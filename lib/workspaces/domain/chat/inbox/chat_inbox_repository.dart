import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';

/// Port serwerowej skrzynki rozmów Chat.
///
/// Port jest osobny od historii i wysyłki, bo skrzynka ma własny kontrakt:
/// serwerowy licznik nieprzeczytanych, kursory i znacznik odczytu. Dzięki temu
/// panel nie pobiera wszystkich wiadomości, aby policzyć badge.
abstract interface class ChatInboxRepository {
  /// Pobiera stronę skrzynki w stabilnej kolejności ostatniej aktywności.
  Future<Either<ApiError, ChatInboxPage>> loadInbox({
    ChatInboxFilter filter = ChatInboxFilter.all,
    String? cursor,
    int limit,
    String? query,
  });

  /// Pobiera agregat nieprzeczytanych wiadomości bez pobierania stron.
  Future<Either<ApiError, ChatInboxUnreadCount>> loadUnreadCount();

  /// Oznacza wiadomość jako odczytaną po faktycznym zobaczeniu jej w panelu.
  ///
  /// Wywołanie jest częścią portu, ponieważ zmienia serwerowy licznik skrzynki;
  /// UI nie może oznaczać odczytu przy samym pobraniu historii.
  Future<Either<ApiError, void>> markRead({
    required String conversationId,
    required String messageId,
  });
}
