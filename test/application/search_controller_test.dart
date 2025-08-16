import 'package:flutter_test/flutter_test.dart';
import 'package:swappy/application/search/search_controller.dart';
import 'package:swappy/application/core/async_state.dart';
import 'package:swappy/infrastructure/di/locator.dart';

void main() {
  setUpAll(() {
    setupLocator();
  });

  test('search transitions to success', () async {
    final controller = locator<SearchController>();
    await controller.search(
      from: 'a',
      to: 'b',
      seat: '1A',
      dateTime: DateTime(2025),
    );
    expect(controller.state.status, AsyncStatus.success);
    expect(controller.state.data, isNotEmpty);
  });
}
