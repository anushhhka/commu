import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/screens/main/main_screen.dart';
import 'package:heyoo/services/firebase/login_service.dart';
import 'package:heyoo/widgets/otp_text_field_widget.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    print(widget.verificationId);
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
              PrimaryElevatedButton(
                buttonText: 'Verify',
                onPressed: !_isLoading
                    ? () async {
                        setState(() {
                          _isLoading = true;
                        });
                        BaseItemModel response = await FirebaseSignInService()
                            .verifyOTP(
                                widget.verificationId, _otpController.text);
                        if (response.success && context.mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()));
                        } else {
                          Fluttertoast.showToast(
                            msg: response.error ?? '',
                          );
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    : null,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
