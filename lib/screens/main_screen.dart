import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heyoo/services/firebase/notification_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? mobileToken = "";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Initialize the Firebase Messaging Foreground Service for IOS
    NotificationService().foregroundMessageIOS();
    // Initialize the Firebase Messaging Foreground Service
    NotificationService().firebaseInit(context);
    // Initialize the Firebase Messaging Background & Terminate Service
    NotificationService().setupInteractMessage(context);
    // set fcm mobile token
    setFCMToken();
    // Listen for FCM token refresh
    NotificationService.listenForTokenRefreh();
  }

  setFCMToken() async {
    mobileToken = await NotificationService.getMobileToken();
    if (mobileToken != null) {
      print('Mobile Token: $mobileToken');
      FirebaseFirestore.instance
          .collection('mobile_tokens')
          .doc(mobileToken)
          .set({'token': mobileToken});
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
