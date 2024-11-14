// lib/events_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').orderBy('datetime', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No events available'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final dateTime = (data['datetime'] as Timestamp).toDate();
              return ListTile(
                title: Text(data['title'] ?? 'No Title'),
                subtitle: Text(
                    'Date: ${dateTime.toLocal().toString().split(" ")[0]}\n'
                        'Time: ${TimeOfDay.fromDateTime(dateTime).format(context)}\n'
                        'Content: ${data['content'] ?? 'No Content'}'
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
