import 'package:equatable/equatable.dart';

abstract class InsightEvent extends Equatable {
  const InsightEvent();

  @override
  List<Object?> get props => [];
}

class LoadInsight extends InsightEvent {
  final int chartId;
  final String topicSlug;
  final String language;
  final String style;

  const LoadInsight({
    required this.chartId,
    required this.topicSlug,
    required this.language,
    required this.style,
  });

  @override
  List<Object?> get props => [chartId, topicSlug, language, style];
}

class RegenerateInsight extends InsightEvent {
  final int chartId;
  final String topicSlug;
  final String language;
  final String style;

  const RegenerateInsight({
    required this.chartId,
    required this.topicSlug,
    required this.language,
    required this.style,
  });

  @override
  List<Object?> get props => [chartId, topicSlug, language, style];
}
