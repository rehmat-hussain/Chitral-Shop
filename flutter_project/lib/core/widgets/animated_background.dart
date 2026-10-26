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
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base dark navy canvas
        Container(
          color: AppColors.backgroundDeep,
        ),
        // Animated glowing orbs and particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _ParticleOrbPainter(
                progress: _controller.value,
                showParticles: widget.showParticles,
              ),
              size: Size.infinite,
            );
          },
        ),
        // Content on top
        widget.child,
      ],
    );
  }
}

class _ParticleOrbPainter extends CustomPainter {
  final double progress;
  final bool showParticles;

  _ParticleOrbPainter({
    required this.progress,
    required this.showParticles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double angle = progress * 2 * pi;

    // Glowing Orb 1: Cyan / Blue (Top Left moving towards center)
    final orb1Center = Offset(
      size.width * 0.25 + sin(angle) * (size.width * 0.15),
      size.height * 0.2 + cos(angle) * (size.height * 0.1),
    );
    final orb1Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.neonCyan.withOpacity(0.22),
          AppColors.neonBlue.withOpacity(0.10),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: orb1Center, radius: size.width * 0.45));
    canvas.drawCircle(orb1Center, size.width * 0.45, orb1Paint);

    // Glowing Orb 2: Violet / Purple (Bottom Right moving)
    final orb2Center = Offset(
      size.width * 0.8 - cos(angle * 0.8) * (size.width * 0.15),
      size.height * 0.7 - sin(angle * 0.8) * (size.height * 0.12),
    );
    final orb2Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.neonViolet.withOpacity(0.20),
          AppColors.neonPurple.withOpacity(0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: orb2Center, radius: size.width * 0.5));
    canvas.drawCircle(orb2Center, size.width * 0.5, orb2Paint);

    if (showParticles) {
      // 18 Floating micro-stars / light particles
      final particlePaint = Paint()..style = PaintingStyle.fill;
      for (int i = 0; i < 18; i++) {
        final double speed = 0.5 + (i % 5) * 0.2;
        final double pOffset = (progress * speed + (i * 0.055)) % 1.0;
        final double px = (sin(i * 1.7) * 0.5 + 0.5) * size.width;
        final double py = (1.0 - pOffset) * size.height;
        final double pSize = 1.2 + (i % 3) * 0.9;
        final double opacity = sin(pOffset * pi) * 0.6;

        particlePaint.color = (i % 2 == 0 ? AppColors.neonCyan : AppColors.neonViolet)
            .withOpacity(opacity.clamp(0.0, 1.0));
        canvas.drawCircle(Offset(px, py), pSize, particlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleOrbPainter oldDelegate) => true;
}
