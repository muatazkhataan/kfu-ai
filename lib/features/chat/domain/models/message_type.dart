/// أنواع الرسائل في المحادثة
///
/// يحدد هذا التعداد أنواع الرسائل المختلفة التي يمكن إرسالها في المحادثة
enum MessageType {
  /// رسالة من المستخدم
  user('user'),

  /// رسالة من المساعد الذكي
  assistant('assistant'),

  /// رسالة نظام (إشعارات، أخطاء، إلخ)
  system('system'),

  /// رسالة ترحيب
  welcome('welcome'),

  /// رسالة اقتراح
  suggestion('suggestion');

  const MessageType(this.value);

  /// القيمة النصية للنوع
  final String value;

  /// التحويل من نص إلى نوع رسالة
  static MessageType fromString(String value) {
    return MessageType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MessageType.user,
    );
  }

  /// التحقق من كون الرسالة من المستخدم
  bool get isUser => this == MessageType.user;

  /// التحقق من كون الرسالة من المساعد
  bool get isAssistant => this == MessageType.assistant;

  /// التحقق من كون الرسالة من النظام
  bool get isSystem => this == MessageType.system;

  /// التحقق من كون الرسالة ترحيبية
  bool get isWelcome => this == MessageType.welcome;

  /// التحقق من كون الرسالة اقتراح
  bool get isSuggestion => this == MessageType.suggestion;
}
