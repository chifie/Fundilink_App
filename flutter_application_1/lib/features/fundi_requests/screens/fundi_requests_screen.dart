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
import '../../../widgets/requests/request_filter_bar.dart';
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
  RequestFilter _filter = RequestFilter.all;

  @override
  Widget build(BuildContext context) {
    final requests = _filter.apply(
      context.watch<RequestProvider>().fundiRequests,
    );
    final isLoading = context.watch<RequestProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.requests)),
      body: Column(
        children: [
          const SizedBox(height: AppDimensions.paddingS),
          RequestFilterBar(
            current: _filter,
            onChanged: (filter) => setState(() => _filter = filter),
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
                    title: AppStrings.noRequestsTitle,
                    message: AppStrings.noFundiRequestsHint,
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
