import '../../domain/seats/seat.dart';
import '../../infrastructure/seats/seat_service.dart';

class SearchSeatController {
  final SeatService _seatService;

  SearchSeatController(this._seatService);

  Stream<List<Seat>> searchSeats({
    required String origin,
    required String destination,
    required DateTime date,
    String? flightCode,
  }) {
    return _seatService.searchSeats(
      origin: origin,
      destination: destination,
      date: date,
      flightCode: flightCode,
    );
  }
}
