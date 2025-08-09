import 'package:flutter/material.dart';
import 'routes.dart';
import 'transitions.dart'; // Added for custom transitions

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swappy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Updated to use our custom slide transition globally
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeTransitionsBuilder(),
            TargetPlatform.iOS: FadeTransitionsBuilder(),
            TargetPlatform.macOS: FadeTransitionsBuilder(),
            TargetPlatform.linux: FadeTransitionsBuilder(),
            TargetPlatform.windows: FadeTransitionsBuilder(),
            TargetPlatform.fuchsia: FadeTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}