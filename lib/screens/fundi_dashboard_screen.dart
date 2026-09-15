import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../state/store_scope.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';
import '../widgets/status_badge.dart';

/// Simple MVP fundi dashboard for receiving and updating job requests.
class FundiDashboardScreen extends StatelessWidget {
  const FundiDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    final jobs = store.fundiJobs;

    return Scaffold(
      appBar: AppBar(title: const Text('Fundi dashboard')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _StatsGrid(
            pending: store.pendingRequests.length,
            upcoming: store.upcomingJobs.length,
            inProgress: store.jobsInProgress.length,
            completed: store.completedJobs.length,
            earnings: store.totalEarnings,
          ),
          const SizedBox(height: 16),
          Text('Jobs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (jobs.isEmpty)
            const EmptyState(
              icon: Icons.work_outline,
              title: 'No fundi jobs yet',
              message: 'Customer requests will appear here.',
            )
          else
            for (final booking in jobs) ...[
              _FundiJobCard(booking: booking),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.pending,
    required this.upcoming,
    required this.inProgress,
    required this.completed,
    required this.earnings,
  });

  final int pending;
  final int upcoming;
  final int inProgress;
  final int completed;
  final int earnings;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.9,
      children: [
        _StatTile(label: 'Pending', value: '$pending'),
        _StatTile(label: 'Upcoming', value: '$upcoming'),
        _StatTile(label: 'In progress', value: '$inProgress'),
        _StatTile(label: 'Completed', value: '$completed'),
        _StatTile(label: 'Earnings', value: Formatters.currency(earnings)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: text.titleMedium),
            const SizedBox(height: 2),
            Text(
              label,
              style: text.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FundiJobCard extends StatelessWidget {
  const _FundiJobCard({required this.booking});

  final Booking booking;

  Future<void> _complete(BuildContext context) async {
    final result = await showModalBottomSheet<_CompletionResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CompleteJobSheet(booking: booking),
    );
    if (result == null || !context.mounted) return;

    context.storeRead.completeJob(
      id: booking.id,
      workCompleted: result.workCompleted,
      labourCost: result.labourCost,
      materialCost: result.materialCost,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(booking.service, style: text.titleMedium),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.person_outline, text: 'Customer: G.girl'),
            _InfoRow(icon: Icons.location_on_outlined, text: booking.location),
            _InfoRow(icon: Icons.event_outlined, text: booking.dateLabel),
            if (booking.notes.isNotEmpty)
              _InfoRow(icon: Icons.notes_outlined, text: booking.notes),
            const SizedBox(height: 12),
            _Actions(booking: booking, onComplete: () => _complete(context)),
            if (booking.workCompleted != null) ...[
              const SizedBox(height: 12),
              Text(
                booking.workCompleted!,
                style: text.bodyMedium?.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                'Total: ${Formatters.currency(booking.payableAmount)}',
                style: text.titleSmall?.copyWith(color: colors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colors.onSurfaceVariant),
          const SizedBox(width: 6),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.booking, required this.onComplete});

  final Booking booking;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final store = context.storeRead;

    return switch (booking.status) {
      BookingStatus.pending => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => store.rejectBooking(booking.id),
              child: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: () => store.acceptBooking(booking.id),
              child: const Text('Accept'),
            ),
          ),
        ],
      ),
      BookingStatus.accepted => FilledButton(
        onPressed: () => store.updateBookingStatus(
          booking.id,
          BookingStatus.onTheWay,
        ),
        child: const Text('Start journey'),
      ),
      BookingStatus.onTheWay => FilledButton(
        onPressed: () => store.updateBookingStatus(
          booking.id,
          BookingStatus.inProgress,
        ),
        child: const Text('Start job'),
      ),
      BookingStatus.inProgress => FilledButton(
        onPressed: onComplete,
        child: const Text('Complete job'),
      ),
      BookingStatus.active => FilledButton(
        onPressed: () => store.updateBookingStatus(
          booking.id,
          BookingStatus.onTheWay,
        ),
        child: const Text('Start journey'),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _CompleteJobSheet extends StatefulWidget {
  const _CompleteJobSheet({required this.booking});

  final Booking booking;

  @override
  State<_CompleteJobSheet> createState() => _CompleteJobSheetState();
}

class _CompleteJobSheetState extends State<_CompleteJobSheet> {
  final TextEditingController _workController = TextEditingController();
  final TextEditingController _labourController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _workController.dispose();
    _labourController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  int _parseAmount(TextEditingController controller) =>
      int.tryParse(controller.text.trim()) ?? 0;

  void _submit() {
    final work = _workController.text.trim();
    if (work.isEmpty) {
      setState(() => _error = 'Enter the work completed');
      return;
    }

    Navigator.of(context).pop(
      _CompletionResult(
        workCompleted: work,
        labourCost: _parseAmount(_labourController),
        materialCost: _parseAmount(_materialController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Complete job', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _workController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Work completed',
                errorText: _error,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _labourController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Labour cost'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _materialController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Material cost'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submit,
              child: const Text('Complete job'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionResult {
  const _CompletionResult({
    required this.workCompleted,
    required this.labourCost,
    required this.materialCost,
  });

  final String workCompleted;
  final int labourCost;
  final int materialCost;
}
