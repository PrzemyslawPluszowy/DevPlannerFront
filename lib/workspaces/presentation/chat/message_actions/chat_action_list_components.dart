import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChatActionLoadFailure extends StatelessWidget {
  const ChatActionLoadFailure({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.error_outline, size: 24, color: chat.error),
          const SizedBox(height: Sizes.p8),
          Text(
            context.l10n.chatActionFailureMessage,
            textAlign: TextAlign.center,
            style: chat.contentStyle.copyWith(color: chat.metadataText),
          ),
          const SizedBox(height: Sizes.p4),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.chatInboxRetry),
          ),
        ],
      ),
    );
  }
}

class ChatActionListRow extends StatelessWidget {
  const ChatActionListRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p6),
      child: Material(
        color: chat.listSurface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.p12,
              top: Sizes.p6,
              bottom: Sizes.p6,
              right: Sizes.p4,
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: chat.linkText),
                const SizedBox(width: Sizes.p10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chat.contentStyle.copyWith(
                          color: chat.incomingText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chat.metadataStyle.copyWith(
                          color: chat.metadataText,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
