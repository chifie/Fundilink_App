import 'package:flutter/material.dart';

import '../state/store_scope.dart';
import '../widgets/empty_state.dart';

/// Manages the places the customer can send a fundi to.
class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  Future<void> _add(BuildContext context) async {
    // Resolved before the dialog opens: the context must not be used after
    // the await, and the store outlives this screen anyway.
    final store = context.storeRead;
    final draft = await showDialog<({String label, String line})>(
      context: context,
      builder: (_) => const _AddAddressDialog(),
    );
    if (draft == null) return;

    store.addAddress(label: draft.label, line: draft.line);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final addresses = context.store.addresses;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add address'),
      ),
      body: addresses.isEmpty
          ? const EmptyState(
              icon: Icons.location_off_outlined,
              title: 'No saved addresses',
              message: 'Add a place and fundis will know where to go.',
            )
          : ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 96),
              children: [
                if (addresses.length > 1)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                    child: Text(
                      'Tap an address to make it your default.',
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                for (final address in addresses)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        address.isDefault
                            ? Icons.home_outlined
                            : Icons.location_on_outlined,
                        color: address.isDefault ? colors.primary : null,
                      ),
                      title: Row(
                        children: [
                          Flexible(child: Text(address.label)),
                          if (address.isDefault) ...[
                            const SizedBox(width: 8),
                            _DefaultBadge(colors: colors, text: text),
                          ],
                        ],
                      ),
                      subtitle: Text(address.line),
                      // The default address is already the one in use, so
                      // tapping it would do nothing.
                      onTap: address.isDefault
                          ? null
                          : () => context.storeRead.makeDefaultAddress(
                              address.id,
                            ),
                      trailing: IconButton(
                        tooltip: 'Remove ${address.label}',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            context.storeRead.removeAddress(address.id),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Pill marking the address bookings default to.
class _DefaultBadge extends StatelessWidget {
  const _DefaultBadge({required this.colors, required this.text});

  final ColorScheme colors;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Default',
        style: text.labelSmall?.copyWith(color: colors.onSecondaryContainer),
      ),
    );
  }
}

/// Collects the label and street line for a new address.
class _AddAddressDialog extends StatefulWidget {
  const _AddAddressDialog();

  @override
  State<_AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<_AddAddressDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _label = TextEditingController();
  final TextEditingController _line = TextEditingController();

  @override
  void dispose() {
    _label.dispose();
    _line.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(
      context,
    ).pop((label: _label.text.trim(), line: _line.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add address'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _label,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Label',
                hintText: 'Home, Office, Mum…',
              ),
              validator: (value) =>
                  (value?.trim().isEmpty ?? true) ? 'Name this address' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _line,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Street, area, city',
              ),
              validator: (value) => (value?.trim().length ?? 0) < 5
                  ? 'Enter the street and area'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
