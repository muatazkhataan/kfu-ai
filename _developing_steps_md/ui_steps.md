## خطة تنفيذ واجهات المستخدم (UI) - مرحلة التحضير دون تنفيذ

الغرض: توثيق خطوات الإعداد الأولية قبل كتابة أي كود، اعتماداً على المواصفات في `CONTEXT.md` واستلهاماً من تصميمات `web_design/`.

### 1) تعريف الأصول (Assets) – دون تعديل فعلي للملفات
- الخطوط (`assets/fonts/`):
  - IBMPlexSansArabic-Thin.ttf (100)
  - IBMPlexSansArabic-ExtraLight.ttf (200)
  - IBMPlexSansArabic-Light.ttf (300)
  - IBMPlexSansArabic-Regular.ttf (400)
  - IBMPlexSansArabic-Medium.ttf (500)
  - IBMPlexSansArabic-SemiBold.ttf (600)
  - IBMPlexSansArabic-Bold.ttf (700)
  - FontAwesome7_0_1Pro-Regular-400.otf (خط الأيقونات)
- الشعارات/الأيقونات المتجهية (`assets/svg/`):
  - kfu_logo.svg, delit_logo.svg
  - mosa3ed_kfu_icon.svg, mosa3ed_kfu_icon_black.svg, mosa3ed_kfu_icon_app.svg
- أيقونة التطبيق:
  - اعتماد `assets/svg/mosa3ed_kfu_icon_app.svg` كمصدر لتوليد أيقونات المنصّات (Android/iOS/Web/Desktop). لا تنفيذ الآن، فقط اعتماد المصدر.

خطوات الإعداد المخطط لها (لاحقاً عند التنفيذ):
- إضافة أقسام `assets:` و`fonts:` في `pubspec.yaml` مع أوزان الخطوط كما أعلاه.
- ربط عائلة الخط باسم `IBMPlexSansArabic` وتوحيد استخدامها عبر السمات.
- توليد أيقونات التطبيق عبر أداة مناسبة (مثل `flutter_launcher_icons`) بعد اعتمادك.

### 2) ملفات السمات (Themes) – تصميم الهيكل فقط الآن
- موقع مقترح داخل `lib/core/theme/`:
  - `tokens.dart`: تعريف tokens للألوان والمسافات والحواف والظلال.
  - `typography.dart`: سلّم التايبوغرافيا بالعربية باستخدام `IBMPlexSansArabic` للأوزان 100–700.
  - `color_schemes.dart`: مخططات Light/Dark باستخدام Material 3.
  - `app_theme.dart`: تجميع `ThemeData` للوضعين مع تبديل فوري.
  - `icons.dart`: نقطة مركزية لتعريف الأيقونات العامة (FontAwesome + SVGs).
- أسلوب Minimal Swiss Design: تباين عالٍ، حواف بسيطة، فراغات متسقة.
- ملاحظة: تفعيل `useMaterial3` بعد ضبط التباين وقيم الألوان المعتمدة.

### 3) إعداد FontAwesome – جرد الأيقونات وخطة الربط
- مصدر الجرد: ملفات `web_design/*.html`.
- آلية الجرد:
  1. استخراج كل الأصناف `fa-...` من ملفات HTML.
  2. توحيد النمط إلى `fa-regular` كافتراضي (حسب المرجع)، مع توثيق أي استخدام لأنماط أخرى.
  3. إنشاء ملف mapping داخل `lib/core/icons/fa_map.dart`:
     - enum `AppIcon` لقيم دلالية: chat, send, attach, trash, folder, settings, help, feedback, search, filter, sort, share, export, archive, back, edit, plus, minus, user, lock, eye, microphone, image, file, download, upload, star ...
     - دالة `IconData iconOf(AppIcon)` تُعيد الرمز المناسب من خط FontAwesome المحلي.
- لن نستخدم حزم مدفوعة؛ نعتمد خط `FontAwesome7_0_1Pro-Regular-400.otf` المحلي عبر `pubspec.yaml`. إن لزم، يمكن إضافة `font_awesome_flutter` للأسماء الثابتة فقط.

عينة مبكرة متوقعة من الجرد (قابلة للتحديث بعد الموافقة):
- من `chat.html`: send, attach, microphone, image, trash, edit, share, export, plus, folder, settings, search.
- من `chat-history.html`: search, filter, sort, refresh, back, share, trash, archive, move, list/grid toggle.
- من `settings.html`: language, theme, font-size, notifications, privacy, data, info.
- من `help.html`: question, info/book, search.
- من `feedback.html`: upload image(s), priority, submit, save, clear.

نُوثّق القائمة النهائية لاحقاً في `docs/fa_inventory.md` قبل أي تنفيذ.

### 4) مكتبة اللغات والترجمة (i18n) – تخطيط ARB فقط الآن
- الحزم المقترحة: `flutter_localizations`, `intl` (نظام ARB).
- هيكل الملفات:
  - `lib/core/localization/`
    - `l10n.dart`: مزوّد اللغة والاتجاه ودوال المساعدة.
    - `arb/`
      - `app_ar.arb` (العربية الافتراضية)
      - `app_en.arb` (الإنجليزية اختيارية)
- سياسة المفاتيح: مفاتيح دلالية حسب `CONTEXT.md` مثل: `authLogin`, `authUsername`, `chatHistorySearchPlaceholder`, `chatClear`, `settingsGeneralLanguage`, ...
- عملية العمل لاحقاً:
  1. جمع النصوص من `web_design/` لكل الشاشات.
  2. إدراجها في `app_ar.arb` ثم ترجمتها إلى `app_en.arb`.
  3. توليد كود `AppLocalizations` عبر `flutter gen-l10n` بعد موافقتك.

### 5) خارطة الشاشات (UI فقط)
- `Splash`: شعار KFU + حركة بسيطة.
- `Login` (مرجعية `login.html`): تدفّق من خطوتين.
- `Chat` (مرجعية `chat.html`): الرسائل، مؤشر الكتابة، الإدخال، Drawer جانبي.
- `Chat History` (مرجعية `chat-history.html`): بحث/فلاتر/ترتيب/قائمة/حالات فارغة.
- `Settings` (مرجعية `settings.html`).
- `Help` (مرجعية `help.html`).
- `Feedback` (مرجعية `feedback.html`).

### 6) قرارات مطلوبة لاعتماد الخطة قبل التنفيذ
- تأكيد قيم الألوان الأساسية/الثانوية (HEX) النهائية.
- اعتماد `IBMPlexSansArabic` كخط افتراضي وحيد أو إضافة بديل.
- اعتماد `mosa3ed_kfu_icon_app.svg` كمصدر موحّد لأيقونات المنصّات.
- الموافقة على أسماء `enum AppIcon` الأولية وتوسعتها.
- الموافقة على مسارات وملفات السمات المقترحة.

### 7) مخرجات هذه المرحلة
- هذا المستند مرجع للتنفيذ.
- بعد موافقتك: نبدأ إضافة الأصول في `pubspec.yaml` وإنشاء ملفات السمات و`fa_map.dart` وهيكل i18n.


