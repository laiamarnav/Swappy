// lib/application/app_state_controller.dart

import 'package:flutter/foundation.dart';

import '../models/exchange_request.dart';
import '../models/listing.dart';

/// Controller that holds demo listings, exchange requests and the current user.
///
/// It exposes read/write access through getters and setters and notifies
/// listeners whenever the underlying state changes.
class AppStateController extends ChangeNotifier {
  String _currentUserId = 'user_1';
  String get currentUserId => _currentUserId;
  set currentUserId(String id) {
    _currentUserId = id;
    notifyListeners();
  }

  final List<Listing> _listings = [
    Listing(
      id: 'l1',
      userId: 'user_1',
      userAvatarUrl: 'https://i.pravatar.cc/150?img=1',
      origin: 'Barcelona, Spain',
      destination: 'Tivat, Montenegro',
      airline: 'Vueling',
      flightNumber: 'VY3001',
      seat: '13D',
      date: DateTime(2025, 9, 30, 10, 15),
    ),
    Listing(
      id: 'l2',
      userId: 'user_2',
      userAvatarUrl: 'https://i.pravatar.cc/150?img=2',
      origin: 'Berlin, Germany',
      destination: 'Paris, France',
      airline: 'easyJet',
      flightNumber: 'EJ1234',
      seat: '7A',
      date: DateTime(2025, 10, 5, 8, 30),
    ),
    Listing(
      id: 'l3',
      userId: 'user_3',
      userAvatarUrl: 'https://i.pravatar.cc/150?img=3',
      origin: 'New York, USA',
      destination: 'Los Angeles, USA',
      airline: 'Delta',
      flightNumber: 'DL567',
      seat: '21C',
      date: DateTime(2025, 11, 12, 14, 45),
    ),
  ];

  List<Listing> get listings => List.unmodifiable(_listings);

  final List<ExchangeRequest> _requests = [
    ExchangeRequest(
      id: 'r1',
      listingId: 'l1',
      fromUserId: 'user_2',
      toUserId: 'user_1',
      status: ExchangeRequestStatus.pending,
    ),
    ExchangeRequest(
      id: 'r2',
      listingId: 'l1',
      fromUserId: 'user_3',
      toUserId: 'user_1',
      status: ExchangeRequestStatus.pending,
    ),
    ExchangeRequest(
      id: 'r3',
      listingId: 'l2',
      fromUserId: 'user_1',
      toUserId: 'user_2',
      status: ExchangeRequestStatus.pending,
    ),
    ExchangeRequest(
      id: 'r4',
      listingId: 'l3',
      fromUserId: 'user_1',
      toUserId: 'user_3',
      status: ExchangeRequestStatus.pending,
    ),
  ];

  /// Pending requests received by the current user.
  List<ExchangeRequest> getReceivedRequests() {
    return _requests
        .where((r) =>
            r.toUserId == _currentUserId &&
            r.status == ExchangeRequestStatus.pending)
        .toList();
  }

  /// Pending requests sent by the current user.
  List<ExchangeRequest> getSentRequests() {
    return _requests
        .where((r) =>
            r.fromUserId == _currentUserId &&
            r.status == ExchangeRequestStatus.pending)
        .toList();
  }

  List<Listing> getMyListings() =>
      _listings.where((l) => l.userId == _currentUserId).toList();

  Listing getListingById(String id) => _listings.firstWhere(
        (l) => l.id == id,
        orElse: () =>
            throw StateError('Listing con id "$id" no encontrado'),
      );

  void respondToRequest(String requestId, ExchangeRequestStatus newStatus) {
    final req = _requests.firstWhere(
      (r) => r.id == requestId,
      orElse: () =>
          throw StateError('Request con id "$requestId" no encontrado'),
    );
    req.status = newStatus;
    notifyListeners();
  }
}

