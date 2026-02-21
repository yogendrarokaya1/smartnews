class ApiEndpoints {
  // Base URL - CHANGE THIS TO YOUR BACKEND URL
  static const String baseUrl = 'http://10.0.2.2:5000'; // Android emulator
  // static const String baseUrl = 'http://localhost:5000'; // iOS simulator
  // static const String baseUrl = 'https://your-api.com'; // Production

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ══════════════════════════════════════════════════════════════════════════
  // AUTH ENDPOINTS
  // ══════════════════════════════════════════════════════════════════════════
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String whoAmI = '/api/auth/whoami';
  static const String updateProfile = '/api/auth/update-profile';

  // ══════════════════════════════════════════════════════════════════════════
  // NEWS ENDPOINTS
  // ══════════════════════════════════════════════════════════════════════════
  static const String newsLanding = '/api/news/landing';
  static const String newsCategoryPreviews = '/api/news/categories-preview';
  static const String newsPublished = '/api/news';
  static String newsBySlug(String slug) => '/api/news/slug/$slug';

  // ══════════════════════════════════════════════════════════════════════════
  // VIDEO ENDPOINTS
  // ══════════════════════════════════════════════════════════════════════════
  static const String videoLatest = '/api/videos/latest';
  static const String videoCategoryPreviews = '/api/videos/categories-preview';
  static const String videoPublished = '/api/videos';
  static String videoBySlug(String slug) => '/api/videos/slug/$slug';

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ══════════════════════════════════════════════════════════════════════════

  // Get full URL
  static String getUrl(String endpoint) => '$baseUrl$endpoint';

  // Get image URL
  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$baseUrl$path';
  }

  // Get YouTube thumbnail
  static String getYouTubeThumbnail(String videoUrl) {
    String? videoId;

    if (videoUrl.contains('youtube.com')) {
      final uri = Uri.parse(videoUrl);
      videoId = uri.queryParameters['v'];
    } else if (videoUrl.contains('youtu.be')) {
      videoId = videoUrl.split('/').last.split('?').first;
    }

    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    }
    return '';
  }
}
