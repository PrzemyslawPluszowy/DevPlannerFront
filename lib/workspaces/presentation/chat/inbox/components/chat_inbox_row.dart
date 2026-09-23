import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_timestamp_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.actionsBuilder,
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

  /// Akcje menu kontekstowego dla tego wiersza; brak wyłącza menu.
  final List<AppContextMenuAction> Function(BuildContext context)?
  actionsBuilder;

  /// Czy wiersz jest aktualnie otwartą rozmową.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final unread = item.hasUnread;
    final preview = _previewText(context);
    final builder = actionsBuilder;

    return Semantics(
      button: true,
      selected: selected,
      label: _semanticsLabel(context, preview),
      child: Focus(
        onKeyEvent: builder == null
            ? null
            : (node, event) {
                if (event is! KeyDownEvent) return KeyEventResult.ignored;
                final isContextMenu =
                    event.logicalKey == LogicalKeyboardKey.contextMenu ||
                    (event.logicalKey == LogicalKeyboardKey.f10 &&
                        HardwareKeyboard.instance.isShiftPressed);
                if (!isContextMenu) return KeyEventResult.ignored;
                unawaited(
                  _openMenu(
                    context,
                    builder,
                    AppContextMenu.positionFor(context),
                  ),
                );
                return KeyEventResult.handled;
              },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onSecondaryTapDown: builder == null
              ? null
              : (details) => unawaited(
                  _openMenu(context, builder, details.globalPosition),
                ),
          child: Material(
            color: selected
                ? context.chatTheme.selectedSurface
                : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: InkWell(
              onTap: onTap == null ? null : () => onTap!(item),
              onLongPress: builder == null
                  ? null
                  : () => unawaited(
                      _openMenu(
                        context,
                        builder,
                        AppContextMenu.positionFor(context),
                      ),
                    ),
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
                                    style: chat.contentStyle.copyWith(
                                      fontSize: 14,
                                      color: chat.incomingText,
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
                                  style: chat.metadataStyle.copyWith(
                                    color: chat.metadataText,
                                  ),
                                ),
                                if (builder != null)
                                  Builder(
                                    builder: (anchorContext) => IconButton(
                                      key: ValueKey<String>(
                                        'chat-inbox-row-actions-${item.conversation.id}',
                                      ),
                                      tooltip: context
                                          .l10n
                                          .chatInboxRowActionsTooltip,
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      constraints:
                                          const BoxConstraints.tightFor(
                                            width: 30,
                                            height: 30,
                                          ),
                                      onPressed: () => unawaited(
                                        _openMenu(
                                          context,
                                          builder,
                                          AppContextMenu.positionFor(
                                            anchorContext,
                                          ),
                                        ),
                                      ),
                                      icon: Icon(
                                        Symbols.more_horiz,
                                        size: 18,
                                        color: chat.metadataText,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: Sizes.p4),
                            Row(
                              children: [
                                if (item.isDraft) ...[
                                  _ChatInboxLabel(
                                    text: context.l10n.chatInboxDraftLabel,
                                  ),
                                  const SizedBox(width: Sizes.p6),
                                ],
                                if (item.isMuted) ...[
                                  Icon(
                                    Symbols.volume_off,
                                    size: 14,
                                    color: chat.metadataText,
                                  ),
                                  const SizedBox(width: Sizes.p4),
                                ],
                                Expanded(
                                  child: Text(
                                    preview,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: chat.metadataStyle.copyWith(
                                      color: chat.metadataText,
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
        ),
      ),
    );
  }

  /// Prefiks autora w podglądzie grupy lub kanału.
  ///
  /// W rozmowie 1:1 autor jest oczywisty, a w grupie podgląd bez autora myli
  /// własną wiadomość z cudzą, dlatego podgląd dostaje nazwę nadawcy z listy
  /// uczestników zwróconej przez serwer.
  /// Otwiera menu przy wierszu; używane przez długie przytrzymanie.
  Future<void> _openMenu(
    BuildContext context,
    List<AppContextMenuAction> Function(BuildContext context) builder,
    Offset globalPosition,
  ) {
    final actions = builder(context);
    if (actions.isEmpty) return Future<void>.value();
    return AppContextMenu.show(
      context,
      globalPosition: globalPosition,
      actions: actions,
      headerTitle: item.displayName,
    );
  }

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
    return ChatTimestampFormatter.relativeLabel(
      l10n: context.l10n,
      atUtc: atUtc,
      nowUtc: nowUtc,
      locale: Localizations.localeOf(context),
    );
  }
}

class _ChatInboxAvatar extends StatelessWidget {
  const _ChatInboxAvatar({required this.item});

  final ChatInboxItem item;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    if (item.conversation.type == 'direct') {
      final person = item.otherParticipants.firstOrNull;
      return AppUserAvatar(
        userId: person?.userId,
        displayName: person?.label ?? item.displayName,
        avatarUrl: person?.avatarUrl,
        hasCustomAvatar: person?.avatarUrl?.trim().isNotEmpty == true,
        radius: ChatInboxRow.avatarSize / 2,
        singleInitial: true,
      );
    }
    final icon = switch (item.conversation.type) {
      'channel' => Symbols.campaign_rounded,
      'broadcast' => Symbols.campaign_rounded,
      _ => Symbols.group_rounded,
    };
    return CircleAvatar(
      radius: ChatInboxRow.avatarSize / 2,
      backgroundColor: chat.selectedSurface,
      child: Icon(icon, size: 22, color: chat.linkText),
    );
  }
}

/// Krótka etykieta stanu wiersza, np. „Szkic”.
class _ChatInboxLabel extends StatelessWidget {
  const _ChatInboxLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p6, vertical: 1),
      decoration: BoxDecoration(
        color: chat.mentionSurface,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        text,
        style: chat.metadataStyle.copyWith(
          color: chat.mentionText,
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
    final chat = context.chatTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p6, vertical: 2),
      decoration: BoxDecoration(
        color: chat.sendButtonSurface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: chat.metadataStyle.copyWith(
          color: chat.sendButtonForeground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
