import 'package:flutter/material.dart';
import 'app.dart';
import 'infrastructure/di/locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}
