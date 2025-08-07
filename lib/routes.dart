import 'package:flutter/material.dart';
import 'package:swappy/screens/create_listing_screen.dart';
import 'package:swappy/screens/notifications_screen.dart';
import 'package:swappy/screens/search_screen.dart';
import 'package:swappy/screens/splash_screen.dart';
import 'package:swappy/screens/profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (_)             => const SplashScreen(),
  '/notifications': (_) => const NotificationsScreen(),
  '/search': (_)        => const SearchScreen(),
  '/profile': (_)       => const ProfileScreen(),
  '/create': (_)        => const CreateListingScreen(),
};