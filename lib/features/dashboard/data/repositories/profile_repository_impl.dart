import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<UserEntity> updateProfile({required String name, String? avatarPath}) {
    return remoteDataSource.updateProfile(name, avatarPath);
  }
}
