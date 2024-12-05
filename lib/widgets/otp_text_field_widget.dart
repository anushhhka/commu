import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPTextFieldWidget extends StatelessWidget {
  const OTPTextFieldWidget({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      autoDisposeControllers: false,
      appContext: context,
      controller: controller,
      length: 6,
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      textStyle: const TextStyle(color: AppColors.black),
      pinTheme: PinTheme(
        fieldHeight: 50,
        fieldWidth: 50,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(14),
        activeColor: AppColors.grey,
        selectedColor: AppColors.primary,
        inactiveColor: AppColors.grey,
        selectedFillColor: AppColors.grey,
        inactiveFillColor: AppColors.grey,
        activeFillColor: AppColors.grey,
      ),
      onCompleted: (pin) {},
      dialogConfig: DialogConfig(
          dialogTitle: "Paste OTP",
          dialogContent: "Do you want to paste this code"),
      beforeTextPaste: (text) {
        return true;
      },
    );
  }
}
