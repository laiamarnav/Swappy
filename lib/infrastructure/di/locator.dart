import 'package:get_it/get_it.dart';

import '../../domain/repositories/search_repository.dart';
import '../../application/app_state_controller.dart';
import '../../application/search/search_controller.dart';
import '../repositories/mock_search_repository.dart';

import '../auth/auth_service.dart';
import '../auth/firebase_auth_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // App state base
  locator.registerLazySingleton<AppStateController>(() => AppStateController());

  // Repos
  locator.registerLazySingleton<SearchRepository>(() => MockSearchRepository());

  // Auth
  if (!locator.isRegistered<AuthService>()) {
    locator.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  }

  // Controllers
  locator.registerFactory<SearchController>(() => SearchController(locator()));
}
