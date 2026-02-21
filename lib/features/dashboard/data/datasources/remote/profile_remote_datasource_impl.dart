import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../models/user_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get(ApiEndpoints.whoAmI);

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }
      throw Exception(
        response.data['message'] ?? 'Failed to fetch user profile',
      );
    } on DioException catch (e) {
      throw Exception('Failed to fetch profile: ${e.message}');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    File? profilePicture,
  }) async {
    try {
      FormData formData = FormData();

      // Add text fields
      if (fullName != null) {
        formData.fields.add(MapEntry('fullName', fullName));
      }
      if (email != null) {
        formData.fields.add(MapEntry('email', email));
      }
      if (phoneNumber != null) {
        formData.fields.add(MapEntry('phoneNumber', phoneNumber));
      }

      // Add profile picture if provided
      if (profilePicture != null) {
        formData.files.add(
          MapEntry(
            'profilePicture',
            await MultipartFile.fromFile(
              profilePicture.path,
              filename: profilePicture.path.split('/').last,
            ),
          ),
        );
      }

      final response = await apiClient.uploadFile(
        ApiEndpoints.updateProfile,
        formData: formData,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Failed to update profile');
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }
}
