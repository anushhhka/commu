import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialDayScreen extends StatelessWidget {
  const SpecialDayScreen({super.key});

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
        title: Text(getTranslated(context, 'special_days')),
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('user_details') // Fetch from all user_details collections
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No user dates available!"));
          }

          // List of user details
          var userDetails = snapshot.data!.docs;

          // Sort by today's date at the top
          userDetails.sort((a, b) {
            var aData = a.data() as Map<String, dynamic>;
            var bData = b.data() as Map<String, dynamic>;
            Timestamp? aDob = aData['dateOfBirth'] as Timestamp?;
            Timestamp? bDob = bData['dateOfBirth'] as Timestamp?;
            Timestamp? aMarriageDate = aData['marriageDate'] as Timestamp?;
            Timestamp? bMarriageDate = bData['marriageDate'] as Timestamp?;

            DateTime now = DateTime.now();
            bool aIsToday = (aDob != null && aDob.toDate().day == now.day && aDob.toDate().month == now.month) ||
                (aMarriageDate != null && aMarriageDate.toDate().day == now.day && aMarriageDate.toDate().month == now.month);
            bool bIsToday = (bDob != null && bDob.toDate().day == now.day && bDob.toDate().month == now.month) ||
                (bMarriageDate != null && bMarriageDate.toDate().day == now.day && bMarriageDate.toDate().month == now.month);

            if (aIsToday && !bIsToday) return -1;
            if (!aIsToday && bIsToday) return 1;
            return 0;
          });

          return ListView.builder(
            itemCount: userDetails.length,
            itemBuilder: (context, index) {
              var user = userDetails[index].data() as Map<String, dynamic>;
              Timestamp? dobTimestamp = user['dateOfBirth'] as Timestamp?;
              Timestamp? marriageTimestamp = user['marriageDate'] as Timestamp?;
              String dob = dobTimestamp != null ? DateFormat('dd/MM/yyyy').format(dobTimestamp.toDate()) : 'N/A';
              String marriageDate = marriageTimestamp != null ? DateFormat('dd/MM/yyyy').format(marriageTimestamp.toDate()) : 'N/A';

              String? mobileNumber;
              if (user['mobileOrWhatsappNumber'] is int) {
                mobileNumber = user['mobileOrWhatsappNumber'].toString();
              } else if (user['mobileOrWhatsappNumber'] is String) {
                mobileNumber = user['mobileOrWhatsappNumber'];
              }

              String filteredNumber = '';
              if (mobileNumber != null) {
                if (mobileNumber.length == 10) {
                  filteredNumber = '+91$mobileNumber';
                } else {
                  filteredNumber = mobileNumber;
                }
              }

              bool isToday =
                  (dobTimestamp != null && dobTimestamp.toDate().day == DateTime.now().day && dobTimestamp.toDate().month == DateTime.now().month) ||
                      (marriageTimestamp != null &&
                          marriageTimestamp.toDate().day == DateTime.now().day &&
                          marriageTimestamp.toDate().month == DateTime.now().month);

              return Card(
                color: isToday ? Colors.grey[800] : Colors.grey[900],
                child: ListTile(
                  title: Text(
                    'Name: ${user['firstNameOfTheMember'] ?? user['fullNameOfTheMarriedDaughter']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of Birth: $dob',
                        style: TextStyle(
                          color: dobTimestamp != null &&
                                  dobTimestamp.toDate().day == DateTime.now().day &&
                                  dobTimestamp.toDate().month == DateTime.now().month
                              ? Colors.green
                              : Colors.white,
                        ),
                      ),
                      Text(
                        'Marriage Date: $marriageDate',
                        style: TextStyle(
                          color: marriageTimestamp != null &&
                                  marriageTimestamp.toDate().day == DateTime.now().day &&
                                  marriageTimestamp.toDate().month == DateTime.now().month
                              ? Colors.green
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () {
                          launchUrl(Uri.parse("tel:$filteredNumber"));
                        },
                      ),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                          size: 35,
                        ),
                        onPressed: () {
                          _openWhatsApp(filteredNumber);
                        },
                      ),
                    ],
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
