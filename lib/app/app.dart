import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/theme/app_theme.dart';
import '../core/localization/l10n.dart';
import '../core/widgets/splash_background.dart';
import '../core/widgets/splash_image_logo.dart';
import '../core/widgets/neural_network_effect.dart';
import '../core/widgets/animated_kfu_logo.dart';
import '../core/widgets/animated_delit_logo.dart';
import '../core/widgets/floating_input_field.dart';
import '../core/widgets/password_related_elements.dart';
import '../state/app_state.dart';
import '../features/chat/presentation/screens/chat_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/chat/presentation/providers/chat_sessions_provider.dart';

/// Main application widget
class KfuAiApp extends ConsumerWidget {
  const KfuAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'KFU AI Assistant',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Localization configuration
      locale: locale,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      supportedLocales: AppLocalization.supportedLocales,

      // Home screen
      home: const SplashScreen(),
    );
  }
}

/// Splash screen widget
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _particleController;
  late AnimationController _kfuLogoController;
  late AnimationController _delitLogoController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _kfuLogoAnimation;
  late Animation<double> _delitLogoAnimation;
  late AnimationController _countdownController;
  int _countdown = 30;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNextScreen();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _kfuLogoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _delitLogoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _countdownController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _kfuLogoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _kfuLogoController, curve: Curves.easeIn),
    );

    _delitLogoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _delitLogoController, curve: Curves.easeIn),
    );

    _animationController.forward();
    _particleController.repeat();
    _startCountdown();

    // Start logo animations with delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _kfuLogoController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _delitLogoController.forward();
      }
    });
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;

      // ignore: avoid_print
      print('\n╔═══════════════════════════════════════════════');
      // ignore: avoid_print
      print('║ 🚀 SplashScreen: التحقق من تسجيل الدخول');
      // ignore: avoid_print
      print('╚═══════════════════════════════════════════════\n');

      try {
        // التحقق من وجود جلسة محفوظة
        final authState = ref.read(authProvider);

        // ignore: avoid_print
        print('📊 Is Authenticated: ${authState.isAuthenticated}');

        // محاولة تحميل الجلسة من TokenManager
        // ignore: avoid_print
        print('🔍 البحث عن جلسة محفوظة...');

        final sessionValid = await ref
            .read(authProvider.notifier)
            .checkSavedSession();

        if (sessionValid && mounted) {
          // ignore: avoid_print
          print('✅ تم العثور على جلسة صالحة - الانتقال إلى ChatScreen\n');

          // تحميل المحادثات الأخيرة
          await ref.read(chatSessionsProvider.notifier).loadRecentChats();

          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          }
        } else {
          // ignore: avoid_print
          print('❌ لا توجد جلسة محفوظة - الانتقال إلى LoginScreen\n');

          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        }
      } catch (e) {
        // ignore: avoid_print
        print('❌ خطأ في التحقق من الجلسة: $e\n');

        // في حالة الخطأ، الانتقال إلى LoginScreen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    });
  }

  void _startCountdown() {
    _countdownController.forward();
    _countdownController.addListener(() {
      if (mounted) {
        setState(() {
          _countdown = 15 - (_countdownController.value * 30).round();
        });
      }
    });

    // Auto navigate when countdown reaches 0
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _particleController.dispose();
    _kfuLogoController.dispose();
    _delitLogoController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        child: SplashBackground(
          particleAnimation: _particleAnimation,
          child: Stack(
            children: [
              // Neural network effect
              NeuralNetworkEffect(
                animation: _particleAnimation,
                primaryColor: Theme.of(context).colorScheme.primary,
              ),
              // Animated KFU Logo at top left
              AnimatedKfuLogo(
                animation: _kfuLogoAnimation,
                logoPath: 'assets/images/kfu_logo.png',
                logoHeight: 75,
                top: 0,
                left: 20,
              ),
              // Main content
              Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.2,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Main logo with light rays
                              SplashImageLogo(
                                animationController: _animationController,
                                imagePath:
                                    'assets/images/mosa3ed_kfu_icon_app.jpg',
                                logoSize: 75,
                                logoColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),

                              const SizedBox(height: 40),

                              // Welcome message
                              Text(
                                context.l10n.appWelcomeMessage,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 8),

                              // App Description
                              Text(
                                context.l10n.appDescription,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 24),

                              // Loading indicator with countdown
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      strokeWidth: 1,
                                      value: _countdown / 16,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      '$_countdown',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Login button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  context.l10n.authLogin,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Animated DELIT Logo and text at bottom
              AnimatedDelitLogo(
                animation: _delitLogoAnimation,
                logoPath: 'assets/images/delit_logo.png',
                logoHeight: 36,
                developmentText:
                    'تم التصميم والتطوير بعمادة التعلم الإلكتروني وتقنية المعلومات 2025',
                versionText: 'الإصدار 1.0.0',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Login screen widget with animations
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _academicIdController;
  late AnimationController _passwordController;
  late AnimationController _passwordElementsController;
  late AnimationController _logoController;
  late Animation<double> _particleAnimation;
  late Animation<double> _academicIdAnimation;
  late Animation<double> _passwordAnimation;
  late Animation<double> _passwordElementsAnimation;
  late Animation<double> _logoAnimation;

  final TextEditingController _academicIdTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isPasswordStep = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _academicIdController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _passwordController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _passwordElementsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _academicIdAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _academicIdController, curve: Curves.easeInOut),
    );

    _passwordAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _passwordController, curve: Curves.easeInOut),
    );

    _passwordElementsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _passwordElementsController,
        curve: Curves.easeInOut,
      ),
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _particleController.repeat();
    _academicIdController.forward();
    _logoController.forward();
  }

  void _onNextPressed() {
    if (!_isPasswordStep) {
      // Start exit animation for academic ID
      _academicIdController.reverse().then((_) {
        // Start enter animations for password elements
        _passwordController.forward();
        _passwordElementsController.forward();
        // Change state after animations are set up
        setState(() {
          _isPasswordStep = true;
        });
      });
    }
  }

  void _onPreviousPressed() {
    if (_isPasswordStep) {
      // Start exit animations for password elements
      _passwordController.reverse();
      _passwordElementsController.reverse().then((_) {
        // Start enter animation for academic ID
        _academicIdController.forward();
        // Change state after animations are set up
        setState(() {
          _isPasswordStep = false;
        });
      });
    }
  }

  void _onLoginPressed() async {
    // ignore: avoid_print
    print('\n╔═══════════════════════════════════════════════');
    // ignore: avoid_print
    print('║ 🔐 LoginScreen: بدء عملية تسجيل الدخول');
    // ignore: avoid_print
    print('╠═══════════════════════════════════════════════');

    // التحقق من إدخال البيانات
    final studentNumber = _academicIdTextController.text.trim();
    final password = _passwordTextController.text;

    // ignore: avoid_print
    print('║ 📝 الرقم الجامعي: $studentNumber');
    // ignore: avoid_print
    print('║ 📝 طول كلمة المرور: ${password.length} حرف');
    // ignore: avoid_print
    print(
      '║ 📝 كلمة المرور: ${password.length > 3 ? password.substring(0, 3) : password}***',
    );

    if (studentNumber.isEmpty || password.isEmpty) {
      // ignore: avoid_print
      print('║ ❌ البيانات فارغة!');
      // ignore: avoid_print
      print('╚═══════════════════════════════════════════════\n');
      _showErrorMessage('يرجى إدخال الرقم الجامعي وكلمة المرور');
      return;
    }

    // ignore: avoid_print
    print('║ ✅ البيانات مكتملة - بدء المصادقة...');
    // ignore: avoid_print
    print('╚═══════════════════════════════════════════════\n');

    // عرض مؤشر التحميل
    setState(() {
      _isLoading = true;
    });

    // محاولة تسجيل الدخول
    // ignore: avoid_print
    print('🔄 استدعاء AuthProvider.login()...\n');

    final success = await ref
        .read(authProvider.notifier)
        .login(studentNumber, password);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // ignore: avoid_print
    print('\n╔═══════════════════════════════════════════════');
    // ignore: avoid_print
    print('║ 📊 نتيجة تسجيل الدخول: ${success ? "نجاح ✅" : "فشل ❌"}');
    // ignore: avoid_print
    print('╠═══════════════════════════════════════════════');

    if (success) {
      final authState = ref.read(authProvider);
      // ignore: avoid_print
      print('║ ✅ تم تسجيل الدخول بنجاح!');
      // ignore: avoid_print
      print('║ 👤 User ID: ${authState.userId}');
      // ignore: avoid_print
      print('║ 📦 Profile: ${authState.loginResponse?.profile}');
      // ignore: avoid_print
      print('╚═══════════════════════════════════════════════\n');

      // تحميل المحادثات الأخيرة
      // ignore: avoid_print
      print('📥 تحميل المحادثات الأخيرة...\n');
      ref.read(chatSessionsProvider.notifier).refreshAll();

      // إخفاء الشعارات والانتقال للمحادثة
      _logoController.reverse().then((_) {
        if (mounted) {
          // ignore: avoid_print
          print('🔄 الانتقال إلى ChatScreen...\n');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        }
      });
    } else {
      // عرض رسالة الخطأ
      final error = ref.read(authProvider).error;
      // ignore: avoid_print
      print('║ ❌ فشل تسجيل الدخول!');
      // ignore: avoid_print
      print('║ 💬 رسالة الخطأ: $error');
      // ignore: avoid_print
      print('╚═══════════════════════════════════════════════\n');

      _showErrorMessage(error ?? 'فشل تسجيل الدخول');
    }
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    _academicIdController.dispose();
    _passwordController.dispose();
    _passwordElementsController.dispose();
    _logoController.dispose();
    _academicIdTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SplashBackground(
        particleAnimation: _particleAnimation,
        child: Stack(
          children: [
            // Neural network effect
            NeuralNetworkEffect(
              animation: _particleAnimation,
              primaryColor: Theme.of(context).colorScheme.primary,
            ),
            // Animated KFU Logo at top left
            AnimatedKfuLogo(
              animation: _logoAnimation,
              logoPath: 'assets/images/kfu_logo.png',
              logoHeight: 75,
              top: 0,
              left: 20,
            ),
            // Main content
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15 + 50,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width > 400
                          ? 400
                          : double.infinity,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Main logo with light rays
                        SplashImageLogo(
                          animationController: _academicIdAnimation,
                          imagePath: 'assets/images/mosa3ed_kfu_icon_app.jpg',
                          logoSize: 75,
                          logoColor: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        // Login Title
                        Text(
                          context.l10n.authLoginTitle,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        // Academic ID input (first step)
                        if (!_isPasswordStep)
                          FloatingInputField(
                            animation: _academicIdAnimation,
                            label: context.l10n.authAcademicId,
                            hint: context.l10n.authAcademicIdHint,
                            controller: _academicIdTextController,
                            icon: FontAwesomeIcons.user,
                            onNext: _onNextPressed,
                            nextButtonText: context.l10n.authNext,
                            isRTL:
                                Localizations.localeOf(context).languageCode ==
                                'ar',
                          ),
                        // Password input (second step)
                        if (_isPasswordStep)
                          FloatingInputField(
                            animation: _passwordAnimation,
                            label: context.l10n.authPassword,
                            hint: context.l10n.authPasswordHint,
                            controller: _passwordTextController,
                            icon: FontAwesomeIcons.lock,
                            isPassword: true,
                            showNextButton: false,
                            isRTL:
                                Localizations.localeOf(context).languageCode ==
                                'ar',
                          ),
                        // Password related elements (only in password step)
                        if (_isPasswordStep)
                          PasswordRelatedElements(
                            animation: _passwordElementsAnimation,
                            rememberMe: _rememberMe,
                            onRememberMeChanged: (value) {
                              setState(() {
                                _rememberMe = value;
                              });
                            },
                            onPrevious: _onPreviousPressed,
                            onLogin: _isLoading ? null : _onLoginPressed,
                            isRTL:
                                Localizations.localeOf(context).languageCode ==
                                'ar',
                            isLoading: _isLoading,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Animated DELIT Logo and text at bottom
            AnimatedDelitLogo(
              animation: _logoAnimation,
              logoPath: 'assets/images/delit_logo.png',
              logoHeight: 36,
              developmentText:
                  'تم التصميم والتطوير بعمادة التعلم الإلكتروني وتقنية المعلومات 2025',
              versionText: 'الإصدار 1.0.0',
            ),
          ],
        ),
      ),
    );
  }
}
