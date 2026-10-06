part of '../../tasks_board_page.dart';

/// Ramka karty Kanban odpowiada za hover, focus, zaznaczenie i menu klawiaturowe.
class KanbanCardFrame extends StatefulWidget {
  const KanbanCardFrame({
    required this.child,
    this.isSelected = false,
    this.isPending = false,
    this.hasError = false,
    this.onTap,
    this.onSecondaryTapUp,
    this.onShowContextMenu,
    this.semanticsLabel,
    this.padding,
    this.focusNode,
    super.key,
  });

  final Widget child;
  final bool isSelected;

  /// Karta, której zapis trwa; nie zmniejsza czytelności tytułu.
  final bool isPending;

  /// Karta po nieudanym zapisie; obrys bierze kolor błędu, a komunikat i tak
  /// niesie banner, żeby błąd nie był zakodowany wyłącznie kolorem.
  final bool hasError;
  final VoidCallback? onTap;
  final void Function(TapUpDetails details)? onSecondaryTapUp;
  final VoidCallback? onShowContextMenu;
  final String? semanticsLabel;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;

  @override
  State<KanbanCardFrame> createState() => _KanbanCardFrameState();
}

class _KanbanCardFrameState extends State<KanbanCardFrame> {
  final _isHovered = ValueNotifier<bool>(false);
  final _isFocused = ValueNotifier<bool>(false);
  late final Listenable _interactionChanges;

  @override
  void initState() {
    super.initState();
    _interactionChanges = Listenable.merge([_isHovered, _isFocused]);
  }

  @override
  void dispose() {
    _isHovered.dispose();
    _isFocused.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _interactionChanges,
    builder: (context, _) => _KanbanCardSurface(
      isHovered: _isHovered.value,
      isFocused: _isFocused.value,
      isSelected: widget.isSelected,
      isPending: widget.isPending,
      hasError: widget.hasError,
      onTap: widget.onTap,
      onSecondaryTapUp: widget.onSecondaryTapUp,
      onShowContextMenu: widget.onShowContextMenu,
      semanticsLabel: widget.semanticsLabel,
      padding: widget.padding,
      focusNode: widget.focusNode,
      onHoverChanged: (hovered) => _isHovered.value = hovered,
      onFocusChanged: (focused) => _isFocused.value = focused,
      child: widget.child,
    ),
  );
}

/// Rysuje kartę z aktualnego stanu interakcji i zachowuje jej geometrię.
class _KanbanCardSurface extends StatelessWidget {
  const _KanbanCardSurface({
    required this.child,
    required this.isHovered,
    required this.isFocused,
    required this.isSelected,
    required this.isPending,
    required this.hasError,
    required this.onHoverChanged,
    required this.onFocusChanged,
    this.onTap,
    this.onSecondaryTapUp,
    this.onShowContextMenu,
    this.semanticsLabel,
    this.padding,
    this.focusNode,
  });

  final Widget child;
  final bool isHovered;
  final bool isFocused;
  final bool isSelected;
  final bool isPending;
  final bool hasError;
  final ValueChanged<bool> onHoverChanged;
  final ValueChanged<bool> onFocusChanged;
  final VoidCallback? onTap;
  final void Function(TapUpDetails details)? onSecondaryTapUp;
  final VoidCallback? onShowContextMenu;
  final String? semanticsLabel;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final highContrast = MediaQuery.maybeHighContrastOf(context) ?? false;
    final solidBorderColor = isFocused
        ? KanbanCardTokens.cardFocusRing(colors)
        : hasError
        ? KanbanCardTokens.cardBorderError(colors)
        : KanbanCardTokens.cardBorderSelected(colors);
    final cardBackgroundColor = isSelected
        ? KanbanCardTokens.cardSurfaceSelected(colors)
        : isPending
        ? KanbanCardTokens.cardSurfacePending(colors)
        : KanbanCardTokens.cardSurfaceRest(colors);
    final dashedBorderColor = isHovered
        ? KanbanCardTokens.cardFocusRing(colors)
        : KanbanCardTokens.cardDashedBorderRest(
            colors,
            isDark: isDark,
            highContrast: highContrast,
          );
    final usesSolidBorder = isSelected || hasError || isFocused;
    final card = AnimatedContainer(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
        border: usesSolidBorder
            ? Border.all(
                color: solidBorderColor,
                width: isFocused ? 2 : KanbanCardTokens.cardBorderWidth,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
        child: InkWell(
          focusNode: focusNode,
          onTap: onTap,
          onSecondaryTapUp: onSecondaryTapUp,
          borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          onFocusChange: onFocusChanged,
          child: Stack(
            children: [
              Padding(
                padding: padding ?? KanbanCardTokens.contentPaddingComfortable,
                child: child,
              ),
              if (isPending)
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 0,
                  child: _KanbanCardPendingIndicator(
                    label: context.l10n.tasksBulkSaving,
                    color: colors.primary,
                    reduceMotion: reduceMotion,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    final dashedCard = usesSolidBorder
        ? card
        : CustomPaint(
            foregroundPainter: DottedRRectPainter(
              color: dashedBorderColor,
              dotDiameter: 2,
              step: 6,
            ),
            child: card,
          );
    final keyboardEnabledCard = onShowContextMenu == null
        ? dashedCard
        : Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.f10, shift: true):
                  _ShowKanbanContextMenuIntent(),
              SingleActivator(LogicalKeyboardKey.contextMenu):
                  _ShowKanbanContextMenuIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                _ShowKanbanContextMenuIntent:
                    CallbackAction<_ShowKanbanContextMenuIntent>(
                      onInvoke: (_) {
                        onShowContextMenu?.call();
                        return null;
                      },
                    ),
              },
              child: dashedCard,
            ),
          );
    final framedCard = isFocused
        ? DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                KanbanCardTokens.cardRadius + 2.0,
              ),
              border: Border.all(color: colors.primary, width: 2.0),
            ),
            child: keyboardEnabledCard,
          )
        : keyboardEnabledCard;
    final result = MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: framedCard,
    );
    if (semanticsLabel != null || isPending) {
      final savingLabel = isPending ? context.l10n.tasksBulkSaving : null;
      return Semantics(
        button: onTap != null,
        label: semanticsLabel,
        value: savingLabel,
        liveRegion: isPending,
        child: result,
      );
    }
    return result;
  }
}

/// Delikatny pasek zapisu mieści się w wewnętrznym odstępie bez zmiany układu.
class _KanbanCardPendingIndicator extends StatelessWidget {
  const _KanbanCardPendingIndicator({
    required this.label,
    required this.color,
    required this.reduceMotion,
  });

  final String label;
  final Color color;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    child: ExcludeSemantics(
      child: SizedBox(
        height: 8,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: reduceMotion
              ? SizedBox(
                  width: 32,
                  height: 2,
                  child: ColoredBox(
                    key: const ValueKey<String>(
                      'kanban-card-pending-indicator',
                    ),
                    color: color,
                  ),
                )
              : SizedBox(
                  height: 2,
                  child: LinearProgressIndicator(
                    key: const ValueKey<String>(
                      'kanban-card-pending-indicator',
                    ),
                    minHeight: 2,
                    color: color,
                    backgroundColor: color.withValues(alpha: .18),
                  ),
                ),
        ),
      ),
    ),
  );
}

class _ShowKanbanContextMenuIntent extends Intent {
  const _ShowKanbanContextMenuIntent();
}

/// Alias kompatybilności wstecznej dla starszych testów i konsumentów.
typedef KanbanDottedCardFrame = KanbanCardFrame;
