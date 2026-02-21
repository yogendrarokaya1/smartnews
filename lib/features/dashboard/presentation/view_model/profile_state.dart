import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final UserEntity? user;
  final String? error;
  final bool isUpdating;
  final String? updateMessage;

  const ProfileState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isUpdating = false,
    this.updateMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? error,
    bool? isUpdating,
    String? updateMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      isUpdating: isUpdating ?? this.isUpdating,
      updateMessage: updateMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    user,
    error,
    isUpdating,
    updateMessage,
  ];
}
