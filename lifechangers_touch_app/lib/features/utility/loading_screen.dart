import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class LoadingScreen extends StatefulWidget {
  final String? message;
  final bool showProgress;
  final double? progress;
  final VoidCallback? onCancel;

  const LoadingScreen({
    super.key,
    this.message,
    this.showProgress = false,
    this.progress,
    this.onCancel,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // App Name
            Text(
              'Lifechangers Touch',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Connecting Faith, Inspiring Lives',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Loading Indicator
            if (widget.showProgress && widget.progress != null)
              _buildProgressIndicator()
            else
              _buildSpinningIndicator(),
            
            const SizedBox(height: 24),
            
            // Loading Message
            if (widget.message != null)
              Text(
                widget.message!,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            
            const SizedBox(height: 16),
            
            // Loading Steps
            _buildLoadingSteps(),
            
            const SizedBox(height: 32),
            
            // Cancel Button (if provided)
            if (widget.onCancel != null)
              TextButton(
                onPressed: widget.onCancel,
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpinningIndicator() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.14159,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: widget.progress,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${((widget.progress ?? 0) * 100).toInt()}%',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSteps() {
    final steps = [
      'Initializing app...',
      'Loading user data...',
      'Syncing content...',
      'Ready to go!',
    ];

    return Column(
      children: steps.map((step) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              step,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

// Specialized Loading Screens
class AppInitializationScreen extends StatelessWidget {
  const AppInitializationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingScreen(
      message: 'Initializing Lifechangers Touch...',
      showProgress: true,
      progress: 0.0,
    );
  }
}

class ContentLoadingScreen extends StatelessWidget {
  final String contentName;
  final double? progress;

  const ContentLoadingScreen({
    super.key,
    required this.contentName,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      message: 'Loading $contentName...',
      showProgress: progress != null,
      progress: progress,
    );
  }
}

class DownloadLoadingScreen extends StatelessWidget {
  final String fileName;
  final double progress;
  final VoidCallback? onCancel;

  const DownloadLoadingScreen({
    super.key,
    required this.fileName,
    required this.progress,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      message: 'Downloading $fileName...',
      showProgress: true,
      progress: progress,
      onCancel: onCancel,
    );
  }
}

class PaymentProcessingScreen extends StatelessWidget {
  const PaymentProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingScreen(
      message: 'Processing your payment...',
      showProgress: true,
      progress: 0.0,
    );
  }
}

class SyncLoadingScreen extends StatelessWidget {
  final String syncType;
  final double? progress;

  const SyncLoadingScreen({
    super.key,
    required this.syncType,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      message: 'Syncing $syncType...',
      showProgress: progress != null,
      progress: progress,
    );
  }
}
