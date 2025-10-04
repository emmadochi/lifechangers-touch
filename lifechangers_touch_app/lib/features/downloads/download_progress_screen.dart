import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class DownloadProgressScreen extends StatefulWidget {
  const DownloadProgressScreen({super.key});

  @override
  State<DownloadProgressScreen> createState() => _DownloadProgressScreenState();
}

class _DownloadProgressScreenState extends State<DownloadProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  // Mock download progress data - replace with actual progress data
  final List<DownloadProgress> _downloads = [
    DownloadProgress(
      id: 'download_1',
      title: 'Sunday Service - Faith and Hope',
      author: 'Pastor John Doe',
      type: ContentType.video,
      status: DownloadStatus.downloading,
      progress: 75,
      totalSize: 250 * 1024 * 1024, // 250 MB
      downloadedSize: 187 * 1024 * 1024, // 187 MB
      speed: 2.5 * 1024 * 1024, // 2.5 MB/s
      timeRemaining: const Duration(minutes: 3, seconds: 12),
      startTime: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    DownloadProgress(
      id: 'download_2',
      title: 'Prayer and Meditation',
      author: 'Pastor Sarah Johnson',
      type: ContentType.audio,
      status: DownloadStatus.paused,
      progress: 45,
      totalSize: 45 * 1024 * 1024, // 45 MB
      downloadedSize: 20 * 1024 * 1024, // 20 MB
      speed: 0,
      timeRemaining: const Duration(minutes: 0),
      startTime: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    DownloadProgress(
      id: 'download_3',
      title: 'The Power of Faith',
      author: 'Dr. Sarah Williams',
      type: ContentType.book,
      status: DownloadStatus.failed,
      progress: 30,
      totalSize: 15 * 1024 * 1024, // 15 MB
      downloadedSize: 4 * 1024 * 1024, // 4 MB
      speed: 0,
      timeRemaining: const Duration(minutes: 0),
      startTime: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Progress'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _pauseAllDownloads,
            icon: const Icon(Icons.pause),
          ),
          IconButton(
            onPressed: _showDownloadSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // Overall Progress
          _buildOverallProgress(),
          
          // Downloads List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _downloads.length,
              itemBuilder: (context, index) {
                final download = _downloads[index];
                return _DownloadProgressCard(
                  download: download,
                  onPause: () => _pauseDownload(download),
                  onResume: () => _resumeDownload(download),
                  onRetry: () => _retryDownload(download),
                  onCancel: () => _cancelDownload(download),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress() {
    final activeDownloads = _downloads.where((d) => d.status == DownloadStatus.downloading).length;
    final totalDownloads = _downloads.length;
    final totalSize = _downloads.fold<int>(0, (sum, d) => sum + d.totalSize);
    final downloadedSize = _downloads.fold<int>(0, (sum, d) => sum + d.downloadedSize);
    final overallProgress = totalSize > 0 ? (downloadedSize / totalSize) * 100 : 0.0;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Download Progress',
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$activeDownloads of $totalDownloads active',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Progress Bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${overallProgress.toStringAsFixed(1)}%',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_formatFileSize(downloadedSize)} / ${_formatFileSize(totalSize)}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: overallProgress / 100,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.download,
                label: 'Downloaded',
                value: _formatFileSize(downloadedSize),
              ),
              _StatItem(
                icon: Icons.speed,
                label: 'Speed',
                value: _getTotalSpeed(),
              ),
              _StatItem(
                icon: Icons.access_time,
                label: 'Time Left',
                value: _getTotalTimeRemaining(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTotalSpeed() {
    final totalSpeed = _downloads
        .where((d) => d.status == DownloadStatus.downloading)
        .fold<double>(0, (sum, d) => sum + d.speed);
    return '${_formatFileSize(totalSpeed.round())}/s';
  }

  String _getTotalTimeRemaining() {
    final activeDownloads = _downloads.where((d) => d.status == DownloadStatus.downloading);
    if (activeDownloads.isEmpty) return '0m';
    
    final maxTime = activeDownloads
        .map((d) => d.timeRemaining)
        .reduce((a, b) => a > b ? a : b);
    return _formatDuration(maxTime);
  }

  void _pauseAllDownloads() {
    setState(() {
      for (var download in _downloads) {
        if (download.status == DownloadStatus.downloading) {
          download.status = DownloadStatus.paused;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All downloads paused'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _showDownloadSettings() {
    context.go(RouteNames.downloadSettings);
  }

  void _pauseDownload(DownloadProgress download) {
    setState(() {
      download.status = DownloadStatus.paused;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download paused'),
      ),
    );
  }

  void _resumeDownload(DownloadProgress download) {
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

  void _retryDownload(DownloadProgress download) {
    setState(() {
      download.status = DownloadStatus.downloading;
      download.progress = 0;
      download.downloadedSize = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Retrying download...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _cancelDownload(DownloadProgress download) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Download'),
        content: Text('Are you sure you want to cancel "${download.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _downloads.remove(download);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download cancelled'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _DownloadProgressCard extends StatelessWidget {
  final DownloadProgress download;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onRetry;
  final VoidCallback onCancel;

  const _DownloadProgressCard({
    required this.download,
    required this.onPause,
    required this.onResume,
    required this.onRetry,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Content Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getContentColor(download.type),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getContentIcon(download.type),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Content Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download.title,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        download.author,
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
            
            const SizedBox(height: 16),
            
            // Progress Bar
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${download.progress}%',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_formatFileSize(download.downloadedSize)} / ${_formatFileSize(download.totalSize)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: download.progress / 100,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(download.status)),
                ),
              ],
            ),
            
            // Download Stats
            if (download.status == DownloadStatus.downloading)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.speed,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_formatFileSize(download.speed.round())}/s',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(download.timeRemaining),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
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

  Widget _buildStatusChip(DownloadStatus status) {
    Color color;
    String text;
    
    switch (status) {
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
      case DownloadStatus.completed:
        color = AppColors.success;
        text = 'Completed';
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
      case DownloadStatus.downloading:
        buttons.addAll([
          IconButton(
            onPressed: onPause,
            icon: const Icon(Icons.pause),
            color: AppColors.warning,
          ),
          IconButton(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel),
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
            onPressed: onCancel,
            icon: const Icon(Icons.cancel),
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
            onPressed: onCancel,
            icon: const Icon(Icons.cancel),
            color: AppColors.error,
          ),
        ]);
        break;
      case DownloadStatus.completed:
        buttons.addAll([
          IconButton(
            onPressed: () {}, // Open content
            icon: const Icon(Icons.play_arrow),
            color: AppColors.primary,
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

  Color _getStatusColor(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.downloading:
        return AppColors.primary;
      case DownloadStatus.paused:
        return AppColors.warning;
      case DownloadStatus.failed:
        return AppColors.error;
      case DownloadStatus.completed:
        return AppColors.success;
      case DownloadStatus.cancelled:
        return AppColors.textSecondary;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}

class DownloadProgress {
  final String id;
  final String title;
  final String author;
  final ContentType type;
  DownloadStatus status;
  int progress;
  final int totalSize;
  int downloadedSize;
  final double speed;
  final Duration timeRemaining;
  final DateTime startTime;

  DownloadProgress({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    required this.status,
    required this.progress,
    required this.totalSize,
    required this.downloadedSize,
    required this.speed,
    required this.timeRemaining,
    required this.startTime,
  });
}
