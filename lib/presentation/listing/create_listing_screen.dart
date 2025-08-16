// lib/screens/create_listing_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({Key? key}) : super(key: key);

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey             = GlobalKey<FormState>();
  final airlineController    = TextEditingController();
  final flightCodeController = TextEditingController();
  final fromController       = TextEditingController();
  final toController         = TextEditingController();
  final seatController       = TextEditingController();
  DateTime? selectedDateTime;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:   DateTime.now(),
      lastDate:    DateTime(2030),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (time == null) return;
    setState(() {
      selectedDateTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute
      );
    });
  }

  void _submitListing() {
    if (_formKey.currentState!.validate() && selectedDateTime != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asiento publicado exitosamente')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  Widget _iconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.blue),
    );
  }

  Widget _inputTile(String label, IconData icon, TextEditingController c) {
    return Row(
      children: [
        _iconBox(icon),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: c,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _dateTimeTile(
      String label, IconData icon, String value, VoidCallback onTap) {
    return Row(
      children: [
        _iconBox(icon),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: Text(value),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar blanco con iconos y texto grises
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Publicar asiento",
          style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w200),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección: Detalles del vuelo
                  const Text('Detalles del vuelo',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _inputTile('Aerolínea', Icons.flight, airlineController),
                  const SizedBox(height: 12),
                  _inputTile('Código de vuelo', Icons.confirmation_number,
                      flightCodeController),

                  const SizedBox(height: 24),
                  // Sección: Ruta
                  const Text('Ruta',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _inputTile('Origen', Icons.location_on, fromController),
                  const SizedBox(height: 12),
                  _inputTile('Destino', Icons.location_city, toController),

                  const SizedBox(height: 24),
                  // Sección: Horario
                  const Text('Horario',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _dateTimeTile(
                          'Fecha',
                          Icons.calendar_today,
                          selectedDateTime != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(selectedDateTime!)
                              : 'Seleccionar fecha',
                          _pickDateTime,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dateTimeTile(
                          'Hora',
                          Icons.access_time,
                          selectedDateTime != null
                              ? DateFormat('HH:mm')
                                  .format(selectedDateTime!)
                              : '--:--',
                          _pickDateTime,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // Sección: Asiento
                  const Text('Asiento',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _inputTile('Asiento', Icons.event_seat, seatController),

                  const SizedBox(height: 32),
                  // Botón de envío
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitListing,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Publicar asiento',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
