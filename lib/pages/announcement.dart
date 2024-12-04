import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/profilepage/contactbook.dart';
import 'package:heyoo/profilepage/download.dart';
import 'package:heyoo/profilepage/generalcontact.dart';
import 'package:heyoo/profilepage/upload%20documents.dart';
import 'package:intl/intl.dart';

class AnnouncementsScreen extends StatelessWidget {
  // Function to like an announcement
  Future<void> likeAnnouncement(String announcementId, String userId) async {
    final likesRef = FirebaseFirestore.instance
        .collection('announcements')
        .doc(announcementId)
        .collection('likes')
        .doc(userId);

    final snapshot = await likesRef.get();

    if (!snapshot.exists) {
      await likesRef.set({
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Announcement liked!');
    } else {
      print('User already liked this announcement.');
    }
  }

  // Function to add a comment
  Future<void> addComment(BuildContext context, String announcementId, String userId) async {
    final TextEditingController commentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(hintText: 'Enter your comment here'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final commentText = commentController.text.trim();
              if (commentText.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('announcements')
                    .doc(announcementId)
                    .collection('comments')
                    .add({
                  'userId': userId,
                  'commentText': commentText,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                print('Comment added!');
              }
              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  // Function to navigate to the Advertisement Details Screen
  void navigateToAdvertisement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdvertisementDetailsScreen()),
    );
  }

  // Function to fetch advertisements from Firestore
  Stream<QuerySnapshot> fetchAdvertisements() {
    return FirebaseFirestore.instance.collection('advertisements').snapshots();
  }

  // Function to navigate to different screens from the hamburger menu
  void navigateToScreen(BuildContext context, String screenName) {
    switch (screenName) {
      case 'Contact Book':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ContactBookScreen()));
        break;
      case 'General Contact':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GeneralContactScreen()));
        break;
      case 'Upload Form':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UploadScreen()));
        break;
      case 'Download Form':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DownloadScreen()));
        break;
      case 'Logout':
      // Handle logout here
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 4.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header with a circular image and title
            DrawerHeader(
              child: Column(
                children: [
                  // Circular image for the drawer
                  CircleAvatar(
                    radius: 50, // Radius of the circle
                    backgroundImage: AssetImage('images/NA.jpg'), // Your image asset
                  ),
                  SizedBox(height: 10), // Space between image and title

                ],
              ),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
            ),

            // List of menu items with icons and dividers between each item
            ListTile(
              leading: Icon(Icons.contacts),
              iconColor: Colors.purple,// Icon for Contact Book
              title: Text('Contact Book'),
              onTap: () => navigateToScreen(context, 'Contact Book'),
            ),
             // Line separator
            ListTile(
              leading: Icon(Icons.phone),
              iconColor: Colors.purple,// Icon for General Contact
              title: Text('General Contact'),
              onTap: () => navigateToScreen(context, 'General Contact'),
            ),
             // Line separator
            ListTile(
              leading: Icon(Icons.upload_file),
              iconColor: Colors.purple,// Icon for Upload Form
              title: Text('Upload Form'),
              onTap: () => navigateToScreen(context, 'Upload Form'),
            ),
             // Line separator
            ListTile(
              leading: Icon(Icons.download),
              iconColor: Colors.purple,// Icon for Download Form
              title: Text('Download Form'),
              onTap: () => navigateToScreen(context, 'Download Form'),
            ),
             // Line separator
            ListTile(
              leading: Icon(Icons.logout),
              iconColor: Colors.purple,
              title: Text('Logout'),
              onTap: () => navigateToScreen(context, 'Logout'),
            )
          ],
        ),
      ),


      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.blueGrey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Floating Advertisement space above the announcements
            StreamBuilder<QuerySnapshot>(
              stream: fetchAdvertisements(),
              builder: (context, adSnapshot) {
                if (adSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!adSnapshot.hasData || adSnapshot.data!.docs.isEmpty) {
                  return SizedBox.shrink();
                }

                final advertisement = adSnapshot.data!.docs.first; // Fetch the first advertisement

                final adTitle = advertisement['title'];
                final adDescription = advertisement['description'];

                return GestureDetector(
                  onTap: () => navigateToAdvertisement(context),
                  child: Container(
                    height: 50, // Adjust height as needed
                    color: Colors.white70, // Advertisement background color
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          adTitle,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          adDescription,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Main content section for announcements
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('announcements')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No announcements available.', style: TextStyle(fontSize: 18)));
                  }

                  final announcements = snapshot.data!.docs;

                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final announcement = announcements[index];
                      final description = announcement['description'];
                      final imageUrl = announcement['imageUrl'];
                      final timestamp = DateTime.parse(announcement['timestamp']);
                      final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(timestamp);
                      final announcementId = announcement.id;

                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('announcements')
                            .doc(announcementId)
                            .collection('likes')
                            .get(),
                        builder: (context, likesSnapshot) {
                          final likesCount = likesSnapshot.data?.docs.length ?? 0;

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (imageUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover),
                                    ),
                                  SizedBox(height: 12),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Posted on: $formattedDate',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$likesCount likes',
                                        style: TextStyle(fontSize: 14, color: Colors.black54),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.thumb_up, color: Colors.deepPurple),
                                            onPressed: () {
                                              likeAnnouncement(announcementId, 'user123'); // Replace 'user123' with actual user ID
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.comment, color: Colors.deepPurple),
                                            onPressed: () {
                                              addComment(context, announcementId, 'user123'); // Replace 'user123' with actual user ID
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Floating Advertisement space below the announcements
            StreamBuilder<QuerySnapshot>(
              stream: fetchAdvertisements(),
              builder: (context, adSnapshot) {
                if (adSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!adSnapshot.hasData || adSnapshot.data!.docs.isEmpty) {
                  return SizedBox.shrink();
                }

                final advertisement = adSnapshot.data!.docs.first;

                final adTitle = advertisement['title'];
                final adDescription = advertisement['description'];

                return GestureDetector(
                  onTap: () => navigateToAdvertisement(context),
                  child: Container(
                    height: 50, // Adjust height as needed
                    color: Colors.white70, // Advertisement background color
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          adTitle,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          adDescription,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class AdvertisementDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advertisement Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Advertisement title
            Text(
              'Advertisement Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Advertisement description
            Text(
              'Detailed description of the advertisement goes here. It could include more information about the product, offer, or service being advertised.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            // Advertisement image (if available)
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                'https://via.placeholder.com/400', // Replace with actual image URL
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            // Call to action button or further details
            ElevatedButton(
              onPressed: () {
                // Add action to handle user interaction with the ad
              },
              child: Text('Learn More'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
