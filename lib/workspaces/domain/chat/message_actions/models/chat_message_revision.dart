import 'package:equatable/equatable.dart';

/// Niezmienny snapshot poprzedniej wersji wiadomości, niezależny od DTO API.
final class ChatMessageRevision extends Equatable {
  /// Tworzy rewizję zwróconą przez autoryzowaną historię backendu.
  const ChatMessageRevision({
    required this.id,
    required this.messageId,
    required this.authorUserId,
    required this.editedByUserId,
    required this.text,
    required this.createdAtUtc,
    required this.version,
    required this.newVersion,
    this.deltaJson,
  });

  final String id;
  final String messageId;

  /// Local UserId autora poprzedniej treści.
  final String authorUserId;

  /// Local UserId użytkownika, który dokonał edycji.
  final String editedByUserId;
  final String text;
  final String? deltaJson;
  final DateTime createdAtUtc;
  final int version;
  final int newVersion;

  @override
  List<Object?> get props => [
    id,
    messageId,
    authorUserId,
    editedByUserId,
    text,
    deltaJson,
    createdAtUtc,
    version,
    newVersion,
  ];
}
