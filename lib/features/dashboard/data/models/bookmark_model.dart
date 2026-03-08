import 'package:smartnews/features/dashboard/data/models/news_model.dart';
import 'package:smartnews/features/dashboard/domain/entities/bookmark_entity.dart';

class BookmarkModel {
  final String id;
  final String userId;
  final String newsId;
  final NewsModel? news;
  final DateTime createdAt;

  BookmarkModel({
    required this.id,
    required this.userId,
    required this.newsId,
    this.news,
    required this.createdAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    // news is populated — could be a Map or just an ObjectId string
    NewsModel? newsModel;
    if (json['news'] is Map<String, dynamic>) {
      newsModel = NewsModel.fromJson(json['news'] as Map<String, dynamic>);
    }

    return BookmarkModel(
      id: json['_id'] ?? '',
      userId: json['user']?.toString() ?? '',
      newsId: json['news'] is Map
          ? (json['news']['_id'] ?? '').toString()
          : json['news']?.toString() ?? '',
      news: newsModel,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  BookmarkEntity toEntity() {
    return BookmarkEntity(
      id: id,
      userId: userId,
      newsId: newsId,
      news: news?.toEntity(),
      createdAt: createdAt,
    );
  }
}
