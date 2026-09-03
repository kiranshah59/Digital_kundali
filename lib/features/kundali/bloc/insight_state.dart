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

  const InsightLoaded({required this.insightData});

  @override
  List<Object?> get props => [insightData];
}

class InsightError extends InsightState {
  final String message;

  const InsightError({required this.message});

  @override
  List<Object?> get props => [message];
}
