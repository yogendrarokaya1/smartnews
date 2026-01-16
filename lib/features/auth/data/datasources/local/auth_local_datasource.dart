import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/services/hive/hive_service.dart';
import 'package:smartnews/features/auth/data/datasources/auth_datasource.dart';
import 'package:smartnews/features/auth/data/models/auth_hive_model.dart';

final authLocalDatasourceProvider = Provider<IAuthDataSource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDataSource(hiveService: hiveService);
});

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    return await _hiveService.registerUser(user);
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      return await _hiveService.loginUser(email, password);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      return await _hiveService.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logoutUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) async {
    try {
      return _hiveService.getUserById(authId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    try {
      return _hiveService.getUserByEmail(email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUser(AuthHiveModel user) async {
    try {
      return await _hiveService.updateUser(user);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String authId) async {
    try {
      await _hiveService.deleteUser(authId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
