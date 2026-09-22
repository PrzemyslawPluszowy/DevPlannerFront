import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';

/// Stan serwerowej skrzynki rozmów w panelu.
sealed class ChatInboxState {
  const ChatInboxState();
}

/// Pierwsza strona skrzynki jest w drodze.
final class ChatInboxLoading extends ChatInboxState {
  /// Tworzy stan ładowania pierwszej strony.
  const ChatInboxLoading();
}

/// Skrzynka ma co najmniej jedną pozycję.
final class ChatInboxReady extends ChatInboxState {
  /// Tworzy stan gotowej listy.
  const ChatInboxReady({
    required this.items,
    required this.filter,
    required this.unreadTotal,
    this.nextCursor,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  final List<ChatInboxItem> items;
  final ChatInboxFilter filter;

  /// Serwerowy licznik nieprzeczytanych dla belki i nagłówka panelu.
  final int unreadTotal;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  /// Tworzy kopię stanu z nowymi wartościami.
  ChatInboxReady copyWith({
    List<ChatInboxItem>? items,
    ChatInboxFilter? filter,
    int? unreadTotal,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    bool? isLoadingMore,
    bool? loadMoreFailed,
  }) => ChatInboxReady(
    items: items ?? this.items,
    filter: filter ?? this.filter,
    unreadTotal: unreadTotal ?? this.unreadTotal,
    nextCursor: clearNextCursor ? null : nextCursor ?? this.nextCursor,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
  );
}

/// Skrzynka nie ma pozycji dla bieżącego filtra i frazy.
final class ChatInboxEmpty extends ChatInboxState {
  /// Tworzy stan pustej skrzynki.
  const ChatInboxEmpty({required this.filter});

  final ChatInboxFilter filter;
}

/// Pierwszej strony nie udało się pobrać; UI pokazuje powód i ponowienie.
final class ChatInboxFailure extends ChatInboxState {
  /// Tworzy stan błędu z kodem domenowym błędu.
  const ChatInboxFailure(this.message);

  final String message;
}
