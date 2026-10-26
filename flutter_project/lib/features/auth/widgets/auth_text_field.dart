import 'package:flutter/material.dart';

import 'auth_theme_tokens.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.validator,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AuthThemeTokens.label),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: AuthThemeTokens.fieldRadius,
            border: Border.all(
              color: focused
                  ? AuthThemeTokens.focusGlow
                  : AuthThemeTokens.fieldBorder.withOpacity(0.55),
              width: focused ? 1.3 : 1,
            ),
            boxShadow: [
              if (focused)
                BoxShadow(
                  color: AuthThemeTokens.focusGlow.withOpacity(0.34),
                  blurRadius: 20,
                  spreadRadius: -8,
                ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            textInputAction: widget.textInputAction,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            validator: widget.validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: AuthThemeTokens.glassField,
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Color(0xFF6F7E9D), fontSize: 13),
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: AuthThemeTokens.fieldRadius,
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(color: Color(0xFFFFB3C1), fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}
