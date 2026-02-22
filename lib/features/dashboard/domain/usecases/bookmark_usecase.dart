import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/core/usecases/app_usecases.dart';
import 'package:smartnews/features/dashboard/data/repositories/bookmark_repository.dart';
import 'package:smartnews/features/dashboard/domain/entities/bookmark_entity.dart';

// ─── Get User Bookmarks ───────────────────────────────────────────────────────

final getBookmarksUsecaseProvider = Provider<GetBookmarksUsecase>((ref) {
  return GetBookmarksUsecase(ref.read(bookmarkRepositoryProvider));
});

class GetBookmarksUsecase implements UsecaseWithoutParms<List<BookmarkEntity>> {
  final IBookmarkRepository _repository;
  GetBookmarksUsecase(this._repository);

  @override
  Future<Either<Failure, List<BookmarkEntity>>> call() {
    return _repository.getUserBookmarks();
  }
}

// ─── Add Bookmark ─────────────────────────────────────────────────────────────

final addBookmarkUsecaseProvider = Provider<AddBookmarkUsecase>((ref) {
  return AddBookmarkUsecase(ref.read(bookmarkRepositoryProvider));
});

class AddBookmarkUsecase implements UsecaseWithParms<bool, String> {
  final IBookmarkRepository _repository;
  AddBookmarkUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String newsId) {
    return _repository.addBookmark(newsId);
  }
}

// ─── Remove Bookmark ──────────────────────────────────────────────────────────

final removeBookmarkUsecaseProvider = Provider<RemoveBookmarkUsecase>((ref) {
  return RemoveBookmarkUsecase(ref.read(bookmarkRepositoryProvider));
});

class RemoveBookmarkUsecase implements UsecaseWithParms<bool, String> {
  final IBookmarkRepository _repository;
  RemoveBookmarkUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String newsId) {
    return _repository.removeBookmark(newsId);
  }
}

// ─── Check Bookmark Status ────────────────────────────────────────────────────

final isBookmarkedUsecaseProvider = Provider<IsBookmarkedUsecase>((ref) {
  return IsBookmarkedUsecase(ref.read(bookmarkRepositoryProvider));
});

class IsBookmarkedUsecase implements UsecaseWithParms<bool, String> {
  final IBookmarkRepository _repository;
  IsBookmarkedUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String newsId) {
    return _repository.isBookmarked(newsId);
  }
}
