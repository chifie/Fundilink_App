import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/navigation/customer_tabs.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/service_request.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/request_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/requests/request_filter_bar.dart';
import '../../../widgets/status_chip.dart';
import 'request_detail_screen.dart';

/// Filterable list of the signed-in customer's service requests.
class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  RequestFilter _filter = RequestFilter.all;

  @override
  Widget build(BuildContext context) {
    final requests = _filter.apply(
      context.watch<RequestProvider>().customerRequests,
    );

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.myRequests)),
      body: Column(
        children: [
          const SizedBox(height: AppDimensions.paddingS),
          RequestFilterBar(
            current: _filter,
            onChanged: (filter) => setState(() => _filter = filter),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Expanded(
            child: requests.isEmpty
                ? EmptyState(
                    icon: Icons.assignment_outlined,
                    title: AppStrings.noRequests,
                    message: AppStrings.requestsEmptyHint,
                    actionLabel: AppStrings.findFundi,
                    onAction: () => CustomerTabs.goTo(CustomerTabs.home),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      final user = context.read<AuthProvider>().user;
                      if (user != null) {
                        await context
                            .read<RequestProvider>()
                            .loadCustomerRequests(user.id);
                      }
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingS,
                      ),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return _RequestCard(request: request);
                      },
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
            builder: (_) => RequestDetailScreen(request: request),
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
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Text(
                request.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Text(
                '${request.categoryName} · ${request.fundiName}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXS),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
