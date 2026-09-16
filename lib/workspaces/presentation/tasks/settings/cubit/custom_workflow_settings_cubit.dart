import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_status_category.dart';
import 'package:ready_next/workspaces/domain/repositories/custom_workflow_repository.dart';

sealed class CustomWorkflowSettingsState {
  const CustomWorkflowSettingsState();
}

final class CustomWorkflowSettingsLoading extends CustomWorkflowSettingsState {
  const CustomWorkflowSettingsLoading();
}

final class CustomWorkflowSettingsFailure extends CustomWorkflowSettingsState {
  const CustomWorkflowSettingsFailure(this.message);
  final String message;
}

final class CustomWorkflowSettingsReady extends CustomWorkflowSettingsState {
  const CustomWorkflowSettingsReady({
    required this.statuses,
    required this.templates,
    this.isSaving = false,
    this.error,
  });
  final List<ProjectCustomStatusResponse> statuses;
  final List<WorkflowTemplateSummary> templates;
  final bool isSaving;
  final String? error;
  CustomWorkflowSettingsReady copyWith({
    List<ProjectCustomStatusResponse>? statuses,
    List<WorkflowTemplateSummary>? templates,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => CustomWorkflowSettingsReady(
    statuses: statuses ?? this.statuses,
    templates: templates ?? this.templates,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
  );
}

/// Zarządza własnymi statusami z wersjonowaniem optimistic concurrency.
final class CustomWorkflowSettingsCubit
    extends Cubit<CustomWorkflowSettingsState> {
  CustomWorkflowSettingsCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const CustomWorkflowSettingsLoading());
  final CustomWorkflowRepository repository;
  final String workspaceId;
  final String projectId;
  Future<void> load() async {
    emit(const CustomWorkflowSettingsLoading());
    final statusesResult = await repository.listStatuses(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    final templatesResult = await repository.listTemplates(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) {
      return;
    }
    statusesResult.fold(
      (error) => emit(CustomWorkflowSettingsFailure(error.message)),
      (statuses) => templatesResult.fold(
        (error) => emit(CustomWorkflowSettingsFailure(error.message)),
        (templates) => emit(
          CustomWorkflowSettingsReady(
            statuses: _sort(statuses),
            templates: templates,
          ),
        ),
      ),
    );
  }

  Future<bool> create({
    required String name,
    required String colorHex,
    required TaskStatusCategory category,
    int? wipLimit,
    bool isDefault = false,
  }) async {
    final s = state;
    if (s is! CustomWorkflowSettingsReady ||
        s.isSaving ||
        name.trim().isEmpty) {
      return false;
    }
    emit(s.copyWith(isSaving: true, clearError: true));
    final r = await repository.createStatus(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: CreateProjectCustomStatusPayload(
        name: name.trim(),
        colorHex: colorHex,
        category: category,
        wipLimit: wipLimit,
        isDefault: isDefault,
      ),
    );
    if (isClosed) {
      return false;
    }
    return r.fold(
      (e) {
        emit(s.copyWith(isSaving: false, error: e.message));
        return false;
      },
      (v) {
        emit(
          CustomWorkflowSettingsReady(
            statuses: _sort([...s.statuses, v]),
            templates: s.templates,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> delete(
    ProjectCustomStatusResponse status,
    String fallbackStatusId,
  ) async {
    final s = state;
    if (s is! CustomWorkflowSettingsReady ||
        s.isSaving ||
        fallbackStatusId == status.id) {
      return false;
    }
    emit(s.copyWith(isSaving: true, clearError: true));
    final r = await repository.deleteStatus(
      workspaceId: workspaceId,
      projectId: projectId,
      statusId: status.id,
      payload: DeleteProjectCustomStatusPayload(
        fallbackStatusId: fallbackStatusId,
        expectedVersion: status.version,
      ),
    );
    if (isClosed) {
      return false;
    }
    return r.fold(
      (e) {
        emit(s.copyWith(isSaving: false, error: e.message));
        return false;
      },
      (_) {
        emit(
          CustomWorkflowSettingsReady(
            statuses: s.statuses.where((x) => x.id != status.id).toList(),
            templates: s.templates,
          ),
        );
        return true;
      },
    );
  }

  /// Zapisuje właściwości statusu z jego aktualną wersją.
  Future<bool> update({
    required ProjectCustomStatusResponse status,
    required String name,
    required String colorHex,
    required TaskStatusCategory category,
    required int? wipLimit,
    required bool isDefault,
  }) async {
    final current = state;
    if (current is! CustomWorkflowSettingsReady ||
        current.isSaving ||
        name.trim().isEmpty) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.updateStatus(
      workspaceId: workspaceId,
      projectId: projectId,
      statusId: status.id,
      payload: UpdateProjectCustomStatusPayload(
        name: name.trim(),
        colorHex: colorHex,
        category: category,
        wipLimit: wipLimit,
        isDefault: isDefault,
        expectedVersion: status.version,
      ),
    );
    if (isClosed) {
      return false;
    }
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (updated) {
        emit(
          CustomWorkflowSettingsReady(
            statuses: _sort([
              for (final item in current.statuses)
                if (item.id == updated.id) updated else item,
            ]),
            templates: current.templates,
          ),
        );
        return true;
      },
    );
  }

  /// Utrwala pełną kolejność statusów zwróconą po przeciągnięciu elementu.
  Future<bool> reorder(List<ProjectCustomStatusResponse> statuses) async {
    final current = state;
    if (current is! CustomWorkflowSettingsReady || current.isSaving) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.reorderStatuses(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: ReorderProjectCustomStatusesPayload(
        statusIds: statuses.map((item) => item.id).toList(),
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (updated) {
        emit(
          CustomWorkflowSettingsReady(
            statuses: _sort(updated),
            templates: current.templates,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> applyTemplate(String templateKey) async {
    final current = state;
    if (current is! CustomWorkflowSettingsReady || current.isSaving) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.applyTemplate(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: ApplyWorkflowTemplatePayload(
        templateKey: templateKey,
        replaceExisting: true,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (statuses) {
        emit(
          CustomWorkflowSettingsReady(
            statuses: _sort(statuses),
            templates: current.templates,
          ),
        );
        return true;
      },
    );
  }

  static List<ProjectCustomStatusResponse> _sort(
    Iterable<ProjectCustomStatusResponse> v,
  ) => v.toList()..sort((a, b) => a.position.compareTo(b.position));
}
