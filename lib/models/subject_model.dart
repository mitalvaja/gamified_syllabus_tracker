import 'chapter_model.dart';
import 'topic_model.dart';

class SubjectModel {
  final int id;
  final String name;
  final String code;
  final String description;
  final String icon;
  final int colorHex;
  final List<ChapterModel> chapters;

  SubjectModel({
    required this.id,
    required this.name,
    this.code = '',
    this.description = '',
    this.icon = 'book',
    this.colorHex = 0xFF4F46E5,
    this.chapters = const [],
  });

  List<TopicModel> get allTopics {
    return chapters.expand((c) => c.topics).toList();
  }

  int get totalTopics => allTopics.length;
  int get completedTopics => allTopics.where((t) => t.isCompleted).length;
  int get pendingTopics => totalTopics - completedTopics;
  double get progressPercentage => totalTopics == 0 ? 0.0 : (completedTopics / totalTopics);
  int get progressPercentInt => (progressPercentage * 100).round();

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    var rawChapters = json['chapters'];
    List<ChapterModel> parsedChapters = [];
    if (rawChapters is List) {
      parsedChapters = rawChapters
          .map((item) => ChapterModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return SubjectModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? 'book',
      colorHex: json['color_hex'] is int
          ? json['color_hex']
          : int.tryParse(json['color_hex']?.toString() ?? '0xFF4F46E5') ?? 0xFF4F46E5,
      chapters: parsedChapters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'icon': icon,
      'color_hex': colorHex,
      'chapters': chapters.map((c) => c.toJson()).toList(),
    };
  }

  SubjectModel copyWith({
    int? id,
    String? name,
    String? code,
    String? description,
    String? icon,
    int? colorHex,
    List<ChapterModel>? chapters,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      chapters: chapters ?? this.chapters,
    );
  }
}
