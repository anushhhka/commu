import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/screens/main/main_screen.dart';
import 'package:heyoo/services/firebase/login_service.dart';
import 'package:heyoo/widgets/otp_text_field_widget.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';
import 'dart:async';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.verificationId, required this.phoneNumber, this.resendToken});
  final String verificationId;
  final String phoneNumber;
  final int? resendToken;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResendButtonEnabled = false;
  Timer? _timer;
  int _start = 80; // 3 minutes in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _isResendButtonEnabled = false;
    _start = 80;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendButtonEnabled = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resendOTP() {
    if (_isResendButtonEnabled) {
      FirebaseSignInService().resendOTP(widget.phoneNumber);
      Fluttertoast.showToast(
        msg: getTranslated(context, 'otp_resent'),
      );
      startTimer();
    } else {
      Fluttertoast.showToast(
        msg: getTranslated(context, 'try_again_later'),
      );
    }
  }

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
                getTranslated(context, 'enter_otp_text'),
                style: Typo.titleMedium,
              ),
              const SizedBox(height: 20),
              OTPTextFieldWidget(controller: _otpController),
              const SizedBox(height: 20),
              PrimaryElevatedButton(
                buttonText: getTranslated(context, 'verify_button'),
                onPressed: !_isLoading
                    ? () async {
                        setState(() {
                          _isLoading = true;
                        });
                        BaseItemModel response = await FirebaseSignInService().verifyOTP(widget.verificationId, _otpController.text);
                        if (response.success && context.mounted) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
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
              const SizedBox(height: 20),
              TextButton(
                onPressed: _isResendButtonEnabled ? _resendOTP : null,
                child: Text(
                  _isResendButtonEnabled ? getTranslated(context, 'resend_otp') : '${getTranslated(context, 'resend_otp_in')} $_start s',
                  style: TextStyle(
                    color: _isResendButtonEnabled ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
