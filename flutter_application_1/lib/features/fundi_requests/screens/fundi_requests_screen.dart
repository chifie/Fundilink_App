import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/service_request.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/request_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/shimmer_loading.dart';
import '../../../widgets/status_chip.dart';
import 'fundi_request_detail_screen.dart';

/// Fundi-side view of incoming service requests.
class FundiRequestsScreen extends StatefulWidget {
  const FundiRequestsScreen({super.key});

  @override
  State<FundiRequestsScreen> createState() => _FundiRequestsScreenState();
}

class _FundiRequestsScreenState extends State<FundiRequestsScreen> {
  String _filter = 'all';

  List<ServiceRequest> _applyFilter(List<ServiceRequest> requests) {
    switch (_filter) {
      case 'pending':
        return requests
            .where((r) => r.status == RequestStatus.pending)
            .toList();
      case 'active':
        return requests
            .where(
              (r) =>
                  r.status == RequestStatus.accepted ||
                  r.status == RequestStatus.inProgress,
            )
            .toList();
      case 'completed':
        return requests
            .where(
              (r) =>
                  r.status == RequestStatus.completed ||
                  r.status == RequestStatus.reviewed,
            )
            .toList();
      default:
        return requests;
    }
  }

  @override
  Widget build(BuildContext context) {
    final requests = _applyFilter(
      context.watch<RequestProvider>().fundiRequests,
    );
    final isLoading = context.watch<RequestProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.requests)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingS),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
              ),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _filter == 'all',
                    onTap: () => setState(() => _filter = 'all'),
                  ),
                  _FilterChip(
                    label: AppStrings.pending,
                    selected: _filter == 'pending',
                    onTap: () => setState(() => _filter = 'pending'),
                  ),
                  _FilterChip(
                    label: AppStrings.inProgress,
                    selected: _filter == 'active',
                    onTap: () => setState(() => _filter = 'active'),
                  ),
                  _FilterChip(
                    label: AppStrings.completed,
                    selected: _filter == 'completed',
                    onTap: () => setState(() => _filter = 'completed'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Expanded(
            child: isLoading
                ? ListView(
                    children: List.generate(
                      3,
                      (_) => const Padding(
                        padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
                        child: ShimmerFundiCard(),
                      ),
                    ),
                  )
                : requests.isEmpty
                ? const EmptyState(
                    icon: Icons.inbox_outlined,
                    title: 'No requests',
                    message:
                        'When customers request your services, they\'ll appear here.',
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      final user = context.read<AuthProvider>().user;
                      if (user != null) {
                        await context.read<RequestProvider>().loadFundiRequests(
                          user.id,
                        );
                      }
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingS,
                      ),
                      itemCount: requests.length,
                      itemBuilder: (context, index) =>
                          _RequestCard(request: requests[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primarySurface,
        labelStyle: TextStyle(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});
  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => FundiRequestDetailScreen(request: request),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StatusChip(status: request.status, compact: true),
                  const Spacer(),
                  Text(
                    Formatters.currency(request.estimatedCost),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Text(
                request.customerName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                request.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${request.preferredDate} · ${request.preferredTime}',
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.location_on_outlined,
                    size: 12,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
