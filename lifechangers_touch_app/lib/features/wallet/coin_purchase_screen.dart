import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class CoinPurchaseScreen extends StatefulWidget {
  const CoinPurchaseScreen({super.key});

  @override
  State<CoinPurchaseScreen> createState() => _CoinPurchaseScreenState();
}

class _CoinPurchaseScreenState extends State<CoinPurchaseScreen> {
  String _selectedPackage = '';
  String _selectedPaymentMethod = 'Credit Card';
  bool _isProcessing = false;
  final TextEditingController _customAmountController = TextEditingController();

  final List<CoinPackage> _packages = [
    CoinPackage(
      id: 'package_1',
      name: 'Starter Pack',
      coins: 100,
      price: 2.99,
      bonus: 0,
      popular: false,
    ),
    CoinPackage(
      id: 'package_2',
      name: 'Value Pack',
      coins: 500,
      price: 9.99,
      bonus: 50,
      popular: true,
    ),
    CoinPackage(
      id: 'package_3',
      name: 'Premium Pack',
      coins: 1000,
      price: 19.99,
      bonus: 200,
      popular: false,
    ),
    CoinPackage(
      id: 'package_4',
      name: 'Ultimate Pack',
      coins: 2500,
      price: 49.99,
      bonus: 750,
      popular: false,
    ),
  ];

  final List<String> _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'PayPal',
    'Apple Pay',
    'Google Pay',
    'Bank Transfer',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Coins'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _showPurchaseHistory,
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    'Purchase Coins',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Buy coins to unlock premium content and support our ministry',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Current Balance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Balance',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '1,250 Coins',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '≈ \$25.00',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Package Selection
            Text(
              'Choose a Package',
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
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final package = _packages[index];
                final isSelected = _selectedPackage == package.id;
                
                return _PackageCard(
                  package: package,
                  isSelected: isSelected,
                  onSelected: () => setState(() => _selectedPackage = package.id),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Custom Amount
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Amount',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Enter amount in USD',
                        prefixText: '\$',
                        hintText: '0.00',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() => _selectedPackage = '');
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rate: 1 USD = 50 Coins',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
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
            
            Card(
              child: Column(
                children: _paymentMethods.map((method) => RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Purchase Summary
            if (_selectedPackage.isNotEmpty || _customAmountController.text.isNotEmpty)
              _buildPurchaseSummary(),
            
            const SizedBox(height: 24),
            
            // Purchase Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canPurchase() ? _processPurchase : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Purchase \$${_getPurchaseAmount()}',
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
                      'Your payment is secure and encrypted. We use industry-standard security measures.',
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
      ),
    );
  }

  Widget _buildPurchaseSummary() {
    final package = _packages.firstWhere(
      (p) => p.id == _selectedPackage,
      orElse: () => CoinPackage(
        id: 'custom',
        name: 'Custom Amount',
        coins: _getCustomCoins(),
        price: _getCustomPrice(),
        bonus: 0,
        popular: false,
      ),
    );
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Purchase Summary',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Package:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  package.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Coins:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${package.coins}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            if (package.bonus > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bonus:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    '+${package.bonus}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
            
            const Divider(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${package.price.toStringAsFixed(2)}',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _canPurchase() {
    return _selectedPackage.isNotEmpty || _customAmountController.text.isNotEmpty;
  }

  String _getPurchaseAmount() {
    if (_selectedPackage.isNotEmpty) {
      final package = _packages.firstWhere((p) => p.id == _selectedPackage);
      return package.price.toStringAsFixed(2);
    } else if (_customAmountController.text.isNotEmpty) {
      return _customAmountController.text;
    }
    return '0.00';
  }

  int _getCustomCoins() {
    if (_customAmountController.text.isEmpty) return 0;
    final amount = double.tryParse(_customAmountController.text) ?? 0;
    return (amount * 50).round(); // 1 USD = 50 coins
  }

  double _getCustomPrice() {
    if (_customAmountController.text.isEmpty) return 0;
    return double.tryParse(_customAmountController.text) ?? 0;
  }

  void _processPurchase() {
    setState(() => _isProcessing = true);
    
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showPurchaseSuccess();
      }
    });
  }

  void _showPurchaseSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Successful!'),
        content: Text('You have successfully purchased ${_getCustomCoins()} coins.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchase history coming soon'),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final CoinPackage package;
  final bool isSelected;
  final VoidCallback onSelected;

  const _PackageCard({
    required this.package,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (package.popular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'POPULAR',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (package.popular) const SizedBox(height: 8),
              
              Text(
                package.name,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                '${package.coins}',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Text(
                'coins',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                '\$${package.price.toStringAsFixed(2)}',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              if (package.bonus > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '+${package.bonus} bonus',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CoinPackage {
  final String id;
  final String name;
  final int coins;
  final double price;
  final int bonus;
  final bool popular;

  const CoinPackage({
    required this.id,
    required this.name,
    required this.coins,
    required this.price,
    required this.bonus,
    required this.popular,
  });
}
