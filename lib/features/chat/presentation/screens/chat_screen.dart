import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/chatgpt_style_input_field.dart';
import '../widgets/recent_chats_widget.dart';
// import '../../../../features/folders/presentation/widgets/folder_sidebar.dart';
// import '../../../../features/chat_history/presentation/widgets/chat_list_sidebar.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_sessions_provider.dart';
import '../../../../core/widgets/neural_network_effect.dart';
import '../../../../core/theme/icons.dart';
// import '../../domain/models/chat.dart';
// import '../../domain/models/message.dart';
import '../../../../features/folders/domain/models/folder.dart';
import '../../../../features/help/presentation/screens/help_screen.dart';
import '../../../../features/settings/presentation/screens/settings_screen.dart'
    as settings;
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/search/presentation/screens/search_screen.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/providers/sidebar_provider.dart';
import '../../../../app/app.dart';
import '../../../../core/localization/l10n.dart';

/// الشاشة الرئيسية للمحادثة
///
/// تعرض واجهة المحادثة الكاملة مع الشريط الجانبي وقائمة المحادثات
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late Animation<double> _particleAnimation;

  final ScrollController _messageScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String? _selectedChatId; // بدء بشاشة فارغة
  // String? _selectedFolderId;
  // bool _showSidebar = true;
  bool _isSearching = false;

  final GlobalKey _messagesAreaKey = GlobalKey();

  // متغيرات للمراقبة
  int _previousMessageCount = 0;
  bool _previousTyping = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeData();
  }

  void _setupAnimations() {
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _particleController.repeat();
  }

  void _initializeData() {
    // تحميل البيانات الأولية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // بدء بشاشة فارغة بدون محادثة محددة
      // ref.read(chatProvider.notifier).createNewChat();
      // ref.read(folderProvider.notifier).loadDefaultFolders();
      // ref.read(chatHistoryProvider.notifier).loadChatHistory();
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    _messageScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final chatState = ref.watch(chatProvider);
    final isRTL = context.isRTL;

    // مراقبة التغييرات في الرسائل ومؤشر الكتابة
    final currentMessageCount = chatState.messages.length;
    final currentTyping = chatState.isTyping;

    // إذا تغير عدد الرسائل أو مؤشر الكتابة، قم بالتمرير
    if (currentMessageCount != _previousMessageCount ||
        currentTyping != _previousTyping) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
      _previousMessageCount = currentMessageCount;
      _previousTyping = currentTyping;
    }

    // ignore: avoid_print
    print('[ChatScreen] 🌍 isRTL: $isRTL');
    // ignore: avoid_print
    print(
      '[ChatScreen] 📍 TextDirection: ${ContextExtensions(context).textDirection}',
    );
    // ignore: avoid_print
    print(
      '[ChatScreen] 🗂️ drawer: ${isRTL ? 'set (يفتح من اليمين)' : 'null'}',
    );
    // ignore: avoid_print
    print(
      '[ChatScreen] 🗂️ endDrawer: ${isRTL ? 'null' : 'set (يفتح من اليمين)'}',
    );

    // التحقق من حالة sidebar
    final sidebarOpen = ref.watch(sidebarProvider);

    // التحقق من حجم الشاشة (يدعم التابلت وأجهزة الفولد مثل Samsung Fold)
    // نستخدم MediaQuery للحصول على حجم الشاشة الكامل
    // الحد الأدنى 600px يدعم: التابلت، أجهزة الفولد، والشاشات العريضة
    final isWideScreen = !context.isSmallScreen; // أي شاشة >= 600px

    return LayoutBuilder(
      builder: (context, constraints) {
        // في الشاشات العريضة (التابلت والفولد)، نستخدم sidebar دائم
        // نستخدم أيضاً constraints.maxWidth كمعيار إضافي للتأكد
        final canUseSidebar = isWideScreen || constraints.maxWidth >= 600;

        if (canUseSidebar) {
          // في الشاشات العريضة، نضع القائمة الجانبية والـ AppBar في نفس الـ Row
          return Scaffold(
            body: Row(
              children: [
                // Sidebar في الشاشات العريضة - يأخذ كامل الارتفاع (top: 0, bottom: 0)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: sidebarOpen ? 320 : 0,
                  child: sidebarOpen
                      ? const AppDrawer(isSidebar: true)
                      : const SizedBox.shrink(),
                ),
                // المحتوى الرئيسي مع AppBar
                Expanded(
                  child: Column(
                    children: [
                      // AppBar يدوي - يتحرك مع القائمة الجانبية
                      _buildAppBarContent(
                        theme,
                        chatState,
                        isRTL,
                        isWideScreen: true,
                      ),
                      // المحتوى الرئيسي
                      Expanded(
                        child: Stack(
                          children: [
                            // خلفية التأثير البصري
                            NeuralNetworkEffect(
                              animation: _particleAnimation,
                              primaryColor: theme.colorScheme.primary,
                            ),
                            // المحادثة الرئيسية
                            _buildMainChatArea(theme, chatState),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // في الشاشات الصغيرة، نستخدم drawer عادي
        return Scaffold(
          drawer: const AppDrawer(),
          appBar: _buildAppBar(theme, chatState, isRTL, isWideScreen: false),
          body: Stack(
            children: [
              // خلفية التأثير البصري
              NeuralNetworkEffect(
                animation: _particleAnimation,
                primaryColor: theme.colorScheme.primary,
              ),
              // المحادثة الرئيسية (تأخذ الشاشة كاملة)
              _buildMainChatArea(theme, chatState),
            ],
          ),
        );
      },
    );
  }

  /// بناء محتوى AppBar (Widget عادي)
  Widget _buildAppBarContent(
    ThemeData theme,
    dynamic chatState,
    bool isRTL, {
    bool isWideScreen = false,
  }) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Builder(
          builder: (builderContext) {
            return Row(
              children: [
                // أيقونة القائمة - من اليمين في RTL
                Consumer(
                  builder: (context, ref, _) {
                    final sidebarOpen = ref.watch(sidebarProvider);
                    return IconButton(
                      icon: Icon(
                        AppIcons.getIcon(AppIcon.menu),
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      onPressed: () {
                        if (isWideScreen) {
                          // في الشاشات العريضة، نستخدم toggle
                          ref.read(sidebarProvider.notifier).toggle();
                        } else {
                          // في الشاشات الصغيرة، نستخدم drawer عادي
                          // ignore: avoid_print
                          print('[Menu Button] 🔘 تم الضغط على زر القائمة');
                          // ignore: avoid_print
                          print('[Menu Button] 🌍 isRTL: $isRTL');
                          // ignore: avoid_print
                          print(
                            '[Menu Button] 🗂️ سيتم فتح: drawer (من اليمين في RTL)',
                          );

                          builderContext.openAdaptiveDrawer();
                        }
                      },
                      tooltip: isWideScreen
                          ? (sidebarOpen ? 'إغلاق القائمة' : 'فتح القائمة')
                          : 'القائمة',
                    );
                  },
                ),

                // المسافة
                const SizedBox(width: 8),

                // العنوان في المنتصف
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getChatTitle(chatState),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_getChatSubtitle(chatState).isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          _getChatSubtitle(chatState),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // المسافة
                const SizedBox(width: 8),

                // أيقونة الإعدادات - من اليسار في RTL
                IconButton(
                  icon: Icon(
                    AppIcons.getIcon(AppIcon.settings),
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.of(builderContext).push(
                      MaterialPageRoute(
                        builder: (context) => const settings.SettingsScreen(),
                      ),
                    );
                  },
                  tooltip: 'الإعدادات',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// بناء AppBar مخصص بالكامل (PreferredSizeWidget للاستخدام في appBar)
  PreferredSizeWidget _buildAppBar(
    ThemeData theme,
    dynamic chatState,
    bool isRTL, {
    bool isWideScreen = false,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: _buildAppBarContent(
        theme,
        chatState,
        isRTL,
        isWideScreen: isWideScreen,
      ),
    );
  }

  /// بناء منطقة المحادثة الرئيسية
  Widget _buildMainChatArea(ThemeData theme, dynamic chatState) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.outline.withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildMessagesArea(theme, chatState),
          _buildChatInput(theme),
        ],
      ),
    );
  }

  /// بناء منطقة الرسائل
  Widget _buildMessagesArea(ThemeData theme, dynamic chatState) {
    return Expanded(
      child: Stack(
        key: _messagesAreaKey,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _isSearching
                ? _buildSearchResults(theme)
                : _buildMessagesList(theme, chatState),
          ),
        ],
      ),
    );
  }

  /// بناء قائمة الرسائل
  Widget _buildMessagesList(ThemeData theme, dynamic chatState) {
    // عرض شاشة الترحيب إذا لم تكن هناك رسائل أو لم تكن هناك محادثة محددة
    if (chatState.messages.isEmpty || chatState.currentChat == null) {
      return _buildEmptyChatState(theme);
    }

    return ListView.builder(
      controller: _messageScrollController,
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 16, // مساحة إضافية في الأسفل
      ),
      itemCount: chatState.messages.length + (chatState.isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < chatState.messages.length) {
          final message = chatState.messages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: MessageBubble(message: message),
          );
        } else {
          // مؤشر الكتابة مع أيقونة المساعد
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAssistantAvatar(context.theme),
                const SizedBox(width: 8),
                TypingIndicator(userName: context.l10n.appNameShort),
              ],
            ),
          );
        }
      },
    );
  }

  /// بناء صورة شخصية المساعد لظهور مؤشر الكتابة بجوارها
  Widget _buildAssistantAvatar(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        color: theme.colorScheme.secondary,
        child: Image.asset(
          'assets/images/mosa3ed_kfu_icon_app.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// بناء حالة المحادثة الفارغة (رسالة الترحيب)
  Widget _buildEmptyChatState(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة التطبيق
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(51),
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  'assets/images/mosa3ed_kfu_icon_app.jpg',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // عنوان الترحيب
            Text(
              'مرحباً بك في مساعد كفو!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // نص الترحيب
            Text(
              'أنا مساعدك الذكي. يمكنني مساعدتك في المذاكرة، الشؤون الأكاديمية، وحل المشاكل الدراسية.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // بطاقات الاقتراحات
            _buildSuggestionCards(theme),

            const SizedBox(height: 32),

            // الإجراءات السريعة
            _buildQuickActions(theme),
          ],
        ),
      ),
    );
  }

  /// بناء بطاقات الاقتراحات
  Widget _buildSuggestionCards(ThemeData theme) {
    final suggestions = [
      {
        'icon': '📖',
        'title': 'المقررات الدراسية',
        'subtitle': 'مساعدة في أحد المقررات الدراسية',
        'action': 'أريد مساعدة في حل مشكلة برمجية',
      },
      {
        'icon': '📅',
        'title': 'الجداول الدراسية',
        'subtitle': 'معرفة مواعيد الامتحانات والمحاضرات',
        'action': 'متى موعد الامتحانات النهائية؟',
      },
      {
        'icon': '📊',
        'title': 'الدرجات والتقديرات',
        'subtitle': 'الاستعلام عن النتائج والدرجات',
        'action': 'كيف أستعلم عن درجاتي؟',
      },
      {
        'icon': '🎓',
        'title': 'الشؤون الأكاديمية',
        'subtitle': 'الاستفسار عن الشؤون الأكاديمية',
        'action': 'أريد أن أستفسر عن موضوع بخصوص الحضور',
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isLargeScreen = constraints.maxWidth > 900;

        if (isSmallScreen) {
          // قائمة عمودية للشاشات الصغيرة
          return Column(
            children: suggestions.map((suggestion) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSuggestionCard(
                  theme,
                  suggestion,
                  isSmallScreen: true,
                ),
              );
            }).toList(),
          );
        } else {
          // شبكة للأجهزة المتوسطة والكبيرة
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isLargeScreen ? 1000 : 800, // زيادة العرض الأقصى
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 أزرار في الصف
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isLargeScreen ? 1.2 : 1.3,
                ),
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return _buildSuggestionCard(
                    theme,
                    suggestion,
                    isSmallScreen: false,
                    maxWidth: isLargeScreen
                        ? 250
                        : 200, // حد أقصى 250px للشاشات الكبيرة، 200px للمتوسطة
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  /// بناء بطاقة اقتراح واحدة
  Widget _buildSuggestionCard(
    ThemeData theme,
    Map<String, String> suggestion, {
    required bool isSmallScreen,
    double? maxWidth,
  }) {
    Widget card = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onSuggestionTapped(suggestion['action']!),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: isSmallScreen
              ? const EdgeInsets.all(12)
              : const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withAlpha(51),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withAlpha(25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isSmallScreen
              ? Row(
                  children: [
                    // الإيموجي في الشاشات الصغيرة
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          suggestion['icon']!,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // النص في الشاشات الصغيرة
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion['title']!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            suggestion['subtitle']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    // حساب حجم النص بناءً على حجم الزر المتاح
                    final availableHeight = constraints.maxHeight;

                    // حساب الأحجام بناءً على الحجم المتاح مع حدود دنيا وعليا
                    final iconSize = (availableHeight * 0.3).clamp(28.0, 48.0);
                    final fontSizeTitle = (availableHeight * 0.15).clamp(
                      11.0,
                      15.0,
                    );
                    final fontSizeSubtitle = (availableHeight * 0.11).clamp(
                      9.0,
                      13.0,
                    );
                    final spacingBetween = (availableHeight * 0.06).clamp(
                      4.0,
                      12.0,
                    );

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // الإيموجي في الشاشات الكبيرة - يتكيف مع الحجم
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(iconSize / 2),
                          ),
                          child: Center(
                            child: Text(
                              suggestion['icon']!,
                              style: TextStyle(fontSize: iconSize * 0.48),
                            ),
                          ),
                        ),
                        SizedBox(height: spacingBetween),
                        // العنوان - يتكيف مع الحجم
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              suggestion['title']!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                                fontSize: fontSizeTitle,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(height: spacingBetween * 0.7),
                        // العنوان الفرعي - يتكيف مع الحجم
                        Flexible(
                          child: Text(
                            suggestion['subtitle']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: fontSizeSubtitle,
                              height: 1.15,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );

    // إضافة حد أقصى للعرض إذا تم تحديده
    if (maxWidth != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: card,
      );
    }

    return card;
  }

  /// بناء الإجراءات السريعة
  Widget _buildQuickActions(ThemeData theme) {
    final actions = [
      {
        'icon': AppIcon.code,
        'title': 'مساعدة في البرمجة',
        'action': 'أحتاج مساعدة في حل مشكلة برمجية',
      },
      {
        'icon': AppIcon.calendarAlt,
        'title': 'المواعيد الأكاديمية',
        'action': 'ما هي المواعيد المهمة للفصل الدراسي؟',
      },
      {
        'icon': AppIcon.brain,
        'title': 'نصائح البرمجة',
        'action': 'كيف أحسن مهاراتي في البرمجة؟',
      },
      {
        'icon': AppIcon.sitemap,
        'title': 'هياكل البيانات',
        'action': 'أحتاج شرح لهياكل البيانات',
      },
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions.map((action) {
        return _buildQuickActionButton(theme, action);
      }).toList(),
    );
  }

  /// بناء زر الإجراء السريع
  Widget _buildQuickActionButton(ThemeData theme, Map<String, dynamic> action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onSuggestionTapped(action['action']),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withAlpha(25),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AppIcons.getIcon(action['icon']),
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                action['title'],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء نتائج البحث
  Widget _buildSearchResults(ThemeData theme) {
    return Column(
      children: [
        // شريط البحث
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'البحث في الرسائل...',
            prefixIcon: Icon(AppIcons.getIcon(AppIcon.search)),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
              icon: Icon(AppIcons.getIcon(AppIcon.close)),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            // TODO: تطبيق البحث في الرسائل
          },
        ),
        const SizedBox(height: 16),

        // نتائج البحث
        Expanded(
          child: Center(
            child: Text(
              'لا توجد نتائج بحث',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// بناء حقل إدخال المحادثة
  Widget _buildChatInput(ThemeData theme) {
    return ChatGPTStyleInputField(
      onSend: (message) => _onMessageSent(message),
      onAttachFile: () => _onAttachmentSelected('file'),
      enabled: !_isSearching,
      hintText: 'اكتب رسالتك هنا...',
      onTextChanged: (text) {
        // يمكن إضافة معالجة تغيير النص هنا إذا لزم الأمر
      },
    );
  }

  /// بناء القائمة الجانبية الرئيسية (المجلدات والمحادثات) - DEPRECATED
  Widget _buildNavigationDrawer(ThemeData theme) {
    final authState = ref.watch(authProvider);
    final userName = authState.loginResponse?.profile?['fullName'] ?? 'مستخدم';
    final userId = authState.userId ?? '';

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      width: 320,
      child: SafeArea(
        child: Column(
          children: [
            // رأس القائمة مع الشعار
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withAlpha(25),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/images/mosa3ed_kfu_icon_app.jpg',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'مساعد كفو',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // معلومات المستخدم وزر الخروج
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: theme.colorScheme.secondary),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(
                      AppIcons.getIcon(AppIcon.user),
                      size: 20,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // ID المستخدم
                        const SizedBox(height: 2),
                        Text(
                          userId.isNotEmpty
                              ? 'ID: ${userId.substring(0, 8)}...'
                              : '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) {
                        // العودة إلى SplashScreen بعد تسجيل الخروج
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    icon: Icon(
                      AppIcons.getIcon(AppIcon.signOut),
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    tooltip: 'تسجيل الخروج',
                  ),
                ],
              ),
            ),

            // أزرار محادثة جديدة والبحث
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Column(
                children: [
                  // زر محادثة جديدة
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(chatProvider.notifier).createNewChat();
                      },
                      icon: Icon(AppIcons.getIcon(AppIcon.plus), size: 16),
                      label: const Text('محادثة جديدة'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // زر البحث
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: فتح البحث في سجل المحادثات
                      },
                      icon: Icon(AppIcons.getIcon(AppIcon.search), size: 16),
                      label: const Text('بحث في المحادثات'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // المحتوى القابل للتمرير (مثل الويب)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // قسم المجلدات (مثل الويب)
                    _buildFoldersSection(theme),

                    // قسم المحادثات الأخيرة (مثل الويب)
                    _buildRecentChatsSection(theme),
                  ],
                ),
              ),
            ),

            // تذييل القائمة الجانبية
            _buildSidebarFooter(theme),
          ],
        ),
      ),
    );
  }

  /// بناء قسم المجلدات
  Widget _buildFoldersSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان قسم المجلدات
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.folder),
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'المجلدات',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // TODO: إضافة مجلد جديد
                  },
                  icon: Icon(
                    AppIcons.getIcon(AppIcon.plus),
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // قائمة المجلدات
          _buildFolderList(theme),
        ],
      ),
    );
  }

  /// بناء قسم المحادثات الأخيرة
  Widget _buildRecentChatsSection(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان قسم المحادثات
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(25),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.chat),
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'المحادثات الأخيرة',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    ref.read(chatSessionsProvider.notifier).loadRecentChats();
                  },
                  icon: Icon(
                    AppIcons.getIcon(AppIcon.refresh),
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  tooltip: 'تحديث',
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // قائمة المحادثات
          _buildChatList(theme),
        ],
      ),
    );
  }

  /// بناء تذييل القائمة الجانبية
  Widget _buildSidebarFooter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(75),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withAlpha(25),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildFooterMenuItem(
            theme,
            icon: AppIcons.getIcon(AppIcon.settings),
            title: 'الإعدادات',
            onTap: () {
              Navigator.pop(context);
              // TODO: فتح الإعدادات
            },
          ),
          const SizedBox(height: 4),
          _buildFooterMenuItem(
            theme,
            icon: AppIcons.getIcon(AppIcon.help),
            title: 'المساعدة',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  /// بناء عنصر في تذييل القائمة الجانبية
  Widget _buildFooterMenuItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// الحصول على عنوان المحادثة
  String _getChatTitle(dynamic chatState) {
    if (chatState.currentChat != null) {
      return chatState.currentChat.title;
    }
    return 'محادثة جديدة';
  }

  /// الحصول على العنوان الفرعي للمحادثة
  String _getChatSubtitle(dynamic chatState) {
    if (chatState.currentChat != null) {
      final chat = chatState.currentChat;
      if (chat.messageCount > 0) {
        return '${chat.messageCount} رسالة • آخر نشاط: ${chat.updatedAt.toString()}';
      }
    }
    return '';
  }

  // ==================== Event Handlers ====================

  void _onFolderSelected(String? folderId) {
    // setState(() {
    //   _selectedFolderId = folderId;
    //   _selectedChatId = null; // إعادة تعيين المحادثة المحددة
    // });

    // تحديث فلتر المحادثات حسب المجلد المحدد
    if (folderId != null) {
      // ref.read(chatHistoryProvider.notifier).filterByFolder(folderId);
    } else {
      // ref.read(chatHistoryProvider.notifier).clearFilter();
    }
  }

  void _onChatSelected(String? chatId) {
    // ignore: avoid_print
    print('\n╔═══════════════════════════════════════════════');
    // ignore: avoid_print
    print('║ 💬 ChatScreen: اختيار محادثة');
    // ignore: avoid_print
    print('╠═══════════════════════════════════════════════');
    // ignore: avoid_print
    print('║ 🆔 Chat ID: $chatId');
    // ignore: avoid_print
    print('╚═══════════════════════════════════════════════\n');

    setState(() {
      _selectedChatId = chatId;
    });

    if (chatId != null) {
      // ignore: avoid_print
      print('📥 تحميل المحادثة...\n');

      // تحميل المحادثة المحددة
      ref.read(chatProvider.notifier).loadChat(chatId);
    } else {
      // ignore: avoid_print
      print('➕ إنشاء محادثة جديدة...\n');

      // إنشاء محادثة جديدة
      ref.read(chatProvider.notifier).createNewChat();
    }
  }

  void _onCreateChat() {
    // setState(() {
    //   _selectedChatId = null;
    // });
    ref.read(chatProvider.notifier).createNewChat();
  }

  void _onCreateFolder() {
    // TODO: عرض نافذة إنشاء مجلد جديد
    showDialog(
      context: context,
      builder: (context) => _buildCreateFolderDialog(),
    );
  }

  void _onEditFolder(Folder folder) {
    // TODO: عرض نافذة تعديل المجلد
    showDialog(
      context: context,
      builder: (context) => _buildEditFolderDialog(folder),
    );
  }

  void _onDeleteFolder(Folder folder) {
    // تأكيد الحذف
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المجلد'),
        content: Text('هل أنت متأكد من حذف مجلد "${folder.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // ref.read(folderProvider.notifier).deleteFolder(folder.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _onMessageSent(String message) {
    if (message.trim().isNotEmpty) {
      // إخفاء لوحة المفاتيح
      FocusScope.of(context).unfocus();

      // إرسال الرسالة عبر ChatProvider
      ref.read(chatProvider.notifier).sendMessage(message);

      // التمرير إلى آخر رسالة بعد فترة قصيرة
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    }
  }

  /// تمرير إلى آخر رسالة
  void _scrollToBottom({bool animate = true}) {
    if (!_messageScrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_messageScrollController.hasClients) return;

      final maxScroll = _messageScrollController.position.maxScrollExtent;

      if (animate) {
        _messageScrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      } else {
        _messageScrollController.jumpTo(maxScroll);
      }
    });
  }

  void _onSuggestionTapped(String message) {
    // إرسال الرسالة المقترحة مباشرة
    if (message.trim().isNotEmpty) {
      // إخفاء لوحة المفاتيح
      FocusScope.of(context).unfocus();

      ref.read(chatProvider.notifier).sendMessage(message);

      // التمرير للأسفل بعد فترة قصيرة
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    }
  }

  void _onAttachmentSelected(String attachmentType) {
    // TODO: معالجة إضافة المرفقات
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديد $attachmentType'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onSearch(String query) {
    // البحث في المحادثات
    // ref.read(chatHistoryProvider.notifier).searchChats(query);
  }

  void _onSearchToggle() {
    // setState(() {
    //   _isSearching = !_isSearching;
    //   if (!_isSearching) {
    //     _searchController.clear();
    //   }
    // });
  }

  void _onFilterChanged(dynamic filter) {
    // ref.read(chatHistoryProvider.notifier).applyFilter(filter);
  }

  void _onSortChanged(dynamic sort) {
    // ref.read(chatHistoryProvider.notifier).changeSort(sort);
  }

  void _onChatSettings() {
    // TODO: عرض إعدادات المحادثة
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('إعدادات المحادثة'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ==================== Dialog Builders ====================

  Widget _buildCreateFolderDialog() {
    return AlertDialog(
      title: const Text('إنشاء مجلد جديد'),
      content: const TextField(
        decoration: InputDecoration(
          labelText: 'اسم المجلد',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO: إنشاء المجلد
          },
          child: const Text('إنشاء'),
        ),
      ],
    );
  }

  Widget _buildEditFolderDialog(Folder folder) {
    return AlertDialog(
      title: const Text('تعديل المجلد'),
      content: TextField(
        decoration: const InputDecoration(
          labelText: 'اسم المجلد',
          border: OutlineInputBorder(),
        ),
        controller: TextEditingController(text: folder.name),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO: تحديث المجلد
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }

  /// بناء قائمة المجلدات المبسطة
  Widget _buildFolderList(ThemeData theme) {
    final folders = [
      {'name': 'جميع المحادثات', 'icon': AppIcon.inbox, 'count': '4'},
      {'name': 'البرمجة', 'icon': AppIcon.code, 'count': '1'},
      {'name': 'هياكل البيانات', 'icon': AppIcon.sitemap, 'count': '1'},
      {
        'name': 'الشؤون الأكاديمية',
        'icon': AppIcon.graduationCap,
        'count': '2',
      },
    ];

    return Column(
      children: folders.map((folder) {
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          leading: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              AppIcons.getIcon(folder['icon'] as AppIcon),
              size: 14,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            folder['name'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              folder['count'] as String,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            // _onFolderSelected(folder['name'] as String);
          },
        );
      }).toList(),
    );
  }

  /// بناء قائمة المحادثات المبسطة
  Widget _buildChatList(ThemeData theme) {
    return SizedBox(
      height: 300, // ارتفاع محدد للقائمة
      child: RecentChatsWidget(
        selectedSessionId: _selectedChatId,
        onSessionSelected: (sessionId) {
          Navigator.pop(context);
          _onChatSelected(sessionId);
        },
        showRefreshButton: false, // لأن هناك زر تحديث في القسم
      ),
    );
  }

  /// بناء القائمة الجانبية الثانوية (البحث والإعدادات) - DEPRECATED
  Widget _buildEndDrawer(ThemeData theme) {
    print('[ChatScreen] 🎨 بناء EndDrawer مع زر البحث');
    return Drawer(
      child: Column(
        children: [
          // رأس البحث
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(51),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(51),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Text(
                    'البحث والإعدادات',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // زر البحث
                  InkWell(
                    onTap: () {
                      print('🔥🔥🔥 تم النقر على زر البحث 🔥🔥🔥');
                      print('[ChatScreen] 🔍 تم النقر على زر البحث');
                      Navigator.pop(context);
                      print('[ChatScreen] 🔍 تم إغلاق القائمة الجانبية');
                      // الانتقال لشاشة البحث
                      print('[ChatScreen] 🔍 بدء الانتقال لشاشة البحث...');
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                print('[ChatScreen] 🔍 بناء SearchScreen...');
                                return const SearchScreen();
                              },
                            ),
                          )
                          .then((_) {
                            print('[ChatScreen] 🔍 عودة من SearchScreen');
                          })
                          .catchError((error) {
                            print(
                              '[ChatScreen] ❌ خطأ في الانتقال لشاشة البحث: $error',
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            AppIcons.getIcon(AppIcon.search),
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'البحث في المحادثات...',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // خيارات البحث والفلترة
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSearchOption(
                  theme,
                  AppIcon.calendarAlt,
                  'البحث بالتاريخ',
                  'البحث في المحادثات حسب التاريخ',
                ),
                _buildSearchOption(
                  theme,
                  AppIcon.folder,
                  'البحث بالمجلد',
                  'البحث في محادثات مجلد معين',
                ),
                _buildSearchOption(
                  theme,
                  AppIcon.search,
                  'البحث بالعلامات',
                  'البحث باستخدام العلامات والكلمات المفتاحية',
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                Text(
                  'إعدادات المحادثة',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                _buildSettingOption(
                  theme,
                  AppIcon.bell,
                  'الإشعارات',
                  'إعدادات الإشعارات',
                ),
                _buildSettingOption(
                  theme,
                  AppIcon.palette,
                  'المظهر',
                  'تغيير مظهر التطبيق',
                ),
                _buildSettingOption(
                  theme,
                  AppIcon.settings,
                  'اللغة',
                  'تغيير لغة التطبيق',
                ),
                _buildSettingOption(
                  theme,
                  AppIcon.download,
                  'النسخ الاحتياطي',
                  'نسخ احتياطي للمحادثات',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// بناء خيار البحث
  Widget _buildSearchOption(
    ThemeData theme,
    AppIcon icon,
    String title,
    String subtitle,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          AppIcons.getIcon(icon),
          size: 20,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // TODO: تنفيذ البحث
      },
    );
  }

  /// بناء خيار الإعدادات
  Widget _buildSettingOption(
    ThemeData theme,
    AppIcon icon,
    String title,
    String subtitle,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          AppIcons.getIcon(icon),
          size: 20,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        AppIcons.getIcon(AppIcon.chevronLeft),
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: () {
        Navigator.pop(context);
        // TODO: فتح الإعدادات
      },
    );
  }
}
