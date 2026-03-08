import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smartnews/core/api/api_endpoints.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';
import 'package:smartnews/features/dashboard/domain/usecases/news_usecase.dart';
import 'package:smartnews/features/dashboard/presentation/pages/bottomnavbar/bookmark_screen.dart';
import 'package:smartnews/features/dashboard/presentation/pages/bottomnavbar/categories_screen.dart';
import 'package:smartnews/features/dashboard/presentation/pages/bottomnavbar/home_screen.dart';
import 'package:smartnews/features/dashboard/presentation/pages/bottomnavbar/profile_screen.dart';
import 'package:smartnews/features/dashboard/presentation/view_model/bookmark_view_model.dart';

// ─── State ────────────────────────────────────────────────────────────────────

enum NewsDetailStatus { initial, loading, loaded, error }

class NewsDetailState {
  final NewsDetailStatus status;
  final NewsEntity? news;
  final String? errorMessage;

  const NewsDetailState({
    this.status = NewsDetailStatus.initial,
    this.news,
    this.errorMessage,
  });

  NewsDetailState copyWith({
    NewsDetailStatus? status,
    NewsEntity? news,
    String? errorMessage,
  }) {
    return NewsDetailState(
      status: status ?? this.status,
      news: news ?? this.news,
      errorMessage: errorMessage,
    );
  }
}

// ─── ViewModel ────────────────────────────────────────────────────────────────

class NewsDetailViewModel extends StateNotifier<NewsDetailState> {
  final GetNewsBySlugUsecase _usecase;
  NewsDetailViewModel(this._usecase) : super(const NewsDetailState());

  Future<void> loadNews(String slug) async {
    state = state.copyWith(status: NewsDetailStatus.loading);
    final result = await _usecase(slug);
    result.fold(
      (failure) => state = state.copyWith(
        status: NewsDetailStatus.error,
        errorMessage: failure.message,
      ),
      (news) =>
          state = state.copyWith(status: NewsDetailStatus.loaded, news: news),
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final newsDetailViewModelProvider =
    StateNotifierProvider.family<NewsDetailViewModel, NewsDetailState, String>(
      (ref, slug) =>
          NewsDetailViewModel(ref.read(getNewsBySlugUsecaseProvider)),
    );

// ─── Screen ───────────────────────────────────────────────────────────────────

class NewsDetailScreen extends ConsumerStatefulWidget {
  final String slug;
  final NewsEntity? preloadedNews;
  final int initialNavIndex; // which tab was active when navigating here

  const NewsDetailScreen({
    super.key,
    required this.slug,
    this.preloadedNews,
    this.initialNavIndex = 0,
  });

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(newsDetailViewModelProvider(widget.slug).notifier)
          .loadNews(widget.slug);
      ref.read(bookmarkViewModelProvider.notifier).loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsDetailViewModelProvider(widget.slug));
    final news = state.news ?? widget.preloadedNews;
    final isBookmarked = news != null
        ? ref.watch(
            bookmarkViewModelProvider.select(
              (s) => s.bookmarkedNewsIds.contains(news.id),
            ),
          )
        : false;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A7CFF),
        foregroundColor: Colors.white,
        title: const Text(
          'News Detail',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (news != null) ...[
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
              onPressed: () {
                ref
                    .read(bookmarkViewModelProvider.notifier)
                    .toggleBookmark(news);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBookmarked ? 'Bookmark removed' : 'Article bookmarked!',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () => _share(news),
            ),
          ],
        ],
      ),
      body: state.status == NewsDetailStatus.loading && news == null
          ? const Center(child: CircularProgressIndicator())
          : state.status == NewsDetailStatus.error && news == null
          ? _buildError(state.errorMessage)
          : _buildDetail(context, news!),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.initialNavIndex,
        onTap: (index) => Navigator.pop(context),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0B2C4D),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _tabScreen(int index) {
    final screens = [
      const HomeTab(),
      const CategoriesTab(),
      const BookmarksTab(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0B2C4D),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildError(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message ?? 'Failed to load article'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => ref
                .read(newsDetailViewModelProvider(widget.slug).notifier)
                .loadNews(widget.slug),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(BuildContext context, NewsEntity news) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (news.thumbnail != null && news.thumbnail!.isNotEmpty)
            Image.network(
              news.thumbnail!,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _thumbnailPlaceholder(),
            )
          else
            _thumbnailPlaceholder(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A7CFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _capitalize(news.category),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      news.publishedAt != null
                          ? _formatDate(news.publishedAt!)
                          : 'Unknown date',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${news.views} views',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (news.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: news.tags
                        .map(
                          (tag) => Chip(
                            label: Text(
                              tag,
                              style: const TextStyle(fontSize: 11),
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  news.summary,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  news.content,
                  style: const TextStyle(fontSize: 15, height: 1.8),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _share(news),
                    icon: const Icon(Icons.share),
                    label: const Text('Share this article'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbnailPlaceholder() {
    return Container(
      width: double.infinity,
      height: 220,
      color: const Color(0xFF0B2C4D),
      child: const Center(
        child: Icon(Icons.article_outlined, size: 64, color: Colors.white30),
      ),
    );
  }

  void _share(NewsEntity news) {
    final url = '${ApiEndpoints.baseUrl}/news/${news.slug}';
    Share.share('${news.title}\n\n${news.summary}\n\nRead more: $url');
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
