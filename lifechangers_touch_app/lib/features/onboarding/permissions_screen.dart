import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final Map<String, bool> _permissions = {
    'notifications': false,
    'storage': false,
    'camera': false,
    'location': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Enable Permissions',
              style: AppTextStyles.displaySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We need these permissions to provide you with the best experience.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            
            // Permissions List
            ..._buildPermissionItems(),
            
            const SizedBox(height: 32),
            
            // Privacy Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: AppColors.info,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Privacy Notice',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We respect your privacy and only use these permissions to enhance your app experience. You can change these settings anytime in your device settings.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _denyAll,
                    child: const Text('Deny All'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _allowAll,
                    child: const Text('Allow All'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _continue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPermissionItems() {
    return [
      _PermissionItem(
        icon: Icons.notifications,
        title: 'Notifications',
        description: 'Receive updates about live streams, events, and community activities',
        color: AppColors.primary,
        isEnabled: _permissions['notifications']!,
        onToggle: (value) {
          setState(() {
            _permissions['notifications'] = value;
          });
        },
      ),
      _PermissionItem(
        icon: Icons.storage,
        title: 'Storage Access',
        description: 'Download content for offline viewing and save your preferences',
        color: AppColors.secondary,
        isEnabled: _permissions['storage']!,
        onToggle: (value) {
          setState(() {
            _permissions['storage'] = value;
          });
        },
      ),
      _PermissionItem(
        icon: Icons.camera_alt,
        title: 'Camera Access',
        description: 'Take photos for your profile and share moments with the community',
        color: AppColors.success,
        isEnabled: _permissions['camera']!,
        onToggle: (value) {
          setState(() {
            _permissions['camera'] = value;
          });
        },
      ),
      _PermissionItem(
        icon: Icons.location_on,
        title: 'Location Access',
        description: 'Find nearby church events and connect with local community members',
        color: AppColors.warning,
        isEnabled: _permissions['location']!,
        onToggle: (value) {
          setState(() {
            _permissions['location'] = value;
          });
        },
      ),
    ];
  }

  void _allowAll() {
    setState(() {
      _permissions.updateAll((key, value) => true);
    });
  }

  void _denyAll() {
    setState(() {
      _permissions.updateAll((key, value) => false);
    });
  }

  void _continue() {
    // TODO: Request actual permissions and save preferences
    context.go(RouteNames.welcomeComplete);
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isEnabled
                    ? color
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isEnabled ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
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
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Toggle
            Switch(
              value: isEnabled,
              onChanged: onToggle,
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }
}
