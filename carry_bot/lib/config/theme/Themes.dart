import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Color(0xFF040D12),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  appBarTheme: AppBarTheme(color: Colors.teal),
  primaryColor: Colors.teal,
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.teal),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal, foregroundColor: Colors.white),
);

/// 040D12
/// 183D3D
/// 5C8374
/// 93B1A6
