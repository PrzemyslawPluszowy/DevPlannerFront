part of 'task_details_page.dart';

/// Sekcja wartości pól własnych taska z rozpoznaniem ich typu kontraktowego.
class _TaskCustomFieldsSection extends StatelessWidget {
  const _TaskCustomFieldsSection({
    required this.fields,
    required this.isSaving,
  });

  final List<TaskCustomFieldDefinitionValueResponse> fields;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => _Section(
    title: context.l10n.taskDetailsCustomFields,
    action: IconButton(
      tooltip: context.l10n.taskDetailsEditCustomFields,
      onPressed: isSaving || fields.isEmpty
          ? null
          : () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: _EditCustomFieldsDialog(fields: fields),
              ),
            ),
      icon: const Icon(Symbols.tune_rounded, size: 20),
    ),
    child: fields.isEmpty
        ? Text(
            context.l10n.taskDetailsNoCustomFields,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Column(
              children: [
                for (final field in _sortedFields(fields))
                  _CustomFieldReadRow(field: field),
              ],
            ),
          ),
  );
}

class _CustomFieldReadRow extends StatelessWidget {
  const _CustomFieldReadRow({required this.field});

  final TaskCustomFieldDefinitionValueResponse field;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    leading: Icon(_customFieldIcon(field.type), size: 19),
    title: Row(
      children: [
        Flexible(child: Text(field.name)),
        if (field.isRequired) ...[
          const SizedBox(width: 5),
          Text('*', style: TextStyle(color: context.colors.error)),
        ],
      ],
    ),
    trailing: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Text(
        _customFieldDisplayValue(field.value),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: context.text.bodyMedium?.copyWith(
          color: context.colors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class _EditCustomFieldsDialog extends StatefulWidget {
  const _EditCustomFieldsDialog({required this.fields});

  final List<TaskCustomFieldDefinitionValueResponse> fields;

  @override
  State<_EditCustomFieldsDialog> createState() =>
      _EditCustomFieldsDialogState();
}

class _EditCustomFieldsDialogState extends State<_EditCustomFieldsDialog> {
  late final Map<String, dynamic> _values;
  late final Future<List<ProjectMemberProfile>> _memberProfiles;
  var _saving = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _values = {for (final field in widget.fields) field.id: field.value};
    final cubit = context.read<TaskDetailsCubit>();
    _memberProfiles = context
        .read<ProjectMemberProfilesRepository>()
        .listProfiles(
          workspaceId: cubit.workspaceId,
          projectId: cubit.projectId,
        )
        .then((result) => result.fold((_) => const [], (items) => items));
  }

  @override
  Widget build(BuildContext context) => WorkspaceCreationModalWrapper(
    title: context.l10n.taskDetailsEditCustomFields,
    icon: Symbols.tune_rounded,
    accentColor: context.colors.primary,
    isSubmitting: _saving,
    submitLabel: context.l10n.save,
    cancelLabel: context.l10n.cancel,
    maxWidth: 460,
    onSubmit: _saving ? null : _save,
    body: FutureBuilder<List<ProjectMemberProfile>>(
      future: _memberProfiles,
      builder: (context, snapshot) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final field in _sortedFields(widget.fields)) ...[
              _CustomFieldEditor(
                field: field,
                value: _values[field.id],
                enabled:
                    !_saving &&
                    snapshot.connectionState == ConnectionState.done,
                memberProfiles: snapshot.data ?? const [],
                onChanged: (value) => setState(() {
                  _values[field.id] = value;
                  _validationError = null;
                }),
              ),
              const SizedBox(height: 14),
            ],
            if (_validationError case final message?)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  message,
                  style: TextStyle(color: context.colors.error),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  Future<void> _save() async {
    for (final field in widget.fields.where(
      (field) => field.type == TaskCustomFieldType.number,
    )) {
      if (_values[field.id] is String) {
        setState(
          () => _validationError =
              '${field.name}: ${context.l10n.taskDetailsInvalidNumber}',
        );
        return;
      }
    }
    for (final field in widget.fields.where((field) => field.isRequired)) {
      final value = _values[field.id];
      if (value == null || (value is String && value.trim().isEmpty)) {
        setState(
          () => _validationError =
              '${field.name}: ${context.l10n.taskDetailsRequiredField}',
        );
        return;
      }
    }
    setState(() => _saving = true);
    final cleanValues = <String, dynamic>{
      for (final entry in _values.entries)
        if (entry.value != null &&
            (entry.value is! String ||
                (entry.value as String).trim().isNotEmpty))
          entry.key: entry.value,
    };
    final saved = await context
        .read<TaskDetailsCubit>()
        .replaceCustomFieldValues(cleanValues);
    if (!mounted) return;
    if (saved) Navigator.of(context).pop();
    if (!saved) setState(() => _saving = false);
  }
}
