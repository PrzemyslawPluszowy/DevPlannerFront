import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';

/// Wspolny spinner aplikacji z plynna animacja i subtelna poswiata.
class AppSpinner extends StatefulWidget {
  /// Tworzy spinner z opcjonalnym rozmiarem i kolorem.
  const AppSpinner({
    super.key,
    this.size,
    this.color,
    this.strokeWidth = Sizes.p4,
  });

  /// Opcjonalny wymiar spinnera. Jesli null, zajmie cala dostepna przestrzen.
  final double? size;

  /// Kolor spinnera. Domyslnie `context.colors.primary`.
  final Color? color;

  /// Grubosc obreczy spinnera.
  final double strokeWidth;

  @override
  State<AppSpinner> createState() => _AppSpinnerState();
}

/// Stan animacji spinnera aplikacyjnego.
class _AppSpinnerState extends State<AppSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1320),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spinnerColor = widget.color ?? colors.primary;
    final trackColor = Color.lerp(
      colors.outlineVariant,
      colors.surfaceContainerHighest,
      .42,
    )!;

    Widget child = RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final pulse = .5 - (.5 * math.cos(t * math.pi * 2));
          final sweep = _lerpDouble(math.pi * .42, math.pi * 1.58, pulse);
          final rotation = t * math.pi * 2;
          final startAngle = rotation - (sweep * .32) - (math.pi / 2);

          return CustomPaint(
            painter: _AppSpinnerPainter(
              color: spinnerColor,
              trackColor: trackColor,
              strokeWidth: widget.strokeWidth,
              startAngle: startAngle,
              sweepAngle: sweep,
            ),
          );
        },
      ),
    );

    if (widget.size case final size?) {
      child = SizedBox.square(dimension: size, child: child);
    }

    return child;
  }
}

/// Rysuje spinner z rozmyta poata i jednolitym ruchem obrotowym.
class _AppSpinnerPainter extends CustomPainter {
  /// Tworzy painter spinnera.
  const _AppSpinnerPainter({
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.startAngle,
    required this.sweepAngle,
  });

  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double startAngle;
  final double sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    final effectiveStroke = math.min(strokeWidth, side / 7);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (side - effectiveStroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor.withValues(alpha: .6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = effectiveStroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: .1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = effectiveStroke + 1
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, Sizes.p2);

    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: .12),
          color.withValues(alpha: .82),
          color,
          color.withValues(alpha: .2),
          color.withValues(alpha: 0),
        ],
        stops: const [0, .16, .46, .68, .86, 1],
        transform: GradientRotation(startAngle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = effectiveStroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _AppSpinnerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle;
  }
}

double _lerpDouble(double a, double b, double t) => a + ((b - a) * t);
