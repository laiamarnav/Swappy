// lib/screens/notifications_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/main_scaffold.dart';
import '../data/app_state.dart';
import '../models/exchange_request.dart';
import '../models/listing.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final received = AppState.instance.getReceivedRequests();
    final sent     = AppState.instance.getSentRequests();

    return MainScaffold(
      currentIndex: 0,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // ► SLIVER APP BAR CON IMAGEN BLURRITO Y TÍTULO CENTRAL
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: const Text(
                  'Tus Intercambios',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/notifications_header.jpg',
                      fit: BoxFit.cover,
                    ),
                    // blur filter
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(color: Colors.black.withOpacity(0)),
                      ),
                    ),
                    // overlay semitransparente
                    Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),

            // ► CONTENIDO SOBRE FONDO BLANCO CON ESQUINAS SUPERIORES REDONDEADAS
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  children: [
                    // cada tarjeta de notificación
                    for (var r in received)
                      _NotificationCard(request: r, isReceived: true),
                    for (var r in sent)
                      _NotificationCard(request: r, isReceived: false),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // espacio final para FAB/nav
            SliverToBoxAdapter(child: const SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final ExchangeRequest request;
  final bool isReceived;

  const _NotificationCard({
    required this.request,
    required this.isReceived,
  });

  Widget _iconBox(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.blue, size: 20),
    );
  }

  Widget _dashedDivider(double height) {
    final dashHeight = 4.0;
    final dashCount = (height / (dashHeight * 2)).floor();
    return SizedBox(
      width: 1,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          dashCount,
          (_) => SizedBox(
            width: 1,
            height: dashHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listing = AppState.instance.getListingById(request.listingId);
    final dateStr = DateFormat('dd MMM yyyy').format(listing.date);
    final timeStr = DateFormat('HH:mm').format(listing.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ► CONTENIDO PRINCIPAL
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // columna izq: From / To
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        _iconBox(Icons.location_on),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('From', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text(listing.origin, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('$dateStr, $timeStr', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Row(children: [
                        _iconBox(Icons.flight_takeoff),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('To', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text(listing.destination, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('$dateStr, $timeStr', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ]),
                    ],
                  ),
                ),

                // divisor punteado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _dashedDivider(100),
                ),

                // columna der: avatar + vuelo/asiento
                Expanded(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(listing.userAvatarUrl),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(height: 12),
                      Text('Vuelo ${listing.flightNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Asiento ${listing.seat}', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(thickness: 1, height: 1),

          // ► BOTONES CENTRADOS
          if (isReceived && request.status == ExchangeRequestStatus.pending)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => AppState.instance.respondToRequest(request.id, ExchangeRequestStatus.rejected),
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text('Rechazar', style: TextStyle(color: Colors.red)),
                  ),
                  const SizedBox(width: 48),
                  TextButton.icon(
                    onPressed: () => AppState.instance.respondToRequest(request.id, ExchangeRequestStatus.accepted),
                    icon: const Icon(Icons.check, color: Colors.green),
                    label: const Text('Aceptar', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
