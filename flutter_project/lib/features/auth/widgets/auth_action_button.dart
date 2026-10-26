import 'dart:math';

import 'package:flutter/material.dart';

import 'auth_theme_tokens.dart';

enum AuthButtonVariant { primary, secondary }

class AuthActionButton extends StatefulWidget {
  final String label;
  final Future<void> Function()? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AuthButtonVariant variant;

  const AuthActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AuthButtonVariant.primary,
  });

  @override
  State<AuthActionButton> createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _pressed = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!_isEnabled) return;
    await _controller.forward();
    await _controller.reverse();
    await widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.variant == AuthButtonVariant.primary
        ? AuthThemeTokens.primaryGradient
        : AuthThemeTokens.secondaryGradient;

    return GestureDetector(
      onTapDown: _isEnabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: _isEnabled ? () => setState(() => _pressed = false) : null,
      onTapUp: _isEnabled ? (_) => setState(() => _pressed = false) : null,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = max(_controller.value, _pressed ? 0.65 : 0);
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..scale(1 - 0.03 * t)
              ..rotateX(0.03 * t),
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.18)),
                boxShadow: [
                  BoxShadow(
                    color: widget.variant == AuthButtonVariant.primary
                        ? const Color(0xFF3F87FF).withOpacity(0.35 - (0.18 * t))
                        : Colors.black.withOpacity(0.24),
                    blurRadius: 20 - (6 * t),
                    spreadRadius: -5,
                    offset: Offset(0, 10 - (6 * t)),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else ...[
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                    ],
                    Text(widget.label, style: AuthThemeTokens.buttonText),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
