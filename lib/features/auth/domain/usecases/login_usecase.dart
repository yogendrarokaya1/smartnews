import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/core/usecases/app_usecases.dart';
import 'package:smartnews/features/auth/data/repositories/auth_repository.dart';
import 'package:smartnews/features/auth/domain/entities/auth_entity.dart';
import 'package:smartnews/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUseCaseParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUseCase(authRepository: authRepository);
});

class LoginUseCase implements UsecaseWithParms<AuthEntity, LoginUseCaseParams> {
  final IAuthRepository _authRepository;

  LoginUseCase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(LoginUseCaseParams params) {
    return _authRepository.loginUser(params.email, params.password);
  }
}
