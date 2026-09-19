part of '../tasks_board_page.dart';

/// Ładowanie i normalizacja statusu edytora szablonu.
extension _TemplateEditorLoading on _TaskTemplateEditorState {
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
        customStatusCategory: _TemplateEditorHelpers.mapTaskStatusToCategory(
          todoCol.status,
        ),
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
    _updateEditorState(() {
      _loading = true;
      _loadError = null;
    });

    final result = await _cubit.loadDetails(template.id);
    if (!mounted) return;

    switch (result) {
      case TaskTemplateDetailsLoadFailure(:final error):
        _updateEditorState(() {
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
              customStatusCategory:
                  _TemplateEditorHelpers.mapTaskStatusToCategory(
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
              customStatusCategory:
                  _TemplateEditorHelpers.mapTaskStatusToCategory(
                    details.status,
                  ),
            );
          }
        }

        _updateEditorState(() {
          _details = details;
          _status = matchedStatus;
          _priority = details.priority;
          _startAtUtc = details.startAtUtc;
          _dueAtUtc = details.dueAtUtc;
          _assigneeUserIds = details.assigneeUserIds.toSet();
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
}
