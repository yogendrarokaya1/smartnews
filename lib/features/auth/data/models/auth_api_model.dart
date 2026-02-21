import 'package:smartnews/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? password;

  AuthApiModel({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (password != null) {
      data['password'] = password;
      data['confirmPassword'] = password;
    }
    return data;
  }

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName ?? '',
      email: email ?? '',
      phoneNumber: phoneNumber,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
    );
  }
}
