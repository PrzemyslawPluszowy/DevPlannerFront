import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:equatable/equatable.dart';

/// Informacja zwrotna dla interfejsu (toast/komunikat).
sealed class ProjectRecurrenceFeedback extends Equatable {
  const ProjectRecurrenceFeedback();

  @override
  List<Object?> get props => [];
}

/// Sukces operacji na cyklu.
final class ProjectRecurrenceFeedbackSuccess extends ProjectRecurrenceFeedback {
  const ProjectRecurrenceFeedbackSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Błąd operacji na cyklu.
final class ProjectRecurrenceFeedbackError extends ProjectRecurrenceFeedback {
  const ProjectRecurrenceFeedbackError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stany menedżera zadań cyklicznych projektu.
sealed class ProjectRecurrencesState extends Equatable {
  const ProjectRecurrencesState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy przed załadowaniem.
final class ProjectRecurrencesInitial extends ProjectRecurrencesState {
  const ProjectRecurrencesInitial();
}

/// Stan ładowania reguł i historii.
final class ProjectRecurrencesLoading extends ProjectRecurrencesState {
  const ProjectRecurrencesLoading({this.previousRules, this.previousRuns});

  final List<ProjectTaskRecurrenceItemResponse>? previousRules;
  final List<ProjectTaskRecurrenceRunResponse>? previousRuns;

  @override
  List<Object?> get props => [previousRules, previousRuns];
}

/// Stan załadowanych reguł i historii wykonań.
final class ProjectRecurrencesLoaded extends ProjectRecurrencesState {
  const ProjectRecurrencesLoaded({
    required this.rules,
    required this.runs,
    this.isActionInProgress = false,
    this.feedback,
  });

  final List<ProjectTaskRecurrenceItemResponse> rules;
  final List<ProjectTaskRecurrenceRunResponse> runs;
  final bool isActionInProgress;
  final ProjectRecurrenceFeedback? feedback;

  ProjectRecurrencesLoaded copyWith({
    List<ProjectTaskRecurrenceItemResponse>? rules,
    List<ProjectTaskRecurrenceRunResponse>? runs,
    bool? isActionInProgress,
    ProjectRecurrenceFeedback? feedback,
    bool clearFeedback = false,
  }) => ProjectRecurrencesLoaded(
    rules: rules ?? this.rules,
    runs: runs ?? this.runs,
    isActionInProgress: isActionInProgress ?? this.isActionInProgress,
    feedback: clearFeedback ? null : (feedback ?? this.feedback),
  );

  @override
  List<Object?> get props => [rules, runs, isActionInProgress, feedback];
}

/// Stan krytycznego błędu pobierania danych.
final class ProjectRecurrencesError extends ProjectRecurrencesState {
  const ProjectRecurrencesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
