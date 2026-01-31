class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.0.2.2:5000';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth ============
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';

  // ============ Profile ============
  static const String getProfile = '/api/auth/whoami';
  static const String updateProfile = '/api/auth/update-profile';
}
