import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = "Anushka Singh";
  String email = "anushka@gmail.com";
  String phone = "7666974326";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
        await _firestore.collection('newusers').doc(user.uid).get();

        if (userData.exists) {
          setState(() {
            name = userData['name'];
            email = userData['email'];
            phone = userData['phone'];
            imageUrl = userData['image'];
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundImage: imageUrl.isNotEmpty
                    ? CachedNetworkImageProvider(imageUrl)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 16),
              // User Details
              buildUserInfo("Name", name, Icons.person),
              buildUserInfo("Email", email, Icons.email),
              buildUserInfo("Phone", phone, Icons.phone),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget to Display User Info
  Widget buildUserInfo(String title, String value, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value.isNotEmpty ? value : "Loading..."),
      ),
    );
  }
}
