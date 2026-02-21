import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String phoneNumber;
  final String fullName;
  final String role;
  final String? profilePicture;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    this.profilePicture,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? 'user',
      profilePicture: json['profilePicture'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'role': role,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      phoneNumber: phoneNumber,
      fullName: fullName,
      role: role,
      profilePicture: profilePicture,
      createdAt: createdAt,
    );
  }
}
