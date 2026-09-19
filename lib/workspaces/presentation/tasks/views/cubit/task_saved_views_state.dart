import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:flutter/foundation.dart';

/// Niemutowalne stany zarządzania prywatnymi widokami zadań (Saved Views).
@immutable
sealed class TaskSavedViewsState {
  const TaskSavedViewsState();
}

/// Stan początkowy ładowania listy zapisanych widoków.
final class TaskSavedViewsLoading extends TaskSavedViewsState {
  const TaskSavedViewsLoading();
}

/// Stan błędu odczytu listy zapisanych widoków.
final class TaskSavedViewsFailure extends TaskSavedViewsState {
  const TaskSavedViewsFailure(this.message);

  /// Treść błędu z backendu.
  final String message;
}

/// Typ bieżącej akcji mutującej w stanie gotowości.
enum TaskSavedViewBusyAction {
  create,
  update,
  delete,
  select,
}

/// Gotowy stan prywatnych widoków zadań dla bieżącego projektu.
final class TaskSavedViewsReady extends TaskSavedViewsState {
  const TaskSavedViewsReady({
    required this.views,
    this.activeViewId,
    this.busyAction,
    this.error,
    this.successMessage,
    this.successSerial = 0,
  });

  /// Lista zapisanych widoków użytkownika w bieżącym projekcie.
  final List<TaskSavedViewResponse> views;

  /// Identyfikator aktywnego widoku (lub `null` dla widoku domyślnego).
  final String? activeViewId;

  /// Aktualnie trwająca akcja mutująca (lub `null` gdy cubit nie wykonuje żądania).
  final TaskSavedViewBusyAction? busyAction;

  /// Czy jakakolwiek operacja mutująca jest w toku.
  bool get busy => busyAction != null;

  /// Treść błędu ostatniej operacji mutującej (np. błąd walidacji, 409 konflikt).
  final String? error;

  /// Komunikat sukcesu ostatniej operacji mutującej dla powiadomień UI (np. SnackBar).
  final String? successMessage;

  /// Numer seryjny sukcesu zmieniający się przy każdej udanej operacji.
  final int successSerial;

  /// Aktywny obiekt [TaskSavedViewResponse] na podstawie [activeViewId].
  TaskSavedViewResponse? get activeView {
    if (activeViewId == null) return null;
    return views.where((view) => view.id == activeViewId).firstOrNull;
  }

  /// Tworzy kopię stanu z możliwością aktualizacji poszczególnych pól.
  TaskSavedViewsReady copyWith({
    List<TaskSavedViewResponse>? views,
    String? activeViewId,
    bool clearActiveView = false,
    TaskSavedViewBusyAction? busyAction,
    bool clearBusyAction = false,
    String? error,
    bool clearError = false,
    String? successMessage,
    bool clearSuccessMessage = false,
    int? successSerial,
  }) => TaskSavedViewsReady(
    views: views ?? this.views,
    activeViewId: clearActiveView ? null : activeViewId ?? this.activeViewId,
    busyAction: clearBusyAction ? null : busyAction ?? this.busyAction,
    error: clearError ? null : error ?? this.error,
    successMessage: clearSuccessMessage
        ? null
        : successMessage ?? this.successMessage,
    successSerial: successSerial ?? this.successSerial,
  );
}
