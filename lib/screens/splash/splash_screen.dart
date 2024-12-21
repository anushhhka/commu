import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/screens/main/main_screen.dart';
import 'package:heyoo/screens/select_language.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _animateLogo();
    _navigateToNextScreen();
  }

  _animateLogo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _visible = true;
    });
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Show splash screen for 3 seconds

    // Show full-screen image for 10 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FullScreenImageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(seconds: 2),
          child: Image.asset(
            "assets/images/png/logo.png",
            width: size.width * 0.6,
            height: size.height * 0.4,
          ),
        ),
      ),
    );
  }
}

class FullScreenImageScreen extends StatefulWidget {
  const FullScreenImageScreen({super.key});

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  StreamSubscription<User?>? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 5)); // Show full-screen image for 10 seconds

    // Navigate to the next screen based on authentication state
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        // User is not signed in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectLanguage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel(); // Cancel the listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              "assets/images/advertisement.jpg",
              fit: BoxFit.fill,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
