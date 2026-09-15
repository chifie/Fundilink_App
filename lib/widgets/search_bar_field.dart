import 'package:flutter/material.dart';

/// Rounded, tappable search field used on the home screen.
class SearchBarField extends StatelessWidget {
  const SearchBarField({super.key, this.onTap, this.onChanged});

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search services or fundis',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune),
          tooltip: 'Filters',
          onPressed: () {},
        ),
        filled: true,
        fillColor: colors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
