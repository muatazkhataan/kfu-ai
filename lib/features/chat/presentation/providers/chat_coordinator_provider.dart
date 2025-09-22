import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/chat_status.dart';
import '../../../folders/domain/models/folder_icon.dart';
import 'chat_provider.dart';
import '../../../folders/presentation/providers/folder_provider.dart';
import '../../../chat_history/presentation/providers/chat_history_provider.dart';

/// مزود تنسيق العمليات المشتركة
///
/// يدير العمليات التي تتطلب تنسيق بين مزودي المحادثة والمجلدات والسجل
class ChatCoordinatorNotifier extends StateNotifier<void> {
  ChatCoordinatorNotifier(this.ref) : super(null);

  final Ref ref;

  /// إنشاء محادثة جديدة في مجلد محدد
  Future<Chat?> createChatInFolder({
    String? title,
    String? description,
    String? folderId,
  }) async {
    try {
      // التحقق من وجود المجلد إذا تم تحديده
      if (folderId != null) {
        final folderState = ref.read(folderProvider);
        final folder = folderState.getFolderById(folderId);
        if (folder == null) {
          throw Exception('المجلد المحدد غير موجود');
        }
      }

      // إنشاء المحادثة
      final chat = Chat.create(
        title: title ?? 'محادثة جديدة',
        description: description,
        userId: 'user_123', // TODO: الحصول من مصدر المستخدم الحالي
        folderId: folderId,
      );

      // تحديث مزود المحادثة
      ref.read(chatProvider.notifier).state = ref
          .read(chatProvider)
          .copyWith(currentChat: chat);

      // إضافة للسجل
      await ref.read(chatHistoryProvider.notifier).addChat(chat);

      // تحديث عدد المحادثات في المجلد
      if (folderId != null) {
        final folderState = ref.read(folderProvider);
        final folder = folderState.getFolderById(folderId);
        if (folder != null) {
          await ref
              .read(folderProvider.notifier)
              .updateFolderChatCount(folderId, folder.chatCount + 1);
        }
      }

      return chat;
    } catch (e) {
      // TODO: معالجة الخطأ
      print('فشل في إنشاء محادثة في مجلد: ${e.toString()}');
      return null;
    }
  }

  /// نقل محادثة لمجلد آخر
  Future<void> moveChatToFolder(String chatId, String? newFolderId) async {
    try {
      // التحقق من وجود المجلد الجديد إذا تم تحديده
      if (newFolderId != null) {
        final folderState = ref.read(folderProvider);
        final folder = folderState.getFolderById(newFolderId);
        if (folder == null) {
          throw Exception('المجلد المحدد غير موجود');
        }
      }

      // الحصول على المحادثة الحالية
      final chatHistoryState = ref.read(chatHistoryProvider);
      final chat = chatHistoryState.getChatById(chatId);
      if (chat == null) {
        throw Exception('المحادثة غير موجودة');
      }

      final oldFolderId = chat.folderId;

      // تحديث المحادثة في مزود المحادثة إذا كانت نشطة
      final chatState = ref.read(chatProvider);
      if (chatState.currentChat?.id == chatId) {
        await ref.read(chatProvider.notifier).moveChatToFolder(newFolderId);
      }

      // تحديث المحادثة في السجل
      final updatedChat = chat.copyWith(
        folderId: newFolderId,
        updatedAt: DateTime.now(),
      );
      await ref.read(chatHistoryProvider.notifier).updateChat(updatedChat);

      // تحديث عدد المحادثات في المجلدات
      if (oldFolderId != null) {
        final folderState = ref.read(folderProvider);
        final oldFolder = folderState.getFolderById(oldFolderId);
        if (oldFolder != null) {
          await ref
              .read(folderProvider.notifier)
              .updateFolderChatCount(oldFolderId, oldFolder.chatCount - 1);
        }
      }

      if (newFolderId != null) {
        final folderState = ref.read(folderProvider);
        final newFolder = folderState.getFolderById(newFolderId);
        if (newFolder != null) {
          await ref
              .read(folderProvider.notifier)
              .updateFolderChatCount(newFolderId, newFolder.chatCount + 1);
        }
      }
    } catch (e) {
      // TODO: معالجة الخطأ
      print('فشل في نقل المحادثة: ${e.toString()}');
    }
  }

  /// حذف محادثة مع تحديث المجلد
  Future<void> deleteChat(String chatId) async {
    try {
      // الحصول على المحادثة
      final chatHistoryState = ref.read(chatHistoryProvider);
      final chat = chatHistoryState.getChatById(chatId);
      if (chat == null) {
        throw Exception('المحادثة غير موجودة');
      }

      // حذف المحادثة من مزود المحادثة إذا كانت نشطة
      final chatState = ref.read(chatProvider);
      if (chatState.currentChat?.id == chatId) {
        await ref.read(chatProvider.notifier).deleteChat();
      }

      // حذف من السجل
      await ref.read(chatHistoryProvider.notifier).deleteChat(chatId);

      // تحديث عدد المحادثات في المجلد
      if (chat.folderId != null) {
        final folderState = ref.read(folderProvider);
        final folder = folderState.getFolderById(chat.folderId!);
        if (folder != null) {
          await ref
              .read(folderProvider.notifier)
              .updateFolderChatCount(chat.folderId!, folder.chatCount - 1);
        }
      }
    } catch (e) {
      // TODO: معالجة الخطأ
      print('فشل في حذف المحادثة: ${e.toString()}');
    }
  }

  /// أرشفة محادثة مع تحديث المجلد
  Future<void> archiveChat(String chatId) async {
    try {
      // الحصول على المحادثة
      final chatHistoryState = ref.read(chatHistoryProvider);
      final chat = chatHistoryState.getChatById(chatId);
      if (chat == null) {
        throw Exception('المحادثة غير موجودة');
      }

      // أرشفة المحادثة في مزود المحادثة إذا كانت نشطة
      final chatState = ref.read(chatProvider);
      if (chatState.currentChat?.id == chatId) {
        await ref.read(chatProvider.notifier).archiveChat();
      }

      // أرشفة في السجل
      final updatedChat = chat.copyWith(
        status: ChatStatus.archived,
        updatedAt: DateTime.now(),
      );
      await ref.read(chatHistoryProvider.notifier).updateChat(updatedChat);

      // تحديث عدد المحادثات في المجلد
      if (chat.folderId != null) {
        final folderState = ref.read(folderProvider);
        final folder = folderState.getFolderById(chat.folderId!);
        if (folder != null) {
          await ref
              .read(folderProvider.notifier)
              .updateFolderChatCount(chat.folderId!, folder.chatCount - 1);
        }
      }
    } catch (e) {
      // TODO: معالجة الخطأ
      print('فشل في أرشفة المحادثة: ${e.toString()}');
    }
  }

  /// فتح محادثة من السجل
  Future<void> openChatFromHistory(String chatId) async {
    try {
      // الحصول على المحادثة من السجل
      final chatHistoryState = ref.read(chatHistoryProvider);
      final chat = chatHistoryState.getChatById(chatId);
      if (chat == null) {
        throw Exception('المحادثة غير موجودة');
      }

      // تحميل المحادثة في مزود المحادثة
      await ref.read(chatProvider.notifier).loadChat(chatId);

      // تحديث آخر نشاط في المجلد
      if (chat.folderId != null) {
        await ref
            .read(folderProvider.notifier)
            .updateFolderLastActivity(chat.folderId!);
      }
    } catch (e) {
      // TODO: معالجة الخطأ
      print('فشل في فتح المحادثة: ${e.toString()}');
    }
  }

  /// إرسال رسالة مع تحديث السجل والمجلد
  Future<void> sendMessageWithUpdates(String content) async {
    try {
      // إرسال الرسالة
      await ref.read(chatProvider.notifier).sendMessage(content);

      // تحديث السجل مع معاينة الرسالة
      final chatState = ref.read(chatProvider);
      if (chatState.currentChat != null) {
        await ref
            .read(chatHistoryProvider.notifier)
            .updateChatAfterMessage(
              chatState.currentChat!.id,
              content.length > 50 ? '${content.substring(0, 50)}...' : content,
            );

        // تحديث آخر نشاط في المجلد
        if (chatState.currentChat!.folderId != null) {
          await ref
              .read(folderProvider.notifier)
              .updateFolderLastActivity(chatState.currentChat!.folderId!);
        }
      }
    } catch (e) {
      // TODO: معالجة الخطأ
      print('فشل في إرسال الرسالة مع التحديثات: ${e.toString()}');
    }
  }

  /// إنشاء مجلد جديد مع محادثة ترحيبية
  Future<void> createFolderWithWelcomeChat({
    required String folderName,
    String? description,
    FolderIcon? icon,
    String? color,
  }) async {
    try {
      // إنشاء المجلد
      await ref
          .read(folderProvider.notifier)
          .createFolder(
            name: folderName,
            description: description,
            icon: icon,
            color: color,
          );

      // الحصول على المجلد الجديد
      final folderState = ref.read(folderProvider);
      final newFolder = folderState.folders.firstWhere(
        (folder) => folder.name == folderName,
      );

      // إنشاء محادثة ترحيبية في المجلد
      await createChatInFolder(
        title: 'مرحباً بك في $folderName',
        description: 'هذه محادثة ترحيبية في مجلد $folderName',
        folderId: newFolder.id,
      );
    } catch (e) {
      // TODO: معالجة الخطأ
      print('فشل في إنشاء مجلد مع محادثة ترحيبية: ${e.toString()}');
    }
  }

  /// حذف مجلد مع نقل محادثاته
  Future<void> deleteFolderWithChats(
    String folderId,
    String? targetFolderId,
  ) async {
    try {
      // الحصول على المجلد
      final folderState = ref.read(folderProvider);
      final folder = folderState.getFolderById(folderId);
      if (folder == null) {
        throw Exception('المجلد غير موجود');
      }

      if (!folder.isDeletable) {
        throw Exception('لا يمكن حذف هذا المجلد');
      }

      // الحصول على محادثات المجلد
      final chatHistoryState = ref.read(chatHistoryProvider);
      final folderChats = chatHistoryState.getChatsByFolder(folderId);

      // نقل المحادثات للمجلد الهدف أو إلغاء ربطها
      if (folderChats.isNotEmpty) {
        final chatIds = folderChats.map((chat) => chat.id).toList();
        await ref
            .read(chatHistoryProvider.notifier)
            .moveChatsToFolder(targetFolderId ?? '', chatIds);
      }

      // حذف المجلد
      await ref.read(folderProvider.notifier).deleteFolder(folderId);
    } catch (e) {
      // TODO: معالجة الخطأ
      print('فشل في حذف المجلد مع المحادثات: ${e.toString()}');
    }
  }

  /// إعادة تحميل جميع البيانات
  Future<void> refreshAllData() async {
    try {
      // تحميل المجلدات
      await ref.read(folderProvider.notifier).refresh();

      // تحميل سجل المحادثات
      await ref.read(chatHistoryProvider.notifier).refresh();

      // إعادة تعيين مزود المحادثة
      ref.read(chatProvider.notifier).reset();
    } catch (e) {
      // TODO: معالجة الخطأ
      print('فشل في إعادة تحميل البيانات: ${e.toString()}');
    }
  }

  /// مسح جميع الأخطاء
  void clearAllErrors() {
    ref.read(chatProvider.notifier).clearErrors();
    ref.read(folderProvider.notifier).clearErrors();
    ref.read(chatHistoryProvider.notifier).clearErrors();
  }
}

/// مزود تنسيق العمليات المشتركة
final chatCoordinatorProvider =
    StateNotifierProvider<ChatCoordinatorNotifier, void>((ref) {
      return ChatCoordinatorNotifier(ref);
    });

/// مزود العمليات المشتركة (للاستخدام المباشر)
final chatOperationsProvider = Provider<ChatCoordinatorNotifier>((ref) {
  return ref.read(chatCoordinatorProvider.notifier);
});
