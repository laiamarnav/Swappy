import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/repositories/search_repository.dart';
import '../../application/app_state_controller.dart';
import '../../application/search/search_controller.dart';
import '../repositories/mock_search_repository.dart';
import '../auth/auth_service.dart';
import '../auth/firebase_auth_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AppStateController>(() => AppStateController());
  locator.registerLazySingleton<SearchRepository>(() => MockSearchRepository());
  locator.registerLazySingleton<AuthService>(() =>
      FirebaseAuthService(FirebaseAuth.instance, GoogleSignIn()));
  locator.registerFactory<SearchController>(() => SearchController(locator()));
}
