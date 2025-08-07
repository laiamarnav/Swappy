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
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController seatController = TextEditingController();
  DateTime? selectedDateTime;
  bool _hasSearched = false;

  final List<Map<String, String>> searchResults = [
    {
      'airline': 'Air France',
      'from': 'Barcelona',
      'to': 'Paris',
      'seat': '12A',
      'date': '2025-11-30',
      'time': '10:15'
    },
    {
      'airline': 'Vueling',
      'from': 'Barcelona',
      'to': 'Rome',
      'seat': '9C',
      'date': '2025-11-30',
      'time': '12:20'
    },
    // Puedes añadir más si deseas...
  ];

  void _navigateCreate() {
    Navigator.pushNamed(context, '/create').then((_) => setState(() {}));
  }

  void _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2025, 11, 30),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 12, minute: 35),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitSearch() {
    if (_formKey.currentState!.validate() && selectedDateTime != null) {
      setState(() {
        _hasSearched = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            // 🔵 HEADER AZUL CON TÍTULO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5078F2), Color(0xFF80A7FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.airplanemode_active, color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Where's your\nnext destination",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 30, 24, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Search your next trip",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 94, 94, 94),
                  ),
                ),
              ),
            ),
            // 🔵 SEARCH SUMMARY SI YA BUSCASTE
            if (_hasSearched)
              SearchSummary(
                from: fromController.text,
                to: toController.text,
                seat: seatController.text,
                dateTime: selectedDateTime,
                onEdit: () => setState(() => _hasSearched = false),
              ),

            // 🔵 BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      DestinationCarousel(screenWidth: screenWidth)
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
                        onRequestSeat: (result) => showSeatRequestDialog(context, result),
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
