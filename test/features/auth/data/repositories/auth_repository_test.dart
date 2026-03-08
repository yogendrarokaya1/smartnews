import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/core/services/connectivity/network_info.dart';
import 'package:smartnews/features/auth/data/datasources/auth_datasource.dart';
import 'package:smartnews/features/auth/data/models/auth_api_model.dart';
import 'package:smartnews/features/auth/data/models/auth_hive_model.dart';
import 'package:smartnews/features/auth/data/repositories/auth_repository.dart';
import 'package:smartnews/features/auth/domain/entities/auth_entity.dart';

class MockAuthLocalDatasource extends Mock implements IAuthLocalDataSource {}

class MockAuthRemoteDatasource extends Mock implements IAuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthRepository repository;
  late MockAuthLocalDatasource mockLocal;
  late MockAuthRemoteDatasource mockRemote;
  late MockNetworkInfo mockNetwork;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  final tApiModel = AuthApiModel(fullName: 'Test User', email: tEmail);
  final tHiveModel = AuthHiveModel(
    fullName: 'Test User',
    email: tEmail,
    password: tPassword,
  );
  final tEntity = AuthEntity(
    fullName: 'Test User',
    email: tEmail,
    password: tPassword,
  );

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    registerFallbackValue(AuthEntity(fullName: '', email: ''));
    registerFallbackValue(AuthApiModel(fullName: '', email: ''));
    registerFallbackValue(AuthHiveModel(fullName: '', email: ''));
  });

  setUp(() {
    mockLocal = MockAuthLocalDatasource();
    mockRemote = MockAuthRemoteDatasource();
    mockNetwork = MockNetworkInfo();
    repository = AuthRepository(
      authDatasource: mockLocal,
      authRemoteDataSource: mockRemote,
      networkInfo: mockNetwork,
    );
  });

  // ── Login ──────────────────────────────────────────────────────────────────
  group('AuthRepository - login', () {
    test('1. should return AuthEntity on successful online login', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemote.login(tEmail, tPassword),
      ).thenAnswer((_) async => tApiModel);

      final result = await repository.login(tEmail, tPassword);

      expect(result, isA<Right<Failure, AuthEntity>>());
      verify(() => mockRemote.login(tEmail, tPassword)).called(1);
    });

    test('2. should return failure when online login returns null', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemote.login(tEmail, tPassword),
      ).thenAnswer((_) async => null);

      final result = await repository.login(tEmail, tPassword);

      expect(result, isA<Left<Failure, AuthEntity>>());
    });

    test('3. should use local datasource when offline', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocal.login(tEmail, tPassword),
      ).thenAnswer((_) async => tHiveModel);

      final result = await repository.login(tEmail, tPassword);

      expect(result, isA<Right<Failure, AuthEntity>>());
      verify(() => mockLocal.login(tEmail, tPassword)).called(1);
      verifyNever(() => mockRemote.login(any(), any()));
    });

    test('4. should return failure when offline login returns null', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocal.login(tEmail, tPassword),
      ).thenAnswer((_) async => null);

      final result = await repository.login(tEmail, tPassword);

      expect(result, isA<Left<Failure, AuthEntity>>());
    });
  });

  // ── Register ───────────────────────────────────────────────────────────────
  group('AuthRepository - register', () {
    test('5. should return true on successful online registration', () async {
      when(() => mockNetwork.isConnected).thenAnswer((_) async => true);
      when(() => mockRemote.register(any())).thenAnswer((_) async => tApiModel);

      final result = await repository.register(tEntity);

      expect(result, const Right<Failure, bool>(true));
    });

    test(
      '6. should return failure when email already exists offline',
      () async {
        when(() => mockNetwork.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocal.getUserByEmail(tEmail),
        ).thenAnswer((_) async => tHiveModel);

        final result = await repository.register(tEntity);

        expect(result, isA<Left<Failure, bool>>());
        final failure = (result as Left).value as LocalDatabaseFailure;
        expect(failure.message, 'Email already registered');
      },
    );
  });

  // ── Logout ─────────────────────────────────────────────────────────────────
  group('AuthRepository - logout', () {
    test('7. should return true on successful logout', () async {
      when(() => mockLocal.logout()).thenAnswer((_) async => true);

      final result = await repository.logout();

      expect(result, isA<Right<Failure, bool>>());
      verify(() => mockLocal.logout()).called(1);
    });

    test('8. should return failure when logout throws exception', () async {
      when(() => mockLocal.logout()).thenThrow(Exception('Storage error'));

      final result = await repository.logout();

      expect(result, isA<Left<Failure, bool>>());
    });
  });

  // ── getCurrentUser ─────────────────────────────────────────────────────────
  group('AuthRepository - getCurrentUser', () {
    test(
      '9. should return AuthEntity when user exists in local storage',
      () async {
        when(
          () => mockLocal.getCurrentUser(),
        ).thenAnswer((_) async => tHiveModel);

        final result = await repository.getCurrentUser();

        expect(result, isA<Right<Failure, AuthEntity>>());
      },
    );

    test('10. should return failure when no user is logged in', () async {
      when(() => mockLocal.getCurrentUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result, isA<Left<Failure, AuthEntity>>());
      final failure = (result as Left).value as LocalDatabaseFailure;
      expect(failure.message, 'No user logged in');
    });
  });
}
