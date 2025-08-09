// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/main_scaffold.dart';
import '../widgets/search_form.dart';
import '../widgets/search_summary.dart';
import '../widgets/destination_carousel.dart';
import '../widgets/seat_request_dialog.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey       = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController   = TextEditingController();
  final seatController = TextEditingController();
  DateTime? selectedDateTime;
  bool _hasSearched    = false;

  // Aquí defines TUS anuncios; pon 3, 7, 10… tantos como quieras
  final List<Map<String, String>> searchResults = [
    {
      'airline':'Air France',
      'from':'Barcelona',
      'to':'Paris',
      'seat':'12A',
      'date':'2025-11-30',
      'time':'10:15'
    },
    {
      'airline':'Vueling',
      'from':'Barcelona',
      'to':'Rome',
      'seat':'9C',
      'date':'2025-11-30',
      'time':'12:20'
    },
    {
      'airline':'KLM',
      'from':'Berlin',
      'to':'Amsterdam',
      'seat':'8B',
      'date':'2025-12-01',
      'time':'09:45'
    },
        {
      'airline':'Air France',
      'from':'Barcelona',
      'to':'Paris',
      'seat':'12A',
      'date':'2025-11-30',
      'time':'10:15'
    },
    {
      'airline':'Vueling',
      'from':'Barcelona',
      'to':'Rome',
      'seat':'9C',
      'date':'2025-11-30',
      'time':'12:20'
    },
    {
      'airline':'KLM',
      'from':'Berlin',
      'to':'Amsterdam',
      'seat':'8B',
      'date':'2025-12-01',
      'time':'09:45'
    },
  ];

  void _navigateCreate() {
    Navigator.pushNamed(context, '/create').then((_) => setState(() {}));
  }

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
        date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submitSearch() {
    if (_formKey.currentState!.validate() && selectedDateTime != null) {
      setState(() => _hasSearched = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    return MainScaffold(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          heroTag: "search",
          onPressed: _navigateCreate,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Column(
          children: [
            // AppBar blanco sin flecha
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: const Text(
                'Swappy',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Header gráfico solo cuando NO se ha buscado
            if (!_hasSearched)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    color: Colors.white,
                    child: const Text(
                      "Where's your\nnext destination",
                      style: TextStyle(
                        color: Color.fromARGB(255, 79, 170, 255),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: -80,
                    child: SizedBox(
                      width: 300,
                      child: Opacity(
                        opacity: 0.15,
                        child: Image.asset(
                          'assets/plane_header.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Search your next trip",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 94, 94, 94),
                  ),
                ),
              ),
            ),

            if (_hasSearched)
              SearchSummary(
                from: fromController.text,
                to: toController.text,
                seat: seatController.text,
                dateTime: selectedDateTime,
                onEdit: () => setState(() => _hasSearched = false),
              ),

            Expanded(
              child: _hasSearched
                  // RESULTADOS: dinámico según searchResults.length
                  ? SafeArea(
                      top: false,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: bottomPadding,
                        ),
                        itemCount: searchResults.length,
                        itemBuilder: (context, i) {
                          final r = searchResults[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // fila superior: ruta y fecha/hora
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.flight_takeoff,
                                          color: Color.fromARGB(
                                              255, 79, 170, 255),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${r['from']} → ${r['to']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(r['date']!,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text(r['time']!,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(r['airline']!,
                                    style: const TextStyle(color: Colors.grey)),
                                const Divider(height: 20),

                                // pie: asiento + botón
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Seat: ${r['seat']}'),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          showSeatRequestDialog(context, r),
                                      icon: const Icon(Icons.event_seat),
                                      label: const Text('Solicitar asiento'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.blue.withOpacity(0.1),
                                        foregroundColor: Colors.blue,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  // FORMULARIO + CAROUSEL: scroll normal
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          SearchForm(
                            formKey: _formKey,
                            fromController: fromController,
                            toController: toController,
                            seatController: seatController,
                            selectedDateTime: selectedDateTime,
                            onPickDateTime: _pickDateTime,
                            onSubmit: _submitSearch,
                          ),
                          const SizedBox(height: 8),
                          DestinationCarousel(
                              screenWidth: MediaQuery.of(context).size.width),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
