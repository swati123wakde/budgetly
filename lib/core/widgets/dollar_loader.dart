import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'dollar_logo.dart';

/// The brand "$" mark with a spinning matte-red arc and a soft pulse.
/// Used for full-screen "setting things up" moments.
class DollarLoader extends StatefulWidget {
  const DollarLoader({super.key, this.size = 160});

  final double size;

  @override
  State<DollarLoader> createState() => _DollarLoaderState();
}

class _DollarLoaderState extends State<DollarLoader> with TickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween(begin: 0.94, end: 1.0).animate(
    CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _spin.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _spin,
            child: CustomPaint(size: Size.square(size), painter: const _ArcPainter()),
          ),
          ScaleTransition(
            scale: _scale,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => DollarLogo(size: size * 0.66, glow: 0.35 + 0.65 * _pulse.value),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = AppColors.surfaceHigh;
    canvas.drawCircle(rect.center, size.width / 2 - 2, track);

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [Color(0x00A8323A), AppColors.matteRed],
      ).createShader(rect);
    canvas.drawArc(rect.deflate(2), 0, math.pi * 1.3, false, arc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
