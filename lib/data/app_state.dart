// lib/data/app_state.dart

import 'package:flutter/foundation.dart';               // ← añadido
import '../models/listing.dart';
import '../models/exchange_request.dart';

class AppState extends ChangeNotifier {                  // ← ahora extiende ChangeNotifier
  // Singleton boilerplate
  AppState._privateConstructor();
  static final AppState instance = AppState._privateConstructor();

  // El usuario actual
  String currentUserId = 'user_1';

  // Lista de todos los anuncios (listings)
  final List<Listing> listings = [
    // Publicado por el usuario actual
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
    // Publicado por otro usuario
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
    // Un tercer usuario
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

  // Lista interna de intercambios/peticiones
  final List<ExchangeRequest> _requests = [
    // Solicitudes recibidas por el usuario actual
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
    // Solicitudes enviadas por el usuario actual
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

  /// Sólo peticiones **pendientes** recibidas
  List<ExchangeRequest> getReceivedRequests() {
    return _requests
      .where((r) =>
        r.toUserId == currentUserId &&
        r.status == ExchangeRequestStatus.pending
      )
      .toList();
  }

  /// Sólo peticiones **pendientes** enviadas
  List<ExchangeRequest> getSentRequests() {
    return _requests
      .where((r) =>
        r.fromUserId == currentUserId &&
        r.status == ExchangeRequestStatus.pending
      )
      .toList();
  }

  /// Tus otros getters originales
  List<Listing> getMyListings() => listings
      .where((l) => l.userId == currentUserId)
      .toList();

  Listing getListingById(String id) => listings.firstWhere(
      (l) => l.id == id,
      orElse: () => throw StateError('Listing con id "$id" no encontrado'),
  );

  /// Cambia el estado de la petición y notifica
  void respondToRequest(String requestId, ExchangeRequestStatus newStatus) {
    final req = _requests.firstWhere(
      (r) => r.id == requestId,
      orElse: () =>
        throw StateError('Request con id "$requestId" no encontrado'),
    );
    req.status = newStatus;
    notifyListeners();                                // ← añadido
  }
}
