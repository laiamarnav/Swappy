// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/main_scaffold.dart';
import '../widgets/search_form.dart';
import '../widgets/search_summary.dart';
import '../widgets/destination_carousel.dart';
import '../widgets/search_results_list.dart';
import '../widgets/seat_request_dialog.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final seatController = TextEditingController();
  DateTime? selectedDateTime;
  bool _hasSearched = false;

  final List<Map<String, String>> searchResults = [
    {'airline': 'Air France','from': 'Barcelona','to': 'Paris','seat': '12A','date': '2025-11-30','time': '10:15'},
    {'airline': 'Vueling','from': 'Barcelona','to': 'Rome','seat': '9C','date': '2025-11-30','time': '12:20'},
    {'airline': 'KLM','from': 'Berlin','to': 'Amsterdam','seat': '8B','date': '2025-12-01','time': '09:45'},
  ];

  void _navigateCreate() {
    Navigator.pushNamed(context, '/create').then((_) => setState(() {}));
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (time == null) return;
    setState(() {
      selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
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
            // ► AppBar blanco con texto gris
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Swappy',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // ► Título grande en azul
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: const Text(
                "Where's your\nnext destination",
                style: TextStyle(
                  color: Color.fromARGB(255, 79, 170, 255),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
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
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    if (!_hasSearched)
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
                    if (!_hasSearched)
                      DestinationCarousel(screenWidth: MediaQuery.of(context).size.width)
                    else ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Search results",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 120, 120, 121),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SearchResultsList(
                        results: searchResults,
                        onRequestSeat: (result) =>
                            showSeatRequestDialog(context, result),
                      ),
                    ],
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
