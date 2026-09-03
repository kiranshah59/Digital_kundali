import 'package:equatable/equatable.dart';

abstract class KundaliEvent extends Equatable {
  const KundaliEvent();

  @override
  List<Object?> get props => [];
}

class LoadKundaliData extends KundaliEvent {
  final Map<String, dynamic> profileData;

  const LoadKundaliData({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}
