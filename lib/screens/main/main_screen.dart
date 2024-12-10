import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/screens/announcement_screen.dart';
import 'package:heyoo/screens/feeds_screen.dart';
import 'package:heyoo/screens/gallery_screen.dart';
import 'package:heyoo/screens/profile/profile_screen.dart';
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
      FirebaseFirestore.instance
          .collection('mobile_tokens')
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .set({'token': mobileToken});
    }
  }

  final List<Widget> _widgetOptions = const [
    FeedsScreen(),
    AnnouncementScreen(),
    GalleryScreen(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Announcements'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Gallery'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppColors.white.withOpacity(0.1),
        selectedItemColor: AppColors.primary,
      ),
    );
  }
}
