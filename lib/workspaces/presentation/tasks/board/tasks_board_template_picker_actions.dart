part of 'tasks_board_page.dart';

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
    final action = await TaskContextMenu.show<_TemplateTileAction>(
      context,
      position: TaskContextMenu.positionFor(context),
      items: [
        TaskContextMenuItem(
          value: _TemplateTileAction.edit,
          title: context.l10n.edit,
          icon: Symbols.tune_rounded,
        ),
        TaskContextMenuItem(
          value: _TemplateTileAction.rename,
          title: context.l10n.tasksTemplatesRename,
          icon: Symbols.edit_rounded,
        ),
        TaskContextMenuItem(
          value: _TemplateTileAction.delete,
          title: context.l10n.delete,
          icon: Symbols.delete_outline_rounded,
          iconColor: context.colors.error,
        ),
      ],
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case _TemplateTileAction.edit:
        unawaited(
          _editTemplate(
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
          _renameTemplate(context, template, pickerCubit: pickerCubit),
        );
      case _TemplateTileAction.delete:
        unawaited(
          _confirmDeleteTemplate(context, template, pickerCubit: pickerCubit),
        );
    }
  }
}

/// Otwiera boczny panel edycji istniejącego szablonu z jawnym przekazaniem zależności.
Future<void> _editTemplate(
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
Future<void> _createTemplateFromDefinition(
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

class _TaskTemplateEditorState extends State<TaskTemplateEditor> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  String? _taskType;
  int? _size;
  int? _complexity;
  int? _risk;
  int? _businessValue;
  int? _estimate;
  List<String> _checklistItems = <String>[];
  List<String> _acceptanceCriteria = <String>[];

  SelectedTemplateStatus? _status;
  TaskPriority _priority = TaskPriority.normal;
  DateTime? _startAtUtc;
  DateTime? _dueAtUtc;
  Set<String> _assigneeCoreUserIds = <String>{};
  List<TaskTemplateLabelResponse> _labels = <TaskTemplateLabelResponse>[];
  List<TaskTemplateCustomFieldValueResponse> _customFieldValues =
      <TaskTemplateCustomFieldValueResponse>[];

  late TaskTemplateDetailsResponse? _details;
  bool _loading = false;
  ApiError? _loadError;
  bool _saving = false;
  bool _isDirty = false;
  String? _saveError;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool get _isCreating => widget.template == null;
  TaskTemplatePickerCubit get _cubit =>
      widget.pickerCubit ?? context.read<TaskTemplatePickerCubit>();

  @override
  void initState() {
    super.initState();
    if (_isCreating) {
      _details = null;
      _loading = false;
      _priority = TaskPriority.normal;
      _initDefaultStatus();
    } else {
      _details = null;
      _loading = true;
      unawaited(_loadExistingTemplate());
    }
  }

  void _initDefaultStatus() {
    if (widget.columns.isNotEmpty) {
      final todoCol =
          widget.columns
              .where(
                (col) =>
                    col.status == ProjectTaskStatus.todo &&
                    col.customStatusId == null,
              )
              .firstOrNull ??
          widget.columns.first;
      _status = SelectedTemplateStatus(
        fallbackStatus: todoCol.status,
        customStatusId: todoCol.customStatusId,
        displayName: todoCol.displayName,
        color: todoCol.color,
        customStatusCategory: _mapTaskStatusToCategory(todoCol.status),
      );
    } else {
      _status = const SelectedTemplateStatus(
        fallbackStatus: ProjectTaskStatus.todo,
        displayName: 'Do zrobienia',
        color: '#2563EB',
        customStatusCategory: TaskStatusCategory.todo,
      );
    }
  }

  Future<void> _loadExistingTemplate() async {
    final template = widget.template;
    if (template == null) return;
    setState(() {
      _loading = true;
      _loadError = null;
    });

    final result = await _cubit.loadDetails(template.id);
    if (!mounted) return;

    switch (result) {
      case TaskTemplateDetailsLoadFailure(:final error):
        setState(() {
          _loading = false;
          _loadError = error;
        });
      case TaskTemplateDetailsLoaded(:final details):
        _name.text = details.name;
        _taskType = details.taskType;
        _size = details.size;
        _complexity = details.complexity;
        _risk = details.risk;
        _businessValue = details.businessValue;
        _estimate = details.estimatedMinutes;
        _checklistItems = List<String>.of(details.checklistItems);
        _acceptanceCriteria = List<String>.of(details.acceptanceCriteria);

        SelectedTemplateStatus? matchedStatus;
        if (details.customStatus != null) {
          final customName = details.customStatus!.name.toLowerCase();
          final matchingCol = widget.columns
              .where(
                (col) =>
                    col.customStatusId != null &&
                    col.displayName.toLowerCase() == customName,
              )
              .firstOrNull;
          if (matchingCol != null) {
            matchedStatus = SelectedTemplateStatus(
              fallbackStatus: matchingCol.status,
              customStatusId: matchingCol.customStatusId,
              displayName: matchingCol.displayName,
              color: matchingCol.color,
              customStatusCategory: details.customStatus!.category,
            );
          } else {
            matchedStatus = SelectedTemplateStatus(
              fallbackStatus: details.status,
              customStatusId: 'custom-saved',
              displayName: details.customStatus!.name,
              color: '#6C5CE7',
              customStatusCategory: details.customStatus!.category,
            );
          }
        } else {
          final matchingCol = widget.columns
              .where(
                (col) =>
                    col.status == details.status && col.customStatusId == null,
              )
              .firstOrNull;
          if (matchingCol != null) {
            matchedStatus = SelectedTemplateStatus(
              fallbackStatus: matchingCol.status,
              displayName: matchingCol.displayName,
              color: matchingCol.color,
              customStatusCategory: _mapTaskStatusToCategory(
                matchingCol.status,
              ),
            );
          } else {
            matchedStatus = SelectedTemplateStatus(
              fallbackStatus: details.status,
              displayName: TaskStatusVisualHelper.label(
                context,
                details.status,
              ),
              color: '#2563EB',
              customStatusCategory: _mapTaskStatusToCategory(details.status),
            );
          }
        }

        setState(() {
          _details = details;
          _status = matchedStatus;
          _priority = details.priority;
          _startAtUtc = details.startAtUtc;
          _dueAtUtc = details.dueAtUtc;
          _assigneeCoreUserIds = details.assigneeCoreUserIds.toSet();
          _labels = List<TaskTemplateLabelResponse>.of(details.labels);
          _customFieldValues = List<TaskTemplateCustomFieldValueResponse>.of(
            details.customFieldValues,
          );
          _loading = false;
          _loadError = null;
          _isDirty = false;
        });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_isDirty || _saving) return true;
    return AppConfirmDialog.show(
      context,
      title: context.l10n.tasksTemplatesUnsavedTitle,
      message: context.l10n.tasksTemplatesUnsavedDescription,
      confirmLabel: context.l10n.tasksTemplatesDiscardChanges,
      cancelLabel: context.l10n.tasksTemplatesKeepEditing,
      tone: AppConfirmDialogTone.warning,
    );
  }

  Future<void> _handleCancel() async {
    final shouldDiscard = await _confirmDiscard();
    if (shouldDiscard && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _save() async {
    if (_saving) return;

    final formValid = _formKey.currentState?.validate() ?? false;
    final dateInvalid =
        _startAtUtc != null &&
        _dueAtUtc != null &&
        _dueAtUtc!.isBefore(_startAtUtc!);

    if (!formValid || dateInvalid || _status == null) {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
        _saveError = context.l10n.tasksTemplatesFormFixErrors;
      });
      return;
    }

    setState(() {
      _saving = true;
      _saveError = null;
    });

    final estimate = _estimate;
    final size = _size;
    final complexity = _complexity;
    final risk = _risk;
    final businessValue = _businessValue;
    final currentStatus = _status!;

    final TaskTemplateMutationResult mutationResult;

    if (_isCreating) {
      final customStatus = currentStatus.isCustom
          ? TaskTemplateCustomStatusResponse(
              name: currentStatus.displayName,
              category:
                  currentStatus.customStatusCategory ??
                  _mapTaskStatusToCategory(currentStatus.fallbackStatus),
            )
          : null;

      final payload = CreateTaskTemplateDefinitionPayload(
        name: _name.text.trim(),
        status: currentStatus.fallbackStatus,
        priority: _priority,
        startAtUtc: _startAtUtc,
        dueAtUtc: _dueAtUtc,
        taskType: _taskType,
        size: size,
        complexity: complexity,
        risk: risk,
        businessValue: businessValue,
        estimatedMinutes: estimate,
        assigneeCoreUserIds: _assigneeCoreUserIds.toList(growable: false),
        checklistItems: _checklistItems,
        acceptanceCriteria: _acceptanceCriteria,
        labels: _labels,
        customFieldValues: _customFieldValues,
        customStatus: customStatus,
      );
      mutationResult = await _cubit.createFromDefinition(payload);
    } else {
      final details = _details!;
      final customStatus = currentStatus.isCustom
          ? TaskTemplateCustomStatusResponse(
              name: currentStatus.displayName,
              category:
                  currentStatus.customStatusCategory ??
                  _mapTaskStatusToCategory(currentStatus.fallbackStatus),
            )
          : null;
      final clearCustomStatus =
          !currentStatus.isCustom && details.customStatus != null;

      final payload = UpdateTaskTemplatePayload(
        name: _name.text.trim(),
        status: currentStatus.fallbackStatus,
        priority: _priority,
        startAtUtc: _startAtUtc,
        dueAtUtc: _dueAtUtc,
        taskType: _taskType,
        size: size,
        complexity: complexity,
        risk: risk,
        businessValue: businessValue,
        estimatedMinutes: estimate,
        assigneeCoreUserIds: _assigneeCoreUserIds.toList(growable: false),
        checklistItems: _checklistItems,
        acceptanceCriteria: _acceptanceCriteria,
        labels: _labels,
        customFieldValues: _customFieldValues,
        customStatus: customStatus,
        clearCustomStatus: clearCustomStatus,
        expectedVersion: details.version,
      );
      mutationResult = await _cubit.updateDetails(
        templateId: details.id,
        payload: payload,
      );
    }

    if (!mounted) return;
    if (mutationResult.isSuccess) {
      _isDirty = false;
      Navigator.of(context).pop();
    } else {
      setState(() {
        _saving = false;
        _saveError =
            mutationResult.errorOrNull?.message ?? context.l10n.workspacesRetry;
      });
    }
  }

  Future<void> _pickStatus(
    BuildContext anchorContext,
    List<SelectedTemplateStatus> statuses,
  ) async {
    final selected = await TaskContextMenu.show<SelectedTemplateStatus>(
      anchorContext,
      position: TaskContextMenu.positionFor(anchorContext),
      items: [
        for (final item in statuses)
          TaskContextMenuItem<SelectedTemplateStatus>(
            value: item,
            title: item.displayName,
            icon: TaskStatusVisualHelper.icon(item.fallbackStatus),
            iconColor: _parseColor(item.color),
            isSelected: item == _status,
          ),
      ],
    );
    if (selected == null || !mounted) return;
    _markDirty();
    setState(() => _status = selected);
  }

  Future<void> _pickDate(
    BuildContext anchorContext, {
    required bool startDate,
  }) async {
    final current = startDate ? _startAtUtc : _dueAtUtc;
    final box = anchorContext.findRenderObject() as RenderBox?;
    if (box == null) return;
    final selection = await pickAnchoredDate(
      anchorContext,
      initialValue: current,
      globalPosition: box.localToGlobal(Offset(0, box.size.height)),
    );
    if (selection == null || !mounted) return;
    _markDirty();
    setState(() {
      final utcDate = asUtcCalendarDate(selection.value);
      if (startDate) {
        _startAtUtc = utcDate;
      } else {
        _dueAtUtc = utcDate;
      }
    });
  }

  Object? _customFieldValue(TaskCustomFieldResponse field) => _customFieldValues
      .where(
        (value) =>
            value.fieldType == field.type &&
            value.fieldName.toLowerCase() == field.name.toLowerCase(),
      )
      .firstOrNull
      ?.value;

  void _setCustomFieldValue(TaskCustomFieldResponse field, Object? value) {
    _markDirty();
    setState(() {
      _customFieldValues = [
        for (final item in _customFieldValues)
          if (item.fieldName.toLowerCase() != field.name.toLowerCase()) item,
        if (value != null)
          TaskTemplateCustomFieldValueResponse(
            fieldName: field.name,
            fieldType: field.type,
            value: value,
          ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_isDirty || _saving,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;
      final shouldDiscard = await _confirmDiscard();
      if (shouldDiscard && context.mounted) {
        Navigator.of(context).pop();
      }
    },
    child: Scaffold(
      backgroundColor: context.colors.surface,
      body: _buildBody(context),
      bottomNavigationBar: _buildStickyActionBar(context),
    ),
  );

  Widget _buildBody(BuildContext context) {
    if (!_isCreating && _loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_isCreating && _loadError != null) {
      return _buildLoadError();
    }
    return _buildForm(context);
  }

  Widget _buildLoadError() => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.error_outline_rounded,
            size: 48,
            color: context.colors.error,
          ),
          const SizedBox(height: 12),
          Text(
            _loadError?.message ?? context.l10n.workspacesRetry,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.error),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => unawaited(_loadExistingTemplate()),
            icon: const Icon(Symbols.refresh_rounded),
            label: Text(context.l10n.workspacesRetry),
          ),
        ],
      ),
    ),
  );

  Widget _buildForm(BuildContext context) {
    final availableStatuses = _buildAvailableStatuses(context, widget.columns);
    final metadataState = context.watch<TaskSavedViewMetadataCubit?>()?.state;
    final projectLabels = metadataState is TaskSavedViewMetadataReady
        ? metadataState.labels
        : const <TaskLabelResponse>[];

    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_saveError != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.errorContainer,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.error_rounded,
                    color: context.colors.onErrorContainer,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _saveError!,
                      style: TextStyle(color: context.colors.onErrorContainer),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 1. Podstawowe
          _TemplateSectionCard(
            title: context.l10n.tasksTemplatesSectionBasic,
            icon: Symbols.info_rounded,
            children: [
              TextFormField(
                key: const Key('task-template-name'),
                controller: _name,
                enabled: !_saving,
                decoration: InputDecoration(
                  labelText: context.l10n.taskDetailsTemplateName,
                ),
                onChanged: (_) => _markDirty(),
                validator: (val) {
                  final trimmed = val?.trim() ?? '';
                  if (trimmed.isEmpty) {
                    return context.l10n.tasksTemplatesNameRequired;
                  }
                  if (trimmed.length > 160) {
                    return context.l10n.tasksTemplatesNameTooLong;
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Planowanie
          _TemplateSectionCard(
            title: context.l10n.tasksTemplatesSectionPlanning,
            icon: Symbols.event_note_rounded,
            children: [
              _TemplateDomainPickerField(
                enabled: !_saving,
                label: context.l10n.taskDetailsStatusField,
                value: _status?.displayName,
                icon: TaskStatusVisualHelper.icon(
                  _status?.fallbackStatus ?? ProjectTaskStatus.todo,
                ),
                color: _status == null ? null : _parseColor(_status!.color),
                valueWidget: _status == null
                    ? null
                    : _TemplateValueBadge(
                        label: _status!.displayName,
                        icon: TaskStatusVisualHelper.icon(
                          _status!.fallbackStatus,
                        ),
                        color: _parseColor(_status!.color),
                      ),
                onTap: (anchorContext) =>
                    _pickStatus(anchorContext, availableStatuses),
              ),
              const SizedBox(height: 12),
              _TemplateDomainPickerField(
                enabled: !_saving,
                label: context.l10n.taskDetailsPriorityField,
                value: TaskPriorityVisualHelper.label(context, _priority),
                icon: TaskPriorityVisualHelper.icon(_priority),
                color: TaskPriorityVisualHelper.color(_priority),
                valueWidget: _TemplateValueBadge(
                  label: TaskPriorityVisualHelper.label(context, _priority),
                  icon: TaskPriorityVisualHelper.icon(_priority),
                  color: TaskPriorityVisualHelper.color(_priority),
                ),
                onTap: (anchorContext) => TaskPriorityPicker.show(
                  anchorContext,
                  selected: _priority,
                  onChanged: (value) async {
                    _markDirty();
                    setState(() => _priority = value);
                    return true;
                  },
                ),
              ),
              const SizedBox(height: 12),
              _TemplateDateField(
                label: context.l10n.taskDetailsStartDate,
                value: _startAtUtc,
                enabled: !_saving,
                onPick: (anchorContext) =>
                    _pickDate(anchorContext, startDate: true),
                onClear: () {
                  _markDirty();
                  setState(() => _startAtUtc = null);
                },
              ),
              const SizedBox(height: 12),
              _TemplateDateField(
                label: context.l10n.taskDetailsDueDate,
                value: _dueAtUtc,
                enabled: !_saving,
                hasError:
                    _startAtUtc != null &&
                    _dueAtUtc != null &&
                    _dueAtUtc!.isBefore(_startAtUtc!),
                errorText:
                    _startAtUtc != null &&
                        _dueAtUtc != null &&
                        _dueAtUtc!.isBefore(_startAtUtc!)
                    ? context.l10n.tasksTemplatesInvalidDueDate
                    : null,
                onPick: (anchorContext) =>
                    _pickDate(anchorContext, startDate: false),
                onClear: () {
                  _markDirty();
                  setState(() => _dueAtUtc = null);
                },
              ),
              const SizedBox(height: 12),
              _TemplateDomainPickerField(
                enabled: !_saving,
                label: context.l10n.taskDetailsEstimateMinutes,
                value: _estimate == null
                    ? null
                    : TaskDurationFormatter.format(_estimate),
                icon: Symbols.schedule_rounded,
                onTap: (anchorContext) => showTaskDurationPicker(
                  anchorContext,
                  currentMinutes: _estimate,
                  title: context.l10n.taskDetailsEstimateMinutes,
                  onSave: (value) async {
                    _markDirty();
                    setState(() => _estimate = value);
                    return true;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Odpowiedzialność
          _TemplateSectionCard(
            title: context.l10n.tasksTemplatesSectionResponsibility,
            icon: Symbols.people_rounded,
            children: [
              _AssigneePickerSection(
                members: widget.members,
                selectedUserIds: _assigneeCoreUserIds,
                enabled: !_saving,
                onToggle: (userId) {
                  _markDirty();
                  setState(() {
                    if (_assigneeCoreUserIds.contains(userId)) {
                      _assigneeCoreUserIds.remove(userId);
                    } else {
                      _assigneeCoreUserIds.add(userId);
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. Zakres pracy
          _TemplateSectionCard(
            title: context.l10n.tasksTemplatesSectionScope,
            icon: Symbols.checklist_rounded,
            children: [
              _TemplateStringItemsEditor(
                title: context.l10n.taskDetailsChecklist,
                addLabel: context.l10n.taskDetailsAddChecklistItem,
                items: _checklistItems,
                enabled: !_saving,
                maxItemLength: 500,
                onChanged: (items) {
                  _markDirty();
                  setState(() => _checklistItems = items);
                },
              ),
              const SizedBox(height: 12),
              _TemplateStringItemsEditor(
                title: context.l10n.taskDetailsAcceptanceCriteria,
                addLabel: context.l10n.taskDetailsAddAcceptanceCriterion,
                items: _acceptanceCriteria,
                enabled: !_saving,
                maxItemLength: 1000,
                onChanged: (items) {
                  _markDirty();
                  setState(() => _acceptanceCriteria = items);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 5. Klasyfikacja
          _TemplateSectionCard(
            title: context.l10n.tasksTemplatesSectionClassification,
            icon: Symbols.category_rounded,
            children: [
              _TemplateDomainPickerField(
                label: context.l10n.tasksTemplateTaskType,
                value: TaskPresetType.fromName(_taskType)?.label ?? _taskType,
                icon:
                    TaskPresetType.fromName(_taskType)?.icon ??
                    Symbols.category_rounded,
                color: TaskPresetType.fromName(_taskType)?.color,
                valueWidget: _taskType == null
                    ? null
                    : _TemplateValueBadge(
                        label:
                            TaskPresetType.fromName(_taskType)?.label ??
                            _taskType!,
                        icon:
                            TaskPresetType.fromName(_taskType)?.icon ??
                            Symbols.label_important_rounded,
                        color:
                            TaskPresetType.fromName(_taskType)?.color ??
                            context.colors.primary,
                      ),
                enabled: !_saving,
                onTap: (anchorContext) => showTaskTypePicker(
                  anchorContext,
                  currentType: _taskType,
                  onSave: (value) async {
                    _markDirty();
                    setState(() => _taskType = value.isEmpty ? null : value);
                    return true;
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TemplateDomainPickerField(
                      enabled: !_saving,
                      label: context.l10n.tasksTemplateSize,
                      value: TaskTShirtSize.fromValue(_size)?.label,
                      icon: Symbols.straighten_rounded,
                      color: TaskTShirtSize.fromValue(_size)?.color,
                      valueWidget: _size == null
                          ? null
                          : _TemplateValueBadge(
                              label:
                                  TaskTShirtSize.fromValue(_size)?.label ??
                                  '$_size',
                              icon: Symbols.straighten_rounded,
                              color:
                                  TaskTShirtSize.fromValue(_size)?.color ??
                                  context.colors.primary,
                            ),
                      onTap: (anchorContext) => showTaskSizePicker(
                        anchorContext,
                        currentSize: _size,
                        onSave: (value) async {
                          _markDirty();
                          setState(() => _size = value);
                          return true;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TemplateDomainPickerField(
                      enabled: !_saving,
                      label: context.l10n.tasksTemplateComplexity,
                      value: _complexity?.toString(),
                      icon: Symbols.tune_rounded,
                      color: TaskComplexityLevel.fromValue(_complexity)?.color,
                      valueWidget: _complexity == null
                          ? null
                          : _TemplateComplexityValue(value: _complexity!),
                      onTap: (anchorContext) => showTaskComplexityPicker(
                        anchorContext,
                        currentComplexity: _complexity,
                        onSave: (value) async {
                          _markDirty();
                          setState(() => _complexity = value);
                          return true;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TemplateDomainPickerField(
                      enabled: !_saving,
                      label: context.l10n.tasksTemplateRisk,
                      value: TaskRiskLevel.fromValue(_risk)?.label,
                      icon: Symbols.shield_rounded,
                      color: TaskRiskLevel.fromValue(_risk)?.color,
                      valueWidget: _risk == null
                          ? null
                          : _TemplateValueBadge(
                              label:
                                  TaskRiskLevel.fromValue(_risk)?.label ??
                                  '$_risk',
                              icon: Symbols.shield_rounded,
                              color:
                                  TaskRiskLevel.fromValue(_risk)?.color ??
                                  context.colors.error,
                            ),
                      onTap: (anchorContext) => showTaskRiskPicker(
                        anchorContext,
                        currentRisk: _risk,
                        onSave: (value) async {
                          _markDirty();
                          setState(() => _risk = value);
                          return true;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TemplateDomainPickerField(
                      enabled: !_saving,
                      label: context.l10n.tasksTemplateBusinessValue,
                      value: _businessValue == null
                          ? null
                          : '$_businessValue pkt',
                      icon: Symbols.stars_rounded,
                      color: context.colors.primary,
                      valueWidget: _businessValue == null
                          ? null
                          : _TemplateValueBadge(
                              label: '$_businessValue',
                              icon: Symbols.stars_rounded,
                              color: context.colors.primary,
                            ),
                      onTap: (anchorContext) => showTaskBusinessValuePicker(
                        anchorContext,
                        currentValue: _businessValue,
                        onSave: (value) async {
                          _markDirty();
                          setState(() => _businessValue = value);
                          return true;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 6. Metadane
          _TemplateSectionCard(
            title: context.l10n.tasksTemplatesSectionMetadata,
            icon: Symbols.label_rounded,
            children: [
              Text(
                context.l10n.taskDetailsLabels,
                style: context.text.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              if (projectLabels.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final label in projectLabels)
                      FilterChip(
                        label: Text(label.name),
                        backgroundColor: _parseColor(
                          label.color,
                        ).withValues(alpha: .14),
                        selected: _labels.any(
                          (selected) => selected.name == label.name,
                        ),
                        onSelected: _saving
                            ? null
                            : (selected) {
                                _markDirty();
                                setState(() {
                                  _labels.removeWhere(
                                    (item) => item.name == label.name,
                                  );
                                  if (selected) {
                                    _labels.add(
                                      TaskTemplateLabelResponse(
                                        name: label.name,
                                        color: label.color,
                                      ),
                                    );
                                  }
                                });
                              },
                      ),
                  ],
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.tasksTemplateNoLabels,
                    style: TextStyle(color: context.colors.onSurfaceVariant),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.tasksTemplateCustomValues,
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.customFields.isNotEmpty)
                ...widget.customFields.map(
                  (field) => Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _TemplateCustomFieldEditor(
                      field: field,
                      value: _customFieldValue(field),
                      members: widget.members,
                      enabled: !_saving,
                      onChanged: (value) => _setCustomFieldValue(field, value),
                    ),
                  ),
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.tasksTemplateNoCustomValues,
                    style: TextStyle(color: context.colors.onSurfaceVariant),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyActionBar(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLowest,
      border: Border(
        top: BorderSide(color: context.colors.outlineVariant),
      ),
    ),
    child: Row(
      children: [
        OutlinedButton(
          onPressed: _saving ? null : () => unawaited(_handleCancel()),
          child: Text(context.l10n.cancel),
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: _saving ? null : () => unawaited(_save()),
          icon: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Symbols.save_rounded, size: 18),
          label: Text(
            _isCreating
                ? context.l10n.tasksTemplatesCreateAction
                : context.l10n.tasksTemplatesSaveAction,
          ),
        ),
      ],
    ),
  );
}

/// Karta grupująca poszczególne sekcje formularza formatki.
class _TemplateSectionCard extends StatelessWidget {
  const _TemplateSectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLowest,
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      border: Border.all(
        color: context.colors.outlineVariant.withValues(alpha: .5),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: context.colors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: context.text.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...children,
      ],
    ),
  );
}

/// Nowoczesny komponent wyboru wykonawców z wyszukiwaniem i avatarami.
class _AssigneePickerSection extends StatefulWidget {
  const _AssigneePickerSection({
    required this.members,
    required this.selectedUserIds,
    required this.enabled,
    required this.onToggle,
  });

  final List<ProjectMemberProfile> members;
  final Set<String> selectedUserIds;
  final bool enabled;
  final ValueChanged<String> onToggle;

  @override
  State<_AssigneePickerSection> createState() => _AssigneePickerSectionState();
}

class _AssigneePickerSectionState extends State<_AssigneePickerSection> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMembers = widget.members
        .where((m) => widget.selectedUserIds.contains(m.coreUserId))
        .toList(growable: false);

    final filteredMembers = widget.members
        .where((m) {
          if (_query.trim().isEmpty) return true;
          final name = _templateMemberLabel(context, m).toLowerCase();
          return name.contains(_query.trim().toLowerCase());
        })
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedMembers.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final member in selectedMembers)
                InputChip(
                  avatar: CircleAvatar(
                    backgroundColor: _cardAvatarColor(member.coreUserId),
                    foregroundColor: Colors.white,
                    child: Text(
                      _templateMemberInitial(member),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  label: Text(_templateMemberLabel(context, member)),
                  onDeleted: widget.enabled
                      ? () => widget.onToggle(member.coreUserId)
                      : null,
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        TextField(
          controller: _searchController,
          enabled: widget.enabled,
          decoration: InputDecoration(
            hintText: context.l10n.tasksTemplatesAssigneesSearchHint,
            prefixIcon: const Icon(Symbols.search_rounded, size: 20),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Symbols.clear_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          onChanged: (val) => setState(() => _query = val),
        ),
        const SizedBox(height: 8),
        if (widget.members.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              context.l10n.tasksTemplatesAssigneesLoadError,
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          )
        else if (filteredMembers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              context.l10n.tasksTemplatesAssigneesEmpty,
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                final member = filteredMembers[index];
                final isSelected = widget.selectedUserIds.contains(
                  member.coreUserId,
                );
                return Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: _cardAvatarColor(member.coreUserId),
                      foregroundColor: Colors.white,
                      child: Text(
                        _templateMemberInitial(member),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    title: Text(
                      _templateMemberLabel(context, member),
                      style: context.text.bodyMedium,
                    ),
                    trailing: Icon(
                      isSelected
                          ? Symbols.check_box_rounded
                          : Symbols.check_box_outline_blank_rounded,
                      color: isSelected ? context.colors.primary : null,
                      size: 20,
                    ),
                    onTap: widget.enabled
                        ? () => widget.onToggle(member.coreUserId)
                        : null,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

List<SelectedTemplateStatus> _buildAvailableStatuses(
  BuildContext context,
  List<KanbanColumnResponse> columns,
) {
  if (columns.isNotEmpty) {
    return [
      for (final col in columns)
        SelectedTemplateStatus(
          fallbackStatus: col.status,
          customStatusId: col.customStatusId,
          displayName: col.displayName,
          color: col.color,
          customStatusCategory: _mapTaskStatusToCategory(col.status),
        ),
    ];
  }
  return [
    for (final status in ProjectTaskStatus.values)
      SelectedTemplateStatus(
        fallbackStatus: status,
        displayName: TaskStatusVisualHelper.label(context, status),
        color: '#2563EB',
        customStatusCategory: _mapTaskStatusToCategory(status),
      ),
  ];
}

TaskStatusCategory _mapTaskStatusToCategory(ProjectTaskStatus status) =>
    switch (status) {
      ProjectTaskStatus.backlog ||
      ProjectTaskStatus.todo => TaskStatusCategory.todo,
      ProjectTaskStatus.inProgress ||
      ProjectTaskStatus.blocked => TaskStatusCategory.inProgress,
      ProjectTaskStatus.done => TaskStatusCategory.done,
      ProjectTaskStatus.cancelled => TaskStatusCategory.cancelled,
    };

String _templateMemberLabel(
  BuildContext context,
  ProjectMemberProfile member,
) {
  final displayName = member.displayName?.trim();
  return displayName?.isNotEmpty == true
      ? displayName!
      : context.l10n.tasksPresenceAnonymousUser;
}

String _templateMemberInitial(ProjectMemberProfile member) {
  final displayName = member.displayName?.trim();
  if (displayName?.isNotEmpty == true) {
    return displayName!.characters.first.toUpperCase();
  }
  return '?';
}

/// Kompaktowa lista zakresu pracy. Każdy wpis jest osobnym elementem, a nie
/// fragmentem wielowierszowego tekstu wymagającym ręcznego separatora.
class _TemplateStringItemsEditor extends StatefulWidget {
  const _TemplateStringItemsEditor({
    required this.title,
    required this.addLabel,
    required this.items,
    required this.enabled,
    required this.maxItemLength,
    required this.onChanged,
  });

  final String title;
  final String addLabel;
  final List<String> items;
  final bool enabled;
  final int maxItemLength;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_TemplateStringItemsEditor> createState() =>
      _TemplateStringItemsEditorState();
}

class _TemplateStringItemsEditorState
    extends State<_TemplateStringItemsEditor> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final value = _controller.text.trim();
    if (value.isEmpty || value.length > widget.maxItemLength) return;
    widget.onChanged([...widget.items, value]);
    _controller.clear();
  }

  Future<void> _edit(int index) async {
    final controller = TextEditingController(text: widget.items[index]);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => WorkspaceCreationModalWrapper(
        title: widget.title,
        icon: Symbols.edit_rounded,
        accentColor: context.colors.primary,
        submitLabel: context.l10n.save,
        cancelLabel: context.l10n.cancel,
        maxWidth: 440,
        onSubmit: () {
          final value = controller.text.trim();
          if (value.isNotEmpty && value.length <= widget.maxItemLength) {
            Navigator.of(dialogContext).pop(value);
          }
        },
        body: TextField(
          controller: controller,
          autofocus: true,
          maxLength: widget.maxItemLength,
          maxLines: 2,
          onSubmitted: (_) {
            final value = controller.text.trim();
            if (value.isNotEmpty && value.length <= widget.maxItemLength) {
              Navigator.of(dialogContext).pop(value);
            }
          },
        ),
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;
    final updated = List<String>.of(widget.items)..[index] = result;
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.title,
        style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      for (var index = 0; index < widget.items.length; index++)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Material(
            color: context.colors.surfaceContainerLow.withValues(alpha: .65),
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            child: ListTile(
              dense: true,
              minTileHeight: 38,
              contentPadding: const EdgeInsets.only(left: 10, right: 2),
              leading: Icon(
                Symbols.drag_indicator_rounded,
                size: 17,
                color: context.colors.onSurfaceVariant,
              ),
              title: Text(widget.items[index], style: context.text.bodySmall),
              trailing: widget.enabled
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: context.l10n.edit,
                          visualDensity: VisualDensity.compact,
                          onPressed: () => unawaited(_edit(index)),
                          icon: const Icon(Symbols.edit_rounded, size: 16),
                        ),
                        IconButton(
                          tooltip: context.l10n.delete,
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            final updated = List<String>.of(widget.items)
                              ..removeAt(index);
                            widget.onChanged(updated);
                          },
                          icon: const Icon(Symbols.close_rounded, size: 16),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
      if (widget.enabled)
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLength: widget.maxItemLength,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: widget.addLabel,
                  counterText: '',
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 6),
            IconButton.filledTonal(
              tooltip: widget.addLabel,
              onPressed: _add,
              icon: const Icon(Symbols.add_rounded, size: 18),
            ),
          ],
        ),
    ],
  );
}

/// Typowany edytor wartości pola projektu. Korzysta z tych samych reprezentacji
/// opcji i użytkowników co komórki listy zadań zamiast przyjmować surowy tekst.
class _TemplateCustomFieldEditor extends StatelessWidget {
  const _TemplateCustomFieldEditor({
    required this.field,
    required this.value,
    required this.members,
    required this.enabled,
    required this.onChanged,
  });

  final TaskCustomFieldResponse field;
  final Object? value;
  final List<ProjectMemberProfile> members;
  final bool enabled;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final currentValue = value;
    return switch (field.type) {
      TaskCustomFieldType.boolean => _TemplateDomainPickerField(
        label: field.name,
        value: value == null
            ? null
            : value == true
            ? context.l10n.yes
            : context.l10n.no,
        icon: value == true
            ? Symbols.check_circle_rounded
            : Symbols.cancel_rounded,
        color: value == true
            ? const Color(0xFF4CAF50)
            : const Color(0xFF757575),
        valueWidget: value == null
            ? null
            : _TemplateValueBadge(
                label: value == true ? context.l10n.yes : context.l10n.no,
                icon: value == true
                    ? Symbols.check_circle_rounded
                    : Symbols.cancel_rounded,
                color: value == true
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF757575),
              ),
        enabled: enabled,
        onTap: (anchorContext) async {
          final selected = await TaskCustomFieldPicker.pickBoolean(
            anchorContext,
            field: field,
            value: value,
            menuPosition: TaskContextMenu.positionFor(anchorContext),
          );
          if (selected != customFieldCancelled) onChanged(selected);
        },
      ),
      TaskCustomFieldType.singleSelect => _TemplateDomainPickerField(
        label: field.name,
        value: currentValue == null
            ? null
            : CustomFieldOption.fromRaw(currentValue.toString()).label,
        icon: Symbols.label_rounded,
        valueWidget: currentValue == null
            ? null
            : _TemplateCustomOptionValue(raw: currentValue.toString()),
        enabled: enabled,
        onTap: (anchorContext) async {
          final selected = await TaskCustomFieldPicker.pickSingleSelect(
            anchorContext,
            field: field,
            value: value,
            menuPosition: TaskContextMenu.positionFor(anchorContext),
          );
          if (selected != customFieldCancelled) onChanged(selected);
        },
      ),
      TaskCustomFieldType.multiSelect => _TemplateDomainPickerField(
        label: field.name,
        value: currentValue is List && currentValue.isNotEmpty
            ? currentValue
                  .map(
                    (item) => CustomFieldOption.fromRaw(item.toString()).label,
                  )
                  .join(', ')
            : null,
        icon: Symbols.sell_rounded,
        valueWidget: currentValue is List && currentValue.isNotEmpty
            ? _TemplateMultiOptionValue(values: currentValue)
            : null,
        enabled: enabled,
        onTap: (anchorContext) async {
          final selected = await TaskCustomFieldPicker.pickMultiSelect(
            anchorContext,
            field: field,
            value: value,
            menuPosition: TaskContextMenu.positionFor(anchorContext),
          );
          if (selected != customFieldCancelled) onChanged(selected);
        },
      ),
      TaskCustomFieldType.date => _TemplateCustomDateField(
        field: field,
        value: value,
        enabled: enabled,
        onChanged: onChanged,
      ),
      TaskCustomFieldType.user => DropdownButtonFormField<String>(
        initialValue: members.any((member) => member.coreUserId == currentValue)
            ? currentValue! as String
            : null,
        decoration: InputDecoration(labelText: field.name),
        items: [
          if (!field.isRequired)
            DropdownMenuItem(
              child: Text(context.l10n.taskDetailsNobody),
            ),
          for (final member in members)
            DropdownMenuItem(
              value: member.coreUserId,
              child: Text(_templateMemberLabel(context, member)),
            ),
        ],
        onChanged: enabled ? onChanged : null,
      ),
      TaskCustomFieldType.number || TaskCustomFieldType.text => TextFormField(
        initialValue: value?.toString() ?? '',
        enabled: enabled,
        keyboardType: field.type == TaskCustomFieldType.number
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(labelText: field.name),
        validator: (raw) {
          final normalized = raw?.trim() ?? '';
          if (field.isRequired && normalized.isEmpty) {
            return context.l10n.tasksTemplatesNameRequired;
          }
          if (field.type == TaskCustomFieldType.number &&
              normalized.isNotEmpty &&
              num.tryParse(normalized) == null) {
            return context.l10n.taskDetailsInvalidNumber;
          }
          return null;
        },
        onChanged: (raw) {
          final normalized = raw.trim();
          onChanged(
            normalized.isEmpty
                ? null
                : field.type == TaskCustomFieldType.number
                ? num.tryParse(normalized) ?? normalized
                : normalized,
          );
        },
      ),
    };
  }
}

class _TemplateCustomDateField extends StatelessWidget {
  const _TemplateCustomDateField({
    required this.field,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final TaskCustomFieldResponse field;
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final currentValue = value;
    final date = currentValue is DateTime
        ? currentValue
        : DateTime.tryParse(value?.toString() ?? '');
    return _TemplateDateField(
      label: field.name,
      value: date,
      enabled: enabled,
      onPick: (anchorContext) async {
        final box = anchorContext.findRenderObject() as RenderBox?;
        if (box == null) return;
        final picked = await pickAnchoredDate(
          anchorContext,
          initialValue: date,
          globalPosition: box.localToGlobal(Offset(0, box.size.height)),
        );
        if (picked != null) {
          onChanged(asUtcCalendarDate(picked.value)?.toIso8601String());
        }
      },
      onClear: () => onChanged(null),
    );
  }
}

class _TemplateDateField extends StatelessWidget {
  const _TemplateDateField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onPick,
    required this.onClear,
    this.hasError = false,
    this.errorText,
  });

  final String label;
  final DateTime? value;
  final bool enabled;
  final bool hasError;
  final String? errorText;
  final Future<void> Function(BuildContext anchorContext) onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _TemplateDomainPickerField(
        label: label,
        value: value == null
            ? null
            : MaterialLocalizations.of(
                context,
              ).formatMediumDate(value!.toLocal()),
        icon: Symbols.calendar_today_rounded,
        enabled: enabled,
        onTap: onPick,
        onClear: value == null ? null : onClear,
      ),
      if (hasError && errorText != null) ...[
        const SizedBox(height: 4),
        Text(
          errorText!,
          style: context.text.bodySmall?.copyWith(color: context.colors.error),
        ),
      ],
    ],
  );
}

class _TemplateValueBadge extends StatelessWidget {
  const _TemplateValueBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: .14),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      border: Border.all(color: color.withValues(alpha: .4), width: .8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class _TemplateCustomOptionValue extends StatelessWidget {
  const _TemplateCustomOptionValue({required this.raw});

  final String raw;

  @override
  Widget build(BuildContext context) {
    final option = CustomFieldOption.fromRaw(raw);
    return _TemplateValueBadge(
      label: option.label,
      icon: option.icon ?? Symbols.circle,
      color: option.color ?? context.colors.primary,
    );
  }
}

class _TemplateMultiOptionValue extends StatelessWidget {
  const _TemplateMultiOptionValue({required this.values});

  final List<dynamic> values;

  @override
  Widget build(BuildContext context) {
    final options = values
        .map((value) => CustomFieldOption.fromRaw(value.toString()))
        .toList(growable: false);
    final first = options.first;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TemplateValueBadge(
          label: first.label,
          icon: first.icon ?? Symbols.circle,
          color: first.color ?? context.colors.primary,
        ),
        if (options.length > 1) ...[
          const SizedBox(width: 4),
          Text(
            '+${options.length - 1}',
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _TemplateComplexityValue extends StatelessWidget {
  const _TemplateComplexityValue({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    final normalized = value.clamp(1, 5);
    final color =
        TaskComplexityLevel.fromValue(normalized)?.color ??
        context.colors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 1; index <= 5; index++)
          Container(
            width: 3.5,
            height: 10,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(1)),
              color: index <= normalized
                  ? color
                  : context.colors.outlineVariant.withValues(alpha: .35),
            ),
          ),
        const SizedBox(width: 3),
        Text(
          '$normalized',
          style: context.text.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Pole formularza otwierające ten sam zakotwiczony picker co komórka listy.
class _TemplateDomainPickerField extends StatelessWidget {
  const _TemplateDomainPickerField({
    required this.enabled,
    required this.label,
    required this.icon,
    required this.onTap,
    this.value,
    this.valueWidget,
    this.color,
    this.onClear,
  });

  final bool enabled;
  final String label;
  final String? value;
  final Widget? valueWidget;
  final IconData icon;
  final Color? color;
  final VoidCallback? onClear;
  final Future<void> Function(BuildContext anchorContext) onTap;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (anchorContext) => Material(
      color: context.colors.surfaceContainerLow.withValues(alpha: .65),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: enabled ? () => unawaited(onTap(anchorContext)) : null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 42),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: color ?? context.colors.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: context.text.labelMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Flexible(
                  child:
                      valueWidget ??
                      Text(
                        value ?? context.l10n.myTasksAny,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: context.text.labelMedium?.copyWith(
                          color: value == null
                              ? context.colors.onSurfaceVariant
                              : context.colors.onSurface,
                          fontWeight: value == null ? null : FontWeight.w600,
                        ),
                      ),
                ),
                const SizedBox(width: 4),
                if (onClear != null && enabled)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints.tightFor(
                      width: 28,
                      height: 28,
                    ),
                    padding: EdgeInsets.zero,
                    tooltip: context.l10n.myTasksClear,
                    onPressed: onClear,
                    icon: const Icon(Symbols.close_rounded, size: 16),
                  )
                else
                  const Icon(Symbols.chevron_right_rounded, size: 17),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _renameTemplate(
  BuildContext context,
  TaskTemplateResponse template, {
  TaskTemplatePickerCubit? pickerCubit,
}) async {
  final controller = TextEditingController(text: template.name);
  final cubit = pickerCubit ?? context.read<TaskTemplatePickerCubit>();
  final l10n = context.l10n;
  final colors = context.colors;

  final name = await showDialog<String>(
    context: context,
    builder: (dialogContext) => WorkspaceCreationModalWrapper(
      title: l10n.tasksTemplatesRename,
      subtitle: l10n.taskDetailsTemplateName,
      icon: Symbols.edit_rounded,
      accentColor: colors.primary,
      submitLabel: l10n.save,
      cancelLabel: l10n.cancel,
      maxWidth: 420,
      onSubmit: () => Navigator.of(dialogContext).pop(controller.text.trim()),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            maxLength: 120,
            decoration: InputDecoration(
              hintText: l10n.taskDetailsTemplateName,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onSubmitted: (value) =>
                Navigator.of(dialogContext).pop(value.trim()),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
  if (name == null || name.trim().isEmpty || name.trim() == template.name) {
    return;
  }

  await cubit.rename(templateId: template.id, name: name.trim());
}

Future<void> _confirmDeleteTemplate(
  BuildContext context,
  TaskTemplateResponse template, {
  TaskTemplatePickerCubit? pickerCubit,
}) async {
  final cubit = pickerCubit ?? context.read<TaskTemplatePickerCubit>();
  final confirmed = await AppConfirmDialog.show(
    context,
    title: context.l10n.tasksTemplatesDeleteTitle,
    message: context.l10n.tasksTemplatesDeleteDescription(template.name),
    confirmLabel: context.l10n.delete,
    cancelLabel: context.l10n.cancel,
    tone: AppConfirmDialogTone.danger,
  );
  if (confirmed) {
    await cubit.delete(template.id);
  }
}
