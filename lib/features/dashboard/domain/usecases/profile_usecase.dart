import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<UserEntity> call() {
    return repository.getProfile();
  }
}
