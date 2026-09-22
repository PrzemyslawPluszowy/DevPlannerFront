import 'package:equatable/equatable.dart';

/// Zapytanie wyszukiwania wiadomości widocznych dla bieżącego użytkownika.
final class ChatSearchQuery extends Equatable {
  /// Tworzy zapytanie wyszukiwania.
  const ChatSearchQuery({
    required this.term,
    this.conversationId,
    this.senderId,
    this.workspaceId,
    this.projectId,
    this.fromUtc,
    this.toUtc,
    this.mentionedUserId,
    this.limit = 50,
    this.cursor,
  });

  /// Fraza wyszukiwania; backend wymaga od 2 do 160 znaków.
  final String term;
  final String? conversationId;
  final String? senderId;
  final String? workspaceId;
  final String? projectId;
  final DateTime? fromUtc;
  final DateTime? toUtc;
  final String? mentionedUserId;
  final int limit;
  final String? cursor;

  @override
  List<Object?> get props => [
    term,
    conversationId,
    senderId,
    workspaceId,
    projectId,
    fromUtc,
    toUtc,
    mentionedUserId,
    limit,
    cursor,
  ];
}

/// Pojedynczy wynik wyszukiwania wiadomości.
final class ChatSearchHit extends Equatable {
  /// Tworzy wynik zwrócony przez backend.
  const ChatSearchHit({
    required this.messageId,
    required this.conversationId,
    required this.authorUserId,
    required this.text,
    required this.createdAtUtc,
    required this.hasMention,
    this.conversationName,
    this.highlight,
  });

  final String messageId;
  final String conversationId;
  final String authorUserId;

  /// Treść wiadomości z limitem backendu.
  final String text;

  /// Krótki fragment z oznaczeniem trafienia albo `null`.
  final String? highlight;
  final String? conversationName;
  final DateTime createdAtUtc;
  final bool hasMention;

  @override
  List<Object?> get props => [
    messageId,
    conversationId,
    authorUserId,
    text,
    highlight,
    conversationName,
    createdAtUtc,
    hasMention,
  ];
}

/// Strona wyników wyszukiwania.
final class ChatSearchPage extends Equatable {
  /// Tworzy stronę wyników.
  const ChatSearchPage({
    required this.hits,
    required this.totalApproximate,
    this.nextCursor,
  });

  final List<ChatSearchHit> hits;
  final String? nextCursor;
  final int totalApproximate;

  @override
  List<Object?> get props => [hits, nextCursor, totalApproximate];
}

/// Kubełek facetu wyszukiwania.
final class ChatSearchFacetBucket extends Equatable {
  /// Tworzy kubełek facetu.
  const ChatSearchFacetBucket({
    required this.id,
    required this.count,
    this.label,
  });

  final String id;
  final String? label;
  final int count;

  @override
  List<Object?> get props => [id, label, count];
}

/// Agregaty wyszukiwania dostępne dla bieżącego użytkownika.
final class ChatSearchFacets extends Equatable {
  /// Tworzy facety zwrócone przez backend.
  const ChatSearchFacets({
    required this.total,
    this.conversations = const <ChatSearchFacetBucket>[],
    this.senders = const <ChatSearchFacetBucket>[],
    this.workspaces = const <ChatSearchFacetBucket>[],
    this.projects = const <ChatSearchFacetBucket>[],
  });

  final int total;
  final List<ChatSearchFacetBucket> conversations;
  final List<ChatSearchFacetBucket> senders;
  final List<ChatSearchFacetBucket> workspaces;
  final List<ChatSearchFacetBucket> projects;

  @override
  List<Object?> get props => [
    total,
    conversations,
    senders,
    workspaces,
    projects,
  ];
}

/// Podpowiedź aktywnego lokalnego użytkownika do wzmianki.
final class ChatMentionSuggestion extends Equatable {
  /// Tworzy podpowiedź zwróconą przez backend.
  const ChatMentionSuggestion({
    required this.userId,
    required this.login,
    required this.displayName,
    this.avatarUrl,
  });

  final String userId;
  final String login;
  final String displayName;
  final String? avatarUrl;

  @override
  List<Object?> get props => [userId, login, displayName, avatarUrl];
}
