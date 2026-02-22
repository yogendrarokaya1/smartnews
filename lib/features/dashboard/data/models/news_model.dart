import 'package:smartnews/core/api/api_endpoints.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';

class NewsModel {
  final String id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String category;
  final List<String> tags;
  final String? thumbnail;
  final String authorId;
  final String status;
  final bool isFeatured;
  final int views;
  final DateTime? publishedAt;
  final DateTime? createdAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.category,
    required this.tags,
    this.thumbnail,
    required this.authorId,
    required this.status,
    required this.isFeatured,
    required this.views,
    this.publishedAt,
    this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      thumbnail: json['thumbnail'],
      authorId: json['author'] is Map
          ? json['author']['_id'] ?? ''
          : json['author']?.toString() ?? '',
      status: json['status'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      views: json['views'] ?? 0,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  NewsEntity toEntity() {
    return NewsEntity(
      id: id,
      title: title,
      slug: slug,
      summary: summary,
      content: content,
      category: category,
      tags: tags,
      thumbnail: thumbnail != null ? ApiEndpoints.getImageUrl(thumbnail) : null,
      authorId: authorId,
      status: status,
      isFeatured: isFeatured,
      views: views,
      publishedAt: publishedAt,
      createdAt: createdAt,
    );
  }
}
