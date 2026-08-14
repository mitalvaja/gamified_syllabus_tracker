class StreakModel {
  final int userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;
  final List<DateTime> activeDates;

  StreakModel({
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
    this.activeDates = const [],
  });

  bool get isActiveToday {
    if (lastActivityDate == null) return false;
    final now = DateTime.now();
    return lastActivityDate!.year == now.year &&
        lastActivityDate!.month == now.month &&
        lastActivityDate!.day == now.day;
  }

  String get motivationalMessage {
    if (currentStreak >= 30) return 'Legendary dedication! Unstoppable 🔥👑';
    if (currentStreak >= 14) return '2 weeks on fire! Keep crushing it 🔥';
    if (currentStreak >= 7) return "You're on fire! Keep your 7-day streak alive 🔥";
    if (currentStreak >= 3) return 'Great momentum! 3 days in a row ⚡';
    if (currentStreak >= 1) return 'Streak started! Study tomorrow to keep the flame burning 🔥';
    return 'Complete a study topic today to ignite your streak! 🚀';
  }

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    List<DateTime> parsedDates = [];
    if (json['active_dates'] is List) {
      parsedDates = (json['active_dates'] as List)
          .map((d) => DateTime.parse(d.toString()))
          .toList();
    }

    return StreakModel(
      userId: json['user_id'] ?? json['userId'] ?? 0,
      currentStreak: json['current_streak'] ?? json['currentStreak'] ?? 0,
      longestStreak: json['longest_streak'] ?? json['longestStreak'] ?? 0,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.parse(json['last_activity_date'].toString())
          : null,
      activeDates: parsedDates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_activity_date': lastActivityDate?.toIso8601String(),
      'active_dates': activeDates.map((d) => d.toIso8601String()).toList(),
    };
  }

  StreakModel copyWith({
    int? userId,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    List<DateTime>? activeDates,
  }) {
    return StreakModel(
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      activeDates: activeDates ?? this.activeDates,
    );
  }
}
