import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/screens/auth/login/otp_screen.dart';
import 'package:heyoo/screens/auth/login/signup_screen.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                    child: TextFormField(
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              PrimaryElevatedButton(
                  buttonText: 'Send OTP',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OTPScreen(),
                      ),
                    );
                  }),
              SizedBox(height: size.height * 0.04),
              PrimaryElevatedButton(
                buttonText: 'Create New Account',
                buttonBackgroundColor: Colors.transparent,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
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
