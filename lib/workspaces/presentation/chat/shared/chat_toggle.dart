import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Przełącznik Chat z własną geometrią i kolorami niezależnymi od Material.
final class ChatToggle extends StatelessWidget {
  const ChatToggle({
    required this.value,
    required this.label,
    required this.onChanged,
    this.showLabel = false,
    this.activeColor,
    super.key,
  });

  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;
  final bool showLabel;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final activeTrack = activeColor ?? chat.focusRing;
    return Semantics(
      label: label,
      toggled: value,
      enabled: onChanged != null,
      button: true,
      child: Tooltip(
        message: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            onTap: onChanged == null ? null : () => onChanged!(!value),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: showLabel ? Sizes.p8 : Sizes.p4,
                vertical: Sizes.p6,
              ),
              child: Row(
                mainAxisSize: showLabel ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (showLabel) ...[
                    Icon(
                      Symbols.do_not_disturb_on_rounded,
                      size: 17,
                      color: value ? chat.presenceDnd : chat.metadataText,
                    ),
                    const SizedBox(width: Sizes.p4),
                    Expanded(
                      child: Text(
                        label,
                        style: chat.metadataStyle.copyWith(
                          color: value ? chat.presenceDnd : chat.metadataText,
                          fontWeight: value ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    width: 34,
                    height: 20,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: value ? activeTrack : chat.separator,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      alignment: value
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: value ? Colors.white : chat.listSurface,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox.square(dimension: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
