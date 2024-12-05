import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heyoo/profilepage/contactbook.dart';
import 'package:heyoo/profilepage/generalcontact.dart';
import 'package:heyoo/profilepage/upload%20documents.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = "";
  String email = "";
  String phone = "";
  String imageUrl = "";
  File? selectedFile;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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
            nameController.text = name;
            emailController.text = email;
            phoneController.text = phone;
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> uploadProfilePicture() async {
    try {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (pickedFile != null) {
        setState(() {
          selectedFile = File(pickedFile.path);
          imageUrl = pickedFile.path;
        });

        print("Profile image selected: ${pickedFile.path}");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> updateUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('newusers').doc(user.uid).update({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
        });
        setState(() {
          name = nameController.text;
          email = emailController.text;
          phone = phoneController.text;
        });
        print("User data updated!");
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFD0091), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: uploadProfilePicture,
                          child: CircleAvatar(
                            radius: screenWidth * 0.12,
                            backgroundImage: imageUrl.isNotEmpty
                                ? FileImage(File(imageUrl))
                                : const AssetImage('images/da.png')
                                    as ImageProvider,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              buildEditableField("Name", nameController),
                              buildEditableField("Phone", phoneController),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: updateUserData,
                                child: const Text("Save Changes"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    buildActionButton("Contact Book", Icons.contacts, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ContactBookScreen()), // Navigate to ContactBook
                      );
                      print("Navigate to Contact Book");
                    }),
                    buildActionButton("Upload Forms", Icons.upload_file, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UploadScreen()), // Navigate to UploadScreen
                      );
                      print("Upload Document Clicked");
                    }),
                    buildActionButton("Download Form", Icons.download, () {
                      print("Download Form Clicked");
                    }),
                    buildActionButton("General Contact", Icons.contact_phone,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GeneralContactScreen()), // Navigate to GeneralContact
                      );
                      print("General Contact Clicked");
                    }),
                    buildActionButton("Logout", Icons.logout, () async {
                      try {
                        // Sign out the user
                        await _auth.signOut();
                        print("Logout successful");

                        // Navigate to the login screen after logout
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           WelcomeScreen()), // Replace with your login screen
                        // );
                      } catch (e) {
                        print("Error logging out: $e");
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        width: screenWidth * 0.9,
        height: 50,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionButton(
      String title, IconData icon, VoidCallback onPressed) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 50,
        width: screenWidth * 0.85,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: screenWidth * 0.05,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(icon, color: const Color(0xFF0A0A0A)),
          label: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Color(0xFF000000)),
          ),
        ),
      ),
    );
  }
}
