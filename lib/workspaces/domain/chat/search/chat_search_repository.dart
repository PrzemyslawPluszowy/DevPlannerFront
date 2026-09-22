import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';

/// Port wyszukiwania wiadomości i podpowiedzi wzmianek.
///
/// Wyniki są ograniczone do rozmów, do których użytkownik ma dostęp; backend
/// ponownie autoryzuje każde zapytanie, a `429` wymaga respektowania
/// `Retry-After`.
abstract interface class ChatSearchRepository {
  /// Przeszukuje wiadomości dostępnych rozmów.
  Future<Either<ApiError, ChatSearchPage>> searchMessages(
    ChatSearchQuery query,
  );

  /// Zwraca agregaty i facety dostępne dla bieżącego użytkownika.
  Future<Either<ApiError, ChatSearchFacets>> loadFacets({
    required String term,
    String? conversationId,
  });

  /// Zwraca podpowiedzi wzmianek w rozmowie, filtrowane po zakresie dostępu.
  Future<Either<ApiError, List<ChatMentionSuggestion>>> suggestMentions({
    required String conversationId,
    required String term,
  });
}
