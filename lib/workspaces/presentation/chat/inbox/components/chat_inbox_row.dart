import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wiersz skrzynki rozmów: awatar, nazwa, podgląd, czas i stan nieprzeczytania.
///
/// Wiersz nie pobiera danych ani nie zna nawigacji; dostaje gotową pozycję
/// domenową i zgłasza wybór. Stan wysłania per wiadomość należy do widoku
/// rozmowy, nie do wiersza skrzynki.
class ChatInboxRow extends StatelessWidget {
  /// Tworzy wiersz skrzynki.
  const ChatInboxRow({
    required this.item,
    required this.nowUtc,
    this.onTap,
    this.selected = false,
    super.key,
  });

  /// Minimalna wysokość wiersza kolumny listy z §2.3 planu korekty.
  static const double minHeight = 72;

  /// Rozmiar awatara rozmowy z §2.3.
  static const double avatarSize = 44;

  final ChatInboxItem item;
  final DateTime nowUtc;
  final ValueChanged<ChatInboxItem>? onTap;

  /// Czy wiersz jest aktualnie otwartą rozmową.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unread = item.hasUnread;
    final preview = _previewText(context);

    return Semantics(
      button: true,
      selected: selected,
      label: _semanticsLabel(context, preview),
      child: Material(
        color: selected
            ? theme.colorScheme.primaryContainer.withValues(alpha: .55)
            : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          onTap: onTap == null ? null : () => onTap!(item),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: minHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p10,
              ),
              child: Row(
                children: [
                  _ChatInboxAvatar(item: item),
                  const SizedBox(width: Sizes.p12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: unread
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: Sizes.p8),
                            Text(
                              _relativeTime(
                                context,
                                item.lastActivityAtUtc,
                                nowUtc,
                              ),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Sizes.p4),
                        Row(
                          children: [
                            if (item.isDraft) ...[
                              _ChatInboxLabel(text: context.l10n.chatInboxDraftLabel),
                              const SizedBox(width: Sizes.p6),
                            ],
                            if (item.isMuted) ...[
                              Icon(
                                Symbols.volume_off,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: Sizes.p4),
                            ],
                            Expanded(
                              child: Text(
                                preview,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            if (unread) ...[
                              const SizedBox(width: Sizes.p8),
                              _ChatUnreadBadge(count: item.unreadCount),
                            ],
                          ],
                        ),
                      ],
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

  /// Prefiks autora w podglądzie grupy lub kanału.
  ///
  /// W rozmowie 1:1 autor jest oczywisty, a w grupie podgląd bez autora myli
  /// własną wiadomość z cudzą, dlatego podgląd dostaje nazwę nadawcy z listy
  /// uczestników zwróconej przez serwer.
  String? _authorPrefix(BuildContext context) {
    final type = item.conversation.type;
    if (type == 'direct') return null;
    final authorId = item.lastMessage?.authorUserId;
    if (authorId == null) return null;
    for (final participant in item.participants) {
      if (participant.userId == authorId) {
        return participant.isCurrentUser
            ? context.l10n.chatMembersYou
            : participant.label;
      }
    }
    return null;
  }

  String _previewText(BuildContext context) {
    final l10n = context.l10n;
    final draft = item.draftText?.trim();
    if (item.isDraft && draft != null && draft.isNotEmpty) {
      return l10n.chatInboxDraftPreview(draft);
    }
    final message = item.lastMessage;
    if (message == null) return l10n.globalChatEmptyMessage;
    final author = _authorPrefix(context);
    final prefix = author == null ? '' : '$author: ';
    if (message.isDeleted) return '$prefix${l10n.globalChatDeletedMessage}';
    final text = message.text?.trim();
    if (text != null && text.isNotEmpty) return '$prefix$text';
    return prefix +
        (message.hasAttachments
            ? l10n.chatInboxAttachmentPreview
            : l10n.globalChatDeletedMessage);
  }

  String _semanticsLabel(BuildContext context, String preview) {
    final l10n = context.l10n;
    final parts = <String>[
      item.displayName,
      if (item.hasUnread) l10n.chatInboxUnreadSemantics(item.unreadCount),
      if (item.isMuted) l10n.chatInboxMutedSemantics,
      preview,
    ];
    return parts.join(', ');
  }

  static String _relativeTime(
    BuildContext context,
    DateTime atUtc,
    DateTime nowUtc,
  ) {
    final l10n = context.l10n;
    final at = atUtc.toLocal();
    final now = nowUtc.toLocal();
    final difference = now.difference(at);
    if (difference.inMinutes < 1) return l10n.chatInboxTimeNow;
    if (difference.inHours < 1) return l10n.chatInboxTimeMinutes(difference.inMinutes);
    if (difference.inDays < 1) return l10n.chatInboxTimeHours(difference.inHours);
    if (difference.inDays < 7) return l10n.chatInboxTimeDays(difference.inDays);
    return '${at.day.toString().padLeft(2, '0')}.${at.month.toString().padLeft(2, '0')}';
  }
}

class _ChatInboxAvatar extends StatelessWidget {
  const _ChatInboxAvatar({required this.item});

  final ChatInboxItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = item.otherParticipants
        .map((participant) => participant.avatarUrl)
        .firstWhere((value) => value != null && value.isNotEmpty, orElse: () => null);
    final initials = _initials(item.displayName);
    return Container(
      width: ChatInboxRow.avatarSize,
      height: ChatInboxRow.avatarSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: url == null
          ? Text(
              initials,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : Image.network(
              url,
              width: ChatInboxRow.avatarSize,
              height: ChatInboxRow.avatarSize,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Text(
                initials,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
    );
  }

  static String _initials(String label) {
    final words = label
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .toList(growable: false);
    if (words.isEmpty) return '?';
    return words.map((word) => word.characters.first.toUpperCase()).join();
  }
}

/// Krótka etykieta stanu wiersza, np. „Szkic”.
class _ChatInboxLabel extends StatelessWidget {
  const _ChatInboxLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p6, vertical: 1),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ChatUnreadBadge extends StatelessWidget {
  const _ChatUnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
