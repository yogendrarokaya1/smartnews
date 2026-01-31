// import '../../domain//entities/user_entity.dart';

// class ProfileState {
//   final bool isLoading;
//   final UserEntity? user;
//   final String? error;

//   const ProfileState({this.isLoading = false, this.user, this.error});

//   ProfileState copyWith({bool? isLoading, UserEntity? user, String? error}) {
//     return ProfileState(
//       isLoading: isLoading ?? this.isLoading,
//       user: user ?? this.user,
//       error: error,
//     );
//   }
// }

import '../../domain/entities/user_entity.dart';

class ProfileState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;

  const ProfileState({this.isLoading = false, this.user, this.error});

  ProfileState copyWith({bool? isLoading, UserEntity? user, String? error}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}
