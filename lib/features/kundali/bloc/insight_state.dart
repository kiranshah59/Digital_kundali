import 'package:equatable/equatable.dart';
import '../models/insight_model.dart';

abstract class InsightState extends Equatable {
  const InsightState();
  
  @override
  List<Object?> get props => [];
}

class InsightInitial extends InsightState {}

class InsightLoading extends InsightState {}

class InsightLoaded extends InsightState {
  final InsightModel insightData;
  final int? statusCode;

  const InsightLoaded({required this.insightData, this.statusCode});

  @override
  List<Object?> get props => [insightData, statusCode];
}

class InsightError extends InsightState {
  final String message;
  final int? statusCode;

  const InsightError({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

