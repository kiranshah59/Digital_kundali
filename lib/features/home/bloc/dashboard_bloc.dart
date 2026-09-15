import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../kundali/data/chart_service.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      // 1. Fetch Insight Topics
      final topicsResponse = await ChartService.getInsightTopics();
      List<dynamic> topics = [];
      if (topicsResponse['success']) {
        topics = topicsResponse['data'] ?? [];
      }

      // 2. Fetch Daily Prediction if a Rashi is provided
      Map<String, dynamic>? prediction;
      if (event.rashiSlug != null && event.rashiSlug!.isNotEmpty) {
        final predictionResponse = await ChartService.getDailyPrediction(event.rashiSlug!);
        if (predictionResponse['success']) {
          prediction = predictionResponse['data'];
          if (prediction != null) {
            prediction['rashi'] = event.rashiSlug;
          }
        }
      }

      emit(DashboardLoaded(
        insightTopics: topics,
        dailyPrediction: prediction,
      ));
    } catch (e) {
      emit(DashboardError(message: 'Failed to load dashboard data.'));
    }
  }
}
