class AnnouncementModel {
  final int id;
  final int adminId;
  final String authorName;
  final String title;
  final String content;
  final String tag;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    this.adminId = 1,
    this.authorName = 'Faculty Admin',
    required this.title,
    required this.content,
    this.tag = 'General',
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      adminId: json['admin_id'] ?? json['adminId'] ?? 1,
      authorName: json['author_name'] ?? json['authorName'] ?? 'Faculty Admin',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tag: json['tag'] ?? 'General',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'author_name': authorName,
      'title': title,
      'content': content,
      'tag': tag,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
