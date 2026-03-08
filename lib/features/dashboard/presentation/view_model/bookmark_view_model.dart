import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/features/dashboard/domain/entities/bookmark_entity.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';
import 'package:smartnews/features/dashboard/domain/usecases/bookmark_usecase.dart';

// ─── State ────────────────────────────────────────────────────────────────────

enum BookmarkStatus { initial, loading, loaded, error }

class BookmarkState {
  final BookmarkStatus status;
  final List<BookmarkEntity> bookmarks;
  final Set<String> bookmarkedNewsIds; // for O(1) lookup
  final String? errorMessage;

  const BookmarkState({
    this.status = BookmarkStatus.initial,
    this.bookmarks = const [],
    this.bookmarkedNewsIds = const {},
    this.errorMessage,
  });

  BookmarkState copyWith({
    BookmarkStatus? status,
    List<BookmarkEntity>? bookmarks,
    Set<String>? bookmarkedNewsIds,
    String? errorMessage,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      bookmarkedNewsIds: bookmarkedNewsIds ?? this.bookmarkedNewsIds,
      errorMessage: errorMessage,
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final bookmarkViewModelProvider =
    NotifierProvider<BookmarkViewModel, BookmarkState>(BookmarkViewModel.new);

// ─── ViewModel ────────────────────────────────────────────────────────────────

class BookmarkViewModel extends Notifier<BookmarkState> {
  late final GetBookmarksUsecase _getBookmarks;
  late final AddBookmarkUsecase _addBookmark;
  late final RemoveBookmarkUsecase _removeBookmark;

  @override
  BookmarkState build() {
    _getBookmarks = ref.read(getBookmarksUsecaseProvider);
    _addBookmark = ref.read(addBookmarkUsecaseProvider);
    _removeBookmark = ref.read(removeBookmarkUsecaseProvider);
    return const BookmarkState();
  }

  // ─── Load bookmarks ─────────────────────────────────────────────────────────

  Future<void> loadBookmarks() async {
    state = state.copyWith(status: BookmarkStatus.loading);

    final result = await _getBookmarks();

    result.fold(
      (failure) => state = state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: failure.message,
      ),
      (bookmarks) {
        final ids = bookmarks
            .where((b) => b.news != null)
            .map((b) => b.newsId)
            .toSet();
        state = state.copyWith(
          status: BookmarkStatus.loaded,
          bookmarks: bookmarks,
          bookmarkedNewsIds: ids,
        );
      },
    );
  }

  // ─── Toggle bookmark ────────────────────────────────────────────────────────

  Future<void> toggleBookmark(NewsEntity news) async {
    final isCurrentlyBookmarked = state.bookmarkedNewsIds.contains(news.id);

    // Optimistic update
    final updatedIds = Set<String>.from(state.bookmarkedNewsIds);
    List<BookmarkEntity> updatedBookmarks = List.from(state.bookmarks);

    if (isCurrentlyBookmarked) {
      updatedIds.remove(news.id);
      updatedBookmarks.removeWhere((b) => b.newsId == news.id);
    } else {
      updatedIds.add(news.id);
    }

    state = state.copyWith(
      bookmarkedNewsIds: updatedIds,
      bookmarks: updatedBookmarks,
    );

    // API call
    final result = isCurrentlyBookmarked
        ? await _removeBookmark(news.id)
        : await _addBookmark(news.id);

    result.fold(
      (failure) {
        // Revert on failure
        final revertedIds = Set<String>.from(state.bookmarkedNewsIds);
        if (isCurrentlyBookmarked) {
          revertedIds.add(news.id);
        } else {
          revertedIds.remove(news.id);
        }
        state = state.copyWith(
          bookmarkedNewsIds: revertedIds,
          errorMessage: failure.message,
        );
        // Reload to get accurate state
        loadBookmarks();
      },
      (_) {
        // If we added, reload to get full populated bookmark data
        if (!isCurrentlyBookmarked) loadBookmarks();
      },
    );
  }

  bool isNewsBookmarked(String newsId) {
    return state.bookmarkedNewsIds.contains(newsId);
  }
}
