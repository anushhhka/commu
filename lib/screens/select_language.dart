import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:heyoo/main.dart';
import 'package:heyoo/screens/auth/login/login_screen.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  // Method to update the selected language and apply it
  void _changeLanguage(String languageCode) async {
    Locale _locale = await setLocale(languageCode);
    MyApp.setLocale(context, _locale); // Refresh the app with the new locale
  }

  String selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getTranslated(context, 'select_language'),
              style: Typo.titleLarge,
            ),
            const SizedBox(height: 20),
            PrimaryElevatedButton(
                buttonText: 'English',
                buttonBorderColor: selectedLanguage == 'en' ? Colors.white : Colors.black,
                onPressed: () {
                  _changeLanguage('en');
                  selectedLanguage = 'en';
                }),
            const SizedBox(height: 20),
            PrimaryElevatedButton(
                buttonText: 'Hindi',
                buttonBorderColor: selectedLanguage == 'hi' ? Colors.white : Colors.black,
                onPressed: () {
                  _changeLanguage('hi');
                  selectedLanguage = 'hi';
                }),
            const SizedBox(height: 20),
            PrimaryElevatedButton(
                buttonText: 'Gujarati',
                buttonBorderColor: selectedLanguage == 'gu' ? Colors.white : Colors.black,
                onPressed: () {
                  _changeLanguage('gu');
                  selectedLanguage = 'gu';
                }),
            const SizedBox(height: 20),
            PrimaryElevatedButton(
              buttonText: 'Continue',
              buttonBackgroundColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
