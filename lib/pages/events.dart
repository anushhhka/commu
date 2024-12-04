import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to toggle attendance
  Future<void> _toggleAttendance(String eventId, bool isAttending) async {
    try {
      final userId = 'user123'; // Replace with your logged-in user ID
      if (isAttending) {
        await _firestore.collection('events').doc(eventId).update({
          'attendees': FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firestore.collection('events').doc(eventId).update({
          'attendees': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update attendance")),
      );
    }
  }

  // Check if the user is attending
  bool isAttending(List<dynamic> attendees) {
    final userId = 'user123'; // Replace with your logged-in user ID
    return attendees.contains(userId);
  }

  // Function to show advertisement details
  void _showAdDetails(String title, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.pink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Advertisement space below the header
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('advertisementss').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    height: 50,
                    color: Colors.white70,
                    alignment: Alignment.center,
                    child: Text(
                      '--Ad Space--',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  );
                }

                final ad = snapshot.data!.docs[0].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () => _showAdDetails(ad['title'], ad['description']),
                  child: Container(
                    height: 50,
                    color: Colors.white70,
                    alignment: Alignment.center,
                    child: Text(
                      ad['title'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                );
              },
            ),

            // Main content
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('events').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No events available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  final events = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index].data() as Map<String, dynamic>;
                      final eventId = events[index].id;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.pinkAccent.shade200, Colors.pink.shade200],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (event['imageUrl'] != null &&
                                      event['imageUrl'].isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        event['imageUrl'],
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  SizedBox(height: 10),
                                  Text(
                                    event['title'] ?? 'No Title',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    event['description'] ?? 'No Description',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          final attending = isAttending(event['attendees'] ?? []);
                                          _toggleAttendance(eventId, attending);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.yellow,
                                        ),
                                        child: Text(
                                          isAttending(event['attendees'] ?? [])
                                              ? 'Cancel Attendance'
                                              : 'Attend Event',
                                        ),
                                      ),
                                      if (isAttending(event['attendees'] ?? []))
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.yellow,
                                          size: 24.0,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Advertisement space above the footer
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('advertisementss').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    height: 50,
                    color: Colors.white70,
                    alignment: Alignment.center,
                    child: Text(
                      '--Ad Space--',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  );
                }

                final ad = snapshot.data!.docs[0].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () => _showAdDetails(ad['title'], ad['description']),
                  child: Container(
                    height: 50,
                    color: Colors.white70,
                    alignment: Alignment.center,
                    child: Text(
                      ad['title'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
