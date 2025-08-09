import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/dates.dart';
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
              const SizedBox(height: 16),
              _inputTile(Icons.flight_takeoff, "To", toController),
              const SizedBox(height: 16),
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
                  const SizedBox(width: 12),
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
              const SizedBox(height: 16),
              _inputTile(Icons.airline_seat_recline_normal, "Seat", seatController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TapScale(
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      "Search",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputTile(IconData icon, String label, TextEditingController controller) {
    return Row(
      children: [
        _iconBox(icon),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _dateTimeTile(IconData icon, String label, String value) {
    return Row(
      children: [
        _iconBox(icon),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onPickDateTime,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.primary),
    );
  }
}
