import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/api/api_client.dart';
import 'package:smartnews/core/api/api_endpoints.dart';
import 'package:smartnews/features/dashboard/data/models/news_model.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';

// ─── Interface ────────────────────────────────────────────────────────────────

abstract class INewsRemoteDatasource {
  Future<List<NewsEntity>> getLandingNews();
  Future<Map<String, List<NewsEntity>>> getCategoryPreviews();
  Future<List<NewsEntity>> getPublishedNews({
    int page,
    int limit,
    String? category,
    String? search,
  });
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final newsRemoteDatasourceProvider = Provider<INewsRemoteDatasource>((ref) {
  return NewsRemoteDatasourceImpl(ref.read(apiClientProvider));
});

// ─── Implementation ───────────────────────────────────────────────────────────

class NewsRemoteDatasourceImpl implements INewsRemoteDatasource {
  final ApiClient _apiClient;

  NewsRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<NewsEntity>> getLandingNews() async {
    final response = await _apiClient.get(ApiEndpoints.newsLanding);
    final List<dynamic> data = response.data['data']['latest'] ?? [];
    return data.map((json) => NewsModel.fromJson(json).toEntity()).toList();
  }

  @override
  Future<Map<String, List<NewsEntity>>> getCategoryPreviews() async {
    final response = await _apiClient.get(ApiEndpoints.newsCategoryPreviews);
    final Map<String, dynamic> data =
        response.data['data'] as Map<String, dynamic>;

    return data.map((category, articles) {
      final list = (articles as List<dynamic>)
          .map((json) => NewsModel.fromJson(json).toEntity())
          .toList();
      return MapEntry(category, list);
    });
  }

  @override
  Future<List<NewsEntity>> getPublishedNews({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.newsPublished,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      },
    );
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => NewsModel.fromJson(json).toEntity()).toList();
  }
}
