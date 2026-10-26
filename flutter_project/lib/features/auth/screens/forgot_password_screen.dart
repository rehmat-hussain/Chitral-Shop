import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/appwrite_service.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_theme_tokens.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _appwriteService = AppwriteService();

  bool _isLoading = false;
  String? _statusMessage;
  bool _statusError = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      await _appwriteService.createPasswordRecovery(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _statusError = false;
        _statusMessage =
            'Recovery link sent. Please check your email and follow the Appwrite reset flow.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _statusError = true;
        _statusMessage = 'Unable to send recovery email. ${error.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = AuthThemeTokens.reducedMotion(context);

    return AuthScreenShell(
      showBack: true,
      child: Column(
        children: [
          const AuthBrandHeader(subtitle: 'Secure account recovery'),
          const SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration:
                reducedMotion ? Duration.zero : const Duration(milliseconds: 440),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 14 * (1 - value)),
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
                    Text('Forgot password?', style: AuthThemeTokens.displayTitle),
                    const SizedBox(height: 6),
                    Text(
                      'Enter your account email and we will send your Appwrite password recovery link.',
                      style: AuthThemeTokens.body,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email address',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      prefix: const Icon(Icons.mark_email_read_outlined,
                          color: AppColors.neonCyan),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'Email is required';
                        final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(text);
                        return isEmail ? null : 'Enter a valid email address';
                      },
                    ),
                    const SizedBox(height: 14),
                    AuthActionButton(
                      label: 'Send recovery link',
                      isLoading: _isLoading,
                      onPressed: _handleReset,
                    ),
                    AuthMessageBanner(
                      message: _statusMessage,
                      isError: _statusError,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                        child: const Text('Return to sign in'),
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
