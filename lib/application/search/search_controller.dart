import 'package:flutter/foundation.dart';

import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../core/async_state.dart';

class SearchController extends ChangeNotifier {
  SearchController(this._repository);

  final SearchRepository _repository;

  AsyncState<List<SearchResult>> state = const AsyncState.idle();

  Future<void> search({
    required String from,
    required String to,
    required String seat,
    required DateTime dateTime,
  }) async {
    state = const AsyncState.loading();
    notifyListeners();
    try {
      final results = await _repository.search(
        from: from,
        to: to,
        seat: seat,
        dateTime: dateTime,
      );
      state = AsyncState.success(results);
    } catch (e) {
      state = AsyncState.error(e.toString());
    }
    notifyListeners();
  }
}
