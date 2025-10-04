import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class OfflineLibraryScreen extends StatefulWidget {
  const OfflineLibraryScreen({super.key});

  @override
  State<OfflineLibraryScreen> createState() => _OfflineLibraryScreenState();
}

class _OfflineLibraryScreenState extends State<OfflineLibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _selectedSort = 'Recent';
  bool _isOfflineMode = true;

  final List<String> _filterOptions = ['All', 'Videos', 'Audio', 'Books', 'Messages'];
  final List<String> _sortOptions = ['Recent', 'Name', 'Size', 'Type', 'Author'];

  // Mock offline content data - replace with actual offline content data
  final List<OfflineContent> _offlineContent = [
    OfflineContent(
      id: 'offline_1',
      content: ContentModel(
        id: 'content_1',
        title: 'Sunday Service - Faith and Hope',
        description: 'Join us for an inspiring message about faith, hope, and love.',
        type: ContentType.video,
        status: ContentStatus.free,
        coinCost: 0,
        category: 'sermons',
        tags: ['faith', 'hope', 'sunday'],
        author: 'Pastor John Doe',
        createdAt: DateTime.now(),
        duration: 3600,
        viewCount: 1250,
        downloadCount: 45,
        rating: 4.8,
        isDownloadable: true,
        isLive: false,
      ),
      downloadedAt: DateTime.now().subtract(const Duration(days: 2)),
      fileSize: 250 * 1024 * 1024, // 250 MB
      localPath: '/storage/downloads/sunday_service.mp4',
      isAvailable: true,
      lastPlayed: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    OfflineContent(
      id: 'offline_2',
      content: ContentModel(
        id: 'content_2',
        title: 'Prayer and Meditation',
        description: 'A peaceful time of prayer and reflection.',
        type: ContentType.audio,
        status: ContentStatus.free,
        coinCost: 0,
        category: 'prayer',
        tags: ['prayer', 'meditation'],
        author: 'Pastor Sarah Johnson',
        createdAt: DateTime.now(),
        duration: 1800,
        viewCount: 890,
        downloadCount: 32,
        rating: 4.9,
        isDownloadable: true,
        isLive: false,
      ),
      downloadedAt: DateTime.now().subtract(const Duration(days: 1)),
      fileSize: 45 * 1024 * 1024, // 45 MB
      localPath: '/storage/downloads/prayer_meditation.mp3',
      isAvailable: true,
      lastPlayed: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    OfflineContent(
      id: 'offline_3',
      content: ContentModel(
        id: 'content_3',
        title: 'The Power of Faith',
        description: 'A comprehensive guide to understanding faith.',
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
      ),
      downloadedAt: DateTime.now().subtract(const Duration(hours: 6)),
      fileSize: 15 * 1024 * 1024, // 15 MB
      localPath: '/storage/downloads/power_of_faith.pdf',
      isAvailable: true,
      lastPlayed: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    OfflineContent(
      id: 'offline_4',
      content: ContentModel(
        id: 'content_4',
        title: 'Worship Music Collection',
        description: 'Beautiful worship songs to lift your spirit.',
        type: ContentType.audio,
        status: ContentStatus.premium,
        coinCost: 5,
        category: 'music',
        tags: ['worship', 'music'],
        author: 'Worship Team',
        createdAt: DateTime.now(),
        duration: 3600,
        viewCount: 2100,
        downloadCount: 78,
        rating: 4.7,
        isDownloadable: true,
        isLive: false,
      ),
      downloadedAt: DateTime.now().subtract(const Duration(days: 3)),
      fileSize: 120 * 1024 * 1024, // 120 MB
      localPath: '/storage/downloads/worship_collection.mp3',
      isAvailable: false, // File corrupted or deleted
      lastPlayed: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Library'),
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: _showSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Videos'),
            Tab(text: 'Audio'),
            Tab(text: 'Books'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Offline Mode Indicator
          if (_isOfflineMode)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: AppColors.success.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Icon(
                    Icons.offline_bolt,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Offline Mode - All content available',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          
          // Storage Info
          _buildStorageInfo(),
          
          // Content List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContentTab(),
                _buildContentTab(ContentType.video),
                _buildContentTab(ContentType.audio),
                _buildContentTab(ContentType.book),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToDownloads,
        icon: const Icon(Icons.download),
        label: const Text('Manage Downloads'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStorageInfo() {
    final totalSize = _offlineContent.fold<int>(0, (sum, content) => sum + content.fileSize);
    final availableContent = _offlineContent.where((c) => c.isAvailable).length;
    final totalContent = _offlineContent.length;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Offline Storage',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${availableContent}/${totalContent} available',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Size: ${_formatFileSize(totalSize)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: availableContent / totalContent,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _refreshContent,
                icon: const Icon(Icons.refresh),
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab([ContentType? filterType]) {
    final filteredContent = _getFilteredContent(filterType);
    
    if (filteredContent.isEmpty) {
      return _buildEmptyState(filterType);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredContent.length,
      itemBuilder: (context, index) {
        final content = filteredContent[index];
        return _OfflineContentCard(
          content: content,
          onTap: () => _openContent(content),
          onDelete: () => _deleteContent(content),
          onRedownload: () => _redownloadContent(content),
          onShare: () => _shareContent(content),
        );
      },
    );
  }

  Widget _buildEmptyState([ContentType? filterType]) {
    String title;
    String subtitle;
    IconData icon;
    
    if (filterType == null) {
      title = 'No Offline Content';
      subtitle = 'Download content to view offline';
      icon = Icons.offline_bolt;
    } else {
      switch (filterType) {
        case ContentType.video:
          title = 'No Offline Videos';
          subtitle = 'Download videos to watch offline';
          icon = Icons.play_circle_fill;
          break;
        case ContentType.audio:
          title = 'No Offline Audio';
          subtitle = 'Download audio to listen offline';
          icon = Icons.music_note;
          break;
        case ContentType.book:
          title = 'No Offline Books';
          subtitle = 'Download books to read offline';
          icon = Icons.menu_book;
          break;
        case ContentType.message:
          title = 'No Offline Messages';
          subtitle = 'Download messages to read offline';
          icon = Icons.message;
          break;
      }
    }
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _goToDownloads,
              icon: const Icon(Icons.download),
              label: const Text('Browse Downloads'),
            ),
          ],
        ),
      ),
    );
  }

  List<OfflineContent> _getFilteredContent(ContentType? filterType) {
    List<OfflineContent> content = _offlineContent;
    
    // Filter by content type
    if (filterType != null) {
      content = content.where((c) => c.content.type == filterType).toList();
    }
    
    // Sort content
    switch (_selectedSort) {
      case 'Recent':
        content.sort((a, b) => b.downloadedAt.compareTo(a.downloadedAt));
        break;
      case 'Name':
        content.sort((a, b) => a.content.title.compareTo(b.content.title));
        break;
      case 'Size':
        content.sort((a, b) => b.fileSize.compareTo(a.fileSize));
        break;
      case 'Type':
        content.sort((a, b) => a.content.type.toString().compareTo(b.content.type.toString()));
        break;
      case 'Author':
        content.sort((a, b) => a.content.author.compareTo(b.content.author));
        break;
    }
    
    return content;
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
            
            // Filter Options
            Text(
              'Content Type',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _filterOptions.map((filter) => FilterChip(
                label: Text(filter),
                selected: _selectedFilter == filter,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              )).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Sort Options
            Text(
              'Sort By',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sortOptions.map((sort) => FilterChip(
                label: Text(sort),
                selected: _selectedSort == sort,
                onSelected: (selected) {
                  setState(() {
                    _selectedSort = sort;
                  });
                },
              )).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings() {
    context.go(RouteNames.downloadSettings);
  }

  void _goToDownloads() {
    context.go(RouteNames.downloads);
  }

  void _refreshContent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing offline content...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openContent(OfflineContent content) {
    if (!content.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Content not available. Please redownload.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    // TODO: Open content based on type
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${content.content.title}'),
      ),
    );
  }

  void _deleteContent(OfflineContent content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Offline Content'),
        content: Text('Are you sure you want to delete "${content.content.title}" from offline storage?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _offlineContent.remove(content);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Content deleted from offline storage'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _redownloadContent(OfflineContent content) {
    setState(() {
      content.isAvailable = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redownloading content...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareContent(OfflineContent content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${content.content.title}'),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class _OfflineContentCard extends StatelessWidget {
  final OfflineContent content;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onRedownload;
  final VoidCallback onShare;

  const _OfflineContentCard({
    required this.content,
    required this.onTap,
    required this.onDelete,
    required this.onRedownload,
    required this.onShare,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Content Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: content.isAvailable 
                          ? _getContentColor(content.content.type)
                          : AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getContentIcon(content.content.type),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Content Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.content.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          content.content.author,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _formatFileSize(content.fileSize),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(content.downloadedAt),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Status and Actions
                  Column(
                    children: [
                      _buildStatusChip(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildActionButtons(),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Last Played Info
              if (content.lastPlayed != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Last played: ${_formatDate(content.lastPlayed!)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    if (content.isAvailable) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success),
        ),
        child: Text(
          'Available',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.error),
        ),
        child: Text(
          'Unavailable',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  List<Widget> _buildActionButtons() {
    List<Widget> buttons = [];
    
    if (content.isAvailable) {
      buttons.addAll([
        IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.play_arrow),
          color: AppColors.primary,
        ),
        IconButton(
          onPressed: onShare,
          icon: const Icon(Icons.share),
          color: AppColors.textSecondary,
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
          color: AppColors.error,
        ),
      ]);
    } else {
      buttons.addAll([
        IconButton(
          onPressed: onRedownload,
          icon: const Icon(Icons.download),
          color: AppColors.primary,
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
          color: AppColors.error,
        ),
      ]);
    }
    
    return buttons;
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

  Color _getContentColor(ContentType type) {
    switch (type) {
      case ContentType.video:
        return AppColors.primary;
      case ContentType.audio:
        return AppColors.secondary;
      case ContentType.book:
        return AppColors.success;
      case ContentType.message:
        return AppColors.warning;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class OfflineContent {
  final String id;
  final ContentModel content;
  final DateTime downloadedAt;
  final int fileSize;
  final String localPath;
  bool isAvailable;
  final DateTime? lastPlayed;

  OfflineContent({
    required this.id,
    required this.content,
    required this.downloadedAt,
    required this.fileSize,
    required this.localPath,
    required this.isAvailable,
    this.lastPlayed,
  });
}
