import 'package:smartnews/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role;
  final String token;

  AuthApiModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.token,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['user']['_id'],
      fullName: json['user']['fullName'],
      email: json['user']['email'],
      phoneNumber: json['user']['phoneNumber'],
      role: json['user']['role'],
      token: json['token'],
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'user': {
        '_id': id,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
      },
      'token': token,
    };
  }

  // Info: To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: null,
      profilePicture: null,
    );
  }

  // Info: From Entity (factory function)
  factory AuthApiModel.fromEntity(
    AuthEntity entity,
    String role,
    String token,
  ) {
    return AuthApiModel(
      id: entity.authId ?? '',
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber ?? '',
      role: role,
      token: token,
    );
  }
}
