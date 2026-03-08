import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smartnews/core/error/failures.dart';
import 'package:smartnews/features/dashboard/data/datasources/remote/news_remote_datasource.dart';
import 'package:smartnews/features/dashboard/data/repositories/news_repository.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';

// ── Mocks ──────────────────────────────────────────────────────────────────
class MockNewsRemoteDatasource extends Mock implements INewsRemoteDatasource {}

void main() {
  late NewsRepositoryImpl repository;
  late MockNewsRemoteDatasource mockDatasource;

  final tNews = NewsEntity(
    id: '1',
    title: 'Test News',
    slug: 'test-news',
    summary: 'A test summary',
    content: 'Full content',
    category: 'national',
    tags: const ['test'],
    authorId: 'author1',
    status: 'published',
    isFeatured: false,
    views: 100,
    publishedAt: DateTime(2026, 1, 1),
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockDatasource = MockNewsRemoteDatasource();
    repository = NewsRepositoryImpl(mockDatasource);
  });

  // ── getLandingNews ──────────────────────────────────────────────────────────
  group('NewsRepository - getLandingNews', () {
    test('1. should return list of news on success', () async {
      when(() => mockDatasource.getLandingNews())
          .thenAnswer((_) async => [tNews]);

      final result = await repository.getLandingNews();

      expect(result, isA<Right<Failure, List<NewsEntity>>>());
      final news = (result as Right).value as List<NewsEntity>;
      expect(news.length, 1);
      expect(news.first.title, 'Test News');
    });

    test('2. should return failure when datasource throws', () async {
      when(() => mockDatasource.getLandingNews())
          .thenThrow(Exception('Network error'));

      final result = await repository.getLandingNews();

      expect(result, isA<Left<Failure, List<NewsEntity>>>());
    });

    test('3. should return empty list when no news available', () async {
      when(() => mockDatasource.getLandingNews())
          .thenAnswer((_) async => []);

      final result = await repository.getLandingNews();

      expect(result, isA<Right<Failure, List<NewsEntity>>>());
      final news = (result as Right).value as List<NewsEntity>;
      expect(news.isEmpty, isTrue);
    });
  });

  // ── getCategoryPreviews ─────────────────────────────────────────────────────
  group('NewsRepository - getCategoryPreviews', () {
    test('4. should return map of category news on success', () async {
      when(() => mockDatasource.getCategoryPreviews())
          .thenAnswer((_) async => {'national': [tNews]});

      final result = await repository.getCategoryPreviews();

      expect(result, isA<Right<Failure, Map<String, List<NewsEntity>>>>());
      final data = (result as Right).value as Map<String, List<NewsEntity>>;
      expect(data.containsKey('national'), isTrue);
    });

    test('5. should return failure when getCategoryPreviews throws', () async {
      when(() => mockDatasource.getCategoryPreviews())
          .thenThrow(Exception('Server error'));

      final result = await repository.getCategoryPreviews();

      expect(result, isA<Left<Failure, Map<String, List<NewsEntity>>>>());
    });
  });

  // ── getNewsBySlug ───────────────────────────────────────────────────────────
  group('NewsRepository - getNewsBySlug', () {
    test('6. should return NewsEntity by slug on success', () async {
      when(() => mockDatasource.getNewsBySlug('test-news'))
          .thenAnswer((_) async => tNews);

      final result = await repository.getNewsBySlug('test-news');

      expect(result, isA<Right<Failure, NewsEntity>>());
      final news = (result as Right).value as NewsEntity;
      expect(news.slug, 'test-news');
    });

    test('7. should return failure when slug not found', () async {
      when(() => mockDatasource.getNewsBySlug(any()))
          .thenThrow(Exception('Not found'));

      final result = await repository.getNewsBySlug('nonexistent');

      expect(result, isA<Left<Failure, NewsEntity>>());
    });
  });

  // ── getPublishedNews ────────────────────────────────────────────────────────
  group('NewsRepository - getPublishedNews', () {
    test('8. should return paginated news on success', () async {
      when(() => mockDatasource.getPublishedNews(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            category: any(named: 'category'),
            search: any(named: 'search'),
          )).thenAnswer((_) async => [tNews]);

      final result = await repository.getPublishedNews(page: 1, limit: 10);

      expect(result, isA<Right<Failure, List<NewsEntity>>>());
    });

    test('9. should return failure when getPublishedNews throws', () async {
      when(() => mockDatasource.getPublishedNews(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            category: any(named: 'category'),
            search: any(named: 'search'),
          )).thenThrow(Exception('Connection timeout'));

      final result = await repository.getPublishedNews(page: 1, limit: 10);

      expect(result, isA<Left<Failure, List<NewsEntity>>>());
    });

    test('10. should pass category filter correctly', () async {
      when(() => mockDatasource.getPublishedNews(
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            category: 'sports',
            search: any(named: 'search'),
          )).thenAnswer((_) async => [tNews]);

      final result = await repository.getPublishedNews(
          page: 1, limit: 10, category: 'sports');

      expect(result, isA<Right<Failure, List<NewsEntity>>>());
      verify(() => mockDatasource.getPublishedNews(
            page: 1,
            limit: 10,
            category: 'sports',
            search: null,
          )).called(1);
    });
  });
}
