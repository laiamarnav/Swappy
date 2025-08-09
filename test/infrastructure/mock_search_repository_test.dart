import 'package:flutter_test/flutter_test.dart';
import 'package:swappy/infrastructure/repositories/mock_search_repository.dart';

void main() {
  test('mock repository returns data', () async {
    final repo = MockSearchRepository();
    final results = await repo.search(
      from: 'a',
      to: 'b',
      seat: '1A',
      dateTime: DateTime(2025),
    );
    expect(results, isNotEmpty);
  });
}
