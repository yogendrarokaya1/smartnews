import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartnews/features/dashboard/domain/entities/bookmark_entity.dart';
import 'package:smartnews/features/dashboard/domain/entities/news_entity.dart';
import 'package:smartnews/features/dashboard/presentation/pages/news_detail_screen.dart';
import 'package:smartnews/features/dashboard/presentation/view_model/bookmark_view_model.dart';

class BookmarksTab extends ConsumerStatefulWidget {
  const BookmarksTab({super.key});

  @override
  ConsumerState<BookmarksTab> createState() => _BookmarksTabState();
}

class _BookmarksTabState extends ConsumerState<BookmarksTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(bookmarkViewModelProvider.notifier).loadBookmarks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookmarkViewModelProvider);

    if (state.status == BookmarkStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == BookmarkStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(state.errorMessage ?? 'Something went wrong'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  ref.read(bookmarkViewModelProvider.notifier).loadBookmarks(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.bookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_outline, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No bookmarks yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save articles to read them later',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(bookmarkViewModelProvider.notifier).loadBookmarks(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.bookmarks.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final bookmark = state.bookmarks[index];
          final news = bookmark.news;
          if (news == null) return const SizedBox.shrink();
          return _bookmarkTile(bookmark, news);
        },
      ),
    );
  }

  Widget _bookmarkTile(BookmarkEntity bookmark, NewsEntity news) {
    return Dismissible(
      key: Key(bookmark.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_remove, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text('Remove', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Remove Bookmark'),
            content: const Text(
              'Are you sure you want to remove this bookmark?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(bookmarkViewModelProvider.notifier).toggleBookmark(news);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bookmark removed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => ref
                  .read(bookmarkViewModelProvider.notifier)
                  .toggleBookmark(news),
            ),
          ),
        );
      },
      child: GestureDetector(
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
              // Thumbnail
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
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A7CFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _capitalize(news.category),
                        style: const TextStyle(
                          color: Color(0xFF4A7CFF),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
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
                    Row(
                      children: [
                        Icon(
                          Icons.bookmark,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Saved ${_timeAgo(bookmark.createdAt)}',
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
              // Remove icon button
              IconButton(
                icon: const Icon(
                  Icons.bookmark_remove_outlined,
                  color: Colors.red,
                  size: 22,
                ),
                onPressed: () => ref
                    .read(bookmarkViewModelProvider.notifier)
                    .toggleBookmark(news),
                tooltip: 'Remove bookmark',
              ),
            ],
          ),
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
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }
}
