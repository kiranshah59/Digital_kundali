import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<dynamic> insightTopics;
  final Map<String, dynamic>? dailyPrediction;

  const DashboardLoaded({
    required this.insightTopics,
    this.dailyPrediction,
  });

  @override
  List<Object?> get props => [insightTopics, dailyPrediction];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
