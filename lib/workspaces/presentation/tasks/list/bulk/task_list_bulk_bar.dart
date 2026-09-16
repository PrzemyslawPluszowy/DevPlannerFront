import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';

/// Pływający pasek akcji masowych (Bulk Toolbar).
///
/// Wyświetla się na dole widoku, gdy użytkownik zaznaczy co najmniej jedno zadanie.
/// Umożliwia masową zmianę statusu, priorytetu, terminu, wykonawcy oraz archiwizację.
class TaskListBulkBar extends StatelessWidget {
  const TaskListBulkBar({
    required this.selectedCount,
    required this.memberProfiles,
    required this.groups,
    required this.groupBy,
    super.key,
  });

  final int selectedCount;
  final Map<String, ProjectMemberProfile> memberProfiles;
  final List<ProjectTaskListGroupResponse> groups;
  final TaskSavedViewGroupBy groupBy;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectTasksListCubit>();

    Future<void> apply({
      ProjectTaskStatus? status,
      TaskPriority? priority,
      DateTime? dueAtUtc,
      List<String>? assigneeIds,
      String? customStatusId,
      bool clearCustomStatus = false,
      bool archive = false,
      bool entireResult = false,
    }) async {
      if (entireResult) {
        await cubit.bulkUpdateEntireResult(
          status: status,
          customStatusId: customStatusId,
          clearCustomStatus: clearCustomStatus,
          priority: priority,
          dueAtUtc: dueAtUtc,
          assigneeIds: assigneeIds,
          archive: archive,
        );
      } else {
        await cubit.bulkUpdateSelected(
          status: status,
          priority: priority,
          dueAtUtc: dueAtUtc,
          assigneeIds: assigneeIds,
          archive: archive,
        );
      }
    }

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(10),
      color: context.colors.surfaceContainerHigh,
      shadowColor: Colors.black.withValues(alpha: .28),
      child: Container(
        height: 42,
        padding: const .symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.colors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Text(
              '$selectedCount zaznaczonych',
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<ProjectTaskStatus>(
              tooltip: 'Zmień status $selectedCount zaznaczonych zadań',
              onSelected: (status) => unawaited(apply(status: status)),
              itemBuilder: (context) => [
                for (final status in ProjectTaskStatus.values)
                  PopupMenuItem(
                    value: status,
                    height: 32,
                    child: Text(TaskStatusVisualHelper.label(context, status)),
                  ),
              ],
              child: const _BulkToolbarButton(
                icon: Symbols.playlist_add_check_rounded,
                label: 'Status',
              ),
            ),
            PopupMenuButton<TaskPriority>(
              tooltip: 'Zmień priorytet $selectedCount zaznaczonych zadań',
              elevation: 3,
              color: context.colors.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: context.colors.outlineVariant.withValues(alpha: .5),
                ),
              ),
              onSelected: (priority) => unawaited(apply(priority: priority)),
              itemBuilder: (context) => [
                for (final priority in TaskPriority.values)
                  PopupMenuItem(
                    value: priority,
                    height: 32,
                    child: Text(
                      TaskPriorityVisualHelper.label(context, priority),
                      style: context.text.bodySmall?.copyWith(fontSize: 12),
                    ),
                  ),
              ],
              child: const _BulkToolbarButton(
                icon: Symbols.flag,
                label: 'Priorytet',
              ),
            ),
            if (groupBy == TaskSavedViewGroupBy.customStatus)
              PopupMenuButton<_BulkCustomStatusTarget>(
                tooltip: 'Przenieś cały filtrowany wynik do grupy workflow',
                onSelected: (target) => unawaited(
                  apply(
                    customStatusId: target.customStatusId,
                    clearCustomStatus: target.clearCustomStatus,
                    entireResult: true,
                  ),
                ),
                itemBuilder: (context) => [
                  for (final group in groups)
                    if (group.key.startsWith('custom-status:'))
                      PopupMenuItem(
                        value: group.key == 'custom-status:none'
                            ? const _BulkCustomStatusTarget.clear()
                            : _BulkCustomStatusTarget.assign(
                                group.key.substring('custom-status:'.length),
                              ),
                        height: 32,
                        child: Text('Cały wynik: ${group.displayName}'),
                      ),
                ],
                child: const _BulkToolbarButton(
                  icon: Symbols.account_tree,
                  label: 'Grupa wszystkich',
                ),
              ),
            Tooltip(
              message:
                  'Ustaw termin dziś dla $selectedCount zaznaczonych zadań',
              child: TextButton.icon(
                onPressed: () => unawaited(
                  apply(dueAtUtc: DateTime.now().toUtc()),
                ),
                icon: const Icon(Symbols.today, size: 16),
                label: const Text('Termin dziś'),
                style: TextButton.styleFrom(visualDensity: .compact),
              ),
            ),
            if (memberProfiles.isNotEmpty)
              PopupMenuButton<String>(
                tooltip:
                    'Przypisz wykonawcę $selectedCount zaznaczonym zadaniom',
                onSelected: (coreUserId) => unawaited(
                  apply(assigneeIds: [coreUserId]),
                ),
                itemBuilder: (context) => [
                  for (final profile in memberProfiles.values)
                    PopupMenuItem(
                      value: profile.coreUserId,
                      height: 32,
                      child: Text(_profileName(profile)),
                    ),
                ],
                child: const _BulkToolbarButton(
                  icon: Symbols.person_add_alt,
                  label: 'Wykonawca',
                ),
              ),
            const Spacer(),
            PopupMenuButton<ProjectTaskStatus>(
              tooltip: 'Zmień status całego filtrowanego wyniku',
              onSelected: (status) => unawaited(
                apply(status: status, entireResult: true),
              ),
              itemBuilder: (context) => [
                for (final status in ProjectTaskStatus.values)
                  PopupMenuItem(
                    value: status,
                    height: 32,
                    child: Text(
                      'Cały wynik: ${TaskStatusVisualHelper.label(context, status)}',
                    ),
                  ),
              ],
              child: const _BulkToolbarButton(
                icon: Symbols.select_all_rounded,
                label: 'Cały wynik',
              ),
            ),
            PopupMenuButton<TaskPriority>(
              tooltip: 'Zmień priorytet całego filtrowanego wyniku',
              elevation: 3,
              color: context.colors.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: context.colors.outlineVariant.withValues(alpha: .5),
                ),
              ),
              onSelected: (priority) => unawaited(
                apply(priority: priority, entireResult: true),
              ),
              itemBuilder: (context) => [
                for (final priority in TaskPriority.values)
                  PopupMenuItem(
                    value: priority,
                    height: 32,
                    child: Text(
                      'Cały wynik: ${TaskPriorityVisualHelper.label(context, priority)}',
                      style: context.text.bodySmall?.copyWith(fontSize: 12),
                    ),
                  ),
              ],
              child: const _BulkToolbarButton(
                icon: Symbols.flag,
                label: 'Priorytet wszystkich',
              ),
            ),
            IconButton(
              tooltip: 'Ustaw termin dziś dla całego filtrowanego wyniku',
              visualDensity: .compact,
              onPressed: () => unawaited(
                apply(dueAtUtc: DateTime.now().toUtc(), entireResult: true),
              ),
              icon: const Icon(Symbols.event_available, size: 18),
            ),
            IconButton(
              tooltip: 'Archiwizuj cały filtrowany wynik',
              color: context.colors.error,
              visualDensity: .compact,
              onPressed: () => unawaited(
                apply(archive: true, entireResult: true),
              ),
              icon: const Icon(Symbols.archive, size: 18),
            ),
            if (memberProfiles.isNotEmpty)
              PopupMenuButton<String>(
                tooltip: 'Przypisz wykonawcę całemu filtrowanemu wynikowi',
                onSelected: (coreUserId) => unawaited(
                  cubit.bulkUpdateEntireResult(assigneeIds: [coreUserId]),
                ),
                itemBuilder: (context) => [
                  for (final profile in memberProfiles.values)
                    PopupMenuItem(
                      value: profile.coreUserId,
                      height: 32,
                      child: Text(_profileName(profile)),
                    ),
                ],
                child: const _BulkToolbarButton(
                  icon: Symbols.person_add_alt,
                  label: 'Wykonawca wszystkich',
                ),
              ),
            IconButton(
              tooltip: 'Archiwizuj $selectedCount zaznaczonych zadań',
              color: context.colors.error,
              visualDensity: .compact,
              onPressed: () => unawaited(apply(archive: true)),
              icon: const Icon(Symbols.archive, size: 18),
            ),
            IconButton(
              tooltip: 'Wyczyść zaznaczenie $selectedCount zadań',
              visualDensity: .compact,
              onPressed: cubit.clearSelection,
              icon: const Icon(Symbols.close_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  static String _profileName(ProjectMemberProfile profile) =>
      profile.displayName?.trim().isNotEmpty == true
      ? profile.displayName!.trim()
      : profile.coreUserId;
}

class _BulkToolbarButton extends StatelessWidget {
  const _BulkToolbarButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .symmetric(horizontal: 5),
    child: Row(
      mainAxisSize: .min,
      children: [
        Icon(icon, size: 16, color: context.colors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.text.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

class _BulkCustomStatusTarget {
  const _BulkCustomStatusTarget.assign(String id)
    : customStatusId = id,
      clearCustomStatus = false;
  const _BulkCustomStatusTarget.clear()
    : customStatusId = null,
      clearCustomStatus = true;

  final String? customStatusId;
  final bool clearCustomStatus;
}
