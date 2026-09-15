import 'package:flutter/material.dart';

import '../screens/bookings_screen.dart';
import '../screens/fundi_dashboard_screen.dart';
import '../screens/new_request_sheet.dart';
import '../screens/home_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/profile_screen.dart';

/// Tabs available in the customer bottom navigation.
enum _Tab { home, bookings, messages, fundi, profile }

/// Main app scaffold: IndexedStack body plus a Material 3 NavigationBar.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  _Tab _current = _Tab.home;

  void _showNewRequestSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const NewRequestSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'new-request',
        onPressed: () => _showNewRequestSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('New request'),
      ),
      body: IndexedStack(
        index: _current.index,
        children: [
          const HomeScreen(),
          const BookingsScreen(),
          const MessagesScreen(),
          const FundiDashboardScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        backgroundColor: colors.surfaceContainer,
        indicatorColor: colors.secondaryContainer,
        selectedIndex: _current.index,
        onDestinationSelected: (index) =>
            setState(() => _current = _Tab.values[index]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.engineering_outlined),
            selectedIcon: Icon(Icons.engineering),
            label: 'Fundi',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
