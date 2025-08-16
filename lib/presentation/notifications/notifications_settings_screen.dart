// lib/screens/notifications_settings_screen.dart

import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsSettingsScreenState createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _exchangeRequests = true;
  bool _newMessages = false;
  bool _flightStatusUpdates = true;
  bool _promotionalOffers = false;
  bool _systemAlerts = true;

  Widget _buildToggle(
    IconData icon,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 16, color: Colors.black)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Configurar notificaciones',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),

          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            children: [
              _buildToggle(
                Icons.sync_alt,
                'Peticiones de intercambio',
                _exchangeRequests,
                (v) => setState(() => _exchangeRequests = v),
              ),
              const Divider(),
              _buildToggle(
                Icons.message,
                'Mensajes nuevos',
                _newMessages,
                (v) => setState(() => _newMessages = v),
              ),
              const Divider(),
              _buildToggle(
                Icons.flight_land,
                'Actualizaciones de vuelo',
                _flightStatusUpdates,
                (v) => setState(() => _flightStatusUpdates = v),
              ),
              const Divider(),
              _buildToggle(
                Icons.local_offer,
                'Ofertas y promociones',
                _promotionalOffers,
                (v) => setState(() => _promotionalOffers = v),
              ),
              const Divider(),
              _buildToggle(
                Icons.notifications_active,
                'Alertas del sistema',
                _systemAlerts,
                (v) => setState(() => _systemAlerts = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
