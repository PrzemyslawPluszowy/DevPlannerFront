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
    _viewState.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final viewState = _viewState.value;
    if (viewState.isSubmitting || title.isEmpty) return;
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

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<_TaskQuickCreateDialogViewState>(
        valueListenable: _viewState,
        builder: (context, viewState, _) => _buildDialog(context, viewState),
      );

  Widget _buildDialog(
    BuildContext context,
    _TaskQuickCreateDialogViewState viewState,
  ) {
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
      onSubmit: _submit,
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
            controller: _titleController,
            autofocus: true,
            enabled: !viewState.isSubmitting,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: l10n.tasksQuickCreateHint,
              border: const OutlineInputBorder(
                borderRadius: .all(.circular(10)),
              ),
              contentPadding: const .symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p12,
              ),
            ),
            onSubmitted: (_) => _submit(),
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
          DropdownButtonFormField<KanbanColumnResponse>(
            initialValue: viewState.column,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: .all(.circular(10)),
              ),
              contentPadding: .symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p8,
              ),
            ),
            items: [
              for (final column in widget.columns)
                DropdownMenuItem(
                  value: column,
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: () {
                            try {
                              final hex = column.color.replaceFirst('#', '');
                              return Color(int.parse('0xFF$hex'));
                            } catch (_) {
                              return colors.primary;
                            }
                          }(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: Sizes.p8),
                      Text(column.displayName),
                    ],
                  ),
                ),
            ],
            onChanged: viewState.isSubmitting
                ? null
                : (column) {
                    if (column != null) {
                      _viewState.value = _viewState.value.copyWith(
                        column: column,
                      );
                    }
                  },
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
                  DropdownButtonFormField<String?>(
                    initialValue:
                        viewState.selectedTemplateId ??
                        (viewState.useDefaultTemplate
                            ? defaultTemplateId
                            : null),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: .all(.circular(10)),
                      ),
                      contentPadding: .symmetric(
                        horizontal: Sizes.p12,
                        vertical: Sizes.p8,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        child: Text(l10n.tasksTemplateNoTemplate),
                      ),
                      for (final t in templates)
                        DropdownMenuItem<String?>(
                          value: t.id,
                          child: Row(
                            children: [
                              Icon(
                                t.id == defaultTemplateId
                                    ? Symbols.star_rounded
                                    : Symbols.auto_awesome_mosaic_rounded,
                                size: 16,
                                color: t.id == defaultTemplateId
                                    ? colors.primary
                                    : null,
                              ),
                              const SizedBox(width: Sizes.p8),
                              Expanded(
                                child: Text(
                                  t.id == defaultTemplateId
                                      ? '${t.name} (${l10n.tasksTemplatesDefault})'
                                      : t.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                    onChanged: viewState.isSubmitting
                        ? null
                        : (value) {
                            _viewState.value = _viewState.value.copyWith(
                              selectedTemplateId: value,
                              clearSelectedTemplateId: value == null,
                              useDefaultTemplate: false,
                            );
                          },
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

class _TaskQuickCreateDialogViewState {
  const _TaskQuickCreateDialogViewState({
    required this.column,
    this.isSubmitting = false,
    this.selectedTemplateId,
    this.useDefaultTemplate = true,
  });

  final KanbanColumnResponse column;
  final bool isSubmitting;
  final String? selectedTemplateId;
  final bool useDefaultTemplate;

  _TaskQuickCreateDialogViewState copyWith({
    KanbanColumnResponse? column,
    bool? isSubmitting,
    String? selectedTemplateId,
    bool clearSelectedTemplateId = false,
    bool? useDefaultTemplate,
  }) => _TaskQuickCreateDialogViewState(
    column: column ?? this.column,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    selectedTemplateId: clearSelectedTemplateId
        ? null
        : selectedTemplateId ?? this.selectedTemplateId,
    useDefaultTemplate: useDefaultTemplate ?? this.useDefaultTemplate,
  );
}
