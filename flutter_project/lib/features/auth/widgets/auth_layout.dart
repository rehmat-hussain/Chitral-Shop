import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/animated_background.dart';
import 'auth_theme_tokens.dart';

Route<T> authPageRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 340),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (_, animation, __) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.03, 0.02), end: Offset.zero)
              .animate(curved),
          child: page,
        ),
      );
    },
  );
}

class AuthScreenShell extends StatelessWidget {
  final Widget child;
  final bool showBack;

  const AuthScreenShell({
    super.key,
    required this.child,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AnimatedBackground(
        child: SafeArea(
          child: Stack(
            children: [
              if (showBack)
                Positioned(
                  top: 2,
                  left: 2,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Center(
                  child: SingleChildScrollView(
                    padding: AuthThemeTokens.pagePadding,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthBrandHeader extends StatelessWidget {
  final String subtitle;

  const AuthBrandHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AuthThemeTokens.reducedMotion(context)
          ? Duration.zero
          : const Duration(milliseconds: 560),
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
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AuthThemeTokens.primaryGradient,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonBlue.withOpacity(0.45),
                  blurRadius: 28,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: const Icon(Icons.shopping_bag_rounded, size: 34, color: Colors.white),
          ),
          const SizedBox(height: 14),
          Text(
            'Chitral Shop',
            style: AuthThemeTokens.displayTitle.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 6),
          Text(subtitle, textAlign: TextAlign.center, style: AuthThemeTokens.body),
        ],
      ),
    );
  }
}

class AuthGlassPanel extends StatelessWidget {
  final Widget child;

  const AuthGlassPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AuthThemeTokens.panelRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x55303F6B),
            Color(0x44111B35),
            Color(0x66101830),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
        boxShadow: AuthThemeTokens.panelShadow,
      ),
      child: ClipRRect(
        borderRadius: AuthThemeTokens.panelRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.transparent,
                        AppColors.neonPurple.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: AuthThemeTokens.panelPadding, child: child),
          ],
        ),
      ),
    );
  }
}

class AuthMessageBanner extends StatelessWidget {
  final String? message;
  final bool isError;

  const AuthMessageBanner({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: message == null
          ? const SizedBox.shrink()
          : Container(
              key: ValueKey<String>(message!),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: (isError ? AuthThemeTokens.danger : AuthThemeTokens.success)
                    .withOpacity(0.16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      (isError ? AuthThemeTokens.danger : AuthThemeTokens.success)
                          .withOpacity(0.5),
                ),
              ),
              child: Text(
                message!,
                style: AuthThemeTokens.body.copyWith(
                  color: isError ? const Color(0xFFFFB3C1) : const Color(0xFFB7FAD9),
                ),
              ),
            ),
    );
  }
}
