/// Date formatting and manipulation helpers.
class DateHelper {
  DateHelper._();

  /// Returns the current date formatted as "MMM d, yyyy".
  static String todayFormatted() {
    final now = DateTime.now();
    return _formatDate(now);
  }

  /// Returns true if [date] falls on a weekend (Saturday or Sunday).
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday;
  }

  /// Returns a date formatted as "MMM d, yyyy".
  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Returns the day name for a DateTime (e.g. "Monday").
  static String dayName(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[date.weekday - 1];
  }

  /// Returns the short day name (e.g. "Mon").
  static String shortDayName(DateTime date) {
    return dayName(date).substring(0, 3);
  }

  /// Returns true if the two dates are on the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
