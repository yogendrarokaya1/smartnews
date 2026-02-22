import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // ── Change these two when switching devices ────────────────────────────────
  static const bool isPhysicalDevice =
      true; // true = real phone, false = emulator
  static const String _ipAddress = '192.168.1.67'; // your PC's WiFi IP
  static const int _port = 5000;

  // ── Auto-detects correct host ──────────────────────────────────────────────
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get baseUrl => 'http://$_host:$_port';

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
  // BOOKMARK ENDPOINTS
  // ══════════════════════════════════════════════════════════════════════════
  static const String bookmarks = '/api/bookmarks';
  static String addBookmark(String newsId) => '/api/bookmarks/$newsId';
  static String removeBookmark(String newsId) => '/api/bookmarks/$newsId';
  static String bookmarkStatus(String newsId) =>
      '/api/bookmarks/$newsId/status';

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ══════════════════════════════════════════════════════════════════════════

  static String getUrl(String endpoint) => '$baseUrl$endpoint';

  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$baseUrl$path';
  }

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
