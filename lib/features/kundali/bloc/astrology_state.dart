import 'package:equatable/equatable.dart';

abstract class AstrologyState extends Equatable {
  const AstrologyState();

  @override
  List<Object?> get props => [];
}

class AstrologyInitial extends AstrologyState {}

class AstrologyLoading extends AstrologyState {}

class AstrologyPolling extends AstrologyState {
  final String message;
  const AstrologyPolling(this.message);

  @override
  List<Object?> get props => [message];
}

class AstrologyLoaded extends AstrologyState {
  final Map<String, dynamic>? personality;
  final Map<String, dynamic>? dasha;
  final Map<String, dynamic>? doshaFlags;
  final Map<String, dynamic>? rashi;

  const AstrologyLoaded({
    this.personality,
    this.dasha,
    this.doshaFlags,
    this.rashi,
  });

  AstrologyLoaded copyWith({
    Map<String, dynamic>? personality,
    Map<String, dynamic>? dasha,
    Map<String, dynamic>? doshaFlags,
    Map<String, dynamic>? rashi,
  }) {
    return AstrologyLoaded(
      personality: personality ?? this.personality,
      dasha: dasha ?? this.dasha,
      doshaFlags: doshaFlags ?? this.doshaFlags,
      rashi: rashi ?? this.rashi,
    );
  }

  @override
  List<Object?> get props => [personality, dasha, doshaFlags, rashi];
}

class AstrologyError extends AstrologyState {
  final String message;
  final int? statusCode;

  const AstrologyError(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}
