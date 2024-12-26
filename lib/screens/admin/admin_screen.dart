import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';
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
            itemCount: 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UnverifiedUsers()));
                    }
                    // else if (index == 1) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ManageUsers()));
                    // } else if (index == 2) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ManageEvents()));
                    // } else if (index == 3) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePosts()));
                    // } else if (index == 4) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ManageCategories()));
                    // } else if (index == 5) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ManageSubCategories()));
                    // } else if (index == 6) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAdvertisements()));
                    // } else if (index == 7) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => ManageFeedbacks()));
                    // }
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
                          const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Unverified Users',
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
            }),
      ),
    );
  }
}
