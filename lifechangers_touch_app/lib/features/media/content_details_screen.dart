import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class ContentDetailsScreen extends StatefulWidget {
  const ContentDetailsScreen({super.key});

  @override
  State<ContentDetailsScreen> createState() => _ContentDetailsScreenState();
}

class _ContentDetailsScreenState extends State<ContentDetailsScreen> {
  bool _isLiked = false;
  bool _isDownloaded = false;
  bool _isBookmarked = false;
  bool _showFullDescription = false;
  int _selectedTab = 0;

  // Mock content - replace with actual content from parameters
  final ContentModel _content = ContentModel(
    id: 'content_1',
    title: 'Sunday Service - Faith and Hope',
    description: 'Join us for an inspiring message about faith, hope, and love in our daily lives. This powerful sermon explores the fundamental principles of Christian faith and how they can transform our perspective on life\'s challenges. Pastor John delivers a message that will strengthen your spiritual foundation and provide practical guidance for living a faith-filled life.',
    thumbnailUrl: null,
    mediaUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    type: ContentType.video,
    status: ContentStatus.premium,
    coinCost: 5,
    category: 'sermons',
    tags: ['faith', 'hope', 'sunday', 'inspiration'],
    author: 'Pastor John Doe',
    createdAt: DateTime.now(),
    duration: 3600, // 1 hour
    viewCount: 1250,
    downloadCount: 45,
    rating: 4.8,
    isDownloadable: true,
    isLive: false,
  );

  final List<ContentModel> _relatedContent = [
    ContentModel(
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
    ContentModel(
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Stack(
                  children: [
                    // Background Image/Video Thumbnail
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: const Icon(
                        Icons.play_circle_fill,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    
                    // Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                    
                    // Play Button
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: _shareContent,
                icon: const Icon(Icons.share, color: Colors.white),
              ),
              IconButton(
                onPressed: _toggleBookmark,
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          // Content Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Author
                  Text(
                    _content.title,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${_content.author}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Stats and Status
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.visibility,
                        label: '${_content.viewCount} views',
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.access_time,
                        label: _content.formattedDuration,
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.star,
                        label: '${_content.rating}',
                      ),
                      const Spacer(),
                      if (_content.isPremium)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.diamond, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${_content.coinCost} coins',
                                style: AppTextStyles.premiumBadge,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _playContent,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _downloadContent,
                          icon: Icon(_isDownloaded ? Icons.download_done : Icons.download),
                          label: Text(_isDownloaded ? 'Downloaded' : 'Download'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: _toggleLike,
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? AppColors.error : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.border,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        _TabButton(
                          label: 'Description',
                          isSelected: _selectedTab == 0,
                          onTap: () => setState(() => _selectedTab = 0),
                        ),
                        _TabButton(
                          label: 'Details',
                          isSelected: _selectedTab == 1,
                          onTap: () => setState(() => _selectedTab = 1),
                        ),
                        _TabButton(
                          label: 'Related',
                          isSelected: _selectedTab == 2,
                          onTap: () => setState(() => _selectedTab = 2),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tab Content
                  _buildTabContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildDescriptionTab();
      case 1:
        return _buildDetailsTab();
      case 2:
        return _buildRelatedTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDescriptionTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _content.description,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            height: 1.5,
          ),
          maxLines: _showFullDescription ? null : 4,
          overflow: _showFullDescription ? null : TextOverflow.ellipsis,
        ),
        if (!_showFullDescription)
          TextButton(
            onPressed: () => setState(() => _showFullDescription = true),
            child: const Text('Read more'),
          ),
        
        const SizedBox(height: 24),
        
        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _content.tags.map((tag) => Chip(
            label: Text(tag),
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            labelStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return Column(
      children: [
        _DetailRow(
          label: 'Category',
          value: _content.category.toUpperCase(),
        ),
        _DetailRow(
          label: 'Duration',
          value: _content.formattedDuration,
        ),
        _DetailRow(
          label: 'Published',
          value: _content.publishedAt?.toIso8601String() ?? 'Not available',
        ),
        _DetailRow(
          label: 'Downloads',
          value: '${_content.downloadCount}',
        ),
        _DetailRow(
          label: 'Rating',
          value: '${_content.rating}/5.0',
        ),
        _DetailRow(
          label: 'Type',
          value: _content.type.toString().split('.').last.toUpperCase(),
        ),
        if (_content.isPremium)
          _DetailRow(
            label: 'Cost',
            value: '${_content.coinCost} coins',
          ),
      ],
    );
  }

  Widget _buildRelatedTab() {
    return Column(
      children: _relatedContent.map((content) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getContentIcon(content.type),
              color: AppColors.primary,
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
                ],
              ),
            ],
          ),
          trailing: content.isPremium
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${content.coinCost}',
                    style: AppTextStyles.premiumBadge,
                  ),
                )
              : null,
          onTap: () => _navigateToContent(content),
        ),
      )).toList(),
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

  void _playContent() {
    // TODO: Navigate to appropriate player based on content type
    switch (_content.type) {
      case ContentType.video:
        context.go(RouteNames.videoPlayer);
        break;
      case ContentType.audio:
        context.go(RouteNames.audioPlayer);
        break;
      case ContentType.book:
        context.go(RouteNames.bookReader);
        break;
      case ContentType.message:
        // Handle message content
        break;
    }
  }

  void _downloadContent() {
    setState(() {
      _isDownloaded = !_isDownloaded;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isDownloaded ? 'Download started' : 'Download removed'),
        backgroundColor: _isDownloaded ? AppColors.success : AppColors.textSecondary,
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  void _shareContent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share options coming soon'),
      ),
    );
  }

  void _navigateToContent(ContentModel content) {
    // TODO: Navigate to content details for related content
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${content.title}'),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.titleMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
