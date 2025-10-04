import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';
import '../../shared/models/content_model.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isProcessing = false;
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;
  String _selectedPaymentMethod = 'Coins';
  int _userCoins = 1250;
  int _contentCost = 500;
  int _remainingCoins = 750;

  // Mock content data - replace with actual content data
  final ContentModel _content = ContentModel(
    id: 'premium_1',
    title: 'The Power of Faith - Complete Series',
    description: 'A comprehensive 12-part series exploring the depths of Christian faith.',
    type: ContentType.video,
    status: ContentStatus.premium,
    coinCost: 500,
    category: 'premium-series',
    tags: ['faith', 'spiritual', 'premium'],
    author: 'Dr. Sarah Williams',
    createdAt: DateTime.now(),
    duration: 7200,
    viewCount: 0,
    downloadCount: 0,
    rating: 0,
    isDownloadable: true,
    isLive: false,
  );

  @override
  void initState() {
    super.initState();
    _remainingCoins = _userCoins - _contentCost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content Summary
            _buildContentSummary(),
            
            const SizedBox(height: 24),
            
            // Payment Method Selection
            _buildPaymentMethodSelection(),
            
            const SizedBox(height: 24),
            
            // Cost Breakdown
            _buildCostBreakdown(),
            
            const SizedBox(height: 24),
            
            // Terms and Conditions
            _buildTermsAndConditions(),
            
            const SizedBox(height: 24),
            
            // Purchase Button
            _buildPurchaseButton(),
            
            const SizedBox(height: 16),
            
            // Security Notice
            _buildSecurityNotice(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Purchase Summary',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                // Content Thumbnail
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle_fill,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Content Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _content.title,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${_content.author}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _content.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Coins Payment
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(
                    Icons.diamond,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('Pay with Coins'),
                ],
              ),
              subtitle: Text('Your balance: $_userCoins coins'),
              value: 'Coins',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
            ),
            
            // Credit Card Payment
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('Credit Card'),
                ],
              ),
              subtitle: Text('Pay \$${(_contentCost / 50).toStringAsFixed(2)} USD'),
              value: 'Credit Card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
            ),
            
            // PayPal Payment
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('PayPal'),
                ],
              ),
              subtitle: Text('Pay \$${(_contentCost / 50).toStringAsFixed(2)} USD'),
              value: 'PayPal',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Breakdown',
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
                  'Content Cost:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${_content.coinCost} coins',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Balance:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '$_userCoins coins',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            
            const Divider(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remaining Balance:',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$_remainingCoins coins',
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

  Widget _buildTermsAndConditions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            CheckboxListTile(
              title: const Text('I agree to the Terms of Service'),
              value: _agreeToTerms,
              onChanged: (value) => setState(() => _agreeToTerms = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            
            CheckboxListTile(
              title: const Text('I agree to the Privacy Policy'),
              value: _agreeToPrivacy,
              onChanged: (value) => setState(() => _agreeToPrivacy = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'By purchasing this content, you agree to our terms and conditions. This is a one-time purchase that grants you lifetime access to this content.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseButton() {
    final canPurchase = _agreeToTerms && _agreeToPrivacy;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canPurchase ? _processPurchase : null,
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
                _selectedPaymentMethod == 'Coins'
                    ? 'Purchase for ${_content.coinCost} coins'
                    : 'Purchase for \$${(_content.coinCost / 50).toStringAsFixed(2)}',
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
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
              'Your payment is secure and encrypted. We use industry-standard security measures to protect your information.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'You have successfully purchased "${_content.title}"!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your remaining balance: $_remainingCoins coins',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteNames.purchaseConfirmation);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
