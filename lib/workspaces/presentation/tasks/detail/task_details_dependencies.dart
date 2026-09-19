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
                      '${TaskDependencyTypeLabeler.label(context, dependency.type)} · '
                      '${TaskDependencyLabeler.kind(context, dependency.dependencyKind)}'
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
  final ValueNotifier<List<ProjectTaskListItemResponse>> _results =
      ValueNotifier(const []);
  final ValueNotifier<ProjectTaskListItemResponse?> _selected = ValueNotifier(
    null,
  );
  final ValueNotifier<TaskDependencyType> _type = ValueNotifier(
    TaskDependencyType.blocks,
  );
  final ValueNotifier<TaskDependencyKind> _kind = ValueNotifier(
    TaskDependencyKind.finishToStart,
  );
  final _lagController = TextEditingController(text: '0');
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  var _searchToken = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _lagController.dispose();
    _results.dispose();
    _selected.dispose();
    _type.dispose();
    _kind.dispose();
    _loading.dispose();
    _saving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([
      _results,
      _selected,
      _type,
      _kind,
      _loading,
      _saving,
    ]),
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsAddDependency,
      icon: Symbols.add_link_rounded,
      accentColor: context.colors.primary,
      isSubmitting: _saving.value,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      onSubmit: _saving.value || _selected.value == null ? null : _save,
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
              suffixIcon: _loading.value
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
            initialValue: _type.value,
            decoration: InputDecoration(
              labelText: context.l10n.taskDetailsDependencyType,
            ),
            items: [
              for (final type in TaskDependencyType.values)
                DropdownMenuItem(
                  value: type,
                  child: Text(TaskDependencyTypeLabeler.label(context, type)),
                ),
            ],
            onChanged: _saving.value
                ? null
                : (value) {
                    if (value != null) _type.value = value;
                  },
          ),
          const SizedBox(height: 12),
          _DependencyScheduleFields(
            kind: _kind.value,
            lagController: _lagController,
            enabled: !_saving.value,
            onKindChanged: (value) => _kind.value = value,
          ),
          if (_results.value.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: ListView.builder(
                itemCount: _results.value.length,
                itemBuilder: (context, index) {
                  final task = _results.value[index];
                  return ListTile(
                    dense: true,
                    selected: task.id == _selected.value?.id,
                    leading: Icon(
                      task.id == _selected.value?.id
                          ? Symbols.radio_button_checked_rounded
                          : Symbols.radio_button_unchecked_rounded,
                    ),
                    onTap: _saving.value ? null : () => _selected.value = task,
                    title: Text(task.title),
                    subtitle: Text(task.key),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    ),
  );

  Future<void> _search(String value) async {
    final token = ++_searchToken;
    if (value.trim().length < 2) {
      _results.value = const [];
      _selected.value = null;
      _loading.value = false;
      return;
    }
    _loading.value = true;
    final results = await context.read<TaskDetailsCubit>().searchProjectTasks(
      value,
    );
    if (!mounted || token != _searchToken) return;
    _results.value = List.unmodifiable(results);
    _loading.value = false;
    if (!_results.value.contains(_selected.value)) _selected.value = null;
  }

  Future<void> _save() async {
    final task = _selected.value;
    if (task == null) return;
    final lag = int.tryParse(_lagController.text);
    if (lag == null || lag < -365 || lag > 365) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.taskDetailsInvalidDependencyLag)),
      );
      return;
    }
    _saving.value = true;
    final saved = await context.read<TaskDetailsCubit>().createDependency(
      targetTaskId: task.id,
      type: _type.value,
      dependencyKind: _kind.value,
      lagDays: lag,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      _saving.value = false;
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
  late final ValueNotifier<TaskDependencyKind> _kind = ValueNotifier(
    widget.dependency.dependencyKind,
  );
  late final TextEditingController _lag = TextEditingController(
    text: widget.dependency.lagDays.toString(),
  );
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  @override
  void dispose() {
    _lag.dispose();
    _kind.dispose();
    _saving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([_kind, _saving]),
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsEditPlanning,
      icon: Symbols.edit_calendar_rounded,
      accentColor: context.colors.primary,
      isSubmitting: _saving.value,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      maxWidth: 440,
      onSubmit: _saving.value ? null : _save,
      body: _DependencyScheduleFields(
        kind: _kind.value,
        lagController: _lag,
        enabled: !_saving.value,
        onKindChanged: (value) => _kind.value = value,
      ),
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
    _saving.value = true;
    final saved = await context.read<TaskDetailsCubit>().updateDependency(
      dependency: widget.dependency,
      dependencyKind: _kind.value,
      lagDays: lag,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.pop(context);
    } else {
      _saving.value = false;
    }
  }
}
