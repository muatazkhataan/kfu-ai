import 'package:html/parser.dart' as html_parser;

/// أدوات معالجة HTML
class HtmlUtils {
  HtmlUtils._();

  /// استخراج معلومات المصادر من HTML
  static List<SourceInfo> extractSources(String htmlString) {
    final sources = <SourceInfo>[];

    if (!htmlString.contains('<')) {
      return sources;
    }

    try {
      final document = html_parser.parse(htmlString);

      // البحث عن div المصادر
      final sourceDivs = document.querySelectorAll('div.sources');

      for (final div in sourceDivs) {
        // البحث عن الأزرار داخل div
        final buttons = div.querySelectorAll('button');

        for (final button in buttons) {
          final title =
              button.attributes['title'] ??
              button.attributes['data-toggle'] ??
              '';

          // استخراج نوع الملف من الأيقونة
          final icon = button.querySelector('i');
          String fileType = 'file';

          if (icon != null) {
            final classes = icon.attributes['class'] ?? '';
            if (classes.contains('fa-file-ppt')) {
              fileType = 'ppt';
            } else if (classes.contains('fa-file-pdf')) {
              fileType = 'pdf';
            } else if (classes.contains('fa-file-word')) {
              fileType = 'word';
            } else if (classes.contains('fa-file-excel')) {
              fileType = 'excel';
            }
          }

          if (title.isNotEmpty) {
            sources.add(SourceInfo(title: title, fileType: fileType));
          }
        }
      }
    } catch (e) {
      // في حالة الخطأ، أرجع قائمة فارغة
    }

    return sources;
  }

  /// تحويل HTML إلى نص عادي
  static String htmlToPlainText(String htmlString) {
    if (!htmlString.contains('<')) {
      // إذا لم يكن HTML، أرجع النص مباشرة
      return htmlString;
    }

    try {
      final document = html_parser.parse(htmlString);

      // استخراج النص فقط (بدون HTML tags)
      final text = document.body?.text ?? htmlString;

      // تنظيف المسافات الزائدة
      return text.trim();
    } catch (e) {
      // في حالة الخطأ، أرجع النص الأصلي
      return htmlString;
    }
  }

  /// تنظيف HTML من tags معينة (مثل sources div)
  static String cleanHtml(String htmlString) {
    if (!htmlString.contains('<')) {
      return htmlString;
    }

    try {
      final document = html_parser.parse(htmlString);

      // حذف div الخاص بالمصادر
      final sourceDivs = document.querySelectorAll('div.sources');
      for (final div in sourceDivs) {
        div.remove();
      }

      return document.body?.innerHtml ?? htmlString;
    } catch (e) {
      return htmlString;
    }
  }

  /// استخراج النص من HTML مع الحفاظ على التنسيق الأساسي
  static String htmlToFormattedText(String htmlString) {
    if (!htmlString.contains('<')) {
      return htmlString;
    }

    try {
      var text = htmlString;

      // استبدال الفقرات بأسطر جديدة
      text = text.replaceAll(RegExp(r'<\/p>\s*<p>'), '\n\n');
      text = text.replaceAll(RegExp(r'<p>|<\/p>'), '');

      // استبدال br بأسطر جديدة
      text = text.replaceAll(RegExp(r'<br\s*\/?>'), '\n');

      // حذف divs الخاصة بالمصادر
      text = text.replaceAll(
        RegExp(
          r'<div[^>]*class=["\x27][^\x22\x27]*sources[^\x22\x27]*["\x27][^>]*>[\s\S]*?</div>',
          multiLine: true,
        ),
        '',
      );

      // حذف جميع HTML tags الأخرى
      text = text.replaceAll(RegExp(r'<[^>]*>'), '');

      // تنظيف المسافات الزائدة
      text = text.replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n');
      text = text.trim();

      return text;
    } catch (e) {
      return htmlToPlainText(htmlString);
    }
  }

  /// التحقق من وجود HTML في النص
  static bool containsHtml(String text) {
    return text.contains(RegExp(r'<[^>]+>'));
  }

  /// التحقق من وجود مصادر في HTML
  static bool hasSources(String htmlString) {
    return htmlString.contains('sources') && htmlString.contains('<div');
  }
}

/// معلومات المصدر
class SourceInfo {
  final String title;
  final String fileType;

  const SourceInfo({required this.title, required this.fileType});

  @override
  String toString() => 'SourceInfo(title: $title, type: $fileType)';
}
