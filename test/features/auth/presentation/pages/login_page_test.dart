import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/features/auth/data/repositories/auth_repository.dart';
import 'package:smartnews/features/auth/domain/entities/auth_entity.dart';
import 'package:smartnews/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartnews/features/auth/presentation/pages/login_page.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockRepository;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    registerFallbackValue(const AuthEntity(fullName: '', email: ''));
  });

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  Widget buildWidget() {
    return ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(mockRepository)],
      child: const MaterialApp(home: LoginPage()),
    );
  }

  // ── Render Tests ───────────────────────────────────────────────────────────
  group('LoginPage - Render', () {
    testWidgets('1. should render LoginPage successfully', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('2. should show email text field', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
    });

    testWidgets('3. should show password text field', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
    });

    testWidgets('4. should show Login button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('5. should show Forgot Password text', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text('Forgot Password?'), findsOneWidget);
    });
  });

  // ── Validation Tests ───────────────────────────────────────────────────────
  group('LoginPage - Validation', () {
    testWidgets('6. should show error when email is empty', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('7. should show error for invalid email format', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'notanemail');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('8. should show error when password is empty', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@example.com');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('9. should show error for short password', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      expect(find.textContaining('6 characters'), findsOneWidget);
    });
  });

  // ── Interaction Tests ──────────────────────────────────────────────────────
  group('LoginPage - Interaction', () {
    testWidgets('10. should accept email input', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextFormField).at(0), 'user@example.com');
      await tester.pumpAndSettle();
      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('11. should accept password input', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
      await tester.pump();
      // Password field exists and was interacted with
      expect(find.byType(TextFormField).at(1), findsOneWidget);
    });

    testWidgets('12. should toggle password visibility', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      // Initially shows visibility_outlined (eye open) meaning password hidden
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('13. should call login on valid form submission', (tester) async {
      when(() => mockRepository.login(any(), any())).thenAnswer(
        (_) async => Right(const AuthEntity(fullName: 'User', email: 'test@example.com')),
      );
      when(() => mockRepository.getCurrentUser()).thenAnswer(
        (_) async => Right(const AuthEntity(fullName: 'User', email: 'test@example.com')),
      );

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      verify(() => mockRepository.login('test@example.com', 'password123'))
          .called(1);
    });

    testWidgets('14. should show link to signup page', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text('Sign Up'), findsOneWidget);
    });
  });
}
