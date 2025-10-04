import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class LivestreamsListScreen extends StatefulWidget {
  const LivestreamsListScreen({super.key});

  @override
  State<LivestreamsListScreen> createState() => _LivestreamsListScreenState();
}

class _LivestreamsListScreenState extends State<LivestreamsListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  bool _isLive = true;

  final List<String> _filterOptions = ['All', 'Live Now', 'Upcoming', 'Past Events'];
  final List<String> _categories = ['All', 'Sunday Service', 'Prayer Meeting', 'Bible Study', 'Special Events'];

  // Mock livestream data - replace with actual data
  final List<ContentModel> _liveStreams = [
    ContentModel(
      id: 'live_1',
      title: 'Sunday Morning Service',
      description: 'Join us for our weekly Sunday service with worship, prayer, and an inspiring message.',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'sunday-service',
      tags: ['sunday', 'service', 'worship', 'live'],
      author: 'Pastor John Doe',
      createdAt: DateTime.now(),
      duration: 0,
      viewCount: 1250,
      downloadCount: 0,
      rating: 4.8,
      isDownloadable: false,
      isLive: true,
      streamUrl: 'https://example.com/stream1',
      scheduledAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ContentModel(
      id: 'live_2',
      title: 'Prayer Meeting',
      description: 'Weekly prayer meeting for community needs and spiritual growth.',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'prayer-meeting',
      tags: ['prayer', 'community', 'live'],
      author: 'Pastor Sarah Johnson',
      createdAt: DateTime.now(),
      duration: 0,
      viewCount: 450,
      downloadCount: 0,
      rating: 4.9,
      isDownloadable: false,
      isLive: true,
      streamUrl: 'https://example.com/stream2',
      scheduledAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  final List<ContentModel> _upcomingStreams = [
    ContentModel(
      id: 'upcoming_1',
      title: 'Bible Study - Book of Romans',
      description: 'Deep dive into the Book of Romans with Pastor John.',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'bible-study',
      tags: ['bible', 'study', 'romans'],
      author: 'Pastor John Doe',
      createdAt: DateTime.now(),
      duration: 0,
      viewCount: 0,
      downloadCount: 0,
      rating: 0,
      isDownloadable: false,
      isLive: false,
      streamUrl: 'https://example.com/stream3',
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
    ),
    ContentModel(
      id: 'upcoming_2',
      title: 'Youth Service',
      description: 'Special service for our youth community.',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'youth-service',
      tags: ['youth', 'service', 'special'],
      author: 'Pastor Mike Wilson',
      createdAt: DateTime.now(),
      duration: 0,
      viewCount: 0,
      downloadCount: 0,
      rating: 0,
      isDownloadable: false,
      isLive: false,
      streamUrl: 'https://example.com/stream4',
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
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
        title: const Text('Live Streams'),
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: _showSchedule,
            icon: const Icon(Icons.schedule),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Live Now'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Past Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLiveStreamsTab(),
          _buildUpcomingStreamsTab(),
          _buildPastEventsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createStream,
        icon: const Icon(Icons.videocam),
        label: const Text('Go Live'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildLiveStreamsTab() {
    if (_liveStreams.isEmpty) {
      return _buildEmptyState(
        icon: Icons.live_tv,
        title: 'No Live Streams',
        subtitle: 'Check back later for live content',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshLiveStreams,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _liveStreams.length,
        itemBuilder: (context, index) {
          final stream = _liveStreams[index];
          return _LiveStreamCard(
            stream: stream,
            onTap: () => _joinStream(stream),
            onShare: () => _shareStream(stream),
            onNotify: () => _notifyStream(stream),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingStreamsTab() {
    if (_upcomingStreams.isEmpty) {
      return _buildEmptyState(
        icon: Icons.schedule,
        title: 'No Upcoming Streams',
        subtitle: 'Check back later for scheduled content',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _upcomingStreams.length,
      itemBuilder: (context, index) {
        final stream = _upcomingStreams[index];
        return _UpcomingStreamCard(
          stream: stream,
          onTap: () => _viewStreamDetails(stream),
          onRemind: () => _setReminder(stream),
          onShare: () => _shareStream(stream),
        );
      },
    );
  }

  Widget _buildPastEventsTab() {
    return _buildEmptyState(
      icon: Icons.history,
      title: 'Past Events',
      subtitle: 'View recordings of past live streams',
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

  Future<void> _refreshLiveStreams() async {
    // TODO: Refresh live streams data
    await Future.delayed(const Duration(seconds: 1));
  }

  void _joinStream(ContentModel stream) {
    context.go(RouteNames.activeLivestream);
  }

  void _viewStreamDetails(ContentModel stream) {
    // TODO: Navigate to stream details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${stream.title}'),
      ),
    );
  }

  void _shareStream(ContentModel stream) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${stream.title}'),
      ),
    );
  }

  void _notifyStream(ContentModel stream) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notifications enabled for ${stream.title}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _setReminder(ContentModel stream) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for ${stream.title}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _createStream() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Go Live feature coming soon'),
      ),
    );
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
              'Filter Streams',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Category Filter
            Text(
              'Category',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) => FilterChip(
                label: Text(category),
                selected: _selectedFilter == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = category;
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

  void _showSchedule() {
    context.go(RouteNames.streamSchedule);
  }
}

class _LiveStreamCard extends StatelessWidget {
  final ContentModel stream;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onNotify;

  const _LiveStreamCard({
    required this.stream,
    required this.onTap,
    required this.onShare,
    required this.onNotify,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stream Thumbnail
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  // Live Indicator
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // View Count
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${stream.viewCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Play Button
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Stream Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stream.title,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stream.author,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stream.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Join Stream'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onShare,
                        icon: const Icon(Icons.share),
                        color: AppColors.textSecondary,
                      ),
                      IconButton(
                        onPressed: onNotify,
                        icon: const Icon(Icons.notifications),
                        color: AppColors.textSecondary,
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
}

class _UpcomingStreamCard extends StatelessWidget {
  final ContentModel stream;
  final VoidCallback onTap;
  final VoidCallback onRemind;
  final VoidCallback onShare;

  const _UpcomingStreamCard({
    required this.stream,
    required this.onTap,
    required this.onRemind,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.schedule,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stream.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stream.author,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatScheduledTime(stream.scheduledAt!),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Text(
                stream.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRemind,
                      icon: const Icon(Icons.notifications),
                      label: const Text('Set Reminder'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
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

  String _formatScheduledTime(DateTime scheduledAt) {
    final now = DateTime.now();
    final difference = scheduledAt.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
}
