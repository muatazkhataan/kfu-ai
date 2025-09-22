import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// مساعد لإصلاح الأيقونات المفقودة
///
/// يوفر أيقونات بديلة للأيقونات المفقودة في AppIcon
class MissingIconsFix {
  /// الحصول على أيقونة بديلة للأيقونات المفقودة
  static IconData getAlternativeIcon(String iconName) {
    switch (iconName) {
      case 'message':
        return FontAwesomeIcons.comment;
      case 'magnifyingGlass':
        return FontAwesomeIcons.magnifyingGlass;
      case 'thumbtack':
        return FontAwesomeIcons.thumbtack;
      case 'ellipsisVertical':
        return FontAwesomeIcons.ellipsisVertical;
      case 'heart':
        return FontAwesomeIcons.heart;
      case 'paperclip':
        return FontAwesomeIcons.paperclip;
      case 'paperPlane':
        return FontAwesomeIcons.paperPlane;
      case 'robot':
        return FontAwesomeIcons.robot;
      case 'exclamationTriangle':
        return FontAwesomeIcons.triangleExclamation;
      case 'externalLink':
        return FontAwesomeIcons.arrowUpRightFromSquare;
      case 'music':
        return FontAwesomeIcons.music;
      case 'video':
        return FontAwesomeIcons.video;
      case 'fileText':
        return FontAwesomeIcons.fileLines;
      case 'reply':
        return FontAwesomeIcons.reply;
      case 'copy':
        return FontAwesomeIcons.copy;
      default:
        return FontAwesomeIcons.question; // أيقونة افتراضية
    }
  }

  /// التحقق من وجود أيقونة
  static bool hasIcon(String iconName) {
    const availableIcons = [
      'message',
      'magnifyingGlass',
      'thumbtack',
      'ellipsisVertical',
      'heart',
      'paperclip',
      'paperPlane',
      'robot',
      'exclamationTriangle',
      'externalLink',
      'music',
      'video',
      'fileText',
      'reply',
      'copy',
    ];

    return availableIcons.contains(iconName);
  }

  /// الحصول على قائمة بجميع الأيقونات المتاحة
  static Map<String, IconData> getAllAlternativeIcons() {
    return {
      'message': FontAwesomeIcons.comment,
      'magnifyingGlass': FontAwesomeIcons.magnifyingGlass,
      'thumbtack': FontAwesomeIcons.thumbtack,
      'ellipsisVertical': FontAwesomeIcons.ellipsisVertical,
      'heart': FontAwesomeIcons.heart,
      'paperclip': FontAwesomeIcons.paperclip,
      'paperPlane': FontAwesomeIcons.paperPlane,
      'robot': FontAwesomeIcons.robot,
      'exclamationTriangle': FontAwesomeIcons.triangleExclamation,
      'externalLink': FontAwesomeIcons.arrowUpRightFromSquare,
      'music': FontAwesomeIcons.music,
      'video': FontAwesomeIcons.video,
      'fileText': FontAwesomeIcons.fileLines,
      'reply': FontAwesomeIcons.reply,
      'copy': FontAwesomeIcons.copy,
    };
  }
}
