import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappy/application/seats/search_seat_controller.dart' show SearchSeatController;
import 'package:swappy/l10n/app_localizations.dart' show AppLocalizations;

import '../../constants/app_colors.dart';
import '../../constants/dates.dart';
import '../../infrastructure/di/locator.dart';
import '../../infrastructure/auth/auth_service.dart';
import '../../ui/spacing.dart';
import '../../ui/max_width.dart';
import '../../ui/states/loading_state.dart';
import '../../ui/states/empty_state.dart';

import '../widgets/destination_carousel.dart';
import '../widgets/adaptive_scaffold.dart';
import '../widgets/search_form.dart';
import '../widgets/search_summary.dart';
import '../widgets/seat_request_dialog.dart';
import '../../widgets/search_results_list.dart';

import '../../domain/seats/seat.dart';
import '../../infrastructure/seats/seat_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final flightCodeController = TextEditingController();
  DateTime? selectedDateTime;

  Stream<List<Seat>>? searchResults;
  bool hasSearched = false;
  bool isLoading = false;
  String? error;

  late final SearchSeatController searchController;

  @override
  void initState() {
    super.initState();
    searchController = SearchSeatController(SeatService());
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    flightCodeController.dispose();
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
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submitSearch() {
    if (_formKey.currentState!.validate() && selectedDateTime != null) {
      setState(() {
        isLoading = true;
        error = null;
        hasSearched = true;
        searchResults = searchController.searchSeats(
          origin: fromController.text,
          destination: toController.text,
          date: selectedDateTime!,
          flightCode: flightCodeController.text.isNotEmpty
              ? flightCodeController.text
              : null,
        );
      });
      setState(() => isLoading = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
    }
  }

  final _routes = ['/notifications', '/search', '/profile'];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

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
        tooltip: 'Create listing',
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: MaxWidth(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                'Swappy',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              actions: [
                IconButton(
                  onPressed: () => locator<AuthService>().signOut(),
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  tooltip: 'Sign out',
                ),
              ],
            ),

            // 🔹 Hero Section
            if (!hasSearched)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: spaceL,
                      vertical: spaceM + spaceXS,
                    ),
                    color: Theme.of(context).colorScheme.background,
                    child: Text(
                      "Where's your\nnext destination",
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.primary,
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

            Padding(
              padding: const EdgeInsets.fromLTRB(
                spaceL,
                0,
                spaceL,
                spaceS + spaceXS,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search your next trip',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),

            if (hasSearched)
              SearchSummary(
                from: fromController.text,
                to: toController.text,
                flightCode: flightCodeController.text,
                dateTime: selectedDateTime,
                onEdit: () {
                  setState(() {
                    hasSearched = false;
                    searchResults = null;
                  });
                },
              ),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return const LoadingState();
                  }
                  if (error != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.somethingWentWrong,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: spaceS + spaceXS),
                        ElevatedButton(
                          onPressed: _submitSearch,
                          child: Text(AppLocalizations.of(context)!.retry),
                        ),
                      ],
                    );
                  }

                  if (searchResults != null) {
                    return SafeArea(
                      top: false,
                      child: StreamBuilder<List<Seat>>(
                        stream: searchResults,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LoadingState();
                          }
                          if (snapshot.hasError) {
                            return EmptyState(
                              icon: Icons.error,
                              title:
                                  AppLocalizations.of(context)!.somethingWentWrong,
                              subtitle:
                                  AppLocalizations.of(context)!.tryDifferentSearch,
                            );
                          }

                          final results = snapshot.data ?? [];
                          if (results.isEmpty) {
                            return EmptyState(
                              icon: Icons.search_off,
                              title:
                                  AppLocalizations.of(context)!.noResultsFound,
                              subtitle:
                                  AppLocalizations.of(context)!.tryDifferentSearch,
                            );
                          }

                          // 🔹 Usamos SearchResultsList con SeatMapper
                          return ListView(
                            padding: EdgeInsets.only(
                              left: spaceM,
                              right: spaceM,
                              top: spaceS,
                              bottom: bottomPadding,
                            ),
                            children: [
                              SearchResultsList(
                                results: results.map((r) => r.toSearchResult()).toList(),
                                onRequestSeat: (r) => showSeatRequestDialog(context, {
                                  'airline': r.airline,
                                  'from': r.from,
                                  'to': r.to,
                                  'flightCode': r.flightCode ?? '',
                                  'date': Dates.ymd(r.dateTime),
                                  'time': Dates.time.format(r.dateTime),
                                  'seatNumber': r.seat,
                                }),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }

                  // 🔹 Initial UI (form + carousel)
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 600;
                      if (isWide) {
                        final sectionWidth = constraints.maxWidth / 2;
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: spaceM,
                            vertical: spaceS,
                          ),
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
                                      flightCodeController: flightCodeController,
                                      selectedDateTime: selectedDateTime,
                                      onPickDateTime: _pickDateTime,
                                      onSubmit: _submitSearch,
                                    ),
                                  ),
                                  const SizedBox(width: spaceM),
                                  Expanded(
                                    child: DestinationCarousel(
                                      screenWidth: sectionWidth,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: spaceL),
                            ],
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: spaceM,
                          vertical: spaceS,
                        ),
                        child: Column(
                          children: [
                            SearchForm(
                              formKey: _formKey,
                              fromController: fromController,
                              toController: toController,
                              flightCodeController: flightCodeController,
                              selectedDateTime: selectedDateTime,
                              onPickDateTime: _pickDateTime,
                              onSubmit: _submitSearch,
                            ),
                            const SizedBox(height: spaceS),
                            DestinationCarousel(
                              screenWidth: constraints.maxWidth,
                            ),
                            const SizedBox(height: spaceL),
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
      ),
    );
  }
}
