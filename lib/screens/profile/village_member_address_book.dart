import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/models/village_member_model.dart';
import 'package:heyoo/screens/profile/village_member_individual_profile_screen.dart';
import 'package:heyoo/services/firebase/profile_service.dart';

class VillageMemberAddressBook extends StatelessWidget {
  const VillageMemberAddressBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Village Member Address Book'),
      ),
      body: FutureBuilder(
        future: FirebaseProfileService().fetchVillageMemberUsersDocument(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("An error occurred"),
            );
          }

          final List<VillageMemberModel> users = snapshot.data as List<VillageMemberModel>;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: Container(
                  width: 60,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: user.imagePath != null
                      ? Image.network(
                          user.imagePath!,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person);
                          },
                        )
                      : const Icon(Icons.person),
                ),
                title: Text(
                  "${user.firstNameOfTheMember}  ${user.surname}",
                  style: Typo.titleLarge,
                ),
                subtitle: Text(
                  user.mobileOrWhatsappNumber.toString(),
                  style: Typo.titleLarge,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VillageMemberIndividualProfileScreen(
                        userProfile: user,
                        phoneNumber: user.mobileOrWhatsappNumber.toString(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
