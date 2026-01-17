import 'package:hive/hive.dart';
import 'package:smartnews/core/constants/hive_table_constant.dart';
import 'package:smartnews/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String? fullName;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? role;

  @HiveField(5)
  final String? password;

  AuthHiveModel({
    String? authId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.role,
    this.password,
  }) : authId = authId ?? const Uuid().v4();

  AuthEntity toEntity({AuthEntity? auth}) {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      role: role,
    );
  }

  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId!,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      role: entity.role,
    );
  }

  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
