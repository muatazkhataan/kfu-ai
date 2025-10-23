import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/help/presentation/screens/help_screen.dart';
import '../../features/chat/presentation/providers/chat_provider.dart';
import '../../features/chat/presentation/widgets/recent_chats_widget.dart';
import '../theme/icons.dart';
import '../extensions/context_extensions.dart';

/// القائمة الجانبية الرئيسية للتطبيق
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final authState = ref.watch(authProvider);
    final userName = authState.loginResponse?.profile?['fullName'] ?? 'مستخدم';
    final userId = authState.userId ?? '';

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      width: 320,
      child: SafeArea(
        child: Column(
          children: [
            // رأس القائمة مع الشعار
            _buildHeader(theme),

            // معلومات المستخدم
            _buildUserInfo(context, theme, userName, userId, ref),

            // أزرار البحث والمحادثة الجديدة
            _buildActionButtons(context, theme, ref),

            // المحتوى القابل للتمرير
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قسم المجلدات
                    _buildFoldersSection(context, theme),

                    // قسم المحادثات الأخيرة
                    _buildRecentChatsSection(context, theme, ref),
                  ],
                ),
              ),
            ),

            // تذييل القائمة الجانبية
            _buildFooter(context, theme),
          ],
        ),
      ),
    );
  }

  /// رأس القائمة مع الشعار
  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withAlpha(25),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/images/mosa3ed_kfu_icon_app.jpg',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'مساعد كفو',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// معلومات المستخدم وزر الخروج
  Widget _buildUserInfo(
    BuildContext context,
    ThemeData theme,
    String userName,
    String userId,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.colorScheme.secondary),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary,
            child: Icon(
              AppIcons.getIcon(AppIcon.user),
              size: 20,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  userId.isNotEmpty ? 'ID: ${userId.substring(0, 8)}...' : '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Scaffold(
                      body: Center(child: Text('تم تسجيل الخروج')),
                    ),
                  ),
                );
              }
            },
            icon: Icon(
              AppIcons.getIcon(AppIcon.signOut),
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
    );
  }

  /// أزرار البحث والمحادثة الجديدة
  Widget _buildActionButtons(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        children: [
          // زر محادثة جديدة
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ref.read(chatProvider.notifier).createNewChat();
              },
              icon: Icon(AppIcons.getIcon(AppIcon.plus), size: 16),
              label: const Text('محادثة جديدة'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // زر البحث - هذا هو المهم!
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              icon: Icon(AppIcons.getIcon(AppIcon.search), size: 16),
              label: const Text('بحث في المحادثات'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// قسم المجلدات
  Widget _buildFoldersSection(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.folder),
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'المجلدات',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // TODO: إضافة مجلد جديد
                  },
                  icon: Icon(
                    AppIcons.getIcon(AppIcon.plus),
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _buildFolderList(context, theme),
        ],
      ),
    );
  }

  /// قسم المحادثات الأخيرة
  Widget _buildRecentChatsSection(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(25),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.chat),
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'المحادثات الأخيرة',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // TODO: تحديث المحادثات
                  },
                  icon: Icon(
                    AppIcons.getIcon(AppIcon.refresh),
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  tooltip: 'تحديث',
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _buildChatList(context, theme, ref),
        ],
      ),
    );
  }

  /// تذييل القائمة الجانبية
  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withAlpha(25),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildFooterMenuItem(
            theme,
            icon: AppIcons.getIcon(AppIcon.settings),
            title: 'الإعدادات',
            onTap: () {
              Navigator.pop(context);
              // TODO: فتح الإعدادات
            },
          ),
          const SizedBox(height: 4),
          _buildFooterMenuItem(
            theme,
            icon: AppIcons.getIcon(AppIcon.help),
            title: 'المساعدة',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  /// عنصر في تذييل القائمة الجانبية
  Widget _buildFooterMenuItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// قائمة المجلدات
  Widget _buildFolderList(BuildContext context, ThemeData theme) {
    final folders = [
      {'name': 'جميع المحادثات', 'icon': AppIcon.inbox, 'count': '4'},
      {'name': 'البرمجة', 'icon': AppIcon.code, 'count': '1'},
      {'name': 'هياكل البيانات', 'icon': AppIcon.sitemap, 'count': '1'},
      {
        'name': 'الشؤون الأكاديمية',
        'icon': AppIcon.graduationCap,
        'count': '2',
      },
    ];

    return Column(
      children: folders.map((folder) {
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          leading: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              AppIcons.getIcon(folder['icon'] as AppIcon),
              size: 14,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            folder['name'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              folder['count'] as String,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            // TODO: اختيار المجلد
          },
        );
      }).toList(),
    );
  }

  /// قائمة المحادثات
  Widget _buildChatList(BuildContext context, ThemeData theme, WidgetRef ref) {
    return SizedBox(
      height: 300,
      child: RecentChatsWidget(
        selectedSessionId: null, // لا يوجد محادثة محددة في القائمة الجانبية
        onSessionSelected: (sessionId) {
          print('🔥🔥🔥 تم اختيار المحادثة من AppDrawer: $sessionId 🔥🔥🔥');
          Navigator.pop(context);
          // تحميل المحادثة المحددة
          ref.read(chatProvider.notifier).loadChat(sessionId);
          print('✅ تم استدعاء loadChat للمحادثة: $sessionId');
        },
        showRefreshButton: false,
      ),
    );
  }
}
