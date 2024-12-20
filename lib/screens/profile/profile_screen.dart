import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:heyoo/main.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/models/niyani_model.dart';
import 'package:heyoo/models/village_member_model.dart';
import 'package:heyoo/screens/auth/login/login_screen.dart';
import 'package:heyoo/screens/contact_screen.dart';
import 'package:heyoo/screens/gallery_screen.dart';
import 'package:heyoo/screens/profile/niyani_address_book.dart';
import 'package:heyoo/screens/profile/individual_profile_screen.dart';
import 'package:heyoo/screens/profile/village_member_address_book.dart';
import 'package:heyoo/services/firebase/profile_service.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                CircleAvatar(
                  radius: 50,
                  child: userProfile.imagePath != null ? Image.network(userProfile.imagePath!) : const Icon(Icons.person, size: 50),
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
                  buttonText: getTranslated(context, 'committee'),
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const GalleryScreen(),
                    //   ),
                    // );
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
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
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
