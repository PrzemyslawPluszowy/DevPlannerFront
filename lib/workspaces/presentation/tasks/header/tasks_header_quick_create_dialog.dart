part of 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';

class TaskQuickCreateDialog extends StatefulWidget {
  const TaskQuickCreateDialog({
    required this.columns,
    required this.onCreate,
    super.key,
  });

  final List<KanbanColumnResponse> columns;
  final Future<bool> Function({
    required String title,
    required KanbanColumnResponse column,
    String? taskTemplateId,
    bool useDefaultTemplate,
  })
  onCreate;

  @override
  State<TaskQuickCreateDialog> createState() => _TaskQuickCreateDialogState();
}

class _TaskQuickCreateDialogState extends State<TaskQuickCreateDialog> {
  late final TextEditingController _titleController;
  final FocusNode _titleFocus = FocusNode();
  late final ValueNotifier<_TaskQuickCreateDialogViewState> _viewState;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _viewState = ValueNotifier(
      _TaskQuickCreateDialogViewState(column: widget.columns.first),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocus.dispose();
    _viewState.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final viewState = _viewState.value;
    if (viewState.isSubmitting) return;
    if (title.isEmpty) {
      _viewState.value = viewState.copyWith(showTitleError: true);
      _titleFocus.requestFocus();
      return;
    }
    _viewState.value = viewState.copyWith(isSubmitting: true);
    final created = await widget.onCreate(
      title: title,
      column: viewState.column,
      taskTemplateId: viewState.selectedTemplateId,
      useDefaultTemplate: viewState.useDefaultTemplate,
    );
    if (!mounted) return;
    if (created) {
      Navigator.of(context).pop();
    } else {
      _viewState.value = _viewState.value.copyWith(isSubmitting: false);
    }
  }

  void _onTitleChanged(String title) {
    if (_viewState.value.showTitleError && title.trim().isNotEmpty) {
      _viewState.value = _viewState.value.copyWith(showTitleError: false);
    }
  }

  void _onColumnChanged(KanbanColumnResponse column) {
    _viewState.value = _viewState.value.copyWith(column: column);
  }

  void _onTemplateChanged(String? value) {
    _viewState.value = _viewState.value.copyWith(
      selectedTemplateId: value,
      clearSelectedTemplateId: value == null,
      useDefaultTemplate: false,
    );
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<_TaskQuickCreateDialogViewState>(
        valueListenable: _viewState,
        builder: (context, viewState, _) => _TaskQuickCreateContent(
          columns: widget.columns,
          viewState: viewState,
          titleController: _titleController,
          titleFocus: _titleFocus,
          onSubmit: _submit,
          onTitleChanged: _onTitleChanged,
          onColumnChanged: _onColumnChanged,
          onTemplateChanged: _onTemplateChanged,
        ),
      );
}

final class _TaskQuickCreateContent extends StatelessWidget {
  const _TaskQuickCreateContent({
    required this.columns,
    required this.viewState,
    required this.titleController,
    required this.titleFocus,
    required this.onSubmit,
    required this.onTitleChanged,
    required this.onColumnChanged,
    required this.onTemplateChanged,
  });
  final List<KanbanColumnResponse> columns;
  final _TaskQuickCreateDialogViewState viewState;
  final TextEditingController titleController;
  final FocusNode titleFocus;
  final VoidCallback onSubmit;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<KanbanColumnResponse> onColumnChanged;
  final ValueChanged<String?> onTemplateChanged;

  static Color _columnColor(String color, Color fallback) {
    final hex = int.tryParse(color.replaceFirst('#', ''), radix: 16);
    return hex == null ? fallback : Color(0xFF000000 | hex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateTaskTitle,
      subtitle: l10n.workspacesCreateTaskSubtitle,
      icon: WorkspaceIcons.tasks,
      accentColor: colors.primary,
      isSubmitting: viewState.isSubmitting,
      submitLabel: l10n.create,
      cancelLabel: l10n.cancel,
      maxWidth: 460,
      onSubmit: onSubmit,
      body: Column(
        mainAxisSize: .min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.workspacesTaskTitleLabel,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h8,
          TextField(
            controller: titleController,
            focusNode: titleFocus,
            onChanged: onTitleChanged,
            autofocus: true,
            enabled: !viewState.isSubmitting,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: l10n.tasksQuickCreateHint,
              errorText: viewState.showTitleError
                  ? l10n.workspacesTaskTitleRequired
                  : null,
              border: const OutlineInputBorder(
                borderRadius: .all(.circular(10)),
              ),
              contentPadding: const .symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p12,
              ),
            ),
            onSubmitted: (_) => onSubmit(),
          ),
          Gaps.h16,
          Text(
            l10n.tasksListStatus,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h8,
          TaskQuickCreateSelect(
            label: viewState.column.displayName,
            leading: Icon(
              Icons.circle,
              size: 10,
              color: _columnColor(viewState.column.color, colors.primary),
            ),
            options: [
              for (var index = 0; index < columns.length; index++)
                AppContextMenuOption<int>(
                  value: index,
                  label: columns[index].displayName,
                  icon: Icons.circle,
                  iconColor: _columnColor(columns[index].color, colors.primary),
                  selected: columns[index] == viewState.column,
                ),
            ],
            onSelected: viewState.isSubmitting
                ? null
                : (index) => onColumnChanged(columns[index]),
          ),
          Builder(
            builder: (context) {
              final pickerState = context
                  .watch<TaskTemplatePickerCubit?>()
                  ?.state;
              final templates = switch (pickerState) {
                TaskTemplatePickerReady(:final templates) => templates,
                _ => const <TaskTemplateResponse>[],
              };
              final defaultTemplateId = switch (pickerState) {
                TaskTemplatePickerReady(:final defaultTemplateId) =>
                  defaultTemplateId,
                _ => null,
              };
              if (templates.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: .min,
                children: [
                  Gaps.h16,
                  Text(
                    l10n.tasksTemplateForThisTask,
                    style: context.text.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Gaps.h8,
                  _TaskTemplateSelect(
                    templates: templates,
                    selectedId:
                        viewState.selectedTemplateId ??
                        (viewState.useDefaultTemplate
                            ? defaultTemplateId
                            : null),
                    defaultId: defaultTemplateId,
                    onSelected: viewState.isSubmitting
                        ? null
                        : onTemplateChanged,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

final class _TaskTemplateSelect extends StatelessWidget {
  const _TaskTemplateSelect({
    required this.templates,
    required this.selectedId,
    required this.defaultId,
    required this.onSelected,
  });
  final List<TaskTemplateResponse> templates;
  final String? selectedId;
  final String? defaultId;
  final ValueChanged<String?>? onSelected;

  String _label(BuildContext context, TaskTemplateResponse template) =>
      template.id == defaultId
      ? '${template.name} (${context.l10n.tasksTemplatesDefault})'
      : template.name;

  @override
  Widget build(BuildContext context) {
    final selected = templates
        .where((item) => item.id == selectedId)
        .firstOrNull;
    return TaskQuickCreateSelect(
      label: selected == null
          ? context.l10n.tasksTemplateNoTemplate
          : _label(context, selected),
      options: [
        AppContextMenuOption<int>(
          value: 0,
          label: context.l10n.tasksTemplateNoTemplate,
          selected: selectedId == null,
        ),
        for (var index = 0; index < templates.length; index++)
          AppContextMenuOption<int>(
            value: index + 1,
            label: _label(context, templates[index]),
            icon: templates[index].id == defaultId
                ? Symbols.star_rounded
                : Symbols.auto_awesome_mosaic_rounded,
            selected: templates[index].id == selectedId,
          ),
      ],
      onSelected: onSelected == null
          ? null
          : (index) => onSelected!(index == 0 ? null : templates[index - 1].id),
    );
  }
}

class _TaskQuickCreateDialogViewState {
  const _TaskQuickCreateDialogViewState({
    required this.column,
    this.isSubmitting = false,
    this.showTitleError = false,
    this.selectedTemplateId,
    this.useDefaultTemplate = true,
  });

  final KanbanColumnResponse column;
  final bool isSubmitting;
  final bool showTitleError;
  final String? selectedTemplateId;
  final bool useDefaultTemplate;

  _TaskQuickCreateDialogViewState copyWith({
    KanbanColumnResponse? column,
    bool? isSubmitting,
    bool? showTitleError,
    String? selectedTemplateId,
    bool clearSelectedTemplateId = false,
    bool? useDefaultTemplate,
  }) => _TaskQuickCreateDialogViewState(
    column: column ?? this.column,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    showTitleError: showTitleError ?? this.showTitleError,
    selectedTemplateId: clearSelectedTemplateId
        ? null
        : selectedTemplateId ?? this.selectedTemplateId,
    useDefaultTemplate: useDefaultTemplate ?? this.useDefaultTemplate,
  );
}
