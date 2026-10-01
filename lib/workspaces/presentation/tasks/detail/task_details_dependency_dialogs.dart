import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dependency_fields.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dialog_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_labelers.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class CreateDependencyDialog extends StatefulWidget {
  const CreateDependencyDialog({super.key});

  @override
  State<CreateDependencyDialog> createState() => CreateDependencyDialogState();
}

class CreateDependencyDialogState extends State<CreateDependencyDialog> {
  TaskDetailDraftRegistration? _draft;
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
  final ValueNotifier<ApiError?> _searchError = ValueNotifier(null);
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  final ValueNotifier<String?> _lagError = ValueNotifier(null);
  late final Listenable _formChanges;
  var _searchToken = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_refreshDraft);
    _lagController.addListener(_refreshDraft);
    _formChanges = Listenable.merge([
      _results,
      _selected,
      _type,
      _kind,
      _loading,
      _searchError,
      _saving,
      _lagError,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsAddDependency,
    );
  }

  void _refreshDraft() {
    _lagError.value = null;
    final isDirty =
        _searchController.text.trim().isNotEmpty ||
        _selected.value != null ||
        _type.value != TaskDependencyType.blocks ||
        _kind.value != TaskDependencyKind.finishToStart ||
        _lagController.text != '0';
    if (isDirty) {
      _draft?.markDirty();
    } else {
      _draft?.clear();
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _searchController.removeListener(_refreshDraft);
    _lagController.removeListener(_refreshDraft);
    _searchController.dispose();
    _lagController.dispose();
    _results.dispose();
    _selected.dispose();
    _type.dispose();
    _kind.dispose();
    _loading.dispose();
    _searchError.dispose();
    _saving.dispose();
    _lagError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _formChanges,
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsAddDependency,
      icon: Symbols.add_link_rounded,
      accentColor: context.colors.primary,
      isSubmitting: _saving.value,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
        context,
        _draft,
      ),
      onSubmit: _saving.value || _selected.value == null ? null : _save,
      body: Column(
        mainAxisSize: .min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TaskDetailsDialogMutationError(),
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
          if (_searchError.value case final error?) ...[
            const SizedBox(height: 10),
            Text(
              context.l10n.taskDetailsTaskSearchFailed,
              style: context.tasksTheme.dataStrongText,
            ),
            const SizedBox(height: 6),
            TaskDetailsModalError(error: error),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _saving.value
                    ? null
                    : () => _search(_searchController.text),
                icon: const Icon(Symbols.refresh_rounded),
                label: Text(context.l10n.retry),
              ),
            ),
          ],
          const SizedBox(height: 12),
          TaskDetailsSelectField<TaskDependencyType>(
            label: context.l10n.taskDetailsDependencyType,
            value: _type.value,
            enabled: !_saving.value,
            options: [
              for (final type in TaskDependencyType.values)
                TaskDetailsSelectOption(
                  value: type,
                  label: TaskDependencyTypeLabeler.label(context, type),
                ),
            ],
            onChanged: (value) {
              _type.value = value;
              _refreshDraft();
            },
          ),
          const SizedBox(height: 12),
          DependencyScheduleFields(
            kind: _kind.value,
            lagError: _lagError.value,
            lagController: _lagController,
            enabled: !_saving.value,
            onKindChanged: (value) {
              _kind.value = value;
              _refreshDraft();
            },
          ),
          if (_searchError.value == null && _results.value.isNotEmpty) ...[
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
                    onTap: _saving.value
                        ? null
                        : () {
                            _selected.value = task;
                            _refreshDraft();
                          },
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
      _searchError.value = null;
      _loading.value = false;
      return;
    }
    _loading.value = true;
    _searchError.value = null;
    final source = context.read<TaskDetailsCubit>();
    final result = await source.searchProjectTasks(
      value,
    );
    if (!mounted || token != _searchToken) return;
    if (!identical(source, context.read<TaskDetailsCubit>())) {
      _loading.value = false;
      _results.value = const [];
      _selected.value = null;
      return;
    }
    result.fold(
      (error) {
        _searchError.value = error;
        _results.value = const [];
      },
      (results) {
        _results.value = List.unmodifiable(results);
      },
    );
    _loading.value = false;
    if (!_results.value.contains(_selected.value)) _selected.value = null;
  }

  Future<void> _save() async {
    final task = _selected.value;
    if (task == null) return;
    final lag = int.tryParse(_lagController.text);
    if (lag == null || lag < -365 || lag > 365) {
      _lagError.value = context.l10n.taskDetailsInvalidDependencyLag;
      return;
    }
    _saving.value = true;
    final source = context.read<TaskDetailsCubit>();
    final saved = await source.createDependency(
      targetTaskId: task.id,
      type: _type.value,
      dependencyKind: _kind.value,
      lagDays: lag,
    );
    if (!mounted) return;
    if (!identical(source, context.read<TaskDetailsCubit>())) {
      _saving.value = false;
      return;
    }
    if (saved) {
      _draft?.clear();
      Navigator.of(context).pop();
    } else {
      _saving.value = false;
    }
  }
}

class EditDependencyDialog extends StatefulWidget {
  const EditDependencyDialog({required this.dependency, super.key});
  final TaskDependencyDetailsResponse dependency;
  @override
  State<EditDependencyDialog> createState() => EditDependencyDialogState();
}

class EditDependencyDialogState extends State<EditDependencyDialog> {
  TaskDetailDraftRegistration? _draft;
  late final ValueNotifier<TaskDependencyKind> _kind = ValueNotifier(
    widget.dependency.dependencyKind,
  );
  late final TextEditingController _lag = TextEditingController(
    text: widget.dependency.lagDays.toString(),
  );
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  final ValueNotifier<String?> _lagError = ValueNotifier(null);
  late final Listenable _formChanges;

  @override
  void initState() {
    super.initState();
    _lag.addListener(_refreshDraft);
    _formChanges = Listenable.merge([_kind, _saving, _lagError]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsEditPlanning,
    );
  }

  void _refreshDraft() {
    _lagError.value = null;
    if (_kind.value == widget.dependency.dependencyKind &&
        _lag.text == widget.dependency.lagDays.toString()) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _lag.removeListener(_refreshDraft);
    _lag.dispose();
    _kind.dispose();
    _saving.dispose();
    _lagError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _formChanges,
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsEditPlanning,
      icon: Symbols.edit_calendar_rounded,
      accentColor: context.colors.primary,
      isSubmitting: _saving.value,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      maxWidth: 440,
      onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
        context,
        _draft,
      ),
      onSubmit: _saving.value ? null : _save,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TaskDetailsDialogMutationError(),
          DependencyScheduleFields(
            kind: _kind.value,
            lagController: _lag,
            lagError: _lagError.value,
            enabled: !_saving.value,
            onKindChanged: (value) {
              _kind.value = value;
              _refreshDraft();
            },
          ),
        ],
      ),
    ),
  );
  Future<void> _save() async {
    final lag = int.tryParse(_lag.text);
    if (lag == null || lag < -365 || lag > 365) {
      _lagError.value = context.l10n.taskDetailsInvalidDependencyLag;
      return;
    }
    _saving.value = true;
    final source = context.read<TaskDetailsCubit>();
    final saved = await source.updateDependency(
      dependency: widget.dependency,
      dependencyKind: _kind.value,
      lagDays: lag,
    );
    if (!mounted) return;
    if (!identical(source, context.read<TaskDetailsCubit>())) {
      _saving.value = false;
      return;
    }
    if (saved) {
      _draft?.clear();
      Navigator.pop(context);
    } else {
      _saving.value = false;
    }
  }
}
