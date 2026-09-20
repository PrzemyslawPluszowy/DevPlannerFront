import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan kaskady harmonogramu w oknie planowania jednego zadania.
///
/// Podgląd i zapis są rozdzielone: podgląd niczego nie zmienia i musi pozostać
/// widoczny, dopóki użytkownik go nie zaakceptuje albo nie zmieni dat.
final class TaskScheduleCascadeState {
  const TaskScheduleCascadeState({
    this.preview,
    this.isPreviewing = false,
    this.isApplying = false,
    this.error,
  });

  final ScheduleCascadeResponse? preview;
  final bool isPreviewing;
  final bool isApplying;
  final String? error;

  bool get isBusy => isPreviewing || isApplying;

  TaskScheduleCascadeState copyWith({
    ScheduleCascadeResponse? preview,
    bool? isPreviewing,
    bool? isApplying,
    String? error,
    bool clearPreview = false,
    bool clearError = false,
  }) => TaskScheduleCascadeState(
    preview: clearPreview ? null : preview ?? this.preview,
    isPreviewing: isPreviewing ?? this.isPreviewing,
    isApplying: isApplying ?? this.isApplying,
    error: clearError ? null : error ?? this.error,
  );
}

/// Wykonuje podgląd i zapis kaskady bez udziału widgetu.
///
/// Widget przekazuje wyłącznie intencje i daty; mapowanie błędów, blokada
/// podwójnego żądania i trzymanie podglądu należą do stanu.
final class TaskScheduleCascadeCubit extends Cubit<TaskScheduleCascadeState> {
  TaskScheduleCascadeCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskScheduleCascadeState());

  final TaskScheduleRepository repository;
  final String workspaceId;
  final String projectId;

  /// Liczy kaskadę dla nowych terminów i pokazuje wynik bez zapisu.
  ///
  /// Zwraca `true`, gdy podgląd się powiódł. Porażka zostaje w `state.error`,
  /// a poprzedni podgląd jest zdejmowany, żeby nie udawał aktualnych terminów.
  Future<bool> preview({
    required String taskId,
    required DateTime newStartAtUtc,
    required DateTime newDueAtUtc,
  }) async {
    if (state.isBusy) return false;
    emit(
      state.copyWith(
        isPreviewing: true,
        clearPreview: true,
        clearError: true,
      ),
    );
    final result = await repository.previewCascade(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: PreviewScheduleCascadePayload(
        taskId: taskId,
        newStartAtUtc: newStartAtUtc,
        newDueAtUtc: newDueAtUtc,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(
          state.copyWith(isPreviewing: false, error: error.message),
        );
        return false;
      },
      (preview) {
        emit(state.copyWith(isPreviewing: false, preview: preview));
        return true;
      },
    );
  }

  /// Zapisuje zaakceptowaną kaskadę z wersjami zadań z bieżącego podglądu.
  ///
  /// Zapis bez podglądu jest odrzucany: kontrakt wymaga `expectedVersion`
  /// każdego przesuwanego zadania, więc nie wolno zgadywać tych wersji.
  Future<bool> apply({
    required String taskId,
    required DateTime newStartAtUtc,
    required DateTime newDueAtUtc,
  }) async {
    final preview = state.preview;
    if (preview == null || state.isBusy) return false;
    emit(state.copyWith(isApplying: true, clearError: true));
    final result = await repository.applyCascade(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: ApplyScheduleCascadePayload(
        taskId: taskId,
        newStartAtUtc: newStartAtUtc,
        newDueAtUtc: newDueAtUtc,
        expectedTaskVersions: {
          for (final shift in preview.dateShifts)
            shift.taskId: shift.expectedVersion,
        },
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(state.copyWith(isApplying: false, error: error.message));
        return false;
      },
      (_) {
        emit(const TaskScheduleCascadeState());
        return true;
      },
    );
  }

  /// Zdejmuje podgląd, gdy użytkownik zmienia daty albo zamyka formularz.
  void clearPreview() => emit(const TaskScheduleCascadeState());
}
