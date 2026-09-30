import 'dart:async';
import 'dart:convert';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/rich_text/chat_code_block_codec.dart';
import 'package:devplanner/workspaces/domain/chat/rich_text/chat_delta_contract_sanitizer.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_keyboard_policy.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_composer_mention_controller.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_format_actions.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_format_commands.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_quill_controller_factory.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/cubit/chat_composer_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/chat_emoji_picker.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_code_block_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:material_symbols_icons/symbols.dart';

/// Właściciel pól edycji, dokumentu Quill i interakcji klawiaturowych.
///
/// Kontrolery tekstu mają ten sam lifecycle co composer. Ten obiekt rozdziela
/// edycję od integracji z uploadem, szkicem i widokiem wiadomości.
final class ChatComposerEditorController {
  ChatComposerEditorController({
    required this.cubit,
    required this.conversationId,
    required this.mentionAllEnabled,
    required this.contextProvider,
    required this.mountedProvider,
    required this.onSubmit,
    required this.onPaste,
    required quill.QuillController? externalRichController,
    required ChatSearchRepository? searchRepository,
  }) : _ownsRichController = externalRichController == null,
       _richController =
           externalRichController ?? ChatQuillControllerFactory.create() {
    _richController.addListener(_onRichTextChanged);
    if (searchRepository case final repository?) {
      _mentionController = ChatComposerMentionController(
        cubit: cubit,
        textController: plainController,
        repository: repository,
        conversationId: conversationId,
        allTokenEnabled: mentionAllEnabled,
        contextProvider: contextProvider,
      );
    }
  }

  final ChatComposerCubit cubit;
  final String conversationId;
  final bool mentionAllEnabled;
  final BuildContext Function() contextProvider;
  final bool Function() mountedProvider;
  final VoidCallback onSubmit;
  final Future<void> Function() onPaste;
  final ChatComposerKeyboardPolicy _keyboardPolicy =
      ChatComposerKeyboardPolicy();
  final GlobalKey emojiAnchorKey = GlobalKey();
  final TextEditingController plainController = TextEditingController();
  final FocusNode plainFocusNode = FocusNode();
  final FocusNode richFocusNode = FocusNode();
  final ScrollController richScrollController = ScrollController();
  late final bool _ownsRichController;
  late quill.QuillController _richController;
  ChatComposerMentionController? _mentionController;
  bool _disposed = false;

  BuildContext get _context => contextProvider();
  bool get _mounted => !_disposed && mountedProvider();
  quill.QuillController get richController => _richController;
  ChatComposerMentionController? get mentionController => _mentionController;

  void updatePlainText(String value) => cubit.updatePlainText(value);

  void restoreDelta(String? deltaJson) {
    final normalized = ChatQuillControllerFactory.normalizeDelta(deltaJson);
    if (normalized == null) return;
    _replaceRichDocument(normalized.operations);
    if (normalized.json != deltaJson) {
      cubit.updateRichText(text: normalized.text, deltaJson: normalized.json);
    }
    cubit.selectMode(ChatComposerMode.richText);
  }

  void resetAfterAccessRevoked() {
    plainController.clear();
    _replaceRichDocument(const <Object>[
      {'insert': '\n'},
    ]);
  }

  Future<void> insertCode() async {
    final input = await ChatCodeBlockDialog.show(_context);
    if (input == null || !_mounted) return;
    if (cubit.state.mode == ChatComposerMode.plainText) {
      selectMode(ChatComposerMode.richText);
    }
    final selection = _richController.selection;
    final index = selection.isValid && selection.start >= 0
        ? selection.start
        : _richController.document.length - 1;
    final length = selection.isValid && !selection.isCollapsed
        ? selection.end - selection.start
        : 0;
    final plainText = _richController.document.toPlainText();
    final precedingText = plainText.substring(
      0,
      index.clamp(0, plainText.length),
    );
    final ops = ChatCodeBlockCodec.buildInsertion(
      code: input.code,
      language: input.language,
      precedingText: precedingText,
    );
    if (ops.isEmpty) return;
    _richController.replaceText(
      index,
      length,
      quill.Document.fromJson(ops).toDelta(),
      null,
    );
    _onRichTextChanged();
    richFocusNode.requestFocus();
  }

  void acceptMention(ChatMentionSuggestion suggestion) =>
      _mentionController?.accept(suggestion);

  void acceptAllMention() => _mentionController?.acceptAll();

  KeyEventResult onEnterKey(FocusNode node, KeyEvent event) {
    final picker = _mentionController?.picker;
    if (event is KeyDownEvent &&
        picker != null &&
        picker.isOpen &&
        cubit.state.mode == ChatComposerMode.plainText) {
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
      final active = picker.active;
      if (key == LogicalKeyboardKey.enter && active != null) {
        acceptMention(active);
        return KeyEventResult.handled;
      }
    }
    final commandModifier =
        HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;
    if (event is KeyDownEvent &&
        cubit.state.mode == ChatComposerMode.richText &&
        commandModifier &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      onSubmit();
      return KeyEventResult.handled;
    }
    if (event is KeyDownEvent &&
        cubit.state.mode == ChatComposerMode.richText &&
        commandModifier) {
      final shortcut = switch (event.logicalKey) {
        LogicalKeyboardKey.keyB => ChatFormatCommand.bold,
        LogicalKeyboardKey.keyI => ChatFormatCommand.italic,
        _ => null,
      };
      if (shortcut != null) {
        unawaited(
          applyFormatCommand(
            _context,
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
        cubit.state.mode == ChatComposerMode.plainText) {
      insertPlainNewline();
      return KeyEventResult.handled;
    }
    if (cubit.state.mode != ChatComposerMode.plainText) {
      return KeyEventResult.ignored;
    }
    return _keyboardPolicy.handle(
      event: event,
      value: plainController.value,
      onSubmit: onSubmit,
    );
  }

  void insertPlainNewline() {
    _replacePlainSelection('\n');
    cubit.updatePlainText(plainController.text);
  }

  void selectMode(ChatComposerMode mode) {
    if (cubit.state.mode == mode) return;
    if (mode == ChatComposerMode.richText) {
      final richText = _richController.document.toPlainText().trimRight();
      if (plainController.text != richText) {
        _replaceRichPlainText(plainController.text);
      }
      final plainSelection = plainController.selection;
      final maxOffset = _richController.document.length - 1;
      final baseOffset = plainSelection.isValid
          ? plainSelection.baseOffset.clamp(0, maxOffset)
          : maxOffset;
      final extentOffset = plainSelection.isValid
          ? plainSelection.extentOffset.clamp(0, maxOffset)
          : maxOffset;
      _richController.updateSelection(
        TextSelection(
          baseOffset: baseOffset,
          extentOffset: extentOffset,
          affinity: plainSelection.affinity,
          isDirectional: plainSelection.isDirectional,
        ),
        quill.ChangeSource.local,
      );
    } else {
      plainController.text = _richController.document.toPlainText().trimRight();
    }
    cubit.selectMode(mode);
  }

  void toggleExpandedEditor() => selectMode(
    cubit.state.mode == ChatComposerMode.richText
        ? ChatComposerMode.plainText
        : ChatComposerMode.richText,
  );

  void replaceRichPlainText(String text) => _replaceRichPlainText(text);

  Future<void> pickEmoji(ChatEmojiRecentCubit? recent) async {
    if (recent == null) return;
    final emoji = await showChatEmojiPicker(
      _context,
      recent: recent,
      anchorKey: emojiAnchorKey,
    );
    if (emoji == null || !_mounted) return;
    insertText(emoji);
  }

  List<AppContextMenuAction> editorMenuActions(
    BuildContext context,
  ) => <AppContextMenuAction>[
    AppContextMenuAction(
      label: context.l10n.chatComposerPastePlain,
      icon: Symbols.content_paste,
      onTap: (_) => unawaited(onPaste()),
    ),
    AppContextMenuAction(
      label: context.l10n.chatComposerSelectAll,
      icon: Symbols.select_all,
      onTap: (_) => selectAll(),
    ),
  ];

  void selectAll() {
    if (cubit.state.mode == ChatComposerMode.plainText) {
      plainController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: plainController.text.length,
      );
      plainFocusNode.requestFocus();
      return;
    }
    final end = _richController.document.length - 1;
    _richController.updateSelection(
      TextSelection(baseOffset: 0, extentOffset: end < 0 ? 0 : end),
      quill.ChangeSource.local,
    );
    richFocusNode.requestFocus();
  }

  void insertText(String text) {
    if (cubit.state.mode == ChatComposerMode.plainText) {
      _replacePlainSelection(text);
      cubit.updatePlainText(plainController.text);
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
    focusEditor();
  }

  void focusEditor() {
    if (cubit.state.mode == ChatComposerMode.plainText) {
      plainFocusNode.requestFocus();
    } else {
      richFocusNode.requestFocus();
    }
  }

  void _replacePlainSelection(String text) {
    final value = plainController.value;
    final selection = value.selection;
    final start = selection.start < 0 ? value.text.length : selection.start;
    final end = selection.end < 0 ? value.text.length : selection.end;
    final updated = value.text.replaceRange(start, end, text);
    plainController.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + text.length),
    );
  }

  void _replaceRichPlainText(String text) {
    _replaceRichDocument(<Object>[
      {'insert': text.isEmpty ? '\n' : '$text\n'},
    ]);
    _onRichTextChanged();
  }

  void _replaceRichDocument(List<Object?> deltaJson) {
    final document = quill.Document.fromJson(
      ChatDeltaContractSanitizer.sanitize(deltaJson),
    );
    final replacement = ChatQuillControllerFactory.fromOperations(
      document.toDelta().toJson(),
      selection: TextSelection.collapsed(
        offset: document.toPlainText().trimRight().length,
      ),
    );
    if (!_ownsRichController) {
      _richController.replaceText(
        0,
        _richController.document.length - 1,
        replacement.document.toDelta(),
        replacement.selection,
      );
      replacement.dispose();
      return;
    }
    _richController.removeListener(_onRichTextChanged);
    _richController.dispose();
    _richController = replacement..addListener(_onRichTextChanged);
  }

  void _onRichTextChanged() {
    final document = _richController.document;
    cubit.updateRichText(
      text: document.toPlainText().trimRight(),
      deltaJson: jsonEncode(document.toDelta().toJson()),
    );
  }

  void dispose() {
    _disposed = true;
    _plainControllerCleanup();
  }

  void _plainControllerCleanup() {
    _mentionController?.dispose();
    plainController.dispose();
    plainFocusNode.dispose();
    richFocusNode.dispose();
    richScrollController.dispose();
    _richController.removeListener(_onRichTextChanged);
    if (_ownsRichController) _richController.dispose();
  }
}
