import 'package:equatable/equatable.dart';

/// Własny status użytkownika w komunikatorze.
final class ChatUserStatus extends Equatable {
  /// Tworzy status zwrócony przez backend.
  const ChatUserStatus({
    required this.userId,
    required this.isDnd,
    required this.updatedAtUtc,
    this.emoji,
    this.text,
    this.expiresAtUtc,
  });

  final String userId;
  final String? emoji;
  final String? text;
  final DateTime? expiresAtUtc;
  final bool isDnd;
  final DateTime updatedAtUtc;

  /// Czy status wygasł względem podanego czasu.
  bool isExpiredAt(DateTime nowUtc) {
    final expiry = expiresAtUtc;
    return expiry != null && !expiry.isAfter(nowUtc);
  }

  @override
  List<Object?> get props => [
    userId,
    emoji,
    text,
    expiresAtUtc,
    isDnd,
    updatedAtUtc,
  ];
}

/// Żądanie ustawienia własnego statusu.
final class ChatUserStatusUpdate extends Equatable {
  /// Tworzy żądanie aktualizacji statusu.
  const ChatUserStatusUpdate({
    this.emoji,
    this.text,
    this.expiresAtUtc,
    this.isDnd = false,
  });

  final String? emoji;
  final String? text;
  final DateTime? expiresAtUtc;
  final bool isDnd;

  @override
  List<Object?> get props => [emoji, text, expiresAtUtc, isDnd];
}
