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
import 'package:smartnews/features/auth/presentation/pages/signup_page.dart';

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
      child: const MaterialApp(home: SignupPage()),
    );
  }

  // ── Render Tests ───────────────────────────────────────────────────────────
  group('SignupPage - Render', () {
    testWidgets('1. should render signup page successfully', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.byType(SignupPage), findsOneWidget);
    });

    testWidgets('2. should show at least 3 text fields', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.byType(TextFormField), findsAtLeastNWidgets(3));
    });

    testWidgets('3. should show Register / Create button', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      // The button could say Register or Create Account
      final hasRegister = find.widgetWithText(ElevatedButton, 'Register')
          .evaluate()
          .isNotEmpty;
      final hasCreate = find.widgetWithText(ElevatedButton, 'Create Account')
          .evaluate()
          .isNotEmpty;
      expect(hasRegister || hasCreate, isTrue);
    });

    testWidgets('4. should show link back to login page', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.textContaining('Login'), findsAtLeastNWidgets(1));
    });
  });

  // ── Validation Tests ───────────────────────────────────────────────────────
  group('SignupPage - Validation', () {
    // Helper: tap the primary submit button
    Future<void> tapSubmit(WidgetTester tester) async {
      final registerBtn = find.widgetWithText(ElevatedButton, 'Register');
      final createBtn = find.widgetWithText(ElevatedButton, 'Create Account');
      if (registerBtn.evaluate().isNotEmpty) {
        await tester.tap(registerBtn);
      } else {
        await tester.tap(createBtn);
      }
      await tester.pumpAndSettle();
    }

    testWidgets('5. should show error when full name is empty', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tapSubmit(tester);
      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('6. should show error when email is empty', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Ram Bahadur');
      await tapSubmit(tester);
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('7. should show error when password is empty', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Ram Bahadur');
      await tester.enterText(find.byType(TextFormField).at(1), 'ram@gmail.com');
      await tapSubmit(tester);
      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('8. should show error for short password', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Ram Bahadur');
      await tester.enterText(find.byType(TextFormField).at(1), 'ram@gmail.com');
      await tester.enterText(find.byType(TextFormField).at(2), '123');
      await tapSubmit(tester);
      expect(find.textContaining('6'), findsAtLeastNWidgets(1));
    });
  });

  // ── Interaction Tests ──────────────────────────────────────────────────────
  group('SignupPage - Interaction', () {
    testWidgets('9. should accept full name input', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Ram Bahadur');
      await tester.pumpAndSettle();
      expect(find.text('Ram Bahadur'), findsOneWidget);
    });

    testWidgets('10. should accept email input', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextFormField).at(1), 'ram@gmail.com');
      await tester.pumpAndSettle();
      expect(find.text('ram@gmail.com'), findsOneWidget);
    });
  });

  // ── Registration Flow ──────────────────────────────────────────────────────
  group('SignupPage - Registration Flow', () {
    testWidgets('11. should call register on valid form submission',
        (tester) async {
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Right(true));

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'Ram Bahadur');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'ram@gmail.com');
      // Find a text field for password and confirm
      final fields = find.byType(TextFormField);
      if (fields.evaluate().length >= 3) {
        await tester.enterText(fields.at(2), 'password123');
      }
      if (fields.evaluate().length >= 4) {
        await tester.enterText(fields.at(3), 'password123');
      }
      // Accept terms if checkbox exists
      final checkboxes = find.byType(Checkbox);
      if (checkboxes.evaluate().isNotEmpty) {
        await tester.tap(checkboxes.first);
        await tester.pump();
      }

      final registerBtn = find.widgetWithText(ElevatedButton, 'Register');
      final createBtn = find.widgetWithText(ElevatedButton, 'Create Account');
      if (registerBtn.evaluate().isNotEmpty) {
        await tester.tap(registerBtn);
      } else if (createBtn.evaluate().isNotEmpty) {
        await tester.tap(createBtn);
      }
      await tester.pump();

      verify(() => mockRepository.register(any())).called(1);
    });
  });
}
