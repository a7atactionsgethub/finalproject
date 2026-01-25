import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../themes/app_theme.dart';
import '../../widgets/custom_switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _emailNotifications = true;

  @override
  void initState() {
    super.initState();
    AppTheme.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    AppTheme.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppDecorations.backgroundDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                Row(
                  children: [
                    Container(
                      decoration: AppDecorations.glassContainer(borderRadius: 100),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: AppTheme.textSecondary),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Settings',
                      style: AppTextStyles.headerLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Settings Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Appearance Section
                        _buildSectionHeader('Appearance'),
                        _buildGlassCard(
                          children: [
                            _buildSettingSwitch(
                              icon: Icons.dark_mode_outlined,
                              title: 'Dark Mode',
                              value: AppTheme.isDarkMode,
                              onChanged: (value) {
                                setState(() {
                                  AppTheme.isDarkMode = value;
                                });
                              },
                            ),
                            _buildDivider(),
                            _buildSettingOption(
                              icon: Icons.color_lens_outlined,
                              title: 'Theme Color',
                              subtitle: AppTheme.isDarkMode ? 'Orange Theme' : 'Blue Theme',
                              onTap: () {
                                // Theme color selection
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Notifications Section
                        _buildSectionHeader('Notifications'),
                        _buildGlassCard(
                          children: [
                            _buildSettingSwitch(
                              icon: Icons.notifications_outlined,
                              title: 'Push Notifications',
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                            ),
                            _buildDivider(),
                            _buildSettingSwitch(
                              icon: Icons.email_outlined,
                              title: 'Email Notifications',
                              value: _emailNotifications,
                              onChanged: (value) {
                                setState(() {
                                  _emailNotifications = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Security Section
                        _buildSectionHeader('Security'),
                        _buildGlassCard(
                          children: [
                            _buildSettingSwitch(
                              icon: Icons.fingerprint_outlined,
                              title: 'Biometric Login',
                              value: _biometricEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _biometricEnabled = value;
                                });
                              },
                            ),
                            _buildDivider(),
                            _buildSettingOption(
                              icon: Icons.lock_outlined,
                              title: 'Change Password',
                              onTap: () {
                                // Change password
                              },
                            ),
                            _buildDivider(),
                            _buildSettingOption(
                              icon: Icons.security_outlined,
                              title: 'Privacy & Security',
                              onTap: () {
                                // Privacy settings
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // About Section
                        _buildSectionHeader('About'),
                        _buildGlassCard(
                          children: [
                            _buildSettingOption(
                              icon: Icons.info_outlined,
                              title: 'App Information',
                              onTap: () {
                                _showAppInfoDialog();
                              },
                            ),
                            _buildDivider(),
                            _buildSettingOption(
                              icon: Icons.school_outlined,
                              title: 'App Tutorial',
                              onTap: () {
                                // Tutorial
                              },
                            ),
                            _buildDivider(),
                            _buildSettingOption(
                              icon: Icons.shield_outlined,
                              title: 'Privacy Policy',
                              onTap: () {
                                // Privacy policy
                              },
                            ),
                            _buildDivider(),
                            _buildSettingOption(
                              icon: Icons.description_outlined,
                              title: 'Terms of Service',
                              onTap: () {
                                // Terms of service
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Support Section
                        _buildSectionHeader('Support'),
                        _buildGlassCard(
                          children: [
                            _buildSettingOption(
                              icon: Icons.help_outlined,
                              title: 'Help & Support',
                              onTap: () {
                                // Help & support
                              },
                            ),
                            _buildDivider(),
                            _buildSettingOption(
                              icon: Icons.bug_report_outlined,
                              title: 'Report a Bug',
                              onTap: () {
                                // Bug report
                              },
                            ),
                            _buildDivider(),
                            _buildSettingOption(
                              icon: Icons.star_outlined,
                              title: 'Rate the App',
                              onTap: () {
                                // Rate app
                              },
                            ),
                            _buildDivider(),
                            _buildSettingOption(
                              icon: Icons.feedback_outlined,
                              title: 'Send Feedback',
                              onTap: () {
                                // Feedback
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Logout Button
                        _buildLogoutButton(),
                        const SizedBox(height: 16),
                        
                        // App Version
                        Text(
                          'Version 1.0.0 • SXCCE Gate Pass',
                          style: AppTextStyles.labelTertiary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTextStyles.headerSmall,
      ),
    );
  }

  Widget _buildGlassCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: AppDecorations.glassContainer(borderRadius: 16),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.labelTertiary,
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: AppTheme.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSettingSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: CustomSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppTheme.dividerColor,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: AppDecorations.buttonDecoration(borderRadius: 16),
      child: TextButton(
        onPressed: () {
          _showLogoutDialog();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: AppTextStyles.buttonLarge,
            ),
          ],
        ),
      ),
    );
  }

  void _showAppInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: AppDecorations.glassContainer(
            borderRadius: 16,
            color: AppTheme.isDarkMode 
                ? const Color(0xFF1A1A1A) 
                : const Color(0xFFF5F5F5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outlined,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'App Information',
                    style: AppTextStyles.headerSmall,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoRow('App Name', 'SXCCE Gate Pass'),
              _buildInfoRow('Version', '1.0.0'),
              _buildInfoRow('Build Number', '1'),
              _buildInfoRow('Developer', 'SXCCE Institution'),
              _buildInfoRow('Flutter Version', '3.19.0'),
              _buildInfoRow('Last Updated', 'December 2024'),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: AppDecorations.buttonDecoration(borderRadius: 12),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: AppDecorations.glassContainer(
            borderRadius: 16,
            color: AppTheme.isDarkMode 
                ? const Color(0xFF1A1A1A) 
                : const Color(0xFFF5F5F5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout_rounded,
                color: AppTheme.primaryColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Logout',
                style: AppTextStyles.headerSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to logout from your account?',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: AppDecorations.glassContainer(borderRadius: 12),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: AppDecorations.buttonDecoration(borderRadius: 12),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _performLogout();
                        },
                        child: Text(
                          'Logout',
                          style: AppTextStyles.buttonMedium,
                        ),
                      ),
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

  void _performLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/signin');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: AppTheme.primaryColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}