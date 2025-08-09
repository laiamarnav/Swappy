import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/dates.dart';
import '../../ui/spacing.dart';
import 'tap_scale.dart';

class SearchForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fromController;
  final TextEditingController toController;
  final TextEditingController seatController;
  final DateTime? selectedDateTime;
  final VoidCallback onPickDateTime;
  final VoidCallback onSubmit;

  const SearchForm({
    super.key,
    required this.formKey,
    required this.fromController,
    required this.toController,
    required this.seatController,
    required this.selectedDateTime,
    required this.onPickDateTime,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(spaceM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(spaceL),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _inputTile(Icons.location_on, "From", fromController),
              const SizedBox(height: spaceM),
              _inputTile(Icons.flight_takeoff, "To", toController),
              const SizedBox(height: spaceM),
              Row(
                children: [
                  Expanded(
                    child: _dateTimeTile(
                      Icons.calendar_today,
                      "Date",
                      selectedDateTime != null
                          ? Dates.date.format(selectedDateTime!)
                          : 'Pick a date',
                    ),
                  ),
                  const SizedBox(width: spaceS + spaceXS),
                  Expanded(
                    child: _dateTimeTile(
                      Icons.access_time,
                      "Hora",
                      selectedDateTime != null
                          ? Dates.time.format(selectedDateTime!)
                          : '--:--',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: spaceM),
              _inputTile(
                Icons.airline_seat_recline_normal,
                "Seat",
                seatController,
              ),
              const SizedBox(height: spaceL),
              SizedBox(
                width: double.infinity,
                child: TapScale(
                  child: FilledButton(
                    onPressed: onSubmit,
                    child: const Text("Search"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputTile(
    IconData icon,
    String label,
    TextEditingController controller,
  ) {
    return Row(
      children: [
        _iconBox(icon),
        const SizedBox(width: spaceS + spaceXS),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: spaceM,
                vertical: spaceS + spaceXS,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(spaceM),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _dateTimeTile(IconData icon, String label, String value) {
    return Row(
      children: [
        _iconBox(icon),
        const SizedBox(width: spaceS + spaceXS),
        Expanded(
          child: GestureDetector(
            onTap: onPickDateTime,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: spaceM,
                  vertical: spaceS + spaceXS,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(spaceM),
                  borderSide: BorderSide.none,
                ),
              ),
              child: Text(value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(spaceS + spaceXS),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(spaceS + spaceXS),
      ),
      child: Icon(icon, color: AppColors.primary),
    );
  }
}
