import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class StreamScheduleScreen extends StatefulWidget {
  const StreamScheduleScreen({super.key});

  @override
  State<StreamScheduleScreen> createState() => _StreamScheduleScreenState();
}

class _StreamScheduleScreenState extends State<StreamScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'All';
  bool _showCalendar = false;

  final List<String> _filterOptions = ['All', 'Today', 'This Week', 'This Month'];
  final List<String> _categories = ['All', 'Sunday Service', 'Prayer Meeting', 'Bible Study', 'Special Events'];

  // Mock schedule data - replace with actual schedule data
  final List<ContentModel> _scheduledStreams = [
    ContentModel(
      id: 'schedule_1',
      title: 'Sunday Morning Service',
      description: 'Weekly Sunday service with worship and message.',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'sunday-service',
      tags: ['sunday', 'service', 'worship'],
      author: 'Pastor John Doe',
      createdAt: DateTime.now(),
      duration: 0,
      viewCount: 0,
      downloadCount: 0,
      rating: 0,
      isDownloadable: false,
      isLive: false,
      streamUrl: 'https://example.com/stream1',
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
    ),
    ContentModel(
      id: 'schedule_2',
      title: 'Bible Study - Book of Romans',
      description: 'Deep dive into the Book of Romans with Pastor John.',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'bible-study',
      tags: ['bible', 'study', 'romans'],
      author: 'Pastor John Doe',
      createdAt: DateTime.now(),
      duration: 0,
      viewCount: 0,
      downloadCount: 0,
      rating: 0,
      isDownloadable: false,
      isLive: false,
      streamUrl: 'https://example.com/stream2',
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
    ),
    ContentModel(
      id: 'schedule_3',
      title: 'Prayer Meeting',
      description: 'Weekly prayer meeting for community needs.',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'prayer-meeting',
      tags: ['prayer', 'community'],
      author: 'Pastor Sarah Johnson',
      createdAt: DateTime.now(),
      duration: 0,
      viewCount: 0,
      downloadCount: 0,
      rating: 0,
      isDownloadable: false,
      isLive: false,
      streamUrl: 'https://example.com/stream3',
      scheduledAt: DateTime.now().add(const Duration(days: 2)),
    ),
    ContentModel(
      id: 'schedule_4',
      title: 'Youth Service',
      description: 'Special service for our youth community.',
      type: ContentType.video,
      status: ContentStatus.free,
      coinCost: 0,
      category: 'youth-service',
      tags: ['youth', 'service', 'special'],
      author: 'Pastor Mike Wilson',
      createdAt: DateTime.now(),
      duration: 0,
      viewCount: 0,
      downloadCount: 0,
      rating: 0,
      isDownloadable: false,
      isLive: false,
      streamUrl: 'https://example.com/stream4',
      scheduledAt: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Schedule'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: _toggleCalendar,
            icon: const Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Selector
          if (_showCalendar)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Date',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _selectedDate = DateTime.now()),
                        child: const Text('Today'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 30, // Show 30 days
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index));
                        final isSelected = _isSameDay(date, _selectedDate);
                        final isToday = _isSameDay(date, DateTime.now());
                        
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDate = date),
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? AppColors.primary 
                                  : isToday 
                                      ? AppColors.primary.withValues(alpha: 0.1)
                                      : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                              border: isToday && !isSelected
                                  ? Border.all(color: AppColors.primary)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _getDayName(date.weekday),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isSelected 
                                        ? Colors.white 
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${date.day}',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: isSelected 
                                        ? Colors.white 
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          
          // Filter Chips
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filterOptions.map((filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                        ),
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Schedule List
          Expanded(
            child: _buildScheduleList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList() {
    final filteredStreams = _getFilteredStreams();
    
    if (filteredStreams.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredStreams.length,
      itemBuilder: (context, index) {
        final stream = filteredStreams[index];
        return _ScheduleCard(
          stream: stream,
          onTap: () => _viewStreamDetails(stream),
          onRemind: () => _setReminder(stream),
          onShare: () => _shareStream(stream),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Scheduled Streams',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for upcoming live streams',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<ContentModel> _getFilteredStreams() {
    List<ContentModel> streams = _scheduledStreams;
    
    // Filter by date
    if (_showCalendar) {
      streams = streams.where((stream) {
        if (stream.scheduledAt == null) return false;
        return _isSameDay(stream.scheduledAt!, _selectedDate);
      }).toList();
    }
    
    // Filter by time range
    switch (_selectedFilter) {
      case 'Today':
        streams = streams.where((stream) {
          if (stream.scheduledAt == null) return false;
          return _isSameDay(stream.scheduledAt!, DateTime.now());
        }).toList();
        break;
      case 'This Week':
        final weekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 7));
        streams = streams.where((stream) {
          if (stream.scheduledAt == null) return false;
          return stream.scheduledAt!.isAfter(weekStart) && stream.scheduledAt!.isBefore(weekEnd);
        }).toList();
        break;
      case 'This Month':
        final monthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
        final monthEnd = DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
        streams = streams.where((stream) {
          if (stream.scheduledAt == null) return false;
          return stream.scheduledAt!.isAfter(monthStart) && stream.scheduledAt!.isBefore(monthEnd);
        }).toList();
        break;
    }
    
    // Sort by scheduled time
    streams.sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));
    
    return streams;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  void _toggleCalendar() {
    setState(() {
      _showCalendar = !_showCalendar;
    });
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Schedule',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Category Filter
            Text(
              'Category',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) => FilterChip(
                label: Text(category),
                selected: _selectedFilter == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = category;
                  });
                },
              )).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewStreamDetails(ContentModel stream) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${stream.title}'),
      ),
    );
  }

  void _setReminder(ContentModel stream) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for ${stream.title}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareStream(ContentModel stream) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${stream.title}'),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final ContentModel stream;
  final VoidCallback onTap;
  final VoidCallback onRemind;
  final VoidCallback onShare;

  const _ScheduleCard({
    required this.stream,
    required this.onTap,
    required this.onRemind,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Time Info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _formatTime(stream.scheduledAt!),
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatDate(stream.scheduledAt!),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Stream Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stream.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stream.author,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stream.description,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Status Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(stream.scheduledAt!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(stream.scheduledAt!),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRemind,
                      icon: const Icon(Icons.notifications),
                      label: const Text('Set Reminder'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onShare,
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Color _getStatusColor(DateTime scheduledAt) {
    final now = DateTime.now();
    final difference = scheduledAt.difference(now);
    
    if (difference.inMinutes < 0) {
      return AppColors.textSecondary; // Past
    } else if (difference.inMinutes < 60) {
      return AppColors.error; // Starting soon
    } else if (difference.inDays < 1) {
      return AppColors.warning; // Today
    } else {
      return AppColors.success; // Future
    }
  }

  String _getStatusText(DateTime scheduledAt) {
    final now = DateTime.now();
    final difference = scheduledAt.difference(now);
    
    if (difference.inMinutes < 0) {
      return 'PAST';
    } else if (difference.inMinutes < 60) {
      return 'SOON';
    } else if (difference.inDays < 1) {
      return 'TODAY';
    } else {
      return 'UPCOMING';
    }
  }
}
