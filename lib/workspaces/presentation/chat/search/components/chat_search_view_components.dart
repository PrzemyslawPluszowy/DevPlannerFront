import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/presentation/chat/search/chat_search_snippet_spans.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChatSearchHitRow extends StatelessWidget {
  const ChatSearchHitRow({
    required this.hit,
    required this.conversation,
    required this.isOpening,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final ChatSearchHit hit;
  final ChatInboxItem? conversation;
  final bool isOpening;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final currentConversation = conversation;
    final sender = currentConversation?.participants
        .where((participant) => participant.userId == hit.authorUserId)
        .firstOrNull;
    final other = currentConversation?.otherParticipants.firstOrNull;
    final isDirect = currentConversation?.conversation.type == 'direct';
    final localTime = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(hit.createdAtUtc.toLocal()),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p8,
        vertical: Sizes.p2,
      ),
      child: Material(
        color: chat.listSurface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDirect)
                  AppUserAvatar(
                    userId: other?.userId,
                    displayName:
                        other?.label ?? currentConversation?.displayName,
                    avatarUrl: other?.avatarUrl,
                    hasCustomAvatar:
                        other?.avatarUrl?.trim().isNotEmpty == true,
                    radius: 18,
                    singleInitial: true,
                  )
                else
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: chat.selectedSurface,
                    child: Icon(
                      currentConversation?.conversation.type == 'channel'
                          ? Symbols.campaign_rounded
                          : Symbols.group_rounded,
                      size: 18,
                      color: chat.linkText,
                    ),
                  ),
                const SizedBox(width: Sizes.p10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              currentConversation?.displayName ??
                                  hit.conversationName ??
                                  context.l10n.chatSearchOpenResult,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: chat.contentStyle.copyWith(
                                color: chat.incomingText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: Sizes.p8),
                          if (!isOpening)
                            Text(
                              localTime,
                              style: chat.metadataStyle.copyWith(
                                color: chat.metadataText,
                              ),
                            )
                          else
                            SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: chat.linkText,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: Sizes.p2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              sender?.label ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: chat.metadataStyle.copyWith(
                                color: chat.metadataText,
                              ),
                            ),
                          ),
                          if (hit.hasMention)
                            Icon(
                              Symbols.alternate_email,
                              size: 14,
                              color: chat.mentionText,
                            ),
                        ],
                      ),
                      const SizedBox(height: Sizes.p4),
                      Text.rich(
                        ChatSearchSnippetSpans.build(
                          hit.highlight ?? hit.text,
                          baseStyle: chat.contentStyle.copyWith(
                            color: chat.metadataText,
                          ),
                          matchStyle: chat.contentStyle.copyWith(
                            color: chat.incomingText,
                            fontWeight: FontWeight.w700,
                            backgroundColor: chat.selectedSurface,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatSearchMessage extends StatelessWidget {
  const ChatSearchMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
    this.retryEnabled = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final bool retryEnabled;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: chat.metadataText),
            const SizedBox(height: Sizes.p8),
            Text(
              title,
              style: chat.contentStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: chat.incomingText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.p4),
            Text(
              message,
              style: chat.metadataStyle.copyWith(color: chat.metadataText),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Sizes.p8),
              TextButton(
                onPressed: retryEnabled ? onRetry : null,
                child: Text(context.l10n.chatInboxRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
