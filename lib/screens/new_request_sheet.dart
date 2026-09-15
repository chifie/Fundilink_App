import 'package:flutter/material.dart';

import '../models/fundi.dart';
import '../state/store_scope.dart';
import '../utils/formatters.dart';

/// Modal sheet for starting a new service request.
class NewRequestSheet extends StatefulWidget {
  const NewRequestSheet({super.key, this.initialSkill});

  /// Service to preselect, e.g. when opened from a category tile.
  final FundiSkill? initialSkill;

  @override
  State<NewRequestSheet> createState() => _NewRequestSheetState();
}

class _NewRequestSheetState extends State<NewRequestSheet> {
  late FundiSkill? _skill = widget.initialSkill;
  final TextEditingController _descriptionController = TextEditingController();

  /// Null keeps the store's default slot: tomorrow at 09:00.
  DateTime? _scheduledAt;
  String? _descriptionError;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickSchedule() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt ?? DateTime(0, 0, 0, 9)),
    );
    if (time == null || !mounted) return;

    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _send() {
    final skill = _skill;
    final description = _descriptionController.text.trim();

    if (description.isEmpty) {
      setState(
        () => _descriptionError = 'Describe the job so fundis can quote',
      );
      return;
    }
    if (skill == null) return;

    final booking = context.storeRead.requestService(
      skill: skill,
      description: description,
      scheduledAt: _scheduledAt,
    );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          booking == null
              ? 'No fundis available for ${skill.label.toLowerCase()} yet'
              : 'Request sent to ${booking.fundi.name}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('New request', style: text.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Pick a service and describe the job.',
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final skill in FundiSkill.values)
                  ChoiceChip(
                    label: Text(skill.label),
                    selected: _skill == skill,
                    onSelected: (_) => setState(() => _skill = skill),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              onChanged: (_) {
                if (_descriptionError != null) {
                  setState(() => _descriptionError = null);
                }
              },
              decoration: InputDecoration(
                hintText: 'Describe the job (e.g. leaking sink in kitchen)',
                errorText: _descriptionError,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _scheduledAt == null
                        ? 'Tomorrow at 9:00 AM'
                        : Formatters.dateTime(_scheduledAt!),
                    style: text.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: _pickSchedule,
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _skill == null ? null : _send,
              child: const Text('Send request'),
            ),
            if (_skill == null) ...[
              const SizedBox(height: 8),
              Text(
                'Choose a service to continue.',
                textAlign: TextAlign.center,
                style: text.labelMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
