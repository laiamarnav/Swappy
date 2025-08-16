// lib/screens/published_listings_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/app_state.dart';
import '../../models/listing.dart';

class PublishedListingsScreen extends StatelessWidget {
  const PublishedListingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        date: DateTime.now().add(Duration(days: 3, hours: 5)),
      ),
      Listing(
        id: 'demo2',
        userId: AppState.instance.currentUserId,
        userAvatarUrl: 'assets/avatar.png',
        origin: 'Valencia, Spain',
        destination: 'London, UK',
        airline: 'Ryanair',
        flightNumber: 'RY5678',
        seat: '22B',
        date: DateTime.now().add(Duration(days: 4, hours: 2)),
      ),
      Listing(
        id: 'demo3',
        userId: AppState.instance.currentUserId,
        userAvatarUrl: 'assets/avatar.png',
        origin: 'Seville, Spain',
        destination: 'Lisbon, Portugal',
        airline: 'TAP',
        flightNumber: 'TP1234',
        seat: '15C',
        date: DateTime.now().add(Duration(days: 5, hours: 3)),
      ),
      Listing(
        id: 'demo4',
        userId: AppState.instance.currentUserId,
        userAvatarUrl: 'https://i.pravatar.cc/150?img=47',
        origin: 'Barcelona, Spain',
        destination: 'Rome, Italy',
        airline: 'Vueling',
        flightNumber: 'VY1234',
        seat: '7C',
        date: DateTime.now().add(Duration(days: 10, hours: 2)),
      ),
      Listing(
        id: 'demo5',
        userId: AppState.instance.currentUserId,
        userAvatarUrl: 'assets/avatar.png',
        origin: 'Berlin, Germany',
        destination: 'Amsterdam, Netherlands',
        airline: 'KLM',
        flightNumber: 'KL4567',
        seat: '8B',
        date: DateTime.now().add(Duration(days: 5, hours: 4)),
      ),
      Listing(
        id: 'demo6',
        userId: AppState.instance.currentUserId,
        userAvatarUrl: 'assets/avatar.png',
        origin: 'Lisbon, Portugal',
        destination: 'Madrid, Spain',
        airline: 'Iberia',
        flightNumber: 'IB8765',
        seat: '19D',
        date: DateTime.now().add(Duration(days: 6, hours: 1)),
      ),
    ];

    final listings = [...realListings, ...demoListings];

    print('⏳ Total listings to show: ${listings.length}');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Mis anuncios publicados', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: listings.length,
        itemBuilder: (ctx, i) {
          final l = listings[i];
          final dateStr = DateFormat('dd MMM yyyy').format(l.date);
          final timeStr = DateFormat('HH:mm').format(l.date);
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.flight, color: Colors.blue),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${l.origin} → ${l.destination}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('$dateStr, $timeStr',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 8),
                      Text('Vuelo ${l.flightNumber}, asiento ${l.seat}',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
