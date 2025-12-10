import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/folder.dart';
import '../../domain/usecases/get_folder_chats_usecase.dart';
import '../../data/providers/folder_repository_provider.dart';
import '../widgets/folder_chat_list_widget.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/localization/l10n.dart';
import '../../../../services/api/chat/models/session_dto.dart';
import '../../../../features/chat/presentation/providers/chat_provider.dart';

/// شاشة محتوى المجلد
///
/// تعرض محادثات المجلد
class FolderContentScreen extends ConsumerStatefulWidget {
  final Folder folder;

  const FolderContentScreen({
    super.key,
    required this.folder,
  });

  @override
  ConsumerState<FolderContentScreen> createState() => _FolderContentScreenState();
}

class _FolderContentScreenState extends ConsumerState<FolderContentScreen> {
  List<SessionDto> _chats = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFolderChats();
  }

  Future<void> _loadFolderChats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final useCase = GetFolderChatsUseCase(
        ref.read(folderRepositoryProvider),
      );
      final chats = await useCase(widget.folder.id);
      
      // تحويل dynamic إلى SessionDto (البيانات بالفعل List<SessionDto> من API)
      final sessionDtos = chats
          .map((chat) => chat as SessionDto)
          .toList();
      
      setState(() {
        _chats = sessionDtos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getFolderColor(theme),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.folder.icon.iconData,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.folder.name,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (widget.folder.description != null)
                    Text(
                      widget.folder.description!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(AppIcons.getIcon(AppIcon.refresh)),
            onPressed: _loadFolderChats,
            tooltip: context.l10n.chatHistoryRefresh,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState(context, theme)
              : _chats.isEmpty
                  ? _buildEmptyState(context, theme)
                  : _buildChatsList(context, theme),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.exclamationTriangle),
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadFolderChats,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.getIcon(AppIcon.comments),
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد محادثات',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'هذا المجلد فارغ حالياً',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(BuildContext context, ThemeData theme) {
    return FolderChatListWidget(
      chats: _chats,
      onChatTap: (chat) {
        final sessionId = chat.sessionId;
        if (sessionId.isNotEmpty) {
          // إغلاق الشاشة الحالية والعودة للشاشة السابقة
          Navigator.pop(context);
          
          // تحميل المحادثة في ChatScreen
          // سيتم تحميلها حتى لو لم نكن في ChatScreen حالياً
          ref.read(chatProvider.notifier).loadChat(sessionId);
          
          // ignore: avoid_print
          print('✅ تم فتح المحادثة من FolderContentScreen: $sessionId');
        }
      },
      onChatDeletedOrMoved: () {
        // إعادة تحميل محادثات المجلد بعد الحذف أو النقل
        _loadFolderChats();
      },
    );
  }

  Color _getFolderColor(ThemeData theme) {
    if (widget.folder.color != null) {
      try {
        return Color(int.parse(widget.folder.color!.replaceAll('#', '0xFF')));
      } catch (e) {
        return theme.colorScheme.primary;
      }
    }
    return theme.colorScheme.primary;
  }

}

