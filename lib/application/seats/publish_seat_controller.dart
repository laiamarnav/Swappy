import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/seats/seat.dart';
import '../../infrastructure/seats/seat_service.dart';

class PublishSeatController {
  final SeatService _seatService;

  PublishSeatController(this._seatService);

  Future<String?> publishSeat({
    required String airline,
    required String flightCode,
    required String origin,
    required String destination,
    required DateTime dateTime,
    required String seatNumber,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Usuario no autenticado");
    }

    final seat = Seat(
      id: '', // se asignará desde Firestore
      airline: airline,
      flightCode: flightCode,
      origin: origin,
      destination: destination,
      dateTime: dateTime,
      seatNumber: seatNumber,
      ownerId: user.uid,
      ownerName: user.displayName ?? user.email ?? 'Anónimo',
    );

    return await _seatService.publishSeat(seat);
  }
}
