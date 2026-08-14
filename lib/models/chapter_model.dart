import 'topic_model.dart';

class ChapterModel {
  final int id;
  final int subjectId;
  final String name;
  final String description;
  final DateTime? targetDate;
  final List<TopicModel> topics;

  ChapterModel({
    required this.id,
    required this.subjectId,
    required this.name,
    this.description = '',
    this.targetDate,
    this.topics = const [],
  });

  int get totalTopics => topics.length;
  int get completedTopics => topics.where((t) => t.isCompleted).length;
  double get progressPercentage => totalTopics == 0 ? 0.0 : (completedTopics / totalTopics);
  bool get isCompleted => totalTopics > 0 && completedTopics == totalTopics;

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    var rawTopics = json['topics'];
    List<TopicModel> parsedTopics = [];
    if (rawTopics is List) {
      parsedTopics = rawTopics
          .map((item) => TopicModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return ChapterModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      subjectId: json['subject_id'] ?? json['subjectId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      targetDate: json['target_date'] != null ? DateTime.tryParse(json['target_date'].toString()) : null,
      topics: parsedTopics,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'name': name,
      'description': description,
      'target_date': targetDate?.toIso8601String(),
      'topics': topics.map((t) => t.toJson()).toList(),
    };
  }

  ChapterModel copyWith({
    int? id,
    int? subjectId,
    String? name,
    String? description,
    DateTime? targetDate,
    List<TopicModel>? topics,
  }) {
    return ChapterModel(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      name: name ?? this.name,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      topics: topics ?? this.topics,
    );
  }
}
