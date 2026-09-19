part of 'task_details_page.dart';

/// Etykiety taska z edycją atomową opartą o katalog projektu.
class _TaskLabelsSection extends StatelessWidget {
  const _TaskLabelsSection({required this.details, required this.isSaving});

  final ProjectTaskDetailsResponse details;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => _Section(
    title: context.l10n.taskDetailsLabels,
    action: IconButton(
      tooltip: context.l10n.taskDetailsEditLabels,
      onPressed: isSaving
          ? null
          : () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: _EditLabelsDialog(selected: details.labels),
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
              for (final label in details.labels) _TaskLabelChip(label: label),
            ],
          ),
  );
}

class _TaskLabelChip extends StatelessWidget {
  const _TaskLabelChip({required this.label});

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

class _EditLabelsDialog extends StatefulWidget {
  const _EditLabelsDialog({required this.selected});

  final List<TaskLabelResponse> selected;

  @override
  State<_EditLabelsDialog> createState() => _EditLabelsDialogState();
}

class _EditLabelsDialogState extends State<_EditLabelsDialog> {
  late final ValueNotifier<Set<String>> _selectedIds;
  final ValueNotifier<List<TaskLabelResponse>?> _labels = ValueNotifier(null);
  final ValueNotifier<bool> _loading = ValueNotifier(true);
  final ValueNotifier<bool> _saving = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _selectedIds = ValueNotifier(
      Set.unmodifiable(widget.selected.map((label) => label.id)),
    );
    unawaited(_load());
  }

  Future<void> _load() async {
    final labels = await context.read<TaskDetailsCubit>().loadProjectLabels();
    if (!mounted) return;
    labels.sort((a, b) => a.name.compareTo(b.name));
    _labels.value = List.unmodifiable(labels);
    _loading.value = false;
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([_selectedIds, _labels, _loading, _saving]),
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsEditLabels,
      icon: Symbols.label_rounded,
      accentColor: context.colors.primary,
      isSubmitting: _saving.value,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      maxWidth: 420,
      onSubmit: _loading.value ? null : _save,
      body: _loading.value
          ? const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          : (_labels.value?.isEmpty ?? true)
          ? Padding(
              padding: const .symmetric(vertical: Sizes.p16),
              child: Text(
                context.l10n.taskDetailsNoProjectLabels,
                style: TextStyle(color: context.colors.onSurfaceVariant),
              ),
            )
          : ConstrainedBox(
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
    ),
  );

  Future<void> _save() async {
    _saving.value = true;
    final saved = await context.read<TaskDetailsCubit>().replaceLabels(
      _selectedIds.value,
    );
    if (!mounted) return;
    if (saved) Navigator.of(context).pop();
    if (!saved) _saving.value = false;
  }

  @override
  void dispose() {
    _selectedIds.dispose();
    _labels.dispose();
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
