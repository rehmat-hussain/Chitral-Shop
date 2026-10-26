import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/appwrite_service.dart';
import '../../marketplace/screens/home_screen.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_theme_tokens.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _statusMessage;
  bool _statusError = false;

  final _appwriteService = AppwriteService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading || _isGoogleLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      await _appwriteService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MarketplaceHomeScreen()),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _statusError = true;
        _statusMessage = 'Sign in failed. ${error.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading || _isGoogleLoading) return;
    setState(() {
      _isGoogleLoading = true;
      _statusMessage = null;
    });
    try {
      await _appwriteService.createOAuth2Session(provider: 'google');
      if (!mounted) return;
      setState(() {
        _statusError = false;
        _statusMessage = 'Continue Google sign-in in the opened browser window.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _statusError = true;
        _statusMessage = 'Google sign-in failed. ${error.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = AuthThemeTokens.reducedMotion(context);

    return AuthScreenShell(
      child: Column(
        children: [
          const AuthBrandHeader(
            subtitle: 'Immersive mountain marketplace experience',
          ),
          const SizedBox(height: 22),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration:
                reducedMotion ? Duration.zero : const Duration(milliseconds: 460),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 16 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: AuthGlassPanel(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back', style: AuthThemeTokens.displayTitle),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in with your email and password to continue shopping.',
                      style: AuthThemeTokens.body,
                    ),
                    const SizedBox(height: 18),
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email address',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.alternate_email_rounded,
                          color: AppColors.neonCyan),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'Email is required';
                        final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(text);
                        return isEmail ? null : 'Enter a valid email address';
                      },
                    ),
                    const SizedBox(height: 12),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      prefix:
                          const Icon(Icons.lock_outline_rounded, color: AppColors.neonCyan),
                      suffix: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          transitionBuilder: (child, animation) {
                            return RotationTransition(
                              turns: Tween(begin: 0.9, end: 1).animate(animation),
                              child: FadeTransition(opacity: animation, child: child),
                            );
                          },
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            key: ValueKey<bool>(_obscurePassword),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final text = value ?? '';
                        if (text.isEmpty) return 'Password is required';
                        if (text.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading || _isGoogleLoading
                            ? null
                            : () => Navigator.push(
                                  context,
                                  authPageRoute(const ForgotPasswordScreen()),
                                ),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    AuthActionButton(
                      label: 'Sign In',
                      isLoading: _isLoading,
                      onPressed: _handleLogin,
                    ),
                    const SizedBox(height: 10),
                    AuthActionButton(
                      label: 'Continue with Google',
                      icon: Icons.g_mobiledata_rounded,
                      variant: AuthButtonVariant.secondary,
                      isLoading: _isGoogleLoading,
                      onPressed: _handleGoogleSignIn,
                    ),
                    AuthMessageBanner(
                      message: _statusMessage,
                      isError: _statusError,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4,
                      children: [
                        Text('New to Chitral Shop?', style: AuthThemeTokens.body),
                        GestureDetector(
                          onTap: _isLoading || _isGoogleLoading
                              ? null
                              : () => Navigator.push(
                                    context,
                                    authPageRoute(const SignupScreen()),
                                  ),
                          child: Text(
                            'Create Account',
                            style: AuthThemeTokens.body.copyWith(
                              color: AppColors.neonCyan,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'By continuing, you agree to Terms & Privacy.',
                        textAlign: TextAlign.center,
                        style: AuthThemeTokens.body.copyWith(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
