import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';

/// Zmiana publicznego statusu uczestnika odebrana w aktywnej rozmowie.
///
/// `status == null` oznacza jawne wyczyszczenie albo wygaśnięcie statusu.
final class ChatUserStatusChanged {
  /// Tworzy typowaną zmianę statusu.
  const ChatUserStatusChanged({required this.userId, required this.status});

  /// UUID użytkownika, którego dotyczy zmiana.
  final String userId;

  /// Nowy status lub `null`, gdy backend go usunął.
  final ChatUserStatus? status;
}
