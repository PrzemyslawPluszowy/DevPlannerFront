import 'dart:async';
import 'dart:convert';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy_repository.dart';
import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:devplanner/workspaces/domain/chat/rich_text/chat_code_block_codec.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/domain/chat/snippets/chat_snippet_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_controls.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_queue_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_height_policy.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_keyboard_policy.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_rich_toolbar.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_surface.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_format_actions.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_format_commands.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_long_paste_card.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_long_paste_decision.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer_fields.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_state.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/chat_emoji_picker.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/mentions/chat_mention_picker_controller.dart';
import 'package:devplanner/workspaces/presentation/chat/mentions/chat_mention_suggestions.dart';
import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_code_block_dialog.dart';
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
    this.mentionAllEnabled = false,
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

  @override
  State<ChatMessageComposer> createState() => _ChatMessageComposerState();
}

class _ChatMessageComposerState extends State<ChatMessageComposer> {
  late final ChatComposerCubit _cubit;
  final GlobalKey _emojiAnchorKey = GlobalKey();
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
  bool _editorFocused = false;
  ChatLinkPolicy? _linkPolicy;
  bool _policyLoaded = false;
  ChatLongPasteAssessment? _pendingPaste;
  String? _pendingPasteText;
  String? _pendingPasteNotice;
  String? _pendingPasteFailure;
  bool _preparingSnippet = false;
  bool _readingPaste = false;
  bool _forceRawPasteAsFile = false;
  String? _pendingPasteAttachmentLocalId;

  /// Nazwa pliku snippet-u zgodna z bieżącym kontraktem backendu.
  static const String _snippetFileName = 'chat-snippet.txt';

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
  ChatMentionPickerController? _mentionPicker;

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
    final searchRepository = context.read<ChatSearchRepository?>();
    if (searchRepository != null) {
      _mentionPicker = ChatMentionPickerController(
        repository: searchRepository,
        conversationId: widget.conversationId,
        allTokenEnabled: widget.mentionAllEnabled,
      );
      // Kursor i tekst zmieniają aktywne wywołanie `@`, więc nasłuch jest na
      // kontrolerze, a nie tylko na `onChanged` pola.
      _plainController.addListener(_syncMentionQuery);
    }
    _syncReplyTarget(widget.replyTarget);
    _conversationSubscription = widget.conversationStates?.listen(
      _onConversationState,
    );
    _createAttachmentCoordinator();
    widget.accessRevocation?.addListener(_onAccessRevocationChanged);
    unawaited(_restoreDraft());
  }

  /// Wstawia blok kodu w trybie rich (operacje delty) albo plain (ogrodzenie).
  ///
  /// Edycja kodu nie wysyła wiadomości: formularz ma własne pole i jawną akcję,
  /// a w trybie rich Enter wewnątrz bloku dodaje linię, nie publikuje.
  Future<void> _insertCode() async {
    final input = await ChatCodeBlockDialog.show(context);
    if (input == null || !mounted) return;
    if (_cubit.state.mode == ChatComposerMode.richText) {
      final ops = ChatCodeBlockCodec.build(
        code: input.code,
        language: input.language,
      );
      if (ops.isEmpty) return;
      final selection = _richController.selection;
      final index = selection.isValid && selection.baseOffset >= 0
          ? selection.baseOffset
          : _richController.document.length - 1;
      _richController.replaceText(
        index,
        0,
        quill.Document.fromJson(ops).toDelta(),
        null,
      );
      _onRichTextChanged();
      return;
    }
    final fence = '```${input.language ?? ''}\n${input.code.trimRight()}\n```';
    final value = _plainController.value;
    final start = value.selection.start < 0
        ? value.text.length
        : value.selection.start;
    final end = value.selection.end < 0
        ? value.text.length
        : value.selection.end;
    final text = value.text.replaceRange(start, end, fence);
    _plainController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: start + fence.length),
    );
    _cubit.updatePlainText(text);
  }

  /// Odzwierciedla bieżący kursor w liście podpowiedzi wzmianki.
  void _syncMentionQuery() {
    final picker = _mentionPicker;
    if (picker == null) return;
    final value = _plainController.value;
    final caret = value.selection.isValid
        ? value.selection.baseOffset
        : value.text.length;
    picker.updateQuery(ChatMentionCodec.activeQuery(value.text, caret));
  }

  /// Wstawia wybraną osobę jako etykietę i rejestruje jej stabilny UUID.
  void _acceptMention(ChatMentionSuggestion suggestion) {
    final picker = _mentionPicker;
    final query = picker?.query;
    if (picker == null || query == null) return;
    final label = ChatMentionCodec.labelFor(
      userId: suggestion.userId,
      displayName: suggestion.displayName,
      login: suggestion.login,
    );
    final text = ChatMentionCodec.applyMention(
      text: _plainController.text,
      query: query,
      label: label,
    );
    _plainController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: query.start + label.length + 2,
      ),
    );
    _cubit.updatePlainText(text);
    _cubit.setMentions([
      ..._cubit.state.draft.mentions,
      ChatMentionReference(userId: suggestion.userId, label: label),
    ]);
    picker.close();
  }

  /// Wstawia `@all`; token nie jest osobą, więc nie rejestrujemy wzmianki.
  void _acceptAllMention() {
    final picker = _mentionPicker;
    final query = picker?.query;
    if (picker == null || query == null) return;
    final text = ChatMentionCodec.applyMention(
      text: _plainController.text,
      query: query,
      label: ChatMentionCodec.allToken.substring(1),
    );
    _plainController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: query.start + ChatMentionCodec.allToken.length + 1,
      ),
    );
    _cubit.updatePlainText(text);
    picker.close();
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
  void dispose() {
    _typingStopTimer?.cancel();
    unawaited(_conversationSubscription?.cancel());
    unawaited(_deliveryConfirmationSubscription?.cancel());
    widget.accessRevocation?.removeListener(_onAccessRevocationChanged);
    unawaited(_attachmentCoordinator?.close());
    unawaited(_cubit.close());
    _plainController.removeListener(_syncMentionQuery);
    _mentionPicker?.dispose();
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
    // Otwarta lista wzmianek przejmuje strzałki, Enter i Escape, żeby wybór
    // osoby nie wysyłał wiadomości ani nie zamykał panelu.
    final picker = _mentionPicker;
    if (event is KeyDownEvent &&
        picker != null &&
        picker.isOpen &&
        _cubit.state.mode == ChatComposerMode.plainText) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.arrowDown) {
        picker.moveDown();
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowUp) {
        picker.moveUp();
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.escape) {
        picker.close();
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.enter) {
        final active = picker.active;
        if (active != null) {
          _acceptMention(active);
          return KeyEventResult.handled;
        }
      }
    }
    final commandModifier =
        HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;
    if (event is KeyDownEvent &&
        _cubit.state.mode == ChatComposerMode.richText &&
        commandModifier &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      // W rozbudowanym edytorze Enter łamie linię, więc wysyłka ma osobny skrót.
      _submit();
      return KeyEventResult.handled;
    }
    if (event is KeyDownEvent &&
        _cubit.state.mode == ChatComposerMode.richText &&
        commandModifier) {
      final shortcut = switch (event.logicalKey) {
        LogicalKeyboardKey.keyB => ChatFormatCommand.bold,
        LogicalKeyboardKey.keyI => ChatFormatCommand.italic,
        _ => null,
      };
      if (shortcut != null) {
        unawaited(
          applyFormatCommand(
            context,
            controller: _richController,
            command: shortcut,
          ),
        );
        return KeyEventResult.handled;
      }
    }
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
    if (mode == ChatComposerMode.richText) {
      // Sama zmiana widoku nie może spłaszczyć istniejącej delty. Treść
      // kopiujemy tylko wtedy, gdy użytkownik faktycznie zmienił tekst w trybie
      // plain; bez edycji wracamy do pełnego formatowania.
      final richText = _richController.document.toPlainText().trimRight();
      if (_plainController.text != richText) {
        _replaceRichPlainText(_plainController.text);
      }
    } else {
      _plainController.text = _richController.document
          .toPlainText()
          .trimRight();
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

  /// Przełącza rozbudowany edytor bez konwersji dokumentu na plain text.
  void _toggleExpandedEditor() {
    _selectMode(
      _cubit.state.mode == ChatComposerMode.richText
          ? ChatComposerMode.plainText
          : ChatComposerMode.richText,
    );
  }

  /// Otwiera wspólny picker i wstawia wybór w miejscu kursora.
  ///
  /// Zamknięcie pickera bez wyboru nic nie zmienia i nie wysyła wiadomości;
  /// fokus wraca do edytora, żeby użytkownik mógł pisać dalej.
  Future<void> _pickEmoji() async {
    final recent = context.read<ChatEmojiRecentCubit?>();
    if (recent == null) return;
    final emoji = await showChatEmojiPicker(
      context,
      recent: recent,
      anchorKey: _emojiAnchorKey,
    );
    if (emoji == null || !mounted) return;
    _insertEmoji(emoji);
  }

  /// Akcje menu edytora: wklejenie bez formatowania i zaznaczenie całości.
  ///
  /// Composer zawsze wkleja czysty tekst (transport to delta budowana przez nas),
  /// więc nie ma drugiej, „bogatej” pozycji, która robiłaby dokładnie to samo.
  List<AppContextMenuAction> _editorMenuActions(BuildContext context) =>
      <AppContextMenuAction>[
        AppContextMenuAction(
          label: context.l10n.chatComposerPastePlain,
          icon: Symbols.content_paste,
          onTap: (_) => unawaited(_handlePaste()),
        ),
        AppContextMenuAction(
          label: context.l10n.chatComposerSelectAll,
          icon: Symbols.select_all,
          onTap: (_) => _selectAll(),
        ),
      ];

  /// Zaznacza całą treść aktywnego edytora.
  void _selectAll() {
    if (_cubit.state.mode == ChatComposerMode.plainText) {
      _plainController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _plainController.text.length,
      );
      _plainFocusNode.requestFocus();
      return;
    }
    final end = _richController.document.length - 1;
    _richController.updateSelection(
      TextSelection(baseOffset: 0, extentOffset: end < 0 ? 0 : end),
      quill.ChangeSource.local,
    );
    _richFocusNode.requestFocus();
  }

  /// Przechwytuje wklejenie, żeby długi tekst nie trafił po cichu do wiadomości.
  ///
  /// Krótka treść wkleja się normalnie; długa czeka na decyzję użytkownika
  /// w karcie nad powierzchnią pisania. Politykę pobieramy raz na sesję
  /// composera, a jej brak oznacza brak propozycji pliku — nie zgadujemy progów.
  Future<void> _handlePaste() async {
    // Jedna decyzja wklejenia naraz. Nadpisanie karty po wybraniu pliku mogłoby
    // pozostawić lokalny upload poprzedniej treści pod nowym tekstem.
    if (_pendingPaste != null || _preparingSnippet || _readingPaste) return;
    _readingPaste = true;
    try {
      final repository = context.read<ChatLinkPolicyRepository?>();
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final text = data?.text;
      if (!mounted || text == null || text.isEmpty) return;
      final policy = await _loadPolicy(repository);
      if (!mounted) return;
      final assessment = ChatLongPasteDecision.assess(
        text: text,
        policy: policy,
      );
      if (assessment.kind == ChatLongPasteKind.text) {
        _insertText(text);
        return;
      }
      setState(() {
        _pendingPasteText = text;
        _pendingPaste = assessment;
        _pendingPasteNotice = null;
        _pendingPasteFailure = null;
      });
    } finally {
      _readingPaste = false;
    }
  }

  /// Przygotowuje bieżący szkic do wysłania jako zwykły plik TXT.
  void _sendDraftAsFile() {
    // Nie zastępuj wklejenia, które użytkownik jeszcze rozstrzyga lub którego
    // załącznik jest przygotowywany.
    if (_pendingPaste != null || _preparingSnippet || _readingPaste) return;
    final text = _cubit.state.draft.text;
    if (text.trim().isEmpty) return;
    final assessment = ChatLongPasteDecision.assess(
      text: text,
      policy: _linkPolicy,
    );
    setState(() {
      _pendingPasteText = text;
      _pendingPaste = ChatLongPasteAssessment(
        kind: ChatLongPasteKind.file,
        characters: assessment.characters,
        byteLength: assessment.byteLength,
        previewLines: assessment.previewLines,
      );
      _pendingPasteNotice = null;
      _pendingPasteFailure = null;
      _forceRawPasteAsFile = true;
    });
  }

  Future<ChatLinkPolicy?> _loadPolicy(
    ChatLinkPolicyRepository? repository,
  ) async {
    if (_policyLoaded) return _linkPolicy;
    if (repository == null) {
      _policyLoaded = true;
      return null;
    }
    final result = await repository.getPolicy();
    if (!mounted) return null;
    setState(() {
      _policyLoaded = true;
      _linkPolicy = result.fold((_) => null, (policy) => policy);
    });
    return _linkPolicy;
  }

  /// Zostawia oczekujące wklejenie w wiadomości.
  ///
  /// Jeśli wcześniej utworzono załącznik TXT, najpierw musi zostać skutecznie
  /// usunięty. Wstawienie treści przed zakończeniem cleanupu pozwalałoby wysłać
  /// ten sam tekst jednocześnie w treści i w załączniku.
  Future<void> _keepPendingPasteAsText() async {
    final text = _pendingPasteText;
    if (text == null || _pendingPaste?.kind == ChatLongPasteKind.overLimit) {
      return;
    }
    final localId = _pendingPasteAttachmentLocalId;
    final coordinator = _attachmentCoordinator;
    if (localId != null) {
      if (coordinator == null) {
        setState(
          () => _pendingPasteFailure = context.l10n.chatLongPastePrepareFailed,
        );
        return;
      }
      setState(() {
        _preparingSnippet = true;
        _pendingPasteFailure = null;
      });
      try {
        await coordinator.remove(widget.conversationId, localId);
      } on Object {
        if (!mounted) return;
        setState(() {
          _preparingSnippet = false;
          _pendingPasteFailure = context.l10n.chatLongPastePrepareFailed;
        });
        return;
      }
      if (!mounted) return;
    }
    _clearPendingPaste();
    _insertText(text);
  }

  /// Usuwa załącznik TXT przed odrzuceniem karty decyzji.
  ///
  /// Koordynator anuluje bieżący upload i aktualizuje listę załączników szkicu.
  /// Wysyłka pozostaje zablokowana do zakończenia sprzątania.
  Future<void> _discardPendingPaste() async {
    final localId = _pendingPasteAttachmentLocalId;
    final coordinator = _attachmentCoordinator;
    if (localId == null || coordinator == null) {
      _clearPendingPaste();
      return;
    }
    setState(() {
      _preparingSnippet = true;
      _pendingPasteFailure = null;
    });
    try {
      await coordinator.remove(widget.conversationId, localId);
    } on Object {
      if (!mounted) return;
      setState(() {
        _preparingSnippet = false;
        _pendingPasteFailure = context.l10n.chatLongPastePrepareFailed;
      });
      return;
    }
    if (mounted) _clearPendingPaste();
  }

  /// Czyści stan decyzji, pozostawiając życie załącznika callerowi.
  void _clearPendingPaste() => setState(() {
    _pendingPasteText = null;
    _pendingPaste = null;
    _pendingPasteNotice = null;
    _pendingPasteFailure = null;
    _forceRawPasteAsFile = false;
    _pendingPasteAttachmentLocalId = null;
    _preparingSnippet = false;
  });

  /// Przygotowuje snippet i przekazuje plik TXT do kolejki załączników.
  ///
  /// Publikacja idzie istniejącą ścieżką Storage: plik jest uploadowany i
  /// dołączany przy wysłaniu wiadomości, więc ponowienie nie tworzy drugiej
  /// wiadomości ani nie gubi treści.
  Future<void> _sendPendingPasteAsFile() async {
    final text = _pendingPasteText;
    final repository = context.read<ChatSnippetRepository?>();
    final coordinator = _attachmentCoordinator;
    final forceRaw = _forceRawPasteAsFile;
    if (text == null) return;
    if ((!forceRaw && repository == null) || coordinator == null) {
      setState(
        () => _pendingPasteFailure = context.l10n.chatLongPastePrepareFailed,
      );
      return;
    }
    setState(() {
      _preparingSnippet = true;
      _pendingPasteFailure = null;
    });
    final overLimit = _pendingPaste?.kind == ChatLongPasteKind.overLimit;
    ChatSnippetPreparation? preparation;
    if (!overLimit && !forceRaw && repository != null) {
      final result = await repository.prepare(
        conversationId: widget.conversationId,
        text: text,
      );
      if (!mounted) return;
      preparation = result.fold<ChatSnippetPreparation?>(
        (_) => null,
        (value) => value,
      );
      if (preparation?.content == null) {
        setState(() {
          _preparingSnippet = false;
          _pendingPasteFailure = context.l10n.chatLongPastePrepareFailed;
        });
        return;
      }
    }
    // Jeżeli endpoint snippet-u nie przyjmie długości wejścia albo zwróci
    // ograniczony podgląd, zapisujemy dokładne oryginalne wklejenie przez zwykły
    // upload Storage. Nie wysyłamy skróconej ani oczyszczonej kopii po cichu.
    final prepared = preparation;
    final useOriginal =
        forceRaw || overLimit || (prepared?.isTruncated ?? false);
    final content = useOriginal ? text : prepared?.content;
    if (content == null) {
      setState(() {
        _preparingSnippet = false;
        _pendingPasteFailure = context.l10n.chatLongPastePrepareFailed;
      });
      return;
    }
    final bytes = utf8.encode(content);
    if (bytes.length > coordinator.selectionCubit.limits.maxFileSizeBytes) {
      setState(() {
        _preparingSnippet = false;
        _pendingPasteFailure = context.l10n.chatLongPasteAttachmentTooLarge;
      });
      return;
    }
    if (_pendingPasteAttachmentLocalId == null) {
      final previousCount = coordinator.selection.attachments.length;
      coordinator.selectInputs(<StorageUploadInput>[
        StorageUploadInput(
          name: preparation?.suggestedFileName ?? _snippetFileName,
          size: bytes.length,
          bytes: Uint8List.fromList(bytes),
          mimeType: preparation?.mimeType ?? 'text/plain; charset=utf-8',
        ),
      ]);
      final selection = coordinator.selectionCubit.state;
      if (selection is! ChatAttachmentSelectionReady ||
          selection.attachments.length <= previousCount) {
        setState(() {
          _preparingSnippet = false;
          _pendingPasteFailure = context.l10n.chatLongPastePrepareFailed;
        });
        return;
      }
      _pendingPasteAttachmentLocalId = selection.attachments.last.localId;
    }
    await coordinator.prepare(widget.conversationId);
    if (!mounted) return;
    final uploadState = coordinator.state;
    if (uploadState is ChatAttachmentComposerCoordinatorReady) {
      setState(() => _preparingSnippet = false);
      _clearPendingPaste();
      return;
    }
    setState(() {
      _preparingSnippet = false;
      _pendingPasteFailure = context.l10n.chatLongPastePrepareFailed;
    });
  }

  void _insertEmoji(String emoji) => _insertText(emoji);

  /// Wstawia tekst w miejscu kursora, zachowując zaznaczenie i atrybuty.
  void _insertText(String text) {
    if (_cubit.state.mode == ChatComposerMode.plainText) {
      final value = _plainController.value;
      final selection = value.selection;
      final start = selection.start < 0 ? value.text.length : selection.start;
      final end = selection.end < 0 ? value.text.length : selection.end;
      final updated = value.text.replaceRange(start, end, text);
      _plainController.value = TextEditingValue(
        text: updated,
        selection: TextSelection.collapsed(offset: start + text.length),
      );
      _cubit.updatePlainText(updated);
    } else {
      final selection = _richController.selection;
      final index = selection.start < 0
          ? _richController.document.length - 1
          : selection.start;
      final length = selection.isValid && !selection.isCollapsed
          ? selection.end - selection.start
          : 0;
      _richController.replaceText(
        index,
        length,
        text,
        TextSelection.collapsed(offset: index + text.length),
      );
      _onRichTextChanged();
    }
    _focusEditor();
  }

  Future<void> _pickImages() async {
    final port = widget.filePickerPort;
    final coordinator = _attachmentCoordinator;
    if (port is! ConstrainedFilePickerPort || coordinator == null) return;
    await _addInputs(
      await port.pickFiles(
        allowedExtensions: _imageExtensions,
        constraints: coordinator.inputConstraints,
      ),
    );
  }

  Future<void> _pickFiles() async {
    final port = widget.filePickerPort;
    final coordinator = _attachmentCoordinator;
    if (port is! ConstrainedFilePickerPort || coordinator == null) return;
    await _addInputs(
      await port.pickFiles(constraints: coordinator.inputConstraints),
    );
  }

  Future<void> _addInputs(List<StorageUploadInput> inputs) async {
    final coordinator = _attachmentCoordinator;
    if (coordinator == null || inputs.isEmpty) return;
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
    _plainController.clear();
    _replaceRichPlainText('');
    _cubit.clearAfterSubmit();
    // Focus wraca do edytora, żeby można było pisać dalej bez klikania.
    _focusEditor();
  }

  /// Ustawia focus na aktywnym edytorze.
  void _focusEditor() {
    if (_cubit.state.mode == ChatComposerMode.plainText) {
      _plainFocusNode.requestFocus();
    } else {
      _richFocusNode.requestFocus();
    }
  }

  void _cancelReply() {
    _cubit.clearReplyTarget();
    widget.onCancelReply?.call();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _cubit,
    child: BlocBuilder<ChatComposerCubit, ChatComposerState>(
      builder: (context, state) {
        final chat = context.chatTheme;
        return LayoutBuilder(
          builder: (context, constraints) {
            final editorMaxHeight = ChatComposerHeightPolicy.maxEditorHeight(
              availableConversationHeight: constraints.maxHeight,
              themeMaxHeight: chat.composerMaxHeight,
            );
            final composer = Padding(
              padding: EdgeInsets.fromLTRB(
                widget.compact ? chat.compactHistoryGutter : chat.historyGutter,
                Sizes.p8,
                widget.compact ? chat.compactHistoryGutter : chat.historyGutter,
                Sizes.p8,
              ),
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
                  if (state.mode == ChatComposerMode.plainText)
                    if (_mentionPicker case final picker?)
                      ChatMentionSuggestions(
                        controller: picker,
                        onSelected: _acceptMention,
                        onSelectAll: widget.mentionAllEnabled
                            ? _acceptAllMention
                            : null,
                      ),
                  if (_pendingPaste case final assessment?)
                    ChatLongPasteCard(
                      assessment: assessment,
                      fileName: _snippetFileName,
                      busy: _preparingSnippet,
                      failureMessage: _pendingPasteFailure,
                      notice: _pendingPasteNotice,
                      onSendAsFile: _attachmentCoordinator == null
                          ? null
                          : () => unawaited(_sendPendingPasteAsFile()),
                      onKeepAsText:
                          assessment.kind == ChatLongPasteKind.overLimit
                          ? null
                          : _keepPendingPasteAsText,
                      onCancel: () => unawaited(_discardPendingPaste()),
                    ),
                  if (_attachmentCoordinator case final coordinator?)
                    ChatAttachmentComposerControls(
                      coordinator: coordinator,
                      conversationId: widget.conversationId,
                    ),
                  if (state.mode == ChatComposerMode.richText)
                    ChatComposerRichToolbar(controller: _richController),
                  Focus(
                    onFocusChange: (value) =>
                        setState(() => _editorFocused = value),
                    child: ChatComposerSurface(
                      focused: _editorFocused,
                      moreActions: ChatComposerMoreMenu(
                        expandedEditor: state.mode == ChatComposerMode.richText,
                        onToggleExpandedEditor: _toggleExpandedEditor,
                        onInsertCode: _insertCode,
                        onTextAsFile: _attachmentCoordinator == null
                            ? null
                            : _sendDraftAsFile,
                        onPickImage:
                            _attachmentCoordinator == null ||
                                widget.filePickerPort
                                    is! ConstrainedFilePickerPort
                            ? null
                            : () => unawaited(_pickImages()),
                        onPickFile:
                            _attachmentCoordinator == null ||
                                widget.filePickerPort
                                    is! ConstrainedFilePickerPort
                            ? null
                            : () => unawaited(_pickFiles()),
                      ),
                      editor: AppContextMenuRegion(
                        actionsBuilder: _editorMenuActions,
                        child: Actions(
                          actions: <Type, Action<Intent>>{
                            PasteTextIntent: CallbackAction<PasteTextIntent>(
                              onInvoke: (_) {
                                unawaited(_handlePaste());
                                return null;
                              },
                            ),
                          },
                          child: state.mode == ChatComposerMode.plainText
                              ? Focus(
                                  onKeyEvent: _onEnterKey,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: editorMaxHeight,
                                    ),
                                    child: TextField(
                                      controller: _plainController,
                                      focusNode: _plainFocusNode,
                                      minLines: chat.composerMinLines,
                                      maxLines: chat.composerMaxLines,
                                      onChanged: (value) {
                                        _reportTyping(
                                          isTyping: value.trim().isNotEmpty,
                                        );
                                        _cubit.updatePlainText(value);
                                      },
                                      decoration: InputDecoration(
                                        hintText:
                                            context.l10n.globalChatComposerHint,
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                  controller: _richController,
                                  focusNode: _richFocusNode,
                                  scrollController: _richScrollController,
                                  onKeyEvent: _onEnterKey,
                                  maxHeight: editorMaxHeight,
                                ),
                        ),
                      ),
                      trailingActions:
                          context.read<ChatEmojiRecentCubit?>() == null
                          ? null
                          : ChatComposerActionButton(
                              key: _emojiAnchorKey,
                              icon: Symbols.emoji_emotions_rounded,
                              tooltip: context.l10n.chatComposerEmoji,
                              onPressed: () => unawaited(_pickEmoji()),
                            ),
                      send: ChatComposerSubmitButton(
                        coordinator: _attachmentCoordinator,
                        canSubmit: (attachmentState) =>
                            _canSubmit(state, attachmentState),
                        onSubmit: _submit,
                      ),
                    ),
                  ),
                ],
              ),
            );
            final coordinator = _attachmentCoordinator;
            return coordinator == null
                ? composer
                : ChatAttachmentDropRegion(
                    coordinator: coordinator,
                    conversationId: widget.conversationId,
                    child: composer,
                  );
          },
        );
      },
    ),
  );

  bool _canSubmit(ChatComposerState state, Object? attachmentState) {
    final uploadReady =
        attachmentState is! ChatAttachmentComposerCoordinatorPreparing &&
        attachmentState is! ChatAttachmentComposerCoordinatorFailed &&
        attachmentState
            is! ChatAttachmentComposerCoordinatorAwaitingConfirmation;
    if (!uploadReady) return false;
    // Pusta treść jest poprawna tylko z gotowym załącznikiem; inaczej nie ma
    // czego wysłać i wysyłka zostałaby bez odpowiedzi.
    final readyAttachments =
        attachmentState is ChatAttachmentComposerCoordinatorReady;
    return !_preparingSnippet &&
        (!state.draft.isEmpty ||
            (readyAttachments && attachmentState.attachmentIds.isNotEmpty));
  }
}
