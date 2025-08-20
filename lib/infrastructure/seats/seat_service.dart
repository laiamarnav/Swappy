import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/seats/seat.dart';

class SeatService {
  final _db = FirebaseFirestore.instance;

  /// Publicar un asiento en Firestore
  Future<String> publishSeat(Seat seat) async {
    final docRef = await _db.collection('seats').add(seat.toJson());
    return docRef.id; // devolvemos el ID del asiento por si luego lo necesitas
  }

  /// Obtener todos los asientos (en tiempo real)
  Stream<List<Seat>> getSeats() {
    return _db.collection('seats').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Seat.fromJson(data);
      }).toList();
    });
  }

  /// Buscar asientos por filtros (origen, destino, fecha)
  Stream<List<Seat>> searchSeats({
    required String origin,
    required String destination,
    required DateTime date,
  }) {
    return _db
        .collection('seats')
        .where('origin', isEqualTo: origin)
        .where('destination', isEqualTo: destination)
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(
          DateTime(date.year, date.month, date.day, 0, 0),
        ))
        .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(
          DateTime(date.year, date.month, date.day, 23, 59),
        ))
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Seat.fromJson(data);
      }).toList();
    });
  }

  /// Eliminar un asiento (solo si el userId coincide con el propietario)
  Future<void> deleteSeat(String seatId) async {
    await _db.collection('seats').doc(seatId).delete();
  }

  Future<void> updateSeatStatus(String seatId, String newStatus) async {
    await _db.collection('seats').doc(seatId).update({
      'status': newStatus,
    });
  }
}
