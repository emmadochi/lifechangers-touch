import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class NoInternetScreen extends StatefulWidget {
  final VoidCallback? onRetry;
  final bool showOfflineContent;

  const NoInternetScreen({
    super.key,
    this.onRetry,
    this.showOfflineContent = true,
  });

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated No Internet Icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wifi_off,
                        color: AppColors.warning,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Title
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'No Internet Connection',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Message
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'Please check your internet connection and try again.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Action Buttons
              SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: widget.onRetry ?? _retry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    if (widget.showOfflineContent)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _viewOfflineContent,
                          icon: const Icon(Icons.offline_bolt),
                          label: const Text('View Offline Content'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Connection Tips
              SlideTransition(
                position: _slideAnimation,
                child: _buildConnectionTips(),
              ),
              
              const SizedBox(height: 24),
              
              // Offline Content Preview
              if (widget.showOfflineContent)
                SlideTransition(
                  position: _slideAnimation,
                  child: _buildOfflineContentPreview(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionTips() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connection Tips',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildTipItem(
              Icons.wifi,
              'Check your Wi-Fi connection',
              'Make sure you\'re connected to a stable Wi-Fi network',
            ),
            
            _buildTipItem(
              Icons.signal_cellular_alt,
              'Check your mobile data',
              'Ensure mobile data is enabled if not using Wi-Fi',
            ),
            
            _buildTipItem(
              Icons.location_on,
              'Check your location',
              'Some networks may have location-based restrictions',
            ),
            
            _buildTipItem(
              Icons.restart_alt,
              'Restart your device',
              'Sometimes a simple restart can resolve connection issues',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
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

  Widget _buildOfflineContentPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Offline',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Mock offline content
            _buildOfflineContentItem(
              'Sunday Service - The Power of Faith',
              'Video • 45 min',
              Icons.play_circle_fill,
            ),
            
            _buildOfflineContentItem(
              'Worship Collection - Volume 1',
              'Audio • 12 songs',
              Icons.music_note,
            ),
            
            _buildOfflineContentItem(
              'Daily Devotion - Week 1',
              'Book • 7 chapters',
              Icons.menu_book,
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _viewOfflineContent,
                child: const Text('View All Offline Content'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineContentItem(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
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

  void _retry() {
    // Check internet connection and retry
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking internet connection...'),
        backgroundColor: AppColors.primary,
      ),
    );
    
    // Simulate connection check
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // In a real app, you would check actual internet connectivity
        // For now, we'll just show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection restored!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  void _viewOfflineContent() {
    context.go(RouteNames.offlineLibrary);
  }
}

// Specialized No Internet Screens
class NoInternetWithRetryScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetWithRetryScreen({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return NoInternetScreen(
      onRetry: onRetry,
      showOfflineContent: false,
    );
  }
}

class NoInternetWithOfflineScreen extends StatelessWidget {
  const NoInternetWithOfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoInternetScreen(
      showOfflineContent: true,
    );
  }
}
