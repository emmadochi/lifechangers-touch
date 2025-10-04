import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class DownloadSettingsScreen extends StatefulWidget {
  const DownloadSettingsScreen({super.key});

  @override
  State<DownloadSettingsScreen> createState() => _DownloadSettingsScreenState();
}

class _DownloadSettingsScreenState extends State<DownloadSettingsScreen> {
  // Download Settings
  bool _wifiOnly = true;
  bool _autoDownload = false;
  bool _downloadInBackground = true;
  bool _notifyOnComplete = true;
  bool _notifyOnFailure = true;
  bool _deleteAfterWatching = false;
  bool _compressDownloads = false;
  
  // Storage Settings
  int _maxStorageSize = 2; // GB
  int _maxConcurrentDownloads = 3;
  String _downloadQuality = 'High';
  String _downloadLocation = 'Internal Storage';
  
  // Quality Options
  final List<String> _qualityOptions = ['Low', 'Medium', 'High', 'Ultra'];
  final List<String> _locationOptions = ['Internal Storage', 'SD Card', 'External Storage'];
  
  // Storage Info
  final int _totalStorage = 2 * 1024 * 1024 * 1024; // 2 GB
  final int _usedStorage = 750 * 1024 * 1024; // 750 MB
  final int _availableStorage = 1 * 1024 * 1024 * 1024; // 1 GB

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Settings'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _resetToDefaults,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Storage Overview
            _buildStorageOverview(),
            
            const SizedBox(height: 24),
            
            // Download Settings
            _buildSection(
              title: 'Download Settings',
              children: [
                _buildSwitchTile(
                  title: 'Wi-Fi Only',
                  subtitle: 'Only download when connected to Wi-Fi',
                  value: _wifiOnly,
                  onChanged: (value) => setState(() => _wifiOnly = value),
                ),
                _buildSwitchTile(
                  title: 'Auto Download',
                  subtitle: 'Automatically download new content',
                  value: _autoDownload,
                  onChanged: (value) => setState(() => _autoDownload = value),
                ),
                _buildSwitchTile(
                  title: 'Background Downloads',
                  subtitle: 'Continue downloads when app is closed',
                  value: _downloadInBackground,
                  onChanged: (value) => setState(() => _downloadInBackground = value),
                ),
                _buildSwitchTile(
                  title: 'Notify on Complete',
                  subtitle: 'Show notification when download completes',
                  value: _notifyOnComplete,
                  onChanged: (value) => setState(() => _notifyOnComplete = value),
                ),
                _buildSwitchTile(
                  title: 'Notify on Failure',
                  subtitle: 'Show notification when download fails',
                  value: _notifyOnFailure,
                  onChanged: (value) => setState(() => _notifyOnFailure = value),
                ),
                _buildSwitchTile(
                  title: 'Delete After Watching',
                  subtitle: 'Automatically delete content after viewing',
                  value: _deleteAfterWatching,
                  onChanged: (value) => setState(() => _deleteAfterWatching = value),
                ),
                _buildSwitchTile(
                  title: 'Compress Downloads',
                  subtitle: 'Reduce file size by compressing downloads',
                  value: _compressDownloads,
                  onChanged: (value) => setState(() => _compressDownloads = value),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Storage Settings
            _buildSection(
              title: 'Storage Settings',
              children: [
                _buildSliderTile(
                  title: 'Max Storage Size',
                  subtitle: 'Maximum storage for downloads',
                  value: _maxStorageSize.toDouble(),
                  min: 0.5,
                  max: 10.0,
                  divisions: 19,
                  onChanged: (value) => setState(() => _maxStorageSize = value.round()),
                  formatValue: (value) => '${value.round()} GB',
                ),
                _buildSliderTile(
                  title: 'Max Concurrent Downloads',
                  subtitle: 'Number of simultaneous downloads',
                  value: _maxConcurrentDownloads.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (value) => setState(() => _maxConcurrentDownloads = value.round()),
                  formatValue: (value) => '${value.round()}',
                ),
                _buildDropdownTile(
                  title: 'Download Quality',
                  subtitle: 'Quality of downloaded content',
                  value: _downloadQuality,
                  options: _qualityOptions,
                  onChanged: (value) => setState(() => _downloadQuality = value!),
                ),
                _buildDropdownTile(
                  title: 'Download Location',
                  subtitle: 'Where to store downloaded content',
                  value: _downloadLocation,
                  options: _locationOptions,
                  onChanged: (value) => setState(() => _downloadLocation = value!),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Advanced Settings
            _buildSection(
              title: 'Advanced Settings',
              children: [
                _buildActionTile(
                  title: 'Clear Download Cache',
                  subtitle: 'Clear temporary download files',
                  icon: Icons.delete_sweep,
                  onTap: _clearDownloadCache,
                ),
                _buildActionTile(
                  title: 'Reset Download Settings',
                  subtitle: 'Reset all settings to default',
                  icon: Icons.restore,
                  onTap: _resetSettings,
                ),
                _buildActionTile(
                  title: 'Storage Analysis',
                  subtitle: 'Analyze storage usage and recommendations',
                  icon: Icons.analytics,
                  onTap: _showStorageAnalysis,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Save Settings',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageOverview() {
    final usedPercentage = (_usedStorage / _totalStorage) * 100;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Storage Overview',
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Storage Bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${usedPercentage.toStringAsFixed(1)}% Used',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_formatFileSize(_usedStorage)} / ${_formatFileSize(_totalStorage)}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: usedPercentage / 100,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Storage Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StorageStat(
                icon: Icons.storage,
                label: 'Used',
                value: _formatFileSize(_usedStorage),
              ),
              _StorageStat(
                icon: Icons.folder_open,
                label: 'Available',
                value: _formatFileSize(_availableStorage),
              ),
              _StorageStat(
                icon: Icons.download,
                label: 'Downloads',
                value: '12 files',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
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
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String Function(double) formatValue,
  }) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.border,
          ),
          Text(
            formatValue(value),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
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
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: options.map((option) => DropdownMenuItem(
          value: option,
          child: Text(option),
        )).toList(),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
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
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text('Are you sure you want to reset all settings to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetSettings();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    setState(() {
      _wifiOnly = true;
      _autoDownload = false;
      _downloadInBackground = true;
      _notifyOnComplete = true;
      _notifyOnFailure = true;
      _deleteAfterWatching = false;
      _compressDownloads = false;
      _maxStorageSize = 2;
      _maxConcurrentDownloads = 3;
      _downloadQuality = 'High';
      _downloadLocation = 'Internal Storage';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings reset to defaults'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _clearDownloadCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Download Cache'),
        content: const Text('This will clear all temporary download files. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download cache cleared'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showStorageAnalysis() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Storage Analysis',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Analysis Results
            _AnalysisItem(
              title: 'Largest Files',
              subtitle: 'Sunday Service (250 MB)',
              icon: Icons.video_library,
            ),
            _AnalysisItem(
              title: 'Oldest Downloads',
              subtitle: '3 files older than 30 days',
              icon: Icons.history,
            ),
            _AnalysisItem(
              title: 'Recommendations',
              subtitle: 'Consider deleting old content',
              icon: Icons.lightbulb,
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class _StorageStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StorageStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _AnalysisItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _AnalysisItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                  style: AppTextStyles.titleMedium.copyWith(
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
}
