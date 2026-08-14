import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDisplayDate(DateTime? date) {
    if (date == null) return 'No target date';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatShortDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM').format(date);
  }

  static String formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return 'Anytime';
    return timeStr;
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isOverdue(DateTime? date, {bool isCompleted = false}) {
    if (date == null || isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.isBefore(today);
  }

  static bool isApproaching(DateTime? date, {int daysThreshold = 3, bool isCompleted = false}) {
    if (date == null || isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = target.difference(today).inDays;
    return difference >= 0 && difference <= daysThreshold;
  }
}
