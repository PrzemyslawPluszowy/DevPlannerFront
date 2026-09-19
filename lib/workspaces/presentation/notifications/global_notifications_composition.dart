import 'package:devplanner/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:devplanner/workspaces/domain/repositories/notifications_repository.dart';

/// Jawny composition root globalnej skrzynki powiadomień.
///
/// Panel i pełna trasa dostają wyłącznie porty domenowe. Nie tworzą klienta
/// HTTP, nie odczytują sesji z ukrytego providera i nie znają implementacji
/// SignalR. `realtime` jest opcjonalne, ponieważ transport live może być
/// dostarczony dopiero przez bootstrap po opublikowaniu kontraktu backendu.
final class DevPlannerGlobalNotificationsComposition {
  const DevPlannerGlobalNotificationsComposition({
    required this.repository,
    this.realtime,
  });

  /// Repozytorium skrzynki i mutacji powiadomień bieżącego użytkownika.
  final NotificationsRepository repository;

  /// Opcjonalny właściciel połączenia realtime dla tej samej sesji.
  final WorkspaceNotificationsRealtimeService? realtime;
}
