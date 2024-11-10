import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    hintColor: Colors.blueAccent,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(),
      buttonColor: Colors.blue, // Button color
      textTheme: ButtonTextTheme.primary,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.blue,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );
}
