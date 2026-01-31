class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://10.0.2.2:5000';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String whoami = '/api/auth/whoami';
  static const String updateprofile = '/api/auth/update-profile';

  // ============ User Endpoints ============
  static const String user = '/users';
  static String userById(String id) => '/users/$id';
}
