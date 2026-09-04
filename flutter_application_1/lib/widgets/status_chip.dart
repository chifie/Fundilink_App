import 'package:flutter/material.dart';

import '../models/service_request.dart';

/// Pill-shaped label reflecting a service request lifecycle status.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.compact = false});

  final RequestStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: status.lightColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!compact) ...[
            Icon(status.icon, size: 14, color: status.color),
            const SizedBox(width: 4),
          ],
          Text(
            status.label,
            style: TextStyle(
              color: status.color,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
