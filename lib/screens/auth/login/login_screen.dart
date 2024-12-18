import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:heyoo/main.dart';
import 'package:heyoo/models/base_item_model.dart';
import 'package:heyoo/screens/auth/login/otp_screen.dart';
import 'package:heyoo/screens/auth/login/signup_screen.dart';
import 'package:heyoo/services/firebase/login_service.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<String> _getCurrentLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LAGUAGE_CODE) ?? 'en'; // Default to English
  }

  // Method to update the selected language and apply it
  void _changeLanguage(String languageCode) async {
    Locale _locale = await setLocale(languageCode);
    MyApp.setLocale(context, _locale); // Refresh the app with the new locale
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Language selection button stays at the top
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 12.0),
                  //   child: SizedBox(
                  //     width: size.width * 0.32,
                  //     child: PrimaryElevatedButton(
                  //       onPressed: () async {
                  //         showDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return AlertDialog(
                  //               title:
                  //                   Text(getTranslated(context, 'select_language')),
                  //               content: Column(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: <Widget>[
                  //                   ListTile(
                  //                     title: const Text('English'),
                  //                     leading: Radio(
                  //                       value: 'en',
                  //                       groupValue: getLocale(),
                  //                       onChanged: (value) {
                  //                         _changeLanguage('en');
                  //                         Navigator.of(context).pop();
                  //                       },
                  //                     ),
                  //                   ),
                  //                   ListTile(
                  //                     title: const Text('हिंदी'),
                  //                     leading: Radio(
                  //                       value: 'hi',
                  //                       groupValue: getLocale(),
                  //                       onChanged: (value) {
                  //                         _changeLanguage('hi');
                  //                         Navigator.of(context).pop();
                  //                       },
                  //                     ),
                  //                   ),
                  //                   ListTile(
                  //                     title: const Text('ગુજરાતી'),
                  //                     leading: Radio(
                  //                       value: 'gu',
                  //                       groupValue: getLocale(),
                  //                       onChanged: (value) {
                  //                         _changeLanguage('gu');
                  //                         Navigator.of(context).pop();
                  //                       },
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             );
                  //           },
                  //         );
                  //       },
                  //       buttonText: getTranslated(context, 'select_language'),
                  //       padding: EdgeInsets.zero,
                  //       height: 30,
                  //       textStyle: Typo.bodyMedium.copyWith(
                  //         color: AppColors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/png/logo.png'),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          getTranslated(context, 'welcome_back'),
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
                                  counterText: ' ', // For Aligning the TextFormField with the second TextFormField
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
                                      return getTranslated(context, 'phone_required');
                                    } else if (value.length != 10) {
                                      return getTranslated(context, 'valid_phone');
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: getTranslated(context, 'enter_phone'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.03),
                        PrimaryElevatedButton(
                          buttonText: getTranslated(context, 'send_otp'),
                          onPressed: !_isLoading
                              ? () async {
                                  if (!_formKey.currentState!.validate()) return;
                                  setState(() {
                                    _isLoading = true; // Show loading indicator
                                  });
                                  String phoneNumber = _phoneNumberController.text.trim();
                                  BaseItemModel response = await FirebaseSignInService().sendVerificationCode(phoneNumber);
                                  if (response.success && context.mounted) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => OTPScreen(
                                          verificationId: response.data as String,
                                          phoneNumber: phoneNumber,
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
                          buttonText: getTranslated(context, 'create_account'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
