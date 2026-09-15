import 'package:equatable/equatable.dart';
import '../models/chart_model.dart';
import '../models/nepali_kundali_model.dart';

abstract class KundaliState extends Equatable {
  const KundaliState();
  
  @override
  List<Object?> get props => [];
}

class KundaliInitial extends KundaliState {}

class KundaliLoading extends KundaliState {}

class KundaliLoaded extends KundaliState {
  final ChartModel chartData;
  final NepaliKundaliModel? nepaliData;
  final int? nepaliStatusCode;
  final String? nepaliErrorMessage;

  const KundaliLoaded({
    required this.chartData,
    this.nepaliData,
    this.nepaliStatusCode,
    this.nepaliErrorMessage,
  });

  @override
  List<Object?> get props => [chartData, nepaliData, nepaliStatusCode, nepaliErrorMessage];
}

class KundaliError extends KundaliState {
  final String message;

  const KundaliError({required this.message});

  @override
  List<Object?> get props => [message];
}
