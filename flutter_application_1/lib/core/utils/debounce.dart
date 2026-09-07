import 'dart:async';

/// A utility class for debouncing function calls.
/// 
/// Debouncing ensures that a function is not called more than once within
/// a specified time window. Useful for search inputs, button clicks, etc.
class Debouncer {
  final Duration delay;
  Timer? _timer;
  bool _isActive = true;

  /// Creates a Debouncer with the specified delay.
  Debouncer({required this.delay});

  /// Run a function after the debounce delay.
  /// If called again within the delay, the timer resets.
  void run(void Function() action) {
    if (!_isActive) return;
    
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Run an async function after the debounce delay.
  Future<void> runAsync(Future<void> Function() action) async {
    if (!_isActive) return;
    
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel the current timer and prevent future runs.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Whether the debouncer is currently active.
  bool get isActive => _isActive;

  /// Set the active state.
  set isActive(bool value) {
    _isActive = value;
    if (!value) {
      cancel();
    }
  }

  /// Dispose the debouncer and clean up.
  void dispose() {
    cancel();
    _isActive = false;
  }
}

/// A utility class for throttling function calls.
/// 
/// Throttling ensures that a function is called at most once per
/// specified time window, regardless of how many times it's triggered.
class Throttler {
  final Duration delay;
  DateTime? _lastRun;
  DateTime? _nextAllowed;
  bool _isActive = true;

  /// Creates a Throttler with the specified delay.
  Throttler({required this.delay});

  /// Run a function, respecting the throttle limit.
  /// If called within the throttle window, the call is skipped.
  void run(void Function() action) {
    if (!_isActive) return;
    
    final now = DateTime.now();
    
    if (_nextAllowed != null && now.isBefore(_nextAllowed!)) {
      return; // Throttled
    }
    
    action();
    _lastRun = now;
    _nextAllowed = now.add(delay);
  }

  /// Run a function immediately and schedule remaining calls.
  void runAndSchedule(void Function() action) {
    if (!_isActive) return;
    
    final now = DateTime.now();
    
    if (_nextAllowed != null && now.isBefore(_nextAllowed!)) {
      return; // Already running
    }
    
    action();
    _lastRun = now;
    _nextAllowed = now.add(delay);
  }

  /// Cancel and prevent future runs.
  void cancel() {
    _lastRun = null;
    _nextAllowed = null;
  }

  /// Whether the throttler is currently active.
  bool get isActive => _isActive;

  /// Set the active state.
  set isActive(bool value) {
    _isActive = value;
    if (!value) {
      cancel();
    }
  }

  /// Dispose the throttler and clean up.
  void dispose() {
    cancel();
    _isActive = false;
  }
}

/// A utility for combining debounce and throttle behavior.
/// 
/// Useful for search inputs where you want:
/// - Immediate response on rapid typing (throttle)
/// - Final call after typing stops (debounce)
class HybridThrottler {
  final Duration immediateInterval;
  final Duration debounceDelay;
  
  DateTime? _lastImmediateCall;
  Timer? _debounceTimer;
  VoidCallback? _pendingAction;
  bool _isActive = true;

  /// Creates a HybridThrottler.
  /// [immediateInterval]: How often to allow immediate calls.
  /// [debounceDelay]: Delay before final call after typing stops.
  HybridThrottler({
    required this.immediateInterval,
    required this.debounceDelay,
  });

  /// Run an action with hybrid throttling behavior.
  void run(void Function() action) {
    if (!_isActive) return;
    
    final now = DateTime.now();
    
    // Check if we should run immediately
    if (_lastImmediateCall == null ||
        now.difference(_lastImmediateCall!) >= immediateInterval) {
      action();
      _lastImmediateCall = now;
      _debounceTimer?.cancel();
      _pendingAction = action;
    } else {
      // Schedule for later
      _pendingAction = action;
      _debounceTimer?.cancel();
      _debounceTimer = Timer(debounceDelay, () {
        _pendingAction?.call();
        _pendingAction = null;
      });
    }
  }

  /// Cancel pending actions and disable.
  void cancel() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _pendingAction = null;
  }

  /// Whether the throttler is active.
  bool get isActive => _isActive;

  /// Set active state.
  set isActive(bool value) {
    _isActive = value;
    if (!value) {
      cancel();
    }
  }

  /// Dispose and clean up.
  void dispose() {
    cancel();
    _isActive = false;
  }
}

/// Extension methods for adding debounce support to Function types.
extension DebounceExtension on Function {
  /// Create a debounced version of this function.
  DebouncedFunction debounce(Duration delay) {
    return DebouncedFunction(this, delay);
  }

  /// Create a throttled version of this function.
  ThrottledFunction throttle(Duration delay) {
    return ThrottledFunction(this, delay);
  }
}

/// A wrapper that provides debounced execution of a function.
class DebouncedFunction {
  final Function _function;
  final Duration _delay;
  Timer? _timer;
  bool _isActive = true;

  DebouncedFunction(this._function, this._delay);

  void call([List<dynamic>? args]) {
    if (!_isActive) return;
    
    _timer?.cancel();
    _timer = Timer(_delay, () {
      if (args != null) {
        _function(args);
      } else {
        _function();
      }
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isActive => _isActive;

  set isActive(bool value) {
    _isActive = value;
    if (!value) {
      cancel();
    }
  }

  void dispose() {
    cancel();
    _isActive = false;
  }
}

/// A wrapper that provides throttled execution of a function.
class ThrottledFunction {
  final Function _function;
  final Duration _delay;
  DateTime? _lastRun;
  DateTime? _nextAllowed;
  bool _isActive = true;

  ThrottledFunction(this._function, this._delay);

  void call([List<dynamic>? args]) {
    if (!_isActive) return;
    
    final now = DateTime.now();
    
    if (_nextAllowed != null && now.isBefore(_nextAllowed!)) {
      return;
    }
    
    if (args != null) {
      _function(args);
    } else {
      _function();
    }
    
    _lastRun = now;
    _nextAllowed = now.add(_delay);
  }

  void cancel() {
    _lastRun = null;
    _nextAllowed = null;
  }

  bool get isActive => _isActive;

  set isActive(bool value) {
    _isActive = value;
    if (!value) {
      cancel();
    }
  }

  void dispose() {
    cancel();
    _isActive = false;
  }
}
