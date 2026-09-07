import 'package:intl/intl.dart';

/// Utility functions for date and time operations.
class DateUtils {
  /// Formats a DateTime as a relative time string (e.g., "2 hours ago").
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Formats a DateTime as a short date string (e.g., "Jan 15").
  static String shortDate(DateTime dateTime) {
    return DateFormat('MMM d').format(dateTime);
  }

  /// Formats a DateTime as a full date string (e.g., "January 15, 2024").
  static String fullDate(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy').format(dateTime);
  }

  /// Formats a DateTime as a date with time (e.g., "Jan 15, 2024, 3:30 PM").
  static String dateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy, h:mm a').format(dateTime);
  }

  /// Formats a DateTime as time only (e.g., "3:30 PM").
  static String time(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Formats a DateTime as a 24-hour time (e.g., "15:30").
  static String time24(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Checks if two dates are on the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Checks if a date is today.
  static bool isToday(DateTime dateTime) {
    return isSameDay(dateTime, DateTime.now());
  }

  /// Checks if a date is yesterday.
  static bool isYesterday(DateTime dateTime) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return isSameDay(dateTime, yesterday);
  }

  /// Gets the start of the day for a given DateTime.
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Gets the end of the day for a given DateTime.
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);
  }

  /// Gets the start of the week for a given DateTime (Monday).
  static DateTime startOfWeek(DateTime dateTime) {
    final daysFromMonday = dateTime.weekday - 1;
    return startOfDay(dateTime.subtract(Duration(days: daysFromMonday)));
  }

  /// Gets the end of the week for a given DateTime (Sunday).
  static DateTime endOfWeek(DateTime dateTime) {
    final daysUntilSunday = 7 - dateTime.weekday;
    return endOfDay(dateTime.add(Duration(days: daysUntilSunday)));
  }

  /// Gets the number of days between two dates.
  static int daysBetween(DateTime a, DateTime b) {
    final aStart = startOfDay(a);
    final bStart = startOfDay(b);
    return bStart.difference(aStart).inDays;
  }

  /// Adds days to a DateTime.
  static DateTime addDays(DateTime dateTime, int days) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day + days,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
  }

  /// Formats a duration as a human-readable string (e.g., "2h 30m").
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Parses a date string in ISO 8601 format.
  static DateTime? parseIso8601(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Formats a DateTime for API transmission (ISO 8601).
  static String toIso8601(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// Gets the day of the week as a string.
  static String dayOfWeek(DateTime dateTime) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dateTime.weekday - 1];
  }

  /// Gets the abbreviated day of the week.
  static String shortDayOfWeek(DateTime dateTime) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dateTime.weekday - 1];
  }
}
