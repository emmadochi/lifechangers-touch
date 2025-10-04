import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class WalletDashboardScreen extends StatefulWidget {
  const WalletDashboardScreen({super.key});

  @override
  State<WalletDashboardScreen> createState() => _WalletDashboardScreenState();
}

class _WalletDashboardScreenState extends State<WalletDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  
  // Mock wallet data - replace with actual wallet data
  final int _coinBalance = 1250;
  final double _dollarBalance = 25.00;
  final List<String> _periods = ['This Week', 'This Month', 'Last 3 Months', 'This Year'];
  
  final List<Transaction> _transactions = [
    Transaction(
      id: 'txn_1',
      type: TransactionType.earned,
      amount: 100,
      description: 'Watched Sunday Service',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: 'txn_2',
      type: TransactionType.spent,
      amount: -50,
      description: 'Premium Content - The Power of Faith',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: 'txn_3',
      type: TransactionType.purchased,
      amount: 500,
      description: 'Coin Purchase - \$10.00',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: 'txn_4',
      type: TransactionType.earned,
      amount: 25,
      description: 'Daily Check-in Bonus',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: 'txn_5',
      type: TransactionType.spent,
      amount: -100,
      description: 'Premium Audio - Worship Collection',
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: TransactionStatus.completed,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [
          IconButton(
            onPressed: _showSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Transactions'),
            Tab(text: 'Earn Coins'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildTransactionsTab(),
          _buildEarnCoinsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
              children: [
                Text(
                  'Your Balance',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_coinBalance Coins',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '≈ \$${_dollarBalance.toStringAsFixed(2)}',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  title: 'Buy Coins',
                  subtitle: 'Purchase more coins',
                  icon: Icons.add_circle,
                  color: AppColors.primary,
                  onTap: _buyCoins,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  title: 'Send Coins',
                  subtitle: 'Gift to friends',
                  icon: Icons.send,
                  color: AppColors.secondary,
                  onTap: _sendCoins,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  title: 'Redeem',
                  subtitle: 'Use coins for content',
                  icon: Icons.shopping_cart,
                  color: AppColors.success,
                  onTap: _redeemCoins,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  title: 'History',
                  subtitle: 'View transactions',
                  icon: Icons.history,
                  color: AppColors.warning,
                  onTap: _viewHistory,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          Text(
            'Recent Activity',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._transactions.take(3).map((transaction) => _TransactionCard(
            transaction: transaction,
            onTap: () => _viewTransactionDetails(transaction),
          )),
          
          const SizedBox(height: 16),
          
          Center(
            child: TextButton(
              onPressed: _viewAllTransactions,
              child: const Text('View All Transactions'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Column(
      children: [
        // Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  isExpanded: true,
                  onChanged: (value) => setState(() => _selectedPeriod = value!),
                  items: _periods.map((period) => DropdownMenuItem(
                    value: period,
                    child: Text(period),
                  )).toList(),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _exportTransactions,
                icon: const Icon(Icons.download),
              ),
            ],
          ),
        ),
        
        // Transactions List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return _TransactionCard(
                transaction: transaction,
                onTap: () => _viewTransactionDetails(transaction),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEarnCoinsTab() {
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
                  'Earn Coins',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete activities to earn coins and unlock premium content',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Earning Activities
          Text(
            'Available Activities',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._getEarningActivities().map((activity) => _EarningActivityCard(
            activity: activity,
            onTap: () => _completeActivity(activity),
          )),
          
          const SizedBox(height: 24),
          
          // Daily Bonus
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Daily Check-in Bonus',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check in daily to earn bonus coins!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _claimDailyBonus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Claim Bonus'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<EarningActivity> _getEarningActivities() {
    return [
      EarningActivity(
        title: 'Watch Sunday Service',
        description: 'Watch the full Sunday service',
        coins: 100,
        icon: Icons.play_circle_fill,
        color: AppColors.primary,
        isCompleted: false,
      ),
      EarningActivity(
        title: 'Read Daily Devotion',
        description: 'Read today\'s devotion',
        coins: 50,
        icon: Icons.menu_book,
        color: AppColors.secondary,
        isCompleted: false,
      ),
      EarningActivity(
        title: 'Share Content',
        description: 'Share content with friends',
        coins: 25,
        icon: Icons.share,
        color: AppColors.success,
        isCompleted: false,
      ),
      EarningActivity(
        title: 'Invite Friends',
        description: 'Invite friends to join',
        coins: 200,
        icon: Icons.person_add,
        color: AppColors.warning,
        isCompleted: false,
      ),
    ];
  }

  void _buyCoins() {
    context.go(RouteNames.coinPurchase);
  }

  void _sendCoins() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Send coins feature coming soon'),
      ),
    );
  }

  void _redeemCoins() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redeem coins feature coming soon'),
      ),
    );
  }

  void _viewHistory() {
    _tabController.animateTo(1);
  }

  void _viewAllTransactions() {
    _tabController.animateTo(1);
  }

  void _viewTransactionDetails(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(transaction.description),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${transaction.amount} coins'),
            Text('Date: ${_formatDate(transaction.date)}'),
            Text('Status: ${transaction.status.toString().split('.').last}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportTransactions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting transactions...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _completeActivity(EarningActivity activity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Completed: ${activity.title} (+${activity.coins} coins)'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _claimDailyBonus() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily bonus claimed! (+25 coins)'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wallet settings coming soon'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getTransactionColor(transaction.type).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTransactionIcon(transaction.type),
            color: _getTransactionColor(transaction.type),
            size: 20,
          ),
        ),
        title: Text(
          transaction.description,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          _formatDate(transaction.date),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.amount > 0 ? '+' : ''}${transaction.amount}',
              style: AppTextStyles.titleMedium.copyWith(
                color: transaction.amount > 0 ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'coins',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.earned:
        return Icons.add_circle;
      case TransactionType.spent:
        return Icons.remove_circle;
      case TransactionType.purchased:
        return Icons.shopping_cart;
      case TransactionType.received:
        return Icons.receipt;
    }
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.earned:
        return AppColors.success;
      case TransactionType.spent:
        return AppColors.error;
      case TransactionType.purchased:
        return AppColors.primary;
      case TransactionType.received:
        return AppColors.secondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _EarningActivityCard extends StatelessWidget {
  final EarningActivity activity;
  final VoidCallback onTap;

  const _EarningActivityCard({
    required this.activity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: activity.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            activity.icon,
            color: activity.color,
            size: 24,
          ),
        ),
        title: Text(
          activity.title,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          activity.description,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '+${activity.coins}',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'coins',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class Transaction {
  final String id;
  final TransactionType type;
  final int amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;

  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
  });
}

enum TransactionType {
  earned,
  spent,
  purchased,
  received,
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}

class EarningActivity {
  final String title;
  final String description;
  final int coins;
  final IconData icon;
  final Color color;
  final bool isCompleted;

  const EarningActivity({
    required this.title,
    required this.description,
    required this.coins,
    required this.icon,
    required this.color,
    required this.isCompleted,
  });
}
