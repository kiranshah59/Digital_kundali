class GuruMessageModel {
  final int id;
  final String role; // "user" or "assistant"
  final String content;
  final String createdAt;

  GuruMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory GuruMessageModel.fromJson(Map<String, dynamic> json) {
    return GuruMessageModel(
      id: json['id'] ?? 0,
      role: json['role'] ?? 'user',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
