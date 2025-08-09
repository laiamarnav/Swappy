import '../entities/search_result.dart';

abstract class SearchRepository {
  Future<List<SearchResult>> search({
    required String from,
    required String to,
    required String seat,
    required DateTime dateTime,
  });
}
