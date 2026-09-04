import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_dimensions.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/shell/customer_shell.dart';
import 'features/shell/fundi_workspace_placeholder.dart';
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
        return const LoginScreen();
      case AuthStatus.authenticated:
        return auth.user?.role == UserRole.fundi
            ? const FundiWorkspacePlaceholder()
            : const CustomerShell();
    }
  }
}

/// Minimal branded splash shown while the persisted session restores.
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handyman, size: 64, color: AppColors.primary),
            SizedBox(height: AppDimensions.spaceL),
            Text(
              AppStrings.appName,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: AppDimensions.spaceXL),
            SizedBox(
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
    );
  }
}
