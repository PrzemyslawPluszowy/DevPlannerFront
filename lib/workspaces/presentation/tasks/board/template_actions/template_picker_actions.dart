part of '../tasks_board_page.dart';

enum _TemplateTileAction { edit, rename, delete }

/// Przycisk menu akcji dla pojedynczego kafla szablonu w katalogu.
class _TemplateTileActions extends StatelessWidget {
  const _TemplateTileActions({
    required this.template,
    required this.disabled,
    required this.members,
    required this.columns,
    required this.pickerCubit,
    required this.customFields,
  });

  final TaskTemplateResponse template;
  final bool disabled;
  final List<ProjectMemberProfile> members;
  final List<KanbanColumnResponse> columns;
  final TaskTemplatePickerCubit pickerCubit;
  final List<TaskCustomFieldResponse> customFields;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (anchorContext) => IconButton(
      tooltip: context.l10n.tasksTemplatesManage,
      onPressed: disabled ? null : () => unawaited(_showMenu(anchorContext)),
      icon: const Icon(Symbols.more_vert_rounded),
    ),
  );

  Future<void> _showMenu(BuildContext context) async {
    final action = await AppContextMenu.select<_TemplateTileAction>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      options: [
        AppContextMenuOption(
          value: _TemplateTileAction.edit,
          label: context.l10n.edit,
          icon: Symbols.tune_rounded,
        ),
        AppContextMenuOption(
          value: _TemplateTileAction.rename,
          label: context.l10n.tasksTemplatesRename,
          icon: Symbols.edit_rounded,
        ),
        AppContextMenuOption(
          value: _TemplateTileAction.delete,
          label: context.l10n.delete,
          icon: Symbols.delete_outline_rounded,
          iconColor: context.colors.error,
          separatorBefore: true,
        ),
      ],
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case _TemplateTileAction.edit:
        unawaited(
          _TemplateManagementActions.editTemplate(
            context,
            template,
            members,
            columns: columns,
            pickerCubit: pickerCubit,
            customFields: customFields,
          ),
        );
      case _TemplateTileAction.rename:
        unawaited(
          _TemplateManagementDialogs.renameTemplate(
            context,
            template,
            pickerCubit: pickerCubit,
          ),
        );
      case _TemplateTileAction.delete:
        unawaited(
          _TemplateManagementDialogs.confirmDeleteTemplate(
            context,
            template,
            pickerCubit: pickerCubit,
          ),
        );
    }
  }
}

/// Akcje otwierania i zarządzania szablonami w menu Kanbanu.
final class _TemplateManagementActions {
  const _TemplateManagementActions._();

  /// Otwiera boczny panel edycji istniejącego szablonu.
  static Future<void> editTemplate(
    BuildContext context,
    TaskTemplateResponse template,
    List<ProjectMemberProfile> members, {
    List<KanbanColumnResponse> columns = const <KanbanColumnResponse>[],
    List<TaskCustomFieldResponse> customFields =
        const <TaskCustomFieldResponse>[],
    TaskTemplatePickerCubit? pickerCubit,
  }) {
    final cubit = pickerCubit ?? context.read<TaskTemplatePickerCubit>();
    return AppExpandableSideSheet.show<void>(
      context,
      title: context.l10n.tasksTemplatesManage,
      subtitle: template.name,
      collapsedWidth: 680,
      expandedWidth: 960,
      padding: EdgeInsets.zero,
      scrollBody: false,
      bodyBuilder: (_, _) => BlocProvider.value(
        value: cubit,
        child: TaskTemplateEditor(
          template: template,
          members: members,
          columns: columns,
          pickerCubit: cubit,
          customFields: customFields,
        ),
      ),
    );
  }

  /// Otwiera boczny panel tworzenia nowego szablonu od zera z definicji.
  static Future<void> createTemplateFromDefinition(
    BuildContext context,
    List<ProjectMemberProfile> members, {
    List<KanbanColumnResponse> columns = const <KanbanColumnResponse>[],
    List<TaskCustomFieldResponse> customFields =
        const <TaskCustomFieldResponse>[],
    TaskTemplatePickerCubit? pickerCubit,
  }) {
    final cubit = pickerCubit ?? context.read<TaskTemplatePickerCubit>();
    return AppExpandableSideSheet.show<void>(
      context,
      title: context.l10n.tasksTemplatesNew,
      subtitle: context.l10n.tasksTemplatesNewDescription,
      collapsedWidth: 680,
      expandedWidth: 960,
      padding: EdgeInsets.zero,
      scrollBody: false,
      bodyBuilder: (_, _) => BlocProvider.value(
        value: cubit,
        child: TaskTemplateEditor(
          template: null,
          members: members,
          columns: columns,
          pickerCubit: cubit,
          customFields: customFields,
        ),
      ),
    );
  }
}

/// Wybrany status szablonu powiązany z kolumną Kanbanu lub statusem systemowym.
@immutable
final class SelectedTemplateStatus {
  const SelectedTemplateStatus({
    required this.fallbackStatus,
    this.customStatusId,
    required this.displayName,
    required this.color,
    this.customStatusCategory,
  });

  final ProjectTaskStatus fallbackStatus;
  final String? customStatusId;
  final String displayName;
  final String color;
  final TaskStatusCategory? customStatusCategory;

  bool get isCustom => customStatusId != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedTemplateStatus &&
          fallbackStatus == other.fallbackStatus &&
          customStatusId == other.customStatusId &&
          displayName == other.displayName;

  @override
  int get hashCode => Object.hash(fallbackStatus, customStatusId, displayName);
}

/// Edytor szablonu zadania obsługujący tryb tworzenia nowej formatki oraz edycję istniejącej.
class TaskTemplateEditor extends StatefulWidget {
  const TaskTemplateEditor({
    required this.template,
    required this.members,
    this.columns = const <KanbanColumnResponse>[],
    this.pickerCubit,
    this.customFields = const <TaskCustomFieldResponse>[],
    super.key,
  });

  final TaskTemplateResponse? template;
  final List<ProjectMemberProfile> members;
  final List<KanbanColumnResponse> columns;
  final TaskTemplatePickerCubit? pickerCubit;
  final List<TaskCustomFieldResponse> customFields;

  @override
  State<TaskTemplateEditor> createState() => _TaskTemplateEditorState();
}
