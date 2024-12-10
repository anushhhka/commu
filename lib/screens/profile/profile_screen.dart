import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/screens/auth/login/login_screen.dart';
import 'package:heyoo/screens/profile/niyani_address_book.dart';
import 'package:heyoo/screens/profile/individual_profile_screen.dart';
import 'package:heyoo/services/firebase/profile_service.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<BaseItemModel<dynamic>> _fetchUserProfile() async {
    final FirebaseProfileService profileService = FirebaseProfileService();
    String userId = FirebaseAuth.instance.currentUser!.phoneNumber!;
    // Remove the +91 country code
    if (userId.startsWith('+91')) {
      userId = userId.replaceFirst('+91', '');
    }
    return await profileService.fetchUserProfile(userId);
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

          return Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon:
                      const Icon(Icons.close, size: 30, color: AppColors.white),
                ),
              ),
              CircleAvatar(
                radius: 50,
                child: userProfile.profileImage != null
                    ? Image.network(userProfile.profileImage!)
                    : const Icon(
                        Icons.person,
                        size: 50,
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
                userProfile.isVillageMember
                    ? '${userProfile.firstName} ${userProfile.surname}'
                    : userProfile.fullNameOfMarriedDaughter,
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
                buttonText: 'My Profile',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => IndividualProfileScreen(
                        userProfile: userProfile,
                        phoneNumber:
                            FirebaseAuth.instance.currentUser!.phoneNumber!),
                  ));
                },
              ),
              const SizedBox(height: 20),
              PrimaryElevatedButton(
                buttonBackgroundColor: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.zero,
                buttonBorderColor: AppColors.white,
                buttonText: 'Niyani Address Book',
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
                buttonText: 'Village Member Address Book',
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
                buttonText: 'Logout',
                borderRadius: BorderRadius.zero,
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
