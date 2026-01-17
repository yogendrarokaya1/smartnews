import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/core/usecases/app_usecases.dart';
import 'package:smartnews/features/auth/data/repositories/auth_repository.dart';
import 'package:smartnews/features/auth/domain/entities/auth_entity.dart';
import 'package:smartnews/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCaseParams extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;

  const RegisterUseCaseParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, phoneNumber, password];
}

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUseCase(authRepository: authRepository);
});

class RegisterUseCase implements UsecaseWithParms<bool, RegisterUseCaseParams> {
  final IAuthRepository _authRepository;

  RegisterUseCase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUseCaseParams params) {
    final authEntity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      password: params.password,
    );

    return _authRepository.registerUser(authEntity);
  }
}
