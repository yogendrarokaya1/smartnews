import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartnews/core/constants/hive_table_constant.dart';
import 'package:smartnews/features/auth/data/models/auth_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/${HiveTableConstant.dbName}";

    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  Future<void> closeBoxes() async {
    await Hive.close();
  }

  // Hack: =================== Auth CRUD Operations ===========================

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // Register a user
  // Register user
  Future<AuthHiveModel> registerUser(AuthHiveModel user) async {
    await _authBox.put(user.authId, user);
    return user;
  }

  // Login - find user by email and password
  AuthHiveModel? loginUser(String email, String password) {
    try {
      final user = _authBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
      );

      // 👇 SAVE SESSION
      _authBox.put(HiveTableConstant.currentUserKey, user);

      return user;
    } catch (e) {
      return null;
    }
  }

  // Get user by ID
  AuthHiveModel? getUserById(String authId) {
    return _authBox.get(authId);
  }

  // Get user by email
  AuthHiveModel? getUserByEmail(String email) {
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // Update user
  Future<bool> updateUser(AuthHiveModel user) async {
    if (_authBox.containsKey(user.authId)) {
      await _authBox.put(user.authId, user);
      return true;
    }
    return false;
  }

  // Delete user
  Future<void> deleteUser(String authId) async {
    await _authBox.delete(authId);
  }

  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      return _authBox.get(HiveTableConstant.currentUserKey);
    } catch (e) {
      return null;
    }
  }

  // logout
  Future<void> logoutUser() async {
    await _authBox.delete(HiveTableConstant.currentUserKey);
  }
}
