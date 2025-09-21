// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'KFU AI Assistant';

  @override
  String get appDescription =>
      'I am your smart assistant. I can help you with studying, academic matters, and solving academic problems.';

  @override
  String get appWelcomeMessage => 'Welcome to KFU AI Assistant!';

  @override
  String get appNameShort => 'KFU AI Assistant';

  @override
  String get authLogin => 'Login';

  @override
  String get authUsername => 'Student ID';

  @override
  String get authPassword => 'Password';

  @override
  String get authNext => 'Next';

  @override
  String get authPrevious => 'Previous';

  @override
  String get authEnter => 'Enter';

  @override
  String get authRememberMe => 'Remember me';

  @override
  String get chatNew => 'New Chat';

  @override
  String get chatTitleDefault => 'Math Help';

  @override
  String get chatClear => 'Clear Chat';

  @override
  String get chatExport => 'Export Chat';

  @override
  String get chatShare => 'Share';

  @override
  String get chatTyping => 'KFU AI is typing...';

  @override
  String get chatMessagePlaceholder => 'Type your message here...';

  @override
  String get chatHistoryTitle => 'Chat History';

  @override
  String get chatHistorySearchPlaceholder => 'Search chats...';

  @override
  String get chatHistoryFilterAll => 'All Chats';

  @override
  String get chatHistoryFilterRecent => 'Recent Chats';

  @override
  String get chatHistoryFilterArchived => 'Archived Chats';

  @override
  String get chatHistorySortBy => 'Sort by';

  @override
  String get chatHistorySortDateDesc => 'Newest First';

  @override
  String get chatHistorySortDateAsc => 'Oldest First';

  @override
  String get chatHistorySortTitle => 'Name';

  @override
  String get chatHistorySortMessages => 'Message Count';

  @override
  String get chatHistoryRefresh => 'Refresh';

  @override
  String get chatHistoryToggleView => 'Toggle View';

  @override
  String get chatHistoryBackToChat => 'Back to Chat';

  @override
  String get chatHistoryDelete => 'Delete Chat';

  @override
  String get chatHistoryArchive => 'Archive';

  @override
  String get chatHistoryMoveToFolder => 'Move to Folder';

  @override
  String get chatHistoryEmptyState => 'No chats found';

  @override
  String get chatHistoryClearFilters => 'Clear Filters';

  @override
  String chatHistoryMessagesCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString messages';
  }

  @override
  String get chatHistoryConfirmDelete =>
      'Are you sure you want to delete this chat?';

  @override
  String get chatHistoryConfirmArchive => 'Do you want to archive this chat?';

  @override
  String chatHistorySearchResults(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return 'Search results: $countString chats';
  }

  @override
  String get foldersTitle => 'Folders';

  @override
  String get foldersCreate => 'Create Folder';

  @override
  String get foldersRename => 'Rename';

  @override
  String get foldersDelete => 'Delete Folder';

  @override
  String get foldersChangeIcon => 'Change Icon';

  @override
  String get foldersProgramming => 'Programming';

  @override
  String get foldersDataStructures => 'Data Structures';

  @override
  String get foldersAlgorithms => 'Algorithms';

  @override
  String get foldersAcademic => 'Academic Affairs';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeAuto => 'Auto';

  @override
  String get settingsFontSize => 'Font Size';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsAbout => 'About';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpQuickStart => 'Quick Start';

  @override
  String get helpFeatures => 'Features';

  @override
  String get helpChatGuide => 'Chat Guide';

  @override
  String get helpFoldersGuide => 'Folder Management';

  @override
  String get helpChatHistoryGuide => 'Chat History';

  @override
  String get helpSettingsGuide => 'Settings';

  @override
  String get helpFAQ => 'FAQ';

  @override
  String get feedbackTitle => 'Send Feedback';

  @override
  String get feedbackName => 'Name';

  @override
  String get feedbackEmail => 'Email';

  @override
  String get feedbackType => 'Feedback Type';

  @override
  String get feedbackPriority => 'Priority';

  @override
  String get feedbackSubject => 'Subject';

  @override
  String get feedbackMessage => 'Description';

  @override
  String get feedbackAttachImages => 'Attach Images';

  @override
  String get feedbackSubmit => 'Submit';

  @override
  String get feedbackSaveDraft => 'Save Draft';

  @override
  String get feedbackClear => 'Clear Form';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonFilter => 'Filter';

  @override
  String get commonSort => 'Sort';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'An error occurred';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSuccess => 'Success';

  @override
  String get commonNoData => 'No data available';

  @override
  String get commonNoResults => 'No results found';

  @override
  String get authAcademicId => 'Academic ID';

  @override
  String get authAcademicIdHint => 'Enter your academic ID';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authLoginTitle => 'Login';
}
