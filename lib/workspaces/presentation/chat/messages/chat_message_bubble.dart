import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_message_attachments.dart';
import 'package:devplanner/workspaces/presentation/chat/links/chat_link_preview_card.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_display_policy.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_grouping.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_metadata.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_conversation_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_rich_text_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Pozycja dymka w zwartej serii jednego nadawcy.
enum ChatMessageSeriesPosition { standalone, first, middle, last }

/// Dymek jednej wiadomości: treść, załączniki, reakcje i metadane.
///
/// Dymek nie zna rozmowy ani cubitów: dostaje gotowe akcje i sam decyduje
/// wyłącznie o układzie. Menu jest nakładką ujawnianą na hover lub fokus, więc
/// jego otwarcie nie zmienia szerokości ani wysokości dymka.
class ChatMessageBubble extends StatefulWidget {
  /// Tworzy dymek wiadomości.
  const ChatMessageBubble({
    required this.message,
    required this.isOwn,
    required this.maxWidth,
    this.seriesPosition = ChatMessageSeriesPosition.standalone,
    this.authorLabel,
    this.replyTarget,
    this.replyTargetAuthorLabel,
    this.onOpenReplyTarget,
    this.showAuthor = false,
    this.menu,
    this.reactions,
    this.onRetry,
    this.onPickReaction,
    this.onContextMenu,
    this.highlighted = false,
    super.key,
  });

  final ChatMessage message;

  /// Czy wiadomość należy do bieżącej sesji; własne dymki idą na prawo.
  final bool isOwn;

  /// Limit szerokości dymka wyliczony z szerokości historii.
  final double maxWidth;

  /// Używa małego narożnika wyłącznie na krawędzi łączącej dymki serii.
  final ChatMessageSeriesPosition seriesPosition;

  /// Etykieta autora; `null` nie pokazuje nazwy.
  final String? authorLabel;

  /// Oryginalna wiadomość cytowana przez tę odpowiedź, jeśli jest w załadowanej historii.
  final ChatMessage? replyTarget;

  /// Nazwa autora cytowanej wiadomości, jeśli katalog uczestników ją udostępnia.
  final String? replyTargetAuthorLabel;

  /// Otwiera cytowaną wiadomość w historii.
  final ValueChanged<String>? onOpenReplyTarget;

  /// Czy pokazać nazwę autora (pierwszy dymek serii w grupie).
  final bool showAuthor;

  /// Menu `…` pokazywane na hover albo fokus.
  final Widget? menu;

  /// Pasek reakcji pod treścią; brak oznacza brak reakcji.
  final Widget? reactions;

  /// Ponowienie wysyłki własnej wiadomości; brak ukrywa akcję.
  final VoidCallback? onRetry;

  /// Otwiera wybór reakcji z nakładki na hover; brak ukrywa przycisk.
  final VoidCallback? onPickReaction;

  /// Otwiera menu wiadomości w pozycji prawego kliknięcia lub długiego tapu.
  final ValueChanged<Offset>? onContextMenu;

  /// Czy dymek jest celem skoku z wyszukiwania.
  final bool highlighted;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  bool _hovered = false;
  bool _focused = false;
  bool _expanded = false;

  bool get _menuVisible => _hovered || _focused;

  /// Czy wiadomość ma więcej linii, niż mieści zwinięty dymek.
  bool get _collapsible => ChatMessageDisplayPolicy.shouldCollapse(
    widget.message.displayText ?? widget.message.text,
  );

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final message = widget.message;
    final displayText = message.displayText ?? message.text;
    final contentColor = widget.isOwn ? chat.outgoingText : chat.incomingText;
    final author = widget.authorLabel?.trim();
    final showAuthor = widget.showAuthor && author != null && author.isNotEmpty;
    final menu = widget.menu;
    final menuOverlay = menu == null
        ? null
        : Focus(
            onFocusChange: (value) => setState(() => _focused = value),
            child: menu,
          );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapUp: (details) =>
          widget.onContextMenu?.call(details.globalPosition),
      onLongPressStart: (details) =>
          widget.onContextMenu?.call(details.globalPosition),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxWidth),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.isOwn
                      ? chat.outgoingBubble
                      : chat.incomingBubble,
                  borderRadius: _seriesBorderRadius(
                    chat.bubbleRadius,
                    widget.isOwn,
                    widget.seriesPosition,
                  ),
                  border: widget.highlighted
                      ? Border.all(color: chat.focusRing, width: 1.2)
                      : null,
                ),
                child: Padding(
                  padding: chat.bubblePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showAuthor) ...[
                        Text(
                          author,
                          style: chat.authorStyle.copyWith(
                            color: chat.metadataText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Sizes.p4),
                      ],
                      if (message.replyToMessageId != null) ...[
                        _ReplyPreview(
                          targetId: message.replyToMessageId!,
                          target: widget.replyTarget,
                          authorLabel: widget.replyTargetAuthorLabel,
                          onTap: widget.onOpenReplyTarget,
                        ),
                        const SizedBox(height: Sizes.p8),
                      ],
                      if (message.isDeleted)
                        Text(
                          context.l10n.globalChatDeletedMessage,
                          style: chat.contentStyle.copyWith(
                            color: chat.metadataText,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else if (_collapsible && !_expanded)
                        // Zwinięty podgląd jest jawny: użytkownik widzi, że treść
                        // jest dłuższa, i ma przycisk pełnej wersji.
                        Text(
                          displayText,
                          maxLines:
                              ChatMessageDisplayPolicy.collapseLineThreshold,
                          overflow: TextOverflow.ellipsis,
                          style: chat.contentStyle.copyWith(
                            color: contentColor,
                          ),
                        )
                      else
                        ChatRichTextBody(
                          text: displayText,
                          deltaJson: message.deltaJson,
                          links: message.links,
                          style: chat.contentStyle.copyWith(
                            color: contentColor,
                          ),
                        ),
                      if (!message.isDeleted)
                        for (final link
                            in message.links
                                .where(
                                  (link) =>
                                      link.previewAllowed && !link.isInternal,
                                )
                                .take(1))
                          ChatLinkPreviewCard(
                            key: ValueKey(
                              'chat-link-preview:${message.id}:${link.url}',
                            ),
                            conversationId: message.conversationId,
                            link: link,
                          ),
                      if (_collapsible && !message.isDeleted)
                        TextButton(
                          onPressed: () =>
                              setState(() => _expanded = !_expanded),
                          child: Text(
                            _expanded
                                ? context.l10n.chatRichTextShowLess
                                : context.l10n.chatRichTextShowMore,
                          ),
                        ),
                      if (!message.isDeleted)
                        ChatMessageAttachments(
                          attachments: message.attachments,
                        ),
                      if (!message.isDeleted && widget.reactions != null) ...[
                        const SizedBox(height: Sizes.p4),
                        widget.reactions!,
                      ],
                      _BubbleFooter(
                        message: message,
                        isOwn: widget.isOwn,
                        onRetry: widget.onRetry,
                      ),
                    ],
                  ),
                ),
              ),
              if (menuOverlay != null || widget.onPickReaction != null)
                Positioned(
                  top: -Sizes.p8,
                  right: widget.isOwn ? null : -Sizes.p8,
                  left: widget.isOwn ? -Sizes.p8 : null,
                  child: AnimatedOpacity(
                    opacity: _menuVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 120),
                    child: IgnorePointer(
                      ignoring: !_menuVisible,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: chat.panelSurface,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(color: chat.separator),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.onPickReaction case final pick?)
                              SizedBox.square(
                                dimension: 36,
                                child: IconButton(
                                  key: const ValueKey('chat-bubble-react'),
                                  onPressed: pick,
                                  tooltip: context.l10n.chatReactionAdd,
                                  padding: EdgeInsets.zero,
                                  iconSize: 18,
                                  color: chat.metadataText,
                                  icon: const Icon(Symbols.add_reaction),
                                ),
                              ),
                            ?menuOverlay,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  BorderRadius _seriesBorderRadius(
    double radius,
    bool isOwn,
    ChatMessageSeriesPosition position,
  ) {
    if (position == ChatMessageSeriesPosition.standalone) {
      return BorderRadius.circular(radius);
    }
    final joinedRadius = radius * .38;
    final isFirst = position == ChatMessageSeriesPosition.first;
    final isLast = position == ChatMessageSeriesPosition.last;
    if (isOwn) {
      return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(isFirst ? radius : joinedRadius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(isLast ? radius : joinedRadius),
      );
    }
    return BorderRadius.only(
      topLeft: Radius.circular(isFirst ? radius : joinedRadius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(isLast ? radius : joinedRadius),
      bottomRight: Radius.circular(radius),
    );
  }
}

/// Cytat widoczny w dymku odpowiedzi, niezależny od treści samej odpowiedzi.
final class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview({
    required this.targetId,
    required this.target,
    this.authorLabel,
    this.onTap,
  });

  final String targetId;
  final ChatMessage? target;
  final String? authorLabel;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final target = this.target;
    final author = authorLabel?.trim();
    final quotedText = target == null
        ? context.l10n.chatReplyOriginalUnavailable
        : target.isDeleted
        ? context.l10n.globalChatDeletedMessage
        : target.text.trim().isEmpty
        ? context.l10n.chatMessageCopy
        : target.text.trim();
    final heading = author?.isNotEmpty == true
        ? context.l10n.chatComposerReplyTo(author!)
        : context.l10n.chatComposerReplyTo(quotedText);

    return Material(
      color: chat.panelSurface.withValues(alpha: .72),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap == null ? null : () => onTap!(targetId),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p8,
            vertical: Sizes.p6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(color: chat.focusRing, width: 3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                heading,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: chat.metadataStyle.copyWith(
                  color: chat.focusRing,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (author?.isNotEmpty == true && target != null) ...[
                const SizedBox(height: Sizes.p2),
                Text(
                  quotedText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: chat.metadataStyle.copyWith(color: chat.metadataText),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Stopka dymka: godzina, znacznik edycji i status dostawy.
///
/// Status pochodzi wyłącznie z potwierdzenia serwera albo kolejki wysyłki;
/// brak potwierdzenia nie jest przedstawiany jako dostarczenie.
class _BubbleFooter extends StatelessWidget {
  const _BubbleFooter({
    required this.message,
    required this.isOwn,
    this.onRetry,
  });

  final ChatMessage message;
  final bool isOwn;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final muted = chat.metadataStyle.copyWith(color: chat.metadataText);
    final status = ChatMessageMetadata.statusFor(
      message: message,
      isOwn: isOwn,
    );
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.p4),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Sizes.p4,
        children: [
          Text(
            ChatMessageMetadata.timeLabel(message.createdAtUtc),
            style: muted,
          ),
          if (message.isEdited)
            Text(context.l10n.chatMessageEdited, style: muted),
          if (status != null)
            _StatusGlyph(kind: status.kind, count: status.count, style: muted),
          if (status != null && status.canRetry && onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.chatMessageRetry),
            ),
        ],
      ),
    );
  }
}

/// Ikona i etykieta statusu wysyłki.
class _StatusGlyph extends StatelessWidget {
  const _StatusGlyph({required this.kind, this.count = 0, this.style});

  final ChatMessageStatusKind kind;

  /// Liczba potwierdzonych odbiorców dla statusów dostawy i odczytu.
  final int count;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final (icon, label) = switch (kind) {
      ChatMessageStatusKind.sending => (
        Symbols.schedule,
        context.l10n.chatMessageStatusSending,
      ),
      ChatMessageStatusKind.sent => (
        Symbols.check,
        context.l10n.chatMessageStatusSent,
      ),
      ChatMessageStatusKind.delivered => (
        Symbols.done_all,
        context.l10n.chatMessageStatusDelivered(count),
      ),
      ChatMessageStatusKind.read => (
        Symbols.done_all,
        context.l10n.chatMessageStatusRead(count),
      ),
      ChatMessageStatusKind.failed => (
        Symbols.error_outline,
        context.l10n.chatMessageStatusFailed,
      ),
    };
    final color = switch (kind) {
      ChatMessageStatusKind.failed => chat.error,
      ChatMessageStatusKind.read => chat.deliveryRead,
      _ => chat.metadataText,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: Sizes.p4),
        Text(label, style: style?.copyWith(color: color)),
      ],
    );
  }
}

/// Seria dymków jednego autora z awatarem i nazwą tylko na jej początku.
class ChatMessageSeriesView extends StatelessWidget {
  const ChatMessageSeriesView({
    required this.series,
    required this.maxWidth,
    this.authorLabel,
    this.authorAvatarUrl,
    this.showIdentity = false,
    this.compact = false,
    this.bubbleBuilder,
    super.key,
  });

  final ChatMessageSeries series;

  /// Limit szerokości dymka w tej historii.
  final double maxWidth;

  /// Etykieta autora serii z katalogu; brak ukrywa tożsamość.
  final String? authorLabel;

  /// Zdjęcie profilu autora z katalogu uczestników.
  final String? authorAvatarUrl;

  /// Czy pokazać awatar i nazwę (grupa/kanał); w DM tożsamość jest w nagłówku.
  final bool showIdentity;

  /// Tryb compact: mniejszy gutter historii.
  final bool compact;

  /// Buduje dymek dla wiadomości serii; panel dostarcza menu i reakcje.
  final Widget Function(
    ChatMessage message,
    bool isFirstInSeries,
    ChatMessageSeriesPosition position,
  )?
  bubbleBuilder;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final label = authorLabel?.trim();
    final showIdentityHere =
        showIdentity &&
        !series.isOwnAuthor &&
        label != null &&
        label.isNotEmpty;
    final avatarSize = chat.avatarBubble;
    final bubbles = <Widget>[
      for (var index = 0; index < series.messages.length; index++) ...[
        if (index > 0) SizedBox(height: chat.seriesGap),
        (bubbleBuilder ?? _defaultBubble)(
          series.messages[index],
          index == 0,
          series.messages.length == 1
              ? ChatMessageSeriesPosition.standalone
              : index == 0
              ? ChatMessageSeriesPosition.first
              : index == series.messages.length - 1
              ? ChatMessageSeriesPosition.last
              : ChatMessageSeriesPosition.middle,
        ),
      ],
    ];
    return Padding(
      padding: EdgeInsets.only(top: chat.authorGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: series.isOwnAuthor
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!series.isOwnAuthor) ...[
            if (showIdentityHere)
              _ChatAuthorAvatar(
                userId: series.authorUserId,
                displayName: label,
                avatarUrl: authorAvatarUrl,
                size: avatarSize,
              )
            else
              SizedBox(width: avatarSize),
            SizedBox(width: chat.seriesGap + Sizes.p4),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: series.isOwnAuthor
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: bubbles,
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultBubble(
    ChatMessage message,
    bool isFirst,
    ChatMessageSeriesPosition position,
  ) => ChatMessageBubble(
    message: message,
    isOwn: series.isOwnAuthor,
    maxWidth: maxWidth,
    seriesPosition: position,
    authorLabel: authorLabel,
    showAuthor: isFirst,
  );
}

/// Awatar autora w grupie z obecnością potwierdzoną snapshotem rozmowy.
class _ChatAuthorAvatar extends StatelessWidget {
  const _ChatAuthorAvatar({
    required this.userId,
    required this.displayName,
    required this.size,
    this.avatarUrl,
  });

  final String userId;
  final String displayName;
  final String? avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final presence = context
        .select<ChatConversationPresenceCubit?, ChatPeerLivePresence>(
          (cubit) =>
              cubit?.state.forUser(userId) ?? ChatPeerLivePresence.unknown,
        );
    final chat = context.chatTheme;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AppUserAvatar(
              userId: userId,
              displayName: displayName,
              avatarUrl: avatarUrl,
              hasCustomAvatar: avatarUrl?.trim().isNotEmpty == true,
              radius: size / 2,
              singleInitial: true,
              semanticsLabel: displayName,
            ),
          ),
          if (presence == ChatPeerLivePresence.online)
            Positioned(
              right: -1,
              bottom: -1,
              child: Tooltip(
                message: context.l10n.chatPeerOnline,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: chat.presenceOnline,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: chat.conversationSurface,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
