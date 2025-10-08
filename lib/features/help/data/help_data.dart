import '../domain/models/help_section.dart';

/// Repository for help data
class HelpData {
  static List<HelpSectionModel> getHelpSections() {
    return [
      _getGettingStartedSection(),
      _getFeaturesSection(),
      _getChatGuideSection(),
      _getFoldersSection(),
      _getSettingsSection(),
      _getFAQSection(),
    ];
  }

  static HelpSectionModel _getGettingStartedSection() {
    return HelpSectionModel(
      section: HelpSection.gettingStarted,
      title: 'البدء السريع مع مساعد كفو',
      description: 'دليل سريع لبدء استخدام التطبيق',
      content: [
        const HelpTextContent(text: 'مرحباً بك في مساعد كفو!', style: 'title'),
        const HelpTextContent(
          text:
              'مساعد ذكي مصمم خصيصاً لطلبة جامعة الملك فيصل لمساعدتك في الشؤون الأكاديمية والدراسية.',
          style: 'body',
        ),
        const HelpTextContent(text: 'خطوات البدء السريع:', style: 'subtitle'),
        const HelpStepContent(
          stepNumber: 1,
          title: 'ابدأ محادثة جديدة',
          description:
              'انقر على زر "محادثة جديدة" في الشريط الجانبي لبدء محادثة مع المساعد الذكي.',
        ),
        const HelpStepContent(
          stepNumber: 2,
          title: 'اطرح سؤالك',
          description:
              'اكتب سؤالك في حقل الإدخال واضغط Enter أو انقر على زر الإرسال.',
        ),
        const HelpStepContent(
          stepNumber: 3,
          title: 'احصل على الإجابة',
          description:
              'سيقوم المساعد الذكي بالرد عليك فوراً مع معلومات مفصلة ومفيدة.',
        ),
        const HelpStepContent(
          stepNumber: 4,
          title: 'نظم محادثاتك',
          description:
              'أنشئ مجلدات لتنظيم محادثاتك حسب الموضوع أو المقرر الدراسي.',
        ),
      ],
    );
  }

  static HelpSectionModel _getFeaturesSection() {
    return HelpSectionModel(
      section: HelpSection.features,
      title: 'الميزات الرئيسية',
      description: 'اكتشف جميع الميزات المتاحة في التطبيق',
      content: [
        const HelpFeatureContent(
          icon: 'fas fa-brain',
          title: 'ذكاء اصطناعي متقدم',
          description:
              'مساعد ذكي يستخدم أحدث تقنيات الذكاء الاصطناعي لتقديم إجابات دقيقة ومفيدة.',
        ),
        const HelpFeatureContent(
          icon: 'fas fa-folder-tree',
          title: 'إدارة المجلدات',
          description:
              'نظم محادثاتك في مجلدات حسب الموضوع أو المقرر الدراسي للوصول السريع.',
        ),
        const HelpFeatureContent(
          icon: 'fas fa-search',
          title: 'البحث المتقدم',
          description:
              'ابحث في محادثاتك السابقة بسرعة وسهولة للعثور على المعلومات المطلوبة.',
        ),
        const HelpFeatureContent(
          icon: 'fas fa-download',
          title: 'تصدير المحادثات',
          description: 'صدّر محادثاتك كملفات PDF أو نصية للمشاركة أو الحفظ.',
        ),
        const HelpFeatureContent(
          icon: 'fas fa-mobile-alt',
          title: 'تصميم متجاوب',
          description: 'استخدم التطبيق على أي جهاز - هاتف، تابلت، أو حاسوب.',
        ),
        const HelpFeatureContent(
          icon: 'fas fa-shield-alt',
          title: 'خصوصية وأمان',
          description:
              'بياناتك محفوظة محلياً على جهازك مع إعدادات خصوصية متقدمة.',
        ),
      ],
    );
  }

  static HelpSectionModel _getChatGuideSection() {
    return HelpSectionModel(
      section: HelpSection.chatGuide,
      title: 'دليل المحادثة',
      description: 'تعلم كيفية استخدام المحادثة بشكل فعال',
      content: [
        const HelpTextContent(text: 'كيفية بدء محادثة:', style: 'subtitle'),
        const HelpTextContent(
          text:
              '1. انقر على زر "محادثة جديدة" في الشريط الجانبي\n2. اكتب سؤالك في حقل الإدخال\n3. اضغط Enter أو انقر على زر الإرسال\n4. انتظر رد المساعد الذكي',
          style: 'body',
        ),
        const HelpTextContent(
          text: 'نصائح للحصول على إجابات أفضل:',
          style: 'subtitle',
        ),
        const HelpTextContent(
          text:
              '• كن محدداً: اطرح أسئلة واضحة ومحددة\n• قدم سياقاً: اذكر المقرر الدراسي أو الموضوع\n• استخدم أمثلة: قدم أمثلة لتوضيح سؤالك\n• اطرح أسئلة متابعة: اطلب توضيحاً إذا لم تفهم الإجابة',
          style: 'body',
        ),
        const HelpTextContent(
          text: 'أمثلة على الأسئلة المفيدة:',
          style: 'subtitle',
        ),
        const HelpExampleContent(
          icon: '📚',
          example: 'اشرح لي مفهوم الأشجار الثنائية في مقرر هياكل البيانات',
        ),
        const HelpExampleContent(
          icon: '📅',
          example: 'متى موعد التسجيل للفصل القادم؟',
        ),
        const HelpExampleContent(
          icon: '📊',
          example: 'كيف أستعلم عن درجاتي في مقرر البرمجة؟',
        ),
      ],
    );
  }

  static HelpSectionModel _getFoldersSection() {
    return HelpSectionModel(
      section: HelpSection.folders,
      title: 'إدارة المجلدات',
      description: 'تعلم كيفية تنظيم محادثاتك باستخدام المجلدات',
      content: [
        const HelpTextContent(text: 'إنشاء مجلد جديد:', style: 'subtitle'),
        const HelpTextContent(
          text:
              '1. انقر على زر "+" بجانب "المجلدات" في الشريط الجانبي\n2. أدخل اسم المجلد (مثل: "البرمجة"، "هياكل البيانات")\n3. اختر أيقونة مناسبة للمجلد\n4. انقر على "إنشاء المجلد"',
          style: 'body',
        ),
        const HelpTextContent(
          text: 'إضافة محادثة إلى مجلد:',
          style: 'subtitle',
        ),
        const HelpTextContent(
          text:
              '1. انقر على زر "..." بجانب المحادثة\n2. اختر "إضافة إلى مجلد"\n3. اختر المجلد المناسب أو أنشئ مجلداً جديداً',
          style: 'body',
        ),
        const HelpTextContent(text: 'إدارة المجلدات:', style: 'subtitle'),
        const HelpTextContent(
          text:
              '• إعادة تسمية: انقر على "..." بجانب المجلد واختر "إعادة تسمية"\n• تغيير الأيقونة: انقر على "..." واختر "تغيير الأيقونة"\n• حذف المجلد: انقر على "..." واختر "حذف المجلد" (سيتم حذف جميع المحادثات داخل المجلد)',
          style: 'body',
        ),
        const HelpTextContent(
          text: 'نصائح لتنظيم المجلدات:',
          style: 'subtitle',
        ),
        const HelpTextContent(
          text:
              '• أنشئ مجلدات لكل مقرر دراسي\n• استخدم أسماء واضحة ووصفية\n• اختر أيقونات مميزة لكل مجلد',
          style: 'body',
        ),
      ],
    );
  }

  static HelpSectionModel _getSettingsSection() {
    return HelpSectionModel(
      section: HelpSection.settings,
      title: 'الإعدادات',
      description: 'تعرف على جميع إعدادات التطبيق وكيفية تخصيصها',
      content: [
        const HelpTextContent(text: 'الإعدادات العامة:', style: 'subtitle'),
        const HelpTextContent(
          text:
              '• اللغة: اختر بين العربية والإنجليزية\n• المنطقة الزمنية: حدد المنطقة الزمنية المناسبة\n• الوضع التجريبي: فعّل للوصول إلى الميزات الجديدة\n• التحديثات التلقائية: فعّل لتحديث التطبيق تلقائياً',
          style: 'body',
        ),
        const HelpTextContent(text: 'إعدادات المظهر:', style: 'subtitle'),
        const HelpTextContent(
          text:
              '• المظهر: اختر بين الفاتح والداكن والتلقائي\n• حجم الخط: عدّل حجم النص حسب تفضيلاتك\n• الشريط الجانبي: اختر متى تريد إظهاره\n• الرسوم المتحركة: فعّل أو ألغِ الانتقالات',
          style: 'body',
        ),
        const HelpTextContent(text: 'إعدادات المحادثة:', style: 'subtitle'),
        const HelpTextContent(
          text:
              '• نمط الرد: اختر بين مفصل ومختصر ومتوازن\n• الحد الأقصى للرسائل: حدد عدد الرسائل المحفوظة\n• الرد التلقائي: فعّل للردود التلقائية\n• اقتراحات المحادثة: فعّل لإظهار الاقتراحات',
          style: 'body',
        ),
        const HelpTextContent(text: 'إعدادات الخصوصية:', style: 'subtitle'),
        const HelpTextContent(
          text:
              '• البيانات التحليلية: فعّل لتحسين التطبيق\n• حفظ سجل المحادثات: فعّل لحفظ المحادثات محلياً\n• مشاركة المحادثات: فعّل للمشاركة مع الآخرين\n• حذف البيانات: احذف جميع البيانات المحفوظة',
          style: 'body',
        ),
        const HelpTextContent(
          text:
              'ملاحظة مهمة: جميع الإعدادات محفوظة محلياً على جهازك. تأكد من حفظ الإعدادات بعد تغييرها.',
          style: 'note',
        ),
      ],
    );
  }

  static HelpSectionModel _getFAQSection() {
    return HelpSectionModel(
      section: HelpSection.faq,
      title: 'الأسئلة الشائعة',
      description: 'إجابات على أكثر الأسئلة شيوعاً',
      content: [
        const HelpFAQContent(
          question: 'كيف يمكنني بدء محادثة جديدة؟',
          answer:
              'انقر على زر "محادثة جديدة" في الشريط الجانبي، أو استخدم الاختصار Ctrl+N (Cmd+N على Mac).',
        ),
        const HelpFAQContent(
          question: 'كيف يمكنني حفظ محادثة؟',
          answer:
              'المحادثات تُحفظ تلقائياً. يمكنك أيضاً تصديرها كملف PDF أو نصي من خلال زر "تصدير المحادثة".',
        ),
        const HelpFAQContent(
          question: 'كيف يمكنني البحث في المحادثات السابقة؟',
          answer:
              'استخدم حقل البحث في أعلى الشريط الجانبي، أو ابحث في مجلد محدد بالنقر على المجلد أولاً.',
        ),
        const HelpFAQContent(
          question: 'كيف يمكنني تغيير مظهر التطبيق؟',
          answer:
              'اذهب إلى الإعدادات > المظهر، واختر بين المظهر الفاتح والداكن والتلقائي.',
        ),
        const HelpFAQContent(
          question: 'كيف يمكنني حذف محادثة؟',
          answer:
              'انقر على زر "..." بجانب المحادثة واختر "حذف". تأكد من أنك تريد حذف المحادثة نهائياً.',
        ),
        const HelpFAQContent(
          question: 'كيف يمكنني مشاركة محادثة مع شخص آخر؟',
          answer:
              'انقر على زر "..." بجانب المحادثة واختر "مشاركة"، ثم اختر طريقة المشاركة المفضلة لديك.',
        ),
        const HelpFAQContent(
          question: 'هل يمكنني استخدام التطبيق بدون إنترنت؟',
          answer:
              'يمكنك عرض المحادثات المحفوظة بدون إنترنت، لكن للتفاعل مع المساعد الذكي تحتاج إلى اتصال بالإنترنت.',
        ),
        const HelpFAQContent(
          question: 'كيف يمكنني تغيير إعدادات الذكاء الاصطناعي؟',
          answer:
              'اذهب إلى الإعدادات > إعدادات الذكاء الاصطناعي، وعدّل النموذج المستخدم ودرجة الإبداع والسياق المحفوظ.',
        ),
      ],
    );
  }
}
