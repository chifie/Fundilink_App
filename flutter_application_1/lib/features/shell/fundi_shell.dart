import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/navigation/fundi_tabs.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/request_provider.dart';
import '../chat/screens/conversation_list_screen.dart';
import '../customer_profile/screens/profile_screen.dart';
import '../fundi_dashboard/screens/fundi_dashboard_screen.dart';
import '../fundi_jobs/screens/fundi_jobs_screen.dart';
import '../fundi_requests/screens/fundi_requests_screen.dart';

/// Root scaffold for signed-in fundis: hosts the five primary tabs
/// (Dashboard, Requests, Jobs, Messages, Profile).
class FundiShell extends StatefulWidget {
  const FundiShell({super.key});

  @override
  State<FundiShell> createState() => _FundiShellState();
}

class _FundiShellState extends State<FundiShell> {
  late int _index;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _index = FundiTabs.index.value;
    FundiTabs.index.addListener(_onTabIndexChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    FundiTabs.index.removeListener(_onTabIndexChanged);
    super.dispose();
  }

  void _onTabIndexChanged() {
    if (mounted && _index != FundiTabs.index.value) {
      setState(() => _index = FundiTabs.index.value);
    }
  }

  void _loadData() {
    if (_loaded) return;
    _loaded = true;
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    context.read<RequestProvider>().loadFundiRequests(user.id);
    context.read<ChatProvider>().setCurrentUserId(user.id);
    context.read<ChatProvider>().loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const FundiDashboardScreen(),
          const FundiRequestsScreen(),
          const FundiJobsScreen(),
          ConversationListScreen(currentUserId: user?.id ?? ''),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => FundiTabs.index.value = value,
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.primarySurface,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
            label: AppStrings.dashboard,
          ),
          const NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: AppColors.primary),
            label: AppStrings.requests,
          ),
          const NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work, color: AppColors.primary),
            label: AppStrings.jobs,
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: context.watch<ChatProvider>().unreadTotal > 0,
              label: Text('${context.watch<ChatProvider>().unreadTotal}'),
              child: const Icon(Icons.chat_bubble_outline),
            ),
            selectedIcon: Badge(
              isLabelVisible: context.watch<ChatProvider>().unreadTotal > 0,
              label: Text('${context.watch<ChatProvider>().unreadTotal}'),
              child: const Icon(Icons.chat_bubble, color: AppColors.primary),
            ),
            label: AppStrings.messages,
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
