import 'package:devplanner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Nowoczesny komponent Shimmer oparty o `flutter_animate`.
///
/// Zapewnia spójny, animowany efekt ładowania (szkieletu) w jasnym i ciemnym motywie.
class AppShimmer extends StatelessWidget {
  /// Tworzy wrapper nakładający efekt Shimmer na dowolny widok szkieletu.
  const AppShimmer({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 1300),
    this.highlightColor,
  });

  /// Widget szkieletu, na który zostanie nałożona animacja.
  final Widget child;

  /// Czas trwania jednego cyklu animacji.
  final Duration duration;

  /// Opcjonalny własny kolor rozbłysku (jeśli brak, wyliczany z motywu).
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveHighlight =
        highlightColor ??
        (isDark
            ? Colors.white.withValues(alpha: .14)
            : Colors.white.withValues(alpha: .65));

    return RepaintBoundary(
      child: child
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: duration,
            color: effectiveHighlight,
          ),
    );
  }
}

/// Prostokątny lub zaokrąglony blok szkieletu.
class AppShimmerBox extends StatelessWidget {
  /// Tworzy blok szkieletu o zadanych wymiarach i zaokrągleniu.
  const AppShimmerBox({
    super.key,
    this.width,
    this.height = Sizes.p16,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.color,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;
    final effectiveColor =
        color ??
        (isDark
            ? Colors.white.withValues(alpha: .08)
            : colors.onSurface.withValues(alpha: .07));

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// Okrągły element szkieletu (ikona, avatar).
class AppShimmerCircle extends StatelessWidget {
  /// Tworzy okrągły blok szkieletu.
  const AppShimmerCircle({
    super.key,
    this.size = Sizes.p32,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;
    final effectiveColor =
        color ??
        (isDark
            ? Colors.white.withValues(alpha: .08)
            : colors.onSurface.withValues(alpha: .07));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Linia tekstu szkieletu.
class AppShimmerLine extends StatelessWidget {
  /// Tworzy zaokrągloną linię szkieletu tekstu.
  const AppShimmerLine({
    super.key,
    this.width,
    this.height = Sizes.p12,
  });

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) => AppShimmerBox(
    width: width,
    height: height,
    borderRadius: const BorderRadius.all(Radius.circular(4)),
  );
}

/// Wiersz szkieletu listy (ikona + tytuł + podtytuł).
class AppShimmerListTile extends StatelessWidget {
  /// Tworzy pojedynczy wiersz szkieletu.
  const AppShimmerListTile({
    super.key,
    this.leadingSize = Sizes.p28,
    this.titleWidth = 140,
    this.subtitleWidth = 90,
  });

  final double leadingSize;
  final double titleWidth;
  final double subtitleWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p8,
        vertical: Sizes.p4,
      ),
      child: Row(
        children: [
          AppShimmerBox(
            width: leadingSize,
            height: leadingSize,
          ),
          Gaps.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppShimmerLine(width: titleWidth, height: 13),
                Gaps.h4,
                AppShimmerLine(width: subtitleWidth, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Szkielet menu bocznego (nawigacji i workspace’ów).
class AppShimmerMenu extends StatelessWidget {
  /// Tworzy pełny szkielet bocznego menu katalogu.
  const AppShimmerMenu({this.itemCount = 5, super.key});

  /// Liczba wierszy zastępczych w stanie ładowania.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppShimmerBox(
              height: 32,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            Gaps.h16,
            const AppShimmerLine(width: 80, height: Sizes.p10),
            Gaps.h8,
            for (var index = 0; index < itemCount; index++)
              const AppShimmerListTile(
                leadingSize: Sizes.p24,
                titleWidth: 100,
                subtitleWidth: 50,
              ),
            Gaps.h16,
            const AppShimmerLine(width: 100, height: Sizes.p10),
            Gaps.h8,
          ],
        ),
      ),
    );
  }
}

/// Kompaktowy szkielet pojedynczego wpisu menu dla poddrzew nawigacji.
class AppShimmerMenuItem extends StatelessWidget {
  const AppShimmerMenuItem({super.key});

  @override
  Widget build(BuildContext context) => const AppShimmerListTile(
    leadingSize: 18,
    titleWidth: 120,
    subtitleWidth: 0,
  );
}

/// Szkielet strony głównej modułu Workspaces.
class AppShimmerContent extends StatelessWidget {
  /// Tworzy szkielet widoku centralnego.
  const AppShimmerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.p24,
              vertical: Sizes.p32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppShimmerCircle(size: 64),
                Gaps.h20,
                AppShimmerBox(
                  width: 220,
                  height: 24,
                ),
                Gaps.h12,
                AppShimmerLine(width: 380, height: 14),
                Gaps.h4,
                AppShimmerLine(width: 280, height: 14),
                Gaps.h28,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppShimmerBox(
                      width: 140,
                      height: 38,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    Gaps.w12,
                    AppShimmerBox(
                      width: 120,
                      height: 38,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
