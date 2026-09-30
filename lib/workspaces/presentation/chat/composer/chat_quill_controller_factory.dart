// The clipboard hook is currently marked experimental by flutter_quill. Chat
// uses it narrowly to normalize pasted Delta before it reaches the strict API
// contract; without this hook normal formatted paste could fail with HTTP 400.
// ignore_for_file: experimental_member_use

import 'dart:convert';

import 'package:devplanner/workspaces/domain/chat/rich_text/chat_delta_contract_sanitizer.dart';
import 'package:flutter/material.dart' show TextSelection;
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Buduje kontrolery Quill z polityką wklejania zgodną z API i historią Chat.
abstract final class ChatQuillControllerFactory {
  static final quill.QuillControllerConfig _config =
      quill.QuillControllerConfig(
        clipboardConfig: quill.QuillClipboardConfig(
          onRichTextPaste: (delta, _) async => quill.Document.fromJson(
            ChatDeltaContractSanitizer.sanitize(delta.toJson()),
          ).toDelta(),
        ),
      );

  /// Normalizuje szkic do tych samych operacji, które akceptuje API wiadomości.
  static ({List<Object?> operations, String text, String json})? normalizeDelta(
    String? deltaJson,
  ) {
    if (deltaJson == null) return null;
    try {
      final decoded = jsonDecode(deltaJson);
      if (decoded is! List) return null;
      final document = quill.Document.fromJson(
        ChatDeltaContractSanitizer.sanitize(decoded),
      );
      final operations = document.toDelta().toJson().cast<Object?>();
      return (
        operations: operations,
        text: document.toPlainText().trimRight(),
        json: jsonEncode(operations),
      );
    } on FormatException {
      return null;
    }
  }

  /// Tworzy pusty kontroler composera.
  static quill.QuillController create() =>
      quill.QuillController.basic(config: _config);

  /// Tworzy kontroler dokumentu po normalizacji szkicu/importowanej Delty.
  static quill.QuillController fromOperations(
    List<Object?> operations, {
    required TextSelection selection,
  }) => quill.QuillController(
    document: quill.Document.fromJson(
      ChatDeltaContractSanitizer.sanitize(operations),
    ),
    selection: selection,
    config: _config,
  );
}
