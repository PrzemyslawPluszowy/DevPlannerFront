import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/notifications/models/notification_reply_command.dart';
import 'package:devplanner/workspaces/domain/notifications/notification_reply_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_client_message_id_factory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Niemutowalny stan krótkiego flow odpowiedzi z jednego powiadomienia.
sealed class NotificationReplyState {
  const NotificationReplyState();
}

/// Edytowalny draft. UUID jest zachowywany wyłącznie po nieudanej próbie.
final class NotificationReplyEditing extends NotificationReplyState {
  const NotificationReplyEditing({
    required this.text,
    this.deltaJson,
    this.clientMessageId,
    this.error,
  });

  final String text;
  final String? deltaJson;
  final String? clientMessageId;
  final ApiError? error;

  bool get canSend => text.trim().isNotEmpty;
}

/// Trwa pojedyncza próba wysłania; ekran nie może uruchomić drugiej.
final class NotificationReplySending extends NotificationReplyState {
  const NotificationReplySending({
    required this.text,
    required this.clientMessageId,
    this.deltaJson,
  });

  final String text;
  final String? deltaJson;
  final String clientMessageId;
}

/// Odpowiedź została potwierdzona przez backend i może odświeżyć inbox.
final class NotificationReplySucceeded extends NotificationReplyState {
  const NotificationReplySucceeded(this.message);

  final ChatMessage message;
}

/// 401/403 usuwa lokalny tekst, Delta i UUID, aby nie zachować prywatnego draftu.
final class NotificationReplyAccessRevoked extends NotificationReplyState {
  const NotificationReplyAccessRevoked(this.error);

  final ApiError error;
}

/// Mały owner wysyłki reply-from-notification bez zależności od rozmowy Chat.
///
/// Retry ponawia dokładnie ten sam `clientMessageId`. Zmiana treści po błędzie
/// tworzy nową intencję i dlatego usuwa poprzedni UUID idempotencyjny.
final class NotificationReplyCubit extends Cubit<NotificationReplyState> {
  NotificationReplyCubit({
    required this.repository,
    required this.notificationId,
    ChatClientMessageIdFactory? clientMessageIdFactory,
  }) : _clientMessageIdFactory =
           clientMessageIdFactory ?? ChatClientMessageIdFactory(),
       super(const NotificationReplyEditing(text: ''));

  final NotificationReplyRepository repository;
  final String notificationId;
  final ChatClientMessageIdFactory _clientMessageIdFactory;

  /// Aktualizuje prostą treść i unieważnia UUID poprzedniej nieudanej próby.
  void updatePlainText(String text) => _replaceDraft(text: text);

  /// Aktualizuje treść Rich Text oraz serializowany Delta bez odwołań do UI.
  void updateRichText({required String text, required String deltaJson}) =>
      _replaceDraft(text: text, deltaJson: deltaJson);

  /// Wysyła nową intencję albo powtarza zachowaną po przejściowym błędzie.
  Future<void> send() async {
    final current = state;
    if (current is! NotificationReplyEditing || !current.canSend) return;
    final clientMessageId =
        current.clientMessageId ?? _clientMessageIdFactory.create();
    final sending = NotificationReplySending(
      text: current.text,
      deltaJson: current.deltaJson,
      clientMessageId: clientMessageId,
    );
    emit(sending);
    final result = await repository.reply(
      NotificationReplyCommand(
        notificationId: notificationId,
        clientMessageId: clientMessageId,
        text: sending.text,
        deltaJson: sending.deltaJson,
      ),
    );
    if (isClosed || state != sending) return;
    result.fold(
      _handleFailure,
      (message) => emit(NotificationReplySucceeded(message)),
    );
  }

  void _replaceDraft({required String text, String? deltaJson}) {
    final current = state;
    if (current is NotificationReplySending ||
        current is NotificationReplyAccessRevoked ||
        current is NotificationReplySucceeded) {
      return;
    }
    emit(NotificationReplyEditing(text: text, deltaJson: deltaJson));
  }

  void _handleFailure(ApiError error) {
    final current = state;
    if (current is! NotificationReplySending) return;
    if (error.type == ApiErrorType.unauthorized ||
        error.type == ApiErrorType.forbidden) {
      emit(NotificationReplyAccessRevoked(error));
      return;
    }
    emit(
      NotificationReplyEditing(
        text: current.text,
        deltaJson: current.deltaJson,
        clientMessageId: current.clientMessageId,
        error: error,
      ),
    );
  }
}
