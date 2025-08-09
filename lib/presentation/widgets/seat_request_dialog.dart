import 'package:flutter/material.dart';

void showSeatRequestDialog(BuildContext context, Map<String, String> result) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 12),
              const Text(
                "Solicitud enviada",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Has solicitado el asiento correctamente.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              _detailRow(Icons.flight, "Vuelo", result['airline'] ?? 'Desconocido'),
              _detailRow(Icons.location_on, "Origen", result['from'] ?? ''),
              _detailRow(Icons.flag, "Destino", result['to'] ?? ''),
              _detailRow(Icons.event_seat, "Asiento", result['seat'] ?? ''),
              _detailRow(Icons.calendar_today, "Fecha", result['date'] ?? ''),
              _detailRow(Icons.access_time, "Hora", result['time'] ?? ''),
              const SizedBox(height: 20),

              // Foto de usuario y nombre (simulado)
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Juan Pérez", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("ID: USR001", style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Aceptar", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _detailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 12),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    ),
  );
}
