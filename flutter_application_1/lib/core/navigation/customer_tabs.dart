import 'package:flutter/foundation.dart';

/// Global navigation state shared between the customer bottom-nav shell and
/// screens that need to switch tabs programmatically (e.g. jumping to
/// Requests after a successful booking).
class CustomerTabs {
  CustomerTabs._();

  static const int home = 0;
  static const int search = 1;
  static const int requests = 2;
  static const int messages = 3;
  static const int profile = 4;

  /// Current bottom-navigation index of the customer shell.
  static final ValueNotifier<int> index = ValueNotifier<int>(home);

  /// Category id requested from the home screen; the search tab consumes it.
  static final ValueNotifier<String?> categoryRequest = ValueNotifier<String?>(
    null,
  );

  /// Switches the shell to a tab and resets any pending category filter.
  static void goTo(int tab) {
    if (tab != search) categoryRequest.value = null;
    index.value = tab;
  }
}
