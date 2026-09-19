part of 'tasks_board_page.dart';

/// Pojedyncza pozycja katalogu szablonów wraz z lokalnym stanem operacji.
class _TaskTemplateTile extends StatelessWidget {
  const _TaskTemplateTile({
    required this.template,
    required this.isDefault,
    required this.applying,
    required this.savingDefault,
    required this.busy,
    required this.members,
    required this.columns,
    required this.pickerCubit,
    required this.customFields,
    required this.onApply,
    required this.onToggleDefault,
  });

  final TaskTemplateResponse template;
  final bool isDefault;
  final bool applying;
  final bool savingDefault;
  final bool busy;
  final List<ProjectMemberProfile> members;
  final List<KanbanColumnResponse> columns;
  final TaskTemplatePickerCubit pickerCubit;
  final List<TaskCustomFieldResponse> customFields;
  final VoidCallback onApply;
  final VoidCallback onToggleDefault;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surfaceContainerLowest,
    borderRadius: const .all(.circular(14)),
    child: Padding(
      padding: const .fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.colors.primaryContainer,
            foregroundColor: context.colors.onPrimaryContainer,
            child: const Icon(Symbols.task_alt_rounded),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TemplateTileDetails(
              template: template,
              isDefault: isDefault,
            ),
          ),
          const SizedBox(width: 8),
          if (applying || busy)
            const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            _TemplateTileControls(
              template: template,
              isDefault: isDefault,
              savingDefault: savingDefault,
              applying: applying,
              busy: busy,
              members: members,
              columns: columns,
              pickerCubit: pickerCubit,
              customFields: customFields,
              onApply: onApply,
              onToggleDefault: onToggleDefault,
            ),
        ],
      ),
    ),
  );
}

class _TemplateTileDetails extends StatelessWidget {
  const _TemplateTileDetails({required this.template, required this.isDefault});

  final TaskTemplateResponse template;
  final bool isDefault;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: .start,
    children: [
      Row(
        children: [
          Flexible(
            child: Text(
              template.name,
              style: context.text.titleSmall?.copyWith(fontWeight: .w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isDefault) ...[
            const SizedBox(width: 8),
            Container(
              padding: const .symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: const .all(.circular(12)),
              ),
              child: Text(context.l10n.tasksTemplatesDefault),
            ),
          ],
        ],
      ),
      const SizedBox(height: 3),
      Text(context.l10n.tasksTemplatesApplyHint),
    ],
  );
}

class _TemplateTileControls extends StatelessWidget {
  const _TemplateTileControls({
    required this.template,
    required this.isDefault,
    required this.savingDefault,
    required this.applying,
    required this.busy,
    required this.members,
    required this.columns,
    required this.pickerCubit,
    required this.customFields,
    required this.onApply,
    required this.onToggleDefault,
  });

  final TaskTemplateResponse template;
  final bool isDefault;
  final bool savingDefault;
  final bool applying;
  final bool busy;
  final List<ProjectMemberProfile> members;
  final List<KanbanColumnResponse> columns;
  final TaskTemplatePickerCubit pickerCubit;
  final List<TaskCustomFieldResponse> customFields;
  final VoidCallback onApply;
  final VoidCallback onToggleDefault;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      FilledButton.tonal(
        onPressed: onApply,
        child: Text(context.l10n.tasksTemplatesUseTileAction),
      ),
      IconButton(
        tooltip: isDefault
            ? context.l10n.tasksTemplatesClearDefault
            : context.l10n.tasksTemplatesSetDefault,
        onPressed: savingDefault ? null : onToggleDefault,
        icon: Icon(
          isDefault ? Symbols.star_rounded : Symbols.star_outline_rounded,
        ),
      ),
      _TemplateTileActions(
        template: template,
        disabled: applying || busy,
        members: members,
        columns: columns,
        pickerCubit: pickerCubit,
        customFields: customFields,
      ),
    ],
  );
}
