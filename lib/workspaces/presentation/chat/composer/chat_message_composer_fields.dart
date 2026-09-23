import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:material_symbols_icons/symbols.dart';

/// Pole rich text rozmowy; kontrolery pozostają własnością composera.
final class ChatComposerRichTextField extends StatelessWidget {
  const ChatComposerRichTextField({
    required this.controller,
    required this.focusNode,
    required this.scrollController,
    required this.onKeyEvent,
    required this.maxHeight,
    super.key,
  });

  final quill.QuillController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final FocusOnKeyEventCallback onKeyEvent;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final bodyStyle = chat.contentStyle.copyWith(color: chat.incomingText);
    final blockStyle = quill.DefaultTextBlockStyle(
      bodyStyle,
      quill.HorizontalSpacing.zero,
      quill.VerticalSpacing.zero,
      quill.VerticalSpacing.zero,
      null,
    );
    final customStyles = quill.DefaultStyles(
      paragraph: blockStyle,
      bold: const TextStyle(fontWeight: FontWeight.w900),
      link: TextStyle(
        color: chat.linkText,
        decoration: TextDecoration.underline,
      ),
      inlineCode: quill.InlineCodeStyle(
        style: chat.monospaceStyle.copyWith(color: chat.incomingText),
        backgroundColor: chat.codeSurface,
        radius: const Radius.circular(4),
      ),
      lists: quill.DefaultListBlockStyle(
        bodyStyle,
        quill.HorizontalSpacing.zero,
        quill.VerticalSpacing.zero,
        quill.VerticalSpacing.zero,
        null,
        null,
      ),
      quote: quill.DefaultTextBlockStyle(
        bodyStyle,
        quill.HorizontalSpacing.zero,
        const quill.VerticalSpacing(4, 4),
        quill.VerticalSpacing.zero,
        BoxDecoration(
          color: chat.hoverSurface,
          border: Border(left: BorderSide(color: chat.focusRing, width: 3)),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
      ),
      code: quill.DefaultTextBlockStyle(
        chat.monospaceStyle.copyWith(
          color: chat.incomingText,
          backgroundColor: chat.codeSurface,
        ),
        quill.HorizontalSpacing.zero,
        const quill.VerticalSpacing(2, 2),
        quill.VerticalSpacing.zero,
        null,
      ),
    );
    return SizedBox(
      height: maxHeight,
      child: Focus(
        onKeyEvent: onKeyEvent,
        child: quill.QuillEditor(
          controller: controller,
          focusNode: focusNode,
          scrollController: scrollController,
          config: quill.QuillEditorConfig(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p8,
              vertical: Sizes.p10,
            ),
            expands: true,
            customStyles: customStyles,
          ),
        ),
      ),
    );
  }
}

/// Widoczny kontekst odpowiedzi wraz z akcją rezygnacji.
final class ChatComposerReplyTarget extends StatelessWidget {
  const ChatComposerReplyTarget({
    required this.message,
    required this.replyId,
    required this.onCancel,
    super.key,
  });

  final ChatMessage? message;
  final String replyId;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: chat.selectedSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: chat.separator),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: Sizes.p8, right: Sizes.p4),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 30,
                decoration: BoxDecoration(
                  color: chat.focusRing,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: Sizes.p8),
              Expanded(
                child: Text(
                  context.l10n.chatComposerReplyTo(
                    message?.text.trim().isNotEmpty == true
                        ? message!.text
                        : replyId,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: chat.metadataStyle.copyWith(
                    color: chat.incomingText,
                  ),
                ),
              ),
              IconButton(
                tooltip: context.l10n.chatComposerCancelReply,
                onPressed: onCancel,
                color: chat.metadataText,
                icon: const Icon(Symbols.close_rounded, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Przycisk wysyłki blokowany przez kolejkę załączników do czasu skanowania.
final class ChatComposerSubmitButton extends StatelessWidget {
  const ChatComposerSubmitButton({
    required this.coordinator,
    required this.canSubmit,
    required this.onSubmit,
    super.key,
  });

  final ChatAttachmentComposerCoordinatorCubit? coordinator;
  final bool Function(ChatAttachmentComposerCoordinatorState? state) canSubmit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: switch (coordinator) {
        final current? =>
          BlocBuilder<
            ChatAttachmentComposerCoordinatorCubit,
            ChatAttachmentComposerCoordinatorState
          >(
            bloc: current,
            builder: (_, state) => _sendButton(
              context,
              isEnabled: canSubmit(state),
            ),
          ),
        null => _sendButton(context, isEnabled: canSubmit(null)),
      },
    );
  }

  Widget _sendButton(BuildContext context, {required bool isEnabled}) {
    final chat = context.chatTheme;
    return Tooltip(
      message: context.l10n.globalChatSendMessage,
      child: Material(
        color: isEnabled
            ? chat.sendButtonSurface
            : chat.sendButtonSurface.withValues(alpha: .45),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: isEnabled ? onSubmit : null,
          customBorder: const CircleBorder(),
          child: Semantics(
            button: true,
            enabled: isEnabled,
            label: context.l10n.globalChatSendMessage,
            child: SizedBox.square(
              dimension: chat.composerActionSize,
              child: Icon(
                Symbols.send_rounded,
                size: chat.composerIconSize,
                color: chat.sendButtonForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
