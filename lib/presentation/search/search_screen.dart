import 'package:flutter/material.dart';

import '../../application/core/async_state.dart';
import '../../application/search/search_controller.dart' as search;
import '../../constants/app_colors.dart';
import '../../constants/dates.dart';
import '../../domain/entities/search_result.dart';
import '../../infrastructure/di/locator.dart';
import '../widgets/destination_carousel.dart';
import '../widgets/main_scaffold.dart';
import '../widgets/search_form.dart';
import '../widgets/search_summary.dart';
import '../widgets/seat_request_dialog.dart';
import '../widgets/tap_scale.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;
    final results = state.data ?? <SearchResult>[];
    final hasSearched = state.status == AsyncStatus.success;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return MainScaffold(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
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
              title: Hero(
                tag: 'app-logo',
                child: Image.asset('assets/logo.png', height: 32),
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
                onEdit: () => controller.state = const AsyncState.idle(),
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: disableAnimations
                    ? Duration.zero
                    : const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: () {
                  if (state.status == AsyncStatus.loading) {
                    return const Center(
                      key: ValueKey('loading'),
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.status == AsyncStatus.error) {
                    return Column(
                      key: const ValueKey('error'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Something went wrong'),
                        const SizedBox(height: 12),
                        TapScale(
                          child: ElevatedButton(
                            onPressed: _submitSearch,
                            child: const Text('Retry'),
                          ),
                        ),
                      ],
                    );
                  }
                  if (state.status == AsyncStatus.success) {
                    if (results.isEmpty) {
                      return const Center(
                        key: ValueKey('empty'),
                        child: Text('No results found'),
                      );
                    }
                    return SafeArea(
                      key: const ValueKey('search-results'),
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
                          final item = Container(
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
                                          color:
                                              Color.fromARGB(255, 79, 170, 255),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          Dates.ymd(r.dateTime),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          Dates.time.format(r.dateTime),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12),
                                        ),
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
                                    TapScale(
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            showSeatRequestDialog(context, {
                                          'airline': r.airline,
                                          'from': r.from,
                                          'to': r.to,
                                          'seat': r.seat,
                                          'date': Dates.ymd(r.dateTime),
                                          'time':
                                              Dates.time.format(r.dateTime),
                                        }),
                                        icon: const Icon(Icons.event_seat),
                                        label:
                                            const Text('Solicitar asiento'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary
                                              .withOpacity(0.1),
                                          foregroundColor: AppColors.primary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                          return _AnimatedResultItem(index: i, child: item);
                        },
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    key: const ValueKey('search-form'),
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
                  );
                }(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedResultItem extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedResultItem({required this.child, required this.index});

  @override
  State<_AnimatedResultItem> createState() => _AnimatedResultItemState();
}

class _AnimatedResultItemState extends State<_AnimatedResultItem> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final disable = MediaQuery.of(context).disableAnimations;
      if (disable) {
        setState(() => _visible = true);
      } else {
        Future.delayed(Duration(milliseconds: widget.index * 50), () {
          if (mounted) setState(() => _visible = true);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 300);
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: duration,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.1),
        duration: duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
