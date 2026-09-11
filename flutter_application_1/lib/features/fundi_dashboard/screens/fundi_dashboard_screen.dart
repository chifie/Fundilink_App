import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/request_provider.dart';
import '../../../widgets/count_up_stat_card.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/shimmer_loading.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../widgets/fundi_quick_actions.dart';
import '../widgets/fundi_recent_activity.dart';

/// Fundi home dashboard showing stats, recent activity and quick actions.
class FundiDashboardScreen extends StatefulWidget {
  const FundiDashboardScreen({super.key});

  @override
  State<FundiDashboardScreen> createState() => _FundiDashboardScreenState();
}

class _FundiDashboardScreenState extends State<FundiDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    context.read<RequestProvider>().loadFundiRequests(user.id);
    context.read<NotificationProvider>().load();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final requests = context.watch<RequestProvider>();
    final notifications = context.watch<NotificationProvider>();
    final isLoading = requests.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        actions: [
          IconButton(
            tooltip: AppStrings.notifications,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NotificationsScreen(),
              ),
            ),
            icon: Badge(
              isLabelVisible: notifications.unreadCount > 0,
              label: Text('${notifications.unreadCount}'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          children: [
            // Welcome header
            _WelcomeHeader(name: user?.fullName ?? 'Fundi'),
            const SizedBox(height: AppDimensions.spaceL),

            // Stats row
            if (isLoading)
              const _StatsShimmer()
            else
              _StatsRow(requests: requests),
            const SizedBox(height: AppDimensions.spaceL),

            // Quick actions
            const FundiQuickActions(),
            const SizedBox(height: AppDimensions.spaceL),

            // Recent activity
            const SectionHeader(title: AppStrings.recentActivity),
            const SizedBox(height: AppDimensions.spaceS),
            if (isLoading)
              const _ActivityShimmer()
            else
              FundiRecentActivity(requests: requests.fundiRequests),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, $name 👋',
            style: const TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            'Here\'s your work overview for today.',
            style: TextStyle(
              color: AppColors.textOnPrimary.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.requests});

  final RequestProvider requests;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CountUpStatCard(
            label: AppStrings.pendingRequests,
            value: requests.pendingCount.toDouble(),
            icon: Icons.schedule,
            color: AppColors.statusPending,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceS),
        Expanded(
          child: CountUpStatCard(
            label: AppStrings.activeJobs,
            value: requests.activeCount.toDouble(),
            icon: Icons.build_circle_outlined,
            color: AppColors.statusInProgress,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceS),
        Expanded(
          child: CountUpStatCard(
            label: AppStrings.completed,
            value: requests.completedCount.toDouble(),
            icon: Icons.verified_outlined,
            color: AppColors.statusCompleted,
          ),
        ),
      ],
    );
  }
}

class _StatsShimmer extends StatelessWidget {
  const _StatsShimmer();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: ShimmerLoading(
            child: SizedBox(
              height: 80,
              child: ColoredBox(color: AppColors.surfaceVariant),
            ),
          ),
        ),
        SizedBox(width: AppDimensions.spaceS),
        Expanded(
          child: ShimmerLoading(
            child: SizedBox(
              height: 80,
              child: ColoredBox(color: AppColors.surfaceVariant),
            ),
          ),
        ),
        SizedBox(width: AppDimensions.spaceS),
        Expanded(
          child: ShimmerLoading(
            child: SizedBox(
              height: 80,
              child: ColoredBox(color: AppColors.surfaceVariant),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityShimmer extends StatelessWidget {
  const _ActivityShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (_) => const Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.spaceS),
          child: ShimmerFundiCard(),
        ),
      ),
    );
  }
}
