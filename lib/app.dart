import 'package:flutter/material.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swappy',
      debugShowCheckedModeBanner: false,  
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}