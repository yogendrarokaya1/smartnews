import 'package:smartnews/features/dashboard/domain/entities/user_entity.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? role;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      profilePicture: json['imageUrl'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (fullName.isNotEmpty) data['fullName'] = fullName;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    return data;
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      role: role,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
      role: entity.role,
    );
  }
}
