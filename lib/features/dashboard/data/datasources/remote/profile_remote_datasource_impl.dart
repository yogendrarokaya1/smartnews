// import 'package:dio/dio.dart';
// import '../../models/user_model.dart';
// import 'profile_remote_datasource.dart';

// class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
//   final Dio dio;

//   ProfileRemoteDataSourceImpl(this.dio);

//   @override
//   Future<UserModel> getProfile() async {
//     final response = await dio.get('/user/profile');
//     return UserModel.fromJson(response.data);
//   }

//   @override
//   Future<UserModel> updateProfile(String name, String? avatarPath) async {
//     final Map<String, dynamic> data = {'name': name};

//     if (avatarPath != null) {
//       data['avatar'] = await MultipartFile.fromFile(avatarPath);
//     }

//     final formData = FormData.fromMap(data);

//     final response = await dio.put('/user/profile', data: formData);

//     return UserModel.fromJson(response.data);
//   }
// }

// import 'package:dio/dio.dart';
// import 'package:smartnews/features/dashboard/data/datasources/remote/profile_remote_datasource_impl.dart'
//     as ApiEndpoints;
// import 'package:smartnews/features/dashboard/data/models/user_model.dart';

// @override
// Future<UserModel> getProfile() async {
//   final response = await dio.get(ApiEndpoints.getProfile);
//   return UserModel.fromJson(response.data);
// }

// @override
// Future<UserModel> updateProfile(String name, String? avatarPath) async {
//   final data = {'name': name};

//   if (avatarPath != null) {
//     data['avatar'] = (await MultipartFile.fromFile(avatarPath)) as String;
//   }

//   final response = await dio.put(
//     ApiEndpoints.updateProfile,
//     data: FormData.fromMap(data),
//   );

//   return UserModel.fromJson(response.data);
// }
