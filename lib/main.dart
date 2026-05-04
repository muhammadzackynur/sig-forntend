import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'splash_screen.dart';

void main() {
  runApp(const FindUsApp());
}

class FindUsApp extends StatelessWidget {
  const FindUsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindUs UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'San Francisco',
        primaryColor: AppColors.primary,
      ),
      home: const SplashScreen(),
    );
  }
}
