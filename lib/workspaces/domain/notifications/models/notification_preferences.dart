import 'package:equatable/equatable.dart';

/// Kanał e-mail, w którym użytkownik chce otrzymywać daną kategorię zdarzeń.
enum NotificationEmailDeliveryMode { none, immediate, dailyDigest, digest }

/// Kategoria globalnej polityki dostarczania powiadomień.
enum NotificationDeliveryCategory {
  invitation,
  membership,
  workspace,
  project,
  task,
  comment,
  chat,
  storage,
  system,
}

/// Ustawienie dostarczania e-mail dla wszystkich kategorii użytkownika.
final class NotificationDeliveryPreferences extends Equatable {
  /// Tworzy snapshot globalnych preferencji dostarczania.
  NotificationDeliveryPreferences({
    required this.coreUserId,
    required Map<NotificationDeliveryCategory, NotificationEmailDeliveryMode>
    modes,
    required this.updatedAtUtc,
  }) : modes = Map.unmodifiable(modes);

  final String coreUserId;
  final Map<NotificationDeliveryCategory, NotificationEmailDeliveryMode> modes;
  final DateTime updatedAtUtc;

  @override
  List<Object?> get props => [coreUserId, modes, updatedAtUtc];
}

/// Zmiana wybranych preferencji dostarczania; null oznacza brak zmiany.
final class UpdateNotificationDeliveryPreferencesCommand extends Equatable {
  /// Tworzy częściową zmianę polityki e-mailowej.
  const UpdateNotificationDeliveryPreferencesCommand({
    this.invitation,
    this.membership,
    this.workspace,
    this.project,
    this.task,
    this.comment,
    this.chat,
    this.storage,
    this.system,
  });

  final NotificationEmailDeliveryMode? invitation;
  final NotificationEmailDeliveryMode? membership;
  final NotificationEmailDeliveryMode? workspace;
  final NotificationEmailDeliveryMode? project;
  final NotificationEmailDeliveryMode? task;
  final NotificationEmailDeliveryMode? comment;
  final NotificationEmailDeliveryMode? chat;
  final NotificationEmailDeliveryMode? storage;
  final NotificationEmailDeliveryMode? system;

  @override
  List<Object?> get props => [
    invitation,
    membership,
    workspace,
    project,
    task,
    comment,
    chat,
    storage,
    system,
  ];
}

/// Skuteczny tryb powiadomień o plikach Storage dla bieżącego użytkownika.
enum StorageNotificationMode { immediate, digest, mentionsOnly, disabled }

/// Snapshot osobistej preferencji powiadomień Storage.
final class StorageNotificationPreference extends Equatable {
  /// Tworzy skuteczną preferencję Storage wraz z jej źródłem.
  const StorageNotificationPreference({
    required this.coreUserId,
    required this.mode,
    required this.isDefault,
    this.updatedAtUtc,
  });

  final String coreUserId;
  final StorageNotificationMode mode;
  final bool isDefault;
  final DateTime? updatedAtUtc;

  @override
  List<Object?> get props => [coreUserId, mode, isDefault, updatedAtUtc];
}
