import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/widgets/otp_text_field_widget.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});

  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the OTP sent to your phone number',
                style: Typo.titleMedium,
              ),
              const SizedBox(height: 20),
              OTPTextFieldWidget(controller: _otpController),
              const SizedBox(height: 20),
              PrimaryElevatedButton(buttonText: 'Verify', onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
