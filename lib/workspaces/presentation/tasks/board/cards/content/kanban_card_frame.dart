part of '../../tasks_board_page.dart';

/// Ramka karty Kanban odpowiada za hover, focus, zaznaczenie i menu klawiaturowe.
class KanbanCardFrame extends StatefulWidget {
  const KanbanCardFrame({
    required this.child,
    this.isSelected = false,
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
    final borderColor = widget.isSelected
        ? KanbanCardTokens.cardBorderSelected(colors)
        : isHovered
        ? KanbanCardTokens.cardBorderHover(colors, isDark: isDark)
        : KanbanCardTokens.cardBorderRest(colors, isDark: isDark);
    final cardBackgroundColor = widget.isSelected
        ? colors.primaryContainer.withValues(alpha: .14)
        : isHovered
        ? colors.surfaceContainerHighest.withValues(alpha: .30)
        : colors.surface;
    final elevation = isHovered
        ? KanbanCardTokens.cardElevationHover
        : KanbanCardTokens.cardElevationRest;
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
        border: Border.all(color: borderColor),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: context.tasksTheme.shadow.withValues(
                    alpha: isDark ? .30 : .08,
                  ),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
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
    final keyboardEnabledCard = widget.onShowContextMenu == null
        ? card
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
              child: card,
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
