import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';

/// Pozycja hierarchicznego menu oparta o [Expansible], bez stylu
/// `ExpansionTile`.
///
/// Nagłówek ma osobną akcję nawigacji (`onTap`) oraz chevron rozwijający
/// dzieci. Pozwala to kliknąć workspace/projekt i przejść do jego strony,
/// jednocześnie zachowując niezależne sterowanie podmenu. Komponent nie
/// wykonuje żadnych wywołań API.
class AppExpansibleNavigationItem extends StatefulWidget {
  /// Tworzy pozycję menu z opcjonalnym rozwijanym podmenu.
  const AppExpansibleNavigationItem({
    required this.label,
    required this.icon,
    super.key,
    this.customLeading,
    this.iconColor,
    this.body = const SizedBox.shrink(),
    this.hasChildren = false,
    this.initiallyExpanded = false,
    this.expanded,
    this.controller,
    this.onExpansionChanged,
    this.onTap,
    this.trailing,
    this.badgeCount,
    this.badgeLabel,
    this.selected = false,
    this.enabled = true,
    this.depth = 0,
  });

  /// Etykieta pozycji.
  final String label;

  /// Ikona pozycji.
  final IconData icon;

  /// Opcjonalny własny widget wiodący zamiast domyślnej ikony.
  final Widget? customLeading;

  /// Opcjonalny dedykowany kolor akcentowy ikony (generuje kolorową kapsułkę).
  final Color? iconColor;

  /// Treść podmenu.
  final Widget body;

  /// Czy pokazać chevron i używać mechanizmu `Expansible`.
  final bool hasChildren;

  /// Początkowy stan, używany tylko gdy nie przekazano kontrolera.
  final bool initiallyExpanded;

  /// Opcjonalny stan kontrolowany przez rodzica.
  ///
  /// Stan kontrolowany przez rodzica. `false` blokuje rozwijanie, a `true`
  /// wymusza otwarcie. Dla zwykłego menu użyj [initiallyExpanded], aby
  /// użytkownik mógł swobodnie zwijać gałęzie.
  final bool? expanded;

  /// Opcjonalny kontroler zewnętrzny; należy go zwolnić po stronie właściciela.
  final ExpansibleController? controller;

  /// Powiadamia właściciela o zmianie rozwinięcia, bez logiki API.
  final ValueChanged<bool>? onExpansionChanged;

  /// Akcja nawigacji wykonywana po kliknięciu etykiety.
  final VoidCallback? onTap;

  /// Dodatkowy widget po prawej stronie nagłówka.
  final Widget? trailing;

  /// Opcjonalny licznik elementów wyświetlany w małej pastylce.
  final int? badgeCount;

  /// Opcjonalna krótka etykieta tekstowa w pastylce badge'a.
  final String? badgeLabel;

  /// Czy pozycja jest aktualnie aktywna.
  final bool selected;

  /// Czy pozycja przyjmuje interakcje.
  final bool enabled;

  /// Poziom zagnieżdżenia wpływający na wcięcie.
  final int depth;

  @override
  State<AppExpansibleNavigationItem> createState() =>
      _AppExpansibleNavigationItemState();
}

class _AppExpansibleNavigationItemState
    extends State<AppExpansibleNavigationItem> {
  late final ExpansibleController _ownedController;
  bool _hasFocus = false;

  ExpansibleController get _controller => widget.controller ?? _ownedController;

  @override
  void initState() {
    super.initState();
    _ownedController = ExpansibleController();
    _controller.addListener(_handleExpansionChanged);
    if (widget.controller == null &&
        (widget.expanded ?? widget.initiallyExpanded)) {
      _ownedController.expand();
    }
    _syncControlledExpansion();
  }

  @override
  void didUpdateWidget(covariant AppExpansibleNavigationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownedController).removeListener(
        _handleExpansionChanged,
      );
      _controller.addListener(_handleExpansionChanged);
    }
    if (oldWidget.expanded != widget.expanded ||
        oldWidget.controller != widget.controller) {
      _syncControlledExpansion();
    }
    // Aktywna trasa otwiera gałąź przy wejściu, ale pozycja pozostaje
    // lokalnie sterowalna. Dzięki temu można zwinąć aktywny workspace i
    // rozwinąć inny bez sztucznego blokowania chevronu.
    if (widget.controller == null &&
        widget.expanded == null &&
        !oldWidget.selected &&
        widget.selected &&
        !_controller.isExpanded) {
      _controller.expand();
    }
  }

  void _handleExpansionChanged() {
    widget.onExpansionChanged?.call(_controller.isExpanded);
  }

  void _syncControlledExpansion() {
    final desired = widget.expanded;
    if (desired == null) return;
    if (desired && !_controller.isExpanded) {
      _controller.expand();
    } else if (!desired && _controller.isExpanded) {
      _controller.collapse();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleExpansionChanged);
    _ownedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasChildren) return _buildInteractiveHeader(context, null);

    return Expansible(
      controller: _controller,
      animationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
      headerBuilder: _buildInteractiveHeader,
      bodyBuilder: (context, animation) => widget.body,
    );
  }

  Widget _buildInteractiveHeader(
    BuildContext context,
    Animation<double>? animation,
  ) {
    if (!widget.hasChildren) return _buildHeader(context, animation);
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowRight):
            _ExpandNavigationIntent(),
        SingleActivator(LogicalKeyboardKey.arrowLeft):
            _CollapseNavigationIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _ExpandNavigationIntent: CallbackAction<_ExpandNavigationIntent>(
            onInvoke: (_) {
              _controller.expand();
              return null;
            },
          ),
          _CollapseNavigationIntent: CallbackAction<_CollapseNavigationIntent>(
            onInvoke: (_) {
              _controller.collapse();
              return null;
            },
          ),
        },
        child: _buildHeader(context, animation),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Animation<double>? animation) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = widget.selected
        ? (isDark
              ? colors.primary.withValues(alpha: .18)
              : colors.primary.withValues(alpha: .10))
        : Colors.transparent;
    final foreground = widget.selected
        ? (isDark ? colors.primaryFixed : colors.primary)
        : colors.onSurfaceVariant;

    Widget leadingWidget;
    if (widget.customLeading != null) {
      leadingWidget = widget.customLeading!;
    } else if (widget.iconColor != null) {
      leadingWidget = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: widget.iconColor!.withValues(alpha: isDark ? .22 : .12),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(
            color: widget.iconColor!.withValues(alpha: isDark ? .38 : .24),
          ),
        ),
        child: Center(
          child: Icon(widget.icon, size: 13, color: widget.iconColor),
        ),
      );
    } else {
      leadingWidget = Icon(widget.icon, size: 18, color: foreground);
    }

    final hasBadge =
        (widget.badgeCount != null && widget.badgeCount! > 0) ||
        (widget.badgeLabel != null && widget.badgeLabel!.isNotEmpty);

    return Focus(
      onFocusChange: (focused) {
        if (mounted) setState(() => _hasFocus = focused);
      },
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: Sizes.p4 + (widget.depth * Sizes.p12),
            end: Sizes.p4,
            top: 1.5,
            bottom: 1.5,
          ),
          child: InkWell(
            onTap: widget.enabled ? widget.onTap : null,
            hoverColor: isDark
                ? colors.onSurface.withValues(alpha: .06)
                : colors.primary.withValues(alpha: .05),
            focusColor: colors.primary.withValues(alpha: .12),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: background,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: widget.selected
                    ? Border.all(
                        color: colors.primary.withValues(
                          alpha: isDark ? .35 : .22,
                        ),
                      )
                    : (_hasFocus ? Border.all(color: colors.secondary) : null),
              ),
              child: SizedBox(
                height: 34,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
                  child: Row(
                    children: [
                      leadingWidget,
                      Gaps.w8,
                      Expanded(
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.labelMedium?.copyWith(
                            color: widget.selected
                                ? (isDark ? colors.onSurface : colors.primary)
                                : colors.onSurface,
                            fontWeight: widget.selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            letterSpacing: .1,
                          ),
                        ),
                      ),
                      if (hasBadge)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: widget.selected
                                ? colors.primary.withValues(
                                    alpha: isDark ? .30 : .16,
                                  )
                                : colors.surfaceContainerHighest,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            widget.badgeLabel ?? '${widget.badgeCount}',
                            style: context.text.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: widget.selected
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      if (widget.trailing != null) widget.trailing!,
                      if (widget.hasChildren)
                        IconButton(
                          tooltip: widget.expanded == false
                              ? 'Aktywny workspace rozwija podmenu'
                              : (_controller.isExpanded ? 'Zwiń' : 'Rozwiń'),
                          onPressed: widget.enabled && widget.expanded == null
                              ? _controller.toggle
                              : null,
                          icon: RotationTransition(
                            turns: Tween<double>(begin: 0, end: .25).animate(
                              animation ?? const AlwaysStoppedAnimation(0),
                            ),
                            child: const Icon(AppIcons.chevronRight, size: 16),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpandNavigationIntent extends Intent {
  const _ExpandNavigationIntent();
}

class _CollapseNavigationIntent extends Intent {
  const _CollapseNavigationIntent();
}
