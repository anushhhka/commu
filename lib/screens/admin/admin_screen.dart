import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/screens/admin/create_announcement.dart';
import 'package:heyoo/screens/admin/create_gallery_screen.dart';
import 'package:heyoo/screens/admin/unverified_users.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Center(
        child: GridView.builder(
          itemCount: 3, // Update itemCount to 3
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            String title;
            IconData icon;
            Widget screen;

            switch (index) {
              case 0:
                title = 'Unverified Users';
                icon = Icons.person;
                screen = const UnverifiedUsers();
                break;
              case 1:
                title = 'Announcement';
                icon = Icons.campaign;
                screen = const CreateAnnouncement(); // Replace with actual screen
                break;
              case 2:
                title = 'Gallery';
                icon = Icons.event;
                screen = const CreateGallery(); // Replace with actual screen
                break;
              default:
                title = 'Unknown';
                icon = Icons.error;
                screen = const Placeholder();
                break;
            }

            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
                },
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.blue[100 * (index + 1 % 9)],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 50,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: Typo.bodyLarge.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
