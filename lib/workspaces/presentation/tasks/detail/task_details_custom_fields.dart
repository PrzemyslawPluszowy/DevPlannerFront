import 'package:devplanner/workspaces/presentation/tasks/detail/collaboration/cubit/task_member_profiles_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_custom_field_presentation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_custom_fields_dialog_body.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

/// Sekcja wartości pól własnych taska z rozpoznaniem ich typu kontraktowego.
class TaskCustomFieldsSection extends StatefulWidget {
  const TaskCustomFieldsSection({
    required this.fields,
    required this.isSaving,
    super.key,
  });

  final List<TaskCustomFieldDefinitionValueResponse> fields;
  final bool isSaving;

  @override
  State<TaskCustomFieldsSection> createState() =>
      TaskCustomFieldsSectionState();
}

class TaskCustomFieldsSectionState extends State<TaskCustomFieldsSection> {
  late List<TaskCustomFieldDefinitionValueResponse> _sortedFields;

  @override
  void initState() {
    super.initState();
    _sortedFields = TaskCustomFieldPresentation.sorted(widget.fields);
  }

  @override
  void didUpdateWidget(TaskCustomFieldsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.fields, widget.fields)) {
      _sortedFields = TaskCustomFieldPresentation.sorted(widget.fields);
    }
  }

  @override
  Widget build(BuildContext context) => Section(
    title: context.l10n.taskDetailsCustomFields,
    action: IconButton(
      tooltip: context.l10n.taskDetailsEditCustomFields,
      onPressed: widget.isSaving || widget.fields.isEmpty
          ? null
          : () => DevPlannerModalHost.showDialog<void>(
              context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: EditCustomFieldsDialog(fields: widget.fields),
              ),
            ),
      icon: const Icon(Symbols.tune_rounded, size: 20),
    ),
    child: widget.fields.isEmpty
        ? Text(
            context.l10n.taskDetailsNoCustomFields,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(
                context.tasksTheme.controlRadius,
              ),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Column(
              children: [
                for (final field in _sortedFields)
                  CustomFieldReadRow(field: field),
              ],
            ),
          ),
  );
}

class CustomFieldReadRow extends StatelessWidget {
  const CustomFieldReadRow({required this.field, super.key});

  final TaskCustomFieldDefinitionValueResponse field;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    leading: Icon(TaskCustomFieldPresentation.icon(field.type), size: 19),
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
        TaskCustomFieldPresentation.displayValue(context, field.value),
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

class EditCustomFieldsDialog extends StatefulWidget {
  const EditCustomFieldsDialog({required this.fields, super.key});

  final List<TaskCustomFieldDefinitionValueResponse> fields;

  @override
  State<EditCustomFieldsDialog> createState() => EditCustomFieldsDialogState();
}

class EditCustomFieldsDialogState extends State<EditCustomFieldsDialog> {
  TaskDetailDraftRegistration? _draft;
  late final ValueNotifier<Map<String, dynamic>> _values;
  TaskMemberProfilesCubit? _memberProfilesCubit;
  late final bool _profilesUnavailable;
  late final String _initialValuesSignature;
  late final List<TaskCustomFieldDefinitionValueResponse> _sortedFields;
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  final ValueNotifier<String?> _validationError = ValueNotifier(null);
  late final Listenable _formChanges;

  @override
  void initState() {
    super.initState();
    _values = ValueNotifier(
      Map.unmodifiable({
        for (final field in widget.fields) field.id: field.value,
      }),
    );
    _sortedFields = TaskCustomFieldPresentation.sorted(widget.fields);
    _formChanges = Listenable.merge([_values, _saving, _validationError]);
    _initialValuesSignature = jsonEncode(_values.value);
    final needsMemberProfiles = widget.fields.any(
      (field) => field.type == TaskCustomFieldType.user,
    );
    final profilesRepository = needsMemberProfiles
        ? context.read<ProjectMemberProfilesRepository?>()
        : null;
    _profilesUnavailable = needsMemberProfiles && profilesRepository == null;
    if (profilesRepository != null) {
      final cubit = context.read<TaskDetailsCubit>();
      final profilesCubit = TaskMemberProfilesCubit(
        repository: profilesRepository,
        workspaceId: cubit.workspaceId,
        projectId: cubit.projectId,
      );
      _memberProfilesCubit = profilesCubit;
      unawaited(profilesCubit.load());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsEditCustomFields,
    );
  }

  void _refreshDraft() {
    if (jsonEncode(_values.value) == _initialValuesSignature) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _formChanges,
    builder: (context, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsEditCustomFields,
      icon: Symbols.tune_rounded,
      accentColor: context.colors.primary,
      isSubmitting: _saving.value,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      maxWidth: 460,
      onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
        context,
        _draft,
      ),
      onSubmit: _saving.value ? null : _save,
      body: TaskDetailsCustomFieldsDialogBody(
        fields: _sortedFields,
        values: _values.value,
        isSaving: _saving.value,
        profilesUnavailable: _profilesUnavailable,
        validationError: _validationError.value,
        profilesCubit: _memberProfilesCubit,
        onFieldChanged: _handleFieldChanged,
      ),
    ),
  );

  Future<void> _save() async {
    if (_saving.value) return;
    for (final field in widget.fields.where(
      (field) => field.type == TaskCustomFieldType.number,
    )) {
      if (_values.value[field.id] is String) {
        _validationError.value =
            '${field.name}: ${context.l10n.taskDetailsInvalidNumber}';
        return;
      }
    }
    for (final field in widget.fields.where((field) => field.isRequired)) {
      final value = _values.value[field.id];
      if (value == null || (value is String && value.trim().isEmpty)) {
        _validationError.value =
            '${field.name}: ${context.l10n.taskDetailsRequiredField}';
        return;
      }
    }
    _saving.value = true;
    final source = context.read<TaskDetailsCubit>();
    final cleanValues = <String, dynamic>{
      for (final entry in _values.value.entries)
        if (entry.value != null &&
            (entry.value is! String ||
                (entry.value as String).trim().isNotEmpty))
          entry.key: entry.value,
    };
    final saved = await source.replaceCustomFieldValues(cleanValues);
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

  void _handleFieldChanged(({String fieldId, dynamic value}) change) {
    _values.value = Map.unmodifiable({
      ..._values.value,
      change.fieldId: change.value,
    });
    _refreshDraft();
    _validationError.value = null;
  }

  @override
  void dispose() {
    _draft?.dispose();
    _values.dispose();
    _saving.dispose();
    _validationError.dispose();
    final profilesCubit = _memberProfilesCubit;
    if (profilesCubit != null) unawaited(profilesCubit.close());
    super.dispose();
  }
}
