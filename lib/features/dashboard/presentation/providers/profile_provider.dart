import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/profile_state.dart';
import '../view_model/profile_view_model.dart';

final profileProvider = StateNotifierProvider<ProfileViewModel, ProfileState>((
  ref,
) {
  return ProfileViewModel(
    ref.read(getProfileUseCaseProvider),
    ref.read(updateProfileUseCaseProvider),
  );
});
