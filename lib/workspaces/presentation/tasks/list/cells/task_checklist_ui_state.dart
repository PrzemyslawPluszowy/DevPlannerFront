import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';

/// Niemutowalny, lokalny stan renderowania popovera checklisty.
final class TaskChecklistUiState {
  const TaskChecklistUiState({
    required this.version,
    this.items = const [],
    this.isLoading = true,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final List<TaskChecklistItemResponse> items;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final int version;

  TaskChecklistUiState copyWith({
    List<TaskChecklistItemResponse>? items,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    int? version,
  }) => TaskChecklistUiState(
    version: version ?? this.version,
    items: items ?? this.items,
    isLoading: isLoading ?? this.isLoading,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}
