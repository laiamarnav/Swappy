import 'package:cloud_firestore/cloud_firestore.dart';

class Seat {
  final String airline;
  final String flightCode;
  final String origin;
  final String destination;
  final DateTime dateTime;
  final String seatNumber;
  final String userId;

  Seat({
    required this.airline,
    required this.flightCode,
    required this.origin,
    required this.destination,
    required this.dateTime,
    required this.seatNumber,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'airline': airline,
      'flightCode': flightCode,
      'origin': origin,
      'destination': destination,
      'dateTime': Timestamp.fromDate(dateTime), // guardado como Timestamp
      'seatNumber': seatNumber,
      'userId': userId,
      'status': 'available',
      'createdAt': FieldValue.serverTimestamp(), // timestamp del servidor
    };
  }
  
  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      airline: json['airline'] ?? '',
      flightCode: json['flightCode'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      seatNumber: json['seatNumber'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}
