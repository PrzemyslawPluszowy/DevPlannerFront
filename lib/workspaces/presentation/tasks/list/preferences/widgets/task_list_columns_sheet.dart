import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/task_columns_sheet_column_pool.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/task_columns_sheet_header.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/task_columns_sheet_sections.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/task_columns_sheet_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

export 'task_columns_sheet_tab.dart';

/// Modalny arkusz personalizacji kolumn tabeli zadań.
class TaskListColumnsSheet extends StatefulWidget {
  const TaskListColumnsSheet({
    required this.cubit,
    super.key,
    this.customFields = const [],
    this.canManage = false,
    this.initialTab = TaskColumnsSheetTab.user,
  });

  final TaskListPreferencesCubit cubit;
  final List<TaskCustomFieldResponse> customFields;
  final bool canManage;
  final TaskColumnsSheetTab initialTab;

  /// Otwiera arkusz jako responsywne okno modalne.
  static Future<void> show(
    BuildContext context, {
    required TaskListPreferencesCubit cubit,
    List<TaskCustomFieldResponse> customFields = const [],
    bool canManage = false,
    TaskColumnsSheetTab initialTab = TaskColumnsSheetTab.user,
  }) => showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final size = MediaQuery.sizeOf(dialogContext);
      return BlocProvider.value(
        value: cubit,
        child: Dialog(
          backgroundColor: dialogContext.colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: (size.width * .94).clamp(720.0, 980.0),
              maxHeight: (size.height * .90).clamp(580.0, 780.0),
            ),
            child: TaskListColumnsSheet(
              cubit: cubit,
              customFields: customFields,
              canManage: canManage,
              initialTab: initialTab,
            ),
          ),
        ),
      );
    },
  );

  @override
  State<TaskListColumnsSheet> createState() => _TaskListColumnsSheetState();
}

class _TaskListColumnsSheetState extends State<TaskListColumnsSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _poolScrollController = ScrollController();
  late final ValueNotifier<_TaskColumnsSheetUiState> _ui = ValueNotifier(
    _TaskColumnsSheetUiState(selectedTab: widget.initialTab),
  );

  @override
  void initState() {
    super.initState();
    if (widget.canManage &&
        _ui.value.selectedTab == TaskColumnsSheetTab.project) {
      unawaited(widget.cubit.loadProjectPolicyDraft());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _poolScrollController.dispose();
    _ui.dispose();
    super.dispose();
  }

  void _changeTab(TaskColumnsSheetTab selectedTab) {
    _ui.value = _ui.value.copyWith(selectedTab: selectedTab);
    if (selectedTab == TaskColumnsSheetTab.project) {
      unawaited(widget.cubit.loadProjectPolicyDraft());
    }
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<_TaskColumnsSheetUiState>(
        valueListenable: _ui,
        builder: (context, ui, _) =>
            BlocBuilder<TaskListPreferencesCubit, TaskListPreferencesState>(
              bloc: widget.cubit,
              builder: (context, state) => switch (state) {
                TaskListPreferencesLoading() => const SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator()),
                ),
                TaskListPreferencesError(:final message) => _ErrorSheet(
                  message: message,
                  onReload: widget.cubit.load,
                ),
                TaskListPreferencesReady() => _readySheet(context, state, ui),
              },
            ),
      );

  Widget _readySheet(
    BuildContext context,
    TaskListPreferencesReady state,
    _TaskColumnsSheetUiState ui,
  ) {
    final isProjectTab = ui.selectedTab == TaskColumnsSheetTab.project;
    final visible = isProjectTab
        ? state.effectiveProjectDefaultColumns
        : state.effectiveVisibleColumns;
    return Padding(
      padding: const .all(20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: TaskColumnsSheetHeader(
                  canManage: widget.canManage,
                  selectedTab: ui.selectedTab,
                  isSaving: state.isSaving,
                  onTabChanged: _changeTab,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Symbols.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SheetSaveError(state: state, onRetry: widget.cubit.saveNow),
          if (isProjectTab) ...[
            ProjectPolicyBanner(isLoading: state.isLoadingProjectPolicy),
            const SizedBox(height: 12),
          ],
          ColumnsSheetPreview(
            visible: visible,
            state: state,
            cubit: widget.cubit,
            customFields: widget.customFields,
            isProjectTab: isProjectTab,
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: context.colors.outlineVariant.withValues(alpha: .4),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TaskColumnsSheetColumnPool(
              state: state,
              customFields: widget.customFields,
              isProjectTab: isProjectTab,
              searchController: _searchController,
              scrollController: _poolScrollController,
              query: ui.query,
              onQueryChanged: (query) =>
                  _ui.value = _ui.value.copyWith(query: query),
              onAdd: isProjectTab
                  ? widget.cubit.toggleProjectDefaultColumn
                  : widget.cubit.toggleColumn,
            ),
          ),
          const SizedBox(height: 12),
          ColumnsSheetActions(
            isProjectTab: isProjectTab,
            isSavingProjectPolicy: ui.isSavingProjectPolicy,
            onReset: _resetColumns,
            onDone: () => Navigator.of(context).pop(),
            onSaveProjectPolicy: _saveProjectPolicy,
          ),
        ],
      ),
    );
  }

  Future<void> _resetColumns() async {
    await widget.cubit.resetToProjectDefaults();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.tasksListColumnsResetSuccess)),
    );
  }

  Future<void> _saveProjectPolicy() async {
    _ui.value = _ui.value.copyWith(isSavingProjectPolicy: true);
    final success = await widget.cubit.saveAsProjectDefaults();
    if (!mounted) return;
    _ui.value = _ui.value.copyWith(isSavingProjectPolicy: false);
    final message = success
        ? context.l10n.tasksListProjectDefaultsSaved
        : 'Nie udało się zapisać domyślnych kolumn projektu.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    if (success) Navigator.of(context).pop();
  }
}

class _ErrorSheet extends StatelessWidget {
  const _ErrorSheet({required this.message, required this.onReload});

  final String message;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .all(24),
    child: Column(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      children: [
        Icon(
          Symbols.error_outline_rounded,
          size: 48,
          color: context.colors.error,
        ),
        const SizedBox(height: 12),
        Text(
          'Nie udało się załadować konfiguracji kolumn',
          style: context.text.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: .center,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zamknij'),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: onReload,
              icon: const Icon(Symbols.refresh_rounded, size: 16),
              label: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _TaskColumnsSheetUiState {
  const _TaskColumnsSheetUiState({
    required this.selectedTab,
    this.query = '',
    this.isSavingProjectPolicy = false,
  });

  final TaskColumnsSheetTab selectedTab;
  final String query;
  final bool isSavingProjectPolicy;

  _TaskColumnsSheetUiState copyWith({
    TaskColumnsSheetTab? selectedTab,
    String? query,
    bool? isSavingProjectPolicy,
  }) => _TaskColumnsSheetUiState(
    selectedTab: selectedTab ?? this.selectedTab,
    query: query ?? this.query,
    isSavingProjectPolicy: isSavingProjectPolicy ?? this.isSavingProjectPolicy,
  );
}
