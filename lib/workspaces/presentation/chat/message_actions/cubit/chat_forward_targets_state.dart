import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_item.dart';

/// Stan wyszukiwania rozmów w pickerze przekazywania wiadomości.
sealed class ChatForwardTargetsState {
  const ChatForwardTargetsState();
}

/// Trwa pobieranie pierwszej strony dla bieżącego zapytania.
final class ChatForwardTargetsLoading extends ChatForwardTargetsState {
  const ChatForwardTargetsLoading(this.query);

  final String? query;
}

/// Wyniki z opcjonalnym kursorem dalszych stron.
final class ChatForwardTargetsReady extends ChatForwardTargetsState {
  const ChatForwardTargetsReady({
    required this.items,
    required this.query,
    required this.hasMore,
    this.nextCursor,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<ChatInboxItem> items;
  final String? query;
  final bool hasMore;
  final String? nextCursor;
  final bool isLoadingMore;
  final ApiError? loadMoreError;
}

/// Brak wyników po uwzględnieniu wykluczonej rozmowy źródłowej.
final class ChatForwardTargetsEmpty extends ChatForwardTargetsState {
  const ChatForwardTargetsEmpty(this.query);

  final String? query;
}

/// Nie udało się pobrać pierwszej strony.
final class ChatForwardTargetsFailure extends ChatForwardTargetsState {
  const ChatForwardTargetsFailure({required this.query, required this.error});

  final String? query;
  final ApiError error;
}
