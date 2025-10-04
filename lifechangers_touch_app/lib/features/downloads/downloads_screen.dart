import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _selectedSort = 'Recent';

  final List<String> _filterOptions = ['All', 'Videos', 'Audio', 'Books', 'Messages'];
  final List<String> _sortOptions = ['Recent', 'Name', 'Size', 'Type'];

  // Mock download data - replace with actual download data
  final List<DownloadItem> _downloads = [
    DownloadItem(
      id: 'download_1',
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
      status: DownloadStatus.completed,
      progress: 100,
      downloadedAt: DateTime.now().subtract(const Duration(days: 2)),
      fileSize: 250 * 1024 * 1024, // 250 MB
      localPath: '/storage/downloads/sunday_service.mp4',
    ),
    DownloadItem(
      id: 'download_2',
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
      status: DownloadStatus.completed,
      progress: 100,
      downloadedAt: DateTime.now().subtract(const Duration(days: 1)),
      fileSize: 45 * 1024 * 1024, // 45 MB
      localPath: '/storage/downloads/prayer_meditation.mp3',
    ),
    DownloadItem(
      id: 'download_3',
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
      status: DownloadStatus.downloading,
      progress: 65,
      downloadedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      fileSize: 15 * 1024 * 1024, // 15 MB
      localPath: '/storage/downloads/power_of_faith.pdf',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Downloads'),
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
            Tab(text: 'All Downloads'),
            Tab(text: 'Downloading'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDownloadsTab(),
          _buildDownloadingTab(),
          _buildCompletedTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToOfflineLibrary,
        icon: const Icon(Icons.offline_bolt),
        label: const Text('Offline Library'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildDownloadsTab() {
    final filteredDownloads = _getFilteredDownloads();
    
    if (filteredDownloads.isEmpty) {
      return _buildEmptyState(
        icon: Icons.download,
        title: 'No Downloads',
        subtitle: 'Download content to view offline',
      );
    }

    return Column(
      children: [
        // Storage Info
        _buildStorageInfo(),
        
        // Downloads List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredDownloads.length,
            itemBuilder: (context, index) {
              final download = filteredDownloads[index];
              return _DownloadCard(
                download: download,
                onTap: () => _openDownload(download),
                onDelete: () => _deleteDownload(download),
                onRetry: () => _retryDownload(download),
                onPause: () => _pauseDownload(download),
                onResume: () => _resumeDownload(download),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadingTab() {
    final downloadingItems = _downloads.where((d) => d.status == DownloadStatus.downloading).toList();
    
    if (downloadingItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.downloading,
        title: 'No Active Downloads',
        subtitle: 'Downloads will appear here when in progress',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: downloadingItems.length,
      itemBuilder: (context, index) {
        final download = downloadingItems[index];
        return _DownloadCard(
          download: download,
          onTap: () => _openDownload(download),
          onDelete: () => _deleteDownload(download),
          onRetry: () => _retryDownload(download),
          onPause: () => _pauseDownload(download),
          onResume: () => _resumeDownload(download),
        );
      },
    );
  }

  Widget _buildCompletedTab() {
    final completedItems = _downloads.where((d) => d.status == DownloadStatus.completed).toList();
    
    if (completedItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle,
        title: 'No Completed Downloads',
        subtitle: 'Completed downloads will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedItems.length,
      itemBuilder: (context, index) {
        final download = completedItems[index];
        return _DownloadCard(
          download: download,
          onTap: () => _openDownload(download),
          onDelete: () => _deleteDownload(download),
          onRetry: () => _retryDownload(download),
          onPause: () => _pauseDownload(download),
          onResume: () => _resumeDownload(download),
        );
      },
    );
  }

  Widget _buildStorageInfo() {
    final totalSize = _downloads.fold<int>(0, (sum, download) => sum + download.fileSize);
    final usedSpace = totalSize;
    final totalSpace = 2 * 1024 * 1024 * 1024; // 2 GB
    final freeSpace = totalSpace - usedSpace;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Storage Usage',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${_formatFileSize(usedSpace)} / ${_formatFileSize(totalSpace)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: usedSpace / totalSpace,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '${_formatFileSize(freeSpace)} available',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
          ],
        ),
      ),
    );
  }

  List<DownloadItem> _getFilteredDownloads() {
    List<DownloadItem> downloads = _downloads;
    
    // Filter by content type
    if (_selectedFilter != 'All') {
      ContentType? type;
      switch (_selectedFilter) {
        case 'Videos':
          type = ContentType.video;
          break;
        case 'Audio':
          type = ContentType.audio;
          break;
        case 'Books':
          type = ContentType.book;
          break;
        case 'Messages':
          type = ContentType.message;
          break;
      }
      if (type != null) {
        downloads = downloads.where((d) => d.content.type == type).toList();
      }
    }
    
    // Sort downloads
    switch (_selectedSort) {
      case 'Recent':
        downloads.sort((a, b) => b.downloadedAt.compareTo(a.downloadedAt));
        break;
      case 'Name':
        downloads.sort((a, b) => a.content.title.compareTo(b.content.title));
        break;
      case 'Size':
        downloads.sort((a, b) => b.fileSize.compareTo(a.fileSize));
        break;
      case 'Type':
        downloads.sort((a, b) => a.content.type.toString().compareTo(b.content.type.toString()));
        break;
    }
    
    return downloads;
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
              'Filter Downloads',
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

  void _goToOfflineLibrary() {
    context.go(RouteNames.offlineLibrary);
  }

  void _openDownload(DownloadItem download) {
    // TODO: Open downloaded content
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${download.content.title}'),
      ),
    );
  }

  void _deleteDownload(DownloadItem download) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Download'),
        content: Text('Are you sure you want to delete "${download.content.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _downloads.remove(download);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download deleted'),
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

  void _retryDownload(DownloadItem download) {
    setState(() {
      download.status = DownloadStatus.downloading;
      download.progress = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Retrying download...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _pauseDownload(DownloadItem download) {
    setState(() {
      download.status = DownloadStatus.paused;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download paused'),
      ),
    );
  }

  void _resumeDownload(DownloadItem download) {
    setState(() {
      download.status = DownloadStatus.downloading;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download resumed'),
        backgroundColor: AppColors.success,
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

class _DownloadCard extends StatelessWidget {
  final DownloadItem download;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onRetry;
  final VoidCallback onPause;
  final VoidCallback onResume;

  const _DownloadCard({
    required this.download,
    required this.onTap,
    required this.onDelete,
    required this.onRetry,
    required this.onPause,
    required this.onResume,
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
                      color: _getContentColor(download.content.type),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getContentIcon(download.content.type),
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
                          download.content.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          download.content.author,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatFileSize(download.fileSize),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status and Actions
                  Column(
                    children: [
                      _buildStatusChip(download.status),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildActionButtons(),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Progress Bar (for downloading items)
              if (download.status == DownloadStatus.downloading || download.status == DownloadStatus.paused)
                Column(
                  children: [
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: download.progress / 100,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${download.progress}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Downloaded ${_formatFileSize((download.fileSize * download.progress / 100).round())} of ${_formatFileSize(download.fileSize)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(DownloadStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case DownloadStatus.completed:
        color = AppColors.success;
        text = 'Completed';
        break;
      case DownloadStatus.downloading:
        color = AppColors.primary;
        text = 'Downloading';
        break;
      case DownloadStatus.paused:
        color = AppColors.warning;
        text = 'Paused';
        break;
      case DownloadStatus.failed:
        color = AppColors.error;
        text = 'Failed';
        break;
      case DownloadStatus.cancelled:
        color = AppColors.textSecondary;
        text = 'Cancelled';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    List<Widget> buttons = [];
    
    switch (download.status) {
      case DownloadStatus.completed:
        buttons.addAll([
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.play_arrow),
            color: AppColors.primary,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            color: AppColors.error,
          ),
        ]);
        break;
      case DownloadStatus.downloading:
        buttons.addAll([
          IconButton(
            onPressed: onPause,
            icon: const Icon(Icons.pause),
            color: AppColors.warning,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            color: AppColors.error,
          ),
        ]);
        break;
      case DownloadStatus.paused:
        buttons.addAll([
          IconButton(
            onPressed: onResume,
            icon: const Icon(Icons.play_arrow),
            color: AppColors.success,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            color: AppColors.error,
          ),
        ]);
        break;
      case DownloadStatus.failed:
        buttons.addAll([
          IconButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            color: AppColors.primary,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            color: AppColors.error,
          ),
        ]);
        break;
      case DownloadStatus.cancelled:
        buttons.addAll([
          IconButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            color: AppColors.primary,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            color: AppColors.error,
          ),
        ]);
        break;
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
}

class DownloadItem {
  final String id;
  final ContentModel content;
  DownloadStatus status;
  int progress;
  final DateTime downloadedAt;
  final int fileSize;
  final String localPath;

  DownloadItem({
    required this.id,
    required this.content,
    required this.status,
    required this.progress,
    required this.downloadedAt,
    required this.fileSize,
    required this.localPath,
  });
}

