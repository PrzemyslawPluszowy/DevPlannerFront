import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/models/task_saved_view_draft.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_columns_section.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_filters_section.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_group_section.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_sort_section.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wynik dialogu konfiguratora zapisanego widoku.
@immutable
final class TaskSavedViewEditorResult {
  const TaskSavedViewEditorResult({
    required this.name,
    required this.draft,
  });

  final String name;
  final TaskSavedViewDraft draft;
}

/// Pełny dialog edycji i konfiguracji widoku (filtry, sortowanie, grupowanie, kolumny).
class TaskSavedViewEditorDialog extends StatefulWidget {
  const TaskSavedViewEditorDialog({
    required this.initialDraft,
    this.availableLabels = const [],
    this.availableCustomFields = const [],
    this.memberProfiles = const {},
    this.title,
    super.key,
  });

  final TaskSavedViewDraft initialDraft;
  final List<TaskLabelResponse> availableLabels;
  final List<TaskCustomFieldResponse> availableCustomFields;
  final Map<String, ProjectMemberProfile> memberProfiles;
  final String? title;

  static Future<TaskSavedViewEditorResult?> show(
    BuildContext context, {
    required TaskSavedViewDraft initialDraft,
    List<TaskLabelResponse> availableLabels = const [],
    List<TaskCustomFieldResponse> availableCustomFields = const [],
    Map<String, ProjectMemberProfile> memberProfiles = const {},
    String? title,
  }) => showDialog<TaskSavedViewEditorResult>(
    context: context,
    builder: (context) => TaskSavedViewEditorDialog(
      initialDraft: initialDraft,
      availableLabels: availableLabels,
      availableCustomFields: availableCustomFields,
      memberProfiles: memberProfiles,
      title: title,
    ),
  );

  @override
  State<TaskSavedViewEditorDialog> createState() =>
      _TaskSavedViewEditorDialogState();
}

class _TaskSavedViewEditorDialogState extends State<TaskSavedViewEditorDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _searchController;
  late final ValueNotifier<_TaskSavedViewEditorUiState> _uiState;

  @override
  void initState() {
    super.initState();
    _uiState = ValueNotifier(
      _TaskSavedViewEditorUiState(draft: widget.initialDraft),
    );
    _nameController = TextEditingController(text: widget.initialDraft.name);
    _searchController = TextEditingController(
      text: widget.initialDraft.filter.search,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    _uiState.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _uiState.value = _uiState.value.copyWith(
        nameError: 'Nazwa widoku nie może być pusta',
      );
      return;
    }

    final draft = _uiState.value.draft;
    final from = draft.filter.dueFromUtc;
    final to = draft.filter.dueToUtc;
    if (from != null && to != null && from.isAfter(to)) {
      _uiState.value = _uiState.value.copyWith(
        dateError: 'Data początkowa musi być wcześniejsza niż końcowa',
      );
      return;
    }

    final finalDraft = draft.copyWith(
      name: name,
      filter: draft.filter.copyWith(
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
      ),
    );

    Navigator.of(context).pop(
      TaskSavedViewEditorResult(name: name, draft: finalDraft),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return ValueListenableBuilder<_TaskSavedViewEditorUiState>(
      valueListenable: _uiState,
      builder: (context, uiState, _) => WorkspaceCreationModalWrapper(
        title: widget.title ?? l10n.tasksSavedViewsManage,
        subtitle: l10n.tasksSavedViewsLayout,
        icon: Symbols.tune_rounded,
        accentColor: colors.primary,
        submitLabel: l10n.save,
        cancelLabel: l10n.cancel,
        maxWidth: 580,
        onSubmit: _validateAndSubmit,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                maxLength: 120,
                decoration: InputDecoration(
                  labelText: l10n.tasksSavedViewsName,
                  errorText: uiState.nameError,
                ),
                onChanged: (_) {
                  if (uiState.nameError != null) {
                    _uiState.value = uiState.copyWith(clearNameError: true);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                l10n.tasksSavedViewsLayout,
                style: context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TaskSavedViewSortSection(
                sortField: uiState.draft.sortField,
                sortDirection: uiState.draft.sortDirection,
                onSortFieldChanged: (val) => _uiState.value = uiState.copyWith(
                  draft: uiState.draft.copyWith(sortField: val),
                ),
                onSortDirectionChanged: (val) =>
                    _uiState.value = uiState.copyWith(
                      draft: uiState.draft.copyWith(sortDirection: val),
                    ),
              ),
              const SizedBox(height: 12),
              TaskSavedViewGroupSection(
                groupBy: uiState.draft.groupBy,
                onGroupByChanged: (val) => _uiState.value = uiState.copyWith(
                  draft: uiState.draft.copyWith(groupBy: val),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.tasksSavedViewsFilters,
                style: context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              TaskSavedViewFiltersSection(
                filter: uiState.draft.filter,
                searchController: _searchController,
                memberProfiles: widget.memberProfiles,
                availableLabels: widget.availableLabels,
                dateErrorMessage: uiState.dateError,
                onFilterChanged: (val) => _uiState.value = uiState.copyWith(
                  draft: uiState.draft.copyWith(filter: val),
                  clearDateError: true,
                ),
              ),
              const SizedBox(height: 20),
              TaskSavedViewColumnsSection(
                columns: uiState.draft.columns,
                customFieldIds: uiState.draft.customFieldIds,
                columnOrder: uiState.draft.columnOrder,
                availableCustomFields: widget.availableCustomFields,
                onColumnsChanged: (val) => _uiState.value = uiState.copyWith(
                  draft: uiState.draft.copyWith(columns: val),
                ),
                onCustomFieldIdsChanged: (val) =>
                    _uiState.value = uiState.copyWith(
                      draft: uiState.draft.copyWith(customFieldIds: val),
                    ),
                onColumnOrderChanged: (val) =>
                    _uiState.value = uiState.copyWith(
                      draft: uiState.draft.copyWith(columnOrder: val),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _TaskSavedViewEditorUiState {
  const _TaskSavedViewEditorUiState({
    required this.draft,
    this.nameError,
    this.dateError,
  });

  final TaskSavedViewDraft draft;
  final String? nameError;
  final String? dateError;

  _TaskSavedViewEditorUiState copyWith({
    TaskSavedViewDraft? draft,
    String? nameError,
    bool clearNameError = false,
    String? dateError,
    bool clearDateError = false,
  }) => _TaskSavedViewEditorUiState(
    draft: draft ?? this.draft,
    nameError: clearNameError ? null : nameError ?? this.nameError,
    dateError: clearDateError ? null : dateError ?? this.dateError,
  );
}
