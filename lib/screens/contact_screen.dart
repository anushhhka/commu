import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactAddress extends StatelessWidget {
  const ContactAddress({super.key});

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
          title: Text(getTranslated(context, 'support')),
        ),
        body: Column(
          children: [
            // Container(
            //   margin: const EdgeInsets.all(10),
            //   padding: const EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     color: Colors.grey[200],
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Rajesh Chheda - 9892455166",
            //         style: Typo.titleLarge.copyWith(color: Colors.black),
            //       ),
            //       const SizedBox(height: 20),
            //       Row(
            //         children: [
            //           const SizedBox(width: 10),
            //           GestureDetector(
            //             onTap: () {
            //               // Function to open phone dialer
            //               launchUrl(Uri.parse("tel:+919892455166"));
            //             },
            //             child: const Icon(Icons.phone),
            //           ),
            //           const SizedBox(width: 20),
            //           GestureDetector(
            //             onTap: () {
            //               _openWhatsApp("+919892455166");
            //             },
            //             child: const FaIcon(
            //               FontAwesomeIcons.whatsapp,
            //               color: Colors.green,
            //               size: 35,
            //             ),
            //           ),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hetan Chheda - 9373973789",
                    style: Typo.titleLarge.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      GestureDetector(
                          onTap: () {
                            // Function to open phone dialer
                            launchUrl(Uri.parse("tel:+919373973789"));
                          },
                          child: Icon(Icons.phone)),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          _openWhatsApp("+919373973789");
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                          size: 35,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
