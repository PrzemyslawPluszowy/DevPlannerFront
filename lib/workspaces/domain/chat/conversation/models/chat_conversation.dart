import 'package:equatable/equatable.dart';

/// Niezależny od transportu opis rozmowy, który może bezpiecznie czytać UI.
final class ChatConversation extends Equatable {
  /// Tworzy snapshot rozmowy zwrócony przez backend Workspaces.
  const ChatConversation({
    required this.id,
    required this.type,
    required this.scopeKind,
    required this.scopeKey,
    required this.version,
    required this.createdAtUtc,
    required this.postingPermission,
    required this.isArchived,
    this.workspaceId,
    this.projectId,
    this.name,
    this.discussionRootMessageId,
  });

  final String id;
  final String type;
  final String scopeKind;
  final String scopeKey;
  final String? workspaceId;
  final String? projectId;
  final String? name;
  final String? discussionRootMessageId;
  final int version;
  final DateTime createdAtUtc;
  final String postingPermission;
  final bool isArchived;

  @override
  List<Object?> get props => [
    id,
    type,
    scopeKind,
    scopeKey,
    workspaceId,
    projectId,
    name,
    discussionRootMessageId,
    version,
    createdAtUtc,
    postingPermission,
    isArchived,
  ];
}
