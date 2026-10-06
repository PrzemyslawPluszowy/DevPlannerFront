import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_chat_dependency_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_resource_conversation_slot.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_member_profiles_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_schedule_repository_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/tasks_details_route_page.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class TaskDetailModalContent extends StatelessWidget {
  const TaskDetailModalContent({
    required this.snapshot,
    required this.draftRegistry,
    required this.tabIntent,
    required this.onClose,
    this.onTabSelected,
    super.key,
  });

  final TaskDetailModalSnapshot snapshot;
  final TaskDetailDraftRegistry draftRegistry;
  final ValueListenable<TaskDetailsModalTab?> tabIntent;
  final VoidCallback onClose;
  final ValueChanged<TaskDetailsModalTab>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    final taskId = snapshot.taskId!;
    final details = snapshot.composition;
    final child = details == null
        ? const TaskDetailModalUnavailableContent()
        : TasksDetailsRoutePage(
            composition: details,
            workspaceId: snapshot.workspaceId,
            projectId: snapshot.projectId,
            taskId: taskId,
            onClose: onClose,
            tabIntent: tabIntent,
            onTabSelected: onTabSelected,
            conversationSlot: TaskDetailResourceConversationSlot(
              taskId: taskId,
              workspaceId: snapshot.workspaceId,
              projectId: snapshot.projectId,
              composition: snapshot.chatComposition,
            ),
          );
    final detailChild = TaskDetailChatDependencyScope(
      composition: snapshot.chatComposition,
      authSession: snapshot.authSession,
      storageRepository: snapshot.storageRepository,
      emojiRecentCubit: snapshot.emojiRecentCubit,
      child: TaskDetailDraftScope(registry: draftRegistry, child: child),
    );
    final repository = snapshot.memberProfilesRepository;
    final scopedChild = repository == null
        ? detailChild
        : RepositoryProvider<ProjectMemberProfilesRepository>.value(
            value: repository,
            child: detailChild,
          );
    return RepositoryProvider<ProjectSettingsComposition?>.value(
      value: snapshot.settingsComposition,
      child: TaskDetailScheduleRepositoryScope(
        repository: snapshot.composition?.scheduleRepository,
        child: TaskDetailMemberProfilesScope(
          repository: repository,
          child: scopedChild,
        ),
      ),
    );
  }
}
