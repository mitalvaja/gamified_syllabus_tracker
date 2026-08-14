class BadgeModel {
  final int id;
  final String code;
  final String name;
  final String description;
  final String iconEmoji;
  final String category; // 'topic', 'streak', 'quiz', 'level'
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int requiredCount;
  final int currentProgress;

  BadgeModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.iconEmoji,
    this.category = 'topic',
    this.isUnlocked = false,
    this.unlockedAt,
    this.requiredCount = 1,
    this.currentProgress = 0,
  });

  double get progressFraction => requiredCount == 0 ? 0.0 : (currentProgress / requiredCount).clamp(0.0, 1.0);

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconEmoji: json['icon'] ?? json['iconEmoji'] ?? '🏆',
      category: json['category'] ?? 'topic',
      isUnlocked: json['is_unlocked'] == true || json['isUnlocked'] == true || json['unlocked_at'] != null,
      unlockedAt: json['unlocked_at'] != null ? DateTime.parse(json['unlocked_at'].toString()) : null,
      requiredCount: json['required_count'] ?? json['requiredCount'] ?? 1,
      currentProgress: json['current_progress'] ?? json['currentProgress'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'icon': iconEmoji,
      'category': category,
      'is_unlocked': isUnlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'required_count': requiredCount,
      'current_progress': currentProgress,
    };
  }

  BadgeModel copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    String? iconEmoji,
    String? category,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? requiredCount,
    int? currentProgress,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      category: category ?? this.category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      requiredCount: requiredCount ?? this.requiredCount,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }
}
