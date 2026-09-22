import 'dart:convert';

import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Magazyn oczekujących wysyłek Chatu.
///
/// Desktop utrwala intencje w systemowym secure storage, więc restart aplikacji
/// nie gubi treści wpisanej offline. Web celowo nie utrwala niczego: przeglądarka
/// nie ma magazynu, który uznalibyśmy za bezpieczny dla treści prywatnych, więc
/// ograniczenie offline na Web jest jawne, a nie ukryte za nieszyfrowanym
/// `localStorage`.
final class ChatPendingSendStoreImpl implements ChatPendingSendStore {
  /// Tworzy magazyn na systemowym secure storage.
  ChatPendingSendStoreImpl({FlutterSecureStorage? storage, bool? isWeb})
    : _storage = storage ?? const FlutterSecureStorage(),
      _isWeb = isWeb ?? kIsWeb;

  final FlutterSecureStorage _storage;
  final bool _isWeb;

  /// Czy ten magazyn utrwala intencje między uruchomieniami.
  bool get isDurable => !_isWeb;

  @override
  Future<List<PendingChatSend>> read({
    required String userId,
    String? conversationId,
  }) async {
    if (!isDurable) return const <PendingChatSend>[];
    try {
      final raw = await _storage.read(key: _key(userId));
      if (raw == null || raw.trim().isEmpty) return const <PendingChatSend>[];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const <PendingChatSend>[];
      return decoded
          .whereType<Map<String, Object?>>()
          .map(PendingChatSend.fromJson)
          .whereType<PendingChatSend>()
          .where(
            (pending) =>
                conversationId == null ||
                pending.conversationId == conversationId,
          )
          .toList(growable: false);
    } on Exception {
      // Brak dostępu do keychaina oznacza brak trwałej kolejki, nigdy plaintext.
      return const <PendingChatSend>[];
    }
  }

  @override
  Future<void> save({
    required String userId,
    required PendingChatSend pending,
  }) async {
    if (!isDurable) return;
    final current = await read(userId: userId);
    final updated = <PendingChatSend>[
      for (final entry in current)
        if (entry.clientMessageId != pending.clientMessageId) entry,
      pending,
    ];
    await _write(userId: userId, pending: updated);
  }

  @override
  Future<void> remove({
    required String userId,
    required String clientMessageId,
  }) async {
    if (!isDurable) return;
    final current = await read(userId: userId);
    final updated = current
        .where((entry) => entry.clientMessageId != clientMessageId)
        .toList(growable: false);
    if (updated.length == current.length) return;
    await _write(userId: userId, pending: updated);
  }

  @override
  Future<void> clearForUser({required String userId}) async {
    if (!isDurable) return;
    try {
      await _storage.delete(key: _key(userId));
    } on Exception {
      // Brak dostępu do keychaina nie może blokować wylogowania.
    }
  }

  Future<void> _write({
    required String userId,
    required List<PendingChatSend> pending,
  }) async {
    try {
      await _storage.write(
        key: _key(userId),
        value: jsonEncode(
          pending.map((entry) => entry.toJson()).toList(growable: false),
        ),
      );
    } on Exception {
      // Zapis do niedostępnego keychaina nie może przerwać wysyłki w pamięci.
    }
  }

  String _key(String userId) =>
      'devplanner.chat_pending_send.v1.${Uri.encodeComponent(userId)}';
}
