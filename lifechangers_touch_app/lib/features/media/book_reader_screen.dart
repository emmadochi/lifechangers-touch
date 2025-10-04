import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class BookReaderScreen extends StatefulWidget {
  const BookReaderScreen({super.key});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  int _currentPage = 1;
  int _totalPages = 120;
  double _fontSize = 16.0;
  String _fontFamily = 'Inter';
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;
  bool _isNightMode = false;
  bool _showBookmarks = false;
  List<int> _bookmarks = [5, 23, 45, 67, 89];
  String _searchQuery = '';
  List<int> _searchResults = [];
  int _currentSearchIndex = 0;

  // Mock book content - replace with actual book data
  final ContentModel _book = ContentModel(
    id: 'book_1',
    title: 'The Power of Faith',
    description: 'A comprehensive guide to understanding and strengthening your faith journey.',
    type: ContentType.book,
    status: ContentStatus.premium,
    coinCost: 10,
    category: 'books',
    tags: ['faith', 'spiritual', 'growth'],
    author: 'Dr. Sarah Williams',
    createdAt: DateTime.now(),
    duration: 0,
    viewCount: 2500,
    downloadCount: 180,
    rating: 4.9,
    isDownloadable: true,
    isLive: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _showBookmarks ? _buildBookmarksAppBar() : _buildReaderAppBar(),
      body: _showBookmarks ? _buildBookmarksView() : _buildReaderView(),
      bottomNavigationBar: _showBookmarks ? null : _buildReaderControls(),
    );
  }

  PreferredSizeWidget _buildReaderAppBar() {
    return AppBar(
      backgroundColor: _backgroundColor,
      foregroundColor: _textColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _book.title,
            style: AppTextStyles.titleMedium.copyWith(
              color: _textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Page $_currentPage of $_totalPages',
            style: AppTextStyles.bodySmall.copyWith(
              color: _textColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _toggleBookmarks,
          icon: Icon(
            _showBookmarks ? Icons.bookmark : Icons.bookmark_border,
            color: _textColor,
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: _textColor),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'search',
              child: ListTile(
                leading: Icon(Icons.search),
                title: Text('Search'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Reader Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'night_mode',
              child: ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Night Mode'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'share',
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  PreferredSizeWidget _buildBookmarksAppBar() {
    return AppBar(
      backgroundColor: _backgroundColor,
      foregroundColor: _textColor,
      elevation: 0,
      leading: IconButton(
        onPressed: _toggleBookmarks,
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        'Bookmarks (${_bookmarks.length})',
        style: AppTextStyles.titleMedium.copyWith(
          color: _textColor,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _addBookmark,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildReaderView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter Title
          Text(
            'Chapter $_currentPage: The Foundation of Faith',
            style: AppTextStyles.headlineSmall.copyWith(
              color: _textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Book Content
          Text(
            _getPageContent(),
            style: AppTextStyles.bodyLarge.copyWith(
              color: _textColor,
              fontSize: _fontSize,
              fontFamily: _fontFamily,
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Page Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _currentPage > 1 ? _previousPage : null,
                icon: const Icon(Icons.chevron_left),
                label: const Text('Previous'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              Text(
                'Page $_currentPage of $_totalPages',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _textColor.withValues(alpha: 0.7),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _currentPage < _totalPages ? _nextPage : null,
                icon: const Icon(Icons.chevron_right),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bookmarks.length,
      itemBuilder: (context, index) {
        final page = _bookmarks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.bookmark,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: Text(
              'Page $page',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Chapter ${(page / 10).ceil()}: The Foundation of Faith',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _goToPage(page),
                  icon: const Icon(Icons.play_arrow),
                ),
                IconButton(
                  onPressed: () => _removeBookmark(page),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            onTap: () => _goToPage(page),
          ),
        );
      },
    );
  }

  Widget _buildReaderControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: Border(
          top: BorderSide(
            color: _textColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Bar
          Slider(
            value: _currentPage.toDouble(),
            min: 1.0,
            max: _totalPages.toDouble(),
            onChanged: (value) => _goToPage(value.toInt()),
            activeColor: AppColors.primary,
            inactiveColor: _textColor.withValues(alpha: 0.3),
          ),
          
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _previousPage,
                icon: const Icon(Icons.skip_previous),
                color: _textColor,
              ),
              IconButton(
                onPressed: _addBookmark,
                icon: Icon(
                  _bookmarks.contains(_currentPage) ? Icons.bookmark : Icons.bookmark_border,
                ),
                color: _bookmarks.contains(_currentPage) ? AppColors.primary : _textColor,
              ),
              IconButton(
                onPressed: _showReaderSettings,
                icon: const Icon(Icons.settings),
                color: _textColor,
              ),
              IconButton(
                onPressed: _nextPage,
                icon: const Icon(Icons.skip_next),
                color: _textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPageContent() {
    // Mock content - replace with actual book content
    return '''
Faith is the foundation upon which our spiritual journey is built. It is not merely a belief in something unseen, but a deep trust in the divine plan that guides our lives. Throughout history, countless individuals have found strength, hope, and purpose through their faith.

In this chapter, we will explore the fundamental principles that make faith such a powerful force in our lives. We will examine how faith shapes our worldview, influences our decisions, and provides comfort during life's most challenging moments.

The journey of faith is not always easy. There will be times when doubt creeps in, when questions arise that seem to have no answers. But it is precisely in these moments that faith becomes most meaningful. It is the anchor that holds us steady when the storms of life threaten to overwhelm us.

As we continue our exploration of faith, remember that this is not a destination but a journey. Each step we take in faith brings us closer to understanding our purpose and our place in the grand design of life.

Faith requires courage. It asks us to trust in something greater than ourselves, to believe in possibilities that may seem impossible. But it is this very act of trust that opens doors to experiences and opportunities we never imagined possible.

The power of faith lies not in its ability to change our circumstances, but in its ability to change us. When we approach life with faith, we see opportunities where others see obstacles. We find hope where others find despair. We discover strength we never knew we possessed.

This is the beginning of a journey that will transform not just how you see the world, but how you see yourself. Welcome to the path of faith.
    ''';
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
    if (_showBookmarks) {
      _toggleBookmarks();
    }
  }

  void _addBookmark() {
    if (!_bookmarks.contains(_currentPage)) {
      setState(() {
        _bookmarks.add(_currentPage);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bookmarked page $_currentPage'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _removeBookmark(int page) {
    setState(() {
      _bookmarks.remove(page);
    });
  }

  void _toggleBookmarks() {
    setState(() {
      _showBookmarks = !_showBookmarks;
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'search':
        _showSearchDialog();
        break;
      case 'settings':
        _showReaderSettings();
        break;
      case 'night_mode':
        _toggleNightMode();
        break;
      case 'share':
        _shareBook();
        break;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search in Book'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter search term...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement search
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showReaderSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reader Settings',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Font Size
            Text(
              'Font Size',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 12,
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
            
            // Font Family
            Text(
              'Font Family',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _fontFamily,
              onChanged: (value) {
                setState(() {
                  _fontFamily = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 'Inter', child: Text('Inter')),
                DropdownMenuItem(value: 'Roboto', child: Text('Roboto')),
                DropdownMenuItem(value: 'Open Sans', child: Text('Open Sans')),
                DropdownMenuItem(value: 'Lato', child: Text('Lato')),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Night Mode Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Night Mode',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Switch(
                  value: _isNightMode,
                  onChanged: (value) {
                    setState(() {
                      _isNightMode = value;
                      if (value) {
                        _backgroundColor = Colors.black;
                        _textColor = Colors.white;
                      } else {
                        _backgroundColor = Colors.white;
                        _textColor = Colors.black;
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleNightMode() {
    setState(() {
      _isNightMode = !_isNightMode;
      if (_isNightMode) {
        _backgroundColor = Colors.black;
        _textColor = Colors.white;
      } else {
        _backgroundColor = Colors.white;
        _textColor = Colors.black;
      }
    });
  }

  void _shareBook() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share options coming soon'),
      ),
    );
  }
}
