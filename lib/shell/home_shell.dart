import 'package:flutter/material.dart';

import '../screens/bookings_screen.dart';
import '../screens/home_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/profile_screen.dart';

/// Tabs available in the customer bottom navigation.
enum _Tab { home, bookings, messages, profile }

/// Main app scaffold: IndexedStack body plus a Material 3 NavigationBar.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  _Tab _current = _Tab.home;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _current.index,
        children: [
          HomeScreen(),
          BookingsScreen(),
          MessagesScreen(),
          ProfileScreen(onToggleTheme: widget.onToggleTheme),
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
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
