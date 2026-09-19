import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:equatable/equatable.dart';

/// Stan zarządzania podzadaniami pojedynczej karty Kanban.
sealed class KanbanSubtasksState extends Equatable {
  const KanbanSubtasksState({
    required this.subtasks,
    required this.subtaskTotal,
    required this.subtaskCompleted,
    this.nextCursor,
    this.hasMore = false,
  });

  /// Lista aktualnie załadowanych podzadań.
  final List<ProjectTaskListItemResponse> subtasks;

  /// Całkowita liczba podzadań wg licznika rodzica.
  final int subtaskTotal;

  /// Liczba ukończonych podzadań wg licznika rodzica.
  final int subtaskCompleted;

  /// Kursor kolejnej strony z backendu (jeśli dostępny).
  final String? nextCursor;

  /// Czy dostępne są kolejne elementy do załadowania.
  final bool hasMore;

  @override
  List<Object?> get props => [
    subtasks,
    subtaskTotal,
    subtaskCompleted,
    nextCursor,
    hasMore,
  ];
}

/// Stan początkowy przed pierwszym rozwinięciem sekcji podzadań.
final class KanbanSubtasksInitial extends KanbanSubtasksState {
  const KanbanSubtasksInitial({
    required super.subtaskTotal,
    required super.subtaskCompleted,
  }) : super(subtasks: const []);
}

/// Stan ładowania pierwszej partii podzadań po rozwinięciu.
final class KanbanSubtasksLoading extends KanbanSubtasksState {
  const KanbanSubtasksLoading({
    required super.subtaskTotal,
    required super.subtaskCompleted,
  }) : super(subtasks: const []);
}

/// Stan gotowości ze sprawdzonymi danymi podzadań.
final class KanbanSubtasksReady extends KanbanSubtasksState {
  const KanbanSubtasksReady({
    required super.subtasks,
    required super.subtaskTotal,
    required super.subtaskCompleted,
    super.nextCursor,
    super.hasMore,
    this.isLoadingMore = false,
    this.isSubmittingSubtask = false,
    this.loadMoreError,
    this.createError,
    this.pendingSubtaskIds = const <String>{},
    this.mutationError,
    this.mutationSerial = 0,
  });

  /// Czy trwa doładowywanie kolejnej strony ("Pokaż kolejne 5").
  final bool isLoadingMore;

  /// Czy trwa asynchroniczne tworzenie nowego podzadania.
  final bool isSubmittingSubtask;

  /// Ewentualny błąd doładowania kolejnej strony (nie usuwa pobranych dzieci).
  final String? loadMoreError;

  /// Ewentualny błąd tworzenia podzadania (pozostawia pole i wpisany tekst).
  final String? createError;
  final Set<String> pendingSubtaskIds;
  final String? mutationError;
  final int mutationSerial;

  KanbanSubtasksReady copyWith({
    List<ProjectTaskListItemResponse>? subtasks,
    int? subtaskTotal,
    int? subtaskCompleted,
    String? nextCursor,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isSubmittingSubtask,
    String? loadMoreError,
    String? createError,
    Set<String>? pendingSubtaskIds,
    String? mutationError,
    int? mutationSerial,
    bool clearLoadMoreError = false,
    bool clearCreateError = false,
  }) => KanbanSubtasksReady(
    subtasks: subtasks ?? this.subtasks,
    subtaskTotal: subtaskTotal ?? this.subtaskTotal,
    subtaskCompleted: subtaskCompleted ?? this.subtaskCompleted,
    nextCursor: nextCursor ?? this.nextCursor,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    isSubmittingSubtask: isSubmittingSubtask ?? this.isSubmittingSubtask,
    loadMoreError: clearLoadMoreError
        ? null
        : (loadMoreError ?? this.loadMoreError),
    createError: clearCreateError ? null : (createError ?? this.createError),
    pendingSubtaskIds: pendingSubtaskIds ?? this.pendingSubtaskIds,
    mutationError: mutationError ?? this.mutationError,
    mutationSerial: mutationSerial ?? this.mutationSerial,
  );

  @override
  List<Object?> get props => [
    ...super.props,
    isLoadingMore,
    isSubmittingSubtask,
    loadMoreError,
    createError,
    pendingSubtaskIds,
    mutationError,
    mutationSerial,
  ];
}

/// Błąd pobierania początkowej listy podzadań.
final class KanbanSubtasksError extends KanbanSubtasksState {
  const KanbanSubtasksError({
    required this.message,
    required super.subtaskTotal,
    required super.subtaskCompleted,
  }) : super(subtasks: const []);

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}
