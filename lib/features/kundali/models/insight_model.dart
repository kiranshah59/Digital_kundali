class InsightModel {
  final int id;
  final int chartId;
  final int insightTopicId;
  final String topicSlug;
  final String language;
  final String style;
  final String content;

  InsightModel({
    required this.id,
    required this.chartId,
    required this.insightTopicId,
    required this.topicSlug,
    required this.language,
    required this.style,
    required this.content,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    return InsightModel(
      id: json['id'] ?? 0,
      chartId: json['chart_id'] ?? 0,
      insightTopicId: json['insight_topic_id'] ?? 0,
      topicSlug: json['topic_slug'] ?? '',
      language: json['language'] ?? 'en',
      style: json['style'] ?? 'technical',
      content: json['content'] ?? '',
    );
  }
}
