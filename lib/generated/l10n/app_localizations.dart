import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// اسم التطبيق
  ///
  /// In ar, this message translates to:
  /// **'مساعد كفو'**
  String get appName;

  /// وصف التطبيق
  ///
  /// In ar, this message translates to:
  /// **'أنا مساعدك الذكي. يمكنني مساعدتك في المذاكرة، الشؤون الأكاديمية، وحل المشاكل الدراسية.'**
  String get appDescription;

  /// رسالة الترحيب في التطبيق
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في مساعد كفو!'**
  String get appWelcomeMessage;

  /// اسم التطبيق المختصر
  ///
  /// In ar, this message translates to:
  /// **'مساعد كفو'**
  String get appNameShort;

  /// عنوان شاشة تسجيل الدخول
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get authLogin;

  /// حقل اسم المستخدم/الرقم الجامعي
  ///
  /// In ar, this message translates to:
  /// **'الرقم الجامعي'**
  String get authUsername;

  /// حقل كلمة المرور
  ///
  /// In ar, this message translates to:
  /// **'رمز المرور'**
  String get authPassword;

  /// زر الانتقال للخطوة التالية
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get authNext;

  /// زر العودة للخطوة السابقة
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get authPrevious;

  /// زر تسجيل الدخول
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get authEnter;

  /// خيار تذكر كلمة المرور
  ///
  /// In ar, this message translates to:
  /// **'تذكر رمز المرور'**
  String get authRememberPassword;

  /// إنشاء محادثة جديدة
  ///
  /// In ar, this message translates to:
  /// **'محادثة جديدة'**
  String get chatNew;

  /// عنوان افتراضي للمحادثة
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في الرياضيات'**
  String get chatTitleDefault;

  /// مسح جميع الرسائل في المحادثة
  ///
  /// In ar, this message translates to:
  /// **'مسح المحادثة'**
  String get chatClear;

  /// تصدير المحادثة إلى ملف
  ///
  /// In ar, this message translates to:
  /// **'تصدير المحادثة'**
  String get chatExport;

  /// زر مشاركة الرسالة
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get chatShare;

  /// مؤشر الكتابة
  ///
  /// In ar, this message translates to:
  /// **'مساعد كفو يكتب...'**
  String get chatTyping;

  /// نص توضيحي لحقل إدخال الرسالة
  ///
  /// In ar, this message translates to:
  /// **'اكتب رسالتك هنا...'**
  String get chatMessagePlaceholder;

  /// عنوان شاشة سجل المحادثات
  ///
  /// In ar, this message translates to:
  /// **'سجل المحادثات'**
  String get chatHistoryTitle;

  /// نص توضيحي لحقل البحث
  ///
  /// In ar, this message translates to:
  /// **'ابحث في المحادثات...'**
  String get chatHistorySearchPlaceholder;

  /// فلتر عرض جميع المحادثات
  ///
  /// In ar, this message translates to:
  /// **'جميع المحادثات'**
  String get chatHistoryFilterAll;

  /// فلتر المحادثات الأخيرة
  ///
  /// In ar, this message translates to:
  /// **'المحادثات الأخيرة'**
  String get chatHistoryFilterRecent;

  /// فلتر المحادثات المؤرشفة
  ///
  /// In ar, this message translates to:
  /// **'المحادثات المؤرشفة'**
  String get chatHistoryFilterArchived;

  /// عنوان قائمة الترتيب
  ///
  /// In ar, this message translates to:
  /// **'ترتيب حسب'**
  String get chatHistorySortBy;

  /// ترتيب حسب التاريخ تنازلي
  ///
  /// In ar, this message translates to:
  /// **'الأحدث أولاً'**
  String get chatHistorySortDateDesc;

  /// ترتيب حسب التاريخ تصاعدي
  ///
  /// In ar, this message translates to:
  /// **'الأقدم أولاً'**
  String get chatHistorySortDateAsc;

  /// ترتيب حسب اسم المحادثة
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get chatHistorySortTitle;

  /// ترتيب حسب عدد الرسائل
  ///
  /// In ar, this message translates to:
  /// **'عدد الرسائل'**
  String get chatHistorySortMessages;

  /// تحديث قائمة المحادثات
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get chatHistoryRefresh;

  /// تبديل بين عرض القائمة والشبكة
  ///
  /// In ar, this message translates to:
  /// **'تبديل العرض'**
  String get chatHistoryToggleView;

  /// العودة لشاشة المحادثة الرئيسية
  ///
  /// In ar, this message translates to:
  /// **'العودة للمحادثة'**
  String get chatHistoryBackToChat;

  /// حذف محادثة
  ///
  /// In ar, this message translates to:
  /// **'حذف المحادثة'**
  String get chatHistoryDelete;

  /// أرشفة محادثة
  ///
  /// In ar, this message translates to:
  /// **'أرشفة'**
  String get chatHistoryArchive;

  /// نقل محادثة إلى مجلد
  ///
  /// In ar, this message translates to:
  /// **'نقل إلى مجلد'**
  String get chatHistoryMoveToFolder;

  /// رسالة الحالة الفارغة
  ///
  /// In ar, this message translates to:
  /// **'لا توجد محادثات'**
  String get chatHistoryEmptyState;

  /// مسح جميع المرشحات
  ///
  /// In ar, this message translates to:
  /// **'مسح المرشحات'**
  String get chatHistoryClearFilters;

  /// عدد الرسائل في المحادثة
  ///
  /// In ar, this message translates to:
  /// **'{count} رسالة'**
  String chatHistoryMessagesCount(int count);

  /// رسالة تأكيد الحذف
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذه المحادثة؟'**
  String get chatHistoryConfirmDelete;

  /// رسالة تأكيد الأرشفة
  ///
  /// In ar, this message translates to:
  /// **'هل تريد أرشفة هذه المحادثة؟'**
  String get chatHistoryConfirmArchive;

  /// عدد نتائج البحث
  ///
  /// In ar, this message translates to:
  /// **'نتائج البحث: {count} محادثة'**
  String chatHistorySearchResults(int count);

  /// عنوان قسم المجلدات
  ///
  /// In ar, this message translates to:
  /// **'المجلدات'**
  String get foldersTitle;

  /// إنشاء مجلد جديد
  ///
  /// In ar, this message translates to:
  /// **'إنشاء مجلد'**
  String get foldersCreate;

  /// إعادة تسمية مجلد
  ///
  /// In ar, this message translates to:
  /// **'إعادة تسمية'**
  String get foldersRename;

  /// حذف مجلد
  ///
  /// In ar, this message translates to:
  /// **'حذف مجلد'**
  String get foldersDelete;

  /// تغيير أيقونة المجلد
  ///
  /// In ar, this message translates to:
  /// **'تغيير الأيقونة'**
  String get foldersChangeIcon;

  /// مجلد البرمجة
  ///
  /// In ar, this message translates to:
  /// **'البرمجة'**
  String get foldersProgramming;

  /// مجلد هياكل البيانات
  ///
  /// In ar, this message translates to:
  /// **'هياكل البيانات'**
  String get foldersDataStructures;

  /// مجلد الخوارزميات
  ///
  /// In ar, this message translates to:
  /// **'الخوارزميات'**
  String get foldersAlgorithms;

  /// مجلد الشؤون الأكاديمية
  ///
  /// In ar, this message translates to:
  /// **'الشؤون الأكاديمية'**
  String get foldersAcademic;

  /// عنوان شاشة الإعدادات
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// قسم الإعدادات العامة
  ///
  /// In ar, this message translates to:
  /// **'عام'**
  String get settingsGeneral;

  /// قسم إعدادات المظهر
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get settingsAppearance;

  /// إعداد اللغة
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get settingsLanguage;

  /// إعداد السمة
  ///
  /// In ar, this message translates to:
  /// **'السمة'**
  String get settingsTheme;

  /// السمة الفاتحة
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get settingsThemeLight;

  /// السمة الداكنة
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get settingsThemeDark;

  /// السمة التلقائية
  ///
  /// In ar, this message translates to:
  /// **'تلقائي'**
  String get settingsThemeAuto;

  /// إعداد حجم الخط
  ///
  /// In ar, this message translates to:
  /// **'حجم الخط'**
  String get settingsFontSize;

  /// إعدادات الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get settingsNotifications;

  /// إعدادات الخصوصية
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية'**
  String get settingsPrivacy;

  /// إعدادات البيانات
  ///
  /// In ar, this message translates to:
  /// **'البيانات'**
  String get settingsData;

  /// معلومات حول التطبيق
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get settingsAbout;

  /// عنوان شاشة المساعدة
  ///
  /// In ar, this message translates to:
  /// **'المساعدة'**
  String get helpTitle;

  /// دليل البدء السريع
  ///
  /// In ar, this message translates to:
  /// **'البدء السريع'**
  String get helpQuickStart;

  /// دليل الميزات
  ///
  /// In ar, this message translates to:
  /// **'الميزات'**
  String get helpFeatures;

  /// دليل استخدام المحادثة
  ///
  /// In ar, this message translates to:
  /// **'دليل المحادثة'**
  String get helpChatGuide;

  /// دليل إدارة المجلدات
  ///
  /// In ar, this message translates to:
  /// **'إدارة المجلدات'**
  String get helpFoldersGuide;

  /// دليل استخدام سجل المحادثات
  ///
  /// In ar, this message translates to:
  /// **'سجل المحادثات'**
  String get helpChatHistoryGuide;

  /// دليل الإعدادات
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get helpSettingsGuide;

  /// الأسئلة الشائعة
  ///
  /// In ar, this message translates to:
  /// **'الأسئلة الشائعة'**
  String get helpFAQ;

  /// عنوان شاشة إرسال الملاحظات
  ///
  /// In ar, this message translates to:
  /// **'إرسال ملاحظات'**
  String get feedbackTitle;

  /// حقل الاسم
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get feedbackName;

  /// حقل البريد الإلكتروني
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get feedbackEmail;

  /// نوع الملاحظة
  ///
  /// In ar, this message translates to:
  /// **'نوع الملاحظة'**
  String get feedbackType;

  /// أولوية الملاحظة
  ///
  /// In ar, this message translates to:
  /// **'الأولوية'**
  String get feedbackPriority;

  /// موضوع الملاحظة
  ///
  /// In ar, this message translates to:
  /// **'الموضوع'**
  String get feedbackSubject;

  /// وصف الملاحظة
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get feedbackMessage;

  /// إرفاق صور
  ///
  /// In ar, this message translates to:
  /// **'إرفاق صور'**
  String get feedbackAttachImages;

  /// إرسال الملاحظة
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get feedbackSubmit;

  /// حفظ كمسودة
  ///
  /// In ar, this message translates to:
  /// **'حفظ كمسودة'**
  String get feedbackSaveDraft;

  /// مسح النموذج
  ///
  /// In ar, this message translates to:
  /// **'مسح النموذج'**
  String get feedbackClear;

  /// زر الإلغاء
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get commonCancel;

  /// زر التأكيد
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get commonConfirm;

  /// زر الحفظ
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get commonSave;

  /// زر الحذف
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get commonDelete;

  /// زر التعديل
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get commonEdit;

  /// زر الإضافة
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get commonAdd;

  /// زر الإزالة
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get commonRemove;

  /// زر البحث
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get commonSearch;

  /// زر التصفية
  ///
  /// In ar, this message translates to:
  /// **'تصفية'**
  String get commonFilter;

  /// زر الترتيب
  ///
  /// In ar, this message translates to:
  /// **'ترتيب'**
  String get commonSort;

  /// رسالة التحميل
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get commonLoading;

  /// رسالة الخطأ العامة
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get commonError;

  /// زر إعادة المحاولة
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get commonRetry;

  /// رسالة النجاح
  ///
  /// In ar, this message translates to:
  /// **'تم بنجاح'**
  String get commonSuccess;

  /// رسالة عدم وجود بيانات
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get commonNoData;

  /// رسالة عدم وجود نتائج
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج'**
  String get commonNoResults;

  /// حقل الرقم الأكاديمي
  ///
  /// In ar, this message translates to:
  /// **'الرقم الأكاديمي'**
  String get authAcademicId;

  /// نص توضيحي لحقل الرقم الأكاديمي
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقمك الأكاديمي'**
  String get authAcademicIdHint;

  /// نص توضيحي لحقل رمز المرور
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز المرور'**
  String get authPasswordHint;

  /// عنوان شاشة تسجيل الدخول
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get authLoginTitle;

  /// خيار تذكر المستخدم
  ///
  /// In ar, this message translates to:
  /// **'تذكرني'**
  String get authRememberMe;

  /// عنوان قسم الإعدادات العامة
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات العامة'**
  String get settingsGeneralTitle;

  /// وصف قسم الإعدادات العامة
  ///
  /// In ar, this message translates to:
  /// **'تخصيص الإعدادات الأساسية للتطبيق'**
  String get settingsGeneralDescription;

  /// عنوان قسم المظهر
  ///
  /// In ar, this message translates to:
  /// **'المظهر والتخصيص'**
  String get settingsAppearanceTitle;

  /// وصف قسم المظهر
  ///
  /// In ar, this message translates to:
  /// **'تخصيص مظهر التطبيق حسب تفضيلاتك'**
  String get settingsAppearanceDescription;

  /// عنوان قسم إعدادات المحادثة
  ///
  /// In ar, this message translates to:
  /// **'إعدادات المحادثة'**
  String get settingsChatTitle;

  /// وصف قسم إعدادات المحادثة
  ///
  /// In ar, this message translates to:
  /// **'تخصيص تجربة المحادثة مع المساعد الذكي'**
  String get settingsChatDescription;

  /// عنوان قسم الخصوصية
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية والأمان'**
  String get settingsPrivacyTitle;

  /// وصف قسم الخصوصية
  ///
  /// In ar, this message translates to:
  /// **'التحكم في خصوصية بياناتك ومعلوماتك'**
  String get settingsPrivacyDescription;

  /// عنوان قسم الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get settingsNotificationsTitle;

  /// وصف قسم الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'تخصيص الإشعارات والتنبيهات'**
  String get settingsNotificationsDescription;

  /// عنوان قسم الذكاء الاصطناعي
  ///
  /// In ar, this message translates to:
  /// **'الذكاء الاصطناعي'**
  String get settingsAITitle;

  /// وصف قسم الذكاء الاصطناعي
  ///
  /// In ar, this message translates to:
  /// **'تخصيص سلوك المساعد الذكي'**
  String get settingsAIDescription;

  /// عنوان قسم البيانات
  ///
  /// In ar, this message translates to:
  /// **'إدارة البيانات'**
  String get settingsDataTitle;

  /// وصف قسم البيانات
  ///
  /// In ar, this message translates to:
  /// **'إدارة البيانات والنسخ الاحتياطية'**
  String get settingsDataDescription;

  /// عنوان قسم حول التطبيق
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get settingsAboutTitle;

  /// وصف قسم حول التطبيق
  ///
  /// In ar, this message translates to:
  /// **'معلومات عن التطبيق والإصدار'**
  String get settingsAboutDescription;

  /// إعداد اللغة الافتراضية
  ///
  /// In ar, this message translates to:
  /// **'اللغة الافتراضية'**
  String get settingsDefaultLanguage;

  /// وصف إعداد اللغة
  ///
  /// In ar, this message translates to:
  /// **'اختر اللغة التي تريد استخدامها في التطبيق'**
  String get settingsDefaultLanguageSubtitle;

  /// إعداد المنطقة الزمنية
  ///
  /// In ar, this message translates to:
  /// **'المنطقة الزمنية'**
  String get settingsTimezone;

  /// وصف إعداد المنطقة الزمنية
  ///
  /// In ar, this message translates to:
  /// **'اختر المنطقة الزمنية الخاصة بك'**
  String get settingsTimezoneSubtitle;

  /// إعداد الوضع التجريبي
  ///
  /// In ar, this message translates to:
  /// **'الوضع التجريبي'**
  String get settingsBetaMode;

  /// وصف الوضع التجريبي
  ///
  /// In ar, this message translates to:
  /// **'الوصول إلى الميزات الجديدة قبل إطلاقها الرسمي'**
  String get settingsBetaModeSubtitle;

  /// إعداد التحديث التلقائي
  ///
  /// In ar, this message translates to:
  /// **'التحديث التلقائي'**
  String get settingsAutoUpdate;

  /// وصف التحديث التلقائي
  ///
  /// In ar, this message translates to:
  /// **'تحديث التطبيق تلقائياً عند توفر إصدارات جديدة'**
  String get settingsAutoUpdateSubtitle;

  /// إعداد الرسوم المتحركة
  ///
  /// In ar, this message translates to:
  /// **'الرسوم المتحركة'**
  String get settingsAnimations;

  /// وصف الرسوم المتحركة
  ///
  /// In ar, this message translates to:
  /// **'إظهار الرسوم المتحركة والانتقالات'**
  String get settingsAnimationsSubtitle;

  /// إعداد اللمس الاهتزازي
  ///
  /// In ar, this message translates to:
  /// **'اللمس الاهتزازي'**
  String get settingsHapticFeedback;

  /// وصف اللمس الاهتزازي
  ///
  /// In ar, this message translates to:
  /// **'اهتزاز خفيف عند التفاعل'**
  String get settingsHapticFeedbackSubtitle;

  /// إعداد نمط الرد
  ///
  /// In ar, this message translates to:
  /// **'نمط الرد'**
  String get settingsResponseStyle;

  /// وصف نمط الرد
  ///
  /// In ar, this message translates to:
  /// **'اختر كيفية رد المساعد على أسئلتك'**
  String get settingsResponseStyleSubtitle;

  /// إعداد الحد الأقصى للرسائل
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى للرسائل'**
  String get settingsMaxMessages;

  /// وصف الحد الأقصى للرسائل
  ///
  /// In ar, this message translates to:
  /// **'عدد الرسائل المحفوظة في المحادثة الواحدة'**
  String get settingsMaxMessagesSubtitle;

  /// إعداد الرد التلقائي
  ///
  /// In ar, this message translates to:
  /// **'الرد التلقائي'**
  String get settingsAutoResponse;

  /// وصف الرد التلقائي
  ///
  /// In ar, this message translates to:
  /// **'السماح للمساعد بالرد تلقائياً على بعض الأسئلة'**
  String get settingsAutoResponseSubtitle;

  /// إعداد اقتراحات المحادثة
  ///
  /// In ar, this message translates to:
  /// **'اقتراحات المحادثة'**
  String get settingsShowSuggestions;

  /// وصف اقتراحات المحادثة
  ///
  /// In ar, this message translates to:
  /// **'إظهار اقتراحات للأسئلة التالية'**
  String get settingsShowSuggestionsSubtitle;

  /// إعداد التصحيح التلقائي
  ///
  /// In ar, this message translates to:
  /// **'التصحيح التلقائي'**
  String get settingsAutoCorrect;

  /// وصف التصحيح التلقائي
  ///
  /// In ar, this message translates to:
  /// **'تصحيح الأخطاء الإملائية تلقائياً'**
  String get settingsAutoCorrectSubtitle;

  /// إعداد جمع البيانات التحليلية
  ///
  /// In ar, this message translates to:
  /// **'جمع البيانات التحليلية'**
  String get settingsAnalytics;

  /// وصف جمع البيانات التحليلية
  ///
  /// In ar, this message translates to:
  /// **'السماح بجمع بيانات الاستخدام لتحسين التطبيق'**
  String get settingsAnalyticsSubtitle;

  /// إعداد حفظ سجل المحادثات
  ///
  /// In ar, this message translates to:
  /// **'حفظ سجل المحادثات'**
  String get settingsSaveChatHistory;

  /// وصف حفظ سجل المحادثات
  ///
  /// In ar, this message translates to:
  /// **'حفظ المحادثات محلياً على جهازك'**
  String get settingsSaveChatHistorySubtitle;

  /// إعداد مشاركة المحادثات
  ///
  /// In ar, this message translates to:
  /// **'مشاركة المحادثات'**
  String get settingsAllowSharing;

  /// وصف مشاركة المحادثات
  ///
  /// In ar, this message translates to:
  /// **'السماح بمشاركة المحادثات مع الآخرين'**
  String get settingsAllowSharingSubtitle;

  /// إعداد تفعيل الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الإشعارات'**
  String get settingsEnableNotifications;

  /// وصف تفعيل الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'استلام إشعارات من التطبيق'**
  String get settingsEnableNotificationsSubtitle;

  /// إعداد إشعارات التحديثات
  ///
  /// In ar, this message translates to:
  /// **'إشعارات التحديثات'**
  String get settingsUpdateNotifications;

  /// وصف إشعارات التحديثات
  ///
  /// In ar, this message translates to:
  /// **'إشعارات عند توفر تحديثات جديدة'**
  String get settingsUpdateNotificationsSubtitle;

  /// إعداد إشعارات الميزات الجديدة
  ///
  /// In ar, this message translates to:
  /// **'إشعارات الميزات الجديدة'**
  String get settingsFeatureNotifications;

  /// وصف إشعارات الميزات الجديدة
  ///
  /// In ar, this message translates to:
  /// **'إشعارات عند إضافة ميزات جديدة'**
  String get settingsFeatureNotificationsSubtitle;

  /// إعداد صوت الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'صوت الإشعارات'**
  String get settingsNotificationSound;

  /// وصف صوت الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'تشغيل صوت عند استلام إشعارات'**
  String get settingsNotificationSoundSubtitle;

  /// إعداد نموذج الذكاء الاصطناعي
  ///
  /// In ar, this message translates to:
  /// **'نموذج الذكاء الاصطناعي'**
  String get settingsAIModel;

  /// وصف نموذج الذكاء الاصطناعي
  ///
  /// In ar, this message translates to:
  /// **'اختر النموذج المستخدم للمساعد'**
  String get settingsAIModelSubtitle;

  /// إعداد السياق المحفوظ
  ///
  /// In ar, this message translates to:
  /// **'السياق المحفوظ'**
  String get settingsContextLength;

  /// وصف السياق المحفوظ
  ///
  /// In ar, this message translates to:
  /// **'عدد الرسائل المحفوظة للسياق'**
  String get settingsContextLengthSubtitle;

  /// إعداد التعلم التكيفي
  ///
  /// In ar, this message translates to:
  /// **'التعلم التكيفي'**
  String get settingsAdaptiveLearning;

  /// وصف التعلم التكيفي
  ///
  /// In ar, this message translates to:
  /// **'تحسين الردود بناءً على تفضيلاتك'**
  String get settingsAdaptiveLearningSubtitle;

  /// إعداد الميزات التجريبية
  ///
  /// In ar, this message translates to:
  /// **'الميزات التجريبية للذكاء الاصطناعي'**
  String get settingsExperimentalAI;

  /// وصف الميزات التجريبية
  ///
  /// In ar, this message translates to:
  /// **'تجربة ميزات جديدة في الذكاء الاصطناعي'**
  String get settingsExperimentalAISubtitle;

  /// إعداد النسخ الاحتياطي التلقائي
  ///
  /// In ar, this message translates to:
  /// **'النسخ الاحتياطي التلقائي'**
  String get settingsAutoBackup;

  /// وصف النسخ الاحتياطي التلقائي
  ///
  /// In ar, this message translates to:
  /// **'إنشاء نسخ احتياطية تلقائياً'**
  String get settingsAutoBackupSubtitle;

  /// إعداد تكرار النسخ الاحتياطي
  ///
  /// In ar, this message translates to:
  /// **'تكرار النسخ الاحتياطي'**
  String get settingsBackupFrequency;

  /// وصف تكرار النسخ الاحتياطي
  ///
  /// In ar, this message translates to:
  /// **'متى يتم إنشاء النسخ الاحتياطية'**
  String get settingsBackupFrequencySubtitle;

  /// معلومات مساحة التخزين
  ///
  /// In ar, this message translates to:
  /// **'مساحة التخزين المستخدمة'**
  String get settingsStorageUsed;

  /// زر تصدير البيانات
  ///
  /// In ar, this message translates to:
  /// **'تصدير البيانات'**
  String get settingsExportData;

  /// زر حذف جميع البيانات
  ///
  /// In ar, this message translates to:
  /// **'حذف جميع البيانات'**
  String get settingsDeleteAllData;

  /// عدد المحادثات
  ///
  /// In ar, this message translates to:
  /// **'المحادثات'**
  String get settingsChats;

  /// عدد الرسائل
  ///
  /// In ar, this message translates to:
  /// **'الرسائل'**
  String get settingsMessages;

  /// آخر نسخة احتياطية
  ///
  /// In ar, this message translates to:
  /// **'آخر نسخة'**
  String get settingsLastBackup;

  /// لا توجد نسخة احتياطية
  ///
  /// In ar, this message translates to:
  /// **'لا توجد'**
  String get settingsNoBackup;

  /// إصدار التطبيق
  ///
  /// In ar, this message translates to:
  /// **'الإصدار {version}'**
  String settingsAppVersion(String version);

  /// وصف التطبيق
  ///
  /// In ar, this message translates to:
  /// **'مساعد ذكي لطلبة جامعة الملك فيصل، مصمم لمساعدتك في الشؤون الأكاديمية والدراسية.'**
  String get settingsAppDescription;

  /// رابط سياسة الخصوصية
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get settingsPrivacyPolicy;

  /// وصف سياسة الخصوصية
  ///
  /// In ar, this message translates to:
  /// **'اقرأ سياسة الخصوصية'**
  String get settingsPrivacyPolicySubtitle;

  /// رابط شروط الاستخدام
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get settingsTermsOfService;

  /// وصف شروط الاستخدام
  ///
  /// In ar, this message translates to:
  /// **'اقرأ شروط الاستخدام'**
  String get settingsTermsOfServiceSubtitle;

  /// رابط المساعدة والدعم
  ///
  /// In ar, this message translates to:
  /// **'المساعدة والدعم'**
  String get settingsHelpAndSupport;

  /// وصف المساعدة والدعم
  ///
  /// In ar, this message translates to:
  /// **'احصل على المساعدة'**
  String get settingsHelpAndSupportSubtitle;

  /// رابط إرسال الملاحظات
  ///
  /// In ar, this message translates to:
  /// **'إرسال ملاحظات'**
  String get settingsSendFeedback;

  /// وصف إرسال الملاحظات
  ///
  /// In ar, this message translates to:
  /// **'ساعدنا في تحسين التطبيق'**
  String get settingsSendFeedbackSubtitle;

  /// معلومات المطور
  ///
  /// In ar, this message translates to:
  /// **'تم التطوير بواسطة فريق جامعة الملك فيصل'**
  String get settingsDevelopedBy;

  /// حقوق النشر
  ///
  /// In ar, this message translates to:
  /// **'جميع الحقوق محفوظة © 2024'**
  String get settingsCopyright;

  /// زر حفظ الإعدادات
  ///
  /// In ar, this message translates to:
  /// **'حفظ الإعدادات'**
  String get settingsSave;

  /// زر إعادة تعيين الإعدادات
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين'**
  String get settingsReset;

  /// زر تصدير الإعدادات
  ///
  /// In ar, this message translates to:
  /// **'تصدير'**
  String get settingsExport;

  /// زر استيراد الإعدادات
  ///
  /// In ar, this message translates to:
  /// **'استيراد'**
  String get settingsImport;

  /// عنوان حوار إعادة التعيين
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين الإعدادات'**
  String get settingsResetDialogTitle;

  /// محتوى حوار إعادة التعيين
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من إعادة تعيين جميع الإعدادات إلى القيم الافتراضية؟'**
  String get settingsResetDialogContent;

  /// رسالة نجاح إعادة التعيين
  ///
  /// In ar, this message translates to:
  /// **'تم إعادة تعيين الإعدادات'**
  String get settingsResetSuccess;

  /// عنوان حوار التصدير
  ///
  /// In ar, this message translates to:
  /// **'تصدير الإعدادات'**
  String get settingsExportDialogTitle;

  /// رسالة نجاح التصدير
  ///
  /// In ar, this message translates to:
  /// **'تم تصدير الإعدادات بنجاح:'**
  String get settingsExportSuccess;

  /// رسالة خطأ التصدير
  ///
  /// In ar, this message translates to:
  /// **'خطأ في التصدير: {error}'**
  String settingsExportError(String error);

  /// رسالة ميزة الاستيراد
  ///
  /// In ar, this message translates to:
  /// **'ميزة الاستيراد قيد التطوير'**
  String get settingsImportFeature;

  /// عنوان حوار الحذف
  ///
  /// In ar, this message translates to:
  /// **'حذف جميع البيانات'**
  String get settingsDeleteDialogTitle;

  /// محتوى حوار الحذف
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف جميع البيانات؟ هذا الإجراء لا يمكن التراجع عنه.'**
  String get settingsDeleteDialogContent;

  /// رسالة نجاح الحذف
  ///
  /// In ar, this message translates to:
  /// **'تم حذف جميع البيانات'**
  String get settingsDeleteSuccess;

  /// زر الحذف
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get settingsDeleteButton;

  /// زر الموافقة
  ///
  /// In ar, this message translates to:
  /// **'موافق'**
  String get settingsOK;

  /// عدد الرسائل
  ///
  /// In ar, this message translates to:
  /// **'{count} رسالة'**
  String settingsMessagesCount(int count);

  /// عدد رسائل السياق
  ///
  /// In ar, this message translates to:
  /// **'{count} رسائل'**
  String settingsContextMessagesCount(int count);

  /// اسم اللغة العربية
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// اسم اللغة الإنجليزية
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// منطقة الرياض الزمنية
  ///
  /// In ar, this message translates to:
  /// **'الرياض (GMT+3)'**
  String get timezoneRiyadh;

  /// منطقة دبي الزمنية
  ///
  /// In ar, this message translates to:
  /// **'دبي (GMT+4)'**
  String get timezoneDubai;

  /// منطقة الكويت الزمنية
  ///
  /// In ar, this message translates to:
  /// **'الكويت (GMT+3)'**
  String get timezoneKuwait;

  /// حجم خط صغير
  ///
  /// In ar, this message translates to:
  /// **'صغير'**
  String get fontSizeSmall;

  /// حجم خط متوسط
  ///
  /// In ar, this message translates to:
  /// **'متوسط'**
  String get fontSizeMedium;

  /// حجم خط كبير
  ///
  /// In ar, this message translates to:
  /// **'كبير'**
  String get fontSizeLarge;

  /// حجم خط كبير جداً
  ///
  /// In ar, this message translates to:
  /// **'كبير جداً'**
  String get fontSizeExtraLarge;

  /// عنوان محدد حجم الخط
  ///
  /// In ar, this message translates to:
  /// **'حجم الخط'**
  String get fontSizeSelectorTitle;

  /// وصف محدد حجم الخط
  ///
  /// In ar, this message translates to:
  /// **'تعديل حجم النص في التطبيق'**
  String get fontSizeSelectorSubtitle;

  /// نص المثال في محدد حجم الخط
  ///
  /// In ar, this message translates to:
  /// **'مثال على النص'**
  String get fontSizeExample;

  /// عنوان محدد المظهر
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get themeSelectorTitle;

  /// وصف محدد المظهر
  ///
  /// In ar, this message translates to:
  /// **'اختر بين المظهر الفاتح أو الداكن'**
  String get themeSelectorSubtitle;

  /// نمط رد مفصل
  ///
  /// In ar, this message translates to:
  /// **'مفصل وموسع'**
  String get responseStyleDetailed;

  /// نمط رد مختصر
  ///
  /// In ar, this message translates to:
  /// **'مختصر ومباشر'**
  String get responseStyleConcise;

  /// نمط رد متوازن
  ///
  /// In ar, this message translates to:
  /// **'متوازن'**
  String get responseStyleBalanced;

  /// نموذج GPT-4
  ///
  /// In ar, this message translates to:
  /// **'GPT-4 (الأكثر دقة)'**
  String get aiModelGPT4;

  /// نموذج GPT-3.5
  ///
  /// In ar, this message translates to:
  /// **'GPT-3.5 (متوازن)'**
  String get aiModelGPT35;

  /// نموذج Claude
  ///
  /// In ar, this message translates to:
  /// **'Claude (مفصل)'**
  String get aiModelClaude;

  /// تكرار نسخ احتياطي: أبداً
  ///
  /// In ar, this message translates to:
  /// **'أبداً'**
  String get backupFrequencyNever;

  /// تكرار نسخ احتياطي: يومياً
  ///
  /// In ar, this message translates to:
  /// **'يومياً'**
  String get backupFrequencyDaily;

  /// تكرار نسخ احتياطي: أسبوعياً
  ///
  /// In ar, this message translates to:
  /// **'أسبوعياً'**
  String get backupFrequencyWeekly;

  /// تكرار نسخ احتياطي: شهرياً
  ///
  /// In ar, this message translates to:
  /// **'شهرياً'**
  String get backupFrequencyMonthly;

  /// عنوان درجة الإبداع
  ///
  /// In ar, this message translates to:
  /// **'درجة الإبداع'**
  String get creativityLevelTitle;

  /// وصف درجة الإبداع
  ///
  /// In ar, this message translates to:
  /// **'مستوى الإبداع في ردود المساعد'**
  String get creativityLevelSubtitle;

  /// تسمية نمط محافظ
  ///
  /// In ar, this message translates to:
  /// **'محافظ'**
  String get creativityConservative;

  /// تسمية نمط متوازن
  ///
  /// In ar, this message translates to:
  /// **'متوازن'**
  String get creativityBalanced;

  /// تسمية نمط إبداعي
  ///
  /// In ar, this message translates to:
  /// **'إبداعي'**
  String get creativityCreative;

  /// وصف النمط المحافظ
  ///
  /// In ar, this message translates to:
  /// **'ردود محافظة ودقيقة بناءً على المعرفة المؤكدة'**
  String get creativityDescriptionConservative;

  /// وصف النمط المتوازن
  ///
  /// In ar, this message translates to:
  /// **'توازن بين الدقة والإبداع في الردود'**
  String get creativityDescriptionBalanced;

  /// وصف النمط الإبداعي
  ///
  /// In ar, this message translates to:
  /// **'ردود إبداعية ومبتكرة مع المرونة في التفسير'**
  String get creativityDescriptionCreative;

  /// زر إغلاق القائمة الجانبية
  ///
  /// In ar, this message translates to:
  /// **'إغلاق القائمة'**
  String get sidebarClose;

  /// اسم المستخدم الافتراضي
  ///
  /// In ar, this message translates to:
  /// **'مستخدم'**
  String get sidebarUserDefault;

  /// عرض معرف المستخدم
  ///
  /// In ar, this message translates to:
  /// **'ID: {id}...'**
  String sidebarUserIdDisplay(String id);

  /// زر تسجيل الخروج
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get sidebarSignOut;

  /// زر البحث في المحادثات
  ///
  /// In ar, this message translates to:
  /// **'بحث في المحادثات'**
  String get sidebarSearchInChats;

  /// تلميح زر فتح شاشة المجلدات
  ///
  /// In ar, this message translates to:
  /// **'فتح شاشة المجلدات'**
  String get sidebarOpenFoldersScreen;

  /// رسالة عدم وجود مجلدات
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مجلدات'**
  String get sidebarNoFolders;

  /// تلميح المجلد الثابت
  ///
  /// In ar, this message translates to:
  /// **'مجلد ثابت لا يمكن تعديله'**
  String get sidebarFixedFolderTooltip;

  /// تلميح المجلد النظامي
  ///
  /// In ar, this message translates to:
  /// **'مجلد نظامي لا يمكن تعديله'**
  String get sidebarSystemFolderTooltip;

  /// تلميح المجلد المحمي
  ///
  /// In ar, this message translates to:
  /// **'هذا المجلد غير قابل للتعديل'**
  String get sidebarProtectedFolderTooltip;

  /// عنوان حوار حذف المجلد
  ///
  /// In ar, this message translates to:
  /// **'حذف المجلد'**
  String get sidebarDeleteFolderTitle;

  /// رسالة تأكيد حذف المجلد
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف المجلد \"{name}\"?\n\nهذا الإجراء لا يمكن التراجع عنه.'**
  String sidebarDeleteFolderMessage(String name);

  /// رسالة نجاح حذف المجلد
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المجلد بنجاح'**
  String get sidebarFolderDeletedSuccess;

  /// عنوان قسم المصادر في المحادثة
  ///
  /// In ar, this message translates to:
  /// **'المصادر'**
  String get chatSources;

  /// تلميح زر فتح القائمة في navbar
  ///
  /// In ar, this message translates to:
  /// **'فتح القائمة'**
  String get navbarOpenMenu;

  /// تلميح زر إغلاق القائمة في navbar
  ///
  /// In ar, this message translates to:
  /// **'إغلاق القائمة'**
  String get navbarCloseMenu;

  /// تلميح زر القائمة في navbar
  ///
  /// In ar, this message translates to:
  /// **'القائمة'**
  String get navbarMenu;

  /// تلميح زر الإعدادات في navbar
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get navbarSettings;

  /// زر الرد على الرسالة
  ///
  /// In ar, this message translates to:
  /// **'الرد'**
  String get chatReply;

  /// زر نسخ الرسالة
  ///
  /// In ar, this message translates to:
  /// **'نسخ'**
  String get chatCopy;

  /// زر تحرير الرسالة
  ///
  /// In ar, this message translates to:
  /// **'تحرير'**
  String get chatEdit;

  /// زر المزيد من الخيارات
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get chatMore;

  /// خيار نقل المحادثة إلى الأرشيف
  ///
  /// In ar, this message translates to:
  /// **'نقل إلى الأرشيف'**
  String get chatMoveToArchive;

  /// خيار نقل المحادثة إلى مجلد
  ///
  /// In ar, this message translates to:
  /// **'نقل إلى مجلد'**
  String get chatMoveToFolder;

  /// عنوان حوار حذف المحادثة
  ///
  /// In ar, this message translates to:
  /// **'حذف المحادثة'**
  String get chatDeleteChatTitle;

  /// رسالة تأكيد حذف المحادثة
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف المحادثة \"{title}\"?'**
  String chatDeleteChatMessage(String title);

  /// عنوان حوار نقل المحادثة إلى مجلد
  ///
  /// In ar, this message translates to:
  /// **'نقل إلى مجلد'**
  String get chatMoveToFolderTitle;

  /// رسالة عدم وجود مجلدات متاحة
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مجلدات متاحة'**
  String get chatNoFoldersAvailable;

  /// خيار عدم وجود مجلد
  ///
  /// In ar, this message translates to:
  /// **'بدون مجلد'**
  String get chatNoFolder;

  /// رسالة فتح المحادثة
  ///
  /// In ar, this message translates to:
  /// **'جاري فتح المحادثة: {title}'**
  String chatOpeningChat(String title);

  /// رسالة حذف المحادثة
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المحادثة: {title}'**
  String chatDeleted(String title);

  /// رسالة تحديث سجل المحادثات
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث سجل المحادثات'**
  String get chatHistoryUpdated;

  /// عنوان حوار حذف المجلد
  ///
  /// In ar, this message translates to:
  /// **'حذف المجلد'**
  String get chatDeleteFolderTitle;

  /// رسالة تأكيد حذف المجلد
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف مجلد \"{name}\"?'**
  String chatDeleteFolderMessage(String name);

  /// رسالة نجاح حذف المجلد
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المجلد بنجاح'**
  String get chatFolderDeletedSuccess;

  /// رسالة خطأ
  ///
  /// In ar, this message translates to:
  /// **'خطأ: {error}'**
  String chatError(String error);

  /// رسالة تحديد المرفق
  ///
  /// In ar, this message translates to:
  /// **'تم تحديد {type}'**
  String chatAttachmentSelected(String type);

  /// عنوان إعدادات المحادثة
  ///
  /// In ar, this message translates to:
  /// **'إعدادات المحادثة'**
  String get chatSettings;

  /// عنوان حوار إنشاء مجلد جديد
  ///
  /// In ar, this message translates to:
  /// **'إنشاء مجلد جديد'**
  String get chatCreateFolderTitle;

  /// زر الإنشاء
  ///
  /// In ar, this message translates to:
  /// **'إنشاء'**
  String get chatCreate;

  /// عنوان حوار تعديل المجلد
  ///
  /// In ar, this message translates to:
  /// **'تعديل المجلد'**
  String get chatEditFolderTitle;

  /// عنوان تغيير الأيقونة
  ///
  /// In ar, this message translates to:
  /// **'تغيير الأيقونة'**
  String get chatChangeIcon;

  /// إضافة المحادثة للمفضلة
  ///
  /// In ar, this message translates to:
  /// **'إضافة للمفضلة'**
  String get chatAddToFavorites;

  /// إزالة المحادثة من المفضلة
  ///
  /// In ar, this message translates to:
  /// **'إزالة من المفضلة'**
  String get chatRemoveFromFavorites;

  /// تثبيت المحادثة
  ///
  /// In ar, this message translates to:
  /// **'تثبيت'**
  String get chatPin;

  /// إلغاء تثبيت المحادثة
  ///
  /// In ar, this message translates to:
  /// **'إلغاء التثبيت'**
  String get chatUnpin;

  /// رسالة نجاح نقل المحادثة إلى مجلد
  ///
  /// In ar, this message translates to:
  /// **'تم نقل المحادثة إلى \"{folder}\" بنجاح'**
  String chatMoveToFolderSuccess(String folder);

  /// رسالة فشل نقل المحادثة
  ///
  /// In ar, this message translates to:
  /// **'فشل نقل المحادثة'**
  String get chatMoveToFolderFailed;

  /// رسالة نجاح نقل المحادثة إلى الأرشيف
  ///
  /// In ar, this message translates to:
  /// **'تم نقل المحادثة إلى الأرشيف بنجاح'**
  String get chatArchiveSuccess;

  /// رسالة فشل نقل المحادثة إلى الأرشيف
  ///
  /// In ar, this message translates to:
  /// **'فشل نقل المحادثة إلى الأرشيف'**
  String get chatArchiveFailed;

  /// رسالة نجاح حذف المحادثة
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المحادثة بنجاح'**
  String get chatDeleteSuccess;

  /// رسالة فشل حذف المحادثة
  ///
  /// In ar, this message translates to:
  /// **'فشل حذف المحادثة'**
  String get chatDeleteFailed;

  /// عنوان شاشة تغيير أيقونة المجلد
  ///
  /// In ar, this message translates to:
  /// **'تغيير أيقونة المجلد'**
  String get folderChangeIconTitle;

  /// عنوان قسم اختيار الأيقونة
  ///
  /// In ar, this message translates to:
  /// **'اختر الأيقونة'**
  String get folderSelectIcon;

  /// عنوان قسم اختيار اللون
  ///
  /// In ar, this message translates to:
  /// **'اختر اللون'**
  String get folderSelectColor;

  /// رسالة اللون المختار
  ///
  /// In ar, this message translates to:
  /// **'اللون المختار: {name}'**
  String folderSelectedColor(String name);

  /// اللون غير محدد
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get folderColorUndefined;

  /// رسالة جاري التطبيق
  ///
  /// In ar, this message translates to:
  /// **'جاري التطبيق...'**
  String get folderApplying;

  /// زر تطبيق الأيقونة
  ///
  /// In ar, this message translates to:
  /// **'تطبيق \"{name}\"'**
  String folderApplyIcon(String name);

  /// رسالة نجاح تغيير الأيقونة
  ///
  /// In ar, this message translates to:
  /// **'تم تغيير أيقونة المجلد \"{name}\" بنجاح'**
  String folderIconChangedSuccess(String name);

  /// اسم اللون الرمادي الفاتح
  ///
  /// In ar, this message translates to:
  /// **'رمادي فاتح'**
  String get folderColorGray;

  /// اسم اللون الأحمر
  ///
  /// In ar, this message translates to:
  /// **'أحمر'**
  String get folderColorRed;

  /// اسم اللون البرتقالي
  ///
  /// In ar, this message translates to:
  /// **'برتقالي'**
  String get folderColorOrange;

  /// اسم اللون الأصفر
  ///
  /// In ar, this message translates to:
  /// **'أصفر'**
  String get folderColorYellow;

  /// اسم اللون الأخضر
  ///
  /// In ar, this message translates to:
  /// **'أخضر'**
  String get folderColorGreen;

  /// اسم اللون الأزرق السماوي
  ///
  /// In ar, this message translates to:
  /// **'أزرق سماوي'**
  String get folderColorCyan;

  /// اسم اللون البنفسجي
  ///
  /// In ar, this message translates to:
  /// **'بنفسجي'**
  String get folderColorPurple;

  /// اسم اللون الوردي
  ///
  /// In ar, this message translates to:
  /// **'وردي'**
  String get folderColorPink;

  /// عنوان معاينة المجلد
  ///
  /// In ar, this message translates to:
  /// **'معاينة المجلد'**
  String get folderPreview;

  /// نص بديل لاسم المجلد
  ///
  /// In ar, this message translates to:
  /// **'اسم المجلد'**
  String get folderNamePlaceholder;

  /// تسمية حقل اسم المجلد
  ///
  /// In ar, this message translates to:
  /// **'اسم المجلد *'**
  String get folderNameLabel;

  /// نص تلميحي لحقل اسم المجلد
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم المجلد'**
  String get folderNameHint;

  /// رسالة خطأ: اسم المجلد مطلوب
  ///
  /// In ar, this message translates to:
  /// **'اسم المجلد مطلوب'**
  String get folderNameRequired;

  /// رسالة خطأ: الحد الأدنى لطول اسم المجلد
  ///
  /// In ar, this message translates to:
  /// **'اسم المجلد يجب أن يكون على الأقل حرفين'**
  String get folderNameMinLength;

  /// رسالة خطأ: الحد الأقصى لطول اسم المجلد
  ///
  /// In ar, this message translates to:
  /// **'اسم المجلد يجب ألا يتجاوز 50 حرفاً'**
  String get folderNameMaxLength;

  /// زر حفظ التعديلات
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get folderSaveChanges;

  /// زر إنشاء المجلد
  ///
  /// In ar, this message translates to:
  /// **'إنشاء المجلد'**
  String get folderCreate;

  /// رسالة نجاح إنشاء المجلد
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء المجلد بنجاح'**
  String get folderCreatedSuccess;

  /// رسالة نجاح تحديث المجلد
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث المجلد بنجاح'**
  String get folderUpdatedSuccess;

  /// اسم فئة الأيقونات العامة
  ///
  /// In ar, this message translates to:
  /// **'عام'**
  String get iconCategoryGeneral;

  /// اسم فئة أيقونات البرمجة
  ///
  /// In ar, this message translates to:
  /// **'البرمجة'**
  String get iconCategoryProgramming;

  /// اسم فئة أيقونات الرياضيات
  ///
  /// In ar, this message translates to:
  /// **'الرياضيات'**
  String get iconCategoryMathematics;

  /// اسم فئة أيقونات العلوم
  ///
  /// In ar, this message translates to:
  /// **'العلوم'**
  String get iconCategoryScience;

  /// اسم فئة أيقونات الدراسة
  ///
  /// In ar, this message translates to:
  /// **'الدراسة'**
  String get iconCategoryStudy;

  /// اسم فئة أيقونات الإبداع
  ///
  /// In ar, this message translates to:
  /// **'الإبداع'**
  String get iconCategoryCreativity;

  /// اسم فئة أيقونات العمل الجماعي
  ///
  /// In ar, this message translates to:
  /// **'العمل الجماعي'**
  String get iconCategoryCollaboration;

  /// اسم فئة أيقونات النظام
  ///
  /// In ar, this message translates to:
  /// **'النظام'**
  String get iconCategorySystem;

  /// اسم أيقونة مجلد عادي
  ///
  /// In ar, this message translates to:
  /// **'مجلد عادي'**
  String get iconFolderGeneral;

  /// اسم أيقونة نجمة
  ///
  /// In ar, this message translates to:
  /// **'نجمة'**
  String get iconFolderStar;

  /// اسم أيقونة قلب
  ///
  /// In ar, this message translates to:
  /// **'قلب'**
  String get iconFolderHeart;

  /// اسم أيقونة الرئيسية
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get iconFolderHome;

  /// اسم أيقونة مثبت
  ///
  /// In ar, this message translates to:
  /// **'مثبت'**
  String get iconFolderThumbtack;

  /// اسم أيقونة إضافة مجلد
  ///
  /// In ar, this message translates to:
  /// **'إضافة مجلد'**
  String get iconFolderPlus;

  /// اسم أيقونة مجلد مفتوح
  ///
  /// In ar, this message translates to:
  /// **'مجلد مفتوح'**
  String get iconFolderOpen;

  /// اسم أيقونة كود
  ///
  /// In ar, this message translates to:
  /// **'كود'**
  String get iconCode;

  /// اسم أيقونة لابتوب كود
  ///
  /// In ar, this message translates to:
  /// **'لابتوب كود'**
  String get iconLaptopCode;

  /// اسم أيقونة طرفية
  ///
  /// In ar, this message translates to:
  /// **'طرفية'**
  String get iconTerminal;

  /// اسم أيقونة خطأ برمجي
  ///
  /// In ar, this message translates to:
  /// **'خطأ برمجي'**
  String get iconBug;

  /// اسم أيقونة إعدادات
  ///
  /// In ar, this message translates to:
  /// **'إعدادات'**
  String get iconCogs;

  /// اسم أيقونة معالج
  ///
  /// In ar, this message translates to:
  /// **'معالج'**
  String get iconMicrochip;

  /// اسم أيقونة خادم
  ///
  /// In ar, this message translates to:
  /// **'خادم'**
  String get iconServer;

  /// اسم أيقونة شبكة
  ///
  /// In ar, this message translates to:
  /// **'شبكة'**
  String get iconNetworkWired;

  /// اسم أيقونة حماية
  ///
  /// In ar, this message translates to:
  /// **'حماية'**
  String get iconShieldAlt;

  /// اسم أيقونة مفتاح
  ///
  /// In ar, this message translates to:
  /// **'مفتاح'**
  String get iconKey;

  /// اسم أيقونة قاعدة بيانات
  ///
  /// In ar, this message translates to:
  /// **'قاعدة بيانات'**
  String get iconDatabase;

  /// اسم أيقونة جدول
  ///
  /// In ar, this message translates to:
  /// **'جدول'**
  String get iconTable;

  /// اسم أيقونة رسم بياني
  ///
  /// In ar, this message translates to:
  /// **'رسم بياني'**
  String get iconChartBar;

  /// اسم أيقونة جوال
  ///
  /// In ar, this message translates to:
  /// **'جوال'**
  String get iconMobileAlt;

  /// اسم أيقونة عالمي
  ///
  /// In ar, this message translates to:
  /// **'عالمي'**
  String get iconGlobe;

  /// اسم أيقونة سحابة
  ///
  /// In ar, this message translates to:
  /// **'سحابة'**
  String get iconCloud;

  /// اسم أيقونة روبوت
  ///
  /// In ar, this message translates to:
  /// **'روبوت'**
  String get iconRobot;

  /// اسم أيقونة دماغ
  ///
  /// In ar, this message translates to:
  /// **'دماغ'**
  String get iconBrain;

  /// اسم أيقونة خريطة موقع
  ///
  /// In ar, this message translates to:
  /// **'خريطة موقع'**
  String get iconSitemap;

  /// اسم أيقونة مخطط مشروع
  ///
  /// In ar, this message translates to:
  /// **'مخطط مشروع'**
  String get iconProjectDiagram;

  /// اسم أيقونة ملف كود
  ///
  /// In ar, this message translates to:
  /// **'ملف كود'**
  String get iconFileCode;

  /// اسم أيقونة فرع كود
  ///
  /// In ar, this message translates to:
  /// **'فرع كود'**
  String get iconCodeBranch;

  /// اسم أيقونة دمج كود
  ///
  /// In ar, this message translates to:
  /// **'دمج كود'**
  String get iconCodeMerge;

  /// اسم أيقونة مقارنة كود
  ///
  /// In ar, this message translates to:
  /// **'مقارنة كود'**
  String get iconCodeCompare;

  /// اسم أيقونة آلة حاسبة
  ///
  /// In ar, this message translates to:
  /// **'آلة حاسبة'**
  String get iconCalculator;

  /// اسم أيقونة جذر تربيعي
  ///
  /// In ar, this message translates to:
  /// **'جذر تربيعي'**
  String get iconSquareRootAlt;

  /// اسم أيقونة لانهاية
  ///
  /// In ar, this message translates to:
  /// **'لانهاية'**
  String get iconInfinity;

  /// اسم أيقونة نسبة مئوية
  ///
  /// In ar, this message translates to:
  /// **'نسبة مئوية'**
  String get iconPercentage;

  /// اسم أيقونة رسم خطي
  ///
  /// In ar, this message translates to:
  /// **'رسم خطي'**
  String get iconChartLine;

  /// اسم أيقونة رسم دائري
  ///
  /// In ar, this message translates to:
  /// **'رسم دائري'**
  String get iconChartPie;

  /// اسم أيقونة رسم مساحي
  ///
  /// In ar, this message translates to:
  /// **'رسم مساحي'**
  String get iconChartArea;

  /// اسم أيقونة ترتيب تصاعدي
  ///
  /// In ar, this message translates to:
  /// **'ترتيب تصاعدي'**
  String get iconSortNumericUp;

  /// اسم أيقونة ترتيب تنازلي
  ///
  /// In ar, this message translates to:
  /// **'ترتيب تنازلي'**
  String get iconSortNumericDown;

  /// اسم أيقونة يساوي
  ///
  /// In ar, this message translates to:
  /// **'يساوي'**
  String get iconEquals;

  /// اسم أيقونة زائد
  ///
  /// In ar, this message translates to:
  /// **'زائد'**
  String get iconPlus;

  /// اسم أيقونة ناقص
  ///
  /// In ar, this message translates to:
  /// **'ناقص'**
  String get iconMinus;

  /// اسم أيقونة ضرب
  ///
  /// In ar, this message translates to:
  /// **'ضرب'**
  String get iconTimes;

  /// اسم أيقونة قسمة
  ///
  /// In ar, this message translates to:
  /// **'قسمة'**
  String get iconDivide;

  /// اسم أيقونة أس علوي
  ///
  /// In ar, this message translates to:
  /// **'أس علوي'**
  String get iconSuperscript;

  /// اسم أيقونة أس سفلي
  ///
  /// In ar, this message translates to:
  /// **'أس سفلي'**
  String get iconSubscript;

  /// اسم أيقونة سيجما
  ///
  /// In ar, this message translates to:
  /// **'سيجما'**
  String get iconSigma;

  /// اسم أيقونة باي
  ///
  /// In ar, this message translates to:
  /// **'باي'**
  String get iconPi;

  /// اسم أيقونة دالة
  ///
  /// In ar, this message translates to:
  /// **'دالة'**
  String get iconFunction;

  /// اسم أيقونة تكامل
  ///
  /// In ar, this message translates to:
  /// **'تكامل'**
  String get iconIntegral;

  /// اسم أيقونة مثلث
  ///
  /// In ar, this message translates to:
  /// **'مثلث'**
  String get iconTriangle;

  /// اسم أيقونة أوميغا
  ///
  /// In ar, this message translates to:
  /// **'أوميغا'**
  String get iconOmega;

  /// اسم أيقونة ثيتا
  ///
  /// In ar, this message translates to:
  /// **'ثيتا'**
  String get iconTheta;

  /// اسم أيقونة ذرة
  ///
  /// In ar, this message translates to:
  /// **'ذرة'**
  String get iconAtom;

  /// اسم أيقونة قارورة
  ///
  /// In ar, this message translates to:
  /// **'قارورة'**
  String get iconFlask;

  /// اسم أيقونة مجهر
  ///
  /// In ar, this message translates to:
  /// **'مجهر'**
  String get iconMicroscope;

  /// اسم أيقونة DNA
  ///
  /// In ar, this message translates to:
  /// **'DNA'**
  String get iconDna;

  /// اسم أيقونة ورقة
  ///
  /// In ar, this message translates to:
  /// **'ورقة'**
  String get iconLeaf;

  /// اسم أيقونة نبتة
  ///
  /// In ar, this message translates to:
  /// **'نبتة'**
  String get iconSeedling;

  /// اسم أيقونة قطرة
  ///
  /// In ar, this message translates to:
  /// **'قطرة'**
  String get iconDroplet;

  /// اسم أيقونة نار
  ///
  /// In ar, this message translates to:
  /// **'نار'**
  String get iconFire;

  /// اسم أيقونة برق
  ///
  /// In ar, this message translates to:
  /// **'برق'**
  String get iconBolt;

  /// اسم أيقونة مغناطيس
  ///
  /// In ar, this message translates to:
  /// **'مغناطيس'**
  String get iconMagnet;

  /// اسم أيقونة قمر صناعي
  ///
  /// In ar, this message translates to:
  /// **'قمر صناعي'**
  String get iconSatellite;

  /// اسم أيقونة صاروخ
  ///
  /// In ar, this message translates to:
  /// **'صاروخ'**
  String get iconRocket;

  /// اسم أيقونة شمس
  ///
  /// In ar, this message translates to:
  /// **'شمس'**
  String get iconSun;

  /// اسم أيقونة قمر
  ///
  /// In ar, this message translates to:
  /// **'قمر'**
  String get iconMoon;

  /// اسم أيقونة نجمة
  ///
  /// In ar, this message translates to:
  /// **'نجمة'**
  String get iconStar;

  /// اسم أيقونة تلسكوب
  ///
  /// In ar, this message translates to:
  /// **'تلسكوب'**
  String get iconTelescope;

  /// اسم أيقونة أنبوب اختبار
  ///
  /// In ar, this message translates to:
  /// **'أنبوب اختبار'**
  String get iconVial;

  /// اسم أيقونة أقراص
  ///
  /// In ar, this message translates to:
  /// **'أقراص'**
  String get iconPills;

  /// اسم أيقونة سماعة طبية
  ///
  /// In ar, this message translates to:
  /// **'سماعة طبية'**
  String get iconStethoscope;

  /// اسم أيقونة نبض
  ///
  /// In ar, this message translates to:
  /// **'نبض'**
  String get iconHeartbeat;

  /// اسم أيقونة عين
  ///
  /// In ar, this message translates to:
  /// **'عين'**
  String get iconEye;

  /// اسم أيقونة أذن
  ///
  /// In ar, this message translates to:
  /// **'أذن'**
  String get iconEar;

  /// اسم أيقونة أنف
  ///
  /// In ar, this message translates to:
  /// **'أنف'**
  String get iconNose;

  /// اسم أيقونة سن
  ///
  /// In ar, this message translates to:
  /// **'سن'**
  String get iconTooth;

  /// اسم أيقونة عظم
  ///
  /// In ar, this message translates to:
  /// **'عظم'**
  String get iconBone;

  /// اسم أيقونة رئتان
  ///
  /// In ar, this message translates to:
  /// **'رئتان'**
  String get iconLungs;

  /// اسم أيقونة كبد
  ///
  /// In ar, this message translates to:
  /// **'كبد'**
  String get iconLiver;

  /// اسم أيقونة كلية
  ///
  /// In ar, this message translates to:
  /// **'كلية'**
  String get iconKidney;

  /// اسم أيقونة معدة
  ///
  /// In ar, this message translates to:
  /// **'معدة'**
  String get iconStomach;

  /// اسم أيقونة أمعاء
  ///
  /// In ar, this message translates to:
  /// **'أمعاء'**
  String get iconIntestines;

  /// اسم أيقونة قبعة تخرج
  ///
  /// In ar, this message translates to:
  /// **'قبعة تخرج'**
  String get iconGraduationCap;

  /// اسم أيقونة كتاب
  ///
  /// In ar, this message translates to:
  /// **'كتاب'**
  String get iconBook;

  /// اسم أيقونة كتاب مفتوح
  ///
  /// In ar, this message translates to:
  /// **'كتاب مفتوح'**
  String get iconBookOpen;

  /// اسم أيقونة قلم
  ///
  /// In ar, this message translates to:
  /// **'قلم'**
  String get iconPen;

  /// اسم أيقونة قلم رصاص
  ///
  /// In ar, this message translates to:
  /// **'قلم رصاص'**
  String get iconPencilAlt;

  /// اسم أيقونة قلم تمييز
  ///
  /// In ar, this message translates to:
  /// **'قلم تمييز'**
  String get iconHighlighter;

  /// اسم أيقونة ملاحظة
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة'**
  String get iconStickyNote;

  /// اسم أيقونة لوح
  ///
  /// In ar, this message translates to:
  /// **'لوح'**
  String get iconClipboard;

  /// اسم أيقونة ملف
  ///
  /// In ar, this message translates to:
  /// **'ملف'**
  String get iconFileAlt;

  /// اسم أيقونة أرشيف
  ///
  /// In ar, this message translates to:
  /// **'أرشيف'**
  String get iconArchive;

  /// اسم أيقونة تقويم
  ///
  /// In ar, this message translates to:
  /// **'تقويم'**
  String get iconCalendarAlt;

  /// اسم أيقونة ساعة
  ///
  /// In ar, this message translates to:
  /// **'ساعة'**
  String get iconClock;

  /// اسم أيقونة ساعة توقيت
  ///
  /// In ar, this message translates to:
  /// **'ساعة توقيت'**
  String get iconStopwatch;

  /// اسم أيقونة ساعة رملية
  ///
  /// In ar, this message translates to:
  /// **'ساعة رملية'**
  String get iconHourglassHalf;

  /// اسم أيقونة جرس
  ///
  /// In ar, this message translates to:
  /// **'جرس'**
  String get iconBell;

  /// اسم أيقونة علم
  ///
  /// In ar, this message translates to:
  /// **'علم'**
  String get iconFlag;

  /// اسم أيقونة كأس
  ///
  /// In ar, this message translates to:
  /// **'كأس'**
  String get iconTrophy;

  /// اسم أيقونة ميدالية
  ///
  /// In ar, this message translates to:
  /// **'ميدالية'**
  String get iconMedal;

  /// اسم أيقونة شهادة
  ///
  /// In ar, this message translates to:
  /// **'شهادة'**
  String get iconCertificate;

  /// اسم أيقونة جائزة
  ///
  /// In ar, this message translates to:
  /// **'جائزة'**
  String get iconAward;

  /// اسم أيقونة طالب
  ///
  /// In ar, this message translates to:
  /// **'طالب'**
  String get iconUserGraduate;

  /// اسم أيقونة معلم
  ///
  /// In ar, this message translates to:
  /// **'معلم'**
  String get iconChalkboardTeacher;

  /// اسم أيقونة سبورة
  ///
  /// In ar, this message translates to:
  /// **'سبورة'**
  String get iconChalkboard;

  /// اسم أيقونة بحث
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get iconSearch;

  /// اسم أيقونة سؤال
  ///
  /// In ar, this message translates to:
  /// **'سؤال'**
  String get iconQuestionCircle;

  /// اسم أيقونة فكرة
  ///
  /// In ar, this message translates to:
  /// **'فكرة'**
  String get iconLightbulb;

  /// اسم أيقونة صندوق وارد
  ///
  /// In ar, this message translates to:
  /// **'صندوق وارد'**
  String get iconInbox;

  /// اسم أيقونة لوحة ألوان
  ///
  /// In ar, this message translates to:
  /// **'لوحة ألوان'**
  String get iconPalette;

  /// اسم أيقونة فرشاة
  ///
  /// In ar, this message translates to:
  /// **'فرشاة'**
  String get iconPaintBrush;

  /// اسم أيقونة سحر
  ///
  /// In ar, this message translates to:
  /// **'سحر'**
  String get iconMagic;

  /// اسم أيقونة شرارات
  ///
  /// In ar, this message translates to:
  /// **'شرارات'**
  String get iconSparkles;

  /// اسم أيقونة قطارة
  ///
  /// In ar, this message translates to:
  /// **'قطارة'**
  String get iconEyeDropper;

  /// اسم أيقونة كاميرا
  ///
  /// In ar, this message translates to:
  /// **'كاميرا'**
  String get iconCamera;

  /// اسم أيقونة فيديو
  ///
  /// In ar, this message translates to:
  /// **'فيديو'**
  String get iconVideo;

  /// اسم أيقونة موسيقى
  ///
  /// In ar, this message translates to:
  /// **'موسيقى'**
  String get iconMusic;

  /// اسم أيقونة سماعات
  ///
  /// In ar, this message translates to:
  /// **'سماعات'**
  String get iconHeadphones;

  /// اسم أيقونة جهاز ألعاب
  ///
  /// In ar, this message translates to:
  /// **'جهاز ألعاب'**
  String get iconGamepad;

  /// اسم أيقونة نرد
  ///
  /// In ar, this message translates to:
  /// **'نرد'**
  String get iconDice;

  /// اسم أيقونة قطعة أحجية
  ///
  /// In ar, this message translates to:
  /// **'قطعة أحجية'**
  String get iconPuzzlePiece;

  /// اسم أيقونة مكعب
  ///
  /// In ar, this message translates to:
  /// **'مكعب'**
  String get iconCube;

  /// اسم أيقونة جوهرة
  ///
  /// In ar, this message translates to:
  /// **'جوهرة'**
  String get iconGem;

  /// اسم أيقونة تاج
  ///
  /// In ar, this message translates to:
  /// **'تاج'**
  String get iconCrown;

  /// اسم أيقونة شريط
  ///
  /// In ar, this message translates to:
  /// **'شريط'**
  String get iconRibbon;

  /// اسم أيقونة مستخدمون
  ///
  /// In ar, this message translates to:
  /// **'مستخدمون'**
  String get iconUsers;

  /// اسم أيقونة أصدقاء
  ///
  /// In ar, this message translates to:
  /// **'أصدقاء'**
  String get iconUserFriends;

  /// اسم أيقونة مصافحة
  ///
  /// In ar, this message translates to:
  /// **'مصافحة'**
  String get iconHandshake;

  /// اسم أيقونة تعليقات
  ///
  /// In ar, this message translates to:
  /// **'تعليقات'**
  String get iconComments;

  /// اسم أيقونة تعليق
  ///
  /// In ar, this message translates to:
  /// **'تعليق'**
  String get iconCommentDots;

  /// اسم أيقونة ظرف
  ///
  /// In ar, this message translates to:
  /// **'ظرف'**
  String get iconEnvelope;

  /// اسم أيقونة هاتف
  ///
  /// In ar, this message translates to:
  /// **'هاتف'**
  String get iconPhone;

  /// اسم أيقونة كاميرا فيديو
  ///
  /// In ar, this message translates to:
  /// **'كاميرا فيديو'**
  String get iconVideoCamera;

  /// اسم أيقونة مشاركة
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get iconShareAlt;

  /// اسم أيقونة رابط
  ///
  /// In ar, this message translates to:
  /// **'رابط'**
  String get iconLink;

  /// اسم أيقونة مزامنة
  ///
  /// In ar, this message translates to:
  /// **'مزامنة'**
  String get iconSync;

  /// اسم أيقونة تحميل
  ///
  /// In ar, this message translates to:
  /// **'تحميل'**
  String get iconDownload;

  /// اسم أيقونة رفع
  ///
  /// In ar, this message translates to:
  /// **'رفع'**
  String get iconUpload;

  /// اسم أيقونة طباعة
  ///
  /// In ar, this message translates to:
  /// **'طباعة'**
  String get iconPrint;

  /// اسم أيقونة نسخ
  ///
  /// In ar, this message translates to:
  /// **'نسخ'**
  String get iconCopy;

  /// اسم أيقونة طائرة ورقية
  ///
  /// In ar, this message translates to:
  /// **'طائرة ورقية'**
  String get iconPaperPlane;

  /// اسم أيقونة إرسال
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get iconSend;

  /// اسم أيقونة إيقاف التنبيهات
  ///
  /// In ar, this message translates to:
  /// **'إيقاف التنبيهات'**
  String get iconBellSlash;

  /// اسم أيقونة محادثة
  ///
  /// In ar, this message translates to:
  /// **'محادثة'**
  String get iconChat;

  /// اسم أيقونة رسالة
  ///
  /// In ar, this message translates to:
  /// **'رسالة'**
  String get iconMessage;

  /// اسم أيقونة رد
  ///
  /// In ar, this message translates to:
  /// **'رد'**
  String get iconReply;

  /// اسم أيقونة مشاركة
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get iconShare;

  /// اسم أيقونة مرفق
  ///
  /// In ar, this message translates to:
  /// **'مرفق'**
  String get iconAttach;

  /// اسم أيقونة صورة
  ///
  /// In ar, this message translates to:
  /// **'صورة'**
  String get iconImage;

  /// اسم أيقونة ملف
  ///
  /// In ar, this message translates to:
  /// **'ملف'**
  String get iconFile;

  /// اسم أيقونة مشبك ورق
  ///
  /// In ar, this message translates to:
  /// **'مشبك ورق'**
  String get iconPaperclip;

  /// اسم أيقونة إعدادات
  ///
  /// In ar, this message translates to:
  /// **'إعدادات'**
  String get iconSettings;

  /// اسم أيقونة ترس
  ///
  /// In ar, this message translates to:
  /// **'ترس'**
  String get iconCog;

  /// اسم أيقونة درع
  ///
  /// In ar, this message translates to:
  /// **'درع'**
  String get iconShield;

  /// اسم أيقونة معلومات
  ///
  /// In ar, this message translates to:
  /// **'معلومات'**
  String get iconInfo;

  /// اسم أيقونة مساعدة
  ///
  /// In ar, this message translates to:
  /// **'مساعدة'**
  String get iconHelp;

  /// اسم أيقونة سؤال
  ///
  /// In ar, this message translates to:
  /// **'سؤال'**
  String get iconQuestion;

  /// اسم أيقونة صح
  ///
  /// In ar, this message translates to:
  /// **'صح'**
  String get iconCheck;

  /// اسم أيقونة تحذير
  ///
  /// In ar, this message translates to:
  /// **'تحذير'**
  String get iconWarning;

  /// اسم أيقونة خطأ
  ///
  /// In ar, this message translates to:
  /// **'خطأ'**
  String get iconError;

  /// اسم أيقونة معلومات
  ///
  /// In ar, this message translates to:
  /// **'معلومات'**
  String get iconInfoCircle;

  /// اسم أيقونة تعجب
  ///
  /// In ar, this message translates to:
  /// **'تعجب'**
  String get iconExclamation;

  /// اسم أيقونة مثلث تحذير
  ///
  /// In ar, this message translates to:
  /// **'مثلث تحذير'**
  String get iconExclamationTriangle;

  /// اسم أيقونة مستخدم
  ///
  /// In ar, this message translates to:
  /// **'مستخدم'**
  String get iconUser;

  /// اسم أيقونة قفل
  ///
  /// In ar, this message translates to:
  /// **'قفل'**
  String get iconLock;

  /// اسم أيقونة تسجيل دخول
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دخول'**
  String get iconSignIn;

  /// اسم أيقونة تسجيل خروج
  ///
  /// In ar, this message translates to:
  /// **'تسجيل خروج'**
  String get iconSignOut;

  /// اسم أيقونة تعديل
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get iconEdit;

  /// اسم أيقونة حذف
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get iconDelete;

  /// اسم أيقونة سلة
  ///
  /// In ar, this message translates to:
  /// **'سلة'**
  String get iconTrash;

  /// اسم أيقونة حفظ
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get iconSave;

  /// اسم أيقونة تاريخ
  ///
  /// In ar, this message translates to:
  /// **'تاريخ'**
  String get iconHistory;

  /// اسم أيقونة قفل
  ///
  /// In ar, this message translates to:
  /// **'قفل'**
  String get iconLockKeyhole;

  /// اسم أيقونة فتح
  ///
  /// In ar, this message translates to:
  /// **'فتح'**
  String get iconUnlock;

  /// اسم أيقونة ميكروفون
  ///
  /// In ar, this message translates to:
  /// **'ميكروفون'**
  String get iconMicrophone;

  /// اسم أيقونة ملف كود
  ///
  /// In ar, this message translates to:
  /// **'ملف كود'**
  String get iconFileCodeIcon;

  /// اسم أيقونة قائمة
  ///
  /// In ar, this message translates to:
  /// **'قائمة'**
  String get iconList;

  /// اسم أيقونة شبكة
  ///
  /// In ar, this message translates to:
  /// **'شبكة'**
  String get iconGrid;

  /// اسم أيقونة شبكة كبيرة
  ///
  /// In ar, this message translates to:
  /// **'شبكة كبيرة'**
  String get iconThLarge;

  /// اسم أيقونة أشرطة
  ///
  /// In ar, this message translates to:
  /// **'أشرطة'**
  String get iconBars;

  /// اسم أيقونة قائمة
  ///
  /// In ar, this message translates to:
  /// **'قائمة'**
  String get iconMenu;

  /// اسم أيقونة تصفية
  ///
  /// In ar, this message translates to:
  /// **'تصفية'**
  String get iconFilter;

  /// اسم أيقونة ترتيب
  ///
  /// In ar, this message translates to:
  /// **'ترتيب'**
  String get iconSort;

  /// اسم أيقونة تحديث
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get iconRefresh;

  /// اسم أيقونة رجوع
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get iconBack;

  /// اسم أيقونة التالي
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get iconNext;

  /// اسم أيقونة السابق
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get iconPrevious;

  /// اسم أيقونة إغلاق
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get iconClose;

  /// اسم أيقونة نقاط
  ///
  /// In ar, this message translates to:
  /// **'نقاط'**
  String get iconEllipsis;

  /// اسم أيقونة نقاط أفقية
  ///
  /// In ar, this message translates to:
  /// **'نقاط أفقية'**
  String get iconEllipsisH;

  /// اسم أيقونة نقاط عمودية
  ///
  /// In ar, this message translates to:
  /// **'نقاط عمودية'**
  String get iconEllipsisV;

  /// اسم أيقونة سهم علوي
  ///
  /// In ar, this message translates to:
  /// **'سهم علوي'**
  String get iconChevronUp;

  /// اسم أيقونة سهم سفلي
  ///
  /// In ar, this message translates to:
  /// **'سهم سفلي'**
  String get iconChevronDown;

  /// اسم أيقونة سهم يسار
  ///
  /// In ar, this message translates to:
  /// **'سهم يسار'**
  String get iconChevronLeft;

  /// اسم أيقونة سهم يمين
  ///
  /// In ar, this message translates to:
  /// **'سهم يمين'**
  String get iconChevronRight;

  /// اسم أيقونة زاوية علوية
  ///
  /// In ar, this message translates to:
  /// **'زاوية علوية'**
  String get iconAngleUp;

  /// اسم أيقونة زاوية سفلية
  ///
  /// In ar, this message translates to:
  /// **'زاوية سفلية'**
  String get iconAngleDown;

  /// اسم أيقونة زاوية يسارية
  ///
  /// In ar, this message translates to:
  /// **'زاوية يسارية'**
  String get iconAngleLeft;

  /// اسم أيقونة زاوية يمينية
  ///
  /// In ar, this message translates to:
  /// **'زاوية يمينية'**
  String get iconAngleRight;

  /// اسم أيقونة زوايا علوية
  ///
  /// In ar, this message translates to:
  /// **'زوايا علوية'**
  String get iconAnglesUp;

  /// اسم أيقونة زوايا سفلية
  ///
  /// In ar, this message translates to:
  /// **'زوايا سفلية'**
  String get iconAnglesDown;

  /// اسم أيقونة توسيع
  ///
  /// In ar, this message translates to:
  /// **'توسيع'**
  String get iconUpRightAndDownLeftFromCenter;

  /// اسم أيقونة طي
  ///
  /// In ar, this message translates to:
  /// **'طي'**
  String get iconDownLeftAndUpRightToCenter;

  /// اسم أيقونة تشغيل
  ///
  /// In ar, this message translates to:
  /// **'تشغيل'**
  String get iconPlay;

  /// اسم أيقونة إيقاف
  ///
  /// In ar, this message translates to:
  /// **'إيقاف'**
  String get iconPause;

  /// اسم أيقونة إيقاف
  ///
  /// In ar, this message translates to:
  /// **'إيقاف'**
  String get iconStop;

  /// اسم أيقونة فيلم
  ///
  /// In ar, this message translates to:
  /// **'فيلم'**
  String get iconFilm;

  /// اسم أيقونة ملف نصي
  ///
  /// In ar, this message translates to:
  /// **'ملف نصي'**
  String get iconFileText;

  /// اسم أيقونة ملف
  ///
  /// In ar, this message translates to:
  /// **'ملف'**
  String get iconFileLines;

  /// اسم أيقونة سهم يسار
  ///
  /// In ar, this message translates to:
  /// **'سهم يسار'**
  String get iconArrowLeft;

  /// اسم أيقونة سهم يمين
  ///
  /// In ar, this message translates to:
  /// **'سهم يمين'**
  String get iconArrowRight;

  /// اسم أيقونة سهم أعلى
  ///
  /// In ar, this message translates to:
  /// **'سهم أعلى'**
  String get iconArrowUp;

  /// اسم أيقونة سهم أسفل
  ///
  /// In ar, this message translates to:
  /// **'سهم أسفل'**
  String get iconArrowDown;

  /// اسم أيقونة سهم منعطف
  ///
  /// In ar, this message translates to:
  /// **'سهم منعطف'**
  String get iconArrowTurnUpLeft;

  /// اسم أيقونة سهم منعطف
  ///
  /// In ar, this message translates to:
  /// **'سهم منعطف'**
  String get iconArrowTurnUpRight;

  /// اسم أيقونة سهم منعطف
  ///
  /// In ar, this message translates to:
  /// **'سهم منعطف'**
  String get iconArrowTurnDownLeft;

  /// اسم أيقونة سهم منعطف
  ///
  /// In ar, this message translates to:
  /// **'سهم منعطف'**
  String get iconArrowTurnDownRight;

  /// اسم أيقونة إغلاق
  ///
  /// In ar, this message translates to:
  /// **'إغلاق'**
  String get iconXmark;

  /// اسم أيقونة صح دائري
  ///
  /// In ar, this message translates to:
  /// **'صح دائري'**
  String get iconCheckCircle;

  /// اسم أيقونة خطأ دائري
  ///
  /// In ar, this message translates to:
  /// **'خطأ دائري'**
  String get iconTimesCircle;

  /// اسم أيقونة معلومات دائري
  ///
  /// In ar, this message translates to:
  /// **'معلومات دائري'**
  String get iconInfoCircleIcon;

  /// اسم أيقونة تعجب دائري
  ///
  /// In ar, this message translates to:
  /// **'تعجب دائري'**
  String get iconExclamationCircle;

  /// رسالة الترحيب في شاشة المحادثة
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في مساعد كفو!'**
  String get chatWelcome;

  /// نص الترحيب في شاشة المحادثة
  ///
  /// In ar, this message translates to:
  /// **'أنا مساعدك الذكي. يمكنني مساعدتك في المذاكرة، الشؤون الأكاديمية، وحل المشاكل الدراسية.'**
  String get chatWelcomeMessage;

  /// عنوان بطاقة اقتراح المقررات الدراسية
  ///
  /// In ar, this message translates to:
  /// **'المقررات الدراسية'**
  String get chatSuggestionCourses;

  /// وصف بطاقة اقتراح المقررات الدراسية
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في أحد المقررات الدراسية'**
  String get chatSuggestionCoursesSubtitle;

  /// رسالة اقتراح المقررات الدراسية
  ///
  /// In ar, this message translates to:
  /// **'أريد مساعدة في حل مشكلة برمجية'**
  String get chatSuggestionCoursesAction;

  /// عنوان بطاقة اقتراح الجداول الدراسية
  ///
  /// In ar, this message translates to:
  /// **'الجداول الدراسية'**
  String get chatSuggestionSchedules;

  /// وصف بطاقة اقتراح الجداول الدراسية
  ///
  /// In ar, this message translates to:
  /// **'معرفة مواعيد الامتحانات والمحاضرات'**
  String get chatSuggestionSchedulesSubtitle;

  /// رسالة اقتراح الجداول الدراسية
  ///
  /// In ar, this message translates to:
  /// **'متى موعد الامتحانات النهائية؟'**
  String get chatSuggestionSchedulesAction;

  /// عنوان بطاقة اقتراح الدرجات والتقديرات
  ///
  /// In ar, this message translates to:
  /// **'الدرجات والتقديرات'**
  String get chatSuggestionGrades;

  /// وصف بطاقة اقتراح الدرجات والتقديرات
  ///
  /// In ar, this message translates to:
  /// **'الاستعلام عن النتائج والدرجات'**
  String get chatSuggestionGradesSubtitle;

  /// رسالة اقتراح الدرجات والتقديرات
  ///
  /// In ar, this message translates to:
  /// **'كيف أستعلم عن درجاتي؟'**
  String get chatSuggestionGradesAction;

  /// عنوان بطاقة اقتراح الشؤون الأكاديمية
  ///
  /// In ar, this message translates to:
  /// **'الشؤون الأكاديمية'**
  String get chatSuggestionAcademic;

  /// وصف بطاقة اقتراح الشؤون الأكاديمية
  ///
  /// In ar, this message translates to:
  /// **'الاستفسار عن الشؤون الأكاديمية'**
  String get chatSuggestionAcademicSubtitle;

  /// رسالة اقتراح الشؤون الأكاديمية
  ///
  /// In ar, this message translates to:
  /// **'أريد أن أستفسر عن موضوع بخصوص الحضور'**
  String get chatSuggestionAcademicAction;

  /// عنوان زر الإجراء السريع للبرمجة
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في البرمجة'**
  String get chatQuickActionProgramming;

  /// رسالة زر الإجراء السريع للبرمجة
  ///
  /// In ar, this message translates to:
  /// **'أحتاج مساعدة في حل مشكلة برمجية'**
  String get chatQuickActionProgrammingAction;

  /// عنوان زر الإجراء السريع للمواعيد الأكاديمية
  ///
  /// In ar, this message translates to:
  /// **'المواعيد الأكاديمية'**
  String get chatQuickActionAcademicDates;

  /// رسالة زر الإجراء السريع للمواعيد الأكاديمية
  ///
  /// In ar, this message translates to:
  /// **'ما هي المواعيد المهمة للفصل الدراسي؟'**
  String get chatQuickActionAcademicDatesAction;

  /// عنوان زر الإجراء السريع لنصائح البرمجة
  ///
  /// In ar, this message translates to:
  /// **'نصائح البرمجة'**
  String get chatQuickActionProgrammingTips;

  /// رسالة زر الإجراء السريع لنصائح البرمجة
  ///
  /// In ar, this message translates to:
  /// **'كيف أحسن مهاراتي في البرمجة؟'**
  String get chatQuickActionProgrammingTipsAction;

  /// عنوان زر الإجراء السريع لهياكل البيانات
  ///
  /// In ar, this message translates to:
  /// **'هياكل البيانات'**
  String get chatQuickActionDataStructures;

  /// رسالة زر الإجراء السريع لهياكل البيانات
  ///
  /// In ar, this message translates to:
  /// **'أحتاج شرح لهياكل البيانات'**
  String get chatQuickActionDataStructuresAction;

  /// نص توضيحي لحقل البحث في الرسائل
  ///
  /// In ar, this message translates to:
  /// **'البحث في الرسائل...'**
  String get chatSearchInMessages;

  /// رسالة عدم وجود نتائج بحث
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نتائج بحث'**
  String get chatNoSearchResults;

  /// نص توضيحي لحقل إدخال الرسالة
  ///
  /// In ar, this message translates to:
  /// **'اكتب رسالتك هنا...'**
  String get chatWriteYourMessage;

  /// عنوان قسم المجلدات
  ///
  /// In ar, this message translates to:
  /// **'المجلدات'**
  String get chatFolders;

  /// خيار عرض جميع المحادثات
  ///
  /// In ar, this message translates to:
  /// **'جميع المحادثات'**
  String get chatAllChats;

  /// رسالة عدم وجود مجلدات
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مجلدات'**
  String get chatNoFolders;

  /// زر حذف
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get chatDelete;

  /// عنوان قسم البحث والإعدادات
  ///
  /// In ar, this message translates to:
  /// **'البحث والإعدادات'**
  String get chatSearchAndSettings;

  /// نص توضيحي لحقل البحث في المحادثات
  ///
  /// In ar, this message translates to:
  /// **'البحث في المحادثات...'**
  String get chatSearchInChats;

  /// عنوان خيار البحث بالتاريخ
  ///
  /// In ar, this message translates to:
  /// **'البحث بالتاريخ'**
  String get chatSearchByDate;

  /// وصف خيار البحث بالتاريخ
  ///
  /// In ar, this message translates to:
  /// **'البحث في المحادثات حسب التاريخ'**
  String get chatSearchByDateSubtitle;

  /// عنوان خيار البحث بالمجلد
  ///
  /// In ar, this message translates to:
  /// **'البحث بالمجلد'**
  String get chatSearchByFolder;

  /// وصف خيار البحث بالمجلد
  ///
  /// In ar, this message translates to:
  /// **'البحث في محادثات مجلد معين'**
  String get chatSearchByFolderSubtitle;

  /// عنوان خيار البحث بالعلامات
  ///
  /// In ar, this message translates to:
  /// **'البحث بالعلامات'**
  String get chatSearchByTags;

  /// وصف خيار البحث بالعلامات
  ///
  /// In ar, this message translates to:
  /// **'البحث باستخدام العلامات والكلمات المفتاحية'**
  String get chatSearchByTagsSubtitle;

  /// عنوان قسم إعدادات المحادثة
  ///
  /// In ar, this message translates to:
  /// **'إعدادات المحادثة'**
  String get chatSettingsTitle;

  /// عنوان خيار الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get chatSettingsNotifications;

  /// وصف خيار الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الإشعارات'**
  String get chatSettingsNotificationsSubtitle;

  /// عنوان خيار المظهر
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get chatSettingsAppearance;

  /// وصف خيار المظهر
  ///
  /// In ar, this message translates to:
  /// **'تغيير مظهر التطبيق'**
  String get chatSettingsAppearanceSubtitle;

  /// عنوان خيار اللغة
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get chatSettingsLanguage;

  /// وصف خيار اللغة
  ///
  /// In ar, this message translates to:
  /// **'تغيير لغة التطبيق'**
  String get chatSettingsLanguageSubtitle;

  /// عنوان خيار النسخ الاحتياطي
  ///
  /// In ar, this message translates to:
  /// **'النسخ الاحتياطي'**
  String get chatSettingsBackup;

  /// وصف خيار النسخ الاحتياطي
  ///
  /// In ar, this message translates to:
  /// **'نسخ احتياطي للمحادثات'**
  String get chatSettingsBackupSubtitle;

  /// عنوان محادثة جديدة
  ///
  /// In ar, this message translates to:
  /// **'محادثة جديدة'**
  String get chatNewChat;

  /// عدد الرسائل في المحادثة
  ///
  /// In ar, this message translates to:
  /// **'{count} رسالة'**
  String chatMessageCount(int count);

  /// تاريخ آخر نشاط في المحادثة
  ///
  /// In ar, this message translates to:
  /// **'آخر نشاط: {date}'**
  String chatLastActivity(String date);

  /// عنوان بطاقة اقتراح الطب
  ///
  /// In ar, this message translates to:
  /// **'الطب'**
  String get chatSuggestionMedicine;

  /// وصف بطاقة اقتراح الطب
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في المواد الطبية والتشخيص'**
  String get chatSuggestionMedicineSubtitle;

  /// رسالة اقتراح الطب
  ///
  /// In ar, this message translates to:
  /// **'أحتاج شرحاً عن آلية عمل القلب والدورة الدموية'**
  String get chatSuggestionMedicineAction;

  /// عنوان بطاقة اقتراح الصيدلة
  ///
  /// In ar, this message translates to:
  /// **'الصيدلة'**
  String get chatSuggestionPharmacy;

  /// وصف بطاقة اقتراح الصيدلة
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في الأدوية والتفاعلات الدوائية'**
  String get chatSuggestionPharmacySubtitle;

  /// رسالة اقتراح الصيدلة
  ///
  /// In ar, this message translates to:
  /// **'ما هي التفاعلات الدوائية المحتملة بين الأسبرين والإيبوبروفين؟'**
  String get chatSuggestionPharmacyAction;

  /// عنوان بطاقة اقتراح العلوم الصحية
  ///
  /// In ar, this message translates to:
  /// **'العلوم الصحية'**
  String get chatSuggestionHealthSciences;

  /// وصف بطاقة اقتراح العلوم الصحية
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في العلوم الصحية والتغذية'**
  String get chatSuggestionHealthSciencesSubtitle;

  /// رسالة اقتراح العلوم الصحية
  ///
  /// In ar, this message translates to:
  /// **'ما هي العناصر الغذائية الأساسية للجسم؟'**
  String get chatSuggestionHealthSciencesAction;

  /// عنوان بطاقة اقتراح الهندسة
  ///
  /// In ar, this message translates to:
  /// **'الهندسة'**
  String get chatSuggestionEngineering;

  /// وصف بطاقة اقتراح الهندسة
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في المواد الهندسية والتصميم'**
  String get chatSuggestionEngineeringSubtitle;

  /// رسالة اقتراح الهندسة
  ///
  /// In ar, this message translates to:
  /// **'أحتاج شرحاً عن مبادئ الديناميكا الحرارية'**
  String get chatSuggestionEngineeringAction;

  /// عنوان بطاقة اقتراح علوم الحاسب
  ///
  /// In ar, this message translates to:
  /// **'علوم الحاسب'**
  String get chatSuggestionComputerScience;

  /// وصف بطاقة اقتراح علوم الحاسب
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في البرمجة والخوارزميات'**
  String get chatSuggestionComputerScienceSubtitle;

  /// رسالة اقتراح علوم الحاسب
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكن تحسين أداء خوارزمية البحث الثنائي؟'**
  String get chatSuggestionComputerScienceAction;

  /// عنوان بطاقة اقتراح الهندسة المدنية
  ///
  /// In ar, this message translates to:
  /// **'الهندسة المدنية'**
  String get chatSuggestionCivilEngineering;

  /// وصف بطاقة اقتراح الهندسة المدنية
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في الإنشاءات والبنية التحتية'**
  String get chatSuggestionCivilEngineeringSubtitle;

  /// رسالة اقتراح الهندسة المدنية
  ///
  /// In ar, this message translates to:
  /// **'ما هي العوامل المؤثرة في تصميم الجسور؟'**
  String get chatSuggestionCivilEngineeringAction;

  /// عنوان بطاقة اقتراح الآداب
  ///
  /// In ar, this message translates to:
  /// **'الآداب'**
  String get chatSuggestionArts;

  /// وصف بطاقة اقتراح الآداب
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في الأدب واللغة والنقد'**
  String get chatSuggestionArtsSubtitle;

  /// رسالة اقتراح الآداب
  ///
  /// In ar, this message translates to:
  /// **'ما هي خصائص الشعر الجاهلي؟'**
  String get chatSuggestionArtsAction;

  /// عنوان بطاقة اقتراح الدراسات الإسلامية
  ///
  /// In ar, this message translates to:
  /// **'الدراسات الإسلامية'**
  String get chatSuggestionIslamicStudies;

  /// وصف بطاقة اقتراح الدراسات الإسلامية
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في الفقه والتفسير والحديث'**
  String get chatSuggestionIslamicStudiesSubtitle;

  /// رسالة اقتراح الدراسات الإسلامية
  ///
  /// In ar, this message translates to:
  /// **'ما هو الفرق بين الفقه والأصول؟'**
  String get chatSuggestionIslamicStudiesAction;

  /// عنوان بطاقة اقتراح العلوم التربوية
  ///
  /// In ar, this message translates to:
  /// **'العلوم التربوية'**
  String get chatSuggestionEducation;

  /// وصف بطاقة اقتراح العلوم التربوية
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في التربية وطرق التدريس'**
  String get chatSuggestionEducationSubtitle;

  /// رسالة اقتراح العلوم التربوية
  ///
  /// In ar, this message translates to:
  /// **'ما هي أفضل طرق التدريس للطلاب ذوي صعوبات التعلم؟'**
  String get chatSuggestionEducationAction;

  /// عنوان بطاقة اقتراح إدارة الأعمال
  ///
  /// In ar, this message translates to:
  /// **'إدارة الأعمال'**
  String get chatSuggestionBusiness;

  /// وصف بطاقة اقتراح إدارة الأعمال
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في الإدارة والتسويق والتمويل'**
  String get chatSuggestionBusinessSubtitle;

  /// رسالة اقتراح إدارة الأعمال
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكن تحليل السوق المستهدف لمشروع جديد؟'**
  String get chatSuggestionBusinessAction;

  /// عنوان بطاقة اقتراح الاقتصاد
  ///
  /// In ar, this message translates to:
  /// **'الاقتصاد'**
  String get chatSuggestionEconomics;

  /// وصف بطاقة اقتراح الاقتصاد
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في الاقتصاد والمالية'**
  String get chatSuggestionEconomicsSubtitle;

  /// رسالة اقتراح الاقتصاد
  ///
  /// In ar, this message translates to:
  /// **'ما هو الفرق بين الاقتصاد الكلي والجزئي؟'**
  String get chatSuggestionEconomicsAction;

  /// عنوان بطاقة اقتراح العلوم
  ///
  /// In ar, this message translates to:
  /// **'العلوم'**
  String get chatSuggestionSciences;

  /// وصف بطاقة اقتراح العلوم
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في الفيزياء والرياضيات'**
  String get chatSuggestionSciencesSubtitle;

  /// رسالة اقتراح العلوم
  ///
  /// In ar, this message translates to:
  /// **'أحتاج شرحاً عن قوانين نيوتن للحركة'**
  String get chatSuggestionSciencesAction;

  /// عنوان بطاقة اقتراح الكيمياء
  ///
  /// In ar, this message translates to:
  /// **'الكيمياء'**
  String get chatSuggestionChemistry;

  /// وصف بطاقة اقتراح الكيمياء
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في الكيمياء والتفاعلات'**
  String get chatSuggestionChemistrySubtitle;

  /// رسالة اقتراح الكيمياء
  ///
  /// In ar, this message translates to:
  /// **'ما هي أنواع التفاعلات الكيميائية؟'**
  String get chatSuggestionChemistryAction;

  /// عنوان بطاقة اقتراح الأحياء
  ///
  /// In ar, this message translates to:
  /// **'الأحياء'**
  String get chatSuggestionBiology;

  /// وصف بطاقة اقتراح الأحياء
  ///
  /// In ar, this message translates to:
  /// **'مساعدة في علم الأحياء والوراثة'**
  String get chatSuggestionBiologySubtitle;

  /// رسالة اقتراح الأحياء
  ///
  /// In ar, this message translates to:
  /// **'كيف تعمل عملية البناء الضوئي في النباتات؟'**
  String get chatSuggestionBiologyAction;

  /// زر نسخ محتوى الرسالة
  ///
  /// In ar, this message translates to:
  /// **'نسخ'**
  String get chatMessageCopy;

  /// زر تحرير رسالة المستخدم
  ///
  /// In ar, this message translates to:
  /// **'تحرير'**
  String get chatMessageEdit;

  /// زر الإعجاب بالإجابة
  ///
  /// In ar, this message translates to:
  /// **'إعجاب'**
  String get chatMessageThumbUp;

  /// زر عدم الإعجاب بالإجابة
  ///
  /// In ar, this message translates to:
  /// **'عدم إعجاب'**
  String get chatMessageThumbDown;

  /// زر إعادة إرسال الطلب السابق
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get chatMessageRetry;

  /// رسالة تأكيد نسخ المحتوى
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ المحتوى'**
  String get chatMessageCopied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
