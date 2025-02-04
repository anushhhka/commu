import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:heyoo/screens/auth/signup/niyani.dart';
import 'package:heyoo/screens/auth/signup/village_member.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTranslated(context, 'welcome_sign_up_as'),
                      style: Typo.headlineSmall),
                  SizedBox(height: size.height * 0.03),
                  PrimaryElevatedButton(
                      buttonText: getTranslated(context, 'village_member'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VillageMember()));
                      }),
                  SizedBox(height: size.height * 0.03),
                  PrimaryElevatedButton(
                    buttonText: getTranslated(context, 'niyani'),
                    buttonBackgroundColor: Colors.transparent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Niyani()));
                    },
                  ),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 16.0),
            //     child: Text(
            //       'By proceeding, you consent to get calls, WhatsApp, or SMS/RCS messages, including by automated means, from Nana Asambia and its affiliates to the number provided.',
            //       textAlign: TextAlign.justify,
            //       style: Typo.bodyLarge,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
