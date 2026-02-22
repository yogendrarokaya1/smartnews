import 'package:equatable/equatable.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';

class BookmarkEntity extends Equatable {
  final String id;
  final String userId;
  final String newsId;
  final NewsEntity? news; // populated from backend
  final DateTime createdAt;

  const BookmarkEntity({
    required this.id,
    required this.userId,
    required this.newsId,
    this.news,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, newsId];
}
