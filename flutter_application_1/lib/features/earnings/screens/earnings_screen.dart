import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/request_status_extension.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/request_provider.dart';
import '../../../widgets/earnings_chart.dart';
import '../../../widgets/shimmer_loading.dart';

/// Earnings dashboard for the fundi.
class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  double? _totalEarnings;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    final total = await context.read<RequestProvider>().totalEarnings(user.id);
    if (mounted) {
      setState(() {
        _totalEarnings = total;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final requests = context.watch<RequestProvider>().fundiRequests;
    final completedJobs = requests.where((r) => r.status.isPaidOut).toList();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.myEarnings)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          // Total earnings card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.forestGreen,
                  AppColors.forestGreen.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Column(
              children: [
                const Text(
                  AppStrings.totalEarned,
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceS),
                if (_loading)
                  const ShimmerLoading(
                    child: SizedBox(
                      width: 150,
                      height: 36,
                      child: ColoredBox(color: AppColors.surfaceVariant),
                    ),
                  )
                else
                  Text(
                    Formatters.currency(_totalEarnings ?? 0),
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),

          // Earnings summary card
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.forestGreen.withValues(alpha: 0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: AppColors.forestGreen),
                SizedBox(width: 6),
                Text(
                  AppStrings.earningsGrowing,
                  style: TextStyle(
                    color: AppColors.forestGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),

          // Weekly chart
          EarningsChart(dailyEarnings: [1200, 800, 2500, 0, 1800, 3200, 0]),
          const SizedBox(height: AppDimensions.spaceXL),

          // Job history
          const Text(
            AppStrings.jobHistory,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          if (completedJobs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingXL),
              child: Center(
                child: Text(
                  AppStrings.noCompletedJobsYet,
                  style: const TextStyle(color: AppColors.textHint),
                ),
              ),
            )
          else
            for (final job in completedJobs)
              Card(
                margin: const EdgeInsets.only(bottom: AppDimensions.spaceS),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.forestGreen.withValues(
                      alpha: 0.12,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.forestGreen,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    job.customerName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    job.categoryName,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    Formatters.currency(job.estimatedCost),
                    style: const TextStyle(
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
