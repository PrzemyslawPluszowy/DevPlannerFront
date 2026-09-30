import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:flutter/material.dart';

/// Cytat widoczny w dymku odpowiedzi, niezależny od treści samej odpowiedzi.
final class ChatMessageReplyPreview extends StatelessWidget {
  const ChatMessageReplyPreview({
    required this.targetId,
    required this.target,
    this.preview,
    this.authorLabel,
    this.onTap,
    super.key,
  });

  final String targetId;
  final ChatMessage? target;
  final ChatMessageReplyTargetPreview? preview;
  final String? authorLabel;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final target = this.target;
    final preview = this.preview;
    final suppliedAuthor = authorLabel?.trim();
    final snapshotAuthor = preview?.authorLabel?.trim();
    final author = suppliedAuthor?.isNotEmpty == true
        ? suppliedAuthor
        : snapshotAuthor?.isNotEmpty == true
        ? snapshotAuthor
        : null;
    final isDeleted = target?.isDeleted ?? preview?.isDeleted ?? false;
    final sourceText = target?.text ?? preview?.text;
    final mentionLabels = target?.mentionLabels ?? preview?.mentionLabels;
    final hasAttachments =
        target?.attachments.isNotEmpty ?? preview?.hasAttachments ?? false;
    final quotedText = isDeleted
        ? context.l10n.globalChatDeletedMessage
        : sourceText?.trim().isNotEmpty == true
        ? ChatMentionCodec.renderText(
            sourceText!.trim(),
            mentionLabels ?? const <String, String>{},
            fallbackLabel: context.l10n.chatMentionUnknownMember,
          )
        : hasAttachments
        ? context.l10n.chatReplyContainsAttachment
        : context.l10n.chatReplyOriginalUnavailable;
    final heading = author?.isNotEmpty == true
        ? context.l10n.chatComposerReplyTo(author!)
        : context.l10n.chatReplyGenericHeading;

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
              if (target != null || preview != null) ...[
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
