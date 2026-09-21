import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';

/// Minimalny port stanu używany przez komendy Kanbana.
///
/// Dzięki temu klasy komend nie znają widgetów ani transportu, a publiczny
/// `TasksBoardCubit` pozostaje jedynym właścicielem emisji stanu.
abstract interface class TasksBoardCommandContext {
  String get workspaceId;
  String get projectId;
  TasksBoardState get currentState;
  bool get isBoardClosed;

  void publish(TasksBoardState state);
  Future<void> reloadBoard({bool force});

  /// Odświeża wariant tablicy widoczny na ekranie: grupowanie po statusach
  /// albo po osobach.
  ///
  /// Sama zmiana preferencji (np. szybkiego filtra) nie wystarcza, bo zawartość
  /// kolumn liczy Backend: gdy użytkownik patrzy na tablicę osób, musi wrócić po
  /// świeże grupy, a nie tylko po kolumny statusów.
  Future<void> reloadActiveBoard({bool force});
}
