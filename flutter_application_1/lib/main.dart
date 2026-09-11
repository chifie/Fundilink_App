import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/shell/customer_shell.dart';
import 'features/splash/screens/splash_screen.dart'
import 'features/shell/fundi_shell.dart';
import 'models/user_model.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/fundi_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/request_provider.dart';
import 'providers/review_provider.dart';
import 'providers/settings_provider.dart';

void main() {
  runApp(const FundiLinkApp());
}

/// Root application: wires the provider scope, theme and the auth gate.
class FundiLinkApp extends StatelessWidget {
  const FundiLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FundiProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Builder(
        builder: (context) {
          final settings = context.watch<SettingsProvider>();
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            home: const RootGate(),
          );
        },
      ),
    );
  }
}

/// Decides the first screen: splash while the session restores, login when
/// signed out, the customer shell or fundi placeholder once signed in.
class RootGate extends StatefulWidget {
  const RootGate({super.key});

  @override
  State<RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<RootGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {
      case AuthStatus.unknown:
        return const SplashScreen();
      case AuthStatus.unauthenticated:
        return const _AuthGate();
      case AuthStatus.authenticated:
        return auth.user?.role == UserRole.fundi
            ? const FundiShell()
            : const CustomerShell();
    }
  }
}

/// Decides between onboarding and login for first-time / returning users.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  bool _checking = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final show = await OnboardingScreen.shouldShow();
    if (mounted) {
      setState(() {
        _showOnboarding = show;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) return const SplashScreen();
    if (_showOnboarding) {
      return OnboardingScreen(
        onComplete: () {
          setState(() {
            _showOnboarding = false;
          });
        },
      );
    }
    return const LoginScreen();
  }
}
