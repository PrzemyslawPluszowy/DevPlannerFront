import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:equatable/equatable.dart';

/// Rodzaj statusu wiadomości pokazywany w dymku.
enum ChatMessageStatusKind {
  /// Lokalna próba wysyłki trwa.
  sending,

  /// Serwer potwierdził zapis wiadomości, ale żaden odbiorca nie potwierdził dostawy.
  sent,

  /// Serwer potwierdził dostawę co najmniej do jednego odbiorcy.
  delivered,

  /// Co najmniej jeden odbiorca odczytał wiadomość (serwerowe potwierdzenie).
  read,

  /// Wysyłka nie powiodła się i można ją ponowić.
  failed,
}

/// Status wiadomości widoczny w dymku.
final class ChatMessageStatusView extends Equatable {
  /// Tworzy opis statusu.
  const ChatMessageStatusView({
    required this.kind,
    required this.canRetry,
    this.count = 0,
  });

  final ChatMessageStatusKind kind;

  /// Czy UI może zaproponować ponowienie wysyłki.
  final bool canRetry;

  /// Liczba potwierdzonych odbiorców dla statusów `delivered`/`read`.
  final int count;

  @override
  List<Object?> get props => [kind, canRetry, count];
}

/// Metadane dymka: godzina i status wysyłki.
///
/// Status pokazujemy wyłącznie dla własnych, nieusuniętych wiadomości, bo tylko
/// one mają lokalny lifecycle wysyłki. Nic nie jest zgadywane: brak potwierdzenia
/// serwera to „wysyłanie”, a błąd to jawna porażka z ponowieniem.
abstract final class ChatMessageMetadata {
  /// Krótka godzina wiadomości w czasie lokalnym (`HH:mm`).
  static String timeLabel(DateTime createdAtUtc) {
    final local = createdAtUtc.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Status własnej wiadomości albo `null`, gdy nie ma czego pokazywać.
  ///
  /// Dostawa i odczyt pochodzą wyłącznie z serwerowych znaczników odbiorców;
  /// gdy ich brak, wiadomość pozostaje „wysłana”, a nie „dostarczona”.
  static ChatMessageStatusView? statusFor({
    required ChatMessage message,
    required bool isOwn,
  }) {
    if (!isOwn || message.isDeleted) return null;
    return switch (message.deliveryState) {
      ChatMessageDeliveryState.sending => const ChatMessageStatusView(
        kind: ChatMessageStatusKind.sending,
        canRetry: false,
      ),
      ChatMessageDeliveryState.failed => const ChatMessageStatusView(
        kind: ChatMessageStatusKind.failed,
        canRetry: true,
      ),
      ChatMessageDeliveryState.sent when message.readByCount > 0 =>
        ChatMessageStatusView(
          kind: ChatMessageStatusKind.read,
          canRetry: false,
          count: message.readByCount,
        ),
      ChatMessageDeliveryState.sent when message.deliveredToCount > 0 =>
        ChatMessageStatusView(
          kind: ChatMessageStatusKind.delivered,
          canRetry: false,
          count: message.deliveredToCount,
        ),
      ChatMessageDeliveryState.sent => const ChatMessageStatusView(
        kind: ChatMessageStatusKind.sent,
        canRetry: false,
      ),
    };
  }
}
