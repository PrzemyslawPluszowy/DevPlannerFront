import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Compact option row used by Chat creation instead of default radio tiles.
class ChatSelectionTile extends StatelessWidget {
  const ChatSelectionTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.icon,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final active = selected;
    return Material(
      color: active ? chat.selectedSurface : chat.listSurface,
      borderRadius: BorderRadius.circular(14),
      child: Semantics(
        button: true,
        selected: selected,
        enabled: enabled,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(Sizes.p12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: active ? chat.focusRing : chat.separator,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: active ? chat.mentionSurface : chat.hoverSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 19,
                    color: enabled ? chat.focusRing : chat.metadataText,
                  ),
                ),
                const SizedBox(width: Sizes.p12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: chat.contentStyle.copyWith(
                          color: enabled
                              ? chat.incomingText
                              : chat.metadataText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: Sizes.p2),
                      Text(
                        subtitle,
                        style: chat.metadataStyle.copyWith(
                          color: chat.metadataText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Sizes.p8),
                Icon(
                  active ? Symbols.check_circle : Symbols.circle,
                  size: 20,
                  color: active ? chat.focusRing : chat.separator,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
