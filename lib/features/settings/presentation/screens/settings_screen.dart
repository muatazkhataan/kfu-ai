import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/models/settings_category.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_item.dart' as widgets;
import '../widgets/theme_selector.dart';
import '../widgets/font_size_selector.dart';
import '../widgets/creativity_slider.dart';

/// شاشة الإعدادات المطورة
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final settings = ref.watch(settingsProvider);
    final updateState = ref.watch(settingsUpdateStateProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: _buildAppBar(theme, updateState),
      body: Column(
        children: [
          // شريط التبويبات الثابت
          _buildFixedTabBar(theme),

          // النص للتاب المحدد
          _buildTabLabel(theme),

          // محتوى التبويبات
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralSettings(settings),
                _buildAppearanceSettings(settings),
                _buildChatSettings(settings),
                _buildPrivacySettings(settings),
                _buildNotificationSettings(settings),
                _buildAISettings(settings),
                _buildDataSettings(settings),
                _buildAboutSettings(settings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// بناء AppBar مخصص
  AppBar _buildAppBar(ThemeData theme, SettingsUpdateState updateState) {
    return AppBar(
      title: Text(context.l10n.settingsTitle),
      centerTitle: true,
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      actions: [
        // زر الحفظ
        if (updateState.hasUnsavedChanges)
          IconButton(
            onPressed: _saveSettings,
            icon: updateState.isUpdating
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : const Icon(Icons.save),
            tooltip: context.l10n.settingsSave,
          ),

        // قائمة إضافية
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'reset',
              child: Row(
                children: [
                  const Icon(Icons.refresh),
                  const SizedBox(width: 8),
                  Text(context.l10n.settingsReset),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  const Icon(Icons.file_download),
                  const SizedBox(width: 8),
                  Text(context.l10n.settingsExport),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'import',
              child: Row(
                children: [
                  const Icon(Icons.file_upload),
                  const SizedBox(width: 8),
                  Text(context.l10n.settingsImport),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// بناء شريط التبويبات الثابت
  Widget _buildFixedTabBar(ThemeData theme) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicator: _CustomTabIndicator(
          color: theme.colorScheme.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          indicatorWidth: 48, // عرض ثابت أكبر من الأيقونة
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(icon: Icon(Icons.tune, size: 20)),
          Tab(icon: Icon(Icons.palette, size: 20)),
          Tab(icon: Icon(Icons.chat_bubble, size: 20)),
          Tab(icon: Icon(Icons.shield, size: 20)),
          Tab(icon: Icon(Icons.notifications, size: 20)),
          Tab(icon: Icon(Icons.psychology, size: 20)),
          Tab(icon: Icon(Icons.storage, size: 20)),
          Tab(icon: Icon(Icons.info, size: 20)),
        ],
      ),
    );
  }

  /// بناء نص التاب المحدد
  Widget _buildTabLabel(ThemeData theme) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        final currentIndex = _tabController.index;
        final tabLabels = [
          context.l10n.settingsGeneralTitle,
          context.l10n.settingsAppearanceTitle,
          context.l10n.settingsChatTitle,
          context.l10n.settingsPrivacyTitle,
          context.l10n.settingsNotificationsTitle,
          context.l10n.settingsAITitle,
          context.l10n.settingsDataTitle,
          context.l10n.settingsAboutTitle,
        ];
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
          ),
          child: Row(
            children: [
              Icon(
                _getTabIcon(currentIndex),
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                tabLabels[currentIndex],
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// الحصول على أيقونة التاب
  IconData _getTabIcon(int index) {
    switch (index) {
      case 0:
        return Icons.tune;
      case 1:
        return Icons.palette;
      case 2:
        return Icons.chat_bubble;
      case 3:
        return Icons.shield;
      case 4:
        return Icons.notifications;
      case 5:
        return Icons.psychology;
      case 6:
        return Icons.storage;
      case 7:
        return Icons.info;
      default:
        return Icons.settings;
    }
  }

  /// الإعدادات العامة
  Widget _buildGeneralSettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          SettingsCard(
            title: context.l10n.settingsGeneralTitle,
            description: context.l10n.settingsGeneralDescription,
            icon: Icons.tune,
            children: [
              widgets.SettingsItem(
                title: context.l10n.settingsDefaultLanguage,
                subtitle: context.l10n.settingsDefaultLanguageSubtitle,
                icon: Icons.language,
                type: SettingsItemType.dropdown,
                value: settings.defaultLanguage,
                options: {
                  'items': [
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text(context.l10n.languageArabic),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(context.l10n.languageEnglish),
                    ),
                  ],
                },
                onChanged: (value) => _updateSetting('defaultLanguage', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsTimezone,
                subtitle: context.l10n.settingsTimezoneSubtitle,
                icon: Icons.access_time,
                type: SettingsItemType.dropdown,
                value: settings.timezone,
                options: {
                  'items': [
                    DropdownMenuItem(
                      value: 'Asia/Riyadh',
                      child: Text(context.l10n.timezoneRiyadh),
                    ),
                    DropdownMenuItem(
                      value: 'Asia/Dubai',
                      child: Text(context.l10n.timezoneDubai),
                    ),
                    DropdownMenuItem(
                      value: 'Asia/Kuwait',
                      child: Text(context.l10n.timezoneKuwait),
                    ),
                  ],
                },
                onChanged: (value) => _updateSetting('timezone', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsBetaMode,
                subtitle: context.l10n.settingsBetaModeSubtitle,
                icon: Icons.science,
                type: SettingsItemType.toggle,
                value: settings.betaMode,
                onChanged: (value) => _updateSetting('betaMode', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsAutoUpdate,
                subtitle: context.l10n.settingsAutoUpdateSubtitle,
                icon: Icons.system_update,
                type: SettingsItemType.toggle,
                value: settings.autoUpdate,
                onChanged: (value) => _updateSetting('autoUpdate', value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// إعدادات المظهر
  Widget _buildAppearanceSettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          SettingsCard(
            title: context.l10n.settingsAppearanceTitle,
            description: context.l10n.settingsAppearanceDescription,
            icon: Icons.palette,
            accentColor: Colors.purple,
            children: [
              // محدد المظهر
              ThemeSelector(
                selectedMode: settings.themeMode,
                onChanged: (mode) => _updateSetting('themeMode', mode),
              ),

              const SizedBox(height: 12),

              // محدد حجم الخط
              FontSizeSelector(
                selectedSize: settings.fontSize,
                onChanged: (size) => _updateSetting('fontSize', size),
              ),

              const SizedBox(height: 12),

              widgets.SettingsItem(
                title: context.l10n.settingsAnimations,
                subtitle: context.l10n.settingsAnimationsSubtitle,
                icon: Icons.animation,
                type: SettingsItemType.toggle,
                value: settings.animationsEnabled,
                onChanged: (value) =>
                    _updateSetting('animationsEnabled', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsHapticFeedback,
                subtitle: context.l10n.settingsHapticFeedbackSubtitle,
                icon: Icons.vibration,
                type: SettingsItemType.toggle,
                value: settings.hapticFeedback,
                onChanged: (value) => _updateSetting('hapticFeedback', value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// إعدادات المحادثة
  Widget _buildChatSettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          SettingsCard(
            title: context.l10n.settingsChatTitle,
            description: context.l10n.settingsChatDescription,
            icon: Icons.chat_bubble,
            accentColor: Colors.green,
            children: [
              widgets.SettingsItem(
                title: context.l10n.settingsResponseStyle,
                subtitle: context.l10n.settingsResponseStyleSubtitle,
                icon: Icons.chat,
                type: SettingsItemType.dropdown,
                value: settings.responseStyle,
                options: {
                  'items': ResponseStyle.values.map((style) {
                    return DropdownMenuItem(
                      value: style,
                      child: Text(_getResponseStyleLabel(context, style)),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('responseStyle', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsMaxMessages,
                subtitle: context.l10n.settingsMaxMessagesSubtitle,
                icon: Icons.format_list_numbered,
                type: SettingsItemType.dropdown,
                value: settings.maxMessages,
                options: {
                  'items': [50, 100, 200, 500].map((count) {
                    return DropdownMenuItem(
                      value: count,
                      child: Text(context.l10n.settingsMessagesCount(count)),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('maxMessages', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsAutoResponse,
                subtitle: context.l10n.settingsAutoResponseSubtitle,
                icon: Icons.auto_fix_high,
                type: SettingsItemType.toggle,
                value: settings.autoResponse,
                onChanged: (value) => _updateSetting('autoResponse', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsShowSuggestions,
                subtitle: context.l10n.settingsShowSuggestionsSubtitle,
                icon: Icons.lightbulb_outline,
                type: SettingsItemType.toggle,
                value: settings.showSuggestions,
                onChanged: (value) => _updateSetting('showSuggestions', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsAutoCorrect,
                subtitle: context.l10n.settingsAutoCorrectSubtitle,
                icon: Icons.spellcheck,
                type: SettingsItemType.toggle,
                value: settings.autoCorrect,
                onChanged: (value) => _updateSetting('autoCorrect', value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// إعدادات الخصوصية
  Widget _buildPrivacySettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          SettingsCard(
            title: context.l10n.settingsPrivacyTitle,
            description: context.l10n.settingsPrivacyDescription,
            icon: Icons.shield,
            accentColor: Colors.orange,
            children: [
              widgets.SettingsItem(
                title: context.l10n.settingsAnalytics,
                subtitle: context.l10n.settingsAnalyticsSubtitle,
                icon: Icons.analytics,
                type: SettingsItemType.toggle,
                value: settings.analytics,
                onChanged: (value) => _updateSetting('analytics', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsSaveChatHistory,
                subtitle: context.l10n.settingsSaveChatHistorySubtitle,
                icon: Icons.history,
                type: SettingsItemType.toggle,
                value: settings.saveChatHistory,
                onChanged: (value) => _updateSetting('saveChatHistory', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsAllowSharing,
                subtitle: context.l10n.settingsAllowSharingSubtitle,
                icon: Icons.share,
                type: SettingsItemType.toggle,
                value: settings.allowSharing,
                onChanged: (value) => _updateSetting('allowSharing', value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// إعدادات الإشعارات
  Widget _buildNotificationSettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          SettingsCard(
            title: context.l10n.settingsNotificationsTitle,
            description: context.l10n.settingsNotificationsDescription,
            icon: Icons.notifications,
            accentColor: Colors.blue,
            children: [
              widgets.SettingsItem(
                title: context.l10n.settingsEnableNotifications,
                subtitle: context.l10n.settingsEnableNotificationsSubtitle,
                icon: Icons.notifications_active,
                type: SettingsItemType.toggle,
                value: settings.enableNotifications,
                onChanged: (value) =>
                    _updateSetting('enableNotifications', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsUpdateNotifications,
                subtitle: context.l10n.settingsUpdateNotificationsSubtitle,
                icon: Icons.system_update_alt,
                type: SettingsItemType.toggle,
                value: settings.updateNotifications,
                onChanged: (value) =>
                    _updateSetting('updateNotifications', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsFeatureNotifications,
                subtitle: context.l10n.settingsFeatureNotificationsSubtitle,
                icon: Icons.new_releases,
                type: SettingsItemType.toggle,
                value: settings.featureNotifications,
                onChanged: (value) =>
                    _updateSetting('featureNotifications', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsNotificationSound,
                subtitle: context.l10n.settingsNotificationSoundSubtitle,
                icon: Icons.volume_up,
                type: SettingsItemType.toggle,
                value: settings.notificationSound,
                onChanged: (value) =>
                    _updateSetting('notificationSound', value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// إعدادات الذكاء الاصطناعي
  Widget _buildAISettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          SettingsCard(
            title: context.l10n.settingsAITitle,
            description: context.l10n.settingsAIDescription,
            icon: Icons.psychology,
            accentColor: Colors.deepPurple,
            children: [
              widgets.SettingsItem(
                title: context.l10n.settingsAIModel,
                subtitle: context.l10n.settingsAIModelSubtitle,
                icon: Icons.memory,
                type: SettingsItemType.dropdown,
                value: settings.aiModel,
                options: {
                  'items': AIModel.values.map((model) {
                    return DropdownMenuItem(
                      value: model,
                      child: Text(_getAIModelLabel(context, model)),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('aiModel', value),
              ),

              const SizedBox(height: 12),

              // شريط الإبداع
              CreativitySlider(
                value: settings.creativityLevel,
                onChanged: (value) => _updateSetting('creativityLevel', value),
              ),

              const SizedBox(height: 12),

              widgets.SettingsItem(
                title: context.l10n.settingsContextLength,
                subtitle: context.l10n.settingsContextLengthSubtitle,
                icon: Icons.history_edu,
                type: SettingsItemType.dropdown,
                value: settings.contextLength,
                options: {
                  'items': [5, 10, 20, 50].map((count) {
                    return DropdownMenuItem(
                      value: count,
                      child: Text(
                        context.l10n.settingsContextMessagesCount(count),
                      ),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('contextLength', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsAdaptiveLearning,
                subtitle: context.l10n.settingsAdaptiveLearningSubtitle,
                icon: Icons.school,
                type: SettingsItemType.toggle,
                value: settings.adaptiveLearning,
                onChanged: (value) => _updateSetting('adaptiveLearning', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsExperimentalAI,
                subtitle: context.l10n.settingsExperimentalAISubtitle,
                icon: Icons.biotech,
                type: SettingsItemType.toggle,
                value: settings.experimentalAI,
                onChanged: (value) => _updateSetting('experimentalAI', value),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// إعدادات البيانات
  Widget _buildDataSettings(AppSettings settings) {
    final usageInfoAsync = ref.watch(settingsUsageInfoProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          SettingsCard(
            title: context.l10n.settingsDataTitle,
            description: context.l10n.settingsDataDescription,
            icon: Icons.storage,
            accentColor: Colors.teal,
            children: [
              widgets.SettingsItem(
                title: context.l10n.settingsAutoBackup,
                subtitle: context.l10n.settingsAutoBackupSubtitle,
                icon: Icons.backup,
                type: SettingsItemType.toggle,
                value: settings.autoBackup,
                onChanged: (value) => _updateSetting('autoBackup', value),
              ),

              widgets.SettingsItem(
                title: context.l10n.settingsBackupFrequency,
                subtitle: context.l10n.settingsBackupFrequencySubtitle,
                icon: Icons.schedule,
                type: SettingsItemType.dropdown,
                value: settings.backupFrequency,
                options: {
                  'items': BackupFrequency.values.map((freq) {
                    return DropdownMenuItem(
                      value: freq,
                      child: Text(_getBackupFrequencyLabel(context, freq)),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('backupFrequency', value),
              ),

              // معلومات الاستخدام
              usageInfoAsync.when(
                data: (usageInfo) => _buildStorageInfo(usageInfo),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Text('${context.l10n.commonError}: $error'),
              ),

              const SizedBox(height: 12),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _exportSettings,
                      icon: const Icon(Icons.file_download),
                      label: Text(context.l10n.settingsExportData),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showDeleteDialog,
                      icon: const Icon(Icons.delete_forever),
                      label: Text(context.l10n.settingsDeleteAllData),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// معلومات التخزين
  Widget _buildStorageInfo(SettingsUsageInfo usageInfo) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.l10n.settingsStorageUsed,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                usageInfo.storageText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: usageInfo.storagePercentage,
            backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              usageInfo.isStorageNearFull
                  ? Colors.orange
                  : theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildStorageStat(
                  context.l10n.settingsChats,
                  usageInfo.totalChats.toString(),
                  Icons.chat,
                ),
              ),
              Expanded(
                child: _buildStorageStat(
                  context.l10n.settingsMessages,
                  usageInfo.totalMessages.toString(),
                  Icons.message,
                ),
              ),
              Expanded(
                child: _buildStorageStat(
                  context.l10n.settingsLastBackup,
                  usageInfo.lastBackup != null
                      ? '${usageInfo.lastBackup!.day}/${usageInfo.lastBackup!.month}'
                      : context.l10n.settingsNoBackup,
                  Icons.backup,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageStat(String label, String value, IconData icon) {
    final theme = context.theme;

    return Column(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }

  /// إعدادات حول التطبيق
  Widget _buildAboutSettings(AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          SettingsCard(
            title: context.l10n.settingsAboutTitle,
            description: context.l10n.settingsAboutDescription,
            icon: Icons.info,
            children: [
              // شعار التطبيق
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/mosa3ed_kfu_icon_app.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.appName,
                      style: context.theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.l10n.settingsAppVersion(settings.version),
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.settingsAppDescription,
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              widgets.SimpleSettingsItem(
                title: context.l10n.settingsPrivacyPolicy,
                subtitle: context.l10n.settingsPrivacyPolicySubtitle,
                icon: Icons.policy,
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // TODO: فتح سياسة الخصوصية
                },
              ),

              widgets.SimpleSettingsItem(
                title: context.l10n.settingsTermsOfService,
                subtitle: context.l10n.settingsTermsOfServiceSubtitle,
                icon: Icons.description,
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // TODO: فتح شروط الاستخدام
                },
              ),

              widgets.SimpleSettingsItem(
                title: context.l10n.settingsHelpAndSupport,
                subtitle: context.l10n.settingsHelpAndSupportSubtitle,
                icon: Icons.help_outline,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: فتح صفحة المساعدة
                },
              ),

              widgets.SimpleSettingsItem(
                title: context.l10n.settingsSendFeedback,
                subtitle: context.l10n.settingsSendFeedbackSubtitle,
                icon: Icons.feedback,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: فتح نموذج الملاحظات
                },
              ),

              const SizedBox(height: 16),

              // معلومات التطوير
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      context.l10n.settingsDevelopedBy,
                      style: context.theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      context.l10n.settingsCopyright,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// تحديث إعداد واحد
  void _updateSetting(String key, dynamic value) {
    ref.read(settingsProvider.notifier).updateSetting(key, value);
  }

  /// حفظ الإعدادات
  Future<void> _saveSettings() async {
    final result = await ref.read(settingsProvider.notifier).saveSettings();

    if (mounted) {
      if (result is SettingsSaveSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
          ),
        );
      } else if (result is SettingsSaveFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// معالجة إجراءات القائمة
  void _handleMenuAction(String action) {
    switch (action) {
      case 'reset':
        _showResetDialog();
        break;
      case 'export':
        _exportSettings();
        break;
      case 'import':
        _importSettings();
        break;
    }
  }

  /// عرض حوار إعادة التعيين
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.settingsResetDialogTitle),
        content: Text(context.l10n.settingsResetDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.commonCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(settingsProvider.notifier).resetToDefaults();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.settingsResetSuccess)),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.settingsReset),
          ),
        ],
      ),
    );
  }

  /// تصدير الإعدادات
  Future<void> _exportSettings() async {
    try {
      final settingsJson = await ref
          .read(settingsProvider.notifier)
          .exportSettings();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.settingsExportDialogTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.settingsExportSuccess),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    settingsJson,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.settingsOK),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.settingsExportError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// استيراد الإعدادات
  void _importSettings() {
    // TODO: تطبيق استيراد الإعدادات من ملف
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.settingsImportFeature)));
  }

  /// عرض حوار حذف البيانات
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.settingsDeleteDialogTitle),
        content: Text(context.l10n.settingsDeleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.commonCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: تطبيق حذف البيانات
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.settingsDeleteSuccess)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.settingsDeleteButton),
          ),
        ],
      ),
    );
  }

  /// الحصول على تسمية نمط الرد من الترجمة
  String _getResponseStyleLabel(BuildContext context, ResponseStyle style) {
    switch (style) {
      case ResponseStyle.detailed:
        return context.l10n.responseStyleDetailed;
      case ResponseStyle.concise:
        return context.l10n.responseStyleConcise;
      case ResponseStyle.balanced:
        return context.l10n.responseStyleBalanced;
    }
  }

  /// الحصول على تسمية نموذج الذكاء الاصطناعي من الترجمة
  String _getAIModelLabel(BuildContext context, AIModel model) {
    switch (model) {
      case AIModel.gpt4:
        return context.l10n.aiModelGPT4;
      case AIModel.gpt35:
        return context.l10n.aiModelGPT35;
      case AIModel.claude:
        return context.l10n.aiModelClaude;
    }
  }

  /// الحصول على تسمية تكرار النسخ الاحتياطي من الترجمة
  String _getBackupFrequencyLabel(BuildContext context, BackupFrequency freq) {
    switch (freq) {
      case BackupFrequency.never:
        return context.l10n.backupFrequencyNever;
      case BackupFrequency.daily:
        return context.l10n.backupFrequencyDaily;
      case BackupFrequency.weekly:
        return context.l10n.backupFrequencyWeekly;
      case BackupFrequency.monthly:
        return context.l10n.backupFrequencyMonthly;
    }
  }
}

/// مؤشر تاب مخصص بعرض ثابت
class _CustomTabIndicator extends Decoration {
  final Color color;
  final BorderRadius borderRadius;
  final double indicatorWidth;

  const _CustomTabIndicator({
    required this.color,
    required this.borderRadius,
    required this.indicatorWidth,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(
      color: color,
      borderRadius: borderRadius,
      indicatorWidth: indicatorWidth,
      onChanged: onChanged,
    );
  }
}

/// رسام المؤشر المخصص
class _CustomTabIndicatorPainter extends BoxPainter {
  final Color color;
  final BorderRadius borderRadius;
  final double indicatorWidth;

  _CustomTabIndicatorPainter({
    required this.color,
    required this.borderRadius,
    required this.indicatorWidth,
    VoidCallback? onChanged,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size size = configuration.size!;

    // حساب موقع المؤشر في المنتصف
    final double indicatorLeft = offset.dx + (size.width - indicatorWidth) / 2;
    final double indicatorTop = offset.dy + 8; // مسافة من الأعلى
    final double indicatorBottom =
        offset.dy + size.height - 8; // مسافة من الأسفل

    final Rect rect = Rect.fromLTRB(
      indicatorLeft,
      indicatorTop,
      indicatorLeft + indicatorWidth,
      indicatorBottom,
    );

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ),
      paint,
    );
  }
}
