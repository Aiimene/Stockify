import 'package:flutter/material.dart';
import '../../presentation/themes/app_colors.dart';
import '../../presentation/widgets/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Settings',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              _buildSectionHeader('Account'),
              const SizedBox(height: 12),

              _buildSettingsItem(
                context,
                icon: Icons.store_outlined,
                title: 'Business Information',
                subtitle: 'Update your business details',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Business Info - Coming Soon')),
                  );
                },
              ),
              const SizedBox(height: 8),

              _buildSettingsItem(
                context,
                icon: Icons.receipt_long_outlined,
                title: 'Billing Information',
                subtitle: 'Manage payment methods',
                onTap: () {
                  Navigator.pushNamed(context, '/billing');
                },
              ),
              const SizedBox(height: 8),

              _buildSettingsItem(
                context,
                icon: Icons.card_membership_outlined,
                title: 'Subscription Plan',
                subtitle: 'View and manage subscription',
                onTap: () {
                  Navigator.pushNamed(context, '/subscription');
                },
              ),
              const SizedBox(height: 24),

              // App Preferences Section
              _buildSectionHeader('App Preferences'),
              const SizedBox(height: 12),

              _buildSettingsItem(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
              const SizedBox(height: 8),

              _buildSettingsItem(
                context,
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'English',
                onTap: () {
                  Navigator.pushNamed(context, '/language');
                },
              ),
              const SizedBox(height: 8),

              _buildSettingsItem(
                context,
                icon: Icons.dark_mode_outlined,
                title: 'Appearance',
                subtitle: 'Light mode',
                onTap: () {
                  _showAppearanceDialog(context);
                },
              ),
              const SizedBox(height: 8),

              _buildSettingsItem(
                context,
                icon: Icons.sync_outlined,
                title: 'Data Sync',
                subtitle: 'Auto-sync enabled',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data Sync Settings - Coming Soon')),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Support Section
              _buildSectionHeader('Support'),
              const SizedBox(height: 12),

              _buildSettingsItem(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help and contact us',
                onTap: () {
                  _showHelpDialog(context);
                },
              ),
              const SizedBox(height: 8),

              _buildSettingsItem(
                context,
                icon: Icons.shield_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  Navigator.pushNamed(context, '/privacy');
                },
              ),
              const SizedBox(height: 8),

              _buildSettingsItem(
                context,
                icon: Icons.info_outline,
                title: 'About StockiFy',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              const SizedBox(height: 24),

              // Danger Zone
              _buildSectionHeader('Account Actions'),
              const SizedBox(height: 12),

              _buildSettingsItem(
                context,
                icon: Icons.logout,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                iconColor: AppColors.error,
                titleColor: AppColors.error,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveTitleColor = titleColor ?? AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: effectiveIconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: effectiveIconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: effectiveTitleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'en',
              activeColor: AppColors.accent,
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Français'),
              value: 'fr',
              groupValue: 'en',
              activeColor: AppColors.accent,
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language change - Coming Soon')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('العربية'),
              value: 'ar',
              groupValue: 'en',
              activeColor: AppColors.accent,
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language change - Coming Soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAppearanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appearance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Light Mode'),
              value: 'light',
              groupValue: 'light',
              activeColor: AppColors.accent,
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark Mode'),
              value: 'dark',
              groupValue: 'light',
              activeColor: AppColors.accent,
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dark Mode - Coming Soon')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('System Default'),
              value: 'system',
              groupValue: 'light',
              activeColor: AppColors.accent,
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('System Theme - Coming Soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('📧 Email: support@stockify.com'),
            SizedBox(height: 4),
            Text('📱 Phone: +213 XXX XXX XXX'),
            SizedBox(height: 4),
            Text('🌐 Web: www.stockify.com'),
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

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'StockiFy Privacy Policy\n\n'
            'We value your privacy and are committed to protecting your personal information.\n\n'
            '1. Data Collection: We collect only necessary business data.\n'
            '2. Data Usage: Your data is used solely for app functionality.\n'
            '3. Data Security: We use industry-standard security measures.\n'
            '4. Data Sharing: We never share your data with third parties.\n\n'
            'For full privacy policy, visit our website.',
            style: TextStyle(fontSize: 14),
          ),
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About StockiFy'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'StockiFy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'A comprehensive inventory and sales management solution for retail businesses.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '© 2025 StockiFy. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
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
}

