import 'package:flutter_bloc/flutter_bloc.dart';
import 'kundali_event.dart';
import 'kundali_state.dart';
import '../data/chart_service.dart';

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
      
      final chartResponse = await ChartService.getChart(profileId);
      final nepaliKundaliResponse = await ChartService.getNepaliKundali(profileId);
      
      if (chartResponse['success'] && nepaliKundaliResponse['success']) {
        emit(KundaliLoaded(
          chartData: chartResponse['data'],
          nepaliData: nepaliKundaliResponse['data'],
        ));
      } else {
        emit(KundaliError(message: 'Failed to load Kundali data'));
      }
    } catch (e) {
      emit(KundaliError(message: 'Failed to generate chart. Please try again.'));
    }
  }
}
