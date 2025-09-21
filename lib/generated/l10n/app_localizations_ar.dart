// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مساعد كفو';

  @override
  String get appDescription => 'مساعد ذكي للطلبة - جامعة الملك فيصل';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get authUsername => 'الرقم الجامعي';

  @override
  String get authPassword => 'رمز المرور';

  @override
  String get authNext => 'التالي';

  @override
  String get authPrevious => 'السابق';

  @override
  String get authEnter => 'دخول';

  @override
  String get authRememberMe => 'تذكر رمز المرور';

  @override
  String get chatNew => 'محادثة جديدة';

  @override
  String get chatTitleDefault => 'مساعدة في الرياضيات';

  @override
  String get chatClear => 'مسح المحادثة';

  @override
  String get chatExport => 'تصدير المحادثة';

  @override
  String get chatShare => 'مشاركة';

  @override
  String get chatTyping => 'مساعد كفو يكتب...';

  @override
  String get chatMessagePlaceholder => 'اكتب رسالتك هنا...';

  @override
  String get chatHistoryTitle => 'سجل المحادثات';

  @override
  String get chatHistorySearchPlaceholder => 'ابحث في المحادثات...';

  @override
  String get chatHistoryFilterAll => 'جميع المحادثات';

  @override
  String get chatHistoryFilterRecent => 'المحادثات الأخيرة';

  @override
  String get chatHistoryFilterArchived => 'المحادثات المؤرشفة';

  @override
  String get chatHistorySortBy => 'ترتيب حسب';

  @override
  String get chatHistorySortDateDesc => 'الأحدث أولاً';

  @override
  String get chatHistorySortDateAsc => 'الأقدم أولاً';

  @override
  String get chatHistorySortTitle => 'الاسم';

  @override
  String get chatHistorySortMessages => 'عدد الرسائل';

  @override
  String get chatHistoryRefresh => 'تحديث';

  @override
  String get chatHistoryToggleView => 'تبديل العرض';

  @override
  String get chatHistoryBackToChat => 'العودة للمحادثة';

  @override
  String get chatHistoryDelete => 'حذف المحادثة';

  @override
  String get chatHistoryArchive => 'أرشفة';

  @override
  String get chatHistoryMoveToFolder => 'نقل إلى مجلد';

  @override
  String get chatHistoryEmptyState => 'لا توجد محادثات';

  @override
  String get chatHistoryClearFilters => 'مسح المرشحات';

  @override
  String chatHistoryMessagesCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString رسالة';
  }

  @override
  String get chatHistoryConfirmDelete => 'هل أنت متأكد من حذف هذه المحادثة؟';

  @override
  String get chatHistoryConfirmArchive => 'هل تريد أرشفة هذه المحادثة؟';

  @override
  String chatHistorySearchResults(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return 'نتائج البحث: $countString محادثة';
  }

  @override
  String get foldersTitle => 'المجلدات';

  @override
  String get foldersCreate => 'إنشاء مجلد';

  @override
  String get foldersRename => 'إعادة تسمية';

  @override
  String get foldersDelete => 'حذف مجلد';

  @override
  String get foldersChangeIcon => 'تغيير الأيقونة';

  @override
  String get foldersProgramming => 'البرمجة';

  @override
  String get foldersDataStructures => 'هياكل البيانات';

  @override
  String get foldersAlgorithms => 'الخوارزميات';

  @override
  String get foldersAcademic => 'الشؤون الأكاديمية';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsGeneral => 'عام';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsTheme => 'السمة';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsThemeAuto => 'تلقائي';

  @override
  String get settingsFontSize => 'حجم الخط';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsPrivacy => 'الخصوصية';

  @override
  String get settingsData => 'البيانات';

  @override
  String get settingsAbout => 'حول التطبيق';

  @override
  String get helpTitle => 'المساعدة';

  @override
  String get helpQuickStart => 'البدء السريع';

  @override
  String get helpFeatures => 'الميزات';

  @override
  String get helpChatGuide => 'دليل المحادثة';

  @override
  String get helpFoldersGuide => 'إدارة المجلدات';

  @override
  String get helpChatHistoryGuide => 'سجل المحادثات';

  @override
  String get helpSettingsGuide => 'الإعدادات';

  @override
  String get helpFAQ => 'الأسئلة الشائعة';

  @override
  String get feedbackTitle => 'إرسال ملاحظات';

  @override
  String get feedbackName => 'الاسم';

  @override
  String get feedbackEmail => 'البريد الإلكتروني';

  @override
  String get feedbackType => 'نوع الملاحظة';

  @override
  String get feedbackPriority => 'الأولوية';

  @override
  String get feedbackSubject => 'الموضوع';

  @override
  String get feedbackMessage => 'الوصف';

  @override
  String get feedbackAttachImages => 'إرفاق صور';

  @override
  String get feedbackSubmit => 'إرسال';

  @override
  String get feedbackSaveDraft => 'حفظ كمسودة';

  @override
  String get feedbackClear => 'مسح النموذج';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonAdd => 'إضافة';

  @override
  String get commonRemove => 'إزالة';

  @override
  String get commonSearch => 'بحث';

  @override
  String get commonFilter => 'تصفية';

  @override
  String get commonSort => 'ترتيب';

  @override
  String get commonLoading => 'جاري التحميل...';

  @override
  String get commonError => 'حدث خطأ';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonSuccess => 'تم بنجاح';

  @override
  String get commonNoData => 'لا توجد بيانات';

  @override
  String get commonNoResults => 'لا توجد نتائج';
}
