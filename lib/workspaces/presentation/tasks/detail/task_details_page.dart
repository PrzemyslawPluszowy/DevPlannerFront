import 'dart:async';

import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_modal_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkspaceTaskDetailsPage extends StatelessWidget {
  const WorkspaceTaskDetailsPage({
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    this.onClose,
    this.conversationSlot,
    this.tabIntent,
    this.onTabSelected,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String taskId;
  final VoidCallback? onClose;
  final Widget? conversationSlot;
  final ValueListenable<TaskDetailsModalTab?>? tabIntent;
  final ValueChanged<TaskDetailsModalTab>? onTabSelected;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = TaskDetailsCubit(
        repository: context.read<TasksRepository>(),
        acceptanceCriteriaRepository: context
            .read<TaskAcceptanceCriteriaRepository>(),
        checklistRepository: context.read<TaskChecklistRepository>(),
        collaborationRepository: context.read<TaskCollaborationRepository>(),
        metadataRepository: context.read<TaskMetadataRepository>(),
        customWorkflowRepository: context.read<CustomWorkflowRepository>(),
        taskViewRepository: context.read<TaskViewRepository>(),
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: TaskDetailsOverlay(
      onClose: onClose,
      conversationSlot: conversationSlot,
      tabIntent: tabIntent,
      onTabSelected: onTabSelected,
    ),
  );
}
