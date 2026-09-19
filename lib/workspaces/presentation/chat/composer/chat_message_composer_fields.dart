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
    required this.compact,
    super.key,
  });

  final quill.QuillController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final FocusOnKeyEventCallback onKeyEvent;
  final bool compact;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: compact ? 110 : 144,
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Focus(
        onKeyEvent: onKeyEvent,
        child: quill.QuillEditor(
          controller: controller,
          focusNode: focusNode,
          scrollController: scrollController,
          config: const quill.QuillEditorConfig(
            padding: EdgeInsets.all(Sizes.p12),
            expands: true,
          ),
        ),
      ),
    ),
  );
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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Sizes.p8),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.chatComposerReplyTo(
                  message?.text.trim().isNotEmpty == true
                      ? message!.text
                      : replyId,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: context.l10n.chatComposerCancelReply,
              onPressed: onCancel,
              icon: const Icon(Symbols.close_rounded, size: 18),
            ),
          ],
        ),
      ),
    ),
  );
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
  Widget build(BuildContext context) => Align(
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

  Widget _sendButton(BuildContext context, {required bool isEnabled}) =>
      IconButton.filled(
        tooltip: context.l10n.globalChatSendMessage,
        onPressed: isEnabled ? onSubmit : null,
        icon: const Icon(Symbols.send_rounded, size: 18),
      );
}
