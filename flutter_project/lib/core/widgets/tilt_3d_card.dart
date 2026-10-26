import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Tilt3DCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double maxTiltAngle;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;

  const Tilt3DCard({
    super.key,
    required this.child,
    this.onTap,
    this.maxTiltAngle = 0.08,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<Tilt3DCard> createState() => _Tilt3DCardState();
}

class _Tilt3DCardState extends State<Tilt3DCard> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  bool _isPressed = false;

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final double xRatio = (details.localPosition.dx / size.width) * 2 - 1;
    final double yRatio = (details.localPosition.dy / size.height) * 2 - 1;

    setState(() {
      _rotateY = (xRatio * widget.maxTiltAngle).clamp(-widget.maxTiltAngle, widget.maxTiltAngle);
      _rotateX = (-yRatio * widget.maxTiltAngle).clamp(-widget.maxTiltAngle, widget.maxTiltAngle);
    });
  }

  void _resetTilt() {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: _resetTilt,
          onPanUpdate: (details) => _onPanUpdate(details, size),
          onPanEnd: (_) => _resetTilt(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015) // Perspective parameter
              ..rotateX(_rotateX)
              ..rotateY(_rotateY)
              ..scale(_isPressed ? 0.97 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: LinearGradient(
                colors: [
                  AppColors.surfaceCard,
                  AppColors.backgroundNavy.withOpacity(0.92),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _isPressed
                    ? AppColors.neonCyan
                    : AppColors.neonCyan.withOpacity(0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonCyan.withOpacity(_isPressed ? 0.35 : 0.12),
                  blurRadius: _isPressed ? 20 : 12,
                  spreadRadius: _isPressed ? 2 : 0,
                  offset: Offset(_rotateY * 30, -_rotateX * 30 + 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  // Inner content
                  Padding(
                    padding: widget.padding,
                    child: widget.child,
                  ),
                  // Specular 3D light reflection sheen
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.08),
                              Colors.transparent,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
