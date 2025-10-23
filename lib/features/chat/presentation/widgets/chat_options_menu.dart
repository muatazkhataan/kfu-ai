import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/extensions/context_extensions.dart';

/// قائمة خيارات المحادثة
class ChatOptionsMenu extends ConsumerWidget {
  final String sessionId;
  final String sessionTitle;
  final bool isArchived;

  const ChatOptionsMenu({
    super.key,
    required this.sessionId,
    required this.sessionTitle,
    this.isArchived = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: Icon(AppIcons.getIcon(AppIcon.ellipsisV)),
      onSelected: (value) => _handleAction(value, context, ref),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'rename',
          child: Row(
            children: [
              Icon(AppIcons.getIcon(AppIcon.edit), size: 18),
              const SizedBox(width: 12),
              const Text('تعديل العنوان'),
            ],
          ),
        ),
        if (!isArchived)
          PopupMenuItem(
            value: 'archive',
            child: Row(
              children: [
                Icon(AppIcons.getIcon(AppIcon.archive), size: 18),
                const SizedBox(width: 12),
                const Text('أرشفة'),
              ],
            ),
          )
        else
          PopupMenuItem(
            value: 'restore',
            child: Row(
              children: [
                Icon(AppIcons.getIcon(AppIcon.archive), size: 18),
                const SizedBox(width: 12),
                const Text('استعادة'),
              ],
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                AppIcons.getIcon(AppIcon.delete),
                size: 18,
                color: context.colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text('حذف', style: TextStyle(color: context.colorScheme.error)),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAction(String action, BuildContext context, WidgetRef ref) {
    switch (action) {
      case 'rename':
        _showRenameDialog(context, ref);
        break;
      case 'archive':
        // TODO: Call archive function
        _showSnackBar(context, 'تم الأرشفة');
        break;
      case 'restore':
        // TODO: Call restore function
        _showSnackBar(context, 'تم الاستعادة');
        break;
      case 'delete':
        _showDeleteDialog(context, ref);
        break;
    }
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: sessionTitle);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل العنوان'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'العنوان الجديد',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Call update title function
              Navigator.pop(context);
              _showSnackBar(context, 'تم تحديث العنوان');
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المحادثة'),
        content: const Text(
          'هل أنت متأكد من حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Call delete function
              Navigator.pop(context);
              _showSnackBar(context, 'تم الحذف');
            },
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
