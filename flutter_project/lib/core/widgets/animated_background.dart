import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final bool showParticles;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.showParticles = true,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _reducedMotion {
    final mediaQuery = MediaQuery.maybeOf(context);
    return (mediaQuery?.disableAnimations ?? false) ||
        (mediaQuery?.accessibleNavigation ?? false);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reducedMotion) {
      _controller.value = 0.45;
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF040713),
                Color(0xFF070B19),
                Color(0xFF0A1025),
                Color(0xFF070918),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _ParticleOrbPainter(
                progress: _controller.value,
                showParticles: widget.showParticles,
                reducedMotion: _reducedMotion,
              ),
            );
          },
        ),
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x2200F0FF),
                  Colors.transparent,
                  Color(0x1A9F6BFF),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _ParticleOrbPainter extends CustomPainter {
  final double progress;
  final bool showParticles;
  final bool reducedMotion;

  const _ParticleOrbPainter({
    required this.progress,
    required this.showParticles,
    required this.reducedMotion,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shimmer = reducedMotion ? 0.0 : sin(progress * 2 * pi);

    final cyanCenter = Offset(
      size.width * 0.2 + shimmer * size.width * 0.08,
      size.height * 0.16 + shimmer * size.height * 0.03,
    );
    final violetCenter = Offset(
      size.width * 0.82 - shimmer * size.width * 0.08,
      size.height * 0.72 - shimmer * size.height * 0.04,
    );
    final magentaCenter = Offset(
      size.width * 0.55 + shimmer * size.width * 0.05,
      size.height * 0.42,
    );

    canvas.drawCircle(
      cyanCenter,
      size.width * 0.5,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.neonCyan.withOpacity(0.26),
            AppColors.neonBlue.withOpacity(0.1),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: cyanCenter, radius: size.width * 0.5),
        ),
    );

    canvas.drawCircle(
      violetCenter,
      size.width * 0.6,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.neonViolet.withOpacity(0.26),
            AppColors.neonPurple.withOpacity(0.1),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: violetCenter, radius: size.width * 0.6),
        ),
    );

    canvas.drawCircle(
      magentaCenter,
      size.width * 0.35,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0x33E879F9),
            const Color(0x119F6BFF),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: magentaCenter, radius: size.width * 0.35),
        ),
    );

    if (!showParticles) {
      return;
    }

    final particlePaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 20; i++) {
      final speed = 0.3 + ((i % 4) * 0.16);
      final anim = reducedMotion
          ? (i / 20)
          : (progress * speed + (i * 0.08)) % 1.0;
      final px = (sin(i * 1.7 + anim * pi) * 0.45 + 0.5) * size.width;
      final py = (1 - anim) * size.height;
      final opacity = reducedMotion ? 0.15 : sin(anim * pi).clamp(0.0, 1.0) * 0.32;
      particlePaint.color =
          (i.isEven ? AppColors.neonCyan : AppColors.neonViolet).withOpacity(opacity);
      canvas.drawCircle(Offset(px, py), 1 + (i % 3) * 0.8, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleOrbPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showParticles != showParticles ||
        oldDelegate.reducedMotion != reducedMotion;
  }
}
