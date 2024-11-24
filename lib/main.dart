import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/splashscreen.dart';
import 'theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: AppTheme.lightTheme, // Use the dark theme
      home: SplashScreen(),
      debugShowCheckedModeBanner: false, // Removes the debug banner
    );
  }
}
