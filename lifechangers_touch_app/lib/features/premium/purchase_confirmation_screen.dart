import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class PurchaseConfirmationScreen extends StatefulWidget {
  const PurchaseConfirmationScreen({super.key});

  @override
  State<PurchaseConfirmationScreen> createState() => _PurchaseConfirmationScreenState();
}

class _PurchaseConfirmationScreenState extends State<PurchaseConfirmationScreen> {
  bool _isDownloading = false;
  bool _isDownloadComplete = false;
  int _downloadProgress = 0;

  // Mock purchase data - replace with actual purchase data
  final ContentModel _purchasedContent = ContentModel(
    id: 'premium_1',
    title: 'The Power of Faith - Complete Series',
    description: 'A comprehensive 12-part series exploring the depths of Christian faith.',
    type: ContentType.video,
    status: ContentStatus.premium,
    coinCost: 500,
    category: 'premium-series',
    tags: ['faith', 'spiritual', 'premium'],
    author: 'Dr. Sarah Williams',
    createdAt: DateTime.now(),
    duration: 7200,
    viewCount: 0,
    downloadCount: 0,
    rating: 0,
    isDownloadable: true,
    isLive: false,
  );

  final String _transactionId = 'TXN_123456789';
  final DateTime _purchaseDate = DateTime.now();
  final int _coinsSpent = 500;
  final int _remainingCoins = 750;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Complete'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _sharePurchase,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Header
            _buildSuccessHeader(),
            
            const SizedBox(height: 24),
            
            // Purchase Details
            _buildPurchaseDetails(),
            
            const SizedBox(height: 24),
            
            // Content Access
            _buildContentAccess(),
            
            const SizedBox(height: 24),
            
            // Download Options
            if (_purchasedContent.isDownloadable)
              _buildDownloadOptions(),
            
            const SizedBox(height: 24),
            
            // Next Steps
            _buildNextSteps(),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Purchase Successful!',
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You now have access to "${_purchasedContent.title}"',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Purchase Details',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildDetailRow('Transaction ID', _transactionId),
            _buildDetailRow('Purchase Date', _formatDate(_purchaseDate)),
            _buildDetailRow('Content', _purchasedContent.title),
            _buildDetailRow('Author', _purchasedContent.author),
            _buildDetailRow('Coins Spent', '$_coinsSpent coins'),
            _buildDetailRow('Remaining Balance', '$_remainingCoins coins'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentAccess() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Access',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Icon(
                  Icons.play_circle_fill,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stream Now',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Start watching immediately',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _startStreaming,
                  child: const Text('Watch Now'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Icon(
                  Icons.download,
                  color: AppColors.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Download for Offline',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Watch without internet connection',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _purchasedContent.isDownloadable ? _startDownload : null,
                  child: const Text('Download'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadOptions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Download Options',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Download Quality
            _buildDownloadQualityOption('High Quality', 'Best experience, larger file size', '2.5 GB'),
            _buildDownloadQualityOption('Medium Quality', 'Good experience, moderate file size', '1.2 GB'),
            _buildDownloadQualityOption('Low Quality', 'Basic experience, smaller file size', '600 MB'),
            
            const SizedBox(height: 16),
            
            // Download Progress
            if (_isDownloading) ...[
              Text(
                'Downloading...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _downloadProgress / 100,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                '$_downloadProgress% complete',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            
            if (_isDownloadComplete) ...[
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Download complete!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadQualityOption(String quality, String description, String size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Radio<String>(
            value: quality,
            groupValue: 'High Quality', // Default selection
            onChanged: (value) {},
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quality,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            size,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextSteps() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What\'s Next?',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildNextStepItem(
              Icons.play_circle_fill,
              'Start Watching',
              'Begin your spiritual journey with this powerful series',
              AppColors.primary,
            ),
            
            _buildNextStepItem(
              Icons.download,
              'Download for Offline',
              'Save content to watch without internet connection',
              AppColors.secondary,
            ),
            
            _buildNextStepItem(
              Icons.share,
              'Share with Friends',
              'Invite others to experience this transformative content',
              AppColors.success,
            ),
            
            _buildNextStepItem(
              Icons.star,
              'Rate and Review',
              'Help others by sharing your experience',
              AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStepItem(IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _startStreaming,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Start Watching Now',
              style: AppTextStyles.titleLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _viewLibrary,
                child: const Text('View Library'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _exploreMore,
                child: const Text('Explore More'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _startStreaming() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting video playback...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _startDownload() {
    setState(() => _isDownloading = true);
    
    // Simulate download progress
    _simulateDownload();
  }

  void _simulateDownload() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _isDownloading) {
        setState(() {
          _downloadProgress += 2;
          if (_downloadProgress >= 100) {
            _downloadProgress = 100;
            _isDownloading = false;
            _isDownloadComplete = true;
          }
        });
        
        if (_downloadProgress < 100) {
          _simulateDownload();
        }
      }
    });
  }

  void _viewLibrary() {
    context.go(RouteNames.media);
  }

  void _exploreMore() {
    context.go(RouteNames.media);
  }

  void _sharePurchase() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing purchase...'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
