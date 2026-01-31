// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/usecases/profile_usecase.dart';
// import '../../domain/usecases/update_profile_usecase.dart';
// import 'profile_state.dart';

// class ProfileViewModel extends StateNotifier<ProfileState> {
//   final GetProfileUseCase getProfileUseCase;
//   final UpdateProfileUseCase updateProfileUseCase;

//   ProfileViewModel(this.getProfileUseCase, this.updateProfileUseCase)
//     : super(const ProfileState()) {
//     fetchProfile();
//   }

//   Future<void> fetchProfile() async {
//     state = state.copyWith(isLoading: true);

//     try {
//       final user = await getProfileUseCase();
//       state = state.copyWith(user: user, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(error: e.toString(), isLoading: false);
//     }
//   }

//   Future<void> updateProfile({required String name, String? avatarPath}) async {
//     state = state.copyWith(isLoading: true);

//     try {
//       final user = await updateProfileUseCase(
//         name: name,
//         avatarPath: avatarPath,
//       );

//       state = state.copyWith(user: user, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(error: e.toString(), isLoading: false);
//     }
//   }
// }
