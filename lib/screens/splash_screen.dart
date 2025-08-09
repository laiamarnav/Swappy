// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../constants/app_keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideNext();
  }

  Future<void> _decideNext() async {
    await Future.delayed(const Duration(milliseconds: 900));
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(AppKeys.authUserId);

    if (userId != null) {
      Navigator.pushReplacementNamed(context, '/search');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image(image: AssetImage('assets/logo.png'), height: 64),
      ),
    );
  }
}
