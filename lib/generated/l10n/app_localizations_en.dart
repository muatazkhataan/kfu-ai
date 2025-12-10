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

  @override
  String get sidebarClose => 'Close Sidebar';

  @override
  String get sidebarUserDefault => 'User';

  @override
  String sidebarUserIdDisplay(String id) {
    return 'ID: $id...';
  }

  @override
  String get sidebarSignOut => 'Sign Out';

  @override
  String get sidebarSearchInChats => 'Search in Chats';

  @override
  String get sidebarOpenFoldersScreen => 'Open Folders Screen';

  @override
  String get sidebarNoFolders => 'No folders';

  @override
  String get sidebarFixedFolderTooltip => 'Fixed folder cannot be modified';

  @override
  String get sidebarSystemFolderTooltip => 'System folder cannot be modified';

  @override
  String get sidebarProtectedFolderTooltip => 'This folder cannot be modified';

  @override
  String get sidebarDeleteFolderTitle => 'Delete Folder';

  @override
  String sidebarDeleteFolderMessage(String name) {
    return 'Are you sure you want to delete the folder \"$name\"?\n\nThis action cannot be undone.';
  }

  @override
  String get sidebarFolderDeletedSuccess => 'Folder deleted successfully';

  @override
  String get chatSources => 'Sources';

  @override
  String get navbarOpenMenu => 'Open Menu';

  @override
  String get navbarCloseMenu => 'Close Menu';

  @override
  String get navbarMenu => 'Menu';

  @override
  String get navbarSettings => 'Settings';

  @override
  String get chatReply => 'Reply';

  @override
  String get chatCopy => 'Copy';

  @override
  String get chatEdit => 'Edit';

  @override
  String get chatMore => 'More';

  @override
  String get chatMoveToArchive => 'Move to Archive';

  @override
  String get chatMoveToFolder => 'Move to Folder';

  @override
  String get chatDeleteChatTitle => 'Delete Chat';

  @override
  String chatDeleteChatMessage(String title) {
    return 'Are you sure you want to delete the chat \"$title\"?';
  }

  @override
  String get chatMoveToFolderTitle => 'Move to Folder';

  @override
  String get chatNoFoldersAvailable => 'No folders available';

  @override
  String get chatNoFolder => 'No Folder';

  @override
  String chatOpeningChat(String title) {
    return 'Opening chat: $title';
  }

  @override
  String chatDeleted(String title) {
    return 'Chat deleted: $title';
  }

  @override
  String get chatHistoryUpdated => 'Chat history updated';

  @override
  String get chatDeleteFolderTitle => 'Delete Folder';

  @override
  String chatDeleteFolderMessage(String name) {
    return 'Are you sure you want to delete the folder \"$name\"?';
  }

  @override
  String get chatFolderDeletedSuccess => 'Folder deleted successfully';

  @override
  String chatError(String error) {
    return 'Error: $error';
  }

  @override
  String chatAttachmentSelected(String type) {
    return '$type selected';
  }

  @override
  String get chatSettings => 'Chat Settings';

  @override
  String get chatCreateFolderTitle => 'Create New Folder';

  @override
  String get chatCreate => 'Create';

  @override
  String get chatEditFolderTitle => 'Edit Folder';

  @override
  String get chatChangeIcon => 'Change Icon';

  @override
  String get chatAddToFavorites => 'Add to Favorites';

  @override
  String get chatRemoveFromFavorites => 'Remove from Favorites';

  @override
  String get chatPin => 'Pin';

  @override
  String get chatUnpin => 'Unpin';

  @override
  String chatMoveToFolderSuccess(String folder) {
    return 'Chat moved to \"$folder\" successfully';
  }

  @override
  String get chatMoveToFolderFailed => 'Failed to move chat';

  @override
  String get chatArchiveSuccess => 'Chat moved to archive successfully';

  @override
  String get chatArchiveFailed => 'Failed to move chat to archive';

  @override
  String get chatDeleteSuccess => 'Chat deleted successfully';

  @override
  String get chatDeleteFailed => 'Failed to delete chat';

  @override
  String get folderChangeIconTitle => 'Change Folder Icon';

  @override
  String get folderSelectIcon => 'Select Icon';

  @override
  String get folderSelectColor => 'Select Color';

  @override
  String folderSelectedColor(String name) {
    return 'Selected color: $name';
  }

  @override
  String get folderColorUndefined => 'Undefined';

  @override
  String get folderApplying => 'Applying...';

  @override
  String folderApplyIcon(String name) {
    return 'Apply \"$name\"';
  }

  @override
  String folderIconChangedSuccess(String name) {
    return 'Folder icon \"$name\" changed successfully';
  }

  @override
  String get folderColorGray => 'Light Gray';

  @override
  String get folderColorRed => 'Red';

  @override
  String get folderColorOrange => 'Orange';

  @override
  String get folderColorYellow => 'Yellow';

  @override
  String get folderColorGreen => 'Green';

  @override
  String get folderColorCyan => 'Cyan';

  @override
  String get folderColorPurple => 'Purple';

  @override
  String get folderColorPink => 'Pink';

  @override
  String get folderPreview => 'Folder Preview';

  @override
  String get folderNamePlaceholder => 'Folder Name';

  @override
  String get folderNameLabel => 'Folder Name *';

  @override
  String get folderNameHint => 'Enter folder name';

  @override
  String get folderNameRequired => 'Folder name is required';

  @override
  String get folderNameMinLength => 'Folder name must be at least 2 characters';

  @override
  String get folderNameMaxLength => 'Folder name must not exceed 50 characters';

  @override
  String get folderSaveChanges => 'Save Changes';

  @override
  String get folderCreate => 'Create Folder';

  @override
  String get folderCreatedSuccess => 'Folder created successfully';

  @override
  String get folderUpdatedSuccess => 'Folder updated successfully';

  @override
  String get iconCategoryGeneral => 'General';

  @override
  String get iconCategoryProgramming => 'Programming';

  @override
  String get iconCategoryMathematics => 'Mathematics';

  @override
  String get iconCategoryScience => 'Science';

  @override
  String get iconCategoryStudy => 'Study';

  @override
  String get iconCategoryCreativity => 'Creativity';

  @override
  String get iconCategoryCollaboration => 'Collaboration';

  @override
  String get iconCategorySystem => 'System';

  @override
  String get iconFolderGeneral => 'General Folder';

  @override
  String get iconFolderStar => 'Star';

  @override
  String get iconFolderHeart => 'Heart';

  @override
  String get iconFolderHome => 'Home';

  @override
  String get iconFolderThumbtack => 'Pinned';

  @override
  String get iconFolderPlus => 'Add Folder';

  @override
  String get iconFolderOpen => 'Open Folder';

  @override
  String get iconCode => 'Code';

  @override
  String get iconLaptopCode => 'Laptop Code';

  @override
  String get iconTerminal => 'Terminal';

  @override
  String get iconBug => 'Bug';

  @override
  String get iconCogs => 'Settings';

  @override
  String get iconMicrochip => 'Processor';

  @override
  String get iconServer => 'Server';

  @override
  String get iconNetworkWired => 'Network';

  @override
  String get iconShieldAlt => 'Security';

  @override
  String get iconKey => 'Key';

  @override
  String get iconDatabase => 'Database';

  @override
  String get iconTable => 'Table';

  @override
  String get iconChartBar => 'Bar Chart';

  @override
  String get iconMobileAlt => 'Mobile';

  @override
  String get iconGlobe => 'Global';

  @override
  String get iconCloud => 'Cloud';

  @override
  String get iconRobot => 'Robot';

  @override
  String get iconBrain => 'Brain';

  @override
  String get iconSitemap => 'Sitemap';

  @override
  String get iconProjectDiagram => 'Project Diagram';

  @override
  String get iconFileCode => 'Code File';

  @override
  String get iconCodeBranch => 'Code Branch';

  @override
  String get iconCodeMerge => 'Code Merge';

  @override
  String get iconCodeCompare => 'Code Compare';

  @override
  String get iconCalculator => 'Calculator';

  @override
  String get iconSquareRootAlt => 'Square Root';

  @override
  String get iconInfinity => 'Infinity';

  @override
  String get iconPercentage => 'Percentage';

  @override
  String get iconChartLine => 'Line Chart';

  @override
  String get iconChartPie => 'Pie Chart';

  @override
  String get iconChartArea => 'Area Chart';

  @override
  String get iconSortNumericUp => 'Sort Ascending';

  @override
  String get iconSortNumericDown => 'Sort Descending';

  @override
  String get iconEquals => 'Equals';

  @override
  String get iconPlus => 'Plus';

  @override
  String get iconMinus => 'Minus';

  @override
  String get iconTimes => 'Multiply';

  @override
  String get iconDivide => 'Divide';

  @override
  String get iconSuperscript => 'Superscript';

  @override
  String get iconSubscript => 'Subscript';

  @override
  String get iconSigma => 'Sigma';

  @override
  String get iconPi => 'Pi';

  @override
  String get iconFunction => 'Function';

  @override
  String get iconIntegral => 'Integral';

  @override
  String get iconTriangle => 'Triangle';

  @override
  String get iconOmega => 'Omega';

  @override
  String get iconTheta => 'Theta';

  @override
  String get iconAtom => 'Atom';

  @override
  String get iconFlask => 'Flask';

  @override
  String get iconMicroscope => 'Microscope';

  @override
  String get iconDna => 'DNA';

  @override
  String get iconLeaf => 'Leaf';

  @override
  String get iconSeedling => 'Seedling';

  @override
  String get iconDroplet => 'Droplet';

  @override
  String get iconFire => 'Fire';

  @override
  String get iconBolt => 'Lightning';

  @override
  String get iconMagnet => 'Magnet';

  @override
  String get iconSatellite => 'Satellite';

  @override
  String get iconRocket => 'Rocket';

  @override
  String get iconSun => 'Sun';

  @override
  String get iconMoon => 'Moon';

  @override
  String get iconStar => 'Star';

  @override
  String get iconTelescope => 'Telescope';

  @override
  String get iconVial => 'Test Tube';

  @override
  String get iconPills => 'Pills';

  @override
  String get iconStethoscope => 'Stethoscope';

  @override
  String get iconHeartbeat => 'Heartbeat';

  @override
  String get iconEye => 'Eye';

  @override
  String get iconEar => 'Ear';

  @override
  String get iconNose => 'Nose';

  @override
  String get iconTooth => 'Tooth';

  @override
  String get iconBone => 'Bone';

  @override
  String get iconLungs => 'Lungs';

  @override
  String get iconLiver => 'Liver';

  @override
  String get iconKidney => 'Kidney';

  @override
  String get iconStomach => 'Stomach';

  @override
  String get iconIntestines => 'Intestines';

  @override
  String get iconGraduationCap => 'Graduation Cap';

  @override
  String get iconBook => 'Book';

  @override
  String get iconBookOpen => 'Open Book';

  @override
  String get iconPen => 'Pen';

  @override
  String get iconPencilAlt => 'Pencil';

  @override
  String get iconHighlighter => 'Highlighter';

  @override
  String get iconStickyNote => 'Note';

  @override
  String get iconClipboard => 'Clipboard';

  @override
  String get iconFileAlt => 'File';

  @override
  String get iconArchive => 'Archive';

  @override
  String get iconCalendarAlt => 'Calendar';

  @override
  String get iconClock => 'Clock';

  @override
  String get iconStopwatch => 'Stopwatch';

  @override
  String get iconHourglassHalf => 'Hourglass';

  @override
  String get iconBell => 'Bell';

  @override
  String get iconFlag => 'Flag';

  @override
  String get iconTrophy => 'Trophy';

  @override
  String get iconMedal => 'Medal';

  @override
  String get iconCertificate => 'Certificate';

  @override
  String get iconAward => 'Award';

  @override
  String get iconUserGraduate => 'Student';

  @override
  String get iconChalkboardTeacher => 'Teacher';

  @override
  String get iconChalkboard => 'Chalkboard';

  @override
  String get iconSearch => 'Search';

  @override
  String get iconQuestionCircle => 'Question';

  @override
  String get iconLightbulb => 'Idea';

  @override
  String get iconInbox => 'Inbox';

  @override
  String get iconPalette => 'Color Palette';

  @override
  String get iconPaintBrush => 'Paint Brush';

  @override
  String get iconMagic => 'Magic';

  @override
  String get iconSparkles => 'Sparkles';

  @override
  String get iconEyeDropper => 'Eye Dropper';

  @override
  String get iconCamera => 'Camera';

  @override
  String get iconVideo => 'Video';

  @override
  String get iconMusic => 'Music';

  @override
  String get iconHeadphones => 'Headphones';

  @override
  String get iconGamepad => 'Gamepad';

  @override
  String get iconDice => 'Dice';

  @override
  String get iconPuzzlePiece => 'Puzzle Piece';

  @override
  String get iconCube => 'Cube';

  @override
  String get iconGem => 'Gem';

  @override
  String get iconCrown => 'Crown';

  @override
  String get iconRibbon => 'Ribbon';

  @override
  String get iconUsers => 'Users';

  @override
  String get iconUserFriends => 'Friends';

  @override
  String get iconHandshake => 'Handshake';

  @override
  String get iconComments => 'Comments';

  @override
  String get iconCommentDots => 'Comment';

  @override
  String get iconEnvelope => 'Envelope';

  @override
  String get iconPhone => 'Phone';

  @override
  String get iconVideoCamera => 'Video Camera';

  @override
  String get iconShareAlt => 'Share';

  @override
  String get iconLink => 'Link';

  @override
  String get iconSync => 'Sync';

  @override
  String get iconDownload => 'Download';

  @override
  String get iconUpload => 'Upload';

  @override
  String get iconPrint => 'Print';

  @override
  String get iconCopy => 'Copy';

  @override
  String get iconPaperPlane => 'Paper Plane';

  @override
  String get iconSend => 'Send';

  @override
  String get iconBellSlash => 'Mute Notifications';

  @override
  String get iconChat => 'Chat';

  @override
  String get iconMessage => 'Message';

  @override
  String get iconReply => 'Reply';

  @override
  String get iconShare => 'Share';

  @override
  String get iconAttach => 'Attachment';

  @override
  String get iconImage => 'Image';

  @override
  String get iconFile => 'File';

  @override
  String get iconPaperclip => 'Paperclip';

  @override
  String get iconSettings => 'Settings';

  @override
  String get iconCog => 'Gear';

  @override
  String get iconShield => 'Shield';

  @override
  String get iconInfo => 'Info';

  @override
  String get iconHelp => 'Help';

  @override
  String get iconQuestion => 'Question';

  @override
  String get iconCheck => 'Check';

  @override
  String get iconWarning => 'Warning';

  @override
  String get iconError => 'Error';

  @override
  String get iconInfoCircle => 'Info';

  @override
  String get iconExclamation => 'Exclamation';

  @override
  String get iconExclamationTriangle => 'Warning Triangle';

  @override
  String get iconUser => 'User';

  @override
  String get iconLock => 'Lock';

  @override
  String get iconSignIn => 'Sign In';

  @override
  String get iconSignOut => 'Sign Out';

  @override
  String get iconEdit => 'Edit';

  @override
  String get iconDelete => 'Delete';

  @override
  String get iconTrash => 'Trash';

  @override
  String get iconSave => 'Save';

  @override
  String get iconHistory => 'History';

  @override
  String get iconLockKeyhole => 'Lock';

  @override
  String get iconUnlock => 'Unlock';

  @override
  String get iconMicrophone => 'Microphone';

  @override
  String get iconFileCodeIcon => 'Code File';

  @override
  String get iconList => 'List';

  @override
  String get iconGrid => 'Grid';

  @override
  String get iconThLarge => 'Large Grid';

  @override
  String get iconBars => 'Bars';

  @override
  String get iconMenu => 'Menu';

  @override
  String get iconFilter => 'Filter';

  @override
  String get iconSort => 'Sort';

  @override
  String get iconRefresh => 'Refresh';

  @override
  String get iconBack => 'Back';

  @override
  String get iconNext => 'Next';

  @override
  String get iconPrevious => 'Previous';

  @override
  String get iconClose => 'Close';

  @override
  String get iconEllipsis => 'Ellipsis';

  @override
  String get iconEllipsisH => 'Horizontal Ellipsis';

  @override
  String get iconEllipsisV => 'Vertical Ellipsis';

  @override
  String get iconChevronUp => 'Chevron Up';

  @override
  String get iconChevronDown => 'Chevron Down';

  @override
  String get iconChevronLeft => 'Chevron Left';

  @override
  String get iconChevronRight => 'Chevron Right';

  @override
  String get iconAngleUp => 'Angle Up';

  @override
  String get iconAngleDown => 'Angle Down';

  @override
  String get iconAngleLeft => 'Angle Left';

  @override
  String get iconAngleRight => 'Angle Right';

  @override
  String get iconAnglesUp => 'Angles Up';

  @override
  String get iconAnglesDown => 'Angles Down';

  @override
  String get iconUpRightAndDownLeftFromCenter => 'Expand';

  @override
  String get iconDownLeftAndUpRightToCenter => 'Collapse';

  @override
  String get iconPlay => 'Play';

  @override
  String get iconPause => 'Pause';

  @override
  String get iconStop => 'Stop';

  @override
  String get iconFilm => 'Film';

  @override
  String get iconFileText => 'Text File';

  @override
  String get iconFileLines => 'File';

  @override
  String get iconArrowLeft => 'Arrow Left';

  @override
  String get iconArrowRight => 'Arrow Right';

  @override
  String get iconArrowUp => 'Arrow Up';

  @override
  String get iconArrowDown => 'Arrow Down';

  @override
  String get iconArrowTurnUpLeft => 'Turn Arrow';

  @override
  String get iconArrowTurnUpRight => 'Turn Arrow';

  @override
  String get iconArrowTurnDownLeft => 'Turn Arrow';

  @override
  String get iconArrowTurnDownRight => 'Turn Arrow';

  @override
  String get iconXmark => 'Close';

  @override
  String get iconCheckCircle => 'Check Circle';

  @override
  String get iconTimesCircle => 'Error Circle';

  @override
  String get iconInfoCircleIcon => 'Info Circle';

  @override
  String get iconExclamationCircle => 'Exclamation Circle';

  @override
  String get chatWelcome => 'Welcome to KFU Assistant!';

  @override
  String get chatWelcomeMessage =>
      'I\'m your smart assistant. I can help you with studying, academic affairs, and solving study problems.';

  @override
  String get chatSuggestionCourses => 'Courses';

  @override
  String get chatSuggestionCoursesSubtitle => 'Help with a course';

  @override
  String get chatSuggestionCoursesAction =>
      'I need help solving a programming problem';

  @override
  String get chatSuggestionSchedules => 'Schedules';

  @override
  String get chatSuggestionSchedulesSubtitle => 'Know exam and lecture dates';

  @override
  String get chatSuggestionSchedulesAction => 'When are the final exams?';

  @override
  String get chatSuggestionGrades => 'Grades';

  @override
  String get chatSuggestionGradesSubtitle => 'Inquire about results and grades';

  @override
  String get chatSuggestionGradesAction => 'How do I check my grades?';

  @override
  String get chatSuggestionAcademic => 'Academic Affairs';

  @override
  String get chatSuggestionAcademicSubtitle => 'Inquire about academic affairs';

  @override
  String get chatSuggestionAcademicAction =>
      'I want to inquire about attendance';

  @override
  String get chatQuickActionProgramming => 'Programming Help';

  @override
  String get chatQuickActionProgrammingAction =>
      'I need help solving a programming problem';

  @override
  String get chatQuickActionAcademicDates => 'Academic Dates';

  @override
  String get chatQuickActionAcademicDatesAction =>
      'What are the important dates for the semester?';

  @override
  String get chatQuickActionProgrammingTips => 'Programming Tips';

  @override
  String get chatQuickActionProgrammingTipsAction =>
      'How can I improve my programming skills?';

  @override
  String get chatQuickActionDataStructures => 'Data Structures';

  @override
  String get chatQuickActionDataStructuresAction =>
      'I need an explanation of data structures';

  @override
  String get chatSearchInMessages => 'Search in messages...';

  @override
  String get chatNoSearchResults => 'No search results';

  @override
  String get chatWriteYourMessage => 'Write your message here...';

  @override
  String get chatFolders => 'Folders';

  @override
  String get chatAllChats => 'All Chats';

  @override
  String get chatNoFolders => 'No folders';

  @override
  String get chatDelete => 'Delete';

  @override
  String get chatSearchAndSettings => 'Search and Settings';

  @override
  String get chatSearchInChats => 'Search in chats...';

  @override
  String get chatSearchByDate => 'Search by Date';

  @override
  String get chatSearchByDateSubtitle => 'Search chats by date';

  @override
  String get chatSearchByFolder => 'Search by Folder';

  @override
  String get chatSearchByFolderSubtitle => 'Search chats in a specific folder';

  @override
  String get chatSearchByTags => 'Search by Tags';

  @override
  String get chatSearchByTagsSubtitle => 'Search using tags and keywords';

  @override
  String get chatSettingsTitle => 'Chat Settings';

  @override
  String get chatSettingsNotifications => 'Notifications';

  @override
  String get chatSettingsNotificationsSubtitle => 'Notification settings';

  @override
  String get chatSettingsAppearance => 'Appearance';

  @override
  String get chatSettingsAppearanceSubtitle => 'Change app appearance';

  @override
  String get chatSettingsLanguage => 'Language';

  @override
  String get chatSettingsLanguageSubtitle => 'Change app language';

  @override
  String get chatSettingsBackup => 'Backup';

  @override
  String get chatSettingsBackupSubtitle => 'Backup conversations';

  @override
  String get chatNewChat => 'New Chat';

  @override
  String chatMessageCount(int count) {
    return '$count message';
  }

  @override
  String chatLastActivity(String date) {
    return 'Last activity: $date';
  }

  @override
  String get chatSuggestionMedicine => 'Medicine';

  @override
  String get chatSuggestionMedicineSubtitle =>
      'Help with medical subjects and diagnosis';

  @override
  String get chatSuggestionMedicineAction =>
      'I need an explanation of how the heart and circulatory system work';

  @override
  String get chatSuggestionPharmacy => 'Pharmacy';

  @override
  String get chatSuggestionPharmacySubtitle =>
      'Help with medications and drug interactions';

  @override
  String get chatSuggestionPharmacyAction =>
      'What are the potential drug interactions between aspirin and ibuprofen?';

  @override
  String get chatSuggestionHealthSciences => 'Health Sciences';

  @override
  String get chatSuggestionHealthSciencesSubtitle =>
      'Help with health sciences and nutrition';

  @override
  String get chatSuggestionHealthSciencesAction =>
      'What are the essential nutrients for the body?';

  @override
  String get chatSuggestionEngineering => 'Engineering';

  @override
  String get chatSuggestionEngineeringSubtitle =>
      'Help with engineering subjects and design';

  @override
  String get chatSuggestionEngineeringAction =>
      'I need an explanation of thermodynamics principles';

  @override
  String get chatSuggestionComputerScience => 'Computer Science';

  @override
  String get chatSuggestionComputerScienceSubtitle =>
      'Help with programming and algorithms';

  @override
  String get chatSuggestionComputerScienceAction =>
      'How can I improve the performance of binary search algorithm?';

  @override
  String get chatSuggestionCivilEngineering => 'Civil Engineering';

  @override
  String get chatSuggestionCivilEngineeringSubtitle =>
      'Help with construction and infrastructure';

  @override
  String get chatSuggestionCivilEngineeringAction =>
      'What are the factors affecting bridge design?';

  @override
  String get chatSuggestionArts => 'Arts';

  @override
  String get chatSuggestionArtsSubtitle =>
      'Help with literature, language, and criticism';

  @override
  String get chatSuggestionArtsAction =>
      'What are the characteristics of pre-Islamic poetry?';

  @override
  String get chatSuggestionIslamicStudies => 'Islamic Studies';

  @override
  String get chatSuggestionIslamicStudiesSubtitle =>
      'Help with jurisprudence, interpretation, and hadith';

  @override
  String get chatSuggestionIslamicStudiesAction =>
      'What is the difference between jurisprudence and principles?';

  @override
  String get chatSuggestionEducation => 'Education';

  @override
  String get chatSuggestionEducationSubtitle =>
      'Help with education and teaching methods';

  @override
  String get chatSuggestionEducationAction =>
      'What are the best teaching methods for students with learning difficulties?';

  @override
  String get chatSuggestionBusiness => 'Business Administration';

  @override
  String get chatSuggestionBusinessSubtitle =>
      'Help with management, marketing, and finance';

  @override
  String get chatSuggestionBusinessAction =>
      'How can I analyze the target market for a new project?';

  @override
  String get chatSuggestionEconomics => 'Economics';

  @override
  String get chatSuggestionEconomicsSubtitle =>
      'Help with economics and finance';

  @override
  String get chatSuggestionEconomicsAction =>
      'What is the difference between macroeconomics and microeconomics?';

  @override
  String get chatSuggestionSciences => 'Sciences';

  @override
  String get chatSuggestionSciencesSubtitle =>
      'Help with physics and mathematics';

  @override
  String get chatSuggestionSciencesAction =>
      'I need an explanation of Newton\'s laws of motion';

  @override
  String get chatSuggestionChemistry => 'Chemistry';

  @override
  String get chatSuggestionChemistrySubtitle =>
      'Help with chemistry and reactions';

  @override
  String get chatSuggestionChemistryAction =>
      'What are the types of chemical reactions?';

  @override
  String get chatSuggestionBiology => 'Biology';

  @override
  String get chatSuggestionBiologySubtitle => 'Help with biology and genetics';

  @override
  String get chatSuggestionBiologyAction =>
      'How does photosynthesis work in plants?';

  @override
  String get chatMessageCopy => 'Copy';

  @override
  String get chatMessageEdit => 'Edit';

  @override
  String get chatMessageThumbUp => 'Thumb Up';

  @override
  String get chatMessageThumbDown => 'Thumb Down';

  @override
  String get chatMessageRetry => 'Retry';

  @override
  String get chatMessageCopied => 'Content copied';
}
