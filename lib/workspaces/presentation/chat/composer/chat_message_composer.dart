import 'dart:async';
import 'dart:convert';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_controls.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_queue_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_keyboard_policy.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer_fields.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_state.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:material_symbols_icons/symbols.dart';


/// Lokalny composer plain text i Quill Delta dla jednej otwartej rozmowy.
///
/// Nie wykonuje żądań ani nie zna identyfikatora rozmowy: snapshot przekazuje
/// do właściciela rozmowy, który dodaje go do kolejki UUID.
class ChatMessageComposer extends StatefulWidget {
  const ChatMessageComposer({
    required this.onSubmit,
    required this.draftRepository,
    required this.userId,
    required this.conversationId,
    this.conversationStates,
    this.deliveryConfirmations,
    this.attachmentUploadPort,
    this.filePickerPort,
    this.onAttachmentCoordinatorCreated,
    this.accessRevocation,
    this.replyTarget,
    this.onCancelReply,
    this.richController,
    this.compact = false,
    super.key,
  });

  final String? Function(ChatComposerDraft draft) onSubmit;
  final ChatDraftRepository draftRepository;
  final String userId;
  final String conversationId;
  final Stream<ChatConversationState>? conversationStates;
  final Stream<ChatMessageDeliveryConfirmation>? deliveryConfirmations;
  final ChatAttachmentUploadPort? attachmentUploadPort;
  final FilePickerPort? filePickerPort;

  /// Udostępnia ownera przyszłemu adapterowi pickera bez logiki platformy w UI.
  final ValueChanged<ChatAttachmentComposerCoordinatorCubit>?
  onAttachmentCoordinatorCreated;
  final ValueListenable<bool>? accessRevocation;
  final ChatMessage? replyTarget;
  final VoidCallback? onCancelReply;
  final quill.QuillController? richController;
  final bool compact;

  @override
  State<ChatMessageComposer> createState() => _ChatMessageComposerState();
}

class _ChatMessageComposerState extends State<ChatMessageComposer> {
  late final ChatComposerCubit _cubit;
  final TextEditingController _plainController = TextEditingController();
  final FocusNode _plainFocusNode = FocusNode();
  final FocusNode _richFocusNode = FocusNode();
  final ScrollController _richScrollController = ScrollController();
  final ChatComposerKeyboardPolicy _keyboardPolicy =
      ChatComposerKeyboardPolicy();
  late quill.QuillController _richController;
  late bool _ownsRichController;
  StreamSubscription<ChatConversationState>? _conversationSubscription;
  Timer? _typingStopTimer;
  bool _isTypingReported = false;
  StreamSubscription<ChatMessageDeliveryConfirmation>?
  _deliveryConfirmationSubscription;
  ChatAttachmentComposerCoordinatorCubit? _attachmentCoordinator;

  @override
  void initState() {
    super.initState();
    _cubit = ChatComposerCubit(
      repository: widget.draftRepository,
      serverRepository: context.read<ChatServerDraftRepository?>(),
      userId: widget.userId,
      conversationId: widget.conversationId,
    );
    _ownsRichController = widget.richController == null;
    _richController = widget.richController ?? quill.QuillController.basic();
    _richController.addListener(_onRichTextChanged);
    _syncReplyTarget(widget.replyTarget);
    _conversationSubscription = widget.conversationStates?.listen(
      _onConversationState,
    );
    _createAttachmentCoordinator();
    widget.accessRevocation?.addListener(_onAccessRevocationChanged);
    unawaited(_restoreDraft());
  }

  /// Zgłasza pisanie na starcie i planuje „stop” po bezczynności.
  void _reportTyping({required bool isTyping}) {
    final cubit = context.read<ChatConversationCubit?>();
    if (cubit == null) return;
    _typingStopTimer?.cancel();
    if (isTyping) {
      if (!_isTypingReported) {
        _isTypingReported = true;
        unawaited(cubit.notifyTyping(true));
      }
      _typingStopTimer = Timer(
        const Duration(seconds: 4),
        () => _reportTyping(isTyping: false),
      );
      return;
    }
    if (!_isTypingReported) return;
    _isTypingReported = false;
    unawaited(cubit.notifyTyping(false));
  }

  void _onConversationState(ChatConversationState state) {
    if (state is ChatConversationDetached) {
      unawaited(_clearForAccessRevoked());
    }
  }

  void _onAccessRevocationChanged() {
    if (widget.accessRevocation?.value == true) {
      unawaited(_clearForAccessRevoked());
    }
  }

  Future<void> _clearForAccessRevoked() async {
    await _attachmentCoordinator?.clearForAccessRevoked();
    _resetControllersAfterAccessRevoked();
    await _cubit.clearForAccessRevoked();
  }

  void _createAttachmentCoordinator() {
    final port = widget.attachmentUploadPort;
    if (port == null) return;
    final coordinator = ChatAttachmentComposerCoordinatorCubit(
      selection: ChatAttachmentSelectionCubit(),
      uploadQueue: ChatAttachmentUploadQueueCubit.fromUploadPort(port),
      updateDraftAttachmentIds: _cubit.updateAttachmentIds,
    );
    _attachmentCoordinator = coordinator;
    _deliveryConfirmationSubscription = widget.deliveryConfirmations?.listen(
      (confirmation) => unawaited(
        coordinator.markConsumedAfterConfirmedSend(
          clientMessageId: confirmation.clientMessageId,
          confirmedAttachmentIds: confirmation.attachmentFileIds,
        ),
      ),
    );
    widget.onAttachmentCoordinatorCreated?.call(coordinator);
  }

  void _resetControllersAfterAccessRevoked() {
    _plainController.clear();
    _replaceRichDocument(const <Object>[
      {'insert': '\n'},
    ]);
  }

  Future<void> _restoreDraft() async {
    await _cubit.restore();
    if (!mounted) return;
    final draft = _cubit.state.draft;
    _plainController.text = draft.text;
    if (draft.deltaJson case final delta?) {
      try {
        final decoded = jsonDecode(delta);
        if (decoded is List) {
          _replaceRichDocument(decoded);
          _cubit.selectMode(ChatComposerMode.richText);
        }
      } on FormatException {
        // Niepoprawny zapis nie może zablokować otwarcia rozmowy.
      }
    }
  }

  @override
  void didUpdateWidget(covariant ChatMessageComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.replyTarget?.id != widget.replyTarget?.id) {
      _syncReplyTarget(widget.replyTarget);
    }
  }

  @override
  @override
  void dispose() {
    _typingStopTimer?.cancel();
    unawaited(_conversationSubscription?.cancel());
    unawaited(_deliveryConfirmationSubscription?.cancel());
    widget.accessRevocation?.removeListener(_onAccessRevocationChanged);
    unawaited(_attachmentCoordinator?.close());
    unawaited(_cubit.close());
    _plainController.dispose();
    _plainFocusNode.dispose();
    _richFocusNode.dispose();
    _richScrollController.dispose();
    _richController.removeListener(_onRichTextChanged);
    if (_ownsRichController) _richController.dispose();
    super.dispose();
  }

  void _syncReplyTarget(ChatMessage? replyTarget) {
    final id = replyTarget?.id;
    if (id == null) {
      _cubit.clearReplyTarget();
    } else {
      _cubit.replyTo(id);
    }
  }

  void _onRichTextChanged() {
    _cubit.updateRichText(
      text: _richController.document.toPlainText().trimRight(),
      deltaJson: jsonEncode(_richController.document.toDelta().toJson()),
    );
  }

  KeyEventResult _onEnterKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        HardwareKeyboard.instance.isShiftPressed &&
        _cubit.state.mode == ChatComposerMode.plainText) {
      _insertPlainNewline();
      return KeyEventResult.handled;
    }
    if (_cubit.state.mode != ChatComposerMode.plainText) {
      return KeyEventResult.ignored;
    }
    return _keyboardPolicy.handle(
      event: event,
      value: _plainController.value,
      onSubmit: _submit,
    );
  }

  void _insertPlainNewline() {
    final value = _plainController.value;
    final selection = value.selection;
    final start = selection.start < 0 ? value.text.length : selection.start;
    final end = selection.end < 0 ? value.text.length : selection.end;
    final text = value.text.replaceRange(start, end, '\n');
    _plainController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: start + 1),
    );
    _cubit.updatePlainText(text);
  }

  void _selectMode(ChatComposerMode mode) {
    if (_cubit.state.mode == mode) return;
    if (mode == ChatComposerMode.richText && _plainController.text.isNotEmpty) {
      _replaceRichPlainText(_plainController.text);
    } else if (mode == ChatComposerMode.plainText) {
      _plainController.text = _richController.document
          .toPlainText()
          .trimRight();
      _cubit.updatePlainText(_plainController.text);
    }
    _cubit.selectMode(mode);
  }

  void _replaceRichPlainText(String text) {
    _replaceRichDocument(<Object>[
      {'insert': text.isEmpty ? '\n' : '$text\n'},
    ]);
    _onRichTextChanged();
  }

  /// Zmienia dokument bez przejmowania lifetime kontrolera przekazanego przez
  /// właściciela. Host może go bezpiecznie utrzymywać ponad rebuildami panelu.
  void _replaceRichDocument(List<Object?> deltaJson) {
    final document = quill.Document.fromJson(deltaJson);
    final replacement = quill.QuillController(
      document: document,
      selection: TextSelection.collapsed(
        offset: document.toPlainText().trimRight().length,
      ),
    );
    if (!_ownsRichController) {
      final replacementDelta = document.toDelta();
      _richController.replaceText(
        0,
        _richController.document.length - 1,
        replacementDelta,
        replacement.selection,
      );
      replacement.dispose();
      return;
    }
    _replaceOwnedRichController(replacement);
  }

  void _replaceOwnedRichController(quill.QuillController controller) {
    _richController.removeListener(_onRichTextChanged);
    _richController.dispose();
    _richController = controller..addListener(_onRichTextChanged);
  }

  void _submit() {
    final draft = _cubit.state.draft;
    if (draft.isEmpty) return;
    final clientMessageId = widget.onSubmit(draft);
    if (clientMessageId != null) {
      _attachmentCoordinator?.registerSubmittedMessage(
        clientMessageId: clientMessageId,
        attachmentIds: draft.attachmentIds,
      );
    }
    _plainController.clear();
    _replaceRichPlainText('');
    _cubit.clearAfterSubmit();
  }

  void _cancelReply() {
    _cubit.clearReplyTarget();
    widget.onCancelReply?.call();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _cubit,
    child: BlocBuilder<ChatComposerCubit, ChatComposerState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.all(widget.compact ? Sizes.p12 : Sizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.draft.replyToMessageId case final replyId?)
              ChatComposerReplyTarget(
                message: widget.replyTarget,
                replyId: replyId,
                onCancel: _cancelReply,
              ),
            SegmentedButton<ChatComposerMode>(
              segments: [
                ButtonSegment(
                  value: ChatComposerMode.plainText,
                  icon: const Icon(Symbols.notes_rounded, size: 18),
                  label: Text(context.l10n.chatComposerPlainMode),
                ),
                ButtonSegment(
                  value: ChatComposerMode.richText,
                  icon: const Icon(Symbols.format_size_rounded, size: 18),
                  label: Text(context.l10n.chatComposerRichMode),
                ),
              ],
              selected: {state.mode},
              onSelectionChanged: (modes) => _selectMode(modes.single),
              showSelectedIcon: false,
            ),
            Gaps.h8,
            if (state.mode == ChatComposerMode.plainText)
              Focus(
                onKeyEvent: _onEnterKey,
                child: TextField(
                  controller: _plainController,
                  focusNode: _plainFocusNode,
                  minLines: 1,
                  maxLines: widget.compact ? 3 : 5,
                  onChanged: (value) {
                    _reportTyping(isTyping: value.trim().isNotEmpty);
                    _cubit.updatePlainText(value);
                  },
                  decoration: InputDecoration(
                    hintText: context.l10n.globalChatComposerHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              )
            else
              ChatComposerRichTextField(
                controller: _richController,
                focusNode: _richFocusNode,
                scrollController: _richScrollController,
                onKeyEvent: _onEnterKey,
                compact: widget.compact,
              ),
            if (_attachmentCoordinator case final coordinator?)
              ChatAttachmentComposerControls(
                coordinator: coordinator,
                conversationId: widget.conversationId,
                filePickerPort: widget.filePickerPort,
              ),
            ChatComposerSubmitButton(
              coordinator: _attachmentCoordinator,
              canSubmit: (attachmentState) =>
                  _canSubmit(state, attachmentState),
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    ),
  );

  bool _canSubmit(ChatComposerState state, Object? attachmentState) {
    return attachmentState is! ChatAttachmentComposerCoordinatorPreparing &&
        attachmentState is! ChatAttachmentComposerCoordinatorFailed &&
        attachmentState
            is! ChatAttachmentComposerCoordinatorAwaitingConfirmation;
  }
}
