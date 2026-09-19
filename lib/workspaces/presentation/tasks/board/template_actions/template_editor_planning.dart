part of '../tasks_board_page.dart';

extension _TemplateEditorPlanning on _TaskTemplateEditorState {
  Widget _buildPlanningSection(
    BuildContext context,
    List<SelectedTemplateStatus> availableStatuses,
  ) =>
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
            color: _status == null
                ? null
                : TaskBoardColorParser.parse(_status!.color),
            valueWidget: _status == null
                ? null
                : _TemplateValueBadge(
                    label: _status!.displayName,
                    icon: TaskStatusVisualHelper.icon(
                      _status!.fallbackStatus,
                    ),
                    color: TaskBoardColorParser.parse(_status!.color),
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
                _updateEditorState(() => _priority = value);
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
              _updateEditorState(() => _startAtUtc = null);
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
              _updateEditorState(() => _dueAtUtc = null);
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
            onTap: (anchorContext) => TaskDurationEditor.show(
              anchorContext,
              currentMinutes: _estimate,
              title: context.l10n.taskDetailsEstimateMinutes,
              onSave: (value) async {
                _markDirty();
                _updateEditorState(() => _estimate = value);
                return true;
              },
            ),
          ),
        ],
      );
}
