import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoDownloadEnabled = false;
  bool _locationServicesEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedQuality = 'High';
  String _selectedStorage = 'Internal';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Portuguese'];
  final List<String> _qualities = ['Low', 'Medium', 'High', 'Ultra'];
  final List<String> _storageOptions = ['Internal', 'SD Card', 'Cloud'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _resetSettings,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(),
            
            const SizedBox(height: 24),
            
            // General Settings
            _buildSettingsSection(
              'General',
              [
                _buildSettingsTile(
                  icon: Icons.person,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: _editProfile,
                ),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  onTap: _changeLanguage,
                ),
                _buildSettingsTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: _darkModeEnabled ? 'Enabled' : 'Disabled',
                  trailing: Switch(
                    value: _darkModeEnabled,
                    onChanged: (value) => setState(() => _darkModeEnabled = value),
                    activeColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Notifications
            _buildSettingsSection(
              'Notifications',
              [
                _buildSettingsTile(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  subtitle: _notificationsEnabled ? 'Enabled' : 'Disabled',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) => setState(() => _notificationsEnabled = value),
                    activeColor: AppColors.primary,
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.email,
                  title: 'Email Notifications',
                  subtitle: 'Manage email preferences',
                  onTap: _manageEmailNotifications,
                ),
                _buildSettingsTile(
                  icon: Icons.schedule,
                  title: 'Quiet Hours',
                  subtitle: 'Set do not disturb times',
                  onTap: _setQuietHours,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Media & Content
            _buildSettingsSection(
              'Media & Content',
              [
                _buildSettingsTile(
                  icon: Icons.download,
                  title: 'Auto Download',
                  subtitle: _autoDownloadEnabled ? 'Enabled' : 'Disabled',
                  trailing: Switch(
                    value: _autoDownloadEnabled,
                    onChanged: (value) => setState(() => _autoDownloadEnabled = value),
                    activeColor: AppColors.primary,
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.high_quality,
                  title: 'Video Quality',
                  subtitle: _selectedQuality,
                  onTap: _changeVideoQuality,
                ),
                _buildSettingsTile(
                  icon: Icons.storage,
                  title: 'Storage Location',
                  subtitle: _selectedStorage,
                  onTap: _changeStorageLocation,
                ),
                _buildSettingsTile(
                  icon: Icons.offline_bolt,
                  title: 'Offline Content',
                  subtitle: 'Manage downloaded content',
                  onTap: _manageOfflineContent,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Privacy & Security
            _buildSettingsSection(
              'Privacy & Security',
              [
                _buildSettingsTile(
                  icon: Icons.location_on,
                  title: 'Location Services',
                  subtitle: _locationServicesEnabled ? 'Enabled' : 'Disabled',
                  trailing: Switch(
                    value: _locationServicesEnabled,
                    onChanged: (value) => setState(() => _locationServicesEnabled = value),
                    activeColor: AppColors.primary,
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Settings',
                  subtitle: 'Control your data privacy',
                  onTap: _openPrivacySettings,
                ),
                _buildSettingsTile(
                  icon: Icons.security,
                  title: 'Security',
                  subtitle: 'Password and authentication',
                  onTap: _openSecuritySettings,
                ),
                _buildSettingsTile(
                  icon: Icons.block,
                  title: 'Blocked Users',
                  subtitle: 'Manage blocked community members',
                  onTap: _manageBlockedUsers,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Account
            _buildSettingsSection(
              'Account',
              [
                _buildSettingsTile(
                  icon: Icons.account_balance_wallet,
                  title: 'Wallet & Payments',
                  subtitle: 'Manage your coins and payment methods',
                  onTap: _openWalletSettings,
                ),
                _buildSettingsTile(
                  icon: Icons.history,
                  title: 'Purchase History',
                  subtitle: 'View your transaction history',
                  onTap: _viewPurchaseHistory,
                ),
                _buildSettingsTile(
                  icon: Icons.family_restroom,
                  title: 'Family Sharing',
                  subtitle: 'Share content with family members',
                  onTap: _manageFamilySharing,
                ),
                _buildSettingsTile(
                  icon: Icons.help,
                  title: 'Help & Support',
                  subtitle: 'Get help and contact support',
                  onTap: _openHelpSupport,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // App Info
            _buildSettingsSection(
              'App Information',
              [
                _buildSettingsTile(
                  icon: Icons.info,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: _openAbout,
                ),
                _buildSettingsTile(
                  icon: Icons.update,
                  title: 'Check for Updates',
                  subtitle: 'Version 1.0.0',
                  onTap: _checkForUpdates,
                ),
                _buildSettingsTile(
                  icon: Icons.bug_report,
                  title: 'Report a Bug',
                  subtitle: 'Help us improve the app',
                  onTap: _reportBug,
                ),
                _buildSettingsTile(
                  icon: Icons.star,
                  title: 'Rate the App',
                  subtitle: 'Share your experience',
                  onTap: _rateApp,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Danger Zone
            _buildDangerZone(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'john.doe@example.com',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Premium Member',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danger Zone',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: AppColors.error.withValues(alpha: 0.05),
          child: Column(
            children: [
              _buildSettingsTile(
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                onTap: _signOut,
              ),
              _buildSettingsTile(
                icon: Icons.delete_forever,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: _deleteAccount,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Action Methods
  void _editProfile() {
    context.go(RouteNames.editProfile);
  }

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) => RadioListTile<String>(
            title: Text(language),
            value: language,
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() => _selectedLanguage = value!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _manageEmailNotifications() {
    context.go(RouteNames.notificationSettings);
  }

  void _setQuietHours() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiet hours settings coming soon'),
      ),
    );
  }

  void _changeVideoQuality() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _qualities.map((quality) => RadioListTile<String>(
            title: Text(quality),
            value: quality,
            groupValue: _selectedQuality,
            onChanged: (value) {
              setState(() => _selectedQuality = value!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _changeStorageLocation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _storageOptions.map((storage) => RadioListTile<String>(
            title: Text(storage),
            value: storage,
            groupValue: _selectedStorage,
            onChanged: (value) {
              setState(() => _selectedStorage = value!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _manageOfflineContent() {
    context.go(RouteNames.offlineLibrary);
  }

  void _openPrivacySettings() {
    context.go(RouteNames.privacySettings);
  }

  void _openSecuritySettings() {
    context.go(RouteNames.accountSettings);
  }

  void _manageBlockedUsers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Blocked users management coming soon'),
      ),
    );
  }

  void _openWalletSettings() {
    context.go(RouteNames.walletDashboard);
  }

  void _viewPurchaseHistory() {
    context.go(RouteNames.transactionHistory);
  }

  void _manageFamilySharing() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Family sharing coming soon'),
      ),
    );
  }

  void _openHelpSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & support coming soon'),
      ),
    );
  }

  void _openAbout() {
    context.go(RouteNames.about);
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checking for updates...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _reportBug() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bug reporting coming soon'),
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App rating coming soon'),
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out successfully'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action cannot be undone. Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion coming soon'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _notificationsEnabled = true;
                _darkModeEnabled = false;
                _autoDownloadEnabled = false;
                _locationServicesEnabled = true;
                _selectedLanguage = 'English';
                _selectedQuality = 'High';
                _selectedStorage = 'Internal';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to default'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
