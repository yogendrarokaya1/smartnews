import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/features/dashboard/presentation/view_model/news_view_model.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';
// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(newsViewModelProvider.notifier).loadHomeData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsViewModelProvider);

    if (newsState.status == NewsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (newsState.status == NewsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(newsState.errorMessage ?? 'Something went wrong'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  ref.read(newsViewModelProvider.notifier).loadHomeData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(newsViewModelProvider.notifier).loadHomeData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // ── Recent / Latest News ──────────────────────────────────────
            if (newsState.latestNews.isNotEmpty) ...[
              _sectionTitle('Recent News'),
              ...newsState.latestNews
                  .take(3)
                  .map((news) => _recentNewsCard(news)),
            ],

            // ── Category Sections ─────────────────────────────────────────
            ...newsState.categoryPreviews.entries.map((entry) {
              final category = entry.key;
              final articles = entry.value;
              if (articles.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    _capitalize(category),
                    seeMore: true,
                    category: category,
                  ),
                  ...articles.take(3).map((news) => _smallNewsCard(news)),
                ],
              );
            }),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ─── Section Title ────────────────────────────────────────────────────────

  Widget _sectionTitle(String title, {bool seeMore = false, String? category}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (seeMore)
            GestureDetector(
              onTap: () {
                // TODO: Navigate to full category list
              },
              child: const Text(
                'See More',
                style: TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Recent News Card (large) ─────────────────────────────────────────────

  Widget _recentNewsCard(NewsEntity news) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to news detail
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade300,
          image: news.thumbnail != null && news.thumbnail!.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(news.thumbnail!),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                )
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7CFF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _capitalize(news.category),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                news.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              if (news.publishedAt != null)
                Text(
                  timeago.format(news.publishedAt!),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Small News Card ──────────────────────────────────────────────────────

  Widget _smallNewsCard(NewsEntity news) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to news detail
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: news.thumbnail != null && news.thumbnail!.isNotEmpty
                  ? Image.network(
                      news.thumbnail!,
                      width: 90,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderImage(),
                    )
                  : _placeholderImage(),
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (news.publishedAt != null)
                    Text(
                      timeago.format(news.publishedAt!),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 90,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_outlined, color: Colors.grey, size: 28),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
