import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/features/dashboard/domain/usecases/profile_usecase.dart';
import 'package:smartnews/features/dashboard/domain/usecases/update_profile_usecase.dart';
import 'package:smartnews/features/dashboard/presentation/view_model/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);

class ProfileViewModel extends Notifier<ProfileState> {
  late final ProfileUsecase _profileUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;

  @override
  ProfileState build() {
    _profileUsecase = ref.read(profileUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    return const ProfileState();
  }

  Future<void> getProfile() async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _profileUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: ProfileStatus.loaded, user: user),
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    File? image,
    String? password,
  }) async {
    state = state.copyWith(status: ProfileStatus.updating);

    final result = await _updateProfileUsecase(
      UpdateProfileParams(
        fullName: fullName,
        phoneNumber: phoneNumber,
        image: image,
        password: password,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: ProfileStatus.updated, user: user),
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
