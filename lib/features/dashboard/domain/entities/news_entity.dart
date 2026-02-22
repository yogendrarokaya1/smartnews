import 'package:equatable/equatable.dart';

enum NewsCategory {
  politics,
  sports,
  technology,
  entertainment,
  business,
  health,
  world,
}

class NewsEntity extends Equatable {
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

  const NewsEntity({
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

  @override
  List<Object?> get props => [id, title, slug, category, status];
}
