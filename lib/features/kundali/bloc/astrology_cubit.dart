import 'package:flutter_bloc/flutter_bloc.dart';
import 'astrology_state.dart';
import '../data/chart_service.dart';

class AstrologyCubit extends Cubit<AstrologyState> {
  AstrologyCubit() : super(AstrologyInitial());

  Future<void> loadPersonality(int profileId, {String language = 'en', String style = 'technical'}) async {
    final currentState = state is AstrologyLoaded ? state as AstrologyLoaded : const AstrologyLoaded();
    emit(AstrologyLoading());
    try {
      final response = await ChartService.getPersonality(profileId, language: language, style: style);
      if (response['success']) {
        final data = response['data'];
        if (data['status'] == 'processing') {
          emit(const AstrologyPolling('Generating Personality Report...'));
          await Future.delayed(const Duration(seconds: 3));
          loadPersonality(profileId, language: language, style: style);
        } else {
          emit(currentState.copyWith(personality: data));
        }
      } else {
        emit(AstrologyError(
          response['message'] ?? 'Failed to load personality',
          statusCode: response['statusCode'],
        ));
      }
    } catch (e) {
      emit(AstrologyError(e.toString()));
    }
  }

  Future<void> loadDasha(int profileId, {String language = 'en', String style = 'technical'}) async {
    final currentState = state is AstrologyLoaded ? state as AstrologyLoaded : const AstrologyLoaded();
    emit(AstrologyLoading());
    try {
      final response = await ChartService.getDasha(profileId, language: language, style: style);
      if (response['success']) {
        emit(currentState.copyWith(dasha: response['data']));
      } else {
        emit(AstrologyError(
          response['message'] ?? 'Failed to load dasha',
          statusCode: response['statusCode'],
        ));
      }
    } catch (e) {
      emit(AstrologyError(e.toString()));
    }
  }

  Future<void> loadDoshaFlags(int profileId, {String language = 'en', String style = 'technical'}) async {
    final currentState = state is AstrologyLoaded ? state as AstrologyLoaded : const AstrologyLoaded();
    emit(AstrologyLoading());
    try {
      final response = await ChartService.getDoshaFlags(profileId, language: language, style: style);
      if (response['success']) {
        final data = response['data'];
        emit(currentState.copyWith(doshaFlags: data));
      } else {
        emit(AstrologyError(
          response['message'] ?? 'Failed to load dosha flags',
          statusCode: response['statusCode'],
        ));
      }
    } catch (e) {
      emit(AstrologyError(e.toString()));
    }
  }

  Future<void> loadRashi(int profileId) async {
    final currentState = state is AstrologyLoaded ? state as AstrologyLoaded : const AstrologyLoaded();
    emit(AstrologyLoading());
    try {
      final response = await ChartService.getRashi(profileId);
      if (response['success']) {
        emit(currentState.copyWith(rashi: response['data']));
      } else {
        emit(AstrologyError(
          response['message'] ?? 'Failed to load rashi',
          statusCode: response['statusCode'],
        ));
      }
    } catch (e) {
      emit(AstrologyError(e.toString()));
    }
  }
}
