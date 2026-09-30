import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Przycisk filtra skrzynki stylowany tokenami komunikatora, bez Material Chip.
final class ChatPanelFilterPill extends StatefulWidget {
  const ChatPanelFilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  State<ChatPanelFilterPill> createState() => _ChatPanelFilterPillState();
}

final class _ChatPanelFilterPillState extends State<ChatPanelFilterPill> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final selected = widget.selected;
    final foreground = selected ? chat.focusRing : chat.metadataText;
    return Semantics(
      button: true,
      enabled: widget.onTap != null,
      selected: selected,
      label: widget.label,
      onTap: widget.onTap,
      child: ExcludeSemantics(
        child: Focus(
          canRequestFocus: widget.onTap != null,
          onFocusChange: (focused) => setState(() => _focused = focused),
          onKeyEvent: (_, event) {
            if (widget.onTap == null || event is! KeyDownEvent) {
              return KeyEventResult.ignored;
            }
            if (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.space) {
              widget.onTap!();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: MouseRegion(
            cursor: widget.onTap == null
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.p10,
                  vertical: Sizes.p6,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? chat.selectedSurface
                      : _hovered
                      ? chat.hoverSurface
                      : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                  border: Border.all(
                    color: selected || _focused
                        ? chat.focusRing.withValues(alpha: .65)
                        : chat.separator,
                  ),
                ),
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: chat.metadataStyle.copyWith(
                    color: foreground,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
