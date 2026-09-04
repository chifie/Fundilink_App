import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// A read-only text field that opens a time picker on tap.
class TimePickerField extends StatelessWidget {
  const TimePickerField({super.key, required this.label, required this.time, required this.onPicked});
  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onPicked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null) onPicked(picked);
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.schedule, size: 20)),
        child: Text(
          time.format(context),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
