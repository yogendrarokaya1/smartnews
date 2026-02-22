import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/core/usecases/app_usecases.dart';
import 'package:smartnews/features/dashboard/data/repositories/news_repository.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';

// ─── Get Landing News ─────────────────────────────────────────────────────────

final getLandingNewsUsecaseProvider = Provider<GetLandingNewsUsecase>((ref) {
  return GetLandingNewsUsecase(ref.read(newsRepositoryProvider));
});

class GetLandingNewsUsecase implements UsecaseWithoutParms<List<NewsEntity>> {
  final INewsRepository _repository;
  GetLandingNewsUsecase(this._repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call() {
    return _repository.getLandingNews();
  }
}

// ─── Get Category Previews ────────────────────────────────────────────────────

final getCategoryPreviewsUsecaseProvider = Provider<GetCategoryPreviewsUsecase>(
  (ref) {
    return GetCategoryPreviewsUsecase(ref.read(newsRepositoryProvider));
  },
);

class GetCategoryPreviewsUsecase
    implements UsecaseWithoutParms<Map<String, List<NewsEntity>>> {
  final INewsRepository _repository;
  GetCategoryPreviewsUsecase(this._repository);

  @override
  Future<Either<Failure, Map<String, List<NewsEntity>>>> call() {
    return _repository.getCategoryPreviews();
  }
}

// ─── Get News By Slug ─────────────────────────────────────────────────────────

final getNewsBySlugUsecaseProvider = Provider<GetNewsBySlugUsecase>((ref) {
  return GetNewsBySlugUsecase(ref.read(newsRepositoryProvider));
});

class GetNewsBySlugUsecase implements UsecaseWithParms<NewsEntity, String> {
  final INewsRepository _repository;
  GetNewsBySlugUsecase(this._repository);

  @override
  Future<Either<Failure, NewsEntity>> call(String slug) {
    return _repository.getNewsBySlug(slug);
  }
}

final getPublishedNewsUsecaseProvider = Provider<GetPublishedNewsUsecase>((
  ref,
) {
  return GetPublishedNewsUsecase(ref.read(newsRepositoryProvider));
});

class GetPublishedNewsParams {
  final int page;
  final int limit;
  final String? category;
  final String? search;

  const GetPublishedNewsParams({
    this.page = 1,
    this.limit = 10,
    this.category,
    this.search,
  });
}

class GetPublishedNewsUsecase
    implements UsecaseWithParms<List<NewsEntity>, GetPublishedNewsParams> {
  final INewsRepository _repository;
  GetPublishedNewsUsecase(this._repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(
    GetPublishedNewsParams params,
  ) {
    return _repository.getPublishedNews(
      page: params.page,
      limit: params.limit,
      category: params.category,
      search: params.search,
    );
  }
}
