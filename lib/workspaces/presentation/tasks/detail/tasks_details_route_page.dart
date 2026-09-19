import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_history_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Granica kompozycji pełnego ekranu szczegółów zadania.
///
/// Strona przekazuje do istniejącego UI wyłącznie porty domenowe. Nie wykonuje
/// żądań HTTP i nie zna szczegółów tokenów ani transportu.
final class TasksDetailsRoutePage extends StatelessWidget {
  const TasksDetailsRoutePage({
    required this.composition,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    super.key,
  });

  final TasksDetailsComposition composition;
  final String workspaceId;
  final String projectId;
  final String taskId;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<TasksRepository>.value(
        value: composition.tasksRepository,
      ),
      RepositoryProvider<TaskAcceptanceCriteriaRepository>.value(
        value: composition.acceptanceCriteriaRepository,
      ),
      RepositoryProvider<TaskAttachmentRepository>.value(
        value: composition.attachmentRepository,
      ),
      RepositoryProvider<TaskChecklistRepository>.value(
        value: composition.checklistRepository,
      ),
      RepositoryProvider<TaskCollaborationRepository>.value(
        value: composition.collaborationRepository,
      ),
      RepositoryProvider<TaskHistoryRepository>.value(
        value: composition.historyRepository,
      ),
      RepositoryProvider<TaskMetadataRepository>.value(
        value: composition.metadataRepository,
      ),
      RepositoryProvider<TaskRecurrenceRepository>.value(
        value: composition.recurrenceRepository,
      ),
      RepositoryProvider<TaskScheduleRepository>.value(
        value: composition.scheduleRepository,
      ),
      RepositoryProvider<TaskTemplateRepository>.value(
        value: composition.templateRepository,
      ),
      RepositoryProvider<TaskTimeTrackingRepository>.value(
        value: composition.timeTrackingRepository,
      ),
      RepositoryProvider<MilestoneRepository>.value(
        value: composition.milestoneRepository,
      ),
      RepositoryProvider<StorageRepository>.value(
        value: composition.storageRepository,
      ),
      RepositoryProvider<TaskAttachmentUploadTransport>.value(
        value: composition.attachmentUploadTransport,
      ),
    ],
    child: WorkspaceTaskDetailsPage(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    ),
  );
}
