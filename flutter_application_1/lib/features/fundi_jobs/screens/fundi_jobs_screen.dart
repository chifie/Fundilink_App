import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/request_status_extension.dart';
import '../../../models/service_request.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/request_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/shimmer_loading.dart';
import '../../../widgets/status_chip.dart';
import '../../customer_requests/screens/request_detail_screen.dart';

/// Active and completed jobs for the signed-in fundi.
class FundiJobsScreen extends StatelessWidget {
  const FundiJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();
    final isLoading = provider.isLoading;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.jobs),
          bottom: const TabBar(
            tabs: [
              Tab(text: AppStrings.jobsActive),
              Tab(text: AppStrings.jobsCompleted),
            ],
          ),
        ),
        body: isLoading
            ? ListView(
                children: List.generate(
                  3,
                  (_) => const Padding(
                    padding: EdgeInsets.only(
                      bottom: AppDimensions.spaceS,
                      top: AppDimensions.paddingS,
                    ),
                    child: ShimmerFundiCard(),
                  ),
                ),
              )
            : TabBarView(
                children: [
                  _JobList(
                    requests: provider.fundiRequests
                        .where((r) => r.status.isActive)
                        .toList(),
                    emptyMessage: AppStrings.noActiveJobs,
                    onRefresh: () => _reloadFundiRequests(context),
                  ),
                  _JobList(
                    requests: provider.fundiRequests
                        .where((r) => r.status.isPaidOut)
                        .toList(),
                    emptyMessage: AppStrings.noCompletedJobs,
                    onRefresh: () => _reloadFundiRequests(context),
                  ),
                ],
              ),
      ),
    );
  }

  /// Reloads the fundi's requests for pull-to-refresh.
  Future<void> _reloadFundiRequests(BuildContext context) async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    await context.read<RequestProvider>().loadFundiRequests(user.id);
  }
}

class _JobList extends StatelessWidget {
  const _JobList({
    required this.requests,
    required this.emptyMessage,
    required this.onRefresh,
  });
  final List<ServiceRequest> requests;
  final String emptyMessage;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 400,
              child: EmptyState(icon: Icons.work_outline, title: emptyMessage),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            child: ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => RequestDetailScreen(request: request),
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: request.status.lightColor,
                child: Icon(
                  request.status.icon,
                  color: request.status.color,
                  size: 20,
                ),
              ),
              title: Text(
                request.customerName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '${request.categoryName} · ${request.preferredDate}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusChip(status: request.status, compact: true),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.currency(request.estimatedCost),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
