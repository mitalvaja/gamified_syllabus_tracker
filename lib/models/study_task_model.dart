class StudyTaskModel {
  final int id;
  final int userId;
  final int? topicId;
  final String subjectName;
  final String topicName;
  final DateTime date;
  final String startTime;
  final int durationMinutes;
  final String priority; // 'high', 'medium', 'low'
  final String status; // 'pending', 'completed'
  final DateTime? completedAt;

  StudyTaskModel({
    required this.id,
    required this.userId,
    this.topicId,
    required this.subjectName,
    required this.topicName,
    required this.date,
    this.startTime = '10:00 AM',
    this.durationMinutes = 45,
    this.priority = 'medium',
    this.status = 'pending',
    this.completedAt,
  });

  bool get isCompleted => status.toLowerCase() == 'completed' || completedAt != null;

  factory StudyTaskModel.fromJson(Map<String, dynamic> json) {
    return StudyTaskModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] ?? json['userId'] ?? 0,
      topicId: json['topic_id'] ?? json['topicId'],
      subjectName: json['subject_name'] ?? json['subjectName'] ?? '',
      topicName: json['topic_name'] ?? json['topicName'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date'].toString()) : DateTime.now(),
      startTime: json['start_time'] ?? json['startTime'] ?? '10:00 AM',
      durationMinutes: json['duration'] ?? json['durationMinutes'] ?? 45,
      priority: json['priority'] ?? 'medium',
      status: json['status'] ?? 'pending',
      completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'topic_id': topicId,
      'subject_name': subjectName,
      'topic_name': topicName,
      'date': date.toIso8601String(),
      'start_time': startTime,
      'duration': durationMinutes,
      'priority': priority,
      'status': status,
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  StudyTaskModel copyWith({
    int? id,
    int? userId,
    int? topicId,
    String? subjectName,
    String? topicName,
    DateTime? date,
    String? startTime,
    int? durationMinutes,
    String? priority,
    String? status,
    DateTime? completedAt,
  }) {
    return StudyTaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      topicId: topicId ?? this.topicId,
      subjectName: subjectName ?? this.subjectName,
      topicName: topicName ?? this.topicName,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
