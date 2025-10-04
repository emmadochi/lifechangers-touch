import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/registration_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/email_verification_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/media/media_screen.dart';
import '../../features/connect/connect_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/feature_selection_screen.dart';
import '../../features/onboarding/permissions_screen.dart';
import '../../features/onboarding/welcome_complete_screen.dart';
import '../../features/media/video_player_screen.dart';
import '../../features/media/audio_player_screen.dart';
import '../../features/media/book_reader_screen.dart';
import '../../features/media/content_details_screen.dart';
import '../../features/media/search_results_screen.dart';
import '../../features/media/content_filter_screen.dart';
import '../../features/livestream/livestreams_list_screen.dart';
import '../../features/livestream/active_livestream_screen.dart';
import '../../features/livestream/stream_schedule_screen.dart';
import '../../features/downloads/downloads_screen.dart';
import '../../features/downloads/download_progress_screen.dart';
import '../../features/downloads/offline_library_screen.dart';
import '../../features/downloads/download_settings_screen.dart';
import '../../features/wallet/give_screen.dart';
import '../../features/wallet/wallet_dashboard_screen.dart';
import '../../features/wallet/coin_purchase_screen.dart';
import '../../features/premium/premium_content_preview_screen.dart';
import '../../features/premium/paywall_screen.dart';
import '../../features/premium/purchase_confirmation_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/settings/notification_settings_screen.dart';
import '../../features/utility/loading_screen.dart';
import '../../features/utility/error_screen.dart';
import '../../features/utility/no_internet_screen.dart';
import '../../features/utility/terms_and_conditions_screen.dart';
import '../../features/utility/privacy_policy_screen.dart';
import '../../features/utility/about_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // Splash Route
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.emailVerification,
        name: 'email-verification',
        builder: (context, state) => const EmailVerificationScreen(),
      ),
      
      // Onboarding Routes
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.featureSelection,
        name: 'feature-selection',
        builder: (context, state) => const FeatureSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.permissions,
        name: 'permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: RouteNames.welcomeComplete,
        name: 'welcome-complete',
        builder: (context, state) => const WelcomeCompleteScreen(),
      ),
      
      // Media Player Routes
      GoRoute(
        path: RouteNames.videoPlayer,
        name: 'video-player',
        builder: (context, state) => const VideoPlayerScreen(),
      ),
      GoRoute(
        path: RouteNames.audioPlayer,
        name: 'audio-player',
        builder: (context, state) => const AudioPlayerScreen(),
      ),
      GoRoute(
        path: RouteNames.bookReader,
        name: 'book-reader',
        builder: (context, state) => const BookReaderScreen(),
      ),
      GoRoute(
        path: RouteNames.contentDetails,
        name: 'content-details',
        builder: (context, state) => const ContentDetailsScreen(),
      ),
      GoRoute(
        path: RouteNames.searchResults,
        name: 'search-results',
        builder: (context, state) => const SearchResultsScreen(),
      ),
      GoRoute(
        path: RouteNames.contentFilter,
        name: 'content-filter',
        builder: (context, state) => const ContentFilterScreen(),
      ),
      
      // Live Streaming Routes
      GoRoute(
        path: RouteNames.livestreamsList,
        name: 'livestreams-list',
        builder: (context, state) => const LivestreamsListScreen(),
      ),
      GoRoute(
        path: RouteNames.activeLivestream,
        name: 'active-livestream',
        builder: (context, state) => const ActiveLivestreamScreen(),
      ),
      GoRoute(
        path: RouteNames.streamSchedule,
        name: 'stream-schedule',
        builder: (context, state) => const StreamScheduleScreen(),
      ),
      
      // Download & Offline Routes
      GoRoute(
        path: RouteNames.downloads,
        name: 'downloads',
        builder: (context, state) => const DownloadsScreen(),
      ),
      GoRoute(
        path: RouteNames.downloadProgress,
        name: 'download-progress',
        builder: (context, state) => const DownloadProgressScreen(),
      ),
      GoRoute(
        path: RouteNames.offlineLibrary,
        name: 'offline-library',
        builder: (context, state) => const OfflineLibraryScreen(),
      ),
      GoRoute(
        path: RouteNames.downloadSettings,
        name: 'download-settings',
        builder: (context, state) => const DownloadSettingsScreen(),
      ),
      
      // Wallet & Payment Routes
      GoRoute(
        path: RouteNames.give,
        name: 'give',
        builder: (context, state) => const GiveScreen(),
      ),
      GoRoute(
        path: RouteNames.walletDashboard,
        name: 'wallet-dashboard',
        builder: (context, state) => const WalletDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.coinPurchase,
        name: 'coin-purchase',
        builder: (context, state) => const CoinPurchaseScreen(),
      ),
      
      // Premium Content Routes
      GoRoute(
        path: RouteNames.premiumContentPreview,
        name: 'premium-content-preview',
        builder: (context, state) => const PremiumContentPreviewScreen(),
      ),
      GoRoute(
        path: RouteNames.paywall,
        name: 'paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: RouteNames.purchaseConfirmation,
        name: 'purchase-confirmation',
        builder: (context, state) => const PurchaseConfirmationScreen(),
      ),
      
      // Settings & Profile Routes
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.notificationSettings,
        name: 'notification-settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      
      // Utility Routes
      GoRoute(
        path: RouteNames.loading,
        name: 'loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: RouteNames.error,
        name: 'error',
        builder: (context, state) => ErrorScreen(
          errorMessage: state.extra as String? ?? 'Something went wrong!',
        ),
      ),
      GoRoute(
        path: RouteNames.noInternet,
        name: 'no-internet',
        builder: (context, state) => const NoInternetScreen(),
      ),
      GoRoute(
        path: RouteNames.termsAndConditions,
        name: 'terms-and-conditions',
        builder: (context, state) => const TermsAndConditionsScreen(),
      ),
      GoRoute(
        path: RouteNames.privacyPolicy,
        name: 'privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: RouteNames.about,
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      
      // Main App Shell with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => _MainAppShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.media,
            name: 'media',
            builder: (context, state) => const MediaScreen(),
          ),
          GoRoute(
            path: RouteNames.connect,
            name: 'connect',
            builder: (context, state) => const ConnectScreen(),
          ),
          GoRoute(
            path: RouteNames.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Content Routes
      GoRoute(
        path: RouteNames.contentDetails,
        name: 'content-details',
        builder: (context, state) => const _PlaceholderScreen('Content Details Screen'),
      ),
      GoRoute(
        path: RouteNames.videoPlayer,
        name: 'video-player',
        builder: (context, state) => const _PlaceholderScreen('Video Player Screen'),
      ),
      GoRoute(
        path: RouteNames.audioPlayer,
        name: 'audio-player',
        builder: (context, state) => const _PlaceholderScreen('Audio Player Screen'),
      ),
      GoRoute(
        path: RouteNames.bookReader,
        name: 'book-reader',
        builder: (context, state) => const _PlaceholderScreen('Book Reader Screen'),
      ),
      GoRoute(
        path: RouteNames.searchResults,
        name: 'search-results',
        builder: (context, state) => const _PlaceholderScreen('Search Results Screen'),
      ),
      GoRoute(
        path: RouteNames.contentFilter,
        name: 'content-filter',
        builder: (context, state) => const _PlaceholderScreen('Content Filter Screen'),
      ),
      
      // Live Streaming Routes
      GoRoute(
        path: RouteNames.livestreamsList,
        name: 'livestreams-list',
        builder: (context, state) => const _PlaceholderScreen('Livestreams List Screen'),
      ),
      GoRoute(
        path: RouteNames.activeLivestream,
        name: 'active-livestream',
        builder: (context, state) => const _PlaceholderScreen('Active Livestream Screen'),
      ),
      GoRoute(
        path: RouteNames.streamSchedule,
        name: 'stream-schedule',
        builder: (context, state) => const _PlaceholderScreen('Stream Schedule Screen'),
      ),
      GoRoute(
        path: RouteNames.streamChat,
        name: 'stream-chat',
        builder: (context, state) => const _PlaceholderScreen('Stream Chat Screen'),
      ),
      
      // Download Routes
      GoRoute(
        path: RouteNames.downloads,
        name: 'downloads',
        builder: (context, state) => const _PlaceholderScreen('Downloads Screen'),
      ),
      GoRoute(
        path: RouteNames.downloadProgress,
        name: 'download-progress',
        builder: (context, state) => const _PlaceholderScreen('Download Progress Screen'),
      ),
      GoRoute(
        path: RouteNames.offlineLibrary,
        name: 'offline-library',
        builder: (context, state) => const _PlaceholderScreen('Offline Library Screen'),
      ),
      GoRoute(
        path: RouteNames.downloadSettings,
        name: 'download-settings',
        builder: (context, state) => const _PlaceholderScreen('Download Settings Screen'),
      ),
      
      // Wallet Routes
      GoRoute(
        path: RouteNames.give,
        name: 'give',
        builder: (context, state) => const _PlaceholderScreen('Give Screen'),
      ),
      GoRoute(
        path: RouteNames.walletDashboard,
        name: 'wallet-dashboard',
        builder: (context, state) => const _PlaceholderScreen('Wallet Dashboard Screen'),
      ),
      GoRoute(
        path: RouteNames.coinPurchase,
        name: 'coin-purchase',
        builder: (context, state) => const _PlaceholderScreen('Coin Purchase Screen'),
      ),
      GoRoute(
        path: RouteNames.transactionHistory,
        name: 'transaction-history',
        builder: (context, state) => const _PlaceholderScreen('Transaction History Screen'),
      ),
      GoRoute(
        path: RouteNames.paymentMethods,
        name: 'payment-methods',
        builder: (context, state) => const _PlaceholderScreen('Payment Methods Screen'),
      ),
      GoRoute(
        path: RouteNames.earnCoins,
        name: 'earn-coins',
        builder: (context, state) => const _PlaceholderScreen('Earn Coins Screen'),
      ),
      
      // Premium Content Routes
      GoRoute(
        path: RouteNames.premiumContentPreview,
        name: 'premium-preview',
        builder: (context, state) => const _PlaceholderScreen('Premium Preview Screen'),
      ),
      GoRoute(
        path: RouteNames.paywall,
        name: 'paywall',
        builder: (context, state) => const _PlaceholderScreen('Paywall Screen'),
      ),
      GoRoute(
        path: RouteNames.purchaseConfirmation,
        name: 'purchase-confirmation',
        builder: (context, state) => const _PlaceholderScreen('Purchase Confirmation Screen'),
      ),
      
      // Settings Routes
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const _PlaceholderScreen('Settings Screen'),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: 'edit-profile',
        builder: (context, state) => const _PlaceholderScreen('Edit Profile Screen'),
      ),
      GoRoute(
        path: RouteNames.notificationSettings,
        name: 'notification-settings',
        builder: (context, state) => const _PlaceholderScreen('Notification Settings Screen'),
      ),
      GoRoute(
        path: RouteNames.privacySettings,
        name: 'privacy-settings',
        builder: (context, state) => const _PlaceholderScreen('Privacy Settings Screen'),
      ),
      GoRoute(
        path: RouteNames.accountSettings,
        name: 'account-settings',
        builder: (context, state) => const _PlaceholderScreen('Account Settings Screen'),
      ),
      
      // Utility Routes
      GoRoute(
        path: RouteNames.loading,
        name: 'loading',
        builder: (context, state) => const _PlaceholderScreen('Loading Screen'),
      ),
      GoRoute(
        path: RouteNames.error,
        name: 'error',
        builder: (context, state) => const _PlaceholderScreen('Error Screen'),
      ),
      GoRoute(
        path: RouteNames.noInternet,
        name: 'no-internet',
        builder: (context, state) => const _PlaceholderScreen('No Internet Screen'),
      ),
      GoRoute(
        path: RouteNames.termsAndConditions,
        name: 'terms-and-conditions',
        builder: (context, state) => const _PlaceholderScreen('Terms and Conditions Screen'),
      ),
      GoRoute(
        path: RouteNames.privacyPolicy,
        name: 'privacy-policy',
        builder: (context, state) => const _PlaceholderScreen('Privacy Policy Screen'),
      ),
      GoRoute(
        path: RouteNames.about,
        name: 'about',
        builder: (context, state) => const _PlaceholderScreen('About Screen'),
      ),
    ],
    errorBuilder: (context, state) => const _PlaceholderScreen('Error Screen'),
  );
}

// Placeholder screens for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This screen is under development',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// Main app shell with bottom navigation
class _MainAppShell extends StatelessWidget {
  final Widget child;
  const _MainAppShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTabTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Media',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.connect_without_contact_outlined),
            activeIcon: Icon(Icons.connect_without_contact),
            label: 'Connect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    if (location == RouteNames.home) return 0;
    if (location == RouteNames.media) return 1;
    if (location == RouteNames.connect) return 2;
    if (location == RouteNames.profile) return 3;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.go(RouteNames.media);
        break;
      case 2:
        context.go(RouteNames.connect);
        break;
      case 3:
        context.go(RouteNames.profile);
        break;
    }
  }
}