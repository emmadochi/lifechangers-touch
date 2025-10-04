import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class PremiumContentPreviewScreen extends StatefulWidget {
  const PremiumContentPreviewScreen({super.key});

  @override
  State<PremiumContentPreviewScreen> createState() => _PremiumContentPreviewScreenState();
}

class _PremiumContentPreviewScreenState extends State<PremiumContentPreviewScreen> {
  bool _isPreviewPlaying = false;
  int _currentPreviewTime = 0;
  int _totalPreviewTime = 30; // 30 seconds preview
  bool _hasEnoughCoins = true;
  int _userCoins = 1250;

  // Mock premium content - replace with actual content data
  final ContentModel _content = ContentModel(
    id: 'premium_1',
    title: 'The Power of Faith - Complete Series',
    description: 'A comprehensive 12-part series exploring the depths of Christian faith, from basic principles to advanced spiritual concepts. This premium content includes exclusive teachings, guided meditations, and practical exercises.',
    type: ContentType.video,
    status: ContentStatus.premium,
    coinCost: 500,
    category: 'premium-series',
    tags: ['faith', 'spiritual', 'premium', 'series'],
    author: 'Dr. Sarah Williams',
    createdAt: DateTime.now(),
    duration: 7200, // 2 hours
    viewCount: 0,
    downloadCount: 0,
    rating: 0,
    isDownloadable: true,
    isLive: false,
  );

  final List<ContentModel> _relatedContent = [
    ContentModel(
      id: 'related_1',
      title: 'Faith Foundations',
      description: 'Basic principles of Christian faith',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'sermons',
      tags: ['faith', 'basics'],
      author: 'Pastor John Doe',
      createdAt: DateTime.now(),
      duration: 1800,
      viewCount: 1250,
      downloadCount: 45,
      rating: 4.8,
      isDownloadable: true,
      isLive: false,
    ),
    ContentModel(
      id: 'related_2',
      title: 'Spiritual Growth Guide',
      description: 'A practical guide to spiritual development',
      type: ContentType.book,
      status: ContentStatus.premium,
      coinCost: 200,
      category: 'books',
      tags: ['spiritual', 'growth'],
      author: 'Dr. Michael Johnson',
      createdAt: DateTime.now(),
      duration: 0,
      viewCount: 890,
      downloadCount: 32,
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
                    // Preview Video Placeholder
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
                    
                    // Preview Controls
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        children: [
                          // Progress Bar
                          LinearProgressIndicator(
                            value: _currentPreviewTime / _totalPreviewTime,
                            backgroundColor: Colors.white.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Preview: ${_currentPreviewTime}s / ${_totalPreviewTime}s',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Premium Badge
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.diamond,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'PREMIUM',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                  
                  // Cost and User Balance
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.diamond,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_content.coinCost} coins',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Your balance: $_userCoins coins',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  Text(
                    _content.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Content Features
                  _buildContentFeatures(),
                  
                  const SizedBox(height: 24),
                  
                  // Purchase Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _hasEnoughCoins ? _purchaseContent : _buyMoreCoins,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasEnoughCoins ? AppColors.primary : AppColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _hasEnoughCoins ? 'Purchase for ${_content.coinCost} coins' : 'Buy More Coins',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  if (!_hasEnoughCoins) ...[
                    const SizedBox(height: 8),
                    Text(
                      'You need ${_content.coinCost - _userCoins} more coins to purchase this content',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Related Content
                  Text(
                    'Related Content',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ..._relatedContent.map((content) => _RelatedContentCard(
                    content: content,
                    onTap: () => _viewRelatedContent(content),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentFeatures() {
    final features = [
      '12-part video series',
      'Exclusive teachings',
      'Guided meditations',
      'Practical exercises',
      'Download for offline viewing',
      'Lifetime access',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s Included',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                feature,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  void _purchaseContent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Purchase'),
        content: Text('Are you sure you want to purchase "${_content.title}" for ${_content.coinCost} coins?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteNames.paywall);
            },
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }

  void _buyMoreCoins() {
    context.go(RouteNames.coinPurchase);
  }

  void _shareContent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing content...'),
      ),
    );
  }

  void _viewRelatedContent(ContentModel content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${content.title}'),
      ),
    );
  }
}

class _RelatedContentCard extends StatelessWidget {
  final ContentModel content;
  final VoidCallback onTap;

  const _RelatedContentCard({
    required this.content,
    required this.onTap,
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
              // Content Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getContentColor(content.type),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getContentIcon(content.type),
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
                      content.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content.author,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Cost
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (content.isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${content.coinCost}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'FREE',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'coins',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
}
