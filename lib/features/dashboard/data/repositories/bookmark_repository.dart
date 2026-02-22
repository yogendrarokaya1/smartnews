import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/features/dashboard/data/datasources/remote/bookmark_remote_datasource.dart';
import 'package:smartnews/features/dashboard/domain/entities/bookmark_entity.dart';

// ─── Interface ────────────────────────────────────────────────────────────────

abstract class IBookmarkRepository {
  Future<Either<Failure, List<BookmarkEntity>>> getUserBookmarks();
  Future<Either<Failure, bool>> addBookmark(String newsId);
  Future<Either<Failure, bool>> removeBookmark(String newsId);
  Future<Either<Failure, bool>> isBookmarked(String newsId);
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final bookmarkRepositoryProvider = Provider<IBookmarkRepository>((ref) {
  return BookmarkRepositoryImpl(ref.read(bookmarkRemoteDatasourceProvider));
});

// ─── Implementation ───────────────────────────────────────────────────────────

class BookmarkRepositoryImpl implements IBookmarkRepository {
  final IBookmarkRemoteDatasource _datasource;

  BookmarkRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<BookmarkEntity>>> getUserBookmarks() async {
    try {
      final bookmarks = await _datasource.getUserBookmarks();
      return Right(bookmarks);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addBookmark(String newsId) async {
    try {
      await _datasource.addBookmark(newsId);
      return const Right(true);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeBookmark(String newsId) async {
    try {
      await _datasource.removeBookmark(newsId);
      return const Right(true);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookmarked(String newsId) async {
    try {
      final result = await _datasource.isBookmarked(newsId);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
