import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:flutter/material.dart';

final class TaskDetailModalSnapshot {
  const TaskDetailModalSnapshot({
    required this.taskId,
    required this.workspaceId,
    required this.projectId,
    required this.composition,
    required this.memberProfilesRepository,
    required this.location,
    required this.targetTab,
    required this.chatComposition,
    required this.authSession,
    required this.storageRepository,
    required this.emojiRecentCubit,
    required this.userId,
    this.settingsComposition,
  });

  final String? taskId;
  final String workspaceId;
  final String projectId;
  final TasksDetailsComposition? composition;
  final ProjectMemberProfilesRepository? memberProfilesRepository;
  final String location;
  final TaskDetailsModalTab? targetTab;
  final DevPlannerGlobalChatComposition? chatComposition;
  final AuthSessionPort? authSession;
  final StorageRepository? storageRepository;
  final ChatEmojiRecentCubit? emojiRecentCubit;
  final String? userId;
  final ProjectSettingsComposition? settingsComposition;

  bool hasSameScope(TaskDetailModalSnapshot? other) =>
      other != null &&
      taskId == other.taskId &&
      workspaceId == other.workspaceId &&
      projectId == other.projectId &&
      identical(composition, other.composition) &&
      identical(settingsComposition, other.settingsComposition) &&
      identical(memberProfilesRepository, other.memberProfilesRepository) &&
      identical(chatComposition, other.chatComposition) &&
      identical(authSession, other.authSession) &&
      identical(storageRepository, other.storageRepository) &&
      identical(emojiRecentCubit, other.emojiRecentCubit) &&
      userId == other.userId;
}

final class TaskDetailModalUnavailableContent extends StatelessWidget {
  const TaskDetailModalUnavailableContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.workspacesTransportUnavailableTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.workspacesTransportUnavailableMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
