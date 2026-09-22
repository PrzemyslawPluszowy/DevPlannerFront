import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_item.dart';
import 'package:equatable/equatable.dart';

/// Strona serwerowej skrzynki rozmów.
final class ChatInboxPage extends Equatable {
  /// Tworzy stronę skrzynki zwróconą przez backend Workspaces.
  const ChatInboxPage({
    required this.items,
    required this.hasMore,
    this.nextCursor,
  });

  final List<ChatInboxItem> items;

  /// Kursor następnej strony; `null` oznacza koniec listy.
  final String? nextCursor;
  final bool hasMore;

  /// Pusta strona bez dalszych stron.
  static const empty = ChatInboxPage(items: <ChatInboxItem>[], hasMore: false);

  @override
  List<Object?> get props => [items, nextCursor, hasMore];
}
