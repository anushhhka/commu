import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/auth/login/otp.dart';

class Mobile extends StatefulWidget {
  @override
  _MobileState createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  final TextEditingController _phoneController = TextEditingController();
  var phone = "";
  bool _isValidNumber = false;

  void _checkPhoneNumber(String value) {
    setState(() {
      phone = value;
      _isValidNumber = RegExp(r'^\d{10}$').hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
              colors: [Colors.blue[200]!, Colors.blueAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo image with reduced height
              Image.asset(
                'images/welcome.png', // Path to your logo image
                width: 250,
                height: screenHeight * 0.25,
              ),
              const SizedBox(height: 10),

              const Text(
                'Please enter your mobile number to receive OTP',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  // Country code input field
                  Expanded(
                    flex: 1,
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        labelText: '+91',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Phone number input field
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: _checkPhoneNumber,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter your mobile number',
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // "Continue" button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isValidNumber
                      ? () async {
                    String fullPhoneNumber = '+91$phone';
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: fullPhoneNumber,
                      verificationCompleted: (PhoneAuthCredential credential) {
                        FirebaseAuth.instance.signInWithCredential(credential);
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Verification failed: ${e.message}'),
                          ),
                        );
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTP(verificationId: verificationId),
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        print('Code auto retrieval timeout: $verificationId');
                      },
                    );
                  }
                      : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid 10-digit number'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'By proceeding, you consent to get calls, WhatsApp, or SMS/RCS messages, including by automated means, from EasyMazdoor and its affiliates to the number provided.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
