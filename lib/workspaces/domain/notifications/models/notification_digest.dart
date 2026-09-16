import 'package:equatable/equatable.dart';

/// Minimalna, stabilna reprezentacja najnowszego elementu grupy digestu.
final class NotificationDigestItem extends Equatable {
  /// Tworzy pozycję najnowszego zdarzenia w grupie.
  const NotificationDigestItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAtUtc,
    this.deepLink,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAtUtc;
  final String? deepLink;

  @override
  List<Object?> get props => [id, title, body, createdAtUtc, deepLink];
}

/// Zagregowana grupa pokazywana przez ekran digestu.
final class NotificationDigestGroup extends Equatable {
  /// Tworzy grupę z licznikiem i najnowszą dostępną pozycją.
  const NotificationDigestGroup({
    required this.groupKey,
    required this.count,
    required this.unreadCount,
    required this.latest,
    this.preview,
  });

  final String groupKey;
  final int count;
  final int unreadCount;
  final NotificationDigestItem latest;
  final String? preview;

  @override
  List<Object?> get props => [groupKey, count, unreadCount, latest, preview];
}

/// Niezmienny snapshot digest-only zwracany przez backend.
final class NotificationDigest extends Equatable {
  /// Tworzy snapshot bez ekspozycji DTO warstwie prezentacji.
  NotificationDigest({
    required this.generatedAtUtc,
    required List<NotificationDigestGroup> groups,
  }) : groups = List.unmodifiable(groups);

  final DateTime generatedAtUtc;
  final List<NotificationDigestGroup> groups;

  @override
  List<Object?> get props => [generatedAtUtc, groups];
}
