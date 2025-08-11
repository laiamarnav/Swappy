import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../infrastructure/di/locator.dart';
import '../infrastructure/auth/auth_service.dart';
import '../presentation/search/search_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = locator<AuthService>();
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const SearchScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
