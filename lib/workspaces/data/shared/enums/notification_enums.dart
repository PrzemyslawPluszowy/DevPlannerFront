import 'package:json_annotation/json_annotation.dart';

/// Kategoria powiadomienia.
@JsonEnum(fieldRename: FieldRename.pascal)
enum NotificationCategory {
  invitation,
  membership,
  workspace,
  system,
  project,
  task,
  comment,
  chat,
  storage,
}

/// Stabilna reprezentacja tekstowa używana w query API.
extension NotificationCategoryWireValue on NotificationCategory {
  String get wireValue => switch (this) {
    NotificationCategory.invitation => 'Invitation',
    NotificationCategory.membership => 'Membership',
    NotificationCategory.workspace => 'Workspace',
    NotificationCategory.system => 'System',
    NotificationCategory.project => 'Project',
    NotificationCategory.task => 'Task',
    NotificationCategory.comment => 'Comment',
    NotificationCategory.chat => 'Chat',
    NotificationCategory.storage => 'Storage',
  };
}

/// Priorytet dostarczenia powiadomienia.
@JsonEnum(fieldRename: FieldRename.pascal)
enum NotificationPriority { low, normal, high }

/// Tryb dostarczania wiadomości e-mail.
@JsonEnum(fieldRename: FieldRename.pascal)
enum NotificationEmailDeliveryMode {
  none,
  immediate,
  dailyDigest,

  /// Backendowy alias domenowy `Digest` ma tę samą wartość liczbową co
  /// `DailyDigest`. Zachowujemy dekodowanie historycznych odpowiedzi.
  @JsonValue('Digest')
  digest,
}

/// Akcja wykonywana bez otwierania centrum powiadomień.
@JsonEnum(fieldRename: FieldRename.pascal)
enum NotificationQuickActionKind {
  markRead,
  archive,
  pin,
  unpin,
  completeTask,
  assignTaskToMe,
}

/// Stan wpisu transactional outbox.
@JsonEnum()
enum EmailOutboxStatus { pending, sending, sent, failed, skipped }

/// Tryb powiadomień Storage.
@JsonEnum(fieldRename: FieldRename.pascal)
enum StorageNotificationPreferenceMode {
  immediate,
  digest,
  mentionsOnly,
  disabled,
}
