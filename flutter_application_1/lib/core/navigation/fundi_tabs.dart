import 'package:flutter/foundation.dart';

/// Global navigation state for the fundi bottom-nav shell.
class FundiTabs {
  FundiTabs._();

  static const int dashboard = 0;
  static const int requests = 1;
  static const int jobs = 2;
  static const int messages = 3;
  static const int profile = 4;

  /// Current bottom-navigation index of the fundi shell.
  static final ValueNotifier<int> index = ValueNotifier<int>(dashboard);

  static void goTo(int tab) {
    index.value = tab;
  }
}
