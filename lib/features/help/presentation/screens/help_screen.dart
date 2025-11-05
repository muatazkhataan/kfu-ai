import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';

/// Help screen widget
class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(theme),

          // Help content
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildHelpSections(theme)
                : _buildSearchResults(theme),
          ),
        ],
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'البحث في المساعدة...',
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  /// Build help sections
  Widget _buildHelpSections(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Start
          _buildHelpSection(
            theme: theme,
            title: context.l10n.helpQuickStart,
            icon: Icons.rocket_launch,
            items: [
              _buildHelpItem(
                theme: theme,
                title: 'كيفية بدء المحادثة',
                content: 'اضغط على زر المحادثة الجديدة وابدأ في كتابة سؤالك.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'استخدام الاقتراحات',
                content: 'استخدم الأزرار المقترحة للبدء السريع في المحادثة.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'إدارة المجلدات',
                content: 'أنشئ مجلدات لتنظيم محادثاتك حسب المواضيع.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Features
          _buildHelpSection(
            theme: theme,
            title: context.l10n.helpFeatures,
            icon: Icons.star,
            items: [
              _buildHelpItem(
                theme: theme,
                title: 'المحادثات الذكية',
                content: 'احصل على إجابات دقيقة ومفصلة لأسئلتك الأكاديمية.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'تنظيم المحادثات',
                content: 'نظم محادثاتك في مجلدات مختلفة حسب الموضوع.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'البحث المتقدم',
                content: 'ابحث في محادثاتك السابقة بسهولة وسرعة.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'المشاركة والتصدير',
                content: 'شارك محادثاتك أو صدرها بصيغ مختلفة.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Chat Guide
          _buildHelpSection(
            theme: theme,
            title: context.l10n.helpChatGuide,
            icon: Icons.chat_bubble_outline,
            items: [
              _buildHelpItem(
                theme: theme,
                title: 'كتابة الرسائل',
                content: 'اكتب أسئلتك بوضوح واختر الكلمات المناسبة.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'إرفاق الملفات',
                content: 'يمكنك إرفاق الصور والملفات لشرح أسئلتك.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'الردود المخصصة',
                content: 'اختر نمط الرد المناسب من الإعدادات.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Folders Guide
          _buildHelpSection(
            theme: theme,
            title: context.l10n.helpFoldersGuide,
            icon: Icons.folder_outlined,
            items: [
              _buildHelpItem(
                theme: theme,
                title: 'إنشاء مجلد جديد',
                content: 'اضغط على زر + في قسم المجلدات لإنشاء مجلد جديد.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'تغيير أيقونة المجلد',
                content: 'اضغط مطولاً على المجلد واختر "تغيير الأيقونة".',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'نقل المحادثات',
                content: 'اسحب المحادثة إلى المجلد المطلوب أو استخدم القائمة.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Settings Guide
          _buildHelpSection(
            theme: theme,
            title: context.l10n.helpSettingsGuide,
            icon: Icons.settings_outlined,
            items: [
              _buildHelpItem(
                theme: theme,
                title: 'تغيير اللغة',
                content: 'انتقل إلى الإعدادات > اللغة لاختيار اللغة المناسبة.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'تغيير السمة',
                content: 'اختر بين السمة الفاتحة أو الداكنة حسب تفضيلك.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'حجم الخط',
                content: 'اضبط حجم الخط ليكون مناسباً لقراءتك.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // FAQ
          _buildHelpSection(
            theme: theme,
            title: context.l10n.helpFAQ,
            icon: Icons.help_outline,
            items: [
              _buildHelpItem(
                theme: theme,
                title: 'هل يمكنني استخدام التطبيق بدون إنترنت؟',
                content:
                    'نعم، يمكنك استخدام التطبيق لقراءة المحادثات السابقة بدون إنترنت.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'كيف يمكنني نسخ احتياطي لبياناتي؟',
                content: 'انتقل إلى الإعدادات > البيانات > النسخ الاحتياطي.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'هل يمكنني تغيير لغة التطبيق؟',
                content:
                    'نعم، يمكنك التبديل بين العربية والإنجليزية من الإعدادات.',
              ),
              _buildHelpItem(
                theme: theme,
                title: 'كيف يمكنني إرسال ملاحظة أو اقتراح؟',
                content: 'استخدم قسم "إرسال ملاحظات" في القائمة الجانبية.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build search results
  Widget _buildSearchResults(ThemeData theme) {
    // TODO: Implement actual search functionality
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'نتائج البحث: "$_searchQuery"',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم تنفيذ البحث قريباً',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build help section
  Widget _buildHelpSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  /// Build help item
  Widget _buildHelpItem({
    required ThemeData theme,
    required String title,
    required String content,
  }) {
    return ExpansionTile(
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            content,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
