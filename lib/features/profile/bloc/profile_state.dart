import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final List<dynamic> profiles;

  const ProfileLoaded({required this.profiles});

  @override
  List<Object?> get props => [profiles];
}

class ProfileOperationSuccess extends ProfileState {
  final String message;

  const ProfileOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
