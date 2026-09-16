import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/kanban/models/kanban_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/domain/repositories/kanban_repository.dart';

sealed class KanbanSettingsState {
  const KanbanSettingsState();
}

final class KanbanSettingsInitial extends KanbanSettingsState {
  const KanbanSettingsInitial();
}

final class KanbanSettingsLoading extends KanbanSettingsState {
  const KanbanSettingsLoading();
}

final class KanbanSettingsFailure extends KanbanSettingsState {
  const KanbanSettingsFailure(this.message);

  final String message;
}

final class KanbanSettingsReady extends KanbanSettingsState {
  const KanbanSettingsReady({
    required this.settings,
    this.isSaving = false,
    this.error,
  });

  final ProjectKanbanSettingsResponse settings;
  final bool isSaving;
  final String? error;

  KanbanSettingsReady copyWith({
    ProjectKanbanSettingsResponse? settings,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => KanbanSettingsReady(
    settings: settings ?? this.settings,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
  );
}

/// Edytuje wersjonowaną konfigurację widoku Kanban projektu.
///
/// Zmiany pozostają lokalne do jawnego zapisu, dzięki czemu przypadkowe
/// kliknięcie przełącznika nie zmienia konfiguracji całego zespołu.
final class KanbanSettingsCubit extends Cubit<KanbanSettingsState> {
  KanbanSettingsCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const KanbanSettingsInitial());

  final KanbanRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    emit(const KanbanSettingsLoading());
    final result = await repository.getSettings(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(KanbanSettingsFailure(error.message)),
      (settings) => emit(KanbanSettingsReady(settings: _normalized(settings))),
    );
  }

  void setSwimlaneMode(KanbanSwimlaneMode value) => _update(
    (settings) => settings.copyWith(swimlaneMode: value),
  );

  void setCardDensity(KanbanCardDensity value) => _update(
    (settings) => settings.copyWith(defaultCardDensity: value),
  );

  void setColumnVisible(ProjectTaskStatus status, bool visible) =>
      _update((settings) {
        final hidden = settings.hiddenColumns.toSet();
        if (visible) {
          hidden.remove(status);
        } else {
          hidden.add(status);
        }
        return settings.copyWith(hiddenColumns: _sortedStatuses(hidden));
      });

  void setCardFieldVisible(KanbanCardField field, bool visible) =>
      _update((settings) {
        final fields = settings.visibleCardFields.toSet();
        if (visible) {
          fields.add(field);
        } else {
          fields.remove(field);
        }
        return settings.copyWith(visibleCardFields: _sortedFields(fields));
      });

  void setWipLimit(ProjectTaskStatus status, int? value) => _update((settings) {
    final limits = Map<String, int>.from(settings.columnWipLimits);
    if (value == null || value <= 0) {
      limits.remove(_statusKey(status));
    } else {
      limits[_statusKey(status)] = value;
    }
    return settings.copyWith(columnWipLimits: limits);
  });

  Future<bool> save() async {
    final current = state;
    if (current is! KanbanSettingsReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearError: true));
    final settings = current.settings;
    final result = await repository.updateSettings(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: UpdateProjectKanbanSettingsPayload(
        swimlaneMode: settings.swimlaneMode,
        columnWipLimits: settings.columnWipLimits,
        hiddenColumns: settings.hiddenColumns,
        visibleCardFields: settings.visibleCardFields,
        defaultCardDensity: settings.defaultCardDensity,
        expectedVersion: settings.version,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (settings) {
        emit(KanbanSettingsReady(settings: _normalized(settings)));
        return true;
      },
    );
  }

  void _update(
    ProjectKanbanSettingsResponse Function(ProjectKanbanSettingsResponse)
    transform,
  ) {
    final current = state;
    if (current is! KanbanSettingsReady || current.isSaving) return;
    emit(
      current.copyWith(
        settings: _normalized(transform(current.settings)),
        clearError: true,
      ),
    );
  }

  static ProjectKanbanSettingsResponse _normalized(
    ProjectKanbanSettingsResponse settings,
  ) => settings.copyWith(
    hiddenColumns: _sortedStatuses(settings.hiddenColumns),
    visibleCardFields: _sortedFields(settings.visibleCardFields),
  );

  static List<ProjectTaskStatus> _sortedStatuses(
    Iterable<ProjectTaskStatus> statuses,
  ) => statuses.toSet().toList()..sort((a, b) => a.index.compareTo(b.index));

  static List<KanbanCardField> _sortedFields(
    Iterable<KanbanCardField> fields,
  ) => fields.toSet().toList()..sort((a, b) => a.index.compareTo(b.index));

  static String _statusKey(ProjectTaskStatus status) => switch (status) {
    ProjectTaskStatus.backlog => 'Backlog',
    ProjectTaskStatus.todo => 'Todo',
    ProjectTaskStatus.inProgress => 'InProgress',
    ProjectTaskStatus.blocked => 'Blocked',
    ProjectTaskStatus.done => 'Done',
    ProjectTaskStatus.cancelled => 'Cancelled',
  };
}
