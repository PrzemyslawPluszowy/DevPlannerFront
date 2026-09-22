import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';

/// Kontrakt historii i dostawy jednej rozmowy, odseparowany od listy drawera.
abstract interface class ChatConversationRepository {
  /// Pobiera aktualny snapshot rozmowy oraz sprawdza jej bieżące uprawnienia.
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  );

  /// Pobiera stronę historii bez ukrywania kursora zwróconego przez backend.
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  });

  /// Pobiera okno historii wokół wskazanej wiadomości.
  ///
  /// Pozwala otworzyć starą wiadomość niezależnie od bieżącego kursora i liczby
  /// stron. Brak dostępu albo nieistniejąca wiadomość w tej rozmowie wracają
  /// wspólnym błędem, więc UI pokazuje komunikat odmowy/braku, a nie pustą listę.
  Future<Either<ApiError, ChatMessageWindow>> loadMessageWindow({
    required String conversationId,
    required String messageId,
    int before = 20,
    int after = 20,
  });

  /// Wysyła intencję o stabilnym `clientMessageId` dla idempotentnego retry.
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  );

  /// Oznacza wiadomość jako doręczoną do bieżącego odbiorcy.
  ///
  /// Sukces HTTP `send` nie jest dowodem doręczenia, więc dostawa ma osobny
  /// lifecycle i osobne wywołanie.
  Future<Either<ApiError, void>> markMessageDelivered({
    required String messageId,
  });

  /// Oznacza wiadomość jako odczytaną przez bieżącego użytkownika.
  ///
  /// Wywołanie należy do widoku, który faktycznie pokazał wiadomość; samo
  /// pobranie historii nie może oznaczać odczytu.
  Future<Either<ApiError, void>> markConversationRead({
    required String conversationId,
    required String messageId,
  });
}
