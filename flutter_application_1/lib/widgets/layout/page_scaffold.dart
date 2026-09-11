import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Standard page scaffold for secondary screens.
///
/// Wraps a [Scaffold] with the app-wide [AppBar] conventions: centered
/// title, back button, and optional trailing actions. Pass [refresh] to
/// get a pull-to-refresh [RefreshIndicator] around the body for free.
///
/// Example usage:
/// ```dart
/// PageScaffold(
///   title: AppStrings.notifications,
///   actions: [
///     IconButton(
///       tooltip: AppStrings.markAllRead,
///       onPressed: provider.markAllRead,
///       icon: const Icon(Icons.done_all),
///     ),
///   ],
///   refresh: () => context.read<NotificationProvider>().load(),
///   body: const NotificationList(),
/// )
/// ```
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.refresh,
    this.backgroundColor,
    this.floatingActionButton,
  });

  /// Title rendered centered in the app bar.
  final String title;

  /// Primary content of the screen.
  final Widget body;

  /// Optional trailing widgets shown in the app bar.
  final List<Widget>? actions;

  /// Optional pull-to-refresh callback. When provided the body is wrapped
  /// in a [RefreshIndicator]; only relevant for scrollable bodies.
  final Future<void> Function()? refresh;

  /// Optional background color. Defaults to the theme scaffold background.
  final Color? backgroundColor;

  /// Optional floating action button forwarded to the [Scaffold].
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      body: body,
    );

    if (refresh == null) return scaffold;

    return RefreshIndicator(onRefresh: refresh!, child: scaffold);
  }
}
