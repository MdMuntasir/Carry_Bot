import 'package:carry_bot/config/theme/Themes.dart';
import 'package:carry_bot/features/device/presentation/pages/device_page.dart';
import 'package:flutter/material.dart';

import 'features/home/presentation/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: darkTheme,
      home: const HomePage(),
    );
  }
}
