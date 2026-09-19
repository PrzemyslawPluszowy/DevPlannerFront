part of '../tasks_board_page.dart';

/// Walidacja, zapis i wybory formularza szablonu.
extension _TemplateEditorMutations on _TaskTemplateEditorState {
  void _markDirty() {
    if (!_isDirty) {
      _updateEditorState(() => _isDirty = true);
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
      _updateEditorState(() {
        _autovalidateMode = AutovalidateMode.always;
        _saveError = context.l10n.tasksTemplatesFormFixErrors;
      });
      return;
    }

    _updateEditorState(() {
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
                  _TemplateEditorHelpers.mapTaskStatusToCategory(
                    currentStatus.fallbackStatus,
                  ),
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
        assigneeUserIds: _assigneeUserIds.toList(growable: false),
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
                  _TemplateEditorHelpers.mapTaskStatusToCategory(
                    currentStatus.fallbackStatus,
                  ),
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
        assigneeUserIds: _assigneeUserIds.toList(growable: false),
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
      _updateEditorState(() {
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
    final selected = await AppContextMenu.select<SelectedTemplateStatus>(
      anchorContext,
      globalPosition: AppContextMenu.positionFor(anchorContext),
      options: [
        for (final item in statuses)
          AppContextMenuOption(
            value: item,
            label: item.displayName,
            icon: TaskStatusVisualHelper.icon(item.fallbackStatus),
            iconColor: TaskBoardColorParser.parse(item.color),
            selected: item == _status,
          ),
      ],
    );
    if (selected == null || !mounted) return;
    _markDirty();
    _updateEditorState(() => _status = selected);
  }

  Future<void> _pickDate(
    BuildContext anchorContext, {
    required bool startDate,
  }) async {
    final current = startDate ? _startAtUtc : _dueAtUtc;
    final box = anchorContext.findRenderObject() as RenderBox?;
    if (box == null) return;
    final selection = await TaskDatePicker.pick(
      anchorContext,
      initialValue: current,
      globalPosition: box.localToGlobal(Offset(0, box.size.height)),
    );
    if (selection == null || !mounted) return;
    _markDirty();
    _updateEditorState(() {
      final utcDate = TaskDatePicker.asUtcCalendarDate(selection.value);
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
    _updateEditorState(() {
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
}
