import 'package:flutter/material.dart';
import 'package:swappy/presentation/about/about_app_screen.dart';
import 'package:swappy/presentation/listing/create_listing_screen.dart';
import 'package:swappy/presentation/profile/edit_profile_screen.dart';
import 'package:swappy/presentation/auth/login_screen.dart';
import 'package:swappy/presentation/notifications/notifications_screen.dart';
import 'package:swappy/presentation/notifications/notifications_settings_screen.dart';
import 'package:swappy/presentation/onboarding/onboarding_screen.dart';
import 'package:swappy/presentation/listing/published_listings_screen.dart';
import 'package:swappy/presentation/auth/register_screen.dart';
import 'package:swappy/presentation/report_problem/report_problem_screen.dart';
import 'package:swappy/presentation/search/search_screen.dart';
import 'package:swappy/presentation/auth/auth_gate.dart';
import 'package:swappy/presentation/profile/profile_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (_)             => const AuthGate(),
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