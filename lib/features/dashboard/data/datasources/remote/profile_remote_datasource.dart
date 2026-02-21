import 'dart:io';
import '../../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    File? profilePicture,
  });
}
