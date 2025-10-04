import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class ErrorScreen extends StatefulWidget {
  final String? errorMessage;
  final String? errorCode;
  final String? errorTitle;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;
  final bool showRetryButton;
  final bool showGoHomeButton;
  final IconData? errorIcon;

  const ErrorScreen({
    super.key,
    this.errorMessage,
    this.errorCode,
    this.errorTitle,
    this.onRetry,
    this.onGoHome,
    this.showRetryButton = true,
    this.showGoHomeButton = true,
    this.errorIcon,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
    
    _shakeController.forward();
  }

  @override
  void dispose() {
    _shakeController.dispose();
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
              // Error Icon
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.errorIcon ?? Icons.error_outline,
                        color: AppColors.error,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Error Title
              Text(
                widget.errorTitle ?? 'Oops! Something went wrong',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Error Message
              Text(
                widget.errorMessage ?? 'We encountered an unexpected error. Please try again.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              if (widget.errorCode != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Error Code: ${widget.errorCode}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 48),
              
              // Action Buttons
              Column(
                children: [
                  if (widget.showRetryButton)
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
                  
                  if (widget.showRetryButton && widget.showGoHomeButton)
                    const SizedBox(height: 12),
                  
                  if (widget.showGoHomeButton)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: widget.onGoHome ?? _goHome,
                        icon: const Icon(Icons.home),
                        label: const Text('Go Home'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Help Text
              Text(
                'If this problem persists, please contact our support team.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              TextButton(
                onPressed: _contactSupport,
                child: Text(
                  'Contact Support',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retry() {
    // Default retry behavior - go back
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      context.go(RouteNames.home);
    }
  }

  void _goHome() {
    context.go(RouteNames.home);
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening support contact...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

// Specialized Error Screens
class NetworkErrorScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorScreen({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      errorTitle: 'Connection Error',
      errorMessage: 'Unable to connect to the server. Please check your internet connection and try again.',
      errorIcon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}

class ServerErrorScreen extends StatelessWidget {
  final String? errorCode;
  final VoidCallback? onRetry;

  const ServerErrorScreen({
    super.key,
    this.errorCode,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      errorTitle: 'Server Error',
      errorMessage: 'We\'re experiencing technical difficulties. Our team has been notified and is working to resolve the issue.',
      errorCode: errorCode,
      errorIcon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }
}

class NotFoundErrorScreen extends StatelessWidget {
  final String? resource;
  final VoidCallback? onGoHome;

  const NotFoundErrorScreen({
    super.key,
    this.resource,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      errorTitle: 'Not Found',
      errorMessage: resource != null 
          ? 'The $resource you\'re looking for could not be found.'
          : 'The content you\'re looking for could not be found.',
      errorIcon: Icons.search_off,
      showRetryButton: false,
      onGoHome: onGoHome,
    );
  }
}

class AuthenticationErrorScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const AuthenticationErrorScreen({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      errorTitle: 'Authentication Error',
      errorMessage: 'Your session has expired. Please sign in again to continue.',
      errorIcon: Icons.lock_outline,
      onRetry: onRetry,
    );
  }
}

class PaymentErrorScreen extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const PaymentErrorScreen({
    super.key,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      errorTitle: 'Payment Error',
      errorMessage: errorMessage ?? 'There was an error processing your payment. Please try again or contact support if the problem persists.',
      errorIcon: Icons.payment,
      onRetry: onRetry,
    );
  }
}

class DownloadErrorScreen extends StatelessWidget {
  final String? fileName;
  final VoidCallback? onRetry;

  const DownloadErrorScreen({
    super.key,
    this.fileName,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      errorTitle: 'Download Failed',
      errorMessage: fileName != null 
          ? 'Failed to download $fileName. Please check your internet connection and try again.'
          : 'Download failed. Please check your internet connection and try again.',
      errorIcon: Icons.download_for_offline,
      onRetry: onRetry,
    );
  }
}

class PermissionErrorScreen extends StatelessWidget {
  final String? permission;
  final VoidCallback? onRetry;

  const PermissionErrorScreen({
    super.key,
    this.permission,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorScreen(
      errorTitle: 'Permission Required',
      errorMessage: permission != null 
          ? 'This app needs $permission permission to function properly. Please grant the permission in your device settings.'
          : 'This app needs additional permissions to function properly. Please grant the required permissions in your device settings.',
      errorIcon: Icons.security,
      onRetry: onRetry,
    );
  }
}
