import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A confirmed empty history, not a replacement for loading or failure.
final class ChatPanelEmptyHistory extends StatelessWidget {
  const ChatPanelEmptyHistory({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Icon(
              Symbols.chat_bubble_outline_rounded,
              size: 24,
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.chatConversationEmptyTitle,
            textAlign: TextAlign.center,
            style: context.tasksTheme.dataStrongText,
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.chatConversationEmptyMessage,
            textAlign: TextAlign.center,
            style: context.tasksTheme.dataText.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}
