class UserModel {
  final int id;
  final String name;
  final String email;
  final String className;
  final String role; // 'student' or 'admin'
  final int totalXp;
  final int currentLevel;
  final int currentStreak;
  final int longestStreak;
  final int badgesEarned;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.className,
    this.role = 'student',
    this.totalXp = 0,
    this.currentLevel = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.badgesEarned = 0,
    this.createdAt,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      className: json['class'] ?? json['className'] ?? 'BCA Sem V',
      role: json['role'] ?? 'student',
      totalXp: json['total_xp'] ?? json['totalXp'] ?? 0,
      currentLevel: json['current_level'] ?? json['currentLevel'] ?? 1,
      currentStreak: json['current_streak'] ?? json['currentStreak'] ?? 0,
      longestStreak: json['longest_streak'] ?? json['longestStreak'] ?? 0,
      badgesEarned: json['badges_earned'] ?? json['badgesEarned'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'class': className,
      'role': role,
      'total_xp': totalXp,
      'current_level': currentLevel,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'badges_earned': badgesEarned,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? className,
    String? role,
    int? totalXp,
    int? currentLevel,
    int? currentStreak,
    int? longestStreak,
    int? badgesEarned,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      className: className ?? this.className,
      role: role ?? this.role,
      totalXp: totalXp ?? this.totalXp,
      currentLevel: currentLevel ?? this.currentLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      badgesEarned: badgesEarned ?? this.badgesEarned,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
