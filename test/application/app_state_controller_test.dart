import 'package:flutter_test/flutter_test.dart';
import 'package:swappy/application/app_state_controller.dart';
import 'package:swappy/models/exchange_request.dart';
import 'package:swappy/infrastructure/di/locator.dart';

void main() {
  late AppStateController appState;

  setUpAll(() {
    setupLocator();
    appState = locator<AppStateController>();
  });

  test('getReceivedRequests returns unique pending requests for current user', () {
    final received = appState.getReceivedRequests();
    final ids = received.map((r) => r.id).toSet();
    expect(ids.length, received.length);
    expect(
      received.every(
        (r) =>
            r.toUserId == appState.currentUserId &&
            r.status == ExchangeRequestStatus.pending,
      ),
      isTrue,
    );
  });

  test('getSentRequests returns unique pending requests from current user', () {
    final sent = appState.getSentRequests();
    final ids = sent.map((r) => r.id).toSet();
    expect(ids.length, sent.length);
    expect(
      sent.every(
        (r) =>
            r.fromUserId == appState.currentUserId &&
            r.status == ExchangeRequestStatus.pending,
      ),
      isTrue,
    );
  });
}
