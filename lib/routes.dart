import 'package:flutter/material.dart';
import 'package:swappy/screens/about_app_screen.dart';
import 'package:swappy/screens/create_listing_screen.dart';
import 'package:swappy/screens/edit_profile_screen.dart';
import 'package:swappy/screens/login_screen.dart';
import 'package:swappy/screens/notifications_screen.dart';
import 'package:swappy/screens/notifications_settings_screen.dart';
import 'package:swappy/screens/onboarding_screen.dart';
import 'package:swappy/screens/published_listings_screen.dart';
import 'package:swappy/screens/register_screen.dart';
import 'package:swappy/screens/report_problem_screen.dart';
import 'package:swappy/presentation/search/search_screen.dart';
import 'package:swappy/screens/splash_screen.dart';
import 'package:swappy/screens/profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (_)             => const SplashScreen(),
  '/onboarding': (_)             => const OnboardingScreen(),
  '/login':   (context) => const LoginScreen(),
  '/register':(context) => const RegisterScreen(),
  '/notifications': (_) => const NotificationsScreen(),
  '/search': (_)        => const SearchScreen(),
  '/profile': (_)       => const ProfileScreen(),
  '/create': (_)        => const CreateListingScreen(),
  '/edit_profile': (_) => const EditProfileScreen(),
  '/notifications_settings': (_) => const NotificationsSettingsScreen(),
  '/report_problem': (_) => const ReportProblemScreen(),
  '/about_app': (_) => const AboutAppScreen(),
  '/published_listings': (_) => const PublishedListingsScreen(),
};