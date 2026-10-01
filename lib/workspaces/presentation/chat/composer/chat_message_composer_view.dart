import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_controls.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_editor_controller.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_height_policy.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_paste_controller.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_rich_toolbar.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_surface.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_long_paste_card.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_long_paste_decision.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer_fields.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_state.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/mentions/chat_mention_suggestions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Renderuje composera na podstawie kontrolerów należących do jego State.
///
/// Widok nie tworzy Cubitów ani kontrolerów. Akcje wyboru pliku deleguje do
/// właściciela composera, który zarządza ich lifecycle i uploadem.
final class ChatMessageComposerView extends StatelessWidget {
  const ChatMessageComposerView({
    required this.composer,
    required this.state,
    required this.editor,
    required this.paste,
    required this.attachmentCoordinator,
    required this.editorFocused,
    required this.onFocusChanged,
    required this.onTypingChanged,
    required this.onSubmit,
    required this.onCancelReply,
    required this.onSendDraftAsFile,
    required this.onKeepPendingPasteAsText,
    required this.onDiscardPendingPaste,
    required this.onSendPendingPasteAsFile,
    required this.onPickImages,
    required this.onPickFiles,
    required this.onPickPrivateFiles,
    super.key,
  });

  final ChatMessageComposer composer;
  final ChatComposerState state;
  final ChatComposerEditorController editor;
  final ChatComposerPasteController paste;
  final ChatAttachmentComposerCoordinatorCubit? attachmentCoordinator;
  final bool editorFocused;
  final ValueChanged<bool> onFocusChanged;
  final ValueChanged<String> onTypingChanged;
  final VoidCallback onSubmit;
  final VoidCallback onCancelReply;
  final VoidCallback onSendDraftAsFile;
  final Future<void> Function() onKeepPendingPasteAsText;
  final Future<void> Function() onDiscardPendingPaste;
  final Future<void> Function() onSendPendingPasteAsFile;
  final Future<void> Function() onPickImages;
  final Future<void> Function() onPickFiles;
  final Future<void> Function() onPickPrivateFiles;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final chat = context.chatTheme;
      final editorMaxHeight = ChatComposerHeightPolicy.maxEditorHeight(
        availableConversationHeight: constraints.maxHeight,
        themeMaxHeight: chat.composerMaxHeight,
      );
      final coordinator = attachmentCoordinator;
      final composerBody = Padding(
        padding: EdgeInsets.fromLTRB(
          composer.compact ? chat.compactHistoryGutter : chat.historyGutter,
          Sizes.p8,
          composer.compact ? chat.compactHistoryGutter : chat.historyGutter,
          Sizes.p8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.draft.replyToMessageId case final replyId?)
              ChatComposerReplyTarget(
                message: composer.replyTarget,
                replyId: replyId,
                onCancel: onCancelReply,
              ),
            if (state.mode == ChatComposerMode.plainText)
              if (editor.mentionController?.picker case final picker?)
                ChatMentionSuggestions(
                  controller: picker,
                  onSelected: editor.acceptMention,
                  onSelectAll: composer.mentionAllEnabled
                      ? editor.acceptAllMention
                      : null,
                ),
            if (paste.pendingPaste case final assessment?)
              ChatLongPasteCard(
                assessment: assessment,
                fileName: ChatComposerPasteController.snippetFileName,
                busy: paste.isPreparing,
                failureMessage: paste.pendingPasteFailure,
                notice: paste.pendingPasteNotice,
                onSendAsFile: coordinator == null
                    ? null
                    : () => unawaited(onSendPendingPasteAsFile()),
                onKeepAsText: assessment.kind == ChatLongPasteKind.overLimit
                    ? null
                    : onKeepPendingPasteAsText,
                onCancel: () => unawaited(onDiscardPendingPaste()),
              ),
            if (coordinator != null)
              ChatAttachmentComposerControls(
                coordinator: coordinator,
                conversationId: composer.conversationId,
              ),
            if (state.mode == ChatComposerMode.richText)
              ChatComposerRichToolbar(controller: editor.richController),
            Focus(
              onFocusChange: onFocusChanged,
              child: ChatComposerSurface(
                focused: editorFocused,
                desktopWebStyle: composer.desktopWebStyle,
                moreActions: ChatComposerMoreMenu(
                  expandedEditor: state.mode == ChatComposerMode.richText,
                  onToggleExpandedEditor: editor.toggleExpandedEditor,
                  onInsertCode: editor.insertCode,
                  onTextAsFile: coordinator == null ? null : onSendDraftAsFile,
                  onPickImage:
                      coordinator == null ||
                          composer.filePickerPort is! ConstrainedFilePickerPort
                      ? null
                      : () => unawaited(onPickImages()),
                  onPickFile:
                      coordinator == null ||
                          composer.filePickerPort is! ConstrainedFilePickerPort
                      ? null
                      : () => unawaited(onPickFiles()),
                  onPickPrivateFile: coordinator == null
                      ? null
                      : () => unawaited(onPickPrivateFiles()),
                ),
                editor: AppContextMenuRegion(
                  actionsBuilder: editor.editorMenuActions,
                  child: Actions(
                    actions: <Type, Action<Intent>>{
                      PasteTextIntent: CallbackAction<PasteTextIntent>(
                        onInvoke: (_) {
                          unawaited(paste.handlePaste());
                          return null;
                        },
                      ),
                    },
                    child: state.mode == ChatComposerMode.plainText
                        ? Focus(
                            onKeyEvent: editor.onEnterKey,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: editorMaxHeight,
                              ),
                              child: TextField(
                                controller: editor.plainController,
                                focusNode: editor.plainFocusNode,
                                minLines: chat.composerMinLines,
                                maxLines: chat.composerMaxLines,
                                onChanged: (value) {
                                  onTypingChanged(value);
                                  editor.updatePlainText(value);
                                },
                                decoration: InputDecoration(
                                  hintText: context.l10n.globalChatComposerHint,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: Sizes.p10,
                                  ),
                                ),
                                style: chat.contentStyle.copyWith(
                                  color: chat.incomingText,
                                ),
                              ),
                            ),
                          )
                        : ChatComposerRichTextField(
                            controller: editor.richController,
                            focusNode: editor.richFocusNode,
                            scrollController: editor.richScrollController,
                            onKeyEvent: editor.onEnterKey,
                            maxHeight: editorMaxHeight,
                          ),
                  ),
                ),
                trailingActions: context.read<ChatEmojiRecentCubit?>() == null
                    ? null
                    : ChatComposerActionButton(
                        key: editor.emojiAnchorKey,
                        icon: Symbols.emoji_emotions_rounded,
                        tooltip: context.l10n.chatComposerEmoji,
                        onPressed: () => unawaited(
                          editor.pickEmoji(
                            context.read<ChatEmojiRecentCubit?>(),
                          ),
                        ),
                      ),
                send: ChatComposerSubmitButton(
                  coordinator: coordinator,
                  canSubmit: (attachmentState) => _canSubmit(
                    state,
                    attachmentState,
                    paste.isPreparing,
                  ),
                  onSubmit: onSubmit,
                  desktopWebStyle: composer.desktopWebStyle,
                ),
              ),
            ),
          ],
        ),
      );

      return coordinator == null
          ? composerBody
          : ChatAttachmentDropRegion(
              coordinator: coordinator,
              conversationId: composer.conversationId,
              child: composerBody,
            );
    },
  );

  static bool _canSubmit(
    ChatComposerState state,
    Object? attachmentState,
    bool isPreparingPaste,
  ) {
    final uploadReady =
        attachmentState is! ChatAttachmentComposerCoordinatorPreparing &&
        attachmentState is! ChatAttachmentComposerCoordinatorFailed &&
        attachmentState
            is! ChatAttachmentComposerCoordinatorAwaitingConfirmation;
    if (!uploadReady) return false;
    final readyAttachments =
        attachmentState is ChatAttachmentComposerCoordinatorReady;
    return !isPreparingPaste &&
        (!state.draft.isEmpty ||
            (readyAttachments && attachmentState.attachmentIds.isNotEmpty));
  }
}
