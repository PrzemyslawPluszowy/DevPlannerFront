part of 'task_details_page.dart';

class _DependenciesSection extends StatelessWidget {
  const _DependenciesSection({
    required this.dependencies,
    required this.isSaving,
  });

  final List<TaskDependencyDetailsResponse> dependencies;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => _Section(
    title: context.l10n.taskDetailsDependencies,
    action: IconButton(
      tooltip: context.l10n.taskDetailsAddDependency,
      onPressed: isSaving
          ? null
          : () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: const _CreateDependencyDialog(),
              ),
            ),
      icon: const Icon(Symbols.add_link_rounded, size: 20),
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: dependencies.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                context.l10n.taskDetailsNoDependencies,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            )
          : Column(
              children: [
                for (final dependency in dependencies)
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 14, right: 4),
                    leading: Icon(
                      dependency.type == TaskDependencyType.blocks
                          ? Symbols.block_rounded
                          : Symbols.account_tree,
                      color: dependency.type == TaskDependencyType.blocks
                          ? context.colors.error
                          : context.colors.primary,
                    ),
                    title: Text(dependency.relatedTask.title),
                    subtitle: Text(
                      '${dependency.relatedTask.key} · '
                      '${_dependencyTypeLabel(context, dependency.type)} · '
                      '${_dependencyKindLabel(context, dependency.dependencyKind)}'
                      '${dependency.lagDays == 0 ? '' : ' · ${dependency.lagDays > 0 ? '+' : ''}${dependency.lagDays} d'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: context.l10n.taskDetailsEditPlanning,
                          onPressed: isSaving
                              ? null
                              : () => showDialog<void>(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<TaskDetailsCubit>(),
                                    child: _EditDependencyDialog(
                                      dependency: dependency,
                                    ),
                                  ),
                                ),
                          icon: const Icon(Symbols.edit, size: 18),
                        ),
                        IconButton(
                          tooltip: context.l10n.taskDetailsDeleteDependency,
                          onPressed: isSaving
                              ? null
                              : () => unawaited(
                                  context
                                      .read<TaskDetailsCubit>()
                                      .deleteDependency(
                                        dependency,
                                      ),
                                ),
                          icon: const Icon(Symbols.close_rounded, size: 18),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    ),
  );
}

class _CreateDependencyDialog extends StatefulWidget {
  const _CreateDependencyDialog();

  @override
  State<_CreateDependencyDialog> createState() =>
      _CreateDependencyDialogState();
}

class _CreateDependencyDialogState extends State<_CreateDependencyDialog> {
  final _searchController = TextEditingController();
  List<ProjectTaskListItemResponse> _results = const [];
  ProjectTaskListItemResponse? _selected;
  TaskDependencyType _type = TaskDependencyType.blocks;
  TaskDependencyKind _kind = TaskDependencyKind.finishToStart;
  final _lagController = TextEditingController(text: '0');
  var _loading = false;
  var _saving = false;
  var _searchToken = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _lagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WorkspaceCreationModalWrapper(
    title: context.l10n.taskDetailsAddDependency,
    icon: Symbols.add_link_rounded,
    accentColor: context.colors.primary,
    isSubmitting: _saving,
    submitLabel: context.l10n.save,
    cancelLabel: context.l10n.cancel,
    onSubmit: _saving || _selected == null ? null : _save,
    body: Column(
      mainAxisSize: .min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _search,
          decoration: InputDecoration(
            labelText: context.l10n.taskDetailsSearchTask,
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TaskDependencyType>(
          initialValue: _type,
          decoration: InputDecoration(
            labelText: context.l10n.taskDetailsDependencyType,
          ),
          items: [
            for (final type in TaskDependencyType.values)
              DropdownMenuItem(
                value: type,
                child: Text(_dependencyTypeLabel(context, type)),
              ),
          ],
          onChanged: _saving
              ? null
              : (value) {
                  if (value != null) setState(() => _type = value);
                },
        ),
        const SizedBox(height: 12),
        _DependencyScheduleFields(
          kind: _kind,
          lagController: _lagController,
          enabled: !_saving,
          onKindChanged: (value) => setState(() => _kind = value),
        ),
        if (_results.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final task = _results[index];
                return ListTile(
                  dense: true,
                  selected: task.id == _selected?.id,
                  leading: Icon(
                    task.id == _selected?.id
                        ? Symbols.radio_button_checked_rounded
                        : Symbols.radio_button_unchecked_rounded,
                  ),
                  onTap: _saving
                      ? null
                      : () => setState(() => _selected = task),
                  title: Text(task.title),
                  subtitle: Text(task.key),
                );
              },
            ),
          ),
        ],
      ],
    ),
  );

  Future<void> _search(String value) async {
    final token = ++_searchToken;
    if (value.trim().length < 2) {
      setState(() {
        _results = const [];
        _selected = null;
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    final results = await context.read<TaskDetailsCubit>().searchProjectTasks(
      value,
    );
    if (!mounted || token != _searchToken) return;
    setState(() {
      _results = results;
      _loading = false;
      if (!_results.contains(_selected)) _selected = null;
    });
  }

  Future<void> _save() async {
    final task = _selected;
    if (task == null) return;
    final lag = int.tryParse(_lagController.text);
    if (lag == null || lag < -365 || lag > 365) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.taskDetailsInvalidDependencyLag)),
      );
      return;
    }
    setState(() => _saving = true);
    final saved = await context.read<TaskDetailsCubit>().createDependency(
      targetTaskId: task.id,
      type: _type,
      dependencyKind: _kind,
      lagDays: lag,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
    }
  }
}

class _EditDependencyDialog extends StatefulWidget {
  const _EditDependencyDialog({required this.dependency});
  final TaskDependencyDetailsResponse dependency;
  @override
  State<_EditDependencyDialog> createState() => _EditDependencyDialogState();
}

class _EditDependencyDialogState extends State<_EditDependencyDialog> {
  late TaskDependencyKind _kind = widget.dependency.dependencyKind;
  late final TextEditingController _lag = TextEditingController(
    text: widget.dependency.lagDays.toString(),
  );
  var _saving = false;
  @override
  void dispose() {
    _lag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WorkspaceCreationModalWrapper(
    title: context.l10n.taskDetailsEditPlanning,
    icon: Symbols.edit_calendar_rounded,
    accentColor: context.colors.primary,
    isSubmitting: _saving,
    submitLabel: context.l10n.save,
    cancelLabel: context.l10n.cancel,
    maxWidth: 440,
    onSubmit: _saving ? null : _save,
    body: _DependencyScheduleFields(
      kind: _kind,
      lagController: _lag,
      enabled: !_saving,
      onKindChanged: (value) => setState(() => _kind = value),
    ),
  );
  Future<void> _save() async {
    final lag = int.tryParse(_lag.text);
    if (lag == null || lag < -365 || lag > 365) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.taskDetailsInvalidDependencyLag)),
      );
      return;
    }
    setState(() => _saving = true);
    final saved = await context.read<TaskDetailsCubit>().updateDependency(
      dependency: widget.dependency,
      dependencyKind: _kind,
      lagDays: lag,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.pop(context);
    } else {
      setState(() => _saving = false);
    }
  }
}

class _DependencyScheduleFields extends StatelessWidget {
  const _DependencyScheduleFields({
    required this.kind,
    required this.lagController,
    required this.enabled,
    required this.onKindChanged,
  });
  final TaskDependencyKind kind;
  final TextEditingController lagController;
  final bool enabled;
  final ValueChanged<TaskDependencyKind> onKindChanged;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      DropdownButtonFormField<TaskDependencyKind>(
        initialValue: kind,
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsDependencyKind,
        ),
        items: [
          for (final value in TaskDependencyKind.values)
            DropdownMenuItem(
              value: value,
              child: Text(_dependencyKindLabel(context, value)),
            ),
        ],
        onChanged: enabled
            ? (value) {
                if (value != null) onKindChanged(value);
              }
            : null,
      ),
      const SizedBox(height: 12),
      TextField(
        controller: lagController,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsDependencyLagDays,
        ),
      ),
    ],
  );
}

String _dependencyKindLabel(BuildContext context, TaskDependencyKind kind) =>
    switch (kind) {
      TaskDependencyKind.finishToStart =>
        context.l10n.taskDependencyKindFinishToStart,
      TaskDependencyKind.startToStart =>
        context.l10n.taskDependencyKindStartToStart,
      TaskDependencyKind.finishToFinish =>
        context.l10n.taskDependencyKindFinishToFinish,
      TaskDependencyKind.startToFinish =>
        context.l10n.taskDependencyKindStartToFinish,
    };
