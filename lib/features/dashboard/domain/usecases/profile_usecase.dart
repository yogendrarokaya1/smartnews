import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/core/usecases/app_usecases.dart';
import 'package:smartnews/features/dashboard/data/repositories/profile_repository_impl.dart';
import 'package:smartnews/features/dashboard/domain/entities/user_entity.dart';
import 'package:smartnews/features/dashboard/domain/repositories/profile_repository.dart';

final profileUsecaseProvider = Provider<ProfileUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return ProfileUsecase(repository);
});

class ProfileUsecase implements UsecaseWithoutParms<UserEntity> {
  final IProfileRepository _repository;

  ProfileUsecase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call() {
    return _repository.getProfile();
  }
}
