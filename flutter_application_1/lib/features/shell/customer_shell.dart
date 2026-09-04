import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/navigation/customer_tabs.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/fundi_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/request_provider.dart';
import '../chat/screens/conversation_list_screen.dart';
import '../customer_profile/screens/profile_screen.dart';
import '../customer_requests/screens/my_requests_screen.dart';
import '../home/screens/home_screen.dart';
import '../search/screens/search_screen.dart';

/// Root scaffold for signed-in customers: hosts the five primary tabs
/// (Home, Search, Requests, Messages, Profile) and pre-loads shared data.
class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  late int _index;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _index = CustomerTabs.index.value;
    CustomerTabs.index.addListener(_onTabIndexChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSharedData());
  }

  @override
  void dispose() {
    CustomerTabs.index.removeListener(_onTabIndexChanged);
    super.dispose();
  }

  void _onTabIndexChanged() {
    if (mounted && _index != CustomerTabs.index.value) {
      setState(() => _index = CustomerTabs.index.value);
    }
  }

  void _loadSharedData() {
    if (_loaded) return;
    _loaded = true;

    final user = context.read<AuthProvider>().user;
    final fundiProvider = context.read<FundiProvider>();
    fundiProvider.loadCategories();
    fundiProvider.loadFundis();

    if (user != null) {
      context.read<RequestProvider>().loadCustomerRequests(user.id);
    }
    context.read<ChatProvider>().loadConversations();
    context.read<NotificationProvider>().load();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreen(),
          const SearchScreen(),
          const MyRequestsScreen(),
          ConversationListScreen(currentUserId: user?.id ?? ''),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => CustomerTabs.index.value = value,
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.primarySurface,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: AppStrings.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, color: AppColors.primary),
            label: AppStrings.search,
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: AppColors.primary),
            label: AppStrings.requests,
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: AppColors.primary),
            label: AppStrings.messages,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
