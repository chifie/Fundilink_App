import 'package:flutter/material.dart';

/// Gradient call-to-action banner shown on the home tab.
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [colors.primary, colors.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First booking?',
                      style: text.titleMedium?.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Get 20% off your first fundi request.',
                      style: text.bodyMedium?.copyWith(
                        color: colors.onPrimary.withAlpha(230),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: colors.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
