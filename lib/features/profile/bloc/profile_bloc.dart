import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../data/profile_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfiles>(_onLoadProfiles);
    on<AddProfile>(_onAddProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteProfile>(_onDeleteProfile);
    on<ClearProfiles>(_onClearProfiles);
  }

  Future<void> _onClearProfiles(
    ClearProfiles event,
    Emitter<ProfileState> emit,
  ) async {
    await ProfileService.clearProfiles();
    emit(ProfileInitial());
  }

  Future<void> _onLoadProfiles(
    LoadProfiles event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await ProfileService.getProfiles();
      if (response['success']) {
        emit(ProfileLoaded(profiles: response['data']));
      } else {
        emit(ProfileError(message: response['message'] ?? 'Failed to load profiles'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onAddProfile(
    AddProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await ProfileService.addProfile(
        fullName: event.profileData['full_name'],
        dateOfBirth: event.profileData['date_of_birth'],
        timeOfBirth: event.profileData['time_of_birth'],
        birthPlaceName: event.profileData['birth_place_name'],
      );
      if (response['success']) {
        emit(ProfileOperationSuccess(message: response['message'] ?? 'Profile added successfully'));
        add(LoadProfiles()); // Reload profiles
      } else {
        emit(ProfileError(message: response['message'] ?? 'Failed to add profile'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await ProfileService.updateProfile(
        id: event.profileId,
        fullName: event.profileData['full_name'],
        dateOfBirth: event.profileData['date_of_birth'],
        timeOfBirth: event.profileData['time_of_birth'],
        birthPlaceName: event.profileData['birth_place_name'],
        originalProfile: event.profileData['original_profile'],
      );
      if (response['success']) {
        emit(ProfileOperationSuccess(message: response['message'] ?? 'Profile updated successfully'));
        add(LoadProfiles()); // Reload profiles
      } else {
        emit(ProfileError(message: response['message'] ?? 'Failed to update profile'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onDeleteProfile(
    DeleteProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final response = await ProfileService.deleteProfile(event.profileId);
      if (response['success']) {
        emit(ProfileOperationSuccess(message: response['message'] ?? 'Profile deleted successfully'));
        add(LoadProfiles()); // Reload profiles
      } else {
        emit(ProfileError(message: response['message'] ?? 'Failed to delete profile'));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
