import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_private_storage_picker.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_queue_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_editor_controller.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_paste_controller.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer_view.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_state.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

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
    this.draftConversationId,
    this.conversationStates,
    this.serverDraftEnabled = true,
    this.deliveryConfirmations,
    this.attachmentUploadPort,
    this.filePickerPort,
    this.mentionAllEnabled = false,
    this.onAttachmentCoordinatorCreated,
    this.accessRevocation,
    this.replyTarget,
    this.onCancelReply,
    this.richController,
    this.compact = false,
    this.desktopWebStyle = false,
    super.key,
  });

  final String? Function(ChatComposerDraft draft) onSubmit;
  final ChatDraftRepository draftRepository;
  final String userId;
  final String conversationId;

  /// Separate local draft identity for a thread; API calls use conversationId.
  final String? draftConversationId;
  final Stream<ChatConversationState>? conversationStates;

  /// Szkice wątków mają lokalny klucz, który nie jest UUID endpointu rozmowy.
  final bool serverDraftEnabled;
  final Stream<ChatMessageDeliveryConfirmation>? deliveryConfirmations;
  final ChatAttachmentUploadPort? attachmentUploadPort;
  final FilePickerPort? filePickerPort;

  /// Czy aktor i typ rozmowy pozwalają na wzmiankę `@all` (decyduje serwer).
  final bool mentionAllEnabled;

  /// Udostępnia ownera przyszłemu adapterowi pickera bez logiki platformy w UI.
  final ValueChanged<ChatAttachmentComposerCoordinatorCubit>?
  onAttachmentCoordinatorCreated;
  final ValueListenable<bool>? accessRevocation;
  final ChatMessage? replyTarget;
  final VoidCallback? onCancelReply;
  final quill.QuillController? richController;
  final bool compact;
  final bool desktopWebStyle;

  @override
  State<ChatMessageComposer> createState() => _ChatMessageComposerState();
}

class _ChatMessageComposerState extends State<ChatMessageComposer> {
  late final ChatComposerCubit _cubit;
  late final ChatComposerEditorController _editor;
  late final ChatComposerPasteController _paste;
  StreamSubscription<ChatConversationState>? _conversationSubscription;
  Timer? _typingStopTimer;
  bool _isTypingReported = false;
  bool _editorFocused = false;

  /// Rozszerzenia zdjęć dla akcji „Zdjęcie”; filtr jest jawny, nie zgadywany.
  static const List<String> _imageExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'heic',
    'heif',
    'bmp',
  ];
  StreamSubscription<ChatMessageDeliveryConfirmation>?
  _deliveryConfirmationSubscription;
  ChatAttachmentComposerCoordinatorCubit? _attachmentCoordinator;

  @override
  void initState() {
    super.initState();
    _cubit = ChatComposerCubit(
      repository: widget.draftRepository,
      serverRepository: widget.serverDraftEnabled
          ? context.read<ChatServerDraftRepository?>()
          : null,
      userId: widget.userId,
      conversationId: widget.draftConversationId ?? widget.conversationId,
    );
    final searchRepository = context.read<ChatSearchRepository?>();
    _editor = ChatComposerEditorController(
      cubit: _cubit,
      conversationId: widget.conversationId,
      mentionAllEnabled: widget.mentionAllEnabled,
      contextProvider: () => context,
      mountedProvider: () => mounted,
      onSubmit: _submit,
      onPaste: _handlePaste,
      externalRichController: widget.richController,
      searchRepository: searchRepository,
    );
    _syncReplyTarget(widget.replyTarget);
    _conversationSubscription = widget.conversationStates?.listen(
      _onConversationState,
    );
    _createAttachmentCoordinator();
    _paste = ChatComposerPasteController(
      contextProvider: () => context,
      mountedProvider: () => mounted,
      conversationId: widget.conversationId,
      cubit: _cubit,
      attachmentCoordinator: () => _attachmentCoordinator,
      insertText: _editor.insertText,
    )..addListener(_onPasteChanged);
    widget.accessRevocation?.addListener(_onAccessRevocationChanged);
    if (widget.accessRevocation?.value == true) {
      unawaited(_clearForAccessRevoked());
    } else {
      unawaited(_restoreDraft());
    }
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
    // Unieważnij restore i zapisz intencję usunięcia synchronicznie, zanim
    // cleanup załączników lub unmount zakończy lifecycle composera.
    final clearDraft = _cubit.clearForAccessRevoked();
    await _attachmentCoordinator?.clearForAccessRevoked();
    if (mounted) _resetControllersAfterAccessRevoked();
    await clearDraft;
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
    _editor.resetAfterAccessRevoked();
  }

  Future<void> _restoreDraft() async {
    await _cubit.restore();
    if (!mounted) return;
    final draft = _cubit.state.draft;
    _editor.plainController.text = draft.text;
    _editor.restoreDelta(draft.deltaJson);
  }

  @override
  void didUpdateWidget(covariant ChatMessageComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.replyTarget?.id != widget.replyTarget?.id) {
      _syncReplyTarget(widget.replyTarget);
    }
  }

  @override
  void dispose() {
    _typingStopTimer?.cancel();
    unawaited(_conversationSubscription?.cancel());
    unawaited(_deliveryConfirmationSubscription?.cancel());
    widget.accessRevocation?.removeListener(_onAccessRevocationChanged);
    unawaited(_attachmentCoordinator?.close());
    unawaited(_cubit.close());
    _paste.removeListener(_onPasteChanged);
    _paste.dispose();
    _editor.dispose();
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

  Future<void> _handlePaste() => _paste.handlePaste();

  void _sendDraftAsFile() => _paste.sendDraftAsFile(_cubit.state.draft.text);

  Future<void> _keepPendingPasteAsText() => _paste.keepAsText();

  Future<void> _discardPendingPaste() => _paste.discard();

  Future<void> _sendPendingPasteAsFile() => _paste.sendPendingAsFile();

  void _onPasteChanged() {
    if (mounted) setState(() {});
  }

  bool get _attachmentLocked =>
      _attachmentCoordinator?.state
          is ChatAttachmentComposerCoordinatorAwaitingConfirmation;

  Future<void> _pickImages() async {
    final port = widget.filePickerPort;
    final coordinator = _attachmentCoordinator;
    if (port is! ConstrainedFilePickerPort ||
        coordinator == null ||
        _attachmentLocked) {
      return;
    }
    final inputs = await port.pickFiles(
      allowedExtensions: _imageExtensions,
      constraints: coordinator.inputConstraints,
    );
    if (!mounted || _attachmentLocked) return;
    await _addInputs(inputs);
  }

  Future<void> _pickFiles() async {
    final port = widget.filePickerPort;
    final coordinator = _attachmentCoordinator;
    if (port is! ConstrainedFilePickerPort ||
        coordinator == null ||
        _attachmentLocked) {
      return;
    }
    final inputs = await port.pickFiles(
      constraints: coordinator.inputConstraints,
    );
    if (!mounted || _attachmentLocked) return;
    await _addInputs(inputs);
  }

  Future<void> _pickPrivateFiles() async {
    final repository = context.read<StorageRepository?>();
    final coordinator = _attachmentCoordinator;
    if (coordinator == null || _attachmentLocked) return;
    if (repository == null) {
      AppToast.show(
        context,
        message: context.l10n.chatPrivateFilesUnavailable,
        tone: AppToastTone.error,
      );
      return;
    }
    final files = await ChatPrivateStoragePicker.show(
      context,
      repository: repository,
    );
    if (!mounted || _attachmentLocked || files == null || files.isEmpty) return;
    coordinator.selectInputs(files);
    await coordinator.prepare(widget.conversationId);
  }

  Future<void> _addInputs(List<StorageUploadInput> inputs) async {
    final coordinator = _attachmentCoordinator;
    if (!mounted ||
        coordinator == null ||
        inputs.isEmpty ||
        _attachmentLocked) {
      return;
    }
    coordinator.selectInputs(inputs);
    await coordinator.prepare(widget.conversationId);
  }

  void _submit() {
    final draft = _cubit.state.draft;
    if (draft.isEmpty) return;
    final clientMessageId = widget.onSubmit(draft);
    // null oznacza, że właściciel nie przyjął wysyłki (np. rozmowa jest już
    // odłączona). Zachowaj wówczas tekst, reply i upload do ponowienia.
    if (clientMessageId == null) return;
    _attachmentCoordinator?.registerSubmittedMessage(
      clientMessageId: clientMessageId,
      attachmentIds: draft.attachmentIds,
    );
    _editor.plainController.clear();
    _editor.replaceRichPlainText('');
    _cubit.clearAfterSubmit();
    // Focus wraca do edytora, żeby można było pisać dalej bez klikania.
    _editor.focusEditor();
  }

  void _cancelReply() {
    _cubit.clearReplyTarget();
    widget.onCancelReply?.call();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _cubit,
    child: BlocListener<ChatComposerCubit, ChatComposerState>(
      listenWhen: (previous, current) =>
          current.serverSyncFailureCode != null &&
          previous.serverSyncFailureCode != current.serverSyncFailureCode,
      listener: (context, _) => AppToast.show(
        context,
        message: context.l10n.chatActionFailureMessage,
        tone: AppToastTone.error,
      ),
      child: BlocBuilder<ChatComposerCubit, ChatComposerState>(
        buildWhen: (previous, current) =>
            current.shouldRebuildComparedTo(previous),
        builder: (context, state) => ChatMessageComposerView(
          composer: widget,
          state: state,
          editor: _editor,
          paste: _paste,
          attachmentCoordinator: _attachmentCoordinator,
          editorFocused: _editorFocused,
          onFocusChanged: (value) => setState(() => _editorFocused = value),
          onTypingChanged: (value) =>
              _reportTyping(isTyping: value.trim().isNotEmpty),
          onSubmit: _submit,
          onCancelReply: _cancelReply,
          onSendDraftAsFile: _sendDraftAsFile,
          onKeepPendingPasteAsText: _keepPendingPasteAsText,
          onDiscardPendingPaste: _discardPendingPaste,
          onSendPendingPasteAsFile: _sendPendingPasteAsFile,
          onPickImages: _pickImages,
          onPickFiles: _pickFiles,
          onPickPrivateFiles: _pickPrivateFiles,
        ),
      ),
    ),
  );
}
