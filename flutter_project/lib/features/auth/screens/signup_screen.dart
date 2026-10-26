import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/appwrite_service.dart';
import '../../marketplace/screens/home_screen.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_theme_tokens.dart';

enum SignupMethod { email, phone }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _appwriteService = AppwriteService();

  SignupMethod _method = SignupMethod.email;
  String _countryCode = '+92';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  String? _statusMessage;
  bool _statusError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  int get _passwordScore {
    final password = _passwordController.text;
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp('[A-Z]').hasMatch(password)) score++;
    if (RegExp('[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    return score;
  }

  Future<void> _handleEmailSignup() async {
    if (_isLoading || _isGoogleLoading) return;
    if (!_acceptedTerms) {
      setState(() {
        _statusError = true;
        _statusMessage = 'Please accept Terms & Privacy to continue.';
      });
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      await _appwriteService.createAccount(
        email: email,
        password: password,
        name: _nameController.text.trim(),
      );
      await _appwriteService.login(email: email, password: password);
      await _appwriteService.createEmailVerification();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MarketplaceHomeScreen()),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _statusError = true;
        _statusMessage = 'Unable to create account. ${error.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handlePhoneSignup() async {
    if (_isLoading || _isGoogleLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _statusError = true;
      _statusMessage =
          'Phone registration is not configured in Appwrite yet. Enable Appwrite phone auth/OTP provider and add verification callbacks before using $_countryCode ${_phoneController.text.trim()}.';
    });
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
        _statusMessage = 'Continue Google sign-up in the opened browser window.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _statusError = true;
        _statusMessage = 'Google sign-up failed. ${error.toString()}';
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
    final score = _passwordScore;

    return AuthScreenShell(
      showBack: true,
      child: Column(
        children: [
          const AuthBrandHeader(subtitle: 'Create your premium marketplace account'),
          const SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration:
                reducedMotion ? Duration.zero : const Duration(milliseconds: 460),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 18 * (1 - value)),
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
                    Text('Create account', style: AuthThemeTokens.displayTitle),
                    const SizedBox(height: 6),
                    Text(
                      'Choose your sign-up method and complete the details below.',
                      style: AuthThemeTokens.body,
                    ),
                    const SizedBox(height: 14),
                    SegmentedButton<SignupMethod>(
                      segments: const [
                        ButtonSegment(
                          value: SignupMethod.email,
                          label: Text('Email'),
                          icon: Icon(Icons.email_outlined),
                        ),
                        ButtonSegment(
                          value: SignupMethod.phone,
                          label: Text('Phone'),
                          icon: Icon(Icons.phone_android_rounded),
                        ),
                      ],
                      selected: {_method},
                      onSelectionChanged: _isLoading || _isGoogleLoading
                          ? null
                          : (selection) {
                              setState(() {
                                _method = selection.first;
                                _statusMessage = null;
                              });
                            },
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _nameController,
                      label: 'Full name',
                      hint: 'Rahmat Khan',
                      prefix: const Icon(Icons.person_outline_rounded,
                          color: AppColors.neonCyan),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    if (_method == SignupMethod.email) ...[
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
                        hint: 'At least 8 characters',
                        obscureText: _obscurePassword,
                        prefix: const Icon(Icons.lock_outline_rounded,
                            color: AppColors.neonCyan),
                        suffix: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
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
                            return 'Use at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(4, (index) {
                          final active = index < score;
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: active
                                    ? const Color(0xFF60A5FA)
                                    : Colors.white.withOpacity(0.16),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        score <= 1
                            ? 'Weak password'
                            : score == 2
                                ? 'Fair password'
                                : score == 3
                                    ? 'Strong password'
                                    : 'Very strong password',
                        style: AuthThemeTokens.body.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 12),
                      AuthTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm password',
                        hint: 'Re-enter password',
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        prefix: const Icon(Icons.verified_user_outlined,
                            color: AppColors.neonCyan),
                        suffix: IconButton(
                          onPressed: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              key: ValueKey<bool>(_obscureConfirmPassword),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        value: _acceptedTerms,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.neonBlue,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          'I agree to Terms & Privacy',
                          style: AuthThemeTokens.body.copyWith(fontSize: 12),
                        ),
                        onChanged: _isLoading || _isGoogleLoading
                            ? null
                            : (value) =>
                                setState(() => _acceptedTerms = value ?? false),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          SizedBox(
                            width: 110,
                            child: DropdownButtonFormField<String>(
                              value: _countryCode,
                              items: const [
                                DropdownMenuItem(value: '+92', child: Text('+92 PK')),
                                DropdownMenuItem(value: '+1', child: Text('+1 US')),
                                DropdownMenuItem(value: '+44', child: Text('+44 UK')),
                              ],
                              onChanged: _isLoading || _isGoogleLoading
                                  ? null
                                  : (value) =>
                                      setState(() => _countryCode = value ?? '+92'),
                              decoration: InputDecoration(
                                labelText: 'Code',
                                labelStyle: AuthThemeTokens.label,
                                filled: true,
                                fillColor: AuthThemeTokens.glassField,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AuthTextField(
                              controller: _phoneController,
                              label: 'Phone number',
                              hint: '3001234567',
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              prefix: const Icon(Icons.phone_rounded,
                                  color: AppColors.neonCyan),
                              validator: (value) {
                                final normalized =
                                    (value ?? '').replaceAll(RegExp(r'\D'), '');
                                if (normalized.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (normalized.length < 10) {
                                  return 'Use a valid phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phone verification uses Appwrite phone provider + OTP. This branch currently displays an actionable setup state only.',
                        style: AuthThemeTokens.body.copyWith(fontSize: 11),
                      ),
                    ],
                    const SizedBox(height: 12),
                    AuthActionButton(
                      label:
                          _method == SignupMethod.email ? 'Create Account' : 'Continue with Phone',
                      isLoading: _isLoading,
                      onPressed: _method == SignupMethod.email
                          ? _handleEmailSignup
                          : _handlePhoneSignup,
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
                    Center(
                      child: TextButton(
                        onPressed: _isLoading || _isGoogleLoading
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('Already have an account? Sign In'),
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
