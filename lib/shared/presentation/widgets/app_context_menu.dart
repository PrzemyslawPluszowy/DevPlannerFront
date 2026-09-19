import 'dart:async';
import 'dart:ui';

import 'package:devplanner/core/theme/theme.dart';
import 'package:flutter/material.dart';

typedef AppContextMenuActionTap = FutureOr<void> Function(BuildContext context);

/// Buduje interaktywną zawartość zachowującą tę samą powierzchnię i pozycjonowanie
/// co standardowe menu kontekstowe.
typedef AppContextMenuContentBuilder = Widget Function(
  BuildContext context,
  VoidCallback dismiss,
);

/// Styl wizualny wspólnego menu kontekstowego.
enum AppContextMenuStyle {
  /// Szklany wariant z rozmyciem i refleksami.
  glass,

  /// Prosty, jasny wariant z białym tłem.
  flat,
}

/// Akcja dostępna we wspólnym menu kontekstowym aplikacji.
class AppContextMenuAction {
  /// Tworzy akcję menu kontekstowego.
  const AppContextMenuAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
    this.foregroundColor,
    this.separatorBefore = false,
    this.selected = false,
  });

  /// Etykieta akcji.
  final String label;

  /// Ikona akcji.
  final IconData? icon;

  /// Funkcja wykonywana po wybraniu akcji.
  final AppContextMenuActionTap onTap;

  /// Czy akcja ma charakter destrukcyjny.
  final bool isDestructive;

  /// Czy akcja jest dostępna.
  final bool enabled;

  /// Opcjonalny kolor akcji.
  final Color? foregroundColor;

  /// Czy przed akcją ma pojawić się separator.
  final bool separatorBefore;

  /// Czy akcja reprezentuje aktualnie wybraną wartość.
  final bool selected;
}

/// Wspólne menu kontekstowe inspirowane interfejsem macOS.
abstract final class AppContextMenu {
  static const _transitionDuration = Duration(milliseconds: 120);
  static const _reverseTransitionDuration = Duration(milliseconds: 80);

  /// Pokazuje menu przy wskazanej pozycji globalnej.
  static Future<void> show(
    BuildContext context, {
    required Offset globalPosition,
    required List<AppContextMenuAction> actions,
    AppContextMenuStyle style = AppContextMenuStyle.flat,
    String? headerTitle,
    String? headerSubtitle,
  }) async {
    if (actions.isEmpty) {
      return;
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    final overlayBox =
        navigator.overlay!.context.findRenderObject()! as RenderBox;
    final overlayPosition =
        overlayBox.globalToLocal(globalPosition) + const Offset(4, 4);
    final selectedIndex = await navigator.push<int>(
      _AppContextMenuRoute(
        position: overlayPosition,
        actions: actions,
        style: style,
        headerTitle: headerTitle,
        headerSubtitle: headerSubtitle,
        transitionDuration: _transitionDuration,
        reverseTransitionDuration: _reverseTransitionDuration,
      ),
    );
    if (!context.mounted || selectedIndex == null) {
      return;
    }
    await actions[selectedIndex].onTap(context);
  }

  /// Pokazuje niestandardową, interaktywną zawartość w identycznym wrapperze.
  /// Służy np. do wyszukiwania, gdy zwykła lista akcji nie wystarcza.
  static Future<void> showCustom(
    BuildContext context, {
    required Offset globalPosition,
    required AppContextMenuContentBuilder contentBuilder,
    AppContextMenuStyle style = AppContextMenuStyle.flat,
    double maxWidth = 360,
    double maxHeight = 420,
  }) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final overlayBox =
        navigator.overlay!.context.findRenderObject()! as RenderBox;
    final overlayPosition =
        overlayBox.globalToLocal(globalPosition) + const Offset(4, 4);
    await navigator.push<int>(
      _AppContextMenuRoute(
        position: overlayPosition,
        actions: const [],
        style: style,
        transitionDuration: _transitionDuration,
        reverseTransitionDuration: _reverseTransitionDuration,
        contentBuilder: contentBuilder,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
    );
  }
}

/// Trasa odpowiedzialna za prezentację menu ponad bieżącym ekranem.
class _AppContextMenuRoute extends PopupRoute<int> {
  /// Tworzy trasę menu kontekstowego.
  _AppContextMenuRoute({
    required this.position,
    required this.actions,
    required this.style,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
    this.headerTitle,
    this.headerSubtitle,
    this.contentBuilder,
    this.maxWidth = 260,
    this.maxHeight,
  });

  /// Pozycja kursora w globalnym układzie współrzędnych.
  final Offset position;

  /// Akcje prezentowane w menu.
  final List<AppContextMenuAction> actions;

  /// Styl wizualny menu.
  final AppContextMenuStyle style;

  /// Tytuł nagłówka menu.
  final String? headerTitle;

  /// Podtytuł nagłówka menu.
  final String? headerSubtitle;
  final AppContextMenuContentBuilder? contentBuilder;
  final double maxWidth;
  final double? maxHeight;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Zamknij menu kontekstowe';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return CustomSingleChildLayout(
      delegate: _AppContextMenuPositionDelegate(
        position,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      child: _AppContextMenuPanel(
        actions: actions,
        style: style,
        headerTitle: headerTitle,
        headerSubtitle: headerSubtitle,
        contentBuilder: contentBuilder,
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        alignment: .topLeft,
        scale: Tween<double>(begin: .985, end: 1).animate(curvedAnimation),
        child: child,
      ),
    );
  }
}

/// Delegat utrzymujący menu wewnątrz widocznego obszaru ekranu.
class _AppContextMenuPositionDelegate extends SingleChildLayoutDelegate {
  /// Tworzy delegata dla pozycji kursora.
  const _AppContextMenuPositionDelegate(
    this.position, {
    required this.maxWidth,
    this.maxHeight,
  });

  /// Pozycja kursora w globalnym układzie współrzędnych.
  final Offset position;
  final double maxWidth;
  final double? maxHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: 220,
      maxWidth: maxWidth,
      maxHeight: (maxHeight ?? constraints.maxHeight).clamp(
        0,
        constraints.maxHeight - (Sizes.p8 * 2),
      ),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final maxX = (size.width - childSize.width - Sizes.p8).clamp(
      Sizes.p8,
      double.infinity,
    );
    final maxY = (size.height - childSize.height - Sizes.p8).clamp(
      Sizes.p8,
      double.infinity,
    );
    return Offset(
      position.dx.clamp(Sizes.p8, maxX),
      position.dy.clamp(Sizes.p8, maxY),
    );
  }

  @override
  bool shouldRelayout(_AppContextMenuPositionDelegate oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.maxWidth != maxWidth ||
        oldDelegate.maxHeight != maxHeight;
  }
}

/// Wizualna powierzchnia menu kontekstowego.
class _AppContextMenuPanel extends StatelessWidget {
  /// Tworzy powierzchnię menu.
  const _AppContextMenuPanel({
    required this.actions,
    required this.style,
    this.headerTitle,
    this.headerSubtitle,
    this.contentBuilder,
  });

  /// Akcje prezentowane w menu.
  final List<AppContextMenuAction> actions;

  /// Styl wizualny menu.
  final AppContextMenuStyle style;

  /// Tytuł nagłówka menu.
  final String? headerTitle;

  /// Podtytuł nagłówka menu.
  final String? headerSubtitle;
  final AppContextMenuContentBuilder? contentBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return switch (style) {
      AppContextMenuStyle.glass => Material(
        type: .transparency,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: .3),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: CustomPaint(
            foregroundPainter: _AppContextMenuBorderPainter(
              highlightColor: context.theme.brightness == .dark
                  ? colors.onSurface
                  : colors.surface,
              outlineColor: colors.outlineVariant,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
              child: _AppContextMenuGlass(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: .topLeft,
                      end: .bottomRight,
                      colors: [
                        colors.surfaceContainerHighest.withValues(alpha: .34),
                        colors.surface.withValues(alpha: .2),
                        colors.surfaceContainerHigh.withValues(alpha: .28),
                      ],
                      stops: const [0, .52, 1],
                    ),
                    borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
                  ),
                  child: Material(
                    type: .transparency,
                    child: _body(context, AppContextMenuStyle.glass),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      AppContextMenuStyle.flat => Material(
        type: .transparency,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.theme.brightness == .dark
                ? const Color(0xFF1E2138)
                : Colors.white,
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            border: Border.all(
              color: context.theme.brightness == .dark
                  ? Colors.white.withValues(alpha: .12)
                  : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: context.theme.brightness == .dark ? .45 : .14,
                ),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: context.theme.brightness == .dark ? .20 : .04,
                ),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            child: Material(
              type: .transparency,
              child: _body(context, AppContextMenuStyle.flat),
            ),
          ),
        ),
      ),
    };
  }

  Widget _body(BuildContext context, AppContextMenuStyle itemStyle) =>
      contentBuilder?.call(context, () => Navigator.of(context).pop()) ??
      _AppContextMenuBody(
        actions: actions,
        headerTitle: headerTitle,
        headerSubtitle: headerSubtitle,
        itemStyle: itemStyle,
      );
}

/// Wspólny układ zawartości menu dla wszystkich stylów.
class _AppContextMenuBody extends StatelessWidget {
  /// Tworzy ciało menu dla wskazanego stylu.
  const _AppContextMenuBody({
    required this.actions,
    required this.itemStyle,
    this.headerTitle,
    this.headerSubtitle,
  });

  /// Akcje prezentowane w menu.
  final List<AppContextMenuAction> actions;

  /// Styl pojedynczych pozycji menu.
  final AppContextMenuStyle itemStyle;

  /// Tytuł nagłówka menu.
  final String? headerTitle;

  /// Podtytuł nagłówka menu.
  final String? headerSubtitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const .all(Sizes.p4),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          if (headerTitle case final title?) _buildHeader(context, title),
          for (var index = 0; index < actions.length; index++) ...[
            if (actions[index].separatorBefore)
              Divider(
                height: Sizes.p8,
                thickness: 1,
                color: _separatorColor(context),
              ),
            _AppContextMenuItem(
              action: actions[index],
              style: itemStyle,
              onPressed: () => Navigator.of(context).pop(index),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    final titleColor = switch (itemStyle) {
      AppContextMenuStyle.glass => Colors.white.withValues(alpha: .96),
      AppContextMenuStyle.flat => context.colors.onSurface,
    };
    final subtitleColor = switch (itemStyle) {
      AppContextMenuStyle.glass => Colors.white.withValues(alpha: .72),
      AppContextMenuStyle.flat => context.colors.onSurfaceVariant,
    };

    return Padding(
      padding: const .fromLTRB(Sizes.p10, Sizes.p8, Sizes.p10, Sizes.p4),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: .ellipsis,
            style: context.text.labelMedium?.copyWith(
              color: titleColor,
              fontWeight: .w700,
            ),
          ),
          if (headerSubtitle case final subtitle?) ...[
            Gaps.h2,
            Text(
              subtitle,
              maxLines: 1,
              overflow: .ellipsis,
              style: context.text.bodySmall?.copyWith(color: subtitleColor),
            ),
          ],
          Gaps.h4,
        ],
      ),
    );
  }

  Color _separatorColor(BuildContext context) {
    return switch (itemStyle) {
      AppContextMenuStyle.glass => Colors.white.withValues(alpha: .16),
      AppContextMenuStyle.flat => context.colors.outlineVariant.withValues(
        alpha: .55,
      ),
    };
  }
}

/// Warstwa refleksu szkła działająca niezależnie od backendu renderującego.
class _AppContextMenuReflection extends StatefulWidget {
  /// Tworzy warstwę refleksu w kolorze aktywnego motywu.
  const _AppContextMenuReflection({required this.color});

  /// Kolor światła odbitego przez szkło.
  final Color color;

  @override
  State<_AppContextMenuReflection> createState() =>
      _AppContextMenuReflectionState();
}

/// Stan zarządzający shaderem widocznego refleksu powierzchni.
class _AppContextMenuReflectionState extends State<_AppContextMenuReflection> {
  static Future<FragmentProgram>? _programFuture;

  FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    final programFuture = _programFuture ??= FragmentProgram.fromAsset(
      'shaders/app_context_menu_reflection.frag',
    );
    unawaited(
      programFuture.then((program) {
        if (!mounted) {
          return;
        }
        setState(() => _shader = program.fragmentShader());
      }),
    );
  }

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _shader == null
          ? null
          : _AppContextMenuReflectionPainter(
              shader: _shader!,
              color: widget.color,
            ),
    );
  }
}

/// Malarz nakładający skompilowany refleks shadera na powierzchnię menu.
class _AppContextMenuReflectionPainter extends CustomPainter {
  /// Tworzy malarza refleksu.
  const _AppContextMenuReflectionPainter({
    required this.shader,
    required this.color,
  });

  /// Shader używany do narysowania refleksu.
  final FragmentShader shader;

  /// Kolor światła refleksu.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, .7)
      ..setFloat(3, color.r)
      ..setFloat(4, color.g)
      ..setFloat(5, color.b);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_AppContextMenuReflectionPainter oldDelegate) {
    return oldDelegate.shader != shader || oldDelegate.color != color;
  }
}

/// Szklana warstwa menu korzystająca z shadera refrakcji tła.
class _AppContextMenuGlass extends StatefulWidget {
  /// Tworzy warstwę szkła dla zawartości menu.
  const _AppContextMenuGlass({required this.child});

  /// Zawartość renderowana ponad filtrowanym tłem.
  final Widget child;

  @override
  State<_AppContextMenuGlass> createState() => _AppContextMenuGlassState();
}

/// Stan zarządzający cyklem życia programu i instancji shadera.
class _AppContextMenuGlassState extends State<_AppContextMenuGlass> {
  static Future<FragmentProgram>? _programFuture;

  FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    final programFuture = _programFuture ??= FragmentProgram.fromAsset(
      'shaders/app_context_menu_glass.frag',
    );
    unawaited(
      programFuture.then((program) {
        if (!mounted) {
          return;
        }
        setState(() => _shader = program.fragmentShader());
      }),
    );
  }

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blurFilter = ImageFilter.blur(sigmaX: 6.5, sigmaY: 6.5);
    final shader = _shader;
    if (shader == null || !ImageFilter.isShaderFilterSupported) {
      return BackdropFilter(filter: blurFilter, child: widget.child);
    }

    final tint = context.colors.surface;
    shader
      ..setFloat(2, .017)
      ..setFloat(3, .65)
      ..setFloat(4, tint.r)
      ..setFloat(5, tint.g)
      ..setFloat(6, tint.b)
      ..setFloat(7, .07)
      ..setFloat(8, .32);
    final glassFilter = ImageFilter.compose(
      outer: ImageFilter.shader(shader),
      inner: blurFilter,
    );
    return BackdropFilter(filter: glassFilter, child: widget.child);
  }
}

/// Malarz neutralnego obrysu imitującego krawędź matowego szkła.
class _AppContextMenuBorderPainter extends CustomPainter {
  /// Tworzy malarza na podstawie kolorów aktywnego motywu.
  const _AppContextMenuBorderPainter({
    required this.highlightColor,
    required this.outlineColor,
  });

  /// Kolor świetlnego refleksu obrysu.
  final Color highlightColor;

  /// Kolor bazowego konturu obrysu.
  final Color outlineColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.1;
    const radius = Sizes.p12;
    final borderRect = Offset.zero & size;
    final borderPaint = Paint()
      ..shader = LinearGradient(
        begin: .topLeft,
        end: .bottomRight,
        colors: [
          highlightColor.withValues(alpha: .42),
          outlineColor.withValues(alpha: .18),
          outlineColor.withValues(alpha: .28),
        ],
      ).createShader(borderRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final rrect = RRect.fromRectAndRadius(
      borderRect.deflate(strokeWidth / 2),
      const Radius.circular(radius),
    );
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(_AppContextMenuBorderPainter oldDelegate) {
    return oldDelegate.highlightColor != highlightColor ||
        oldDelegate.outlineColor != outlineColor;
  }
}

/// Interaktywny wiersz akcji menu kontekstowego.
class _AppContextMenuItem extends StatefulWidget {
  /// Tworzy pojedynczy wiersz akcji.
  const _AppContextMenuItem({
    required this.action,
    required this.style,
    required this.onPressed,
  });

  /// Akcja prezentowana w wierszu.
  final AppContextMenuAction action;

  /// Styl menu, z którego pochodzi wiersz.
  final AppContextMenuStyle style;

  /// Funkcja zamykająca menu z wybraną akcją.
  final VoidCallback onPressed;

  @override
  State<_AppContextMenuItem> createState() => _AppContextMenuItemState();
}

/// Stan wiersza menu obsługujący kontrastowy wygląd po najechaniu.
class _AppContextMenuItemState extends State<_AppContextMenuItem> {
  var _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final action = widget.action;
    final colors = context.colors;
    final isDark = context.theme.brightness == Brightness.dark;
    final defaultForegroundColor =
        action.foregroundColor ??
        switch (widget.style) {
          AppContextMenuStyle.glass =>
            action.isDestructive
                ? colors.errorContainer
                : Colors.white.withValues(alpha: .94),
          AppContextMenuStyle.flat =>
            action.isDestructive
                ? (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626))
                : (isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B)),
        };
    final hoveredForegroundColor = switch (widget.style) {
      AppContextMenuStyle.glass =>
        action.isDestructive ? colors.errorContainer : Colors.white,
      AppContextMenuStyle.flat =>
        action.isDestructive
            ? (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626))
            : (isDark ? Colors.white : const Color(0xFF0F172A)),
    };
    final foregroundColor = _isHovered
        ? hoveredForegroundColor
        : defaultForegroundColor;
    final hoverColor = switch (widget.style) {
      AppContextMenuStyle.glass =>
        action.isDestructive
            ? colors.error.withValues(alpha: .92)
            : colors.primary.withValues(alpha: .92),
      AppContextMenuStyle.flat =>
        action.isDestructive
            ? (isDark
                  ? const Color(0xFFDC2626).withValues(alpha: .22)
                  : const Color(0xFFFEE2E2))
            : (isDark
                  ? Colors.white.withValues(alpha: .08)
                  : const Color(0xFFF1F5F9)),
    };

    return MouseRegion(
      cursor: action.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: Material(
        type: .transparency,
        child: InkWell(
          borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
          hoverColor: hoverColor,
          highlightColor: hoverColor,
          splashFactory: NoSplash.splashFactory,
          onHover: action.enabled
              ? (isHovered) => setState(() => _isHovered = isHovered)
              : null,
          onTap: action.enabled ? widget.onPressed : null,
          child: SizedBox(
            height: 30,
            child: Opacity(
              opacity: action.enabled ? 1 : .4,
              child: Padding(
                padding: const .symmetric(horizontal: Sizes.p10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      child: action.icon == null
                          ? null
                          : Icon(action.icon, size: 15, color: foregroundColor),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: Text(
                        action.label,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: context.text.bodySmall?.copyWith(
                          fontSize: 12.5,
                          color: foregroundColor,
                          fontWeight: action.selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (action.selected)
                      Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: _isHovered
                            ? hoveredForegroundColor
                            : switch (widget.style) {
                                AppContextMenuStyle.glass =>
                                  Colors.white.withValues(alpha: .92),
                                AppContextMenuStyle.flat => colors.primary,
                              },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
