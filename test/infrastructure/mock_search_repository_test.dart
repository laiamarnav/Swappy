import 'package:flutter_test/flutter_test.dart';
import 'package:swappy/infrastructure/repositories/mock_search_repository.dart';

void main() {
  test('filters results by params', () async {
    final repo = MockSearchRepository();
    final match = await repo.search(
      from: 'Barcelona',
      to: 'Paris',
      seat: '12A',
      dateTime: DateTime(2025, 11, 30),
    );
    expect(match, hasLength(1));

    final noMatch = await repo.search(
      from: 'Madrid',
      to: 'Paris',
      seat: '12A',
      dateTime: DateTime(2025, 11, 30),
    );
    expect(noMatch, isEmpty);
  });
}
