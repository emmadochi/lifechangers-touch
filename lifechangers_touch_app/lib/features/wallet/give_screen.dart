import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class GiveScreen extends StatefulWidget {
  const GiveScreen({super.key});

  @override
  State<GiveScreen> createState() => _GiveScreenState();
}

class _GiveScreenState extends State<GiveScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedAmount = '';
  String _selectedFrequency = 'One-time';
  String _selectedMethod = 'Credit Card';
  String _selectedPurpose = 'General Fund';
  bool _isAnonymous = false;
  bool _isRecurring = false;
  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<String> _amounts = ['\$25', '\$50', '\$100', '\$250', '\$500', 'Custom'];
  final List<String> _frequencies = ['One-time', 'Weekly', 'Monthly', 'Quarterly', 'Annually'];
  final List<String> _methods = ['Credit Card', 'Debit Card', 'Bank Transfer', 'PayPal', 'Apple Pay', 'Google Pay'];
  final List<String> _purposes = ['General Fund', 'Building Fund', 'Missions', 'Youth Ministry', 'Children\'s Ministry', 'Music Ministry'];

  final List<GivingOption> _givingOptions = [
    GivingOption(
      title: 'General Fund',
      description: 'Support the general operations of the church',
      icon: Icons.church,
      color: AppColors.primary,
    ),
    GivingOption(
      title: 'Building Fund',
      description: 'Help with church building and maintenance',
      icon: Icons.home,
      color: AppColors.secondary,
    ),
    GivingOption(
      title: 'Missions',
      description: 'Support our mission work around the world',
      icon: Icons.public,
      color: AppColors.success,
    ),
    GivingOption(
      title: 'Youth Ministry',
      description: 'Support youth programs and activities',
      icon: Icons.people,
      color: AppColors.warning,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customAmountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Give'),
        actions: [
          IconButton(
            onPressed: _showGivingHistory,
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: _showSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Give Now'),
            Tab(text: 'Recurring'),
            Tab(text: 'Prayer'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGiveNowTab(),
          _buildRecurringTab(),
          _buildPrayerTab(),
        ],
      ),
    );
  }

  Widget _buildGiveNowTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Support Our Ministry',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your generosity helps us spread the Gospel and serve our community',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Giving Options
          Text(
            'Choose a Purpose',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _givingOptions.length,
            itemBuilder: (context, index) {
              final option = _givingOptions[index];
              final isSelected = _selectedPurpose == option.title;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedPurpose = option.title),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? option.color.withValues(alpha: 0.1) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? option.color : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          option.icon,
                          color: option.color,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          option.title,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option.description,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Amount Selection
          Text(
            'Select Amount',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _amounts.map((amount) => _AmountChip(
              amount: amount,
              isSelected: _selectedAmount == amount,
              onSelected: (selected) {
                setState(() {
                  _selectedAmount = amount;
                  if (amount != 'Custom') {
                    _customAmountController.clear();
                  }
                });
              },
            )).toList(),
          ),
          
          // Custom Amount Input
          if (_selectedAmount == 'Custom')
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextField(
                controller: _customAmountController,
                decoration: const InputDecoration(
                  labelText: 'Enter Amount',
                  prefixText: '\$',
                  hintText: '0.00',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Payment Method
          Text(
            'Payment Method',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._methods.map((method) => RadioListTile<String>(
            title: Text(method),
            value: method,
            groupValue: _selectedMethod,
            onChanged: (value) => setState(() => _selectedMethod = value!),
          )),
          
          const SizedBox(height: 24),
          
          // Additional Options
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Options',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: const Text('Anonymous Giving'),
                    subtitle: const Text('Your name will not be displayed'),
                    value: _isAnonymous,
                    onChanged: (value) => setState(() => _isAnonymous = value),
                    activeColor: AppColors.primary,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message (Optional)',
                      hintText: 'Add a personal message...',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Give Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _processGiving,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Give \${_getSelectedAmount()}',
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Security Notice
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your payment is secure and encrypted',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.secondaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Set Up Recurring Giving',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Support our ministry with regular, automated giving',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Frequency Selection
          Text(
            'Giving Frequency',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._frequencies.map((frequency) => RadioListTile<String>(
            title: Text(frequency),
            value: frequency,
            groupValue: _selectedFrequency,
            onChanged: (value) => setState(() => _selectedFrequency = value!),
          )),
          
          const SizedBox(height: 24),
          
          // Amount Selection (same as give now)
          Text(
            'Select Amount',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _amounts.map((amount) => _AmountChip(
              amount: amount,
              isSelected: _selectedAmount == amount,
              onSelected: (selected) {
                setState(() {
                  _selectedAmount = amount;
                  if (amount != 'Custom') {
                    _customAmountController.clear();
                  }
                });
              },
            )).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Set Up Recurring Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _setUpRecurring,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Set Up Recurring Giving',
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.success, AppColors.success.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Prayer Requests',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Share your prayer requests with our community',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Prayer Request Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Submit Prayer Request',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      hintText: 'Enter your name',
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Prayer Request',
                      hintText: 'Share your prayer request...',
                    ),
                    maxLines: 4,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: const Text('Keep Private'),
                    subtitle: const Text('Only church staff will see this request'),
                    value: false,
                    onChanged: (value) {},
                    activeColor: AppColors.primary,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitPrayerRequest,
                      child: const Text('Submit Prayer Request'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Recent Prayer Requests
          Text(
            'Recent Prayer Requests',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Mock prayer requests
          ...List.generate(3, (index) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                ),
              ),
              title: Text('Prayer Request ${index + 1}'),
              subtitle: Text('Please pray for...'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                color: AppColors.primary,
              ),
            ),
          )),
        ],
      ),
    );
  }

  String _getSelectedAmount() {
    if (_selectedAmount == 'Custom') {
      return _customAmountController.text.isEmpty ? '0' : _customAmountController.text;
    }
    return _selectedAmount.replaceAll('\$', '');
  }

  void _processGiving() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Giving'),
        content: Text('Are you sure you want to give \$${_getSelectedAmount()} to ${_selectedPurpose}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPaymentProcessing();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _setUpRecurring() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recurring giving setup coming soon'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _submitPrayerRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prayer request submitted'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showPaymentProcessing() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Processing payment...'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
    
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful! Thank you for your generosity.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  void _showGivingHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Giving history coming soon'),
      ),
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Giving settings coming soon'),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  final String amount;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _AmountChip({
    required this.amount,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(amount),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }
}

class GivingOption {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const GivingOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
