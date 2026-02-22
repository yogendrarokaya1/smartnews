import 'package:smartnews/features/dashboard/domain/entities/user_entity.dart';

enum ProfileStatus { initial, loading, loaded, updating, updated, error }

class ProfileState {
  final ProfileStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading =>
      status == ProfileStatus.loading || status == ProfileStatus.updating;
}
