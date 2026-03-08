import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';
import 'package:smartnews/features/dashboard/domain/usecases/news_usecase.dart';
import 'package:smartnews/features/dashboard/presentation/pages/news_detail_screen.dart';
import 'package:smartnews/features/dashboard/presentation/pages/bottomnavbar/bookmark_screen.dart';
import 'package:smartnews/features/dashboard/presentation/pages/bottomnavbar/categories_screen.dart';
import 'package:smartnews/features/dashboard/presentation/pages/bottomnavbar/home_screen.dart';
import 'package:smartnews/features/dashboard/presentation/pages/bottomnavbar/profile_screen.dart';

// ─── State ────────────────────────────────────────────────────────────────────

enum CategoryNewsStatus { initial, loading, loaded, loadingMore, error }

class CategoryNewsState {
  final CategoryNewsStatus status;
  final List<NewsEntity> news;
  final int currentPage;
  final int totalPages;
  final String? errorMessage;

  const CategoryNewsState({
    this.status = CategoryNewsStatus.initial,
    this.news = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  bool get hasMore => currentPage < totalPages;

  CategoryNewsState copyWith({
    CategoryNewsStatus? status,
    List<NewsEntity>? news,
    int? currentPage,
    int? totalPages,
    String? errorMessage,
  }) {
    return CategoryNewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage,
    );
  }
}

// ─── ViewModel ────────────────────────────────────────────────────────────────

class CategoryNewsViewModel extends StateNotifier<CategoryNewsState> {
  final GetPublishedNewsUsecase _usecase;
  final String category;

  CategoryNewsViewModel(this._usecase, this.category)
    : super(const CategoryNewsState());

  Future<void> loadNews() async {
    state = state.copyWith(status: CategoryNewsStatus.loading, news: []);
    final result = await _usecase(
      GetPublishedNewsParams(page: 1, limit: 10, category: category),
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: CategoryNewsStatus.error,
        errorMessage: failure.message,
      ),
      (news) => state = state.copyWith(
        status: CategoryNewsStatus.loaded,
        news: news,
        currentPage: 1,
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == CategoryNewsStatus.loadingMore)
      return;
    state = state.copyWith(status: CategoryNewsStatus.loadingMore);
    final nextPage = state.currentPage + 1;
    final result = await _usecase(
      GetPublishedNewsParams(page: nextPage, limit: 10, category: category),
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: CategoryNewsStatus.loaded,
        errorMessage: failure.message,
      ),
      (news) => state = state.copyWith(
        status: CategoryNewsStatus.loaded,
        news: [...state.news, ...news],
        currentPage: nextPage,
      ),
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final categoryNewsViewModelProvider =
    StateNotifierProvider.family<
      CategoryNewsViewModel,
      CategoryNewsState,
      String
    >((ref, category) {
      final usecase = ref.read(getPublishedNewsUsecaseProvider);
      return CategoryNewsViewModel(usecase, category);
    });

// ─── Screen ───────────────────────────────────────────────────────────────────

class CategoryNewsScreen extends ConsumerStatefulWidget {
  final String category;
  const CategoryNewsScreen({super.key, required this.category});

  @override
  ConsumerState<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends ConsumerState<CategoryNewsScreen> {
  final _scrollController = ScrollController();
  int _currentNavIndex = 1; // Categories tab is active

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(categoryNewsViewModelProvider(widget.category).notifier)
          .loadNews(),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(categoryNewsViewModelProvider(widget.category).notifier)
          .loadMore();
    }
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;
    // Navigate back to dashboard and switch tab
    Navigator.popUntil(context, (route) => route.isFirst);
    // Use a small delay to let pop complete then switch tab
    // The DashboardScreen will handle this via its own state
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryNewsViewModelProvider(widget.category));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _capitalize(widget.category),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4A7CFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(state),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
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

  Widget _screenForIndex(int index) {
    switch (index) {
      case 0:
        return const _DashboardWrapper(initialIndex: 0);
      case 1:
        return const _DashboardWrapper(initialIndex: 1);
      case 2:
        return const _DashboardWrapper(initialIndex: 2);
      case 3:
        return const _DashboardWrapper(initialIndex: 3);
      default:
        return const _DashboardWrapper(initialIndex: 0);
    }
  }

  Widget _buildBody(CategoryNewsState state) {
    if (state.status == CategoryNewsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == CategoryNewsStatus.error && state.news.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(state.errorMessage ?? 'Something went wrong'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref
                  .read(categoryNewsViewModelProvider(widget.category).notifier)
                  .loadNews(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.news.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'No news in ${_capitalize(widget.category)} yet',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref
          .read(categoryNewsViewModelProvider(widget.category).notifier)
          .loadNews(),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.news.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == state.news.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _newsListTile(state.news[index]);
        },
      ),
    );
  }

  Widget _newsListTile(NewsEntity news) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                NewsDetailScreen(slug: news.slug, preloadedNews: news),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: news.thumbnail != null && news.thumbnail!.isNotEmpty
                  ? Image.network(
                      news.thumbnail!,
                      width: 100,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
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
                  const SizedBox(height: 6),
                  Text(
                    news.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${news.views} views',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (news.publishedAt != null)
                        Text(
                          _timeAgo(news.publishedAt!),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 100,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_outlined, color: Colors.grey),
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

// ─── Dashboard wrapper to switch tabs ─────────────────────────────────────────

class _DashboardWrapper extends StatelessWidget {
  final int initialIndex;
  const _DashboardWrapper({required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    // Import DashboardScreen from your dashboard file
    // This is handled by importing dashboar_screen.dart
    return _DashboardNav(initialIndex: initialIndex);
  }
}

class _DashboardNav extends StatefulWidget {
  final int initialIndex;
  const _DashboardNav({required this.initialIndex});

  @override
  State<_DashboardNav> createState() => _DashboardNavState();
}

class _DashboardNavState extends State<_DashboardNav> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeTab(),
    CategoriesTab(),
    BookmarksTab(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
}
