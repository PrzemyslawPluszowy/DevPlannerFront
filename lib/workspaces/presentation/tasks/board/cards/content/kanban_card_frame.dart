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

  @override
  void dispose() {
    _isHovered.dispose();
    _isFocused.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([_isHovered, _isFocused]),
    builder: (context, _) => _buildCard(
      context,
      isHovered: _isHovered.value,
      isFocused: _isFocused.value,
    ),
  );

  Widget _buildCard(
    BuildContext context, {
    required bool isHovered,
    required bool isFocused,
  }) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Systemowe preferencje dostępności: bez animacji nie mrugamy layoutem,
    // a wysoki kontrast wzmacnia obrys zamiast subtelnej alfy.
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final highContrast = MediaQuery.maybeHighContrastOf(context) ?? false;
    // Focus klawiatury ma pierwszeństwo nad błędem i zaznaczeniem: bez tego
    // użytkownik klawiatury nie widzi, która karta jest aktywna.
    final solidBorderColor = isFocused
        ? KanbanCardTokens.cardFocusRing(colors)
        : widget.hasError
        ? KanbanCardTokens.cardBorderError(colors)
        : KanbanCardTokens.cardBorderSelected(colors);
    // Hover podświetla wyłącznie ramkę kafelka; tło zostaje spokojne, żeby
    // czytanie tablicy nie mrugało pod kursorem.
    final cardBackgroundColor = widget.isSelected
        ? KanbanCardTokens.cardSurfaceSelected(colors)
        : widget.isPending
        ? KanbanCardTokens.cardSurfacePending(colors)
        : KanbanCardTokens.cardSurfaceRest(colors);
    // Obrys kafelka jest przerywany: w spoczynku biel w motywie ciemnym
    // i czerń w jasnym, a hover zamienia go na niebieski. Zaznaczenie, błąd
    // i focus zostają ciągłą ramką, bo niosą znaczenie, którego kropki nie
    // zastąpią.
    final dashedBorderColor = isHovered
        ? KanbanCardTokens.cardFocusRing(colors)
        : KanbanCardTokens.cardDashedBorderRest(
            colors,
            isDark: isDark,
            highContrast: highContrast,
          );
    final usesSolidBorder = widget.isSelected || widget.hasError || isFocused;
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
          focusNode: widget.focusNode,
          onTap: widget.onTap,
          onSecondaryTapUp: widget.onSecondaryTapUp,
          borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          onFocusChange: (focused) => _isFocused.value = focused,
          child: Padding(
            padding:
                widget.padding ?? KanbanCardTokens.contentPaddingComfortable,
            child: widget.child,
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
    final keyboardEnabledCard = widget.onShowContextMenu == null
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
                        widget.onShowContextMenu?.call();
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
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: framedCard,
    );
    if (widget.semanticsLabel case final label?) {
      return Semantics(button: true, label: label, child: result);
    }
    return result;
  }
}

class _ShowKanbanContextMenuIntent extends Intent {
  const _ShowKanbanContextMenuIntent();
}

/// Alias kompatybilności wstecznej dla starszych testów i konsumentów.
typedef KanbanDottedCardFrame = KanbanCardFrame;
