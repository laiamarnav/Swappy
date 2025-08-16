import 'package:get_it/get_it.dart';

import '../../domain/repositories/search_repository.dart';
import '../../application/app_state_controller.dart';
import '../../application/search/search_controller.dart';
import '../repositories/mock_search_repository.dart';
import '../auth/auth_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AppStateController>(() => AppStateController());
  locator.registerLazySingleton<SearchRepository>(() => MockSearchRepository());
  locator.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  locator.registerFactory<SearchController>(() => SearchController(locator()));
}
