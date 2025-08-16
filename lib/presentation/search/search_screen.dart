import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappy/l10n/app_localizations.dart' show AppLocalizations;

import '../../application/core/async_state.dart';
import '../../application/search/search_controller.dart' as search;
import '../../constants/app_colors.dart';
import '../../constants/dates.dart';
import '../../domain/entities/search_result.dart';
import '../../infrastructure/di/locator.dart';
import '../../infrastructure/auth/auth_service.dart';
import '../auth/auth_gate.dart';
import '../widgets/destination_carousel.dart';
import '../widgets/adaptive_scaffold.dart';
import '../widgets/search_form.dart';
import '../widgets/search_summary.dart';
import '../widgets/seat_request_dialog.dart';
import '../../widgets/search_results_list.dart';
import '../../ui/spacing.dart';
import '../../ui/max_width.dart';
import '../../ui/states/loading_state.dart';
import '../../ui/states/empty_state.dart';

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

  @override
  void dispose() {
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
      context.read<search.SearchController>().search(
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
    final bottomPadding = MediaQuery.of(context).padding.bottom + 16;

    void onSelect(int i) {
      if (i == 1) return;
      Navigator.pushReplacementNamed(context, _routes[i]);
    }

    return Consumer<search.SearchController>(
      builder: (context, controller, _) {
        final state = controller.state;
        final hasSearched = state.status == AsyncStatus.success;

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
                  onPressed: () {
                    locator<AuthService>().signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const AuthGate()),
                      (_) => false,
                    );
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  tooltip: 'Sign out',
                ),
              ],
            ),
            if (state.status == AsyncStatus.idle)
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
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
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
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
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
                    return const LoadingState();
                  }
                  if (state.status == AsyncStatus.error) {
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
                  if (state.status == AsyncStatus.success) {
                    return SafeArea(
                      top: false,
                      child: Selector<search.SearchController, List<SearchResult>>(
                        selector: (_, c) => c.state.data ?? <SearchResult>[],
                        builder: (context, results, _) {
                          if (results.isEmpty) {
                            return EmptyState(
                              icon: Icons.search_off,
                              title:
                                  AppLocalizations.of(context)!.noResultsFound,
                              subtitle: AppLocalizations.of(context)!
                                  .tryDifferentSearch,
                            );
                          }
                          return ListView(
                            padding: EdgeInsets.only(
                              left: spaceM,
                              right: spaceM,
                              top: spaceS,
                              bottom: bottomPadding,
                            ),
                            children: [
                              SearchResultsList(
                                results: results,
                                onRequestSeat: (r) =>
                                    showSeatRequestDialog(context, {
                                  'airline': r.airline,
                                  'from': r.from,
                                  'to': r.to,
                                  'seat': r.seat,
                                  'date': Dates.ymd(r.dateTime),
                                  'time': Dates.time.format(r.dateTime),
                                }),
                              ),
                            ],
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
                                      seatController: seatController,
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
                              seatController: seatController,
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
      },
    );
  }
}
