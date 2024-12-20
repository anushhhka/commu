import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Function to open WhatsApp with a specific number
  _openWhatsApp(String contactNumber) async {
    var contact = contactNumber;
    var androidUrl = "whatsapp://send?phone=$contact";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      Fluttertoast.showToast(msg: "WhatsApp not installed on your device");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications') // Firestore collection name
            .orderBy('timestamp', descending: true) // Latest at the top
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications yet!"));
          }

          // List of notifications
          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index].data() as Map<String, dynamic>;
              String message = notification['message'] ?? 'No message';
              String mobileNumber = notification['mobileOrWhatsapp'].toString();
              Timestamp timestamp = notification['timestamp'] as Timestamp;
              String formattedDate = DateFormat('dd/MM/yyyy').format(timestamp.toDate());

              return ListTile(
                leading: GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse("tel:$mobileNumber"));
                  },
                  child: const Icon(Icons.call),
                ),
                title: Text(message),
                subtitle: Text(formattedDate),
                trailing: GestureDetector(
                  onTap: () {
                    _openWhatsApp(mobileNumber);
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.green,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
