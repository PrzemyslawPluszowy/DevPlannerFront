import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';

/// Pojedynczy wpis prywatnej skrzynki powiadomień standalone.
///
/// Model zawiera wyłącznie dane potrzebne przez skrzynkę. Nie przenosi
/// identyfikatorów Ready/Core ani nie udaje dostępu do zasobu wskazanego przez
/// [deepLink]. Dostęp do takiego zasobu sprawdza właściwy ekran domenowy.
final class StandaloneNotificationItem {
  const StandaloneNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAtUtc,
    required this.readAtUtc,
    required this.category,
    required this.priority,
    required this.deepLink,
    required this.groupKey,
    required this.eventType,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAtUtc;
  final DateTime? readAtUtc;
  final NotificationCategory category;
  final NotificationPriority priority;
  final String? deepLink;
  final String? groupKey;
  final String eventType;

  bool get isUnread => readAtUtc == null;

  StandaloneNotificationItem copyWith({DateTime? readAtUtc}) {
    return StandaloneNotificationItem(
      id: id,
      title: title,
      body: body,
      createdAtUtc: createdAtUtc,
      readAtUtc: readAtUtc ?? this.readAtUtc,
      category: category,
      priority: priority,
      deepLink: deepLink,
      groupKey: groupKey,
      eventType: eventType,
    );
  }
}

/// Strona cursorowej skrzynki powiadomień.
final class StandaloneNotificationPage {
  const StandaloneNotificationPage({
    required this.items,
    required this.nextCursor,
  });

  final List<StandaloneNotificationItem> items;
  final String? nextCursor;
}
