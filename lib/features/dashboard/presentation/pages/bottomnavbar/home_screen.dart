import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';
import 'package:smartnews/features/dashboard/presentation/pages/category_news_screen.dart';
import 'package:smartnews/features/dashboard/presentation/pages/news_detail_screen.dart';
import 'package:smartnews/features/dashboard/presentation/view_model/news_view_model.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  // ── Shake detection ────────────────────────────────────────────────────────
  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  DateTime? _lastShakeTime;
  static const double _shakeThreshold = 15.0;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(newsViewModelProvider.notifier).loadHomeData(),
    );
    _startShakeDetection();
  }

  void _startShakeDetection() {
    _accelerometerSub = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (magnitude > _shakeThreshold) {
        final now = DateTime.now();
        // Debounce — only trigger once every 2 seconds
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > const Duration(seconds: 2)) {
          _lastShakeTime = now;
          _onShakeRefresh();
        }
      }
    });
  }

  void _onShakeRefresh() {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.refresh, color: Colors.white),
            SizedBox(width: 8),
            Text('Refreshing news...'),
          ],
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF4A7CFF),
      ),
    );

    ref.read(newsViewModelProvider.notifier).loadHomeData().then((_) {
      if (mounted) setState(() => _isRefreshing = false);
    });
  }

  @override
  void dispose() {
    _accelerometerSub?.cancel();
    super.dispose();
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
            // ── Shake hint banner ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: const Color(0xFF0B2C4D),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.vibration, color: Colors.white70, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Shake your phone to refresh news',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Recent / Latest News ────────────────────────────────────────
            if (newsState.latestNews.isNotEmpty) ...[
              _sectionTitle('Recent News'),
              ...newsState.latestNews
                  .take(3)
                  .map((news) => _recentNewsCard(news)),
            ],

            // ── Category Sections ───────────────────────────────────────────
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
          if (seeMore && category != null)
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryNewsScreen(category: category),
                ),
              ),
              child: const Text(
                'See More',
                style: TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  Widget _recentNewsCard(NewsEntity news) {
    return GestureDetector(
      onTap: () => _openDetail(news),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        height: 200,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade300,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background image ──────────────────────────────────────────
            if (news.thumbnail != null && news.thumbnail!.isNotEmpty)
              Image.network(
                news.thumbnail!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF0B2C4D),
                  child: const Icon(
                    Icons.article_outlined,
                    color: Colors.white30,
                    size: 48,
                  ),
                ),
              )
            else
              Container(
                color: const Color(0xFF0B2C4D),
                child: const Icon(
                  Icons.article_outlined,
                  color: Colors.white30,
                  size: 48,
                ),
              ),

            // ── Gradient overlay ──────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.3, 0.6, 1.0],
                ),
              ),
            ),

            // ── Text content ──────────────────────────────────────────────
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A7CFF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _capitalize(news.category),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
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
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (news.publishedAt != null)
                    Text(
                      _timeAgo(news.publishedAt!),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallNewsCard(NewsEntity news) {
    return GestureDetector(
      onTap: () => _openDetail(news),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      _timeAgo(news.publishedAt!),
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

  void _openDetail(NewsEntity news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsDetailScreen(slug: news.slug, preloadedNews: news),
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

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }
}
