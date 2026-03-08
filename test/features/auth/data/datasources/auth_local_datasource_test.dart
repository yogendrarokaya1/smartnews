import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartnews/core/services/hive/hive_service.dart';
import 'package:smartnews/core/services/storage/user_session_service.dart';
import 'package:smartnews/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:smartnews/features/auth/data/models/auth_hive_model.dart';

class MockHiveService extends Mock implements HiveService {}

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late AuthLocalDatasource datasource;
  late MockHiveService mockHiveService;
  late MockUserSessionService mockUserSessionService;

  final tUser = AuthHiveModel(
    authId: '123',
    fullName: 'Test User',
    email: 'test@example.com',
    password: 'password123',
    phoneNumber: '9800000000',
  );

  setUpAll(() {
    registerFallbackValue(AuthHiveModel(
      authId: '0',
      fullName: '',
      email: '',
      password: '',
    ));
  });

  setUp(() {
    mockHiveService = MockHiveService();
    mockUserSessionService = MockUserSessionService();
    datasource = AuthLocalDatasource(
      hiveService: mockHiveService,
      userSessionService: mockUserSessionService,
    );
  });

  group('AuthLocalDatasource - register', () {
    test('1. should return AuthHiveModel when registration is successful', () async {
      when(() => mockHiveService.register(any())).thenAnswer((_) async => tUser);

      final result = await datasource.register(tUser);

      expect(result, tUser);
      verify(() => mockHiveService.register(tUser)).called(1);
    });
  });

  group('AuthLocalDatasource - login', () {
    test('2. should save session and return user when login is successful', () async {
      when(() => mockHiveService.login(any(), any())).thenReturn(tUser);
      when(() => mockUserSessionService.saveUserSession(
            userId: any(named: 'userId'),
            email: any(named: 'email'),
            fullName: any(named: 'fullName'),
            phoneNumber: any(named: 'phoneNumber'),
            profilePicture: any(named: 'profilePicture'),
          )).thenAnswer((_) async {});

      final result = await datasource.login('test@example.com', 'password123');

      expect(result, tUser);
      verify(() => mockHiveService.login('test@example.com', 'password123')).called(1);
      verify(() => mockUserSessionService.saveUserSession(
            userId: '123',
            email: 'test@example.com',
            fullName: 'Test User',
            phoneNumber: '9800000000',
            profilePicture: null,
          )).called(1);
    });

    test('3. should return null when login throws an exception', () async {
      when(() => mockHiveService.login(any(), any())).thenThrow(Exception());

      final result = await datasource.login('test@example.com', 'wrongpassword');

      expect(result, null);
    });
  });

  group('AuthLocalDatasource - getCurrentUser', () {
    test('4. should return user when logged in and user id exists', () async {
      when(() => mockUserSessionService.isLoggedIn()).thenReturn(true);
      when(() => mockUserSessionService.getCurrentUserId()).thenReturn('123');
      when(() => mockHiveService.getUserById('123')).thenAnswer((_) async => tUser);

      final result = await datasource.getCurrentUser();

      expect(result, tUser);
      verify(() => mockUserSessionService.isLoggedIn()).called(1);
      verify(() => mockUserSessionService.getCurrentUserId()).called(1);
      verify(() => mockHiveService.getUserById('123')).called(1);
    });

    test('5. should return null when not logged in', () async {
      when(() => mockUserSessionService.isLoggedIn()).thenReturn(false);

      final result = await datasource.getCurrentUser();

      expect(result, null);
      verifyNever(() => mockUserSessionService.getCurrentUserId());
      verifyNever(() => mockHiveService.getUserById(any()));
    });

    test('6. should return null when exception occurs', () async {
      when(() => mockUserSessionService.isLoggedIn()).thenThrow(Exception());

      final result = await datasource.getCurrentUser();

      expect(result, null);
    });
  });

  group('AuthLocalDatasource - logout', () {
    test('7. should return true when session is cleared successfully', () async {
      when(() => mockUserSessionService.clearSession()).thenAnswer((_) async {});

      final result = await datasource.logout();

      expect(result, true);
      verify(() => mockUserSessionService.clearSession()).called(1);
    });

    test('8. should return false when clearing session throws', () async {
      when(() => mockUserSessionService.clearSession()).thenThrow(Exception());

      final result = await datasource.logout();

      expect(result, false);
    });
  });

  group('AuthLocalDatasource - getUserById & getUserByEmail', () {
    test('9. should return user by id', () async {
      when(() => mockHiveService.getUserById('123')).thenAnswer((_) async => tUser);

      final result = await datasource.getUserById('123');

      expect(result, tUser);
    });

    test('10. should return user by email', () async {
      when(() => mockHiveService.getUserByEmail('test@example.com'))
          .thenAnswer((_) async => tUser);

      final result = await datasource.getUserByEmail('test@example.com');

      expect(result, tUser);
    });
  });

  group('AuthLocalDatasource - updateUser & deleteUser', () {
    test('11. should return true on successful update', () async {
      when(() => mockHiveService.updateUser(any())).thenAnswer((_) async => true);

      final result = await datasource.updateUser(tUser);

      expect(result, true);
    });

    test('12. should return true on successful delete', () async {
      when(() => mockHiveService.deleteUser('123')).thenAnswer((_) async {});

      final result = await datasource.deleteUser('123');

      expect(result, true);
    });

    test('13. should return false when delete throws exception', () async {
      when(() => mockHiveService.deleteUser('123')).thenThrow(Exception());

      final result = await datasource.deleteUser('123');

      expect(result, false);
    });
  });
}
