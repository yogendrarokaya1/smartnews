import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/api/api_client.dart';
import 'package:smartnews/core/api/api_endpoints.dart';
import 'package:smartnews/features/dashboard/data/datasources/remote/profile_remote_datasource.dart';
import 'package:smartnews/features/dashboard/data/models/user_model.dart';
import 'package:smartnews/features/dashboard/domain/entities/user_entity.dart';

final profileRemoteDatasourceProvider = Provider<IProfileRemoteDatasource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  return ProfileRemoteDatasourceImpl(apiClient);
});

class ProfileRemoteDatasourceImpl implements IProfileRemoteDatasource {
  final ApiClient _apiClient;

  ProfileRemoteDatasourceImpl(this._apiClient);

  @override
  Future<UserEntity> getProfile() async {
    final response = await _apiClient.get(ApiEndpoints.whoAmI);
    final user = UserModel.fromJson(response.data['data']);
    return user.toEntity();
  }

  @override
  Future<UserEntity> updateProfile({
    String? fullName,
    String? phoneNumber,
    File? image,
    String? password,
  }) async {
    final formData = FormData();

    if (fullName != null && fullName.isNotEmpty) {
      formData.fields.add(MapEntry('fullName', fullName));
    }
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      formData.fields.add(MapEntry('phoneNumber', phoneNumber));
    }
    if (password != null && password.isNotEmpty) {
      formData.fields.add(MapEntry('password', password));
    }
    if (image != null) {
      final fileName = image.path.split('/').last;
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(image.path, filename: fileName),
        ),
      );
    }

    final response = await _apiClient.dio.put(
      ApiEndpoints.updateProfile,
      data: formData,
    );

    final user = UserModel.fromJson(response.data['data']);
    return user.toEntity();
  }
}
