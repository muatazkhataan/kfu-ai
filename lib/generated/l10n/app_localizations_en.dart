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
  String get authRememberPassword => 'Remember Password';

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

  @override
  String get authRememberMe => 'Remember me';

  @override
  String get settingsGeneralTitle => 'General Settings';

  @override
  String get settingsGeneralDescription => 'Customize the basic app settings';

  @override
  String get settingsAppearanceTitle => 'Appearance & Customization';

  @override
  String get settingsAppearanceDescription =>
      'Customize the app appearance to your preferences';

  @override
  String get settingsChatTitle => 'Chat Settings';

  @override
  String get settingsChatDescription =>
      'Customize your chat experience with the AI assistant';

  @override
  String get settingsPrivacyTitle => 'Privacy & Security';

  @override
  String get settingsPrivacyDescription =>
      'Control your data and information privacy';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsDescription =>
      'Customize notifications and alerts';

  @override
  String get settingsAITitle => 'AI Settings';

  @override
  String get settingsAIDescription => 'Customize the AI assistant behavior';

  @override
  String get settingsDataTitle => 'Data Management';

  @override
  String get settingsDataDescription => 'Manage data and backups';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsAboutDescription => 'App information and version';

  @override
  String get settingsDefaultLanguage => 'Default Language';

  @override
  String get settingsDefaultLanguageSubtitle =>
      'Choose the language you want to use in the app';

  @override
  String get settingsTimezone => 'Timezone';

  @override
  String get settingsTimezoneSubtitle => 'Choose your timezone';

  @override
  String get settingsBetaMode => 'Beta Mode';

  @override
  String get settingsBetaModeSubtitle =>
      'Access new features before official release';

  @override
  String get settingsAutoUpdate => 'Auto Update';

  @override
  String get settingsAutoUpdateSubtitle =>
      'Automatically update the app when new versions are available';

  @override
  String get settingsAnimations => 'Animations';

  @override
  String get settingsAnimationsSubtitle => 'Show animations and transitions';

  @override
  String get settingsHapticFeedback => 'Haptic Feedback';

  @override
  String get settingsHapticFeedbackSubtitle => 'Light vibration on interaction';

  @override
  String get settingsResponseStyle => 'Response Style';

  @override
  String get settingsResponseStyleSubtitle =>
      'Choose how the assistant responds to your questions';

  @override
  String get settingsMaxMessages => 'Max Messages';

  @override
  String get settingsMaxMessagesSubtitle =>
      'Number of messages saved in a single chat';

  @override
  String get settingsAutoResponse => 'Auto Response';

  @override
  String get settingsAutoResponseSubtitle =>
      'Allow the assistant to automatically respond to some questions';

  @override
  String get settingsShowSuggestions => 'Chat Suggestions';

  @override
  String get settingsShowSuggestionsSubtitle =>
      'Show suggestions for next questions';

  @override
  String get settingsAutoCorrect => 'Auto Correct';

  @override
  String get settingsAutoCorrectSubtitle =>
      'Automatically correct spelling errors';

  @override
  String get settingsAnalytics => 'Analytics Data Collection';

  @override
  String get settingsAnalyticsSubtitle =>
      'Allow collecting usage data to improve the app';

  @override
  String get settingsSaveChatHistory => 'Save Chat History';

  @override
  String get settingsSaveChatHistorySubtitle =>
      'Save chats locally on your device';

  @override
  String get settingsAllowSharing => 'Share Chats';

  @override
  String get settingsAllowSharingSubtitle => 'Allow sharing chats with others';

  @override
  String get settingsEnableNotifications => 'Enable Notifications';

  @override
  String get settingsEnableNotificationsSubtitle =>
      'Receive notifications from the app';

  @override
  String get settingsUpdateNotifications => 'Update Notifications';

  @override
  String get settingsUpdateNotificationsSubtitle =>
      'Notifications when new updates are available';

  @override
  String get settingsFeatureNotifications => 'New Features Notifications';

  @override
  String get settingsFeatureNotificationsSubtitle =>
      'Notifications when new features are added';

  @override
  String get settingsNotificationSound => 'Notification Sound';

  @override
  String get settingsNotificationSoundSubtitle =>
      'Play sound when receiving notifications';

  @override
  String get settingsAIModel => 'AI Model';

  @override
  String get settingsAIModelSubtitle =>
      'Choose the model used for the assistant';

  @override
  String get settingsContextLength => 'Saved Context';

  @override
  String get settingsContextLengthSubtitle =>
      'Number of messages saved for context';

  @override
  String get settingsAdaptiveLearning => 'Adaptive Learning';

  @override
  String get settingsAdaptiveLearningSubtitle =>
      'Improve responses based on your preferences';

  @override
  String get settingsExperimentalAI => 'Experimental AI Features';

  @override
  String get settingsExperimentalAISubtitle => 'Try new AI features';

  @override
  String get settingsAutoBackup => 'Auto Backup';

  @override
  String get settingsAutoBackupSubtitle => 'Automatically create backups';

  @override
  String get settingsBackupFrequency => 'Backup Frequency';

  @override
  String get settingsBackupFrequencySubtitle => 'When backups are created';

  @override
  String get settingsStorageUsed => 'Storage Used';

  @override
  String get settingsExportData => 'Export Data';

  @override
  String get settingsDeleteAllData => 'Delete All Data';

  @override
  String get settingsChats => 'Chats';

  @override
  String get settingsMessages => 'Messages';

  @override
  String get settingsLastBackup => 'Last Backup';

  @override
  String get settingsNoBackup => 'None';

  @override
  String settingsAppVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsAppDescription =>
      'A smart assistant for King Faisal University students, designed to help you with academic and study matters.';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicySubtitle => 'Read the privacy policy';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsTermsOfServiceSubtitle => 'Read the terms of service';

  @override
  String get settingsHelpAndSupport => 'Help & Support';

  @override
  String get settingsHelpAndSupportSubtitle => 'Get help';

  @override
  String get settingsSendFeedback => 'Send Feedback';

  @override
  String get settingsSendFeedbackSubtitle => 'Help us improve the app';

  @override
  String get settingsDevelopedBy => 'Developed by King Faisal University Team';

  @override
  String get settingsCopyright => 'All rights reserved © 2024';

  @override
  String get settingsSave => 'Save Settings';

  @override
  String get settingsReset => 'Reset';

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsResetDialogTitle => 'Reset Settings';

  @override
  String get settingsResetDialogContent =>
      'Are you sure you want to reset all settings to default values?';

  @override
  String get settingsResetSuccess => 'Settings have been reset';

  @override
  String get settingsExportDialogTitle => 'Export Settings';

  @override
  String get settingsExportSuccess => 'Settings exported successfully:';

  @override
  String settingsExportError(String error) {
    return 'Export error: $error';
  }

  @override
  String get settingsImportFeature => 'Import feature is under development';

  @override
  String get settingsDeleteDialogTitle => 'Delete All Data';

  @override
  String get settingsDeleteDialogContent =>
      'Are you sure you want to delete all data? This action cannot be undone.';

  @override
  String get settingsDeleteSuccess => 'All data has been deleted';

  @override
  String get settingsDeleteButton => 'Delete';

  @override
  String get settingsOK => 'OK';

  @override
  String settingsMessagesCount(int count) {
    return '$count messages';
  }

  @override
  String settingsContextMessagesCount(int count) {
    return '$count messages';
  }

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get timezoneRiyadh => 'Riyadh (GMT+3)';

  @override
  String get timezoneDubai => 'Dubai (GMT+4)';

  @override
  String get timezoneKuwait => 'Kuwait (GMT+3)';

  @override
  String get fontSizeSmall => 'Small';

  @override
  String get fontSizeMedium => 'Medium';

  @override
  String get fontSizeLarge => 'Large';

  @override
  String get fontSizeExtraLarge => 'Extra Large';

  @override
  String get fontSizeSelectorTitle => 'Font Size';

  @override
  String get fontSizeSelectorSubtitle => 'Adjust text size in the app';

  @override
  String get fontSizeExample => 'Sample text';

  @override
  String get themeSelectorTitle => 'Theme';

  @override
  String get themeSelectorSubtitle => 'Choose between light or dark theme';

  @override
  String get responseStyleDetailed => 'Detailed and Expanded';

  @override
  String get responseStyleConcise => 'Concise and Direct';

  @override
  String get responseStyleBalanced => 'Balanced';

  @override
  String get aiModelGPT4 => 'GPT-4 (Most Accurate)';

  @override
  String get aiModelGPT35 => 'GPT-3.5 (Balanced)';

  @override
  String get aiModelClaude => 'Claude (Detailed)';

  @override
  String get backupFrequencyNever => 'Never';

  @override
  String get backupFrequencyDaily => 'Daily';

  @override
  String get backupFrequencyWeekly => 'Weekly';

  @override
  String get backupFrequencyMonthly => 'Monthly';

  @override
  String get creativityLevelTitle => 'Creativity Level';

  @override
  String get creativityLevelSubtitle =>
      'Level of creativity in assistant responses';

  @override
  String get creativityConservative => 'Conservative';

  @override
  String get creativityBalanced => 'Balanced';

  @override
  String get creativityCreative => 'Creative';

  @override
  String get creativityDescriptionConservative =>
      'Conservative and accurate responses based on confirmed knowledge';

  @override
  String get creativityDescriptionBalanced =>
      'Balance between accuracy and creativity in responses';

  @override
  String get creativityDescriptionCreative =>
      'Creative and innovative responses with flexibility in interpretation';
}
