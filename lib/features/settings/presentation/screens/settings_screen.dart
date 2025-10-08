import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';

/// Settings screen widget
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings
            _buildSettingsSection(
              theme: theme,
              title: context.l10n.settingsGeneral,
              children: [
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.language,
                  title: context.l10n.settingsLanguage,
                  subtitle: 'العربية / English',
                  onTap: () {
                    // TODO: Show language picker
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.access_time,
                  title: 'المنطقة الزمنية',
                  subtitle: 'Asia/Riyadh',
                  onTap: () {
                    // TODO: Show timezone picker
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Appearance Settings
            _buildSettingsSection(
              theme: theme,
              title: context.l10n.settingsAppearance,
              children: [
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.palette,
                  title: context.l10n.settingsTheme,
                  subtitle: context.l10n.settingsThemeAuto,
                  onTap: () {
                    // TODO: Show theme picker
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.text_fields,
                  title: context.l10n.settingsFontSize,
                  subtitle: 'متوسط',
                  onTap: () {
                    // TODO: Show font size picker
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.animation,
                  title: 'الرسوم المتحركة',
                  subtitle: 'مفعلة',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle animations
                    },
                  ),
                  onTap: null,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Chat Settings
            _buildSettingsSection(
              theme: theme,
              title: 'إعدادات المحادثة',
              children: [
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.chat_bubble_outline,
                  title: 'نمط الرد',
                  subtitle: 'متوازن',
                  onTap: () {
                    // TODO: Show response mode picker
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.message_outlined,
                  title: 'الحد الأقصى للرسائل',
                  subtitle: '100',
                  onTap: () {
                    // TODO: Show message limit picker
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.auto_fix_high,
                  title: 'الرد التلقائي',
                  subtitle: 'مفعل',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle auto response
                    },
                  ),
                  onTap: null,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Privacy Settings
            _buildSettingsSection(
              theme: theme,
              title: context.l10n.settingsPrivacy,
              children: [
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.analytics_outlined,
                  title: 'جمع البيانات التحليلية',
                  subtitle: 'مفعل',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle analytics
                    },
                  ),
                  onTap: null,
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.save_outlined,
                  title: 'حفظ سجل المحادثات',
                  subtitle: 'مفعل',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle chat history saving
                    },
                  ),
                  onTap: null,
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.share_outlined,
                  title: 'مشاركة المحادثات',
                  subtitle: 'مفعل',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle sharing
                    },
                  ),
                  onTap: null,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Data Settings
            _buildSettingsSection(
              theme: theme,
              title: context.l10n.settingsData,
              children: [
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.backup_outlined,
                  title: 'النسخ الاحتياطي',
                  subtitle: 'تلقائي',
                  onTap: () {
                    // TODO: Show backup settings
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.file_download_outlined,
                  title: 'تصدير البيانات',
                  subtitle: 'JSON, PDF',
                  onTap: () {
                    // TODO: Show export options
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.storage,
                  title: 'مساحة التخزين',
                  subtitle: '25.3 MB',
                  onTap: () {
                    // TODO: Show storage details
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.delete_forever,
                  title: 'حذف جميع البيانات',
                  subtitle: 'إجراء دائم',
                  onTap: () {
                    _showDeleteConfirmation(context, theme);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // About Settings
            _buildSettingsSection(
              theme: theme,
              title: context.l10n.settingsAbout,
              children: [
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.info_outline,
                  title: 'حول التطبيق',
                  subtitle: 'الإصدار 1.0.0',
                  onTap: () {
                    _showAboutDialog(context, theme);
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.policy_outlined,
                  title: 'سياسة الخصوصية',
                  subtitle: 'اقرأ سياسة الخصوصية',
                  onTap: () {
                    // TODO: Open privacy policy
                  },
                ),
                _buildSettingsTile(
                  theme: theme,
                  icon: Icons.description_outlined,
                  title: 'شروط الاستخدام',
                  subtitle: 'اقرأ شروط الاستخدام',
                  onTap: () {
                    // TODO: Open terms of service
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build settings section
  Widget _buildSettingsSection({
    required ThemeData theme,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// Build settings tile
  Widget _buildSettingsTile({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف جميع البيانات'),
        content: const Text(
          'هل أنت متأكد من حذف جميع البيانات؟ هذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement data deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف جميع البيانات')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  /// Show about dialog
  void _showAboutDialog(BuildContext context, ThemeData theme) {
    showAboutDialog(
      context: context,
      applicationName: context.l10n.appName,
      applicationVersion: '1.0.0',
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/mosa3ed_kfu_icon_app.jpg',
          width: 64,
          height: 64,
          fit: BoxFit.cover,
        ),
      ),
      children: [Text(context.l10n.appDescription)],
    );
  }
}
