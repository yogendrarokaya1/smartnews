import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String phoneNumber;
  final String fullName;
  final String role;
  final String? profilePicture;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    this.profilePicture,
    required this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  String get initials {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
  }

  @override
  List<Object?> get props => [
    id,
    email,
    phoneNumber,
    fullName,
    role,
    profilePicture,
    createdAt,
  ];
}
