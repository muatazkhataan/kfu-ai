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

  @override
  String get sidebarClose => 'إغلاق القائمة';

  @override
  String get sidebarUserDefault => 'مستخدم';

  @override
  String sidebarUserIdDisplay(String id) {
    return 'ID: $id...';
  }

  @override
  String get sidebarSignOut => 'تسجيل الخروج';

  @override
  String get sidebarSearchInChats => 'بحث في المحادثات';

  @override
  String get sidebarOpenFoldersScreen => 'فتح شاشة المجلدات';

  @override
  String get sidebarNoFolders => 'لا توجد مجلدات';

  @override
  String get sidebarFixedFolderTooltip => 'مجلد ثابت لا يمكن تعديله';

  @override
  String get sidebarSystemFolderTooltip => 'مجلد نظامي لا يمكن تعديله';

  @override
  String get sidebarProtectedFolderTooltip => 'هذا المجلد غير قابل للتعديل';

  @override
  String get sidebarDeleteFolderTitle => 'حذف المجلد';

  @override
  String sidebarDeleteFolderMessage(String name) {
    return 'هل أنت متأكد من حذف المجلد \"$name\"?\n\nهذا الإجراء لا يمكن التراجع عنه.';
  }

  @override
  String get sidebarFolderDeletedSuccess => 'تم حذف المجلد بنجاح';

  @override
  String get chatSources => 'المصادر';

  @override
  String get navbarOpenMenu => 'فتح القائمة';

  @override
  String get navbarCloseMenu => 'إغلاق القائمة';

  @override
  String get navbarMenu => 'القائمة';

  @override
  String get navbarSettings => 'الإعدادات';

  @override
  String get chatReply => 'الرد';

  @override
  String get chatCopy => 'نسخ';

  @override
  String get chatEdit => 'تحرير';

  @override
  String get chatMore => 'المزيد';

  @override
  String get chatMoveToArchive => 'نقل إلى الأرشيف';

  @override
  String get chatMoveToFolder => 'نقل إلى مجلد';

  @override
  String get chatDeleteChatTitle => 'حذف المحادثة';

  @override
  String chatDeleteChatMessage(String title) {
    return 'هل أنت متأكد من حذف المحادثة \"$title\"?';
  }

  @override
  String get chatMoveToFolderTitle => 'نقل إلى مجلد';

  @override
  String get chatNoFoldersAvailable => 'لا توجد مجلدات متاحة';

  @override
  String get chatNoFolder => 'بدون مجلد';

  @override
  String chatOpeningChat(String title) {
    return 'جاري فتح المحادثة: $title';
  }

  @override
  String chatDeleted(String title) {
    return 'تم حذف المحادثة: $title';
  }

  @override
  String get chatHistoryUpdated => 'تم تحديث سجل المحادثات';

  @override
  String get chatDeleteFolderTitle => 'حذف المجلد';

  @override
  String chatDeleteFolderMessage(String name) {
    return 'هل أنت متأكد من حذف مجلد \"$name\"?';
  }

  @override
  String get chatFolderDeletedSuccess => 'تم حذف المجلد بنجاح';

  @override
  String chatError(String error) {
    return 'خطأ: $error';
  }

  @override
  String chatAttachmentSelected(String type) {
    return 'تم تحديد $type';
  }

  @override
  String get chatSettings => 'إعدادات المحادثة';

  @override
  String get chatCreateFolderTitle => 'إنشاء مجلد جديد';

  @override
  String get chatCreate => 'إنشاء';

  @override
  String get chatEditFolderTitle => 'تعديل المجلد';

  @override
  String get chatChangeIcon => 'تغيير الأيقونة';

  @override
  String get chatAddToFavorites => 'إضافة للمفضلة';

  @override
  String get chatRemoveFromFavorites => 'إزالة من المفضلة';

  @override
  String get chatPin => 'تثبيت';

  @override
  String get chatUnpin => 'إلغاء التثبيت';

  @override
  String chatMoveToFolderSuccess(String folder) {
    return 'تم نقل المحادثة إلى \"$folder\" بنجاح';
  }

  @override
  String get chatMoveToFolderFailed => 'فشل نقل المحادثة';

  @override
  String get chatArchiveSuccess => 'تم نقل المحادثة إلى الأرشيف بنجاح';

  @override
  String get chatArchiveFailed => 'فشل نقل المحادثة إلى الأرشيف';

  @override
  String get chatDeleteSuccess => 'تم حذف المحادثة بنجاح';

  @override
  String get chatDeleteFailed => 'فشل حذف المحادثة';

  @override
  String get folderChangeIconTitle => 'تغيير أيقونة المجلد';

  @override
  String get folderSelectIcon => 'اختر الأيقونة';

  @override
  String get folderSelectColor => 'اختر اللون';

  @override
  String folderSelectedColor(String name) {
    return 'اللون المختار: $name';
  }

  @override
  String get folderColorUndefined => 'غير محدد';

  @override
  String get folderApplying => 'جاري التطبيق...';

  @override
  String folderApplyIcon(String name) {
    return 'تطبيق \"$name\"';
  }

  @override
  String folderIconChangedSuccess(String name) {
    return 'تم تغيير أيقونة المجلد \"$name\" بنجاح';
  }

  @override
  String get folderColorGray => 'رمادي فاتح';

  @override
  String get folderColorRed => 'أحمر';

  @override
  String get folderColorOrange => 'برتقالي';

  @override
  String get folderColorYellow => 'أصفر';

  @override
  String get folderColorGreen => 'أخضر';

  @override
  String get folderColorCyan => 'أزرق سماوي';

  @override
  String get folderColorPurple => 'بنفسجي';

  @override
  String get folderColorPink => 'وردي';

  @override
  String get folderPreview => 'معاينة المجلد';

  @override
  String get folderNamePlaceholder => 'اسم المجلد';

  @override
  String get folderNameLabel => 'اسم المجلد *';

  @override
  String get folderNameHint => 'أدخل اسم المجلد';

  @override
  String get folderNameRequired => 'اسم المجلد مطلوب';

  @override
  String get folderNameMinLength => 'اسم المجلد يجب أن يكون على الأقل حرفين';

  @override
  String get folderNameMaxLength => 'اسم المجلد يجب ألا يتجاوز 50 حرفاً';

  @override
  String get folderSaveChanges => 'حفظ التعديلات';

  @override
  String get folderCreate => 'إنشاء المجلد';

  @override
  String get folderCreatedSuccess => 'تم إنشاء المجلد بنجاح';

  @override
  String get folderUpdatedSuccess => 'تم تحديث المجلد بنجاح';

  @override
  String get iconCategoryGeneral => 'عام';

  @override
  String get iconCategoryProgramming => 'البرمجة';

  @override
  String get iconCategoryMathematics => 'الرياضيات';

  @override
  String get iconCategoryScience => 'العلوم';

  @override
  String get iconCategoryStudy => 'الدراسة';

  @override
  String get iconCategoryCreativity => 'الإبداع';

  @override
  String get iconCategoryCollaboration => 'العمل الجماعي';

  @override
  String get iconCategorySystem => 'النظام';

  @override
  String get iconFolderGeneral => 'مجلد عادي';

  @override
  String get iconFolderStar => 'نجمة';

  @override
  String get iconFolderHeart => 'قلب';

  @override
  String get iconFolderHome => 'الرئيسية';

  @override
  String get iconFolderThumbtack => 'مثبت';

  @override
  String get iconFolderPlus => 'إضافة مجلد';

  @override
  String get iconFolderOpen => 'مجلد مفتوح';

  @override
  String get iconCode => 'كود';

  @override
  String get iconLaptopCode => 'لابتوب كود';

  @override
  String get iconTerminal => 'طرفية';

  @override
  String get iconBug => 'خطأ برمجي';

  @override
  String get iconCogs => 'إعدادات';

  @override
  String get iconMicrochip => 'معالج';

  @override
  String get iconServer => 'خادم';

  @override
  String get iconNetworkWired => 'شبكة';

  @override
  String get iconShieldAlt => 'حماية';

  @override
  String get iconKey => 'مفتاح';

  @override
  String get iconDatabase => 'قاعدة بيانات';

  @override
  String get iconTable => 'جدول';

  @override
  String get iconChartBar => 'رسم بياني';

  @override
  String get iconMobileAlt => 'جوال';

  @override
  String get iconGlobe => 'عالمي';

  @override
  String get iconCloud => 'سحابة';

  @override
  String get iconRobot => 'روبوت';

  @override
  String get iconBrain => 'دماغ';

  @override
  String get iconSitemap => 'خريطة موقع';

  @override
  String get iconProjectDiagram => 'مخطط مشروع';

  @override
  String get iconFileCode => 'ملف كود';

  @override
  String get iconCodeBranch => 'فرع كود';

  @override
  String get iconCodeMerge => 'دمج كود';

  @override
  String get iconCodeCompare => 'مقارنة كود';

  @override
  String get iconCalculator => 'آلة حاسبة';

  @override
  String get iconSquareRootAlt => 'جذر تربيعي';

  @override
  String get iconInfinity => 'لانهاية';

  @override
  String get iconPercentage => 'نسبة مئوية';

  @override
  String get iconChartLine => 'رسم خطي';

  @override
  String get iconChartPie => 'رسم دائري';

  @override
  String get iconChartArea => 'رسم مساحي';

  @override
  String get iconSortNumericUp => 'ترتيب تصاعدي';

  @override
  String get iconSortNumericDown => 'ترتيب تنازلي';

  @override
  String get iconEquals => 'يساوي';

  @override
  String get iconPlus => 'زائد';

  @override
  String get iconMinus => 'ناقص';

  @override
  String get iconTimes => 'ضرب';

  @override
  String get iconDivide => 'قسمة';

  @override
  String get iconSuperscript => 'أس علوي';

  @override
  String get iconSubscript => 'أس سفلي';

  @override
  String get iconSigma => 'سيجما';

  @override
  String get iconPi => 'باي';

  @override
  String get iconFunction => 'دالة';

  @override
  String get iconIntegral => 'تكامل';

  @override
  String get iconTriangle => 'مثلث';

  @override
  String get iconOmega => 'أوميغا';

  @override
  String get iconTheta => 'ثيتا';

  @override
  String get iconAtom => 'ذرة';

  @override
  String get iconFlask => 'قارورة';

  @override
  String get iconMicroscope => 'مجهر';

  @override
  String get iconDna => 'DNA';

  @override
  String get iconLeaf => 'ورقة';

  @override
  String get iconSeedling => 'نبتة';

  @override
  String get iconDroplet => 'قطرة';

  @override
  String get iconFire => 'نار';

  @override
  String get iconBolt => 'برق';

  @override
  String get iconMagnet => 'مغناطيس';

  @override
  String get iconSatellite => 'قمر صناعي';

  @override
  String get iconRocket => 'صاروخ';

  @override
  String get iconSun => 'شمس';

  @override
  String get iconMoon => 'قمر';

  @override
  String get iconStar => 'نجمة';

  @override
  String get iconTelescope => 'تلسكوب';

  @override
  String get iconVial => 'أنبوب اختبار';

  @override
  String get iconPills => 'أقراص';

  @override
  String get iconStethoscope => 'سماعة طبية';

  @override
  String get iconHeartbeat => 'نبض';

  @override
  String get iconEye => 'عين';

  @override
  String get iconEar => 'أذن';

  @override
  String get iconNose => 'أنف';

  @override
  String get iconTooth => 'سن';

  @override
  String get iconBone => 'عظم';

  @override
  String get iconLungs => 'رئتان';

  @override
  String get iconLiver => 'كبد';

  @override
  String get iconKidney => 'كلية';

  @override
  String get iconStomach => 'معدة';

  @override
  String get iconIntestines => 'أمعاء';

  @override
  String get iconGraduationCap => 'قبعة تخرج';

  @override
  String get iconBook => 'كتاب';

  @override
  String get iconBookOpen => 'كتاب مفتوح';

  @override
  String get iconPen => 'قلم';

  @override
  String get iconPencilAlt => 'قلم رصاص';

  @override
  String get iconHighlighter => 'قلم تمييز';

  @override
  String get iconStickyNote => 'ملاحظة';

  @override
  String get iconClipboard => 'لوح';

  @override
  String get iconFileAlt => 'ملف';

  @override
  String get iconArchive => 'أرشيف';

  @override
  String get iconCalendarAlt => 'تقويم';

  @override
  String get iconClock => 'ساعة';

  @override
  String get iconStopwatch => 'ساعة توقيت';

  @override
  String get iconHourglassHalf => 'ساعة رملية';

  @override
  String get iconBell => 'جرس';

  @override
  String get iconFlag => 'علم';

  @override
  String get iconTrophy => 'كأس';

  @override
  String get iconMedal => 'ميدالية';

  @override
  String get iconCertificate => 'شهادة';

  @override
  String get iconAward => 'جائزة';

  @override
  String get iconUserGraduate => 'طالب';

  @override
  String get iconChalkboardTeacher => 'معلم';

  @override
  String get iconChalkboard => 'سبورة';

  @override
  String get iconSearch => 'بحث';

  @override
  String get iconQuestionCircle => 'سؤال';

  @override
  String get iconLightbulb => 'فكرة';

  @override
  String get iconInbox => 'صندوق وارد';

  @override
  String get iconPalette => 'لوحة ألوان';

  @override
  String get iconPaintBrush => 'فرشاة';

  @override
  String get iconMagic => 'سحر';

  @override
  String get iconSparkles => 'شرارات';

  @override
  String get iconEyeDropper => 'قطارة';

  @override
  String get iconCamera => 'كاميرا';

  @override
  String get iconVideo => 'فيديو';

  @override
  String get iconMusic => 'موسيقى';

  @override
  String get iconHeadphones => 'سماعات';

  @override
  String get iconGamepad => 'جهاز ألعاب';

  @override
  String get iconDice => 'نرد';

  @override
  String get iconPuzzlePiece => 'قطعة أحجية';

  @override
  String get iconCube => 'مكعب';

  @override
  String get iconGem => 'جوهرة';

  @override
  String get iconCrown => 'تاج';

  @override
  String get iconRibbon => 'شريط';

  @override
  String get iconUsers => 'مستخدمون';

  @override
  String get iconUserFriends => 'أصدقاء';

  @override
  String get iconHandshake => 'مصافحة';

  @override
  String get iconComments => 'تعليقات';

  @override
  String get iconCommentDots => 'تعليق';

  @override
  String get iconEnvelope => 'ظرف';

  @override
  String get iconPhone => 'هاتف';

  @override
  String get iconVideoCamera => 'كاميرا فيديو';

  @override
  String get iconShareAlt => 'مشاركة';

  @override
  String get iconLink => 'رابط';

  @override
  String get iconSync => 'مزامنة';

  @override
  String get iconDownload => 'تحميل';

  @override
  String get iconUpload => 'رفع';

  @override
  String get iconPrint => 'طباعة';

  @override
  String get iconCopy => 'نسخ';

  @override
  String get iconPaperPlane => 'طائرة ورقية';

  @override
  String get iconSend => 'إرسال';

  @override
  String get iconBellSlash => 'إيقاف التنبيهات';

  @override
  String get iconChat => 'محادثة';

  @override
  String get iconMessage => 'رسالة';

  @override
  String get iconReply => 'رد';

  @override
  String get iconShare => 'مشاركة';

  @override
  String get iconAttach => 'مرفق';

  @override
  String get iconImage => 'صورة';

  @override
  String get iconFile => 'ملف';

  @override
  String get iconPaperclip => 'مشبك ورق';

  @override
  String get iconSettings => 'إعدادات';

  @override
  String get iconCog => 'ترس';

  @override
  String get iconShield => 'درع';

  @override
  String get iconInfo => 'معلومات';

  @override
  String get iconHelp => 'مساعدة';

  @override
  String get iconQuestion => 'سؤال';

  @override
  String get iconCheck => 'صح';

  @override
  String get iconWarning => 'تحذير';

  @override
  String get iconError => 'خطأ';

  @override
  String get iconInfoCircle => 'معلومات';

  @override
  String get iconExclamation => 'تعجب';

  @override
  String get iconExclamationTriangle => 'مثلث تحذير';

  @override
  String get iconUser => 'مستخدم';

  @override
  String get iconLock => 'قفل';

  @override
  String get iconSignIn => 'تسجيل دخول';

  @override
  String get iconSignOut => 'تسجيل خروج';

  @override
  String get iconEdit => 'تعديل';

  @override
  String get iconDelete => 'حذف';

  @override
  String get iconTrash => 'سلة';

  @override
  String get iconSave => 'حفظ';

  @override
  String get iconHistory => 'تاريخ';

  @override
  String get iconLockKeyhole => 'قفل';

  @override
  String get iconUnlock => 'فتح';

  @override
  String get iconMicrophone => 'ميكروفون';

  @override
  String get iconFileCodeIcon => 'ملف كود';

  @override
  String get iconList => 'قائمة';

  @override
  String get iconGrid => 'شبكة';

  @override
  String get iconThLarge => 'شبكة كبيرة';

  @override
  String get iconBars => 'أشرطة';

  @override
  String get iconMenu => 'قائمة';

  @override
  String get iconFilter => 'تصفية';

  @override
  String get iconSort => 'ترتيب';

  @override
  String get iconRefresh => 'تحديث';

  @override
  String get iconBack => 'رجوع';

  @override
  String get iconNext => 'التالي';

  @override
  String get iconPrevious => 'السابق';

  @override
  String get iconClose => 'إغلاق';

  @override
  String get iconEllipsis => 'نقاط';

  @override
  String get iconEllipsisH => 'نقاط أفقية';

  @override
  String get iconEllipsisV => 'نقاط عمودية';

  @override
  String get iconChevronUp => 'سهم علوي';

  @override
  String get iconChevronDown => 'سهم سفلي';

  @override
  String get iconChevronLeft => 'سهم يسار';

  @override
  String get iconChevronRight => 'سهم يمين';

  @override
  String get iconAngleUp => 'زاوية علوية';

  @override
  String get iconAngleDown => 'زاوية سفلية';

  @override
  String get iconAngleLeft => 'زاوية يسارية';

  @override
  String get iconAngleRight => 'زاوية يمينية';

  @override
  String get iconAnglesUp => 'زوايا علوية';

  @override
  String get iconAnglesDown => 'زوايا سفلية';

  @override
  String get iconUpRightAndDownLeftFromCenter => 'توسيع';

  @override
  String get iconDownLeftAndUpRightToCenter => 'طي';

  @override
  String get iconPlay => 'تشغيل';

  @override
  String get iconPause => 'إيقاف';

  @override
  String get iconStop => 'إيقاف';

  @override
  String get iconFilm => 'فيلم';

  @override
  String get iconFileText => 'ملف نصي';

  @override
  String get iconFileLines => 'ملف';

  @override
  String get iconArrowLeft => 'سهم يسار';

  @override
  String get iconArrowRight => 'سهم يمين';

  @override
  String get iconArrowUp => 'سهم أعلى';

  @override
  String get iconArrowDown => 'سهم أسفل';

  @override
  String get iconArrowTurnUpLeft => 'سهم منعطف';

  @override
  String get iconArrowTurnUpRight => 'سهم منعطف';

  @override
  String get iconArrowTurnDownLeft => 'سهم منعطف';

  @override
  String get iconArrowTurnDownRight => 'سهم منعطف';

  @override
  String get iconXmark => 'إغلاق';

  @override
  String get iconCheckCircle => 'صح دائري';

  @override
  String get iconTimesCircle => 'خطأ دائري';

  @override
  String get iconInfoCircleIcon => 'معلومات دائري';

  @override
  String get iconExclamationCircle => 'تعجب دائري';

  @override
  String get chatWelcome => 'مرحباً بك في مساعد كفو!';

  @override
  String get chatWelcomeMessage =>
      'أنا مساعدك الذكي. يمكنني مساعدتك في المذاكرة، الشؤون الأكاديمية، وحل المشاكل الدراسية.';

  @override
  String get chatSuggestionCourses => 'المقررات الدراسية';

  @override
  String get chatSuggestionCoursesSubtitle => 'مساعدة في أحد المقررات الدراسية';

  @override
  String get chatSuggestionCoursesAction => 'أريد مساعدة في حل مشكلة برمجية';

  @override
  String get chatSuggestionSchedules => 'الجداول الدراسية';

  @override
  String get chatSuggestionSchedulesSubtitle =>
      'معرفة مواعيد الامتحانات والمحاضرات';

  @override
  String get chatSuggestionSchedulesAction => 'متى موعد الامتحانات النهائية؟';

  @override
  String get chatSuggestionGrades => 'الدرجات والتقديرات';

  @override
  String get chatSuggestionGradesSubtitle => 'الاستعلام عن النتائج والدرجات';

  @override
  String get chatSuggestionGradesAction => 'كيف أستعلم عن درجاتي؟';

  @override
  String get chatSuggestionAcademic => 'الشؤون الأكاديمية';

  @override
  String get chatSuggestionAcademicSubtitle => 'الاستفسار عن الشؤون الأكاديمية';

  @override
  String get chatSuggestionAcademicAction =>
      'أريد أن أستفسر عن موضوع بخصوص الحضور';

  @override
  String get chatQuickActionProgramming => 'مساعدة في البرمجة';

  @override
  String get chatQuickActionProgrammingAction =>
      'أحتاج مساعدة في حل مشكلة برمجية';

  @override
  String get chatQuickActionAcademicDates => 'المواعيد الأكاديمية';

  @override
  String get chatQuickActionAcademicDatesAction =>
      'ما هي المواعيد المهمة للفصل الدراسي؟';

  @override
  String get chatQuickActionProgrammingTips => 'نصائح البرمجة';

  @override
  String get chatQuickActionProgrammingTipsAction =>
      'كيف أحسن مهاراتي في البرمجة؟';

  @override
  String get chatQuickActionDataStructures => 'هياكل البيانات';

  @override
  String get chatQuickActionDataStructuresAction => 'أحتاج شرح لهياكل البيانات';

  @override
  String get chatSearchInMessages => 'البحث في الرسائل...';

  @override
  String get chatNoSearchResults => 'لا توجد نتائج بحث';

  @override
  String get chatWriteYourMessage => 'اكتب رسالتك هنا...';

  @override
  String get chatFolders => 'المجلدات';

  @override
  String get chatAllChats => 'جميع المحادثات';

  @override
  String get chatNoFolders => 'لا توجد مجلدات';

  @override
  String get chatDelete => 'حذف';

  @override
  String get chatSearchAndSettings => 'البحث والإعدادات';

  @override
  String get chatSearchInChats => 'البحث في المحادثات...';

  @override
  String get chatSearchByDate => 'البحث بالتاريخ';

  @override
  String get chatSearchByDateSubtitle => 'البحث في المحادثات حسب التاريخ';

  @override
  String get chatSearchByFolder => 'البحث بالمجلد';

  @override
  String get chatSearchByFolderSubtitle => 'البحث في محادثات مجلد معين';

  @override
  String get chatSearchByTags => 'البحث بالعلامات';

  @override
  String get chatSearchByTagsSubtitle =>
      'البحث باستخدام العلامات والكلمات المفتاحية';

  @override
  String get chatSettingsTitle => 'إعدادات المحادثة';

  @override
  String get chatSettingsNotifications => 'الإشعارات';

  @override
  String get chatSettingsNotificationsSubtitle => 'إعدادات الإشعارات';

  @override
  String get chatSettingsAppearance => 'المظهر';

  @override
  String get chatSettingsAppearanceSubtitle => 'تغيير مظهر التطبيق';

  @override
  String get chatSettingsLanguage => 'اللغة';

  @override
  String get chatSettingsLanguageSubtitle => 'تغيير لغة التطبيق';

  @override
  String get chatSettingsBackup => 'النسخ الاحتياطي';

  @override
  String get chatSettingsBackupSubtitle => 'نسخ احتياطي للمحادثات';

  @override
  String get chatNewChat => 'محادثة جديدة';

  @override
  String chatMessageCount(int count) {
    return '$count رسالة';
  }

  @override
  String chatLastActivity(String date) {
    return 'آخر نشاط: $date';
  }

  @override
  String get chatSuggestionMedicine => 'الطب';

  @override
  String get chatSuggestionMedicineSubtitle =>
      'مساعدة في المواد الطبية والتشخيص';

  @override
  String get chatSuggestionMedicineAction =>
      'أحتاج شرحاً عن آلية عمل القلب والدورة الدموية';

  @override
  String get chatSuggestionPharmacy => 'الصيدلة';

  @override
  String get chatSuggestionPharmacySubtitle =>
      'مساعدة في الأدوية والتفاعلات الدوائية';

  @override
  String get chatSuggestionPharmacyAction =>
      'ما هي التفاعلات الدوائية المحتملة بين الأسبرين والإيبوبروفين؟';

  @override
  String get chatSuggestionHealthSciences => 'العلوم الصحية';

  @override
  String get chatSuggestionHealthSciencesSubtitle =>
      'مساعدة في العلوم الصحية والتغذية';

  @override
  String get chatSuggestionHealthSciencesAction =>
      'ما هي العناصر الغذائية الأساسية للجسم؟';

  @override
  String get chatSuggestionEngineering => 'الهندسة';

  @override
  String get chatSuggestionEngineeringSubtitle =>
      'مساعدة في المواد الهندسية والتصميم';

  @override
  String get chatSuggestionEngineeringAction =>
      'أحتاج شرحاً عن مبادئ الديناميكا الحرارية';

  @override
  String get chatSuggestionComputerScience => 'علوم الحاسب';

  @override
  String get chatSuggestionComputerScienceSubtitle =>
      'مساعدة في البرمجة والخوارزميات';

  @override
  String get chatSuggestionComputerScienceAction =>
      'كيف يمكن تحسين أداء خوارزمية البحث الثنائي؟';

  @override
  String get chatSuggestionCivilEngineering => 'الهندسة المدنية';

  @override
  String get chatSuggestionCivilEngineeringSubtitle =>
      'مساعدة في الإنشاءات والبنية التحتية';

  @override
  String get chatSuggestionCivilEngineeringAction =>
      'ما هي العوامل المؤثرة في تصميم الجسور؟';

  @override
  String get chatSuggestionArts => 'الآداب';

  @override
  String get chatSuggestionArtsSubtitle => 'مساعدة في الأدب واللغة والنقد';

  @override
  String get chatSuggestionArtsAction => 'ما هي خصائص الشعر الجاهلي؟';

  @override
  String get chatSuggestionIslamicStudies => 'الدراسات الإسلامية';

  @override
  String get chatSuggestionIslamicStudiesSubtitle =>
      'مساعدة في الفقه والتفسير والحديث';

  @override
  String get chatSuggestionIslamicStudiesAction =>
      'ما هو الفرق بين الفقه والأصول؟';

  @override
  String get chatSuggestionEducation => 'العلوم التربوية';

  @override
  String get chatSuggestionEducationSubtitle =>
      'مساعدة في التربية وطرق التدريس';

  @override
  String get chatSuggestionEducationAction =>
      'ما هي أفضل طرق التدريس للطلاب ذوي صعوبات التعلم؟';

  @override
  String get chatSuggestionBusiness => 'إدارة الأعمال';

  @override
  String get chatSuggestionBusinessSubtitle =>
      'مساعدة في الإدارة والتسويق والتمويل';

  @override
  String get chatSuggestionBusinessAction =>
      'كيف يمكن تحليل السوق المستهدف لمشروع جديد؟';

  @override
  String get chatSuggestionEconomics => 'الاقتصاد';

  @override
  String get chatSuggestionEconomicsSubtitle => 'مساعدة في الاقتصاد والمالية';

  @override
  String get chatSuggestionEconomicsAction =>
      'ما هو الفرق بين الاقتصاد الكلي والجزئي؟';

  @override
  String get chatSuggestionSciences => 'العلوم';

  @override
  String get chatSuggestionSciencesSubtitle => 'مساعدة في الفيزياء والرياضيات';

  @override
  String get chatSuggestionSciencesAction =>
      'أحتاج شرحاً عن قوانين نيوتن للحركة';

  @override
  String get chatSuggestionChemistry => 'الكيمياء';

  @override
  String get chatSuggestionChemistrySubtitle => 'مساعدة في الكيمياء والتفاعلات';

  @override
  String get chatSuggestionChemistryAction =>
      'ما هي أنواع التفاعلات الكيميائية؟';

  @override
  String get chatSuggestionBiology => 'الأحياء';

  @override
  String get chatSuggestionBiologySubtitle => 'مساعدة في علم الأحياء والوراثة';

  @override
  String get chatSuggestionBiologyAction =>
      'كيف تعمل عملية البناء الضوئي في النباتات؟';

  @override
  String get chatMessageCopy => 'نسخ';

  @override
  String get chatMessageEdit => 'تحرير';

  @override
  String get chatMessageThumbUp => 'إعجاب';

  @override
  String get chatMessageThumbDown => 'عدم إعجاب';

  @override
  String get chatMessageRetry => 'إعادة المحاولة';

  @override
  String get chatMessageCopied => 'تم نسخ المحتوى';
}
