import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_acceptance_criteria_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_acceptance_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_basic_mutation_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_checklist_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_checklist_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_collaboration_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_collaboration_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_dependencies_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_dependency_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_loader_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_metadata_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_metadata_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_mutation_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_response_assembler.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  TaskDetailsCubit({
    required this.repository,
    required TaskAcceptanceCriteriaRepository acceptanceCriteriaRepository,
    required this.checklistRepository,
    this.collaborationRepository,
    this.metadataRepository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  }) : _acceptanceCriteriaService = TaskAcceptanceCriteriaService(
         repository: acceptanceCriteriaRepository,
         workspaceId: workspaceId,
         projectId: projectId,
         taskId: taskId,
       ),
       _dependenciesService = TaskDetailsDependenciesService(
         repository: repository,
         workspaceId: workspaceId,
         projectId: projectId,
         taskId: taskId,
       ),
       _basicMutationService = TaskDetailsBasicMutationService(
         repository: repository,
         workspaceId: workspaceId,
         projectId: projectId,
         taskId: taskId,
       ),
       _checklistService = TaskDetailsChecklistService(
         repository: checklistRepository,
         workspaceId: workspaceId,
         projectId: projectId,
         taskId: taskId,
       ),
       _collaborationService = collaborationRepository == null
           ? null
           : TaskDetailsCollaborationService(
               repository: collaborationRepository,
               workspaceId: workspaceId,
               projectId: projectId,
               taskId: taskId,
             ),
       _loaderService = TaskDetailsLoaderService(
         repository: repository,
         workspaceId: workspaceId,
         projectId: projectId,
         taskId: taskId,
       ),
       _metadataService = metadataRepository == null
           ? null
           : TaskDetailsMetadataService(
               repository: metadataRepository,
               workspaceId: workspaceId,
               projectId: projectId,
               taskId: taskId,
             ),
       _assembler = const TaskDetailsResponseAssembler(),
       super(const TaskDetailsInitial());

  final TasksRepository repository;
  final TaskChecklistRepository checklistRepository;

  /// Opcjonalne wyłącznie dla izolowanych preview i istniejących testów cubitu.
  /// Aplikacja produkcyjna zawsze dostarcza je przez DI.
  final TaskCollaborationRepository? collaborationRepository;

  /// Opcjonalne dla izolowanych preview; produkcja dostarcza je przez DI.
  final TaskMetadataRepository? metadataRepository;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final TaskAcceptanceCriteriaService _acceptanceCriteriaService;
  final TaskDetailsDependenciesService _dependenciesService;
  final TaskDetailsBasicMutationService _basicMutationService;
  final TaskDetailsChecklistService _checklistService;
  final TaskDetailsCollaborationService? _collaborationService;
  final TaskDetailsLoaderService _loaderService;
  final TaskDetailsMetadataService? _metadataService;
  final TaskDetailsResponseAssembler _assembler;

  TaskDetailsMutationCoordinator get _coordinator =>
      TaskDetailsMutationCoordinator(
        repository: repository,
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        emitReady: emit,
        isClosed: () => isClosed,
      );

  TaskDetailsChecklistCommands get _checklistCommands =>
      TaskDetailsChecklistCommands(
        service: _checklistService,
        coordinator: _coordinator,
        assembler: _assembler,
        readState: () => state,
        emitReady: emit,
      );

  TaskDetailsAcceptanceCommands get _acceptanceCommands =>
      TaskDetailsAcceptanceCommands(
        service: _acceptanceCriteriaService,
        coordinator: _coordinator,
        assembler: _assembler,
        readState: () => state,
        emitReady: emit,
      );

  TaskDetailsDependencyCommands get _dependencyCommands =>
      TaskDetailsDependencyCommands(
        service: _dependenciesService,
        coordinator: _coordinator,
        assembler: _assembler,
        readState: () => state,
        emitReady: emit,
      );

  TaskDetailsMetadataCommands? get _metadataCommands {
    final service = _metadataService;
    if (service == null) return null;
    return TaskDetailsMetadataCommands(
      service: service,
      coordinator: _coordinator,
      assembler: _assembler,
      readState: () => state,
      emitReady: emit,
    );
  }

  TaskDetailsCollaborationCommands? get _collaborationCommands {
    final service = _collaborationService;
    if (service == null) return null;
    return TaskDetailsCollaborationCommands(
      service: service,
      coordinator: _coordinator,
      assembler: _assembler,
      readState: () => state,
      emitReady: emit,
    );
  }

  Future<void> load() async {
    emit(const TaskDetailsLoading());
    final result = await _loaderService.loadState();
    if (isClosed) return;
    emit(result);
  }

  /// Zapisuje pola podstawowe z wersją agregatu zwróconą przez backend.
  Future<bool> updateBasics({
    required String title,
    required ProjectTaskStatus status,
    required TaskPriority priority,
  }) async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) return false;
    final task = current.details.task;
    return _coordinator.executeProjectTask(
      current,
      _basicMutationService.updateBasics(
        task: task,
        title: normalizedTitle,
        status: status,
        priority: priority,
      ),
      _assembler,
    );
  }

  /// Aktualizuje harmonogram i estymację, zachowując pozostałe pola agregatu.
  Future<bool> updatePlanning({
    required DateTime? startAtUtc,
    required DateTime? dueAtUtc,
    required int? estimatedMinutes,
  }) async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    if (estimatedMinutes != null && estimatedMinutes <= 0) return false;
    if (startAtUtc != null &&
        dueAtUtc != null &&
        dueAtUtc.isBefore(startAtUtc)) {
      return false;
    }
    final task = current.details.task;
    return _coordinator.executeProjectTask(
      current,
      _basicMutationService.updatePlanning(
        task: task,
        startAtUtc: startAtUtc,
        dueAtUtc: dueAtUtc,
        estimatedMinutes: estimatedMinutes,
      ),
      _assembler,
    );
  }

  /// Zapisuje opis plain-text oraz jego kanoniczny Quill Delta JSON.
  Future<bool> updateDescription({
    required String description,
    required String descriptionDeltaJson,
  }) async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    final task = current.details.task;
    return _coordinator.executeProjectTask(
      current,
      _basicMutationService.updateDescription(
        task: task,
        description: description,
        descriptionDeltaJson: descriptionDeltaJson,
      ),
      _assembler,
    );
  }

  /// Zastępuje wykonawców i zachowuje wersję agregatu zwróconą przez backend.
  Future<bool> replaceAssignees(List<String> userIds) async {
    return _collaborationCommands?.replaceAssignees(userIds) ?? false;
  }

  /// Archiwizuje albo przywraca zadanie z kontrolą wersji agregatu.
  Future<bool> toggleArchive() async {
    final current = state;
    if (current is! TaskDetailsReady || current.isSaving) return false;
    final task = current.details.task;
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    return _coordinator.execute(
      current: current,
      operation: _basicMutationService.toggleArchive(task),
      onSuccess: _assembler.withProjectTaskMutation,
    );
  }

  /// Tworzy jednopoziomowe podzadanie i odświeża agregat rodzica.
  Future<bool> createSubtask(String title) async {
    final current = state;
    final normalized = title.trim();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        normalized.isEmpty) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearMutationError: true));
    final task = current.details.task;
    return _coordinator.executeAndRefresh(
      current: current,
      operation: _basicMutationService.createSubtask(
        task: task,
        title: normalized,
      ),
    );
  }

  Future<bool> addChecklistItem(String title) => _checklistCommands.add(title);

  Future<bool> toggleChecklistItem(TaskChecklistItemResponse item) =>
      updateChecklistItem(item, isCompleted: !item.isCompleted);

  Future<bool> updateChecklistItem(
    TaskChecklistItemResponse item, {
    String? title,
    bool? isCompleted,
  }) => _checklistCommands.update(
    item,
    title: title,
    isCompleted: isCompleted,
  );

  Future<bool> deleteChecklistItem(TaskChecklistItemResponse item) =>
      _checklistCommands.delete(item);

  /// Przełącza obserwowanie przez bieżącego użytkownika i odświeża agregat.
  Future<bool> toggleWatching() async {
    return _collaborationCommands?.toggleWatching() ?? false;
  }

  /// Przełącza osobiste przypięcie bez zmieniania współdzielonego taska.
  Future<bool> togglePinned() async {
    return _collaborationCommands?.togglePinned() ?? false;
  }

  /// Zapisuje pełną listę etykiet taska z kontrolą wersji agregatu.
  Future<bool> replaceLabels(Iterable<String> labelIds) async {
    return _metadataCommands?.replaceLabels(labelIds) ?? false;
  }

  /// Pobiera projektowe etykiety do selektora, bez utrwalania ich w stanie.
  Future<List<TaskLabelResponse>> loadProjectLabels() async {
    final commands = _metadataCommands;
    if (commands == null) return const [];
    final result = await commands.listLabels();
    if (isClosed) return const [];
    return result;
  }

  /// Zapisuje wartości pól własnych i scala odpowiedź z pełnym detailem.
  Future<bool> replaceCustomFieldValues(Map<String, dynamic> values) async {
    return _metadataCommands?.replaceCustomFieldValues(values) ?? false;
  }

  /// Wyszukuje zadania projektu do bezpiecznego wyboru relacji w UI.
  Future<List<ProjectTaskListItemResponse>> searchProjectTasks(
    String phrase,
  ) async {
    final result = await _dependencyCommands.search(phrase);
    if (isClosed) return const [];
    return result;
  }

  Future<bool> createDependency({
    required String targetTaskId,
    required TaskDependencyType type,
    TaskDependencyKind dependencyKind = TaskDependencyKind.finishToStart,
    int lagDays = 0,
  }) async {
    return _dependencyCommands.create(
      targetTaskId: targetTaskId,
      type: type,
      dependencyKind: dependencyKind,
      lagDays: lagDays,
    );
  }

  /// Zmienia rodzaj Gantta i lag istniejącej relacji z aktualną wersją zadania.
  Future<bool> updateDependency({
    required TaskDependencyDetailsResponse dependency,
    required TaskDependencyKind dependencyKind,
    required int lagDays,
  }) async {
    return _dependencyCommands.update(
      dependency: dependency,
      dependencyKind: dependencyKind,
      lagDays: lagDays,
    );
  }

  Future<bool> deleteDependency(
    TaskDependencyDetailsResponse dependency,
  ) async {
    return _dependencyCommands.delete(dependency);
  }

  Future<bool> addAcceptanceCriterion(String text) =>
      _acceptanceCommands.add(text);

  Future<bool> toggleAcceptanceCriterion(
    TaskAcceptanceCriterionResponse criterion,
  ) => updateAcceptanceCriterion(
    criterion,
    isAccepted: !criterion.isAccepted,
  );

  Future<bool> updateAcceptanceCriterion(
    TaskAcceptanceCriterionResponse criterion, {
    String? text,
    bool? isAccepted,
  }) => _acceptanceCommands.update(
    criterion,
    text: text,
    isAccepted: isAccepted,
  );

  Future<bool> deleteAcceptanceCriterion(
    TaskAcceptanceCriterionResponse criterion,
  ) => _acceptanceCommands.delete(criterion);
}
