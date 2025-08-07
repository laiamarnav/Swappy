// lib/screens/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/main_scaffold.dart';
import '../data/app_state.dart';
import '../models/exchange_request.dart';
import '../models/listing.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      child: AnimatedBuilder(
        animation: AppState.instance,
        builder: (context, _) {
          final recv = AppState.instance.getReceivedRequests();
          final snd  = AppState.instance.getSentRequests();
          final all  = [...recv, ...snd];

          return Column(
            children: [
              // ► AppBar blanco con iconos y texto grises
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.grey,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text(
                  'Notificaciones',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // ► Lista scrollable de notificaciones
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: all.length,
                    itemBuilder: (ctx, i) {
                      final r = all[i];
                      return _NotificationCard(
                        request: r,
                        isReceived: i < recv.length,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final ExchangeRequest request;
  final bool isReceived;

  const _NotificationCard({
    Key? key,
    required this.request,
    required this.isReceived,
  }) : super(key: key);

  Widget _iconBox(IconData icon) {
    return Container(
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.blue, size: 20),
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
          // ► Contenido principal
          Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildRouteInfo(listing, dateStr, timeStr),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: VerticalDivider(
                      color: Colors.grey.withOpacity(0.3),
                      thickness: 1,
                      indent: 8,
                      endIndent: 8,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildFlightInfo(listing),
                  ),
                ],
              ),
            ),
          ),

          const Divider(thickness: 1, height: 1),

          // ► Botones de acción (solo en recibidas y pending)
          if (isReceived && request.status == ExchangeRequestStatus.pending)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => AppState.instance.respondToRequest(
                      request.id,
                      ExchangeRequestStatus.rejected,
                    ),
                    icon: const Icon(Icons.close, color: Colors.red),
                    label: const Text(
                      'Rechazar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 48),
                  TextButton.icon(
                    onPressed: () => AppState.instance.respondToRequest(
                      request.id,
                      ExchangeRequestStatus.accepted,
                    ),
                    icon: const Icon(Icons.check, color: Colors.green),
                    label: const Text(
                      'Aceptar',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(Listing listing, String date, String time) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(Icons.location_on, 'From', listing.origin, date, time),
        _infoRow(Icons.flight_takeoff, 'To', listing.destination, date, time),
      ],
    );
  }

  Widget _infoRow(
      IconData icon, String label, String place, String date, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _iconBox(icon),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(place, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('$date, $time', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlightInfo(Listing listing) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('avatar.png'),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              Text('Vuelo ${listing.flightNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Asiento ${listing.seat}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
