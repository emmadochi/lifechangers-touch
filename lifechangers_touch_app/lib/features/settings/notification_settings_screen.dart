import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // General Notifications
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _smsNotificationsEnabled = false;
  
  // Content Notifications
  bool _newContentNotifications = true;
  bool _liveStreamNotifications = true;
  bool _premiumContentNotifications = true;
  bool _downloadCompleteNotifications = true;
  
  // Community Notifications
  bool _prayerRequestNotifications = true;
  bool _communityPostNotifications = true;
  bool _eventNotifications = true;
  bool _friendRequestNotifications = true;
  
  // Giving & Wallet Notifications
  bool _givingReminders = true;
  bool _walletActivityNotifications = true;
  bool _coinEarnedNotifications = true;
  bool _paymentNotifications = true;
  
  // Quiet Hours
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);
  
  // Notification Frequency
  String _notificationFrequency = 'Immediate';
  final List<String> _frequencies = ['Immediate', 'Hourly', 'Daily', 'Weekly'];
  
  // Notification Sound
  String _notificationSound = 'Default';
  final List<String> _sounds = ['Default', 'Gentle', 'Chime', 'Bell', 'Silent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: _resetToDefaults,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Notifications
            _buildNotificationSection(
              'General Notifications',
              'Control your overall notification preferences',
              [
                _buildNotificationTile(
                  'Push Notifications',
                  'Receive notifications on your device',
                  _pushNotificationsEnabled,
                  (value) => setState(() => _pushNotificationsEnabled = value!),
                ),
                _buildNotificationTile(
                  'Email Notifications',
                  'Receive notifications via email',
                  _emailNotificationsEnabled,
                  (value) => setState(() => _emailNotificationsEnabled = value!),
                ),
                _buildNotificationTile(
                  'SMS Notifications',
                  'Receive notifications via text message',
                  _smsNotificationsEnabled,
                  (value) => setState(() => _smsNotificationsEnabled = value!),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Content Notifications
            _buildNotificationSection(
              'Content Notifications',
              'Stay updated with new content and media',
              [
                _buildNotificationTile(
                  'New Content',
                  'Get notified when new content is available',
                  _newContentNotifications,
                  (value) => setState(() => _newContentNotifications = value!),
                ),
                _buildNotificationTile(
                  'Live Streams',
                  'Get notified when live streams start',
                  _liveStreamNotifications,
                  (value) => setState(() => _liveStreamNotifications = value!),
                ),
                _buildNotificationTile(
                  'Premium Content',
                  'Get notified about new premium content',
                  _premiumContentNotifications,
                  (value) => setState(() => _premiumContentNotifications = value!),
                ),
                _buildNotificationTile(
                  'Download Complete',
                  'Get notified when downloads finish',
                  _downloadCompleteNotifications,
                  (value) => setState(() => _downloadCompleteNotifications = value!),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Community Notifications
            _buildNotificationSection(
              'Community Notifications',
              'Stay connected with your faith community',
              [
                _buildNotificationTile(
                  'Prayer Requests',
                  'Get notified about new prayer requests',
                  _prayerRequestNotifications,
                  (value) => setState(() => _prayerRequestNotifications = value!),
                ),
                _buildNotificationTile(
                  'Community Posts',
                  'Get notified about community activity',
                  _communityPostNotifications,
                  (value) => setState(() => _communityPostNotifications = value!),
                ),
                _buildNotificationTile(
                  'Events',
                  'Get notified about upcoming events',
                  _eventNotifications,
                  (value) => setState(() => _eventNotifications = value!),
                ),
                _buildNotificationTile(
                  'Friend Requests',
                  'Get notified about friend requests',
                  _friendRequestNotifications,
                  (value) => setState(() => _friendRequestNotifications = value!),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Giving & Wallet Notifications
            _buildNotificationSection(
              'Giving & Wallet',
              'Manage your financial and giving notifications',
              [
                _buildNotificationTile(
                  'Giving Reminders',
                  'Get reminded about regular giving',
                  _givingReminders,
                  (value) => setState(() => _givingReminders = value!),
                ),
                _buildNotificationTile(
                  'Wallet Activity',
                  'Get notified about wallet transactions',
                  _walletActivityNotifications,
                  (value) => setState(() => _walletActivityNotifications = value!),
                ),
                _buildNotificationTile(
                  'Coins Earned',
                  'Get notified when you earn coins',
                  _coinEarnedNotifications,
                  (value) => setState(() => _coinEarnedNotifications = value!),
                ),
                _buildNotificationTile(
                  'Payment Notifications',
                  'Get notified about payment confirmations',
                  _paymentNotifications,
                  (value) => setState(() => _paymentNotifications = value!),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Quiet Hours
            _buildNotificationSection(
              'Quiet Hours',
              'Set times when you don\'t want to be disturbed',
              [
                _buildNotificationTile(
                  'Enable Quiet Hours',
                  'Turn off notifications during specific times',
                  _quietHoursEnabled,
                  (value) => setState(() => _quietHoursEnabled = value!),
                ),
                if (_quietHoursEnabled) ...[
                  _buildTimeTile(
                    'Start Time',
                    _formatTime(_quietHoursStart),
                    () => _selectTime(true),
                  ),
                  _buildTimeTile(
                    'End Time',
                    _formatTime(_quietHoursEnd),
                    () => _selectTime(false),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Notification Preferences
            _buildNotificationSection(
              'Notification Preferences',
              'Customize how and when you receive notifications',
              [
                _buildDropdownTile(
                  'Notification Frequency',
                  _notificationFrequency,
                  _frequencies,
                  (value) => setState(() => _notificationFrequency = value!),
                ),
                _buildDropdownTile(
                  'Notification Sound',
                  _notificationSound,
                  _sounds,
                  (value) => setState(() => _notificationSound = value!),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Test Notifications
            _buildTestNotifications(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(String title, String subtitle, List<Widget> children) {
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
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
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

  Widget _buildNotificationTile(String title, String subtitle, bool value, ValueChanged<bool?> onChanged) {
    return SwitchListTile(
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
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildTimeTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDropdownTile(String title, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTestNotifications() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Notifications',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Test your notification settings to make sure they work properly',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testPushNotification,
                    icon: const Icon(Icons.notifications),
                    label: const Text('Test Push'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testEmailNotification,
                    icon: const Icon(Icons.email),
                    label: const Text('Test Email'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _quietHoursStart : _quietHoursEnd,
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _quietHoursStart = picked;
        } else {
          _quietHoursEnd = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour == 0 ? 12 : time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _testPushNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test push notification sent!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _testEmailNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test email notification sent!'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text('Are you sure you want to reset all notification settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _pushNotificationsEnabled = true;
                _emailNotificationsEnabled = true;
                _smsNotificationsEnabled = false;
                _newContentNotifications = true;
                _liveStreamNotifications = true;
                _premiumContentNotifications = true;
                _downloadCompleteNotifications = true;
                _prayerRequestNotifications = true;
                _communityPostNotifications = true;
                _eventNotifications = true;
                _friendRequestNotifications = true;
                _givingReminders = true;
                _walletActivityNotifications = true;
                _coinEarnedNotifications = true;
                _paymentNotifications = true;
                _quietHoursEnabled = false;
                _notificationFrequency = 'Immediate';
                _notificationSound = 'Default';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification settings reset to default'),
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
