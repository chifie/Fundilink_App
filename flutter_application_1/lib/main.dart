import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_dimensions.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/shell/customer_shell.dart';
import 'features/shell/fundi_shell.dart';
import 'models/user_model.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/fundi_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/request_provider.dart';
import 'providers/review_provider.dart';

void main() {
  runApp(const FundiLinkApp());
}

/// Root application: wires the provider scope, theme and the auth gate.
class FundiLinkApp extends StatelessWidget {
  const FundiLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => FundiProvider()),
          ChangeNotifierProvider(create: (_) => RequestProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => ReviewProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ],
        child: const RootGate(),
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
        return const _SplashScreen();
      case AuthStatus.unauthenticated:
        return const _AuthGate();
      case AuthStatus.authenticated:
        return auth.user?.role == UserRole.fundi
            ? const FundiShell()
            : const CustomerShell();
    }
  }
}

/// Minimal branded splash shown while the persisted session restores.
class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: const Icon(
                  Icons.handyman,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceL),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXL),
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    if (_checking) return const _SplashScreen();
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
