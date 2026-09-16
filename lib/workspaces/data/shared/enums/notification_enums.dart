import 'package:json_annotation/json_annotation.dart';

/// Kategoria powiadomienia.
@JsonEnum()
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

/// Priorytet dostarczenia powiadomienia.
@JsonEnum()
enum NotificationPriority { low, normal, high }

/// Tryb dostarczania wiadomości e-mail.
@JsonEnum()
enum NotificationEmailDeliveryMode { none, immediate, dailyDigest, digest }

/// Akcja wykonywana bez otwierania centrum powiadomień.
@JsonEnum()
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
@JsonEnum()
enum StorageNotificationPreferenceMode {
  immediate,
  digest,
  mentionsOnly,
  disabled,
}
