import 'package:equatable/equatable.dart';

abstract class KundaliEvent extends Equatable {
  const KundaliEvent();

  @override
  List<Object?> get props => [];
}

class LoadKundaliData extends KundaliEvent {
  final Map<String, dynamic> profileData;
  final bool forceRefresh;

  const LoadKundaliData({required this.profileData, this.forceRefresh = false});

  @override
  List<Object?> get props => [profileData, forceRefresh];
}
