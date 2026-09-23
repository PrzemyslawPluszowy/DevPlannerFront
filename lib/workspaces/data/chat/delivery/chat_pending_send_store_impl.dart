import 'dart:async';
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
  final Map<String, Future<void>> _operationTails = <String, Future<void>>{};

  /// Czy ten magazyn utrwala intencje między uruchomieniami.
  bool get isDurable => !_isWeb;

  @override
  Future<List<PendingChatSend>> read({
    required String userId,
    String? conversationId,
  }) {
    if (!isDurable) return Future.value(const <PendingChatSend>[]);
    return _serializeOperation(
      userId,
      () => _readFromStorage(userId: userId, conversationId: conversationId),
    );
  }

  Future<List<PendingChatSend>> _readFromStorage({
    required String userId,
    String? conversationId,
  }) async {
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
  }) => _serializeOperation(userId, () async {
    if (!isDurable) return;
    final current = await _readFromStorage(userId: userId);
    final updated = <PendingChatSend>[
      for (final entry in current)
        if (entry.clientMessageId != pending.clientMessageId) entry,
      pending,
    ];
    await _write(userId: userId, pending: updated);
  });

  @override
  Future<void> remove({
    required String userId,
    required String clientMessageId,
  }) => _serializeOperation(userId, () async {
    if (!isDurable) return;
    final current = await _readFromStorage(userId: userId);
    final updated = current
        .where((entry) => entry.clientMessageId != clientMessageId)
        .toList(growable: false);
    if (updated.length == current.length) return;
    await _write(userId: userId, pending: updated);
  });

  @override
  Future<void> clearForUser({required String userId}) =>
      _serializeOperation<void>(userId, () async {
        if (!isDurable) return;
        try {
          await _storage.delete(key: _key(userId));
        } on Exception {
          // Brak dostępu do keychaina nie może blokować wylogowania.
        }
      });

  /// Serializes read-modify-write operations for the keychain record belonging
  /// to one user. Secure-storage writes are asynchronous and may finish out of
  /// order: a late `save` after `remove` would otherwise resurrect a confirmed
  /// send (or a late `save` after logout would restore private draft content).
  Future<T> _serializeOperation<T>(
    String userId,
    Future<T> Function() operationBody,
  ) {
    final previous = _operationTails[userId] ?? Future<void>.value();
    final operation = previous.then((_) => operationBody());
    final settled = operation.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );
    _operationTails[userId] = settled;
    unawaited(
      settled.whenComplete(() {
        if (identical(_operationTails[userId], settled)) {
          final removed = _operationTails.remove(userId);
          if (removed != null) unawaited(removed);
        }
      }),
    );
    return operation;
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
