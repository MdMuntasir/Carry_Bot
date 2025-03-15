import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  textTheme: TextTheme(),
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(
      color: Color(0xFF183D3D),
    ),
    contentTextStyle: TextStyle(
      color: Color(0xFF040D12)
    ),
  ),

);

/// 040D12
/// 183D3D
/// 5C8374
/// 93B1A6
