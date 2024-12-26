import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/screens/admin/admin_screen.dart';
import 'package:heyoo/screens/admin/unverified_users.dart';
import 'package:heyoo/services/firebase/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:heyoo/main.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/models/niyani_model.dart';
import 'package:heyoo/screens/auth/login/login_screen.dart';
import 'package:heyoo/screens/contact_screen.dart';
import 'package:heyoo/screens/gallery_screen.dart';
import 'package:heyoo/screens/profile/individual_profile_screen.dart';
import 'package:heyoo/screens/profile/niyani_address_book.dart';
import 'package:heyoo/screens/profile/village_member_address_book.dart';
import 'package:heyoo/services/firebase/profile_service.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<BaseItemModel<dynamic>> _fetchUserProfile() async {
    final FirebaseProfileService profileService = FirebaseProfileService();
    String userId = FirebaseAuth.instance.currentUser!.phoneNumber!;
    if (userId.startsWith('+91')) {
      userId = userId.replaceFirst('+91', '');
    }
    return await profileService.fetchUserProfile(userId);
  }

  Future<String> _getCurrentLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LAGUAGE_CODE) ?? 'en'; // Default to English
  }

  // Method to update the selected language and apply it
  void _changeLanguage(String languageCode) async {
    Locale _locale = await setLocale(languageCode);
    MyApp.setLocale(context, _locale); // Refresh the app with the new locale
  }

  File? _image;
  String? storageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File _image = File(pickedFile.path);
      String userId = FirebaseAuth.instance.currentUser!.phoneNumber!;

      // Remove country code if present
      if (userId.startsWith('+91')) {
        userId = userId.replaceFirst('+91', '');
      }

      try {
        // Upload the image to Firebase Storage
        final storageUrl = await FirebaseStorageService().uploadImage(_image, userId);

        if (storageUrl != null) {
          // Query all `user_details` documents matching the mobile number
          // Query Firestore to find the user document
          final QuerySnapshot userDocs = await FirebaseFirestore.instance
              .collectionGroup('user_details')
              .where(
                'mobileOrWhatsappNumber',
                isEqualTo: int.parse(userId),
              )
              .get();

          if (userDocs.docs.isNotEmpty) {
            // Update the `imagePath` field for the first matching document
            await userDocs.docs.first.reference.update({'imagePath': storageUrl});
            setState(() {}); // Refresh UI
          } else {
            print('User document not found');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User document not found')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> _checkFirstTime(dynamic userProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeProfileScreen') ?? true;

    if (isFirstTime && (userProfile.imagePath == null || userProfile.imagePath.isEmpty || userProfile.imagePath.contains('drive'))) {
      // Show dialog
      _showFirstTimeDialog();

      // Set isFirstTime to false
      prefs.setBool('isFirstTimeProfileScreen', false);
    }
  }

  void _showFirstTimeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            getTranslated(context, 'profile_picture_missing'),
            style: const TextStyle(color: AppColors.white),
          ),
          content: Text(
            getTranslated(context, 'profile_picture_missing_message'),
            style: const TextStyle(color: AppColors.white),
          ),
          actions: [
            PrimaryElevatedButton(
              buttonText: getTranslated(context, 'ok_text'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<BaseItemModel<dynamic>>(
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.success) {
            return Center(
              child: Text('Error: ${snapshot.data?.error ?? 'Unknown error'}'),
            );
          }

          final dynamic userProfile = snapshot.data!.data;

          // Check if it's the first time and the image path is null
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkFirstTime(userProfile);
          });

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, size: 30, color: AppColors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: userProfile.imagePath == null || userProfile.imagePath.contains('drive')
                            ? const Icon(Icons.person, size: 50)
                            : Image.network(
                                userProfile.imagePath,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cloudGray,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.edit,
                              color: AppColors.white,
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  FirebaseAuth.instance.currentUser!.phoneNumber!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userProfile is NiyaniModel ? userProfile.fullNameOfTheMarriedDaughter : userProfile.firstNameOfTheMember,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (userProfile.isAdmin == true) ...[
                  const SizedBox(height: 20),
                  PrimaryElevatedButton(
                    buttonBackgroundColor: AppColors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.zero,
                    buttonBorderColor: AppColors.white,
                    buttonText: getTranslated(context, 'admin'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AdminScreen(),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),
                PrimaryElevatedButton(
                  buttonBackgroundColor: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                  buttonBorderColor: AppColors.white,
                  buttonText: getTranslated(context, 'my_profile'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          IndividualProfileScreen(userProfile: userProfile, phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber!),
                    ));
                  },
                ),
                const SizedBox(height: 20),
                PrimaryElevatedButton(
                  buttonBackgroundColor: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                  buttonBorderColor: AppColors.white,
                  buttonText: getTranslated(context, 'niyani_address_book'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NiyaniAddressBook(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryElevatedButton(
                  buttonBackgroundColor: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                  buttonBorderColor: AppColors.white,
                  buttonText: getTranslated(context, 'village_member_address_book'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const VillageMemberAddressBook(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryElevatedButton(
                  buttonBackgroundColor: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                  buttonBorderColor: AppColors.white,
                  buttonText: getTranslated(context, 'gallery'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GalleryScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryElevatedButton(
                  buttonBackgroundColor: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                  buttonBorderColor: AppColors.white,
                  buttonText: getTranslated(context, 'patrika'),
                  onPressed: () async {
                    final Uri url = Uri.parse('https://www.kutchipatrika.org');

                    try {
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication, // Opens in external browser
                          webViewConfiguration: const WebViewConfiguration(
                            enableJavaScript: true,
                            enableDomStorage: true,
                          ),
                        );
                      } else {
                        throw 'Could not launch $url';
                      }
                    } catch (e) {
                      debugPrint('Error launching URL: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to open $url')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                PrimaryElevatedButton(
                  buttonBackgroundColor: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                  buttonBorderColor: AppColors.white,
                  buttonText: getTranslated(context, 'support'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ContactAddress(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryElevatedButton(
                  buttonBackgroundColor: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                  buttonBorderColor: AppColors.white,
                  buttonText: getTranslated(context, 'change_language'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(getTranslated(context, 'select_language')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: const Text('English'),
                                leading: Radio(
                                  value: 'en',
                                  groupValue: getLocale(),
                                  onChanged: (value) {
                                    _changeLanguage('en');
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('हिंदी'),
                                leading: Radio(
                                  value: 'hi',
                                  groupValue: getLocale(),
                                  onChanged: (value) {
                                    _changeLanguage('hi');
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('ગુજરાતી'),
                                leading: Radio(
                                  value: 'gu',
                                  groupValue: getLocale(),
                                  onChanged: (value) {
                                    _changeLanguage('gu');
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryElevatedButton(
                  buttonText: getTranslated(context, 'logout'),
                  borderRadius: BorderRadius.zero,
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    clearSharedPreferences();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
