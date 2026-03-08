import 'dart:io';

Future<void> main() async {
  final testFiles = [
    'test/features/auth/data/repositories/auth_repository_test.dart',
    'test/features/auth/presentation/pages/login_page_test.dart',
    'test/features/auth/presentation/pages/signup_page_test.dart',
    'test/features/dashboard/presentation/pages/bookmark_screen_test.dart',
    'test/features/dashboard/presentation/pages/home_screen_test.dart',
    'test/features/dashboard/presentation/pages/profile_screen_test.dart',
    'test/features/dashboard/data/repositories/news_repository_test.dart',
  ];

  for (final file in testFiles) {
    print('Running tests in $file...');
    final result = await Process.run('flutter', ['test', '--reporter', 'expanded', file]);
    if (result.exitCode == 0) {
      print('✅ $file PASSED');
    } else {
      print('❌ $file FAILED');
      print(result.stdout);
      print(result.stderr);
    }
    print('-' * 40);
  }
}
