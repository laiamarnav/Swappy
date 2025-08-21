import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/dates.dart';

class SearchSummary extends StatelessWidget {
  final String from;
  final String to;
  final String flightCode;
  final DateTime? dateTime;
  final VoidCallback onEdit;

  const SearchSummary({
    super.key,
    required this.from,
    required this.to,
    required this.flightCode,
    required this.dateTime,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.of(context).disableAnimations;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: disable ? 1 : 0, end: 1),
      duration: disable ? Duration.zero : const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 8),
            child: child,
          ),
        );
      },
      child: Container(
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
                      _flatSummaryItem(
                          Icons.calendar_today, Dates.date.format(dateTime!)),
                    if (dateTime != null)
                      _flatSummaryItem(
                          Icons.access_time, Dates.time.format(dateTime!)),
                    _flatSummaryItem(
                        Icons.airline_seat_recline_normal, "Seat: $flightCode"),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit,
                  color: AppColors.primary, size: 20),
              tooltip: "Edit",
            ),
          ],
        ),
      ),
    );
  }

  Widget _flatSummaryItem(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
