import 'dart:convert';

import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Adapter keychain/keystore dla prywatnych draftów; nigdy nie używa Hive.
final class SecureChatDraftRepository implements ChatDraftRepository {
  SecureChatDraftRepository({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) async {
    String? value;
    try {
      value = await _storage.read(key: _key(userId, conversationId));
    } on Exception {
      // Brak keychaina/WebCrypto nie może prowadzić do fallbacku plaintext.
      return null;
    }
    if (value == null || value.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic>) return null;
      final attachments = decoded['attachmentIds'];
      return ChatComposerDraft(
        text: decoded['text'] as String? ?? '',
        deltaJson: decoded['deltaJson'] as String?,
        replyToMessageId: decoded['replyToMessageId'] as String?,
        attachmentIds: attachments is List
            ? attachments.whereType<String>().toList(growable: false)
            : const <String>[],
      );
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async {
    try {
      await _storage.write(
        key: _key(userId, conversationId),
        value: jsonEncode({
          'text': draft.text,
          'deltaJson': draft.deltaJson,
          'replyToMessageId': draft.replyToMessageId,
          'attachmentIds': draft.attachmentIds,
        }),
      );
    } on Exception {
      // Fail closed: nie przechowujemy kopii poza platformowym secure storage.
    }
  }

  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async {
    try {
      await _storage.delete(key: _key(userId, conversationId));
    } on Exception {
      // Niedostępny keychain oznacza brak trwałego cache, nigdy plaintext.
    }
  }

  String _key(String userId, String conversationId) =>
      'devplanner.chat_draft.v1.${Uri.encodeComponent(userId)}.${Uri.encodeComponent(conversationId)}';
}
