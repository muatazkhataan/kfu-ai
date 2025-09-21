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
import '../core/widgets/remember_me_checkbox.dart';
import '../core/widgets/login_navigation_buttons.dart';
import '../state/app_state.dart';

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
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
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
    // Future.delayed(const Duration(seconds: 3), () {
    //   if (mounted) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const LoginScreen()),
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _particleController.dispose();
    _kfuLogoController.dispose();
    _delitLogoController.dispose();
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
                top: 50,
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

                              const SizedBox(height: 16),

                              // App Name
                              Text(
                                context.l10n.appName,
                                style: Theme.of(context).textTheme.displayMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
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

                              const SizedBox(height: 48),

                              // Loading indicator
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Tap instruction
                              Text(
                                'اضغط للمتابعة',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontStyle: FontStyle.italic,
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
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _academicIdController;
  late AnimationController _passwordController;
  late Animation<double> _particleAnimation;
  late Animation<double> _academicIdAnimation;
  late Animation<double> _passwordAnimation;

  final TextEditingController _academicIdTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isPasswordStep = false;
  bool _rememberMe = false;

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

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    _academicIdAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _academicIdController, curve: Curves.easeInOut),
    );

    _passwordAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _passwordController, curve: Curves.easeInOut),
    );

    _particleController.repeat();
    _academicIdController.forward();
  }

  void _onNextPressed() {
    if (!_isPasswordStep) {
      // Move to password step
      setState(() {
        _isPasswordStep = true;
      });

      _academicIdController.reverse().then((_) {
        _passwordController.forward();
      });
    }
  }

  void _onPreviousPressed() {
    if (_isPasswordStep) {
      // Move back to academic ID step
      setState(() {
        _isPasswordStep = false;
      });

      _passwordController.reverse().then((_) {
        _academicIdController.forward();
      });
    }
  }

  void _onLoginPressed() {
    // TODO: Implement login logic
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    _academicIdController.dispose();
    _passwordController.dispose();
    _academicIdTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              animation: _academicIdAnimation,
              logoPath: 'assets/images/kfu_logo.png',
              logoHeight: 75,
              top: 50,
              left: 20,
            ),
            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main logo with light rays
                    SplashImageLogo(
                      animationController: _academicIdAnimation,
                      imagePath: 'assets/images/mosa3ed_kfu_icon_app.jpg',
                      logoSize: 75,
                      logoColor: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    // App Name
                    Text(
                      context.l10n.appName,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // App Description
                    Text(
                      context.l10n.appDescription,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Login Title
                    Text(
                      'تسجيل الدخول',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 32),
                    // Academic ID input (first step)
                    if (!_isPasswordStep)
                      FloatingInputField(
                        animation: _academicIdAnimation,
                        label: 'الرقم الأكاديمي',
                        hint: 'أدخل رقمك الأكاديمي',
                        controller: _academicIdTextController,
                        icon: FontAwesomeIcons.user,
                        onNext: _onNextPressed,
                        nextButtonText: 'التالي',
                      ),
                    // Password input (second step)
                    if (_isPasswordStep)
                      FloatingInputField(
                        animation: _passwordAnimation,
                        label: 'رمز المرور',
                        hint: 'أدخل رمز المرور',
                        controller: _passwordTextController,
                        icon: FontAwesomeIcons.lock,
                        isPassword: true,
                        showNextButton: false,
                      ),
                    const SizedBox(height: 24),
                    // Remember me checkbox (only in password step)
                    if (_isPasswordStep)
                      RememberMeCheckbox(
                        initialValue: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value;
                          });
                        },
                      ),
                    const SizedBox(height: 24),
                    // Navigation buttons (only in password step)
                    if (_isPasswordStep)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: LoginNavigationButtons(
                          showPrevious: true,
                          onPrevious: _onPreviousPressed,
                          onLogin: _onLoginPressed,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Animated DELIT Logo and text at bottom
            AnimatedDelitLogo(
              animation: _academicIdAnimation,
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

/// Chat screen widget (placeholder)
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.chatNew),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.chatTitleDefault,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.chatTyping,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
