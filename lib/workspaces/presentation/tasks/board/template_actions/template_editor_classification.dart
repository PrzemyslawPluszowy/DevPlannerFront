part of '../tasks_board_page.dart';

extension _TemplateEditorClassification on _TaskTemplateEditorState {
  Widget _buildClassificationSection(BuildContext context) =>
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
                        TaskPresetType.fromName(_taskType)?.label ?? _taskType!,
                    icon:
                        TaskPresetType.fromName(_taskType)?.icon ??
                        Symbols.label_important_rounded,
                    color:
                        TaskPresetType.fromName(_taskType)?.color ??
                        context.colors.primary,
                  ),
            enabled: !_saving,
            onTap: (anchorContext) => TaskTypePicker.show(
              anchorContext,
              currentType: _taskType,
              onSave: (value) async {
                _markDirty();
                _updateEditorState(
                  () => _taskType = value.isEmpty ? null : value,
                );
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
                  onTap: (anchorContext) => TaskSizePicker.show(
                    anchorContext,
                    currentSize: _size,
                    onSave: (value) async {
                      _markDirty();
                      _updateEditorState(() => _size = value);
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
                  onTap: (anchorContext) => TaskComplexityPicker.show(
                    anchorContext,
                    currentComplexity: _complexity,
                    onSave: (value) async {
                      _markDirty();
                      _updateEditorState(() => _complexity = value);
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
                              TaskRiskLevel.fromValue(_risk)?.label ?? '$_risk',
                          icon: Symbols.shield_rounded,
                          color:
                              TaskRiskLevel.fromValue(_risk)?.color ??
                              context.colors.error,
                        ),
                  onTap: (anchorContext) => TaskRiskPicker.show(
                    anchorContext,
                    currentRisk: _risk,
                    onSave: (value) async {
                      _markDirty();
                      _updateEditorState(() => _risk = value);
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
                  value: _businessValue == null ? null : '$_businessValue pkt',
                  icon: Symbols.stars_rounded,
                  color: context.colors.primary,
                  valueWidget: _businessValue == null
                      ? null
                      : _TemplateValueBadge(
                          label: '$_businessValue',
                          icon: Symbols.stars_rounded,
                          color: context.colors.primary,
                        ),
                  onTap: (anchorContext) => TaskBusinessValuePicker.show(
                    anchorContext,
                    currentValue: _businessValue,
                    onSave: (value) async {
                      _markDirty();
                      _updateEditorState(() => _businessValue = value);
                      return true;
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}
