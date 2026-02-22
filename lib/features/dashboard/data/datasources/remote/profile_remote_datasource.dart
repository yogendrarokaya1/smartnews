import 'dart:io';
import 'package:smartnews/features/dashboard/domain/entities/user_entity.dart';

abstract class IProfileRemoteDatasource {
  Future<UserEntity> getProfile();
  Future<UserEntity> updateProfile({
    String? fullName,
    String? phoneNumber,
    File? image,
    String? password,
  });
}
