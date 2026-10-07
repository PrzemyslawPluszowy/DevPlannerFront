import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';

/// Snapshot czasu serwera; odbiór HTTP nie przedłuża świeżości danych.
final class ChatMembersPresenceSnapshot {
  ChatMembersPresenceSnapshot({
    required Map<String, bool> users,
    required this.snapshotAtUtc,
  }) : users = Map.unmodifiable(users);

  final Map<String, bool> users;
  final DateTime snapshotAtUtc;
}

/// Obecność aplikacyjna aktywnych uczestników rozmowy, po kontroli jej ACL.
// Typed ACL-bound port keeps HTTP out of presentation and is replaceable in tests.
// ignore: one_member_abstracts
abstract interface class ChatMembersPresenceRepository {
  Future<Either<ApiError, ChatMembersPresenceSnapshot>> loadMembersPresence(
    String conversationId,
  );
}
