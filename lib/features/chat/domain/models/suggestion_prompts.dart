/// بنك الطلبات المقترحة للمحادثات
///
/// يحتوي على طلبات متنوعة تغطي جميع المجالات الجامعية
class SuggestionPrompts {
  SuggestionPrompts._();

  /// بنك الطلبات بالعربية (لا يشمل الأربعة الرئيسية)
  static final List<Map<String, String>> arabicPrompts = [
    // الطب
    {
      'icon': '🏥',
      'title': 'chatSuggestionMedicine',
      'subtitle': 'chatSuggestionMedicineSubtitle',
      'action': 'chatSuggestionMedicineAction',
    },
    {
      'icon': '💊',
      'title': 'chatSuggestionPharmacy',
      'subtitle': 'chatSuggestionPharmacySubtitle',
      'action': 'chatSuggestionPharmacyAction',
    },
    {
      'icon': '🔬',
      'title': 'chatSuggestionHealthSciences',
      'subtitle': 'chatSuggestionHealthSciencesSubtitle',
      'action': 'chatSuggestionHealthSciencesAction',
    },
    // الهندسة
    {
      'icon': '⚙️',
      'title': 'chatSuggestionEngineering',
      'subtitle': 'chatSuggestionEngineeringSubtitle',
      'action': 'chatSuggestionEngineeringAction',
    },
    {
      'icon': '💻',
      'title': 'chatSuggestionComputerScience',
      'subtitle': 'chatSuggestionComputerScienceSubtitle',
      'action': 'chatSuggestionComputerScienceAction',
    },
    {
      'icon': '🏗️',
      'title': 'chatSuggestionCivilEngineering',
      'subtitle': 'chatSuggestionCivilEngineeringSubtitle',
      'action': 'chatSuggestionCivilEngineeringAction',
    },
    // الآداب والعلوم الإنسانية
    {
      'icon': '📚',
      'title': 'chatSuggestionArts',
      'subtitle': 'chatSuggestionArtsSubtitle',
      'action': 'chatSuggestionArtsAction',
    },
    {
      'icon': '🕌',
      'title': 'chatSuggestionIslamicStudies',
      'subtitle': 'chatSuggestionIslamicStudiesSubtitle',
      'action': 'chatSuggestionIslamicStudiesAction',
    },
    {
      'icon': '👨‍🏫',
      'title': 'chatSuggestionEducation',
      'subtitle': 'chatSuggestionEducationSubtitle',
      'action': 'chatSuggestionEducationAction',
    },
    // إدارة الأعمال
    {
      'icon': '💼',
      'title': 'chatSuggestionBusiness',
      'subtitle': 'chatSuggestionBusinessSubtitle',
      'action': 'chatSuggestionBusinessAction',
    },
    {
      'icon': '📊',
      'title': 'chatSuggestionEconomics',
      'subtitle': 'chatSuggestionEconomicsSubtitle',
      'action': 'chatSuggestionEconomicsAction',
    },
    // العلوم
    {
      'icon': '🔬',
      'title': 'chatSuggestionSciences',
      'subtitle': 'chatSuggestionSciencesSubtitle',
      'action': 'chatSuggestionSciencesAction',
    },
    {
      'icon': '🧪',
      'title': 'chatSuggestionChemistry',
      'subtitle': 'chatSuggestionChemistrySubtitle',
      'action': 'chatSuggestionChemistryAction',
    },
    {
      'icon': '🌍',
      'title': 'chatSuggestionBiology',
      'subtitle': 'chatSuggestionBiologySubtitle',
      'action': 'chatSuggestionBiologyAction',
    },
  ];

  /// الحصول على طلبات عشوائية (لا تشمل الأربعة الرئيسية)
  static List<Map<String, String>> getRandomPrompts(int count) {
    final shuffled = List<Map<String, String>>.from(arabicPrompts)..shuffle();
    return shuffled.take(count).toList();
  }
}
