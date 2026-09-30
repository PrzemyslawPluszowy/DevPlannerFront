import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_message_attachments.dart';
import 'package:devplanner/workspaces/presentation/chat/links/chat_link_preview_card.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_display_policy.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_footer.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_reply_preview.dart';
import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_rich_text_body.dart';
import 'package:flutter/material.dart';
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
  final ValueChanged<Offset>? onPickReaction;

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
                        ChatMessageReplyPreview(
                          targetId: message.replyToMessageId!,
                          target: widget.replyTarget,
                          preview: message.replyPreview,
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
                          ChatMentionCodec.renderText(
                            displayText,
                            message.mentionLabels,
                            fallbackLabel:
                                context.l10n.chatMentionUnknownMember,
                          ),
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
                          mentionLabels: message.mentionLabels,
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
                      ChatMessageFooter(
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
                                child: Builder(
                                  builder: (buttonContext) => IconButton(
                                    key: const ValueKey('chat-bubble-react'),
                                    onPressed: () => pick(
                                      AppContextMenu.positionFor(buttonContext),
                                    ),
                                    tooltip: context.l10n.chatReactionAdd,
                                    padding: EdgeInsets.zero,
                                    iconSize: 18,
                                    color: chat.metadataText,
                                    icon: const Icon(Symbols.add_reaction),
                                  ),
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
