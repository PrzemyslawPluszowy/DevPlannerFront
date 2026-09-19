import 'package:devplanner/workspaces/domain/repositories/notifications_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lokalny Cubit licznika używany wyłącznie przez globalny topbar.
class UnreadNotificationsCubit extends Cubit<int?> {
  /// `null` oznacza, że licznik jest jeszcze ładowany albo niedostępny.
  UnreadNotificationsCubit(NotificationsRepository repository)
    : _repository = repository,
      super(null);

  final NotificationsRepository _repository;

  /// Odświeża licznik bez zastępowania go sztuczną wartością po błędzie.
  Future<void> load() async {
    if (isClosed) return;
    final result = await _repository.unreadCount();
    if (isClosed) return;
    result.fold((_) {}, emit);
  }
}
