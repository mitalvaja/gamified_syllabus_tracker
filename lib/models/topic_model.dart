class TopicModel {
  final int id;
  final int chapterId;
  final String name;
  final String description;
  final String priority; // 'high', 'medium', 'low'
  final String status; // 'pending', 'in_progress', 'completed'
  final DateTime? targetDate;
  final DateTime? completedAt;

  TopicModel({
    required this.id,
    required this.chapterId,
    required this.name,
    this.description = '',
    this.priority = 'medium',
    this.status = 'pending',
    this.targetDate,
    this.completedAt,
  });

  bool get isCompleted => status.toLowerCase() == 'completed' || completedAt != null;

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      chapterId: json['chapter_id'] ?? json['chapterId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? 'medium',
      status: json['status'] ?? 'pending',
      targetDate: json['target_date'] != null ? DateTime.tryParse(json['target_date'].toString()) : null,
      completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'name': name,
      'description': description,
      'priority': priority,
      'status': status,
      'target_date': targetDate?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  TopicModel copyWith({
    int? id,
    int? chapterId,
    String? name,
    String? description,
    String? priority,
    String? status,
    DateTime? targetDate,
    DateTime? completedAt,
  }) {
    return TopicModel(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      name: name ?? this.name,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      targetDate: targetDate ?? this.targetDate,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
