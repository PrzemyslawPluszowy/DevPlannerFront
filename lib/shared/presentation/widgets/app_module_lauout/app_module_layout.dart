import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_compact_module_layout.dart';

/// Główny szablon strony modułu (sidebar + content) pod web/desktop.
///
/// Kiedy używać:
/// - gdy ekran ma stały panel boczny po lewej i część roboczą po prawej,
/// - gdy chcesz mieć spójny układ z opcjonalnym paskiem górnym (`topBar`),
/// - gdy chcesz automatycznie obsłużyć wariant compact dla mniejszych szerokości.
///
/// Jak działa:
/// - `sidebarBuilder` buduje lewą kolumnę (menu/nawigację),
/// - `contentBuilder` buduje właściwą zawartość modułu,
/// - `topBar` (opcjonalny) jest renderowany nad contentem,
/// - `contentMaxWidth` ogranicza szerokość treści, żeby UI nie rozjeżdżał się
///   na bardzo szerokich ekranach.
class AppModuleLayout extends StatefulWidget {
  const AppModuleLayout({
    required this.sidebarBuilder,
    required this.contentBuilder,
    super.key,
    this.topBar,
    this.compactBreakpoint = 1180,
    this.compactOuterPadding = Sizes.p12,
    this.regularOuterPadding = Sizes.p16,
    this.contentLeadingInset = Sizes.p8,
    this.contentMaxWidth = 960,
    this.contentBackgroundColor,
    this.showSidebarDivider = true,
    this.scrollContent = true,
    this.navigationController,
    this.navigationExpandedWidth = 272,
    this.navigationCollapsedWidth = 56,
    this.navigationAnimationDuration = const Duration(milliseconds: 220),
    this.navigationAnimationCurve = Curves.easeOutCubic,
  });

  final Widget Function(
    BuildContext context,
    bool isCompact,
    double outerPadding,
  )
  /// Buduje panel boczny; dostaje też informacje o trybie compact i paddingu.
  sidebarBuilder;
  final Widget Function(
    BuildContext context,
    bool isCompact,
    double outerPadding,
  )
  /// Buduje treść modułu po prawej stronie.
  contentBuilder;

  /// Opcjonalny pasek nad treścią (np. nagłówek strony, akcje globalne).
  final Widget? topBar;

  /// Breakpoint przełączający układ na tryb compact.
  final double compactBreakpoint;

  /// Zewnętrzny padding dla trybu compact.
  final double compactOuterPadding;

  /// Zewnętrzny padding dla trybu regular.
  final double regularOuterPadding;

  /// Wewnętrzny lewy offset treści po prawej stronie.
  final double contentLeadingInset;

  /// Maksymalna szerokość kolumny contentu.
  final double contentMaxWidth;

  /// Opcjonalny kolor tła obszaru contentu.
  final Color? contentBackgroundColor;

  /// Pokazuje pionowy separator między sidebarem a contentem.
  final bool showSidebarDivider;

  /// Czy obszar contentu ma być przewijalny globalnie.
  ///
  /// Dla shelli z nested routerem (np. AutoTabsRouter) ustaw `false`,
  /// żeby child dostał skończone constraints wysokości.
  final bool scrollContent;

  /// Opcjonalny kontroler panelu nawigacji dla wydajnego układu desktopowego.
  ///
  /// Gdy jest ustawiony, sidebar jest renderowany nad stabilnym `Stack`, a
  /// zmiana położenia głównej treści odbywa się jako transformacja warstwy.
  /// Dzięki temu animacja szerokości menu nie relayoutuje całego ekranu w
  /// każdej klatce. Układ compact nadal używa własnego overlay/drawera.
  final ValueListenable<bool>? navigationController;

  /// Szerokość rozwiniętego panelu bez jego prawego marginesu.
  final double navigationExpandedWidth;

  /// Szerokość zwiniętego panelu bez jego prawego marginesu.
  final double navigationCollapsedWidth;

  /// Czas animacji przesunięcia warstwy treści.
  final Duration navigationAnimationDuration;

  /// Krzywa animacji przesunięcia warstwy treści.
  final Curve navigationAnimationCurve;

  @override
  State<AppModuleLayout> createState() => _AppModuleLayoutState();
}

class _AppModuleLayoutState extends State<AppModuleLayout> {
  /// Ten sam GlobalKey przeprowadza AutoRouter między układem desktopowym a
  /// compact. Bez niego przekroczenie breakpointu niszczyło zagnieżdżony router
  /// i wracało do jego domyślnej trasy (często ekranu tworzenia workspace'u).
  final GlobalKey _contentSurfaceKey = GlobalKey();

  Widget _buildContentSurface(
    BuildContext context,
    bool isCompact,
    double outerPadding,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor =
        widget.contentBackgroundColor ??
        (isDark ? const Color(0xFF171824) : Colors.white);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: .14)
                : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .40 : .07),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ?widget.topBar,
            Expanded(
              child: widget.scrollContent
                  ? SingleChildScrollView(
                      padding: EdgeInsets.all(outerPadding),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: widget.contentBuilder(
                          context,
                          isCompact,
                          outerPadding,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(outerPadding),
                      child: widget.contentBuilder(
                        context,
                        isCompact,
                        outerPadding,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < widget.compactBreakpoint;
        final outerPadding = isCompact
            ? widget.compactOuterPadding
            : widget.regularOuterPadding;

        if (isCompact) {
          return AppCompactModuleLayout(
            sidebarBuilder: widget.sidebarBuilder,
            contentSurfaceBuilder: (context) => KeyedSubtree(
              key: _contentSurfaceKey,
              child: _buildContentSurface(context, true, outerPadding),
            ),
            constraints: constraints,
            outerPadding: outerPadding,
          );
        }

        final navigation = widget.navigationController;
        if (navigation != null) {
          return ValueListenableBuilder<bool>(
            valueListenable: navigation,
            builder: (context, isExpanded, _) => _buildDesktopStack(
              context,
              isExpanded: isExpanded,
              constraints: constraints,
              outerPadding: outerPadding,
              colors: colors,
              isDark: isDark,
            ),
          );
        }

        return Row(
          children: [
            widget.sidebarBuilder(context, isCompact, outerPadding),
            if (widget.showSidebarDivider)
              Container(
                width: 1,
                color: colors.outlineVariant.withValues(
                  alpha: isDark ? .20 : .40,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 12, 12),
                child: KeyedSubtree(
                  key: _contentSurfaceKey,
                  child: _buildContentSurface(
                    context,
                    false,
                    outerPadding,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Desktopowa ścieżka bez relayoutu treści podczas zwijania nawigacji.
  /// Szerokość contentu jest ustalana raz dla rozwiniętego sidebara, a zmiana
  /// pozycji odbywa się wyłącznie przez composited transform.
  Widget _buildDesktopStack(
    BuildContext context, {
    required bool isExpanded,
    required BoxConstraints constraints,
    required double outerPadding,
    required ColorScheme colors,
    required bool isDark,
  }) {
    final sidebarWidth =
        widget.navigationExpandedWidth + (widget.showSidebarDivider ? 1 : 0);
    final collapsedOffset =
        widget.navigationExpandedWidth - widget.navigationCollapsedWidth;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          left: sidebarWidth + 8,
          right: 12,
          bottom: 12,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              end: isExpanded ? 0 : -collapsedOffset,
            ),
            duration: widget.navigationAnimationDuration,
            curve: widget.navigationAnimationCurve,
            builder: (context, offset, child) => Transform.translate(
              offset: Offset(offset, 0),
              child: RepaintBoundary(child: child),
            ),
            child: KeyedSubtree(
              key: _contentSurfaceKey,
              child: _buildContentSurface(context, false, outerPadding),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 12,
          width: widget.navigationExpandedWidth,
          child: widget.sidebarBuilder(context, false, outerPadding),
        ),
        if (widget.showSidebarDivider)
          Positioned(
            left: widget.navigationExpandedWidth,
            top: 0,
            bottom: 12,
            width: 1,
            child: ColoredBox(
              color: colors.outlineVariant.withValues(
                alpha: isDark ? .20 : .40,
              ),
            ),
          ),
      ],
    );
  }
}
