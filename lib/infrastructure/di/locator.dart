import 'package:get_it/get_it.dart';

import '../../domain/repositories/search_repository.dart';
import '../repositories/mock_search_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<SearchRepository>(() => MockSearchRepository());
}
