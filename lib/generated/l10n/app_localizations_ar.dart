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
  String get appDescription =>
      'أنا مساعدك الذكي. يمكنني مساعدتك في المذاكرة، الشؤون الأكاديمية، وحل المشاكل الدراسية.';

  @override
  String get appWelcomeMessage => 'مرحباً بك في مساعد كفو!';

  @override
  String get appNameShort => 'مساعد كفو';

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
  String get authRememberPassword => 'تذكر رمز المرور';

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

  @override
  String get authAcademicId => 'الرقم الأكاديمي';

  @override
  String get authAcademicIdHint => 'أدخل رقمك الأكاديمي';

  @override
  String get authPasswordHint => 'أدخل رمز المرور';

  @override
  String get authLoginTitle => 'تسجيل الدخول';

  @override
  String get authRememberMe => 'تذكرني';

  @override
  String get settingsGeneralTitle => 'الإعدادات العامة';

  @override
  String get settingsGeneralDescription => 'تخصيص الإعدادات الأساسية للتطبيق';

  @override
  String get settingsAppearanceTitle => 'المظهر والتخصيص';

  @override
  String get settingsAppearanceDescription => 'تخصيص مظهر التطبيق حسب تفضيلاتك';

  @override
  String get settingsChatTitle => 'إعدادات المحادثة';

  @override
  String get settingsChatDescription => 'تخصيص تجربة المحادثة مع المساعد الذكي';

  @override
  String get settingsPrivacyTitle => 'الخصوصية والأمان';

  @override
  String get settingsPrivacyDescription => 'التحكم في خصوصية بياناتك ومعلوماتك';

  @override
  String get settingsNotificationsTitle => 'الإشعارات';

  @override
  String get settingsNotificationsDescription => 'تخصيص الإشعارات والتنبيهات';

  @override
  String get settingsAITitle => 'الذكاء الاصطناعي';

  @override
  String get settingsAIDescription => 'تخصيص سلوك المساعد الذكي';

  @override
  String get settingsDataTitle => 'إدارة البيانات';

  @override
  String get settingsDataDescription => 'إدارة البيانات والنسخ الاحتياطية';

  @override
  String get settingsAboutTitle => 'حول التطبيق';

  @override
  String get settingsAboutDescription => 'معلومات عن التطبيق والإصدار';

  @override
  String get settingsDefaultLanguage => 'اللغة الافتراضية';

  @override
  String get settingsDefaultLanguageSubtitle =>
      'اختر اللغة التي تريد استخدامها في التطبيق';

  @override
  String get settingsTimezone => 'المنطقة الزمنية';

  @override
  String get settingsTimezoneSubtitle => 'اختر المنطقة الزمنية الخاصة بك';

  @override
  String get settingsBetaMode => 'الوضع التجريبي';

  @override
  String get settingsBetaModeSubtitle =>
      'الوصول إلى الميزات الجديدة قبل إطلاقها الرسمي';

  @override
  String get settingsAutoUpdate => 'التحديث التلقائي';

  @override
  String get settingsAutoUpdateSubtitle =>
      'تحديث التطبيق تلقائياً عند توفر إصدارات جديدة';

  @override
  String get settingsAnimations => 'الرسوم المتحركة';

  @override
  String get settingsAnimationsSubtitle => 'إظهار الرسوم المتحركة والانتقالات';

  @override
  String get settingsHapticFeedback => 'اللمس الاهتزازي';

  @override
  String get settingsHapticFeedbackSubtitle => 'اهتزاز خفيف عند التفاعل';

  @override
  String get settingsResponseStyle => 'نمط الرد';

  @override
  String get settingsResponseStyleSubtitle =>
      'اختر كيفية رد المساعد على أسئلتك';

  @override
  String get settingsMaxMessages => 'الحد الأقصى للرسائل';

  @override
  String get settingsMaxMessagesSubtitle =>
      'عدد الرسائل المحفوظة في المحادثة الواحدة';

  @override
  String get settingsAutoResponse => 'الرد التلقائي';

  @override
  String get settingsAutoResponseSubtitle =>
      'السماح للمساعد بالرد تلقائياً على بعض الأسئلة';

  @override
  String get settingsShowSuggestions => 'اقتراحات المحادثة';

  @override
  String get settingsShowSuggestionsSubtitle =>
      'إظهار اقتراحات للأسئلة التالية';

  @override
  String get settingsAutoCorrect => 'التصحيح التلقائي';

  @override
  String get settingsAutoCorrectSubtitle => 'تصحيح الأخطاء الإملائية تلقائياً';

  @override
  String get settingsAnalytics => 'جمع البيانات التحليلية';

  @override
  String get settingsAnalyticsSubtitle =>
      'السماح بجمع بيانات الاستخدام لتحسين التطبيق';

  @override
  String get settingsSaveChatHistory => 'حفظ سجل المحادثات';

  @override
  String get settingsSaveChatHistorySubtitle =>
      'حفظ المحادثات محلياً على جهازك';

  @override
  String get settingsAllowSharing => 'مشاركة المحادثات';

  @override
  String get settingsAllowSharingSubtitle =>
      'السماح بمشاركة المحادثات مع الآخرين';

  @override
  String get settingsEnableNotifications => 'تفعيل الإشعارات';

  @override
  String get settingsEnableNotificationsSubtitle => 'استلام إشعارات من التطبيق';

  @override
  String get settingsUpdateNotifications => 'إشعارات التحديثات';

  @override
  String get settingsUpdateNotificationsSubtitle =>
      'إشعارات عند توفر تحديثات جديدة';

  @override
  String get settingsFeatureNotifications => 'إشعارات الميزات الجديدة';

  @override
  String get settingsFeatureNotificationsSubtitle =>
      'إشعارات عند إضافة ميزات جديدة';

  @override
  String get settingsNotificationSound => 'صوت الإشعارات';

  @override
  String get settingsNotificationSoundSubtitle =>
      'تشغيل صوت عند استلام إشعارات';

  @override
  String get settingsAIModel => 'نموذج الذكاء الاصطناعي';

  @override
  String get settingsAIModelSubtitle => 'اختر النموذج المستخدم للمساعد';

  @override
  String get settingsContextLength => 'السياق المحفوظ';

  @override
  String get settingsContextLengthSubtitle => 'عدد الرسائل المحفوظة للسياق';

  @override
  String get settingsAdaptiveLearning => 'التعلم التكيفي';

  @override
  String get settingsAdaptiveLearningSubtitle =>
      'تحسين الردود بناءً على تفضيلاتك';

  @override
  String get settingsExperimentalAI => 'الميزات التجريبية للذكاء الاصطناعي';

  @override
  String get settingsExperimentalAISubtitle =>
      'تجربة ميزات جديدة في الذكاء الاصطناعي';

  @override
  String get settingsAutoBackup => 'النسخ الاحتياطي التلقائي';

  @override
  String get settingsAutoBackupSubtitle => 'إنشاء نسخ احتياطية تلقائياً';

  @override
  String get settingsBackupFrequency => 'تكرار النسخ الاحتياطي';

  @override
  String get settingsBackupFrequencySubtitle =>
      'متى يتم إنشاء النسخ الاحتياطية';

  @override
  String get settingsStorageUsed => 'مساحة التخزين المستخدمة';

  @override
  String get settingsExportData => 'تصدير البيانات';

  @override
  String get settingsDeleteAllData => 'حذف جميع البيانات';

  @override
  String get settingsChats => 'المحادثات';

  @override
  String get settingsMessages => 'الرسائل';

  @override
  String get settingsLastBackup => 'آخر نسخة';

  @override
  String get settingsNoBackup => 'لا توجد';

  @override
  String settingsAppVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get settingsAppDescription =>
      'مساعد ذكي لطلبة جامعة الملك فيصل، مصمم لمساعدتك في الشؤون الأكاديمية والدراسية.';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsPrivacyPolicySubtitle => 'اقرأ سياسة الخصوصية';

  @override
  String get settingsTermsOfService => 'شروط الاستخدام';

  @override
  String get settingsTermsOfServiceSubtitle => 'اقرأ شروط الاستخدام';

  @override
  String get settingsHelpAndSupport => 'المساعدة والدعم';

  @override
  String get settingsHelpAndSupportSubtitle => 'احصل على المساعدة';

  @override
  String get settingsSendFeedback => 'إرسال ملاحظات';

  @override
  String get settingsSendFeedbackSubtitle => 'ساعدنا في تحسين التطبيق';

  @override
  String get settingsDevelopedBy => 'تم التطوير بواسطة فريق جامعة الملك فيصل';

  @override
  String get settingsCopyright => 'جميع الحقوق محفوظة © 2024';

  @override
  String get settingsSave => 'حفظ الإعدادات';

  @override
  String get settingsReset => 'إعادة تعيين';

  @override
  String get settingsExport => 'تصدير';

  @override
  String get settingsImport => 'استيراد';

  @override
  String get settingsResetDialogTitle => 'إعادة تعيين الإعدادات';

  @override
  String get settingsResetDialogContent =>
      'هل أنت متأكد من إعادة تعيين جميع الإعدادات إلى القيم الافتراضية؟';

  @override
  String get settingsResetSuccess => 'تم إعادة تعيين الإعدادات';

  @override
  String get settingsExportDialogTitle => 'تصدير الإعدادات';

  @override
  String get settingsExportSuccess => 'تم تصدير الإعدادات بنجاح:';

  @override
  String settingsExportError(String error) {
    return 'خطأ في التصدير: $error';
  }

  @override
  String get settingsImportFeature => 'ميزة الاستيراد قيد التطوير';

  @override
  String get settingsDeleteDialogTitle => 'حذف جميع البيانات';

  @override
  String get settingsDeleteDialogContent =>
      'هل أنت متأكد من حذف جميع البيانات؟ هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get settingsDeleteSuccess => 'تم حذف جميع البيانات';

  @override
  String get settingsDeleteButton => 'حذف';

  @override
  String get settingsOK => 'موافق';

  @override
  String settingsMessagesCount(int count) {
    return '$count رسالة';
  }

  @override
  String settingsContextMessagesCount(int count) {
    return '$count رسائل';
  }

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get timezoneRiyadh => 'الرياض (GMT+3)';

  @override
  String get timezoneDubai => 'دبي (GMT+4)';

  @override
  String get timezoneKuwait => 'الكويت (GMT+3)';

  @override
  String get fontSizeSmall => 'صغير';

  @override
  String get fontSizeMedium => 'متوسط';

  @override
  String get fontSizeLarge => 'كبير';

  @override
  String get fontSizeExtraLarge => 'كبير جداً';

  @override
  String get fontSizeSelectorTitle => 'حجم الخط';

  @override
  String get fontSizeSelectorSubtitle => 'تعديل حجم النص في التطبيق';

  @override
  String get fontSizeExample => 'مثال على النص';

  @override
  String get themeSelectorTitle => 'المظهر';

  @override
  String get themeSelectorSubtitle => 'اختر بين المظهر الفاتح أو الداكن';

  @override
  String get responseStyleDetailed => 'مفصل وموسع';

  @override
  String get responseStyleConcise => 'مختصر ومباشر';

  @override
  String get responseStyleBalanced => 'متوازن';

  @override
  String get aiModelGPT4 => 'GPT-4 (الأكثر دقة)';

  @override
  String get aiModelGPT35 => 'GPT-3.5 (متوازن)';

  @override
  String get aiModelClaude => 'Claude (مفصل)';

  @override
  String get backupFrequencyNever => 'أبداً';

  @override
  String get backupFrequencyDaily => 'يومياً';

  @override
  String get backupFrequencyWeekly => 'أسبوعياً';

  @override
  String get backupFrequencyMonthly => 'شهرياً';

  @override
  String get creativityLevelTitle => 'درجة الإبداع';

  @override
  String get creativityLevelSubtitle => 'مستوى الإبداع في ردود المساعد';

  @override
  String get creativityConservative => 'محافظ';

  @override
  String get creativityBalanced => 'متوازن';

  @override
  String get creativityCreative => 'إبداعي';

  @override
  String get creativityDescriptionConservative =>
      'ردود محافظة ودقيقة بناءً على المعرفة المؤكدة';

  @override
  String get creativityDescriptionBalanced =>
      'توازن بين الدقة والإبداع في الردود';

  @override
  String get creativityDescriptionCreative =>
      'ردود إبداعية ومبتكرة مع المرونة في التفسير';
}
