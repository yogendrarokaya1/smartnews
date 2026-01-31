import 'package:dio/dio.dart';
import '../../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(String name, String? avatarPath);
}
