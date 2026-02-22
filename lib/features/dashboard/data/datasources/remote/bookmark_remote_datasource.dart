import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/api/api_client.dart';
import 'package:smartnews/core/api/api_endpoints.dart';
import 'package:smartnews/features/dashboard/data/models/bookmark_model.dart';
import 'package:smartnews/features/dashboard/domain/entities/bookmark_entity.dart';

// ─── Interface ────────────────────────────────────────────────────────────────

abstract class IBookmarkRemoteDatasource {
  Future<List<BookmarkEntity>> getUserBookmarks();
  Future<void> addBookmark(String newsId);
  Future<void> removeBookmark(String newsId);
  Future<bool> isBookmarked(String newsId);
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final bookmarkRemoteDatasourceProvider = Provider<IBookmarkRemoteDatasource>((
  ref,
) {
  return BookmarkRemoteDatasourceImpl(ref.read(apiClientProvider));
});

// ─── Implementation ───────────────────────────────────────────────────────────

class BookmarkRemoteDatasourceImpl implements IBookmarkRemoteDatasource {
  final ApiClient _apiClient;

  BookmarkRemoteDatasourceImpl(this._apiClient);

  @override
  Future<List<BookmarkEntity>> getUserBookmarks() async {
    final response = await _apiClient.get(ApiEndpoints.bookmarks);
    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => BookmarkModel.fromJson(json).toEntity()).toList();
  }

  @override
  Future<void> addBookmark(String newsId) async {
    await _apiClient.post(ApiEndpoints.addBookmark(newsId));
  }

  @override
  Future<void> removeBookmark(String newsId) async {
    await _apiClient.delete(ApiEndpoints.removeBookmark(newsId));
  }

  @override
  Future<bool> isBookmarked(String newsId) async {
    final response = await _apiClient.get(ApiEndpoints.bookmarkStatus(newsId));
    return response.data['data']['isBookmarked'] as bool;
  }
}
