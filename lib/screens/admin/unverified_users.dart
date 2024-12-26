import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/models/niyani_model.dart';
import 'package:heyoo/models/village_member_model.dart';
import 'package:heyoo/screens/profile/individual_profile_screen.dart';
import 'package:heyoo/services/firebase/admin_actions.dart';

class UnverifiedUsers extends StatefulWidget {
  const UnverifiedUsers({super.key});

  @override
  UnverifiedUsersState createState() => UnverifiedUsersState();
}

class UnverifiedUsersState extends State<UnverifiedUsers> {
  final AdminService _adminService = AdminService();
  List<DocumentSnapshot> _users = [];
  List<DocumentSnapshot> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUnverifiedUsers();
    _searchController.addListener(_filterUsers);
  }

  Future<void> _fetchUnverifiedUsers() async {
    QuerySnapshot querySnapshot = await _adminService.getUnverifiedUsers();
    setState(() {
      _users = querySnapshot.docs;
      _filteredUsers = _users;
    });
  }

  void _filterUsers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users.where((user) {
        var userData = user.data() as Map<String, dynamic>;
        String fullName = '';
        if (userData.containsKey('firstNameOfTheMember') && userData.containsKey('surname')) {
          fullName = "${user['firstNameOfTheMember']} ${user['surname'] ?? ''}".toLowerCase();
        } else if (userData.containsKey('firstNameOfTheMember')) {
          fullName = user['firstNameOfTheMember'].toString().toLowerCase();
        } else if (userData.containsKey('fullNameOfTheMarriedDaughter')) {
          fullName = user['fullNameOfTheMarriedDaughter'].toString().toLowerCase();
        }
        String phoneNumber = userData.containsKey('mobileOrWhatsappNumber') ? userData['mobileOrWhatsappNumber'].toString() : '';
        return fullName.contains(query) || phoneNumber.contains(query);
      }).toList();
    });
  }

  Future<void> _verifyUser(String userId, bool isNiyani) async {
    await _adminService.verifyUser(userId, isNiyani);
    _fetchUnverifiedUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by name or phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                DocumentSnapshot user = _filteredUsers[index];
                // Check for the existence of fields and show the name accordingly
                String fullName = '';
                var userData = user.data() as Map<String, dynamic>;
                if (userData.containsKey('firstNameOfTheMember') && userData.containsKey('surname')) {
                  fullName = "${user['firstNameOfTheMember']} ${user['surname'] ?? ''}".toLowerCase();
                } else if (userData.containsKey('firstNameOfTheMember')) {
                  fullName = user['firstNameOfTheMember'].toString().toLowerCase();
                } else if (userData.containsKey('fullNameOfTheMarriedDaughter')) {
                  fullName = user['fullNameOfTheMarriedDaughter'].toString().toLowerCase();
                }

                return ListTile(
                  onTap: () {
                    dynamic userProfile;
                    if (userData.containsKey('firstNameOfTheMember')) {
                      userProfile = VillageMemberModel.fromJson(userData);
                    } else if (userData.containsKey('fullNameOfTheMarriedDaughter')) {
                      userProfile = NiyaniModel.fromJson(userData);
                    }

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => IndividualProfileScreen(
                        userProfile: userProfile,
                        phoneNumber: user['mobileOrWhatsappNumber'].toString(),
                      ),
                    ));
                  },
                  title: Text(
                    fullName,
                    style: Typo.titleLarge,
                  ),
                  subtitle: Text(
                    user['mobileOrWhatsappNumber'].toString(),
                    style: Typo.titleMedium,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      bool isNiyani = userData.containsKey('fullNameOfTheMarriedDaughter');
                      _verifyUser(user['mobileOrWhatsappNumber'].toString(), isNiyani);
                    },
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
