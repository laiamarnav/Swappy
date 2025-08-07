// lib/data/app_state.dart

import '../models/listing.dart';
import '../models/exchange_request.dart';

class AppState {
  // Singleton boilerplate
  AppState._privateConstructor();
  static final AppState instance = AppState._privateConstructor();

  // El usuario actual (puedes cambiarlo desde ProfileScreen)
  String currentUserId = 'user_1';

  // Lista de todos los anuncios (listings)
  final List<Listing> listings = [
    // Ejemplo:
    Listing(
      id: 'l1',
      userId: 'user_2',
      userAvatarUrl: 'https://i.pravatar.cc/150?img=3',
      origin: 'Barcelona, Spain',
      destination: 'Tivat, Montenegro',
      airline: 'Vueling',
      flightNumber: 'VY3001',
      seat: '13D',
      date: DateTime(2025, 9, 30, 10, 15),
    ),
  ];

  // Lista interna de intercambios/peticiones
  final List<ExchangeRequest> _requests = [
    // Ejemplo:
    ExchangeRequest(
      id: 'r1',
      listingId: 'l1',
      fromUserId: 'user_2',
      toUserId: 'user_1',
      status: ExchangeRequestStatus.pending,
    ),
  ];

  /// Devuelve las peticiones recibidas para el usuario actual
  List<ExchangeRequest> getReceivedRequests() {
    return _requests
        .where((r) => r.toUserId == currentUserId)
        .toList();
  }

  /// Devuelve las peticiones enviadas por el usuario actual
  List<ExchangeRequest> getSentRequests() {
    return _requests
        .where((r) => r.fromUserId == currentUserId)
        .toList();
  }

  /// Devuelve los listings publicados por el usuario actual
  List<Listing> getMyListings() {
    return listings
        .where((l) => l.userId == currentUserId)
        .toList();
  }

  /// Busca y devuelve un Listing por su [id].
  /// Lanza un error si no se encuentra.
  Listing getListingById(String id) {
    return listings.firstWhere(
      (l) => l.id == id,
      orElse: () => throw StateError('Listing con id "$id" no encontrado'),
    );
  }

  /// Cambia el estado de una petición (aceptada o rechazada)
  void respondToRequest(String requestId, ExchangeRequestStatus newStatus) {
    final req = _requests.firstWhere(
      (r) => r.id == requestId,
      orElse: () => throw StateError('Request con id "$requestId" no encontrado'),
    );
    req.status = newStatus;
  }
}
