import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smartnews/features/dashboard/presentation/view_model/profile_state.dart';
import '../../domain/usecases/profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileViewModel extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileViewModel({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       super(const ProfileState());

  // Load user profile
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getProfileUseCase();

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (user) =>
          state = state.copyWith(isLoading: false, user: user, error: null),
    );
  }

  // Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    File? profilePicture,
  }) async {
    state = state.copyWith(isUpdating: true, updateMessage: null);

    final params = UpdateProfileParams(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
    );

    final result = await _updateProfileUseCase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          updateMessage: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(
          isUpdating: false,
          user: user,
          updateMessage: 'Profile updated successfully',
        );
        return true;
      },
    );
  }

  // Clear update message
  void clearUpdateMessage() {
    state = state.copyWith(updateMessage: null);
  }
}
