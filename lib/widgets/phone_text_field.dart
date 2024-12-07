import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required this.size,
    required GlobalKey<FormState> zerothPageFormKey,
    required TextEditingController phoneNumberController,
  })  : _zerothPageFormKey = zerothPageFormKey,
        _phoneNumberController = phoneNumberController;

  final Size size;
  final GlobalKey<FormState> _zerothPageFormKey;
  final TextEditingController _phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return Row(
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
            key: _zerothPageFormKey,
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
                errorMaxLines: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
