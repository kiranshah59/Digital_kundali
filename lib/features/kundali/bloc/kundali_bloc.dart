import 'package:flutter_bloc/flutter_bloc.dart';
import 'kundali_event.dart';
import 'kundali_state.dart';
import '../data/chart_service.dart';
import '../models/chart_model.dart';

class KundaliBloc extends Bloc<KundaliEvent, KundaliState> {
  KundaliBloc() : super(KundaliInitial()) {
    on<LoadKundaliData>(_onLoadKundali);
  }

  Future<void> _onLoadKundali(
    LoadKundaliData event,
    Emitter<KundaliState> emit,
  ) async {
    emit(KundaliLoading());
    try {
      final String fullName = event.profileData['full_name'] ?? 'Unknown';
      final int profileId = event.profileData['id'] ?? fullName.hashCode.abs();
      
      final chartResponse = event.forceRefresh 
          ? await ChartService.generateChart(profileId)
          : await ChartService.getChart(profileId);
          
      int chartId = profileId; // Fallback
      if (chartResponse['success']) {
        final chartModel = chartResponse['data'] as ChartModel;
        chartId = chartModel.id;
      }
      
      final nepaliKundaliResponse = await ChartService.getNepaliKundali(chartId);
      
      if (chartResponse['success']) {
        emit(KundaliLoaded(
          chartData: chartResponse['data'],
          nepaliData: nepaliKundaliResponse['success'] ? nepaliKundaliResponse['data'] : null,
          nepaliStatusCode: nepaliKundaliResponse['statusCode'],
          nepaliErrorMessage: nepaliKundaliResponse['message'],
        ));
      } else {
        emit(KundaliError(message: chartResponse['message'] ?? 'Failed to load Kundali data'));
      }
    } catch (e) {
      emit(KundaliError(message: 'Failed to generate chart. Please try again.'));
    }
  }
}
