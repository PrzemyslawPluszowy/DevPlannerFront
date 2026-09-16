import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';

class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    required this.height,
    super.key,
    this.width,
    this.borderRadius = const BorderRadius.all(.circular(Sizes.p8)),
    this.shape = BoxShape.rectangle,
  });

  factory AppSkeleton.line({
    Key? key,
    double? width,
    double height = Sizes.p12,
  }) {
    return AppSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
    );
  }

  factory AppSkeleton.circle({Key? key, double size = Sizes.p32}) {
    return AppSkeleton(
      key: key,
      width: size,
      height: size,
      shape: BoxShape.circle,
    );
  }

  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final BoxShape shape;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1350),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = colors.surfaceContainerHigh;
    final highlight = colors.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final begin = -1.4 + (progress * 2.4);
        final end = begin + 0.8;

        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: widget.shape,
              borderRadius: widget.shape == BoxShape.circle
                  ? null
                  : widget.borderRadius,
              gradient: LinearGradient(
                begin: Alignment(begin, 0),
                end: Alignment(end, 0),
                colors: [base, Color.lerp(base, highlight, .7)!, base],
                stops: const [0, .5, 1],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppSkeletonCard extends StatelessWidget {
  const AppSkeletonCard({super.key, this.lines = 3});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(Sizes.p16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              AppSkeleton.circle(),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppSkeleton.line(width: 140),
                    Gaps.h8,
                    AppSkeleton.line(width: 96, height: Sizes.p10),
                  ],
                ),
              ),
            ],
          ),
          Gaps.h16,
          for (var index = 0; index < lines; index++) ...[
            AppSkeleton.line(
              width: math.max(120, 320 - (index * 38)).toDouble(),
            ),
            if (index != lines - 1) Gaps.h8,
          ],
        ],
      ),
    );
  }
}
