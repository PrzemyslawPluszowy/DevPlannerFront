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
}
