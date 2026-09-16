import 'package:equatable/equatable.dart';

/// Globalne kanały dostarczania powiadomień Chat dla bieżącego użytkownika.
final class ChatNotificationSettings extends Equatable {
  /// Tworzy snapshot kanałów Chat.
  const ChatNotificationSettings({
    required this.coreUserId,
    required this.inAppEnabled,
    required this.emailEnabled,
    required this.pushEnabled,
    required this.digestEnabled,
  });

  final String coreUserId;
  final bool inAppEnabled;
  final bool emailEnabled;
  final bool pushEnabled;
  final bool digestEnabled;

  @override
  List<Object?> get props => [
    coreUserId,
    inAppEnabled,
    emailEnabled,
    pushEnabled,
    digestEnabled,
  ];
}

/// Częściowa zmiana globalnych kanałów Chat; null zachowuje obecną wartość.
final class UpdateChatNotificationSettingsCommand extends Equatable {
  /// Tworzy aktualizację wybranych kanałów.
  const UpdateChatNotificationSettingsCommand({
    this.inAppEnabled,
    this.emailEnabled,
    this.pushEnabled,
    this.digestEnabled,
  });

  final bool? inAppEnabled;
  final bool? emailEnabled;
  final bool? pushEnabled;
  final bool? digestEnabled;

  @override
  List<Object?> get props => [
    inAppEnabled,
    emailEnabled,
    pushEnabled,
    digestEnabled,
  ];
}

/// Polityka powiadomień użytkownika dla pojedynczej rozmowy.
enum ChatConversationNotificationMode { all, mentionsOnly, muted, highOnly }

/// Snapshot preferencji jednej rozmowy Chat.
final class ChatConversationNotificationSetting extends Equatable {
  /// Tworzy politykę rozmowy dla konkretnego użytkownika.
  const ChatConversationNotificationSetting({
    required this.conversationId,
    required this.coreUserId,
    required this.mode,
  });

  final String conversationId;
  final String coreUserId;
  final ChatConversationNotificationMode mode;

  @override
  List<Object?> get props => [conversationId, coreUserId, mode];
}
