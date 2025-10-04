import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/routes/route_names.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _printPolicy,
            icon: const Icon(Icons.print),
          ),
          IconButton(
            onPressed: _sharePolicy,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Updated Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Privacy Policy',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: ${_getLastUpdatedDate()}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              '1. Introduction',
              'At Lifechangers Touch, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
            ),
            
            _buildSection(
              '2. Information We Collect',
              'We collect information in several ways:\n\n'
              '**Personal Information:**\n'
              '• Name, email address, and phone number\n'
              '• Profile information and preferences\n'
              '• Payment and billing information\n'
              '• Church affiliation and location\n\n'
              '**Usage Information:**\n'
              '• App usage patterns and preferences\n'
              '• Content viewed and downloaded\n'
              '• Community interactions and posts\n'
              '• Device information and identifiers\n\n'
              '**Technical Information:**\n'
              '• IP address and device identifiers\n'
              '• Operating system and app version\n'
              '• Crash reports and performance data\n'
              '• Network and connection information',
            ),
            
            _buildSection(
              '3. How We Use Your Information',
              'We use your information to:\n\n'
              '• Provide and improve our services\n'
              '• Personalize your experience\n'
              '• Process payments and transactions\n'
              '• Send important notifications and updates\n'
              '• Facilitate community interactions\n'
              '• Analyze usage patterns and trends\n'
              '• Ensure app security and prevent fraud\n'
              '• Comply with legal obligations',
            ),
            
            _buildSection(
              '4. Information Sharing',
              'We may share your information in the following circumstances:\n\n'
              '**With Your Consent:**\n'
              '• When you explicitly agree to share information\n'
              '• For community features and interactions\n'
              '• For marketing and promotional purposes\n\n'
              '**Service Providers:**\n'
              '• Third-party vendors who assist with app operations\n'
              '• Payment processors for transaction handling\n'
              '• Cloud storage providers for data hosting\n'
              '• Analytics services for usage insights\n\n'
              '**Legal Requirements:**\n'
              '• When required by law or legal process\n'
              '• To protect our rights and property\n'
              '• To ensure user safety and security\n'
              '• In case of business transfers or mergers',
            ),
            
            _buildSection(
              '5. Data Security',
              'We implement appropriate security measures to protect your information:\n\n'
              '• Encryption of data in transit and at rest\n'
              '• Secure authentication and access controls\n'
              '• Regular security audits and assessments\n'
              '• Employee training on data protection\n'
              '• Incident response and breach notification procedures\n\n'
              'However, no method of transmission over the internet or electronic storage is 100% secure. We cannot guarantee absolute security.',
            ),
            
            _buildSection(
              '6. Data Retention',
              'We retain your information for as long as necessary to:\n\n'
              '• Provide our services to you\n'
              '• Comply with legal obligations\n'
              '• Resolve disputes and enforce agreements\n'
              '• Improve our services and user experience\n\n'
              'You may request deletion of your account and associated data at any time, subject to legal and operational requirements.',
            ),
            
            _buildSection(
              '7. Your Rights and Choices',
              'You have the following rights regarding your personal information:\n\n'
              '**Access and Portability:**\n'
              '• Request a copy of your personal data\n'
              '• Export your data in a portable format\n'
              '• View your account information and activity\n\n'
              '**Correction and Updates:**\n'
              '• Update your profile information\n'
              '• Correct inaccurate or outdated data\n'
              '• Modify your privacy preferences\n\n'
              '**Deletion and Restriction:**\n'
              '• Request deletion of your account\n'
              '• Restrict processing of your data\n'
              '• Object to certain uses of your information\n\n'
              '**Communication Preferences:**\n'
              '• Opt out of marketing communications\n'
              '• Manage notification settings\n'
              '• Control data sharing preferences',
            ),
            
            _buildSection(
              '8. Cookies and Tracking',
              'We use cookies and similar technologies to:\n\n'
              '• Remember your preferences and settings\n'
              '• Analyze app usage and performance\n'
              '• Provide personalized content and recommendations\n'
              '• Improve user experience and functionality\n\n'
              'You can control cookie settings through your device preferences, though this may affect app functionality.',
            ),
            
            _buildSection(
              '9. Third-Party Services',
              'Our app may integrate with third-party services:\n\n'
              '• Social media platforms for sharing\n'
              '• Payment processors for transactions\n'
              '• Analytics services for insights\n'
              '• Cloud storage for content delivery\n\n'
              'These services have their own privacy policies, and we encourage you to review them.',
            ),
            
            _buildSection(
              '10. Children\'s Privacy',
              'Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete such information.',
            ),
            
            _buildSection(
              '11. International Transfers',
              'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your information during such transfers, including:\n\n'
              '• Standard contractual clauses\n'
              '• Adequacy decisions by relevant authorities\n'
              '• Binding corporate rules\n'
              '• Other appropriate safeguards',
            ),
            
            _buildSection(
              '12. Changes to This Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any material changes by:\n\n'
              '• Posting the updated policy in the app\n'
              '• Sending you an email notification\n'
              '• Displaying a notice when you next use the app\n\n'
              'Your continued use of the app after changes constitutes acceptance of the updated policy.',
            ),
            
            _buildSection(
              '13. Contact Us',
              'If you have any questions about this Privacy Policy or our data practices, please contact us:\n\n'
              '**Email:** privacy@lifechangerstouch.com\n'
              '**Phone:** 1-800-LIFE-TOUCH\n'
              '**Address:** [Your Business Address]\n'
              '**Data Protection Officer:** dpo@lifechangerstouch.com\n\n'
              'We will respond to your inquiry within 30 days.',
            ),
            
            const SizedBox(height: 32),
            
            // Data Rights Summary
            _buildDataRightsSummary(),
            
            const SizedBox(height: 32),
          ],
        ),
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

  Widget _buildDataRightsSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Data Rights Summary',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildRightItem(
              Icons.visibility,
              'Right to Access',
              'View and download your personal data',
            ),
            
            _buildRightItem(
              Icons.edit,
              'Right to Rectification',
              'Correct inaccurate or incomplete data',
            ),
            
            _buildRightItem(
              Icons.delete,
              'Right to Erasure',
              'Request deletion of your personal data',
            ),
            
            _buildRightItem(
              Icons.block,
              'Right to Restrict',
              'Limit how we process your data',
            ),
            
            _buildRightItem(
              Icons.download,
              'Right to Portability',
              'Export your data in a portable format',
            ),
            
            _buildRightItem(
              Icons.cancel,
              'Right to Object',
              'Opt out of certain data processing',
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _exerciseRights,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Exercise Your Rights'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
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

  String _getLastUpdatedDate() {
    return 'December 15, 2024';
  }

  void _printPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Printing privacy policy...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _sharePolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing privacy policy...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _exerciseRights() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exercise Your Rights'),
        content: const Text('To exercise your data rights, please contact our Data Protection Officer at dpo@lifechangerstouch.com or use the contact form in the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Open contact form or email client
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening contact form...'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Contact Us'),
          ),
        ],
      ),
    );
  }
}
