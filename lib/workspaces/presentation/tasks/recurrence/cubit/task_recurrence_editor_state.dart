import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_advanced_enums.dart';

/// Szybkie presety częstotliwości w edytorze.
enum TaskRecurrencePreset { daily, workdays, weekly, monthly, custom }

/// Stany edytora cykliczności pojedynczego zadania.
sealed class TaskRecurrenceEditorState extends Equatable {
  const TaskRecurrenceEditorState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy przed załadowaniem pełnych danych reguły.
final class TaskRecurrenceEditorInitial extends TaskRecurrenceEditorState {
  const TaskRecurrenceEditorInitial();
}

/// Stan ładowania danych z API.
final class TaskRecurrenceEditorLoading extends TaskRecurrenceEditorState {
  const TaskRecurrenceEditorLoading();
}

/// Stan formularza edycji reguły powtarzania.
final class TaskRecurrenceEditorLoaded extends TaskRecurrenceEditorState {
  const TaskRecurrenceEditorLoaded({
    required this.preset,
    required this.mode,
    required this.frequency,
    required this.interval,
    required this.occurrenceStatus,
    required this.skipIfPreviousOpen,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.hasRecurrence,
    required this.isSourceTask,
    this.recurrence,
    this.isSaving = false,
    this.errorMessage,
  });

  final TaskRecurrencePreset preset;
  final TaskRecurrenceMode mode;
  final TaskRecurrenceFrequency frequency;
  final int interval;
  final ProjectTaskStatus occurrenceStatus;
  final bool skipIfPreviousOpen;
  final DateTime scheduledDate;
  final TimeOfDay scheduledTime;
  final bool hasRecurrence;
  final bool isSourceTask;
  final TaskRecurrenceResponse? recurrence;
  final bool isSaving;
  final String? errorMessage;

  bool get isActive => recurrence?.isActive ?? true;

  TaskRecurrenceEditorLoaded copyWith({
    TaskRecurrencePreset? preset,
    TaskRecurrenceMode? mode,
    TaskRecurrenceFrequency? frequency,
    int? interval,
    ProjectTaskStatus? occurrenceStatus,
    bool? skipIfPreviousOpen,
    DateTime? scheduledDate,
    TimeOfDay? scheduledTime,
    bool? hasRecurrence,
    bool? isSourceTask,
    TaskRecurrenceResponse? recurrence,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) => TaskRecurrenceEditorLoaded(
    preset: preset ?? this.preset,
    mode: mode ?? this.mode,
    frequency: frequency ?? this.frequency,
    interval: interval ?? this.interval,
    occurrenceStatus: occurrenceStatus ?? this.occurrenceStatus,
    skipIfPreviousOpen: skipIfPreviousOpen ?? this.skipIfPreviousOpen,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    scheduledTime: scheduledTime ?? this.scheduledTime,
    hasRecurrence: hasRecurrence ?? this.hasRecurrence,
    isSourceTask: isSourceTask ?? this.isSourceTask,
    recurrence: recurrence ?? this.recurrence,
    isSaving: isSaving ?? this.isSaving,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  List<Object?> get props => [
    preset,
    mode,
    frequency,
    interval,
    occurrenceStatus,
    skipIfPreviousOpen,
    scheduledDate,
    scheduledTime,
    hasRecurrence,
    isSourceTask,
    recurrence,
    isSaving,
    errorMessage,
  ];
}

/// Stan sukcesu zapisu reguły z odpowiedzią z backendu.
final class TaskRecurrenceEditorSuccess extends TaskRecurrenceEditorState {
  const TaskRecurrenceEditorSuccess({
    required this.mutationResult,
    required this.message,
  });

  final TaskMutationResponse<TaskRecurrenceResponse> mutationResult;
  final String message;

  @override
  List<Object?> get props => [mutationResult, message];
}

/// Stan sukcesu usunięcia cykliczności zadania.
final class TaskRecurrenceEditorDeleted extends TaskRecurrenceEditorState {
  const TaskRecurrenceEditorDeleted({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
