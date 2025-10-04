import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class ContentFilterScreen extends StatefulWidget {
  const ContentFilterScreen({super.key});

  @override
  State<ContentFilterScreen> createState() => _ContentFilterScreenState();
}

class _ContentFilterScreenState extends State<ContentFilterScreen> {
  // Filter categories
  final List<String> _categories = [
    'All',
    'Sermons',
    'Music',
    'Books',
    'Prayer',
    'Events',
    'Testimonies',
    'Bible Study',
  ];

  final List<String> _contentTypes = [
    'All',
    'Videos',
    'Audio',
    'Books',
    'Messages',
  ];

  final List<String> _statusOptions = [
    'All',
    'Free',
    'Premium',
  ];

  final List<String> _durationOptions = [
    'Any Duration',
    'Under 10 min',
    '10-30 min',
    '30-60 min',
    'Over 1 hour',
  ];

  final List<String> _sortOptions = [
    'Relevance',
    'Newest First',
    'Oldest First',
    'Most Viewed',
    'Highest Rated',
    'Most Downloaded',
  ];

  // Selected filters
  String _selectedCategory = 'All';
  String _selectedContentType = 'All';
  String _selectedStatus = 'All';
  String _selectedDuration = 'Any Duration';
  String _selectedSort = 'Relevance';
  
  // Date range
  DateTime? _startDate;
  DateTime? _endDate;
  
  // Rating range
  double _minRating = 0.0;
  double _maxRating = 5.0;
  
  // Tags
  final List<String> _availableTags = [
    'faith', 'hope', 'love', 'prayer', 'worship', 'bible',
    'sermon', 'testimony', 'healing', 'miracles', 'grace',
    'forgiveness', 'salvation', 'peace', 'joy', 'strength'
  ];
  final Set<String> _selectedTags = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Content'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: _clearAllFilters,
            child: const Text('Clear All'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter
            _FilterSection(
              title: 'Category',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) => _FilterChip(
                  label: category,
                  isSelected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Content Type Filter
            _FilterSection(
              title: 'Content Type',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _contentTypes.map((type) => _FilterChip(
                  label: type,
                  isSelected: _selectedContentType == type,
                  onSelected: (selected) {
                    setState(() {
                      _selectedContentType = type;
                    });
                  },
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Status Filter
            _FilterSection(
              title: 'Status',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _statusOptions.map((status) => _FilterChip(
                  label: status,
                  isSelected: _selectedStatus == status,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Duration Filter
            _FilterSection(
              title: 'Duration',
              child: Column(
                children: _durationOptions.map((duration) => RadioListTile<String>(
                  title: Text(duration),
                  value: duration,
                  groupValue: _selectedDuration,
                  onChanged: (value) {
                    setState(() {
                      _selectedDuration = value!;
                    });
                  },
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Date Range Filter
            _FilterSection(
              title: 'Date Range',
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(_startDate == null 
                        ? 'Start Date' 
                        : 'From: ${_formatDate(_startDate!)}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: _selectStartDate,
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(_endDate == null 
                        ? 'End Date' 
                        : 'To: ${_formatDate(_endDate!)}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: _selectEndDate,
                  ),
                  if (_startDate != null || _endDate != null)
                    TextButton(
                      onPressed: _clearDateRange,
                      child: const Text('Clear Date Range'),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Rating Range Filter
            _FilterSection(
              title: 'Rating Range',
              child: Column(
                children: [
                  RangeSlider(
                    values: RangeValues(_minRating, _maxRating),
                    min: 0.0,
                    max: 5.0,
                    divisions: 10,
                    labels: RangeLabels(
                      _minRating.toStringAsFixed(1),
                      _maxRating.toStringAsFixed(1),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _minRating = values.start;
                        _maxRating = values.end;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_minRating.toStringAsFixed(1)}+'),
                      Text('${_maxRating.toStringAsFixed(1)}+'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tags Filter
            _FilterSection(
              title: 'Tags',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select relevant tags:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTags.map((tag) => _FilterChip(
                      label: tag,
                      isSelected: _selectedTags.contains(tag),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                    )).toList(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Sort Options
            _FilterSection(
              title: 'Sort By',
              child: Column(
                children: _sortOptions.map((sort) => RadioListTile<String>(
                  title: Text(sort),
                  value: sort,
                  groupValue: _selectedSort,
                  onChanged: (value) {
                    setState(() {
                      _selectedSort = value!;
                    });
                  },
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _clearAllFilters,
                child: const Text('Reset'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  void _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  void _clearDateRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = 'All';
      _selectedContentType = 'All';
      _selectedStatus = 'All';
      _selectedDuration = 'Any Duration';
      _selectedSort = 'Relevance';
      _startDate = null;
      _endDate = null;
      _minRating = 0.0;
      _maxRating = 5.0;
      _selectedTags.clear();
    });
  }

  void _applyFilters() {
    // TODO: Apply filters and navigate back with results
    final filters = {
      'category': _selectedCategory,
      'contentType': _selectedContentType,
      'status': _selectedStatus,
      'duration': _selectedDuration,
      'sort': _selectedSort,
      'startDate': _startDate,
      'endDate': _endDate,
      'minRating': _minRating,
      'maxRating': _maxRating,
      'tags': _selectedTags.toList(),
    };
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied ${_getActiveFilterCount()} filters'),
        backgroundColor: AppColors.success,
      ),
    );
    
    context.pop();
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedCategory != 'All') count++;
    if (_selectedContentType != 'All') count++;
    if (_selectedStatus != 'All') count++;
    if (_selectedDuration != 'Any Duration') count++;
    if (_startDate != null || _endDate != null) count++;
    if (_minRating > 0.0 || _maxRating < 5.0) count++;
    if (_selectedTags.isNotEmpty) count++;
    return count;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
      backgroundColor: AppColors.surfaceVariant,
    );
  }
}
