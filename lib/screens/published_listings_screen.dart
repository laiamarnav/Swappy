// lib/screens/published_listings_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/app_state.dart';
import '../models/listing.dart';

class PublishedListingsScreen extends StatelessWidget {
  const PublishedListingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtén tus anuncios reales; si no hay, usa demos para mostrar ejemplo
    final realListings = AppState.instance.getMyListings();
    final demoListings = <Listing>[
      Listing(
        id: 'demo1',
        userId: AppState.instance.currentUserId,
        userAvatarUrl: 'assets/avatar.png',
        origin: 'Madrid, Spain',
        destination: 'Paris, France',
        airline: 'Iberia',
        flightNumber: 'IB3421',
        seat: '12A',
        date: DateTime.now().add(const Duration(days: 3, hours: 5)),
      ),
      Listing(
        id: 'demo2',
        userId: AppState.instance.currentUserId,
        userAvatarUrl: 'https://i.pravatar.cc/150?img=47',
        origin: 'Barcelona, Spain',
        destination: 'Rome, Italy',
        airline: 'Vueling',
        flightNumber: 'VY1234',
        seat: '7C',
        date: DateTime.now().add(const Duration(days: 10, hours: 2)),
      ),
      Listing(
        id: 'demo3',
        userId: AppState.instance.currentUserId,
        userAvatarUrl: 'assets/avatar.png',
        origin: 'Berlin, Germany',
        destination: 'Amsterdam, Netherlands',
        airline: 'KLM',
        flightNumber: 'KL4567',
        seat: '8B',
        date: DateTime.now().add(const Duration(days: 5, hours: 4)),
      ),
    ];
    final listings = realListings.isEmpty ? demoListings : realListings;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Mis anuncios publicados',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: listings.length,
          itemBuilder: (ctx, i) {
            final l = listings[i];
            final dateStr = DateFormat('dd MMM yyyy').format(l.date);
            final timeStr = DateFormat('HH:mm').format(l.date);
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.flight, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l.origin} → ${l.destination}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$dateStr, $timeStr',
                          style:
                              TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Vuelo ${l.flightNumber}, asiento ${l.seat}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
