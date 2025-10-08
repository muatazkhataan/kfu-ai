/// Enum representing different help sections
enum HelpSection {
  gettingStarted('getting-started', 'البدء السريع', 'fas fa-rocket'),
  features('features', 'الميزات الرئيسية', 'fas fa-star'),
  chatGuide('chat-guide', 'دليل المحادثة', 'fas fa-comments'),
  folders('folders', 'إدارة المجلدات', 'fas fa-folder'),
  settings('settings', 'الإعدادات', 'fas fa-cog'),
  faq('faq', 'الأسئلة الشائعة', 'fas fa-question');

  const HelpSection(this.id, this.title, this.icon);

  final String id;
  final String title;
  final String icon;
}

/// Model representing a help section with its content
class HelpSectionModel {
  final HelpSection section;
  final String title;
  final String description;
  final List<HelpContent> content;

  const HelpSectionModel({
    required this.section,
    required this.title,
    required this.description,
    required this.content,
  });
}

/// Base class for help content
abstract class HelpContent {
  final String type;

  const HelpContent({required this.type});
}

/// Text content for help sections
class HelpTextContent extends HelpContent {
  final String text;
  final String? style; // 'title', 'subtitle', 'body', 'note'

  const HelpTextContent({required this.text, this.style = 'body'})
    : super(type: 'text');
}

/// Step content for help sections
class HelpStepContent extends HelpContent {
  final int stepNumber;
  final String title;
  final String description;

  const HelpStepContent({
    required this.stepNumber,
    required this.title,
    required this.description,
  }) : super(type: 'step');
}

/// Feature content for help sections
class HelpFeatureContent extends HelpContent {
  final String icon;
  final String title;
  final String description;

  const HelpFeatureContent({
    required this.icon,
    required this.title,
    required this.description,
  }) : super(type: 'feature');
}

/// FAQ item content
class HelpFAQContent extends HelpContent {
  final String question;
  final String answer;

  const HelpFAQContent({required this.question, required this.answer})
    : super(type: 'faq');
}

/// Example content for help sections
class HelpExampleContent extends HelpContent {
  final String icon;
  final String example;

  const HelpExampleContent({required this.icon, required this.example})
    : super(type: 'example');
}
