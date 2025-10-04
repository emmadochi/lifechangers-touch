import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  String _sortBy = 'recent';
  String _selectedCategory = 'all';

  final List<String> _categories = [
    'all',
    'videos',
    'audio',
    'books',
    'messages',
  ];

  final List<String> _sortOptions = [
    'recent',
    'popular',
    'alphabetical',
    'duration',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Library'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(
            text: category.toUpperCase(),
          )).toList(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search content...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          // Content List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return _buildContentList(category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentList(String category) {
    // Mock data - replace with actual data from API
    final List<ContentModel> contentList = _getMockContent(category);
    
    if (contentList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No content found',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new content',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: contentList.length,
        itemBuilder: (context, index) {
          return _ContentGridCard(
            content: contentList[index],
            onTap: () => _navigateToContent(contentList[index]),
          );
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contentList.length,
        itemBuilder: (context, index) {
          return _ContentListCard(
            content: contentList[index],
            onTap: () => _navigateToContent(contentList[index]),
          );
        },
      );
    }
  }

  void _navigateToContent(ContentModel content) {
    switch (content.type) {
      case ContentType.video:
        context.push(RouteNames.videoPlayer);
        break;
      case ContentType.audio:
        context.push(RouteNames.audioPlayer);
        break;
      case ContentType.book:
        context.push(RouteNames.bookReader);
        break;
      case ContentType.message:
        context.push(RouteNames.contentDetails);
        break;
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter & Sort',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sort by',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _sortOptions.map((option) {
                final isSelected = _sortBy == option;
                return FilterChip(
                  label: Text(option.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _sortBy = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Category',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return FilterChip(
                  label: Text(category.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<ContentModel> _getMockContent(String category) {
    // Mock data - replace with actual API call
    return List.generate(10, (index) {
      return ContentModel(
        id: 'content_$index',
        title: 'Sample Content ${index + 1}',
        description: 'This is a sample content description for testing purposes.',
        thumbnailUrl: null,
        mediaUrl: null,
        type: ContentType.values[index % 4],
        status: index % 3 == 0 ? ContentStatus.premium : ContentStatus.free,
        coinCost: index % 3 == 0 ? 5 : 0,
        category: category,
        tags: ['sample', 'test'],
        author: 'Pastor John Doe',
        createdAt: DateTime.now().subtract(Duration(days: index)),
        publishedAt: DateTime.now().subtract(Duration(days: index)),
        duration: 1800 + (index * 300),
        viewCount: 100 + (index * 50),
        downloadCount: 20 + (index * 10),
        rating: 4.0 + (index * 0.1),
        isDownloadable: true,
        isLive: false,
        streamUrl: null,
        scheduledAt: null,
      );
    });
  }
}

class _ContentGridCard extends StatelessWidget {
  final ContentModel content;
  final VoidCallback onTap;

  const _ContentGridCard({
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _getContentIcon(content.type),
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (content.isPremium)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'PREMIUM',
                            style: AppTextStyles.premiumBadge,
                          ),
                        ),
                      ),
                    if (content.type == ContentType.video)
                      const Positioned(
                        bottom: 8,
                        right: 8,
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Content Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content.author,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          content.formattedDuration,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        if (content.isPremium)
                          Icon(
                            Icons.lock,
                            size: 16,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getContentIcon(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Icons.play_circle_outline;
      case ContentType.audio:
        return Icons.audiotrack;
      case ContentType.book:
        return Icons.menu_book;
      case ContentType.message:
        return Icons.message;
    }
  }
}

class _ContentListCard extends StatelessWidget {
  final ContentModel content;
  final VoidCallback onTap;

  const _ContentListCard({
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  _getContentIcon(content.type),
                  size: 24,
                  color: AppColors.textSecondary,
                ),
              ),
              if (content.isPremium)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        title: Text(
          content.title,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content.author,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  content.formattedDuration,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${content.viewCount} views',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (content.isPremium)
              Icon(
                Icons.lock,
                size: 20,
                color: AppColors.primary,
              )
            else
              Icon(
                Icons.play_arrow,
                size: 20,
                color: AppColors.textSecondary,
              ),
            const SizedBox(height: 4),
            Text(
              content.isPremium ? '${content.coinCost} coins' : 'Free',
              style: AppTextStyles.caption.copyWith(
                color: content.isPremium ? AppColors.primary : AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getContentIcon(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Icons.play_circle_outline;
      case ContentType.audio:
        return Icons.audiotrack;
      case ContentType.book:
        return Icons.menu_book;
      case ContentType.message:
        return Icons.message;
    }
  }
}
