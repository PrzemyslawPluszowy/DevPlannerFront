import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Compact, explicit presence text for direct conversations in the inbox.
final class ChatInboxPresenceLabel extends StatelessWidget {
  const ChatInboxPresenceLabel({required this.isOnline, super.key});

  final bool? isOnline;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final label = switch (isOnline) {
      true => context.l10n.tasksPresenceOnline,
      false => context.l10n.tasksPresenceOffline,
      null => context.l10n.projectPeoplePresenceUnknown,
    };
    final color = isOnline == true ? chat.presenceOnline : chat.metadataText;
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 136),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline == true ? color : null,
                    border: Border.all(color: color, width: 1.5),
                  ),
                  child: isOnline == null
                      ? Center(
                          child: SizedBox.square(
                            dimension: 2,
                            child: ColoredBox(color: color),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: Sizes.p4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: chat.metadataStyle.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
