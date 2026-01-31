import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserEntity> call({required String name, String? avatarPath}) {
    return repository.updateProfile(name: name, avatarPath: avatarPath);
  }
}
