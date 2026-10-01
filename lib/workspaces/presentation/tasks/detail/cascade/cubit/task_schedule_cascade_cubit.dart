import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/session/task_detail_section_lifecycle.dart';
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
    this.apiError,
  });

  final ScheduleCascadeResponse? preview;
  final bool isPreviewing;
  final bool isApplying;
  final String? error;
  final ApiError? apiError;

  bool get isBusy => isPreviewing || isApplying;

  TaskScheduleCascadeState copyWith({
    ScheduleCascadeResponse? preview,
    bool? isPreviewing,
    bool? isApplying,
    String? error,
    ApiError? apiError,
    bool clearPreview = false,
    bool clearError = false,
  }) => TaskScheduleCascadeState(
    preview: clearPreview ? null : preview ?? this.preview,
    isPreviewing: isPreviewing ?? this.isPreviewing,
    isApplying: isApplying ?? this.isApplying,
    error: clearError ? null : error ?? this.error,
    apiError: clearError ? null : apiError ?? this.apiError,
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
    this.canEdit,
    this.onAccessLost,
  }) : super(const TaskScheduleCascadeState());

  final TaskScheduleRepository repository;
  final String workspaceId;
  final String projectId;
  final bool Function()? canEdit;
  final void Function(ApiError)? onAccessLost;
  ({String taskId, DateTime start, DateTime due})? _previewInput;
  late final _lifecycle = TaskDetailSectionLifecycle(
    isClosed: () => isClosed,
    canEdit: canEdit,
    onAccessLost: onAccessLost,
  );

  /// Liczy kaskadę dla nowych terminów i pokazuje wynik bez zapisu.
  ///
  /// Zwraca `true`, gdy podgląd się powiódł. Porażka zostaje w `state.error`,
  /// a poprzedni podgląd jest zdejmowany, żeby nie udawał aktualnych terminów.
  Future<bool> preview({
    required String taskId,
    required DateTime newStartAtUtc,
    required DateTime newDueAtUtc,
  }) async {
    if (!_lifecycle.canMutate || state.isBusy) return false;
    final generation = _lifecycle.begin()!;
    _previewInput = null;
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
    if (!_lifecycle.isCurrent(generation)) return false;
    return result.fold(
      (error) {
        emit(
          state.copyWith(
            isPreviewing: false,
            error: error.message,
            apiError: error,
          ),
        );
        _lifecycle.reportError(error);
        return false;
      },
      (preview) {
        _previewInput = (
          taskId: taskId,
          start: newStartAtUtc,
          due: newDueAtUtc,
        );
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
    if (!_lifecycle.canMutate || preview == null || state.isBusy) return false;
    if (_previewInput !=
        (taskId: taskId, start: newStartAtUtc, due: newDueAtUtc)) {
      const error = ApiError(
        type: ApiErrorType.validation,
        message: 'Oblicz podgląd dla aktualnych terminów przed zapisem.',
        apiCode: 'task_cascade_preview_stale',
      );
      _previewInput = null;
      emit(
        state.copyWith(
          clearPreview: true,
          error: error.message,
          apiError: error,
        ),
      );
      return false;
    }
    final generation = _lifecycle.begin()!;
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
    if (!_lifecycle.isCurrent(generation)) return false;
    return result.fold(
      (error) {
        emit(
          state.copyWith(
            isApplying: false,
            error: error.message,
            apiError: error,
          ),
        );
        _lifecycle.reportError(error);
        return false;
      },
      (_) {
        _previewInput = null;
        emit(const TaskScheduleCascadeState());
        return true;
      },
    );
  }

  /// Zdejmuje podgląd, gdy użytkownik zmienia daty albo zamyka formularz.
  void clearPreview() {
    if (isClosed || state.isApplying) return;
    _lifecycle.invalidate();
    _previewInput = null;
    emit(const TaskScheduleCascadeState());
  }
}
