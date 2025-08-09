import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchSummary extends StatelessWidget {
  final String from;
  final String to;
  final String seat;
  final DateTime? dateTime;
  final VoidCallback onEdit;

  const SearchSummary({
    super.key,
    required this.from,
    required this.to,
    required this.seat,
    required this.dateTime,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _flatSummaryItem(Icons.location_on, "From: $from"),
                  _flatSummaryItem(Icons.flight_takeoff, "To: $to"),
                  if (dateTime != null)
                    _flatSummaryItem(Icons.calendar_today,
                        DateFormat('dd/MM/yyyy').format(dateTime!)),
                  if (dateTime != null)
                    _flatSummaryItem(Icons.access_time,
                        DateFormat('HH:mm').format(dateTime!)),
                  _flatSummaryItem(Icons.airline_seat_recline_normal, "Seat: $seat"),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit,
                color: Color.fromARGB(255, 130, 199, 255), size: 20),
            tooltip: "Edit",
          ),
        ],
      ),
    );
  }

  Widget _flatSummaryItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
