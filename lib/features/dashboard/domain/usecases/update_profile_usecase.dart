import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/core/usecases/app_usecases.dart';
import 'package:smartnews/features/dashboard/data/repositories/profile_repository_impl.dart';
import 'package:smartnews/features/dashboard/domain/entities/user_entity.dart';
import 'package:smartnews/features/dashboard/domain/repositories/profile_repository.dart';

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UpdateProfileUsecase(repository);
});

class UpdateProfileParams {
  final String? fullName;
  final String? phoneNumber;
  final File? image;
  final String? password;

  const UpdateProfileParams({
    this.fullName,
    this.phoneNumber,
    this.image,
    this.password,
  });
}

class UpdateProfileUsecase
    implements UsecaseWithParms<UserEntity, UpdateProfileParams> {
  final IProfileRepository _repository;

  UpdateProfileUsecase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      fullName: params.fullName,
      phoneNumber: params.phoneNumber,
      image: params.image,
      password: params.password,
    );
  }
}
