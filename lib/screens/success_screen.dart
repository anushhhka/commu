import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                'Your details have been sent for verification. You will receive a confirmation message soon.',
                textAlign: TextAlign.center,
                style: Typo.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
