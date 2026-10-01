import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_time_zones_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_time_zones_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/task_recurrence_time_zone_menu_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Otwiera przeszukiwalny katalog stref zwrócony przez bieżący host API.
final class TaskRecurrenceTimeZonePicker extends StatefulWidget {
  const TaskRecurrenceTimeZonePicker({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.selectionScope,
    required this.value,
    required this.enabled,
    required this.onSelected,
    super.key,
  });

  final TaskRecurrenceRepository repository;
  final String workspaceId;
  final String projectId;
  final Object selectionScope;
  final String value;
  final bool enabled;
  final ValueChanged<String> onSelected;

  @override
  State<TaskRecurrenceTimeZonePicker> createState() =>
      _TaskRecurrenceTimeZonePickerState();
}

final class _TaskRecurrenceTimeZonePickerState
    extends State<TaskRecurrenceTimeZonePicker> {
  int _generation = 0;

  @override
  void didUpdateWidget(covariant TaskRecurrenceTimeZonePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameScope(oldWidget)) _generation++;
  }

  bool _sameScope(TaskRecurrenceTimeZonePicker oldWidget) =>
      identical(oldWidget.repository, widget.repository) &&
      oldWidget.workspaceId == widget.workspaceId &&
      oldWidget.projectId == widget.projectId &&
      oldWidget.value == widget.value &&
      identical(oldWidget.selectionScope, widget.selectionScope) &&
      oldWidget.enabled == widget.enabled;

  bool _isCurrent({
    required int generation,
    required TaskRecurrenceRepository repository,
    required String workspaceId,
    required String projectId,
    required String value,
    required Object selectionScope,
    required bool enabled,
  }) =>
      mounted &&
      generation == _generation &&
      identical(widget.repository, repository) &&
      widget.workspaceId == workspaceId &&
      widget.projectId == projectId &&
      widget.value == value &&
      identical(widget.selectionScope, selectionScope) &&
      widget.enabled == enabled &&
      enabled;

  @override
  void dispose() {
    _generation++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Builder(
    builder: (buttonContext) => OutlinedButton.icon(
      onPressed: widget.enabled ? () => unawaited(_open(buttonContext)) : null,
      icon: const Icon(Symbols.public_rounded, size: 16),
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        visualDensity: VisualDensity.compact,
        foregroundColor: context.colors.onSurface,
        side: BorderSide(color: context.tasksTheme.canvasBorder),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        textStyle: context.tasksTheme.controlText,
      ),
    ),
  );

  Future<void> _open(BuildContext sourceContext) {
    final repository = widget.repository;
    final workspaceId = widget.workspaceId;
    final projectId = widget.projectId;
    final value = widget.value;
    final selectionScope = widget.selectionScope;
    final enabled = widget.enabled;
    final generation = _generation;
    if (!sourceContext.mounted ||
        !_isCurrent(
          generation: generation,
          repository: repository,
          workspaceId: workspaceId,
          projectId: projectId,
          value: value,
          selectionScope: selectionScope,
          enabled: enabled,
        )) {
      return Future.value();
    }
    final anchor = AppContextMenu.positionFor(sourceContext);
    return AppContextMenu.showCustom(
      sourceContext,
      globalPosition: anchor,
      maxWidth: 340,
      maxHeight: 440,
      headerTitle: sourceContext.l10n.taskDetailsRecurrenceTimeZone,
      contentBuilder: (_, dismiss) => BlocProvider(
        create: (_) => _createCatalogCubit(
          repository: repository,
          workspaceId: workspaceId,
          projectId: projectId,
          value: value,
          isCurrent: () => _isCurrent(
            generation: generation,
            repository: repository,
            workspaceId: workspaceId,
            projectId: projectId,
            value: value,
            selectionScope: selectionScope,
            enabled: enabled,
          ),
        ),
        child: TaskRecurrenceTimeZoneMenu(
          currentId: value,
          isCurrent: () => _isCurrent(
            generation: generation,
            repository: repository,
            workspaceId: workspaceId,
            projectId: projectId,
            value: value,
            selectionScope: selectionScope,
            enabled: enabled,
          ),
          onSelected: widget.onSelected,
          onDismiss: dismiss,
        ),
      ),
    );
  }

  TaskRecurrenceTimeZonesCubit _createCatalogCubit({
    required TaskRecurrenceRepository repository,
    required String workspaceId,
    required String projectId,
    required String value,
    required bool Function() isCurrent,
  }) {
    final cubit = TaskRecurrenceTimeZonesCubit(
      repository: repository,
      workspaceId: workspaceId,
      projectId: projectId,
      currentId: value,
    );
    if (isCurrent()) unawaited(cubit.load());
    return cubit;
  }
}

class _DismissTimeZoneMenuIntent extends Intent {
  const _DismissTimeZoneMenuIntent();
}

/// Deleguje ładowanie i wyszukiwanie katalogu do lokalnego Cubita.
final class TaskRecurrenceTimeZoneMenu extends StatefulWidget {
  const TaskRecurrenceTimeZoneMenu({
    required this.currentId,
    required this.isCurrent,
    required this.onSelected,
    required this.onDismiss,
    super.key,
  });

  final String currentId;
  final bool Function() isCurrent;
  final ValueChanged<String> onSelected;
  final VoidCallback onDismiss;

  @override
  State<TaskRecurrenceTimeZoneMenu> createState() =>
      _TaskRecurrenceTimeZoneMenuState();
}

class _TaskRecurrenceTimeZoneMenuState
    extends State<TaskRecurrenceTimeZoneMenu> {
  void _search(String query) {
    if (!widget.isCurrent()) {
      widget.onDismiss();
      return;
    }
    context.read<TaskRecurrenceTimeZonesCubit>().search(query);
  }

  void _retry() {
    if (!widget.isCurrent()) {
      widget.onDismiss();
      return;
    }
    final cubit = context.read<TaskRecurrenceTimeZonesCubit>();
    if (!cubit.isClosed) unawaited(cubit.load());
  }

  void _select(String id) {
    final cubit = context.read<TaskRecurrenceTimeZonesCubit>();
    if (cubit.isClosed) return;
    if (!widget.isCurrent()) {
      widget.onDismiss();
      return;
    }
    widget.onSelected(id);
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) => Actions(
    actions: {
      _DismissTimeZoneMenuIntent: CallbackAction<_DismissTimeZoneMenuIntent>(
        onInvoke: (_) {
          widget.onDismiss();
          return null;
        },
      ),
    },
    child: Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape):
            _DismissTimeZoneMenuIntent(),
      },
      child:
          BlocBuilder<
            TaskRecurrenceTimeZonesCubit,
            TaskRecurrenceTimeZonesState
          >(
            builder: (context, state) => TimeZoneMenuLayout(
              state: state,
              currentId: widget.currentId,
              onSearch: _search,
              onRetry: _retry,
              onSelect: _select,
            ),
          ),
    ),
  );
}
