import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/cubit/task_saved_view_metadata_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/cubit/task_saved_views_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/models/task_list_view_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/models/task_saved_view_draft.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/widgets/task_saved_view_dirty_badge.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/widgets/task_saved_view_editor_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/widgets/task_saved_view_name_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/widgets/task_saved_views_feedback_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Intencje użytkownika z menu zapisanych widoków.
sealed class TaskSavedViewMenuAction {
  const TaskSavedViewMenuAction();
}

final class TaskSavedViewMenuActionSaveCurrent extends TaskSavedViewMenuAction {
  const TaskSavedViewMenuActionSaveCurrent();
}

final class TaskSavedViewMenuActionSelectDefault
    extends TaskSavedViewMenuAction {
  const TaskSavedViewMenuActionSelectDefault();
}

final class TaskSavedViewMenuActionSelect extends TaskSavedViewMenuAction {
  const TaskSavedViewMenuActionSelect(this.id);
  final String id;
}

final class TaskSavedViewMenuActionSaveActiveChanges
    extends TaskSavedViewMenuAction {
  const TaskSavedViewMenuActionSaveActiveChanges();
}

enum _SavedViewItemAction { configure, rename, delete }

/// Główne menu zapisanych widoków zadań projektu.
///
/// Prezentuje opcję zapisu bieżącego widoku, powrót do widoku domyślnego,
/// listę widoków oraz akcje zarządzania (zmiana nazwy, konfiguracja, usunięcie).
class TaskSavedViewsMenu extends StatelessWidget {
  const TaskSavedViewsMenu({
    required this.compact,
    required this.workspaceId,
    required this.projectId,
    this.currentSnapshot,
    this.memberProfiles = const {},
    super.key,
  });

  final bool compact;
  final String workspaceId;
  final String projectId;
  final TaskListViewSnapshot? currentSnapshot;
  final Map<String, ProjectMemberProfile> memberProfiles;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TaskSavedViewsCubit?>();
    if (cubit == null) return const SizedBox.shrink();
    final state = cubit.state;
    final ready = state is TaskSavedViewsReady ? state : null;
    final metadataState = context.watch<TaskSavedViewMetadataCubit?>()?.state;
    final metadata = metadataState is TaskSavedViewMetadataReady
        ? metadataState
        : null;

    final activeView = ready?.activeView;
    final isDirty =
        activeView != null &&
        currentSnapshot != null &&
        TaskListViewSnapshot.fromDefinition(activeView.view) != currentSnapshot;

    final isDefaultActive = ready != null && ready.activeViewId == null;

    return TaskSavedViewsFeedbackListener(
      cubit: cubit,
      child: PopupMenuButton<TaskSavedViewMenuAction>(
        tooltip: context.l10n.tasksSavedViews,
        enabled: ready != null && !ready.busy,
        onSelected: (action) => _handleAction(
          context,
          action,
          ready,
          cubit,
          metadata: metadata,
          isDirty: isDirty,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: const TaskSavedViewMenuActionSaveCurrent(),
            enabled: currentSnapshot != null,
            child: ListTile(
              leading: const Icon(Symbols.add_rounded, size: 20),
              title: Text(context.l10n.tasksSavedViewsSaveCurrent),
              subtitle: currentSnapshot == null
                  ? Text(context.l10n.tasksSavedViewsListLoading)
                  : null,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          if (isDirty)
            PopupMenuItem(
              value: const TaskSavedViewMenuActionSaveActiveChanges(),
              child: ListTile(
                leading: const Icon(Symbols.save_rounded, size: 20),
                title: Text(context.l10n.tasksSavedViewsSaveActiveChanges),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          PopupMenuItem(
            value: const TaskSavedViewMenuActionSelectDefault(),
            child: Row(
              children: [
                Icon(
                  isDefaultActive
                      ? Symbols.check_rounded
                      : Symbols.view_agenda_rounded,
                  size: 18,
                  color: isDefaultActive ? context.colors.primary : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.tasksSavedViewsDefault,
                    style: TextStyle(
                      fontWeight: isDefaultActive ? FontWeight.w600 : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (ready != null && ready.views.isNotEmpty) ...[
            const PopupMenuDivider(),
            for (final view in ready.views)
              PopupMenuItem(
                value: TaskSavedViewMenuActionSelect(view.id),
                child: Row(
                  children: [
                    Icon(
                      ready.activeViewId == view.id
                          ? Symbols.check_rounded
                          : Symbols.bookmark_rounded,
                      size: 18,
                      color: ready.activeViewId == view.id
                          ? context.colors.primary
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        view.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: ready.activeViewId == view.id
                              ? FontWeight.w600
                              : null,
                        ),
                      ),
                    ),
                    if (ready.activeViewId == view.id && isDirty) ...[
                      const SizedBox(width: 6),
                      const TaskSavedViewDirtyBadge(),
                    ],
                    PopupMenuButton<_SavedViewItemAction>(
                      tooltip: context.l10n.tasksSavedViewsManage,
                      onSelected: (itemAction) => _handleItemAction(
                        context,
                        view,
                        itemAction,
                        cubit,
                        metadata,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: _SavedViewItemAction.configure,
                          child: Text(context.l10n.tasksSavedViewsManage),
                        ),
                        PopupMenuItem(
                          value: _SavedViewItemAction.rename,
                          child: Text(context.l10n.tasksSavedViewsRename),
                        ),
                        PopupMenuItem(
                          value: _SavedViewItemAction.delete,
                          child: Text(context.l10n.tasksSavedViewsDelete),
                        ),
                      ],
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Symbols.more_horiz_rounded, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
        child: compact
            ? ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                child: Center(
                  child: Icon(
                    isDirty
                        ? Symbols.bookmark_manager_rounded
                        : Symbols.bookmark_rounded,
                    size: 20,
                    color: isDirty ? context.colors.tertiary : null,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(right: 8),
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: Icon(
                    isDirty
                        ? Symbols.bookmark_manager_rounded
                        : Symbols.bookmark_rounded,
                    size: 18,
                    color: isDirty ? context.colors.tertiary : null,
                  ),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isDefaultActive
                            ? context.l10n.tasksSavedViewsDefault
                            : activeView?.name ?? context.l10n.tasksSavedViews,
                      ),
                      if (isDirty) ...[
                        const SizedBox(width: 6),
                        const TaskSavedViewDirtyBadge(),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    TaskSavedViewMenuAction action,
    TaskSavedViewsReady? ready,
    TaskSavedViewsCubit cubit, {
    TaskSavedViewMetadataReady? metadata,
    required bool isDirty,
  }) async {
    switch (action) {
      case TaskSavedViewMenuActionSaveCurrent():
        if (currentSnapshot == null) return;
        final result = await TaskSavedViewNameDialog.show(
          context,
          snapshot: currentSnapshot,
        );
        if (result == null || !context.mounted) return;

        if (result.openConfigurator) {
          final editorResult = await TaskSavedViewEditorDialog.show(
            context,
            initialDraft: TaskSavedViewDraft.fromDefinition(
              name: result.name,
              definition: currentSnapshot!.toDefinition(),
            ),
            availableLabels: metadata?.labels ?? const [],
            availableCustomFields: metadata?.customFields ?? const [],
            memberProfiles: memberProfiles,
            title: 'Konfiguruj i zapisz widok',
          );
          if (editorResult != null && context.mounted) {
            await cubit.create(
              CreateTaskSavedViewPayload(
                name: editorResult.name,
                view: editorResult.draft.toDefinition(),
              ),
            );
          }
        } else {
          await cubit.create(
            CreateTaskSavedViewPayload(
              name: result.name,
              view: currentSnapshot!.toDefinition(),
            ),
          );
        }

      case TaskSavedViewMenuActionSaveActiveChanges():
        final active = ready?.activeView;
        if (active == null || currentSnapshot == null) return;
        await cubit.update(
          active.id,
          UpdateTaskSavedViewPayload(
            name: active.name,
            view: currentSnapshot!.toDefinition(),
            expectedVersion: active.version,
          ),
        );

      case TaskSavedViewMenuActionSelectDefault():
        cubit.select(null);

      case TaskSavedViewMenuActionSelect(:final id):
        cubit.select(id);
    }
  }

  Future<void> _handleItemAction(
    BuildContext context,
    TaskSavedViewResponse view,
    _SavedViewItemAction action,
    TaskSavedViewsCubit cubit,
    TaskSavedViewMetadataReady? metadata,
  ) async {
    switch (action) {
      case _SavedViewItemAction.rename:
        final result = await TaskSavedViewNameDialog.show(
          context,
          initialName: view.name,
          title: context.l10n.tasksSavedViewsRename,
          allowConfigure: false,
        );
        if (result != null && context.mounted) {
          await cubit.update(
            view.id,
            UpdateTaskSavedViewPayload(
              name: result.name,
              view: view.view,
              expectedVersion: view.version,
            ),
          );
        }

      case _SavedViewItemAction.configure:
        final result = await TaskSavedViewEditorDialog.show(
          context,
          initialDraft: TaskSavedViewDraft.fromDefinition(
            name: view.name,
            definition: view.view,
          ),
          availableLabels: metadata?.labels ?? const [],
          availableCustomFields: metadata?.customFields ?? const [],
          memberProfiles: memberProfiles,
          title: context.l10n.tasksSavedViewsManage,
        );

        if (result != null && context.mounted) {
          await cubit.update(
            view.id,
            UpdateTaskSavedViewPayload(
              name: result.name,
              view: result.draft.toDefinition(),
              expectedVersion: view.version,
            ),
          );
        }

      case _SavedViewItemAction.delete:
        final confirmed = await AppConfirmDialog.show(
          context,
          title: context.l10n.tasksSavedViewsDelete,
          message: context.l10n.tasksSavedViewsDeleteDescription(view.name),
          confirmLabel: context.l10n.delete,
          cancelLabel: context.l10n.cancel,
          tone: AppConfirmDialogTone.danger,
        );
        if (confirmed && context.mounted) {
          await cubit.delete(view.id);
        }
    }
  }
}
