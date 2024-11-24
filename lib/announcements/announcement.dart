import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            AppBar(
              title: Text('Announcements', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.deepPurple,
              elevation: 4.0,
            ),
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
          ],
        ),
      ),
    );
  }
}
