import 'package:flutter/material.dart';

class Typo {
  Typo._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 96.0,
    fontWeight: FontWeight.w300,
    // letterSpacing: -1.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 60.0,
    fontWeight: FontWeight.w300,
    // letterSpacing: -0.5,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.0,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w700, // used
    // letterSpacing: 0.25,
  );

  static TextStyle headlineSmall = const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700, // used
    // letterSpacing: 0.0,
  );

  static TextStyle titleLarger = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700, // used
    // letterSpacing: 0.15,
  );

  static TextStyle titleLarge = const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500, // used
    // letterSpacing: 0.15,
  );

  static TextStyle titleMedium = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // used
    // letterSpacing: 0.15,
  );

  static TextStyle titleSmall = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    // letterSpacing: 0.1,
  );

  static TextStyle bodyLarge = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.5,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.25,
  );

  static TextStyle bodySmall = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    // letterSpacing: 1.25,
  );

  static TextStyle labelSmall = const TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    // letterSpacing: 1.5,
  );
}
