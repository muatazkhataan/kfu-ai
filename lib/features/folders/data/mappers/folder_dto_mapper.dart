import '../../domain/models/folder.dart';
import '../../domain/models/folder_icon.dart';
import '../../domain/models/folder_type.dart';
import '../../../../services/api/folder/models/folder_dto.dart';
import '../../../../core/theme/icons.dart';

/// محول FolderDto إلى Folder
class FolderDtoMapper {
  /// تحويل FolderDto إلى Folder
  static Folder toDomain(FolderDto dto) {
    // استخراج البيانات من metadata
    final metadata = dto.metadata ?? {};
    final color = metadata['color'] as String?;
    final isFixed = metadata['isFixed'] as bool? ?? false;

    // استخراج معرف الأيقونة من Icon (FontAwesome string) أو iconClass
    final iconString = dto.icon ?? metadata['iconClass'];
    FolderIcon folderIcon;

    if (iconString != null && iconString.isNotEmpty) {
      // محاولة تحويل FontAwesome string إلى AppIcon
      final appIcon = AppIcons.fromFontAwesomeClass(iconString);
      
      if (appIcon != null) {
        // البحث عن FolderIcon باستخدام AppIcon
        folderIcon = FolderIconManager.getIconByAppIcon(appIcon) ??
            FolderIconManager.getIconById('folder_general')!;
      } else {
        // إذا فشل التحويل، حاول البحث باستخدام iconString مباشرة
        folderIcon = FolderIconManager.getIconById(iconString) ??
            FolderIconManager.getIconById('folder_general')!;
      }
    } else {
      // استخدام الأيقونة الافتراضية
      folderIcon = FolderIconManager.getIconById('folder_general')!;
    }

    // تحديد نوع المجلد
    final folderType = isFixed ? FolderType.fixed : FolderType.custom;

    return Folder(
      id: dto.folderId,
      name: dto.name,
      userId: 'current_user', // TODO: الحصول من Auth Service
      type: folderType,
      icon: folderIcon,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      chatCount: dto.chatCount,
      color: color,
      metadata: dto.metadata,
    );
  }

  /// تحويل قائمة FolderDto إلى قائمة Folder
  static List<Folder> toDomainList(List<FolderDto> dtos) {
    return dtos.map((dto) => toDomain(dto)).toList();
  }

  /// تحويل Folder إلى FolderDto (للاستخدام في الطلبات)
  static FolderDto toDto(Folder folder) {
    // تحويل AppIcon إلى FontAwesome string للإرسال إلى API
    final iconString = AppIcons.toFontAwesomeClass(
      folder.icon.icon,
      style: 'fas', // استخدام solid كافتراضي
    );
    
    return FolderDto(
      folderId: folder.id,
      name: folder.name,
      icon: iconString,
      chatCount: folder.chatCount,
      createdAt: folder.createdAt,
      updatedAt: folder.updatedAt,
      metadata: {
        ...?folder.metadata,
        'iconClass': iconString,
        'color': folder.color,
        'isFixed': folder.isFixed,
      },
    );
  }
}

