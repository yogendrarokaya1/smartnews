import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? role;

  const UserEntity({
    this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    this.role,
  });

  UserEntity copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? role,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phoneNumber,
    profilePicture,
    role,
  ];
}
