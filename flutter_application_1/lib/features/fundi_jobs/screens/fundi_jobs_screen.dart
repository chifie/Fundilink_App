import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/service_request.dart';
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
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: isLoading
            ? ListView(children: List.generate(3, (_) => const Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.spaceS, top: AppDimensions.paddingS),
                child: ShimmerFundiCard(),
              )))
            : TabBarView(
                children: [
                  _JobList(
                    requests: provider.fundiRequests
                        .where((r) => r.status == RequestStatus.accepted || r.status == RequestStatus.inProgress)
                        .toList(),
                    emptyMessage: 'No active jobs right now.',
                  ),
                  _JobList(
                    requests: provider.fundiRequests
                        .where((r) => r.status == RequestStatus.completed || r.status == RequestStatus.reviewed)
                        .toList(),
                    emptyMessage: 'Completed jobs will appear here.',
                  ),
                ],
              ),
      ),
    );
  }
}

class _JobList extends StatelessWidget {
  const _JobList({required this.requests, required this.emptyMessage});
  final List<ServiceRequest> requests;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return EmptyState(icon: Icons.work_outline, title: emptyMessage);
    }
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingS),
            child: ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => RequestDetailScreen(request: request)),
              ),
              leading: CircleAvatar(
                backgroundColor: request.status.lightColor,
                child: Icon(request.status.icon, color: request.status.color, size: 20),
              ),
              title: Text(
                request.customerName,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${request.categoryName} · ${request.preferredDate}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusChip(status: request.status, compact: true),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.currency(request.estimatedCost),
                    style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700),
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
