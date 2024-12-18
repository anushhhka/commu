import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/models/niyani_model.dart';
import 'package:heyoo/screens/profile/individual_profile_screen.dart';
import 'package:heyoo/services/firebase/profile_service.dart';

class NiyaniAddressBook extends StatefulWidget {
  const NiyaniAddressBook({super.key});

  @override
  State<NiyaniAddressBook> createState() => _NiyaniAddressBookState();
}

class _NiyaniAddressBookState extends State<NiyaniAddressBook> {
  final TextEditingController _searchController = TextEditingController();
  List<NiyaniModel> _users = [];
  List<NiyaniModel> _filteredUsers = [];
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final List<NiyaniModel> users = await FirebaseProfileService().fetchNiyaniUsersDocument();
      setState(() {
        _users = users;
        _filteredUsers = users; // Initialize the filtered list with the full list
      });
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
  }

  void _filterUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredUsers = _users;
      });
      return;
    }

    setState(() {
      _filteredUsers = _users.where((user) {
        final fullName = user.fullNameOfTheMarriedDaughter.toLowerCase();
        final phoneNumber = user.mobileOrWhatsappNumber.toString();
        return fullName.contains(query.toLowerCase()) || phoneNumber.contains(query);
      }).toList();
    });
  }

  void _sortUsers() {
    setState(() {
      _filteredUsers.sort((a, b) {
        final comparison = a.fullNameOfTheMarriedDaughter.compareTo(b.fullNameOfTheMarriedDaughter);
        return _isAscending ? comparison : -comparison;
      });
      _isAscending = !_isAscending; // Toggle sorting order
    });
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
        title: const Text('Niyani Address Book'),
        actions: [
          IconButton(
            icon: Icon(
              _isAscending ? Icons.sort_by_alpha : Icons.sort,
            ),
            onPressed: _sortUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by name or phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(
                    child: Text("No users found"),
                  )
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];

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
                          user.fullNameOfTheMarriedDaughter,
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
                              builder: (context) => IndividualProfileScreen(
                                userProfile: user,
                                phoneNumber: user.mobileOrWhatsappNumber.toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
