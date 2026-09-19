import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
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
      child: Builder(
        builder: (buttonContext) => Tooltip(
          message: context.l10n.tasksSavedViews,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: ready == null || ready.busy
                  ? null
                  : () => unawaited(
                      _openMenu(
                        buttonContext,
                        ready: ready,
                        cubit: cubit,
                        metadata: metadata,
                        isDirty: isDirty,
                        isDefaultActive: isDefaultActive,
                        currentSnapshot: currentSnapshot,
                      ),
                    ),
              child: compact
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
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
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: context.colors.outlineVariant,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDirty
                                    ? Symbols.bookmark_manager_rounded
                                    : Symbols.bookmark_rounded,
                                size: 18,
                                color: isDirty ? context.colors.tertiary : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isDefaultActive
                                    ? context.l10n.tasksSavedViewsDefault
                                    : activeView?.name ??
                                          context.l10n.tasksSavedViews,
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
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openMenu(
    BuildContext context, {
    required TaskSavedViewsReady? ready,
    required TaskSavedViewsCubit cubit,
    required TaskSavedViewMetadataReady? metadata,
    required bool isDirty,
    required bool isDefaultActive,
    required TaskListViewSnapshot? currentSnapshot,
  }) async {
    final views = ready?.views ?? const <TaskSavedViewResponse>[];
    final activeViewId = ready?.activeViewId;
    final action = await AppContextMenu.select<TaskSavedViewMenuAction>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: context.l10n.tasksSavedViews,
      options: [
        AppContextMenuOption<TaskSavedViewMenuAction>(
          value: const TaskSavedViewMenuActionSaveCurrent(),
          label: context.l10n.tasksSavedViewsSaveCurrent,
          icon: Symbols.add_rounded,
          enabled: currentSnapshot != null,
        ),
        if (isDirty)
          AppContextMenuOption<TaskSavedViewMenuAction>(
            value: const TaskSavedViewMenuActionSaveActiveChanges(),
            label: context.l10n.tasksSavedViewsSaveActiveChanges,
            icon: Symbols.save_rounded,
          ),
        AppContextMenuOption<TaskSavedViewMenuAction>(
          value: const TaskSavedViewMenuActionSelectDefault(),
          label: context.l10n.tasksSavedViewsDefault,
          icon: Symbols.view_agenda_rounded,
          selected: isDefaultActive,
          separatorBefore: true,
        ),
        for (final view in views)
          AppContextMenuOption<TaskSavedViewMenuAction>(
            value: TaskSavedViewMenuActionSelect(view.id),
            label: view.name,
            icon: Symbols.bookmark_rounded,
            selected: activeViewId == view.id,
            separatorBefore: view == views.first,
            trailing: _SavedViewRowActions(
              onPressed: (anchorGlobalPosition) => unawaited(
                _openItemActions(
                  context,
                  anchorGlobalPosition,
                  view,
                  cubit,
                  metadata,
                ),
              ),
            ),
          ),
      ],
    );
    if (action == null || !context.mounted) return;
    await _handleAction(
      context,
      action,
      ready,
      cubit,
      metadata: metadata,
      isDirty: isDirty,
    );
  }

  /// Otwiera akcje pojedynczego widoku zakotwiczone w jego wierszu menu.
  ///
  /// Menu nadrzędne jest już zamknięte przez [_SavedViewRowActions], a pozycję
  /// kotwiczenia wylicza przycisk wiersza, więc akcje pojawiają się przy
  /// klikniętej pozycji, a nie przy triggerze całego menu.
  Future<void> _openItemActions(
    BuildContext context,
    Offset anchorGlobalPosition,
    TaskSavedViewResponse view,
    TaskSavedViewsCubit cubit,
    TaskSavedViewMetadataReady? metadata,
  ) async {
    final itemAction = await AppContextMenu.select<_SavedViewItemAction>(
      context,
      globalPosition: anchorGlobalPosition,
      headerTitle: view.name,
      options: [
        AppContextMenuOption<_SavedViewItemAction>(
          value: _SavedViewItemAction.configure,
          label: context.l10n.tasksSavedViewsManage,
          icon: Symbols.tune_rounded,
        ),
        AppContextMenuOption<_SavedViewItemAction>(
          value: _SavedViewItemAction.rename,
          label: context.l10n.tasksSavedViewsRename,
          icon: Symbols.edit_rounded,
        ),
        AppContextMenuOption<_SavedViewItemAction>(
          value: _SavedViewItemAction.delete,
          label: context.l10n.tasksSavedViewsDelete,
          icon: Symbols.delete_outline_rounded,
          isDestructive: true,
          separatorBefore: true,
        ),
      ],
    );
    if (itemAction == null || !context.mounted) return;
    await _handleItemAction(context, view, itemAction, cubit, metadata);
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

/// Akcje pojedynczego widoku w wierszu menu zapisanych widoków.
///
/// Przycisk przejmuje zdarzenie przed wierszem menu, więc kliknięcie nie wybiera
/// widoku. Pozycja kotwiczenia jest liczona w kontekście klikniętego przycisku,
/// a menu nadrzędne zamyka się, żeby akcje widoku nie odsłaniały listy widoków
/// pod spodem.
class _SavedViewRowActions extends StatelessWidget {
  const _SavedViewRowActions({required this.onPressed});

  final void Function(Offset anchorGlobalPosition) onPressed;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (buttonContext) => IconButton(
      tooltip: context.l10n.tasksSavedViewsManage,
      onPressed: () {
        final anchorGlobalPosition = AppContextMenu.positionFor(buttonContext);
        Navigator.of(buttonContext, rootNavigator: true).pop();
        onPressed(anchorGlobalPosition);
      },
      icon: const Icon(Symbols.more_horiz_rounded, size: Sizes.p16),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 24, height: 24),
      visualDensity: VisualDensity.compact,
      color: context.colors.onSurfaceVariant,
    ),
  );
}
