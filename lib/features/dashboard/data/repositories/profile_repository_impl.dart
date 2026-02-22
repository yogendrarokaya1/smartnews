import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/features/dashboard/data/datasources/remote/profile_remote_datasource.dart';
import 'package:smartnews/features/dashboard/data/datasources/remote/profile_remote_datasource_impl.dart';
import 'package:smartnews/features/dashboard/domain/entities/user_entity.dart';
import 'package:smartnews/features/dashboard/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final datasource = ref.read(profileRemoteDatasourceProvider);
  return ProfileRepositoryImpl(datasource);
});

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDatasource _datasource;

  ProfileRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final user = await _datasource.getProfile();
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? fullName,
    String? phoneNumber,
    File? image,
    String? password,
  }) async {
    try {
      final user = await _datasource.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        image: image,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
