import 'package:flutter/material.dart';

import '../models/fundi.dart';

/// Modal sheet for starting a new service request.
class NewRequestSheet extends StatefulWidget {
  const NewRequestSheet({super.key});

  @override
  State<NewRequestSheet> createState() => _NewRequestSheetState();
}

class _NewRequestSheetState extends State<NewRequestSheet> {
  FundiSkill? _skill;
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
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
              decoration: const InputDecoration(
                hintText: 'Describe the job (e.g. leaking sink in kitchen)',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _skill == null
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${_skill!.label} request sent to nearby fundis',
                          ),
                        ),
                      );
                    },
              child: const Text('Send request'),
            ),
          ],
        ),
      ),
    );
  }
}
