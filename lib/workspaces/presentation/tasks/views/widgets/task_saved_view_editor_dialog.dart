import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/models/task_saved_view_draft.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_columns_section.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_filters_section.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_group_section.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/widgets/sections/task_saved_view_sort_section.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

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
  late TaskSavedViewDraft _draft;
  String? _nameError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialDraft;
    _nameController = TextEditingController(text: _draft.name);
    _searchController = TextEditingController(text: _draft.filter.search);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Nazwa widoku nie może być pusta');
      return;
    }

    final from = _draft.filter.dueFromUtc;
    final to = _draft.filter.dueToUtc;
    if (from != null && to != null && from.isAfter(to)) {
      setState(
        () => _dateError = 'Data początkowa musi być wcześniejsza niż końcowa',
      );
      return;
    }

    final finalDraft = _draft.copyWith(
      name: name,
      filter: _draft.filter.copyWith(
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

    return WorkspaceCreationModalWrapper(
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
                errorText: _nameError,
              ),
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
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
              sortField: _draft.sortField,
              sortDirection: _draft.sortDirection,
              onSortFieldChanged: (val) =>
                  setState(() => _draft = _draft.copyWith(sortField: val)),
              onSortDirectionChanged: (val) =>
                  setState(() => _draft = _draft.copyWith(sortDirection: val)),
            ),
            const SizedBox(height: 12),
            TaskSavedViewGroupSection(
              groupBy: _draft.groupBy,
              onGroupByChanged: (val) =>
                  setState(() => _draft = _draft.copyWith(groupBy: val)),
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
              filter: _draft.filter,
              searchController: _searchController,
              memberProfiles: widget.memberProfiles,
              availableLabels: widget.availableLabels,
              dateErrorMessage: _dateError,
              onFilterChanged: (val) {
                setState(() {
                  _draft = _draft.copyWith(filter: val);
                  if (_dateError != null) _dateError = null;
                });
              },
            ),
            const SizedBox(height: 20),
            TaskSavedViewColumnsSection(
              columns: _draft.columns,
              customFieldIds: _draft.customFieldIds,
              columnOrder: _draft.columnOrder,
              availableCustomFields: widget.availableCustomFields,
              onColumnsChanged: (val) =>
                  setState(() => _draft = _draft.copyWith(columns: val)),
              onCustomFieldIdsChanged: (val) =>
                  setState(() => _draft = _draft.copyWith(customFieldIds: val)),
              onColumnOrderChanged: (val) =>
                  setState(() => _draft = _draft.copyWith(columnOrder: val)),
            ),
          ],
        ),
      ),
    );
  }
}
