import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';

/// Uniwersalny wrapper elementu pulpitu odpowiedzialny za pozycję i animację.
class DashboardDesktopItemWrapper extends StatelessWidget {
  /// Tworzy wrapper elementu pulpitu.
  const DashboardDesktopItemWrapper({
    required this.position,
    required this.width,
    required this.height,
    required this.child,
    this.isDragging = false,
    this.dragOpacity = .92,
    this.animationDuration = const Duration(milliseconds: 220),
    this.animationCurve = Curves.easeOutCubic,
    super.key,
  });

  /// Pozycja lewego górnego rogu elementu.
  final Offset position;

  /// Szerokość elementu.
  final double width;

  /// Wysokość elementu.
  final double height;

  /// Czy element jest obecnie przeciągany.
  final bool isDragging;

  /// Przezroczystość stosowana podczas przeciągania.
  final double dragOpacity;

  /// Czas animacji przejazdu elementu.
  final Duration animationDuration;

  /// Krzywa animacji przejazdu elementu.
  final Curve animationCurve;

  /// Zawartość renderowana we wrapperze.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wrappedChild = AnimatedScale(
      scale: isDragging ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 260),
      curve: isDragging ? Curves.easeOutCubic : Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
          boxShadow: isDragging
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .30),
                    blurRadius: 28,
                    spreadRadius: 3,
                    offset: const Offset(0, 14),
                  ),
                ]
              : const [],
        ),
        child: SizedBox(
          key: key,
          width: width,
          height: height,
          child: isDragging
              ? Opacity(
                  opacity: dragOpacity,
                  child: child,
                )
              : child,
        ),
      ),
    );

    final snapToGrid = context.select<DashboardPreferencesCubit, bool>(
      (cubit) => cubit.state.snapToGrid,
    );
    final effectiveDuration = isDragging
        ? (snapToGrid ? Duration.zero : const Duration(milliseconds: 80))
        : animationDuration;

    return AnimatedPositioned(
      duration: effectiveDuration,
      curve: animationCurve,
      left: position.dx,
      top: position.dy,
      width: width,
      height: height,
      child: wrappedChild,
    );
  }
}
