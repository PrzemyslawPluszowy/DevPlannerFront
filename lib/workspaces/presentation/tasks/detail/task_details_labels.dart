import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/project_labels_load_failure.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dialog_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_labels_settings_button.dart';

/// Etykiety taska z edycją atomową opartą o katalog projektu.
class TaskLabelsSection extends StatelessWidget {
  const TaskLabelsSection({
    required this.details,
    required this.isSaving,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => Section(
    title: context.l10n.taskDetailsLabels,
    action: IconButton(
      tooltip: context.l10n.taskDetailsEditLabels,
      onPressed: isSaving
          ? null
          : () => DevPlannerModalHost.showDialog<void>(
              context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: EditLabelsDialog(
                  selected: details.labels,
                  settingsComposition: context
                      .read<ProjectSettingsComposition?>(),
                  authSession: context.read<AuthSessionPort?>(),
                ),
              ),
            ),
      icon: const Icon(Symbols.sell, size: 20),
    ),
    child: details.labels.isEmpty
        ? Text(
            context.l10n.taskDetailsNoLabels,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          )
        : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final label in details.labels) TaskLabelChip(label: label),
            ],
          ),
  );
}

class TaskLabelChip extends StatelessWidget {
  const TaskLabelChip({required this.label, super.key});

  final TaskLabelResponse label;

  @override
  Widget build(BuildContext context) {
    final color = TaskLabelColorParser.parse(
      label.color,
      context.colors.primary,
    );
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 5),
      label: Text(label.name),
      side: BorderSide(color: color.withValues(alpha: .35)),
      backgroundColor: color.withValues(alpha: .10),
      visualDensity: VisualDensity.compact,
    );
  }
}

class EditLabelsDialog extends StatefulWidget {
  const EditLabelsDialog({
    required this.selected,
    this.settingsComposition,
    this.authSession,
    super.key,
  });

  final List<TaskLabelResponse> selected;
  final ProjectSettingsComposition? settingsComposition;
  final AuthSessionPort? authSession;

  @override
  State<EditLabelsDialog> createState() => EditLabelsDialogState();
}

class EditLabelsDialogState extends State<EditLabelsDialog> {
  TaskDetailDraftRegistration? _draft;
  late final ValueNotifier<Set<String>> _selectedIds;
  final ValueNotifier<List<TaskLabelResponse>?> _labels = ValueNotifier(null);
  final ValueNotifier<ApiError?> _loadError = ValueNotifier(null);
  final ValueNotifier<bool> _loading = ValueNotifier(true);
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  late final Listenable _formChanges;
  var _loadToken = 0;
  int _projectToken = 0;
  final ValueNotifier<ProjectListItem?> _project = ValueNotifier(null);
  final ValueNotifier<ApiError?> _projectError = ValueNotifier(null);
  final ValueNotifier<bool> _projectLoading = ValueNotifier(false);
  bool get _canManageLabels =>
      !_projectLoading.value &&
      _projectError.value == null &&
      _project.value?.capabilities?.canManage == true;
  late final Set<String> _initialIds;
  bool get _changed =>
      _selectedIds.value.length != _initialIds.length ||
      !_selectedIds.value.containsAll(_initialIds);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsEditLabels,
    );
  }

  void _refreshDraft() {
    final initial = widget.selected.map((label) => label.id).toSet();
    final selected = _selectedIds.value;
    if (initial.length == selected.length && initial.containsAll(selected)) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }

  @override
  void initState() {
    super.initState();
    _initialIds = Set.unmodifiable(widget.selected.map((label) => label.id));
    _selectedIds = ValueNotifier(
      Set.unmodifiable(widget.selected.map((label) => label.id)),
    );
    _formChanges = Listenable.merge([
      _selectedIds,
      _labels,
      _loadError,
      _loading,
      _saving,
      _project,
      _projectError,
      _projectLoading,
    ]);
    unawaited(_load());
    unawaited(_loadProject());
  }

  Future<void> _load() async {
    final token = ++_loadToken;
    final source = context.read<TaskDetailsCubit>();
    _loading.value = true;
    _loadError.value = null;
    final result = await source.loadProjectLabels();
    if (!mounted || token != _loadToken) return;
    if (source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      _loading.value = false;
      return;
    }
    result.fold(
      (error) => _loadError.value = error,
      (labels) {
        final ordered = [...labels]..sort((a, b) => a.name.compareTo(b.name));
        _labels.value = List.unmodifiable(ordered);
      },
    );
    _loading.value = false;
  }

  Future<void> _loadProject() async {
    final settings = widget.settingsComposition;
    if (settings == null) return;
    final token = ++_projectToken;
    final source = context.read<TaskDetailsCubit>();
    _projectLoading.value = true;
    _projectError.value = null;
    final result = await settings.projects.getProject(
      workspaceId: source.workspaceId,
      projectId: source.projectId,
    );
    if (!mounted ||
        token != _projectToken ||
        source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      return;
    }
    result.fold(
      (error) => _projectError.value = error,
      (project) => _project.value = project,
    );
    _projectLoading.value = false;
  }

  Future<void> _manageLabels(BuildContext settingsContext) async {
    final project = _project.value;
    final settings = widget.settingsComposition;
    if (!_canManageLabels ||
        project == null ||
        settings == null ||
        _saving.value) {
      return;
    }
    final source = context.read<TaskDetailsCubit>();
    await ProjectSettingsDialogs.show(
      context: settingsContext,
      project: project,
      userRole: project.myRole,
      initialTab: ProjectSettingsTab.labels,
    );
    if (!mounted ||
        source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      return;
    }
    await _load();
    if (!mounted ||
        source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      return;
    }
    await _loadProject();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _formChanges,
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsEditLabels,
      icon: Symbols.label_rounded,
      accentColor: context.colors.primary,
      isSubmitting: _saving.value,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      maxWidth: 420,
      onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
        context,
        _draft,
      ),
      onSubmit: _loading.value || _loadError.value != null || !_changed
          ? null
          : _save,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TaskDetailsDialogMutationError(),
          if (_projectError.value case final error?) ...[
            TaskDetailsModalError(error: error),
            TextButton.icon(
              onPressed: _projectLoading.value ? null : _loadProject,
              icon: const Icon(Symbols.refresh_rounded),
              label: Text(context.l10n.retry),
            ),
          ],
          if (_loading.value)
            const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_loadError.value case final error?)
            ProjectLabelsLoadFailure(
              error: error,
              onRetry: _load,
            )
          else if (_labels.value?.isEmpty ?? true)
            Padding(
              padding: const .symmetric(vertical: Sizes.p16),
              child: Text(
                context.l10n.taskLabelsEmptyGuidance,
                style: TextStyle(color: context.colors.onSurfaceVariant),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final label in _labels.value!)
                    CheckboxListTile(
                      value: _selectedIds.value.contains(label.id),
                      onChanged: _saving.value
                          ? null
                          : (selected) {
                              final selectedIds = {..._selectedIds.value};
                              if (selected ?? false) {
                                selectedIds.add(label.id);
                              } else {
                                selectedIds.remove(label.id);
                              }
                              _selectedIds.value = Set.unmodifiable(
                                selectedIds,
                              );
                              _refreshDraft();
                            },
                      secondary: CircleAvatar(
                        radius: 8,
                        backgroundColor: TaskLabelColorParser.parse(
                          label.color,
                          context.colors.primary,
                        ),
                      ),
                      title: Text(label.name),
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                ],
              ),
            ),
          if (_canManageLabels)
            TaskLabelsSettingsButton(
              settings: widget.settingsComposition!,
              authSession: widget.authSession,
              enabled: !_saving.value,
              onPressed: _manageLabels,
            ),
        ],
      ),
    ),
  );

  Future<void> _save() async {
    if (_saving.value ||
        _loading.value ||
        _loadError.value != null ||
        !_changed) {
      return;
    }
    _saving.value = true;
    final source = context.read<TaskDetailsCubit>();
    final saved = await source.replaceLabels(
      _selectedIds.value,
    );
    if (!mounted) return;
    if (source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      _saving.value = false;
      return;
    }
    if (saved) {
      _draft?.clear();
      Navigator.of(context).pop();
    }
    if (!saved) _saving.value = false;
  }

  @override
  void dispose() {
    _draft?.dispose();
    _project.dispose();
    _projectError.dispose();
    _projectLoading.dispose();
    _selectedIds.dispose();
    _labels.dispose();
    _loadError.dispose();
    _loading.dispose();
    _saving.dispose();
    super.dispose();
  }
}

/// Parser koloru etykiety z bezpiecznym fallbackiem motywu.
final class TaskLabelColorParser {
  const TaskLabelColorParser._();

  static Color parse(String source, Color fallback) {
    final value = source.replaceFirst('#', '');
    final parsed = int.tryParse(value, radix: 16);
    return parsed == null ? fallback : Color(0xFF000000 | parsed);
  }
}
