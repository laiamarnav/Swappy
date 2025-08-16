import 'package:flutter/material.dart';
import 'app.dart';
import 'infrastructure/di/locator.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'application/app_state_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppStateController(),
      child: const MyApp(),
    ),
  );
}
