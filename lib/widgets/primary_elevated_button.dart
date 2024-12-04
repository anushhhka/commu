import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/app_colors.dart';
import 'package:heyoo/config/themes/typograph.dart';

class PrimaryElevatedButton extends StatelessWidget {
  const PrimaryElevatedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.buttonBackgroundColor,
    this.buttonBorderColor,
    this.buttonTextColor,
    this.borderRadius,
    this.height,
    this.padding,
    this.textStyle,
  });
  final String buttonText;
  final void Function()? onPressed;
  final Color? buttonTextColor;
  final Color? buttonBackgroundColor;
  final Color? buttonBorderColor;
  final BorderRadius? borderRadius;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: padding ?? EdgeInsets.zero,
          backgroundColor: buttonBackgroundColor ?? AppColors.primary,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(14),
              side: BorderSide(
                color: buttonBorderColor ?? AppColors.primary,
              )),
        ),
        child: Text(
          buttonText,
          style: textStyle ??
              Typo.titleLarge.copyWith(
                color: buttonTextColor ?? AppColors.white,
              ),
        ),
      ),
    );
  }
}
