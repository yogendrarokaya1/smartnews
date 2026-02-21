import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileParams extends Equatable {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final File? profilePicture;

  const UpdateProfileParams({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [fullName, email, phoneNumber, profilePicture];
}

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      profilePicture: params.profilePicture,
    );
  }
}
