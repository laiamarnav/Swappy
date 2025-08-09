import 'package:flutter/material.dart';

import '../../application/core/async_state.dart';
import '../../application/search/search_controller.dart' as search;
import '../../constants/app_colors.dart';
import '../../constants/dates.dart';
import '../../domain/entities/search_result.dart';
import '../../infrastructure/di/locator.dart';
import '../widgets/destination_carousel.dart';
import '../widgets/adaptive_scaffold.dart';
import '../widgets/search_form.dart';
import '../widgets/search_summary.dart';
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

  late final search.SearchController controller =
      search.SearchController(locator());

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    fromController.dispose();
    toController.dispose();
    seatController.dispose();
    super.dispose();
  }

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
      selectedDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submitSearch() {
    if (_formKey.currentState!.validate() && selectedDateTime != null) {
      controller.search(
        from: fromController.text,
        to: toController.text,
        seat: seatController.text,
        dateTime: selectedDateTime!,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  final _routes = ['/notifications', '/search', '/profile'];

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;
    final results = state.data ?? <SearchResult>[];
    final hasSearched = state.status == AsyncStatus.success;

    void onSelect(int i) {
      if (i == 1) return;
      Navigator.pushReplacementNamed(context, _routes[i]);
    }

    return AdaptiveScaffold(
      currentIndex: 1,
      onSelect: onSelect,
      fab: FloatingActionButton(
        heroTag: 'search',
        onPressed: _navigateCreate,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
          children: [
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
            if (state.status == AsyncStatus.idle)
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
                  'Search your next trip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 94, 94, 94),
                  ),
                ),
              ),
            ),
            if (hasSearched)
              SearchSummary(
                from: fromController.text,
                to: toController.text,
                seat: seatController.text,
                dateTime: selectedDateTime,
                onEdit: controller.reset,
              ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state.status == AsyncStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == AsyncStatus.error) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Something went wrong'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _submitSearch,
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  }
                  if (state.status == AsyncStatus.success) {
                    if (results.isEmpty) {
                      return const Center(child: Text('No results found'));
                    }
                    return SafeArea(
                      top: false,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 8,
                          bottom: bottomPadding,
                        ),
                        itemCount: results.length,
                        itemBuilder: (context, i) {
                          final r = results[i];
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.flight_takeoff,
                                          color: Color.fromARGB(255, 79, 170, 255),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${r.from} → ${r.to}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(Dates.ymd(r.dateTime),
                                            style: const TextStyle(
                                                color: Colors.grey, fontSize: 12)),
                                        Text(Dates.time.format(r.dateTime),
                                            style: const TextStyle(
                                                color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(r.airline,
                                    style: const TextStyle(color: Colors.grey)),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Seat: ${r.seat}'),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          showSeatRequestDialog(context, {
                                        'airline': r.airline,
                                        'from': r.from,
                                        'to': r.to,
                                        'seat': r.seat,
                                        'date': Dates.ymd(r.dateTime),
                                        'time': Dates.time.format(r.dateTime),
                                      }),
                                      icon: const Icon(Icons.event_seat),
                                      label: const Text('Solicitar asiento'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.primary.withOpacity(0.1),
                                        foregroundColor: AppColors.primary,
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
                    );
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 600;
                      if (isWide) {
                        final sectionWidth = constraints.maxWidth / 2;
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: SearchForm(
                                      formKey: _formKey,
                                      fromController: fromController,
                                      toController: toController,
                                      seatController: seatController,
                                      selectedDateTime: selectedDateTime,
                                      onPickDateTime: _pickDateTime,
                                      onSubmit: _submitSearch,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DestinationCarousel(
                                        screenWidth: sectionWidth),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      }
                      return SingleChildScrollView(
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
                                screenWidth: constraints.maxWidth),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}
