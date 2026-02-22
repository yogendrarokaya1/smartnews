import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/features/dashboard/domain/entities/user_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? phoneNumber,
    File? image,
    String? password,
  });
}
