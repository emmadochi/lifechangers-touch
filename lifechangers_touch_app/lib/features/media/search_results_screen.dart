import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = 'faith';
  String _selectedFilter = 'All';
  String _selectedSort = 'Relevance';
  bool _isLoading = false;

  final List<String> _filterOptions = ['All', 'Videos', 'Audio', 'Books', 'Messages'];
  final List<String> _sortOptions = ['Relevance', 'Newest', 'Oldest', 'Most Viewed', 'Rating'];

  // Mock search results - replace with actual search results
  final List<ContentModel> _searchResults = [
    ContentModel(
      id: 'search_1',
      title: 'Faith and Hope in Difficult Times',
      description: 'A powerful message about maintaining faith during life\'s challenges.',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'sermons',
      tags: ['faith', 'hope', 'difficult', 'times'],
      author: 'Pastor John Doe',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      duration: 2700,
      viewCount: 1250,
      downloadCount: 45,
      rating: 4.8,
      isDownloadable: true,
      isLive: false,
    ),
    ContentModel(
      id: 'search_2',
      title: 'The Power of Faith',
      description: 'Understanding how faith can transform your life.',
      type: ContentType.book,
      status: ContentStatus.premium,
      coinCost: 10,
      category: 'books',
      tags: ['faith', 'power', 'transformation'],
      author: 'Dr. Sarah Williams',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      duration: 0,
      viewCount: 2500,
      downloadCount: 180,
      rating: 4.9,
      isDownloadable: true,
      isLive: false,
    ),
    ContentModel(
      id: 'search_3',
      title: 'Faith in Action',
      description: 'Practical ways to live out your faith daily.',
      type: ContentType.audio,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'sermons',
      tags: ['faith', 'action', 'daily', 'practice'],
      author: 'Pastor Sarah Johnson',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      duration: 1800,
      viewCount: 890,
      downloadCount: 32,
      rating: 4.7,
      isDownloadable: true,
      isLive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = _searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: const Icon(Icons.filter_list),
          ),
        ],
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
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _performSearch,
              onChanged: (value) => setState(() {}),
            ),
          ),
          
          // Search Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_searchResults.length} results for "$_searchQuery"',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _showFilters,
                  icon: const Icon(Icons.tune),
                  label: const Text('Filters'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final filter = _filterOptions[index];
                final isSelected = _selectedFilter == filter;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      _applyFilters();
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primary,
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Results List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final content = _searchResults[index];
                          return _SearchResultCard(
                            content: content,
                            onTap: () => _navigateToContent(content),
                            onDownload: () => _downloadContent(content),
                            onShare: () => _shareContent(content),
                            onLike: () => _likeContent(content),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search terms or filters',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _clearSearch,
              child: const Text('Clear Search'),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isLoading = true;
    });
    
    // Simulate search delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _applyFilters() {
    // TODO: Apply filters to search results
    setState(() {});
  }

  void _showFilters() {
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
            
            // Sort Options
            Text(
              'Sort by',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._sortOptions.map((sort) => RadioListTile<String>(
              title: Text(sort),
              value: sort,
              groupValue: _selectedSort,
              onChanged: (value) {
                setState(() {
                  _selectedSort = value!;
                });
                Navigator.pop(context);
                _applyFilters();
              },
            )),
            
            const SizedBox(height: 24),
            
            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToContent(ContentModel content) {
    // TODO: Navigate to content details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${content.title}'),
      ),
    );
  }

  void _downloadContent(ContentModel content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${content.title}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareContent(ContentModel content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${content.title}'),
      ),
    );
  }

  void _likeContent(ContentModel content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${content.title} to favorites'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final ContentModel content;
  final VoidCallback onTap;
  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onLike;

  const _SearchResultCard({
    required this.content,
    required this.onTap,
    required this.onDownload,
    required this.onShare,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getContentIcon(content.type),
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Content Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
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
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          content.formattedDuration,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${content.viewCount}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        if (content.isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${content.coinCost}',
                              style: AppTextStyles.premiumBadge,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Column(
                children: [
                  IconButton(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download),
                    color: AppColors.textSecondary,
                  ),
                  IconButton(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
                    color: AppColors.textSecondary,
                  ),
                  IconButton(
                    onPressed: onLike,
                    icon: const Icon(Icons.favorite_border),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getContentIcon(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Icons.play_circle_fill;
      case ContentType.audio:
        return Icons.music_note;
      case ContentType.book:
        return Icons.menu_book;
      case ContentType.message:
        return Icons.message;
    }
  }
}
