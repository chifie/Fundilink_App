import 'package:flutter/material.dart';

/// Circular fundi photo with a subtle online indicator.
///
/// Falls back to initials on a tonal disc until real avatars exist.
class FundiAvatar extends StatelessWidget {
  const FundiAvatar({
    super.key,
    required this.name,
    this.size = 48,
    this.isOnline = false,
  });

  final String name;
  final double size;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase())
        .take(2)
        .join();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Text(
            initials,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.onSecondaryContainer,
                ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colors.surface, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
