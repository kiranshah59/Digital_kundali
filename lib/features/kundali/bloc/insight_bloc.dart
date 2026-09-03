import 'package:flutter_bloc/flutter_bloc.dart';
import 'insight_event.dart';
import 'insight_state.dart';
import '../data/chart_service.dart';

class InsightBloc extends Bloc<InsightEvent, InsightState> {
  InsightBloc() : super(InsightInitial()) {
    on<LoadInsight>(_onLoadInsight);
    on<RegenerateInsight>(_onRegenerateInsight);
  }

  Future<void> _onLoadInsight(
    LoadInsight event,
    Emitter<InsightState> emit,
  ) async {
    emit(InsightLoading());
    try {
      final response = await ChartService.getInsight(
        event.chartId,
        event.topicSlug,
        language: event.language,
        style: event.style,
      );
      if (response['success']) {
        emit(InsightLoaded(insightData: response['data']));
      } else {
        emit(InsightError(message: response['message'] ?? 'Failed to load insight'));
      }
    } catch (e) {
      emit(InsightError(message: 'Failed to generate insight. Please try again.'));
    }
  }

  Future<void> _onRegenerateInsight(
    RegenerateInsight event,
    Emitter<InsightState> emit,
  ) async {
    emit(InsightLoading());
    try {
      final response = await ChartService.regenerateInsight(
        event.chartId,
        event.topicSlug,
        language: event.language,
        style: event.style,
      );
      if (response['success']) {
        emit(InsightLoaded(insightData: response['data']));
      } else {
        emit(InsightError(message: response['message'] ?? 'Failed to regenerate insight'));
      }
    } catch (e) {
      emit(InsightError(message: 'Failed to regenerate insight. Please try again.'));
    }
  }
}
