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

  /// خيار تذكر المستخدم
  ///
  /// In ar, this message translates to:
  /// **'تذكرني'**
  String get authRememberMe;

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

  /// مشاركة المحادثة
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
