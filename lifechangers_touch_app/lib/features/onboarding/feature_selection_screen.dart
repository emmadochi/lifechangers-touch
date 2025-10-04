import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class FeatureSelectionScreen extends StatefulWidget {
  const FeatureSelectionScreen({super.key});

  @override
  State<FeatureSelectionScreen> createState() => _FeatureSelectionScreenState();
}

class _FeatureSelectionScreenState extends State<FeatureSelectionScreen> {
  final Set<String> _selectedFeatures = {};

  final List<FeatureOption> _features = [
    FeatureOption(
      id: 'content',
      title: 'Content Library',
      description: 'Access sermons, teachings, and books',
      icon: Icons.video_library,
      color: AppColors.primary,
    ),
    FeatureOption(
      id: 'streaming',
      title: 'Live Streaming',
      description: 'Join live services and events',
      icon: Icons.live_tv,
      color: AppColors.secondary,
    ),
    FeatureOption(
      id: 'community',
      title: 'Community',
      description: 'Connect with fellow believers',
      icon: Icons.people,
      color: AppColors.success,
    ),
    FeatureOption(
      id: 'prayer',
      title: 'Prayer Requests',
      description: 'Share and pray for others',
      icon: Icons.favorite,
      color: AppColors.warning,
    ),
    FeatureOption(
      id: 'downloads',
      title: 'Offline Access',
      description: 'Download content for offline viewing',
      icon: Icons.download,
      color: AppColors.info,
    ),
    FeatureOption(
      id: 'notifications',
      title: 'Notifications',
      description: 'Stay updated with church news',
      icon: Icons.notifications,
      color: AppColors.error,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Your Experience'),
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
              'What interests you most?',
              style: AppTextStyles.displaySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the features you\'d like to explore. You can always change these later.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            
            // Feature Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _features.length,
              itemBuilder: (context, index) {
                final feature = _features[index];
                final isSelected = _selectedFeatures.contains(feature.id);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedFeatures.remove(feature.id);
                      } else {
                        _selectedFeatures.add(feature.id);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? feature.color.withValues(alpha: 0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? feature.color : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: feature.color.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? feature.color
                                  : feature.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              feature.icon,
                              color: isSelected ? Colors.white : feature.color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Title
                          Text(
                            feature.title,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          
                          // Description
                          Text(
                            feature.description,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          // Selection Indicator
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: feature.color,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Quick Select All
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedFeatures.clear();
                      });
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedFeatures.addAll(_features.map((f) => f.id));
                      });
                    },
                    icon: const Icon(Icons.select_all),
                    label: const Text('Select All'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedFeatures.isNotEmpty ? _continue : null,
                child: Text(
                  'Continue (${_selectedFeatures.length} selected)',
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Skip Option
            Center(
              child: TextButton(
                onPressed: _skip,
                child: const Text('Skip for now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    // TODO: Save selected features to preferences
    context.go(RouteNames.permissions);
  }

  void _skip() {
    context.go(RouteNames.permissions);
  }
}

class FeatureOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const FeatureOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
