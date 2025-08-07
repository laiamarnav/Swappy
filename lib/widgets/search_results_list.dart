import 'package:flutter/material.dart';

class SearchResultsList extends StatelessWidget {
  final List<Map<String, String>> results;
  final Function(Map<String, String>) onRequestSeat;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.onRequestSeat,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 249, 254, 255),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.flight_takeoff, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${result['from']} → ${result['to']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            result['airline'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          result['date'] ?? '',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        Text(
                          result['time'] ?? '--:--',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Seat: ${result['seat']}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => onRequestSeat(result),
                      icon: const Icon(Icons.event_seat, size: 18),
                      label: const Text("Solicitar asiento"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
