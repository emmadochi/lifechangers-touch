import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final bool showAcceptButton;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const TermsAndConditionsScreen({
    super.key,
    this.showAcceptButton = false,
    this.onAccept,
    this.onDecline,
  });

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _hasScrolledToBottom = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      if (!_hasScrolledToBottom) {
        setState(() => _hasScrolledToBottom = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _printTerms,
            icon: const Icon(Icons.print),
          ),
          IconButton(
            onPressed: _shareTerms,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Column(
        children: [
          // Last Updated Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.surfaceVariant,
            child: Text(
              'Last updated: ${_getLastUpdatedDate()}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Terms Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    '1. Acceptance of Terms',
                    'By accessing and using the Lifechangers Touch mobile application ("App"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
                  ),
                  
                  _buildSection(
                    '2. Description of Service',
                    'Lifechangers Touch is a mobile application designed to help churches and religious organizations share content, stream services, and provide premium features through a coin-based system. The App provides:\n\n'
                    '• Content streaming and download capabilities\n'
                    '• Live streaming of church services and events\n'
                    '• Community features for prayer requests and sharing\n'
                    '• Premium content access through a coin-based system\n'
                    '• Offline content access for downloaded materials',
                  ),
                  
                  _buildSection(
                    '3. User Accounts',
                    'To access certain features of the App, you may be required to create an account. You are responsible for:\n\n'
                    '• Maintaining the confidentiality of your account credentials\n'
                    '• All activities that occur under your account\n'
                    '• Notifying us immediately of any unauthorized use\n'
                    '• Providing accurate and current information',
                  ),
                  
                  _buildSection(
                    '4. Content and Intellectual Property',
                    'The App contains content owned by Lifechangers Touch and third parties. This includes:\n\n'
                    '• Text, graphics, images, music, and videos\n'
                    '• Software, code, and technical documentation\n'
                    '• Trademarks, logos, and brand elements\n\n'
                    'You may not:\n'
                    '• Copy, modify, or distribute content without permission\n'
                    '• Use content for commercial purposes\n'
                    '• Remove copyright or proprietary notices\n'
                    '• Reverse engineer or decompile the App',
                  ),
                  
                  _buildSection(
                    '5. User-Generated Content',
                    'You may submit content to the App, including:\n\n'
                    '• Prayer requests and community posts\n'
                    '• Comments and feedback\n'
                    '• Profile information and photos\n\n'
                    'By submitting content, you grant us a non-exclusive, royalty-free license to use, modify, and distribute your content in connection with the App. You represent that you have the right to grant this license.',
                  ),
                  
                  _buildSection(
                    '6. Prohibited Uses',
                    'You may not use the App for:\n\n'
                    '• Any unlawful purpose or activity\n'
                    '• Harassment, abuse, or harm to others\n'
                    '• Spreading false or misleading information\n'
                    '• Violating any applicable laws or regulations\n'
                    '• Attempting to gain unauthorized access to the App\n'
                    '• Interfering with the proper functioning of the App',
                  ),
                  
                  _buildSection(
                    '7. Coin System and Payments',
                    'The App uses a virtual coin system for premium content access:\n\n'
                    '• Coins can be purchased with real money\n'
                    '• Coins can be earned through app engagement\n'
                    '• Coins are non-transferable and non-refundable\n'
                    '• We reserve the right to modify the coin system\n'
                    '• All purchases are final unless otherwise stated',
                  ),
                  
                  _buildSection(
                    '8. Privacy and Data Protection',
                    'Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your information. By using the App, you consent to our data practices as described in the Privacy Policy.',
                  ),
                  
                  _buildSection(
                    '9. Disclaimers and Limitations',
                    'THE APP IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND. WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO:\n\n'
                    '• MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE\n'
                    '• NON-INFRINGEMENT OF THIRD PARTY RIGHTS\n'
                    '• UNINTERRUPTED OR ERROR-FREE OPERATION\n\n'
                    'WE SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, OR CONSEQUENTIAL DAMAGES ARISING FROM YOUR USE OF THE APP.',
                  ),
                  
                  _buildSection(
                    '10. Termination',
                    'We may terminate or suspend your account and access to the App at any time, with or without notice, for any reason, including violation of these Terms. Upon termination:\n\n'
                    '• Your right to use the App ceases immediately\n'
                    '• We may delete your account and data\n'
                    '• You remain liable for any outstanding obligations',
                  ),
                  
                  _buildSection(
                    '11. Changes to Terms',
                    'We reserve the right to modify these Terms at any time. We will notify you of any material changes by:\n\n'
                    '• Posting the updated Terms in the App\n'
                    '• Sending you an email notification\n'
                    '• Displaying a notice when you next use the App\n\n'
                    'Your continued use of the App after changes constitutes acceptance of the new Terms.',
                  ),
                  
                  _buildSection(
                    '12. Governing Law',
                    'These Terms are governed by and construed in accordance with the laws of [Your Jurisdiction]. Any disputes arising from these Terms or your use of the App will be resolved in the courts of [Your Jurisdiction].',
                  ),
                  
                  _buildSection(
                    '13. Contact Information',
                    'If you have any questions about these Terms, please contact us at:\n\n'
                    'Email: legal@lifechangerstouch.com\n'
                    'Phone: 1-800-LIFE-TOUCH\n'
                    'Address: [Your Business Address]',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Signature Section
                  if (widget.showAcceptButton)
                    _buildSignatureSection(),
                ],
              ),
            ),
          ),
          
          // Accept/Decline Buttons
          if (widget.showAcceptButton)
            _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agreement',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'By clicking "I Accept" below, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _hasScrolledToBottom,
                  onChanged: null,
                  activeColor: AppColors.primary,
                ),
                Expanded(
                  child: Text(
                    'I have read and agree to the Terms and Conditions',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onDecline,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _hasScrolledToBottom ? widget.onAccept : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('I Accept'),
            ),
          ),
        ],
      ),
    );
  }

  String _getLastUpdatedDate() {
    return 'December 15, 2024';
  }

  void _printTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Printing terms and conditions...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing terms and conditions...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
