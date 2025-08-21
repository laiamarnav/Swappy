import 'package:flutter/material.dart';

Future<void> showSeatRequestDialog(
  BuildContext context,
  Map<String, dynamic> seatData,
) async {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              const Text(
                "Solicitud enviada",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Has solicitado el asiento correctamente."),
              const SizedBox(height: 20),

              // 🔹 Info de vuelo
              _infoTile(Icons.flight, "Vuelo", seatData['airline'] ?? ''),
              _infoTile(Icons.location_on, "Origen", seatData['from'] ?? ''),
              _infoTile(Icons.flag, "Destino", seatData['to'] ?? ''),
              _infoTile(Icons.event_seat, "Asiento", seatData['seatNumber'] ?? ''),
              _infoTile(Icons.calendar_today, "Fecha", seatData['date'] ?? ''),
              _infoTile(Icons.access_time, "Hora", seatData['time'] ?? ''),

              const SizedBox(height: 16),

              // 🔹 Info del propietario
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seatData['ownerName'] ?? 'Usuario desconocido',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "ID: ${seatData['ownerId'] ?? '---'}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _infoTile(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
