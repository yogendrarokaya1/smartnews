import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';
import 'package:smartnews/features/dashboard/domain/usecases/news_usecase.dart';

// ─── State ────────────────────────────────────────────────────────────────────

enum NewsStatus { initial, loading, loaded, error }

class NewsState {
  final NewsStatus status;
  final List<NewsEntity> latestNews;
  final Map<String, List<NewsEntity>> categoryPreviews;
  final String? errorMessage;

  const NewsState({
    this.status = NewsStatus.initial,
    this.latestNews = const [],
    this.categoryPreviews = const {},
    this.errorMessage,
  });

  NewsState copyWith({
    NewsStatus? status,
    List<NewsEntity>? latestNews,
    Map<String, List<NewsEntity>>? categoryPreviews,
    String? errorMessage,
  }) {
    return NewsState(
      status: status ?? this.status,
      latestNews: latestNews ?? this.latestNews,
      categoryPreviews: categoryPreviews ?? this.categoryPreviews,
      errorMessage: errorMessage,
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final newsViewModelProvider = NotifierProvider<NewsViewModel, NewsState>(
  NewsViewModel.new,
);

// ─── ViewModel ────────────────────────────────────────────────────────────────

class NewsViewModel extends Notifier<NewsState> {
  late final GetLandingNewsUsecase _getLandingNews;
  late final GetCategoryPreviewsUsecase _getCategoryPreviews;

  @override
  NewsState build() {
    _getLandingNews = ref.read(getLandingNewsUsecaseProvider);
    _getCategoryPreviews = ref.read(getCategoryPreviewsUsecaseProvider);
    return const NewsState();
  }

  Future<void> loadHomeData() async {
    state = state.copyWith(status: NewsStatus.loading);

    // Fetch both in parallel
    final results = await Future.wait([
      _getLandingNews(),
      _getCategoryPreviews(),
    ]);

    final landingResult = results[0] as dynamic;
    final categoryResult = results[1] as dynamic;

    // Check for errors
    String? error;
    List<NewsEntity> latest = [];
    Map<String, List<NewsEntity>> categories = {};

    landingResult.fold(
      (failure) => error = failure.message,
      (news) => latest = news as List<NewsEntity>,
    );

    categoryResult.fold(
      (failure) => error ??= failure.message,
      (data) => categories = data as Map<String, List<NewsEntity>>,
    );

    if (error != null) {
      state = state.copyWith(status: NewsStatus.error, errorMessage: error);
    } else {
      state = state.copyWith(
        status: NewsStatus.loaded,
        latestNews: latest,
        categoryPreviews: categories,
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
