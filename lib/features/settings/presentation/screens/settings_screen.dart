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
      title: const Text('الإعدادات'),
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
            tooltip: 'حفظ الإعدادات',
          ),

        // قائمة إضافية
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'reset',
              child: Row(
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 8),
                  Text('إعادة تعيين'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.file_download),
                  SizedBox(width: 8),
                  Text('تصدير'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'import',
              child: Row(
                children: [
                  Icon(Icons.file_upload),
                  SizedBox(width: 8),
                  Text('استيراد'),
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
    final tabLabels = [
      'الإعدادات العامة',
      'المظهر والتخصيص',
      'إعدادات المحادثة',
      'الخصوصية والأمان',
      'الإشعارات',
      'الذكاء الاصطناعي',
      'إدارة البيانات',
      'حول التطبيق',
    ];

    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        final currentIndex = _tabController.index;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SettingsCard(
            title: 'الإعدادات العامة',
            description: 'تخصيص الإعدادات الأساسية للتطبيق',
            icon: Icons.tune,
            children: [
              widgets.SettingsItem(
                title: 'اللغة الافتراضية',
                subtitle: 'اختر اللغة التي تريد استخدامها في التطبيق',
                icon: Icons.language,
                type: SettingsItemType.dropdown,
                value: settings.defaultLanguage,
                options: {
                  'items': [
                    const DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    const DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                },
                onChanged: (value) => _updateSetting('defaultLanguage', value),
              ),

              widgets.SettingsItem(
                title: 'المنطقة الزمنية',
                subtitle: 'اختر المنطقة الزمنية الخاصة بك',
                icon: Icons.access_time,
                type: SettingsItemType.dropdown,
                value: settings.timezone,
                options: {
                  'items': [
                    const DropdownMenuItem(
                      value: 'Asia/Riyadh',
                      child: Text('الرياض (GMT+3)'),
                    ),
                    const DropdownMenuItem(
                      value: 'Asia/Dubai',
                      child: Text('دبي (GMT+4)'),
                    ),
                    const DropdownMenuItem(
                      value: 'Asia/Kuwait',
                      child: Text('الكويت (GMT+3)'),
                    ),
                  ],
                },
                onChanged: (value) => _updateSetting('timezone', value),
              ),

              widgets.SettingsItem(
                title: 'الوضع التجريبي',
                subtitle: 'الوصول إلى الميزات الجديدة قبل إطلاقها الرسمي',
                icon: Icons.science,
                type: SettingsItemType.toggle,
                value: settings.betaMode,
                onChanged: (value) => _updateSetting('betaMode', value),
              ),

              widgets.SettingsItem(
                title: 'التحديث التلقائي',
                subtitle: 'تحديث التطبيق تلقائياً عند توفر إصدارات جديدة',
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SettingsCard(
            title: 'إعدادات المظهر',
            description: 'تخصيص مظهر التطبيق حسب تفضيلاتك',
            icon: Icons.palette,
            accentColor: Colors.purple,
            children: [
              // محدد المظهر
              ThemeSelector(
                selectedMode: settings.themeMode,
                onChanged: (mode) => _updateSetting('themeMode', mode),
              ),

              const SizedBox(height: 24),

              // محدد حجم الخط
              FontSizeSelector(
                selectedSize: settings.fontSize,
                onChanged: (size) => _updateSetting('fontSize', size),
              ),

              const SizedBox(height: 24),

              widgets.SettingsItem(
                title: 'الرسوم المتحركة',
                subtitle: 'إظهار الرسوم المتحركة والانتقالات',
                icon: Icons.animation,
                type: SettingsItemType.toggle,
                value: settings.animationsEnabled,
                onChanged: (value) =>
                    _updateSetting('animationsEnabled', value),
              ),

              widgets.SettingsItem(
                title: 'اللمس الاهتزازي',
                subtitle: 'اهتزاز خفيف عند التفاعل',
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SettingsCard(
            title: 'إعدادات المحادثة',
            description: 'تخصيص تجربة المحادثة مع المساعد الذكي',
            icon: Icons.chat_bubble,
            accentColor: Colors.green,
            children: [
              widgets.SettingsItem(
                title: 'نمط الرد',
                subtitle: 'اختر كيفية رد المساعد على أسئلتك',
                icon: Icons.chat,
                type: SettingsItemType.dropdown,
                value: settings.responseStyle,
                options: {
                  'items': ResponseStyle.values.map((style) {
                    return DropdownMenuItem(
                      value: style,
                      child: Text(style.label),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('responseStyle', value),
              ),

              widgets.SettingsItem(
                title: 'الحد الأقصى للرسائل',
                subtitle: 'عدد الرسائل المحفوظة في المحادثة الواحدة',
                icon: Icons.format_list_numbered,
                type: SettingsItemType.dropdown,
                value: settings.maxMessages,
                options: {
                  'items': [50, 100, 200, 500].map((count) {
                    return DropdownMenuItem(
                      value: count,
                      child: Text('$count رسالة'),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('maxMessages', value),
              ),

              widgets.SettingsItem(
                title: 'الرد التلقائي',
                subtitle: 'السماح للمساعد بالرد تلقائياً على بعض الأسئلة',
                icon: Icons.auto_fix_high,
                type: SettingsItemType.toggle,
                value: settings.autoResponse,
                onChanged: (value) => _updateSetting('autoResponse', value),
              ),

              widgets.SettingsItem(
                title: 'اقتراحات المحادثة',
                subtitle: 'إظهار اقتراحات للأسئلة التالية',
                icon: Icons.lightbulb_outline,
                type: SettingsItemType.toggle,
                value: settings.showSuggestions,
                onChanged: (value) => _updateSetting('showSuggestions', value),
              ),

              widgets.SettingsItem(
                title: 'التصحيح التلقائي',
                subtitle: 'تصحيح الأخطاء الإملائية تلقائياً',
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SettingsCard(
            title: 'إعدادات الخصوصية',
            description: 'التحكم في خصوصية بياناتك ومعلوماتك',
            icon: Icons.shield,
            accentColor: Colors.orange,
            children: [
              widgets.SettingsItem(
                title: 'جمع البيانات التحليلية',
                subtitle: 'السماح بجمع بيانات الاستخدام لتحسين التطبيق',
                icon: Icons.analytics,
                type: SettingsItemType.toggle,
                value: settings.analytics,
                onChanged: (value) => _updateSetting('analytics', value),
              ),

              widgets.SettingsItem(
                title: 'حفظ سجل المحادثات',
                subtitle: 'حفظ المحادثات محلياً على جهازك',
                icon: Icons.history,
                type: SettingsItemType.toggle,
                value: settings.saveChatHistory,
                onChanged: (value) => _updateSetting('saveChatHistory', value),
              ),

              widgets.SettingsItem(
                title: 'مشاركة المحادثات',
                subtitle: 'السماح بمشاركة المحادثات مع الآخرين',
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SettingsCard(
            title: 'إعدادات الإشعارات',
            description: 'تخصيص الإشعارات والتنبيهات',
            icon: Icons.notifications,
            accentColor: Colors.blue,
            children: [
              widgets.SettingsItem(
                title: 'تفعيل الإشعارات',
                subtitle: 'استلام إشعارات من التطبيق',
                icon: Icons.notifications_active,
                type: SettingsItemType.toggle,
                value: settings.enableNotifications,
                onChanged: (value) =>
                    _updateSetting('enableNotifications', value),
              ),

              widgets.SettingsItem(
                title: 'إشعارات التحديثات',
                subtitle: 'إشعارات عند توفر تحديثات جديدة',
                icon: Icons.system_update_alt,
                type: SettingsItemType.toggle,
                value: settings.updateNotifications,
                onChanged: (value) =>
                    _updateSetting('updateNotifications', value),
              ),

              widgets.SettingsItem(
                title: 'إشعارات الميزات الجديدة',
                subtitle: 'إشعارات عند إضافة ميزات جديدة',
                icon: Icons.new_releases,
                type: SettingsItemType.toggle,
                value: settings.featureNotifications,
                onChanged: (value) =>
                    _updateSetting('featureNotifications', value),
              ),

              widgets.SettingsItem(
                title: 'صوت الإشعارات',
                subtitle: 'تشغيل صوت عند استلام إشعارات',
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SettingsCard(
            title: 'إعدادات الذكاء الاصطناعي',
            description: 'تخصيص سلوك المساعد الذكي',
            icon: Icons.psychology,
            accentColor: Colors.deepPurple,
            children: [
              widgets.SettingsItem(
                title: 'نموذج الذكاء الاصطناعي',
                subtitle: 'اختر النموذج المستخدم للمساعد',
                icon: Icons.memory,
                type: SettingsItemType.dropdown,
                value: settings.aiModel,
                options: {
                  'items': AIModel.values.map((model) {
                    return DropdownMenuItem(
                      value: model,
                      child: Text(model.label),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('aiModel', value),
              ),

              const SizedBox(height: 16),

              // شريط الإبداع
              CreativitySlider(
                value: settings.creativityLevel,
                onChanged: (value) => _updateSetting('creativityLevel', value),
              ),

              const SizedBox(height: 16),

              widgets.SettingsItem(
                title: 'السياق المحفوظ',
                subtitle: 'عدد الرسائل المحفوظة للسياق',
                icon: Icons.history_edu,
                type: SettingsItemType.dropdown,
                value: settings.contextLength,
                options: {
                  'items': [5, 10, 20, 50].map((count) {
                    return DropdownMenuItem(
                      value: count,
                      child: Text('$count رسائل'),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('contextLength', value),
              ),

              widgets.SettingsItem(
                title: 'التعلم التكيفي',
                subtitle: 'تحسين الردود بناءً على تفضيلاتك',
                icon: Icons.school,
                type: SettingsItemType.toggle,
                value: settings.adaptiveLearning,
                onChanged: (value) => _updateSetting('adaptiveLearning', value),
              ),

              widgets.SettingsItem(
                title: 'الميزات التجريبية للذكاء الاصطناعي',
                subtitle: 'تجربة ميزات جديدة في الذكاء الاصطناعي',
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SettingsCard(
            title: 'البيانات والنسخ الاحتياطية',
            description: 'إدارة البيانات والنسخ الاحتياطية',
            icon: Icons.storage,
            accentColor: Colors.teal,
            children: [
              widgets.SettingsItem(
                title: 'النسخ الاحتياطي التلقائي',
                subtitle: 'إنشاء نسخ احتياطية تلقائياً',
                icon: Icons.backup,
                type: SettingsItemType.toggle,
                value: settings.autoBackup,
                onChanged: (value) => _updateSetting('autoBackup', value),
              ),

              widgets.SettingsItem(
                title: 'تكرار النسخ الاحتياطي',
                subtitle: 'متى يتم إنشاء النسخ الاحتياطية',
                icon: Icons.schedule,
                type: SettingsItemType.dropdown,
                value: settings.backupFrequency,
                options: {
                  'items': BackupFrequency.values.map((freq) {
                    return DropdownMenuItem(
                      value: freq,
                      child: Text(freq.label),
                    );
                  }).toList(),
                },
                onChanged: (value) => _updateSetting('backupFrequency', value),
              ),

              // معلومات الاستخدام
              usageInfoAsync.when(
                data: (usageInfo) => _buildStorageInfo(usageInfo),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('خطأ: $error'),
              ),

              const SizedBox(height: 16),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _exportSettings,
                      icon: const Icon(Icons.file_download),
                      label: const Text('تصدير البيانات'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showDeleteDialog,
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('حذف جميع البيانات'),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'مساحة التخزين المستخدمة',
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
                  'المحادثات',
                  usageInfo.totalChats.toString(),
                  Icons.chat,
                ),
              ),
              Expanded(
                child: _buildStorageStat(
                  'الرسائل',
                  usageInfo.totalMessages.toString(),
                  Icons.message,
                ),
              ),
              Expanded(
                child: _buildStorageStat(
                  'آخر نسخة',
                  usageInfo.lastBackup != null
                      ? '${usageInfo.lastBackup!.day}/${usageInfo.lastBackup!.month}'
                      : 'لا توجد',
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SettingsCard(
            title: 'حول التطبيق',
            description: 'معلومات عن التطبيق والإصدار',
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
                      'مساعد كفو',
                      style: context.theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'الإصدار ${settings.version}',
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'مساعد ذكي لطلبة جامعة الملك فيصل، مصمم لمساعدتك في الشؤون الأكاديمية والدراسية.',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              widgets.SimpleSettingsItem(
                title: 'سياسة الخصوصية',
                subtitle: 'اقرأ سياسة الخصوصية',
                icon: Icons.policy,
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // TODO: فتح سياسة الخصوصية
                },
              ),

              widgets.SimpleSettingsItem(
                title: 'شروط الاستخدام',
                subtitle: 'اقرأ شروط الاستخدام',
                icon: Icons.description,
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // TODO: فتح شروط الاستخدام
                },
              ),

              widgets.SimpleSettingsItem(
                title: 'المساعدة والدعم',
                subtitle: 'احصل على المساعدة',
                icon: Icons.help_outline,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: فتح صفحة المساعدة
                },
              ),

              widgets.SimpleSettingsItem(
                title: 'إرسال ملاحظات',
                subtitle: 'ساعدنا في تحسين التطبيق',
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
                      'تم التطوير بواسطة فريق جامعة الملك فيصل',
                      style: context.theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'جميع الحقوق محفوظة © 2024',
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
        title: const Text('إعادة تعيين الإعدادات'),
        content: const Text(
          'هل أنت متأكد من إعادة تعيين جميع الإعدادات إلى القيم الافتراضية؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(settingsProvider.notifier).resetToDefaults();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إعادة تعيين الإعدادات')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('إعادة تعيين'),
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
            title: const Text('تصدير الإعدادات'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('تم تصدير الإعدادات بنجاح:'),
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
                child: const Text('موافق'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في التصدير: $e'),
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
    ).showSnackBar(const SnackBar(content: Text('ميزة الاستيراد قيد التطوير')));
  }

  /// عرض حوار حذف البيانات
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف جميع البيانات'),
        content: const Text(
          'هل أنت متأكد من حذف جميع البيانات؟ هذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: تطبيق حذف البيانات
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف جميع البيانات')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
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
