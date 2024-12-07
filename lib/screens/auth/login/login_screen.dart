import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/screens/auth/login/otp_screen.dart';
import 'package:heyoo/screens/auth/login/signup_screen.dart';
import 'package:heyoo/services/firebase/login_service.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/png/logo.png'),
              ),
              SizedBox(height: size.height * 0.03),
              const Text(
                'Welcome Back!',
                style: Typo.headlineMedium,
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: '+91',
                        counterText:
                            ' ', // For Aligning the TextFormField with the second TextFormField
                        labelStyle: Typo.bodyLarge.copyWith(
                          color: AppColors.slightlyDarkGray,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                  SizedBox(width: size.height * 0.01),
                  Expanded(
                    flex: 4,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        maxLength: 10,
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value.length != 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your phone number',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              PrimaryElevatedButton(
                buttonText: 'Send OTP',
                onPressed: !_isLoading
                    ? () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() {
                          _isLoading = true; // Show loading indicator
                        });
                        String phoneNumber = _phoneNumberController.text.trim();
                        BaseItemModel response = await FirebaseSignInService()
                            .sendVerificationCode(phoneNumber);
                        if (response.success && context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OTPScreen(
                                verificationId: response.data as String,
                              ),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(msg: response.error ?? '');
                        }
                        setState(() {
                          _isLoading = false; // Hide loading indicator
                        });
                      }
                    : null,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : null,
              ),
              SizedBox(height: size.height * 0.04),
              PrimaryElevatedButton(
                buttonText: 'Create New Account',
                buttonBackgroundColor: Colors.transparent,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
