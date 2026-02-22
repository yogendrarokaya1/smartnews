import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/features/dashboard/data/datasources/remote/news_remote_datasource.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';

// ─── Interface ────────────────────────────────────────────────────────────────

abstract class INewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getLandingNews();
  Future<Either<Failure, Map<String, List<NewsEntity>>>> getCategoryPreviews();
  Future<Either<Failure, List<NewsEntity>>> getPublishedNews({
    int page,
    int limit,
    String? category,
    String? search,
  });
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final newsRepositoryProvider = Provider<INewsRepository>((ref) {
  return NewsRepositoryImpl(ref.read(newsRemoteDatasourceProvider));
});

// ─── Implementation ───────────────────────────────────────────────────────────

class NewsRepositoryImpl implements INewsRepository {
  final INewsRemoteDatasource _datasource;

  NewsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<NewsEntity>>> getLandingNews() async {
    try {
      final news = await _datasource.getLandingNews();
      return Right(news);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<NewsEntity>>>>
  getCategoryPreviews() async {
    try {
      final data = await _datasource.getCategoryPreviews();
      return Right(data);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getPublishedNews({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    try {
      final news = await _datasource.getPublishedNews(
        page: page,
        limit: limit,
        category: category,
        search: search,
      );
      return Right(news);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
