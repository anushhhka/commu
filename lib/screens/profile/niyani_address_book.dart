import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/models/niyani_model.dart';
import 'package:heyoo/screens/profile/individual_profile_screen.dart';
import 'package:heyoo/services/firebase/profile_service.dart';

class NiyaniAddressBook extends StatelessWidget {
  const NiyaniAddressBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Niyani Address Book'),
      ),
      body: FutureBuilder(
        future: FirebaseProfileService().fetchNiyaniUsersDocument(),
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

          final List<NiyaniModel> users = snapshot.data as List<NiyaniModel>;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              print(user.toString());

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
                  child: user.profileImage != null
                      ? Image.network(
                          user.profileImage!,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person);
                          },
                        )
                      : const Icon(Icons.person),
                ),
                title: Text(
                  user.fullNameOfMarriedDaughter,
                  style: Typo.titleLarge,
                ),
                subtitle: Text(
                  user.mobileNumber,
                  style: Typo.titleLarge,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndividualProfileScreen(
                        userProfile: user,
                        phoneNumber: user.mobileNumber,
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
