import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfiles extends ProfileEvent {}

class AddProfile extends ProfileEvent {
  final Map<String, dynamic> profileData;

  const AddProfile({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}

class UpdateProfile extends ProfileEvent {
  final int profileId;
  final Map<String, dynamic> profileData;

  const UpdateProfile({required this.profileId, required this.profileData});

  @override
  List<Object?> get props => [profileId, profileData];
}

class DeleteProfile extends ProfileEvent {
  final int profileId;

  const DeleteProfile({required this.profileId});

  @override
  List<Object?> get props => [profileId];
}

class ClearProfiles extends ProfileEvent {}
