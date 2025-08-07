// lib/models/listing.dart

class Listing {
  /// Identificador único del anuncio
  final String id;

  /// Usuario que publica el anuncio
  final String userId;

  /// URL del avatar del usuario que publicó el anuncio
  final String userAvatarUrl;

  /// Ciudad/origen del vuelo (p.ej. "Barcelona, Spain")
  final String origin;

  /// Ciudad/destino del vuelo (p.ej. "Tivat, Montenegro")
  final String destination;

  /// Compañía aérea
  final String airline;

  /// Número de vuelo
  final String flightNumber;

  /// Asiento que ofreces
  final String seat;

  /// Fecha y hora del vuelo
  final DateTime date;

  Listing({
    required this.id,
    required this.userId,
    required this.userAvatarUrl,
    required this.origin,
    required this.destination,
    required this.airline,
    required this.flightNumber,
    required this.seat,
    required this.date,
  });
}
