import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heyoo/new.dart';
import 'package:heyoo/splashscreen.dart';
import 'theme.dart';

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
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false, // Removes the debug banner
      home: AuthCheck(), // Auth
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if FirebaseAuth is still initializing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // Show a loading indicator
          );
        }

        // If the user is signed in, navigate to HomeScreen
        if (snapshot.hasData) {
          return BottomNavBarExample(); // Replace with your actual home screen widget
        }

        // If the user is not signed in, navigate to Login Page
        return SplashScreen(); // Replace with your actual login page widget
      },
    );
  }
}
