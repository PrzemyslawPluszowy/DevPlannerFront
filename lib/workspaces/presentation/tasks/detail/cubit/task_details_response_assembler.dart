import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Pure assembly of typed repository responses into the detail state.
///
/// Keeping these transformations outside the Cubit makes optimistic
/// concurrency updates consistent across all detail sections.
final class TaskDetailsResponseAssembler {
  const TaskDetailsResponseAssembler();

  TaskDetailsReady withTaskMutation<T>(
    TaskDetailsReady current,
    TaskMutationResponse<T> response,
  ) => current.copyWith(
    details: current.details.copyWith(
      task: current.details.task.copyWith(
        version: response.taskVersion,
        updatedAtUtc: response.taskUpdatedAtUtc,
      ),
    ),
    isSaving: false,
    clearMutationError: true,
  );

  TaskDetailsReady withProjectTaskMutation(
    TaskDetailsReady current,
    TaskMutationResponse<ProjectTaskResponse> response,
  ) => current.copyWith(
    details: current.details.copyWith(task: response.data),
    isSaving: false,
    clearMutationError: true,
  );

  TaskDetailsReady withChecklistMutation<T>(
    TaskDetailsReady current,
    List<TaskChecklistItemResponse> items,
    TaskMutationResponse<T> response,
  ) => current.copyWith(
    details: current.details.copyWith(
      task: current.details.task.copyWith(
        checklistItems: items,
        version: response.taskVersion,
        updatedAtUtc: response.taskUpdatedAtUtc,
      ),
    ),
    isSaving: false,
    clearMutationError: true,
  );

  TaskDetailsReady withCriteriaMutation<T>(
    TaskDetailsReady current,
    List<TaskAcceptanceCriterionResponse> criteria,
    TaskMutationResponse<T> response,
  ) {
    final updated = withTaskMutation(current, response);
    return updated.copyWith(
      details: updated.details.copyWith(acceptanceCriteria: criteria),
    );
  }

  TaskDetailsReady withDependencyUpdate(
    TaskDetailsReady current,
    TaskDependencyDetailsResponse dependency,
    TaskMutationResponse<TaskDependencyResponse> response,
  ) {
    final updated = withTaskMutation(current, response);
    return updated.copyWith(
      details: updated.details.copyWith(
        dependencies: [
          for (final item in current.details.dependencies)
            if (item.id == dependency.id)
              item.copyWith(
                dependencyKind: response.data.dependencyKind,
                lagDays: response.data.lagDays,
              )
            else
              item,
        ],
      ),
    );
  }

  TaskDetailsReady withDependencyDeleted(
    TaskDetailsReady current,
    String dependencyId,
    TaskMutationResponse<TaskMutationAcknowledgementResponse> response,
  ) {
    final updated = withTaskMutation(current, response);
    return updated.copyWith(
      details: updated.details.copyWith(
        dependencies: current.details.dependencies
            .where((item) => item.id != dependencyId)
            .toList(growable: false),
      ),
    );
  }

  TaskDetailsReady withLabels(
    TaskDetailsReady current,
    TaskMutationResponse<List<TaskLabelResponse>> response,
  ) {
    final updated = withTaskMutation(current, response);
    return updated.copyWith(
      details: updated.details.copyWith(labels: response.data),
    );
  }

  TaskDetailsReady withCustomFieldValues(
    TaskDetailsReady current,
    TaskMutationResponse<List<TaskCustomFieldValueResponse>> response,
  ) {
    final valuesByField = {
      for (final value in response.data) value.fieldId: value,
    };
    final fields = current.details.customFields
        .map(
          (field) {
            final value = valuesByField[field.id];
            return value == null
                ? field
                : field.copyWith(
                    value: value.value,
                    valueUpdatedAtUtc: value.updatedAtUtc,
                  );
          },
        )
        .toList(growable: false);
    final updated = withTaskMutation(current, response);
    return updated.copyWith(
      details: updated.details.copyWith(customFields: fields),
    );
  }

  TaskDetailsReady withPinned(
    TaskDetailsReady current,
    bool isPinned,
  ) => current.copyWith(
    details: current.details.copyWith(isPinnedByMe: isPinned),
    isSaving: false,
    clearMutationError: true,
  );
}
