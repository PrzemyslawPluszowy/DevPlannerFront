import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/helpers/task_permission_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/bulk/task_list_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/filters/task_list_filters.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/inline_create/task_list_inline_create.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/task_list_columns_sheet.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/header/task_list_header.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_group_row.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_subtasks.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/task_list_grouping.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/task_recurrence_context_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

part 'task_list_table_builder.part.dart';
part 'task_list_table_resize.part.dart';
part 'task_list_table_row_item.part.dart';
part 'task_list_table_rows.part.dart';
part 'task_list_table_view.part.dart';

/// Główny komponent tabeli zadań projektu w stanie gotowości danych.
///
/// Zarządza przewijaniem poziomym/pionowym, ładowaniem metadanych
/// (pola niestandardowe, kamienie milowe), zwijaniem grup i operacjami D&D.
class TaskListTable extends StatefulWidget {
  const TaskListTable({
    required this.state,
    required this.groupBy,
    required this.columns,
    this.customFieldIds,
    this.columnReferences,
    required this.memberProfilesByUserId,
    this.preferencesCubit,
    this.metadataRevision = 0,
    super.key,
  });

  final ProjectTasksListReady state;
  final TaskSavedViewGroupBy groupBy;
  final List<TaskSavedViewColumn> columns;
  final List<String>? customFieldIds;
  final List<TaskColumnReference>? columnReferences;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final TaskListPreferencesCubit? preferencesCubit;

  /// Wersja rewizji metadanych (pól własnych, kamieni milowych).
  ///
  /// Przeładowanie metadanych następuje tylko przy zmianie tej rewizji
  /// lub identyfikatorów pól [customFieldIds], a nie przy każdej modyfikacji stanu zadań.
  final int metadataRevision;

  @override
  State<TaskListTable> createState() => _TaskListTableState();
}

class _TaskListTableState extends State<TaskListTable> {
  final ScrollController _controller = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  final ValueNotifier<_ColumnResizeGuideData?> _resizeGuideNotifier =
      ValueNotifier(null);
  final ValueNotifier<int> _localUiRevision = ValueNotifier(0);
  final Set<String> _collapsedGroupIds = {};
  final Map<TaskSavedViewColumn, double> _columnWidths = {};
  final Map<String, double> _columnWidthsById = {};
  final TextEditingController _rootCreateController = TextEditingController();
  String? _addingRootGroupKey;
  String? _addingSubtaskParentId;
  late Future<TaskListMetadataResult> _metadata;

  ProjectTasksListReady? _lastStateForGroupedRows;
  TaskSavedViewGroupBy? _lastGroupByForRows;
  TaskSavedViewSortField? _lastSortFieldForRows;
  TaskSavedViewSortDirection? _lastSortDirectionForRows;
  List<_ListRow>? _cachedGroupedRows;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_loadMoreIfNeeded);
    _metadata = _loadMetadata();
  }

  @override
  void didUpdateWidget(covariant TaskListTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.customFieldIds, widget.customFieldIds) ||
        oldWidget.metadataRevision != widget.metadataRevision) {
      _metadata = _loadMetadata();
    }
  }

  Future<TaskListMetadataResult> _loadMetadata() async {
    final cubit = context.read<ProjectTasksListCubit>();
    final fieldsFuture = context
        .read<TaskMetadataRepository>()
        .listCustomFields(
          workspaceId: cubit.workspaceId,
          projectId: cubit.projectId,
        );
    final milestonesFuture = context.read<MilestoneRepository>().listMilestones(
      workspaceId: cubit.workspaceId,
      projectId: cubit.projectId,
    );
    final (fieldsResult, milestonesResult) = await (
      fieldsFuture,
      milestonesFuture,
    ).wait;
    return TaskListMetadataResult(
      fields: fieldsResult.fold(
        (_) => const <TaskCustomFieldResponse>[],
        (f) => f,
      ),
      milestones: milestonesResult.fold(
        (_) => const <MilestoneResponse>[],
        (m) => m,
      ),
      fieldsError: fieldsResult.fold((e) => e.message, (_) => null),
      milestonesError: milestonesResult.fold((e) => e.message, (_) => null),
    );
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_loadMoreIfNeeded)
      ..dispose();
    _horizontalController.dispose();
    _rootCreateController.dispose();
    _resizeGuideNotifier.dispose();
    _localUiRevision.dispose();
    super.dispose();
  }

  void updateState(VoidCallback fn) {
    if (!mounted) return;
    fn();
    _localUiRevision.value++;
  }

  void _beginInlineRootCreate(String groupKey) {
    updateState(() {
      _collapsedGroupIds.remove(groupKey);
      _addingRootGroupKey = groupKey;
      _rootCreateController.clear();
    });
  }

  Future<void> _submitInlineRootCreate(String groupKey) async {
    final customStatusId = TaskListGrouping.customStatusIdForGroup(groupKey);
    final status =
        TaskListGrouping.statusForGroup(groupKey) ??
        (customStatusId != null || widget.groupBy == TaskSavedViewGroupBy.none
            ? ProjectTaskStatus.todo
            : null);
    final title = _rootCreateController.text;
    if (status == null || title.trim().isEmpty) return;
    final created = await context.read<ProjectTasksListCubit>().createRootTask(
      title: title,
      status: status,
      customStatusId: customStatusId,
    );
    if (!mounted || !created) return;
    updateState(() {
      _rootCreateController.clear();
      _addingRootGroupKey = null;
    });
  }

  Future<void> _beginInlineSubtaskCreate(
    ProjectTaskListItemResponse parent,
  ) async {
    final current = context.read<ProjectTasksListCubit>().state;
    updateState(() => _addingSubtaskParentId = parent.id);
    if (current is ProjectTasksListReady &&
        !current.expandedTaskIds.contains(parent.id)) {
      await context.read<ProjectTasksListCubit>().toggleSubtasks(parent);
    }
  }

  void _loadMoreIfNeeded() {
    if (!_controller.hasClients) return;
    if (_controller.position.extentAfter < 260) {
      unawaited(context.read<ProjectTasksListCubit>().loadMore());
    }
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: _localUiRevision,
    builder: (context, _, _) => _buildWithLocalUiState(context),
  );

  Widget _buildWithLocalUiState(BuildContext context) {
    final prefCubit =
        widget.preferencesCubit ??
        () {
          try {
            return context.read<TaskListPreferencesCubit>();
          } catch (_) {
            return null;
          }
        }();

    if (prefCubit != null) {
      return BlocBuilder<TaskListPreferencesCubit, TaskListPreferencesState>(
        bloc: prefCubit,
        builder: (context, prefState) {
          final readyState = prefState is TaskListPreferencesReady
              ? prefState
              : null;
          return _buildTableContent(
            context,
            prefCubit: prefCubit,
            prefState: readyState,
          );
        },
      );
    }

    return _buildTableContent(context);
  }

  Widget _buildTableContent(
    BuildContext context, {
    TaskListPreferencesCubit? prefCubit,
    TaskListPreferencesReady? prefState,
  }) {
    final state = widget.state;
    final groupedRows = _groupedRows(
      state,
      widget.groupBy,
      sortField: prefState?.sortField,
      sortDirection: prefState?.sortDirection,
    );
    final rows = _visibleRows(groupedRows, _collapsedGroupIds);
    final visibleColumns = TaskListGrid.visibleColumns(widget.columns);
    final canMoveBetweenGroups =
        widget.groupBy == TaskSavedViewGroupBy.none ||
        widget.groupBy == TaskSavedViewGroupBy.status ||
        widget.groupBy == TaskSavedViewGroupBy.customStatus;

    return FutureBuilder<TaskListMetadataResult>(
      future: _metadata,
      builder: (context, snapshot) {
        final metaData = snapshot.data;
        final fields = metaData?.fields ?? const <TaskCustomFieldResponse>[];
        final milestonesList =
            metaData?.milestones ?? const <MilestoneResponse>[];
        final milestonesById = {
          for (final m in milestonesList) m.id: m,
        };

        return _buildList(
          context,
          state,
          rows,
          visibleColumns,
          _visibleCustomFields(fields),
          milestonesById,
          canMoveBetweenGroups,
          prefCubit: prefCubit,
          prefState: prefState,
          metadataResult: metaData,
        );
      },
    );
  }

  List<TaskCustomFieldResponse> _visibleCustomFields(
    List<TaskCustomFieldResponse> definitions,
  ) {
    final filterIds = widget.customFieldIds;
    if (filterIds == null) return definitions;
    return definitions
        .where((field) => filterIds.contains(field.id))
        .toList(growable: false);
  }
}

/// Wynik asynchronicznego pobrania metadanych projektu (pól własnych i kamieni milowych)
/// z jawnym zachowaniem ewentualnych błędów zapytań sieciowych.
class TaskListMetadataResult {
  const TaskListMetadataResult({
    this.fields = const [],
    this.milestones = const [],
    this.fieldsError,
    this.milestonesError,
  });

  /// Lista definicji pól własnych dostępnych w projekcie.
  final List<TaskCustomFieldResponse> fields;

  /// Lista kamieni milowych skonfigurowanych w projekcie.
  final List<MilestoneResponse> milestones;

  /// Komunikat błędu pobierania pól własnych, jeśli wystąpił.
  final String? fieldsError;

  /// Komunikat błędu pobierania kamieni milowych, jeśli wystąpił.
  final String? milestonesError;

  /// Czy wystąpił błąd pobrania któregokolwiek ze składników metadanych.
  bool get hasError => fieldsError != null || milestonesError != null;

  /// Scalony, przyjazny dla użytkownika komunikat błędu metadanych.
  String? get errorMessage {
    if (fieldsError != null && milestonesError != null) {
      return 'Nie udało się pobrać pól własnych ani kamieni milowych projektu.';
    }
    if (fieldsError != null) {
      return 'Nie udało się pobrać definicji pól własnych ($fieldsError).';
    }
    if (milestonesError != null) {
      return 'Nie udało się pobrać kamieni milowych ($milestonesError).';
    }
    return null;
  }
}
