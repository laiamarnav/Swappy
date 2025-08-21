import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/search_result.dart';

class Seat {
  final String id;
  final String origin;
  final String destination;
  final DateTime dateTime;
  final String? airline;
  final String? flightCode;
  final String seatNumber;
  final String ownerId;
  final String ownerName; // 🔹 nombre del usuario
  final String status;

  Seat({
    required this.id,
    required this.origin,
    required this.destination,
    required this.dateTime,
    required this.seatNumber,
    required this.ownerId,
    required this.ownerName,
    this.airline,
    this.flightCode,
    this.status = 'available',
  });

  factory Seat.fromJson(Map<String, dynamic> json, {String? id}) {
    return Seat(
      id: id ?? '',
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      airline: json['airline'] as String?,
      flightCode: json['flightCode'] as String?,
      seatNumber: json['seatNumber'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String? ?? 'Anónimo',
      status: json['status'] as String? ?? 'available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'origin': origin,
      'destination': destination,
      'dateTime': Timestamp.fromDate(dateTime),
      'airline': airline,
      'flightCode': flightCode,
      'seatNumber': seatNumber,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'status': status,
    };
  }
}

/// 🔹 Para reutilizar con tu SearchResult
extension SeatMapper on Seat {
  SearchResult toSearchResult() {
    return SearchResult(
      from: origin,
      to: destination,
      flightCode: flightCode,
      dateTime: dateTime,
      airline: airline ?? '',
      seat: seatNumber,
    );
  }
}
