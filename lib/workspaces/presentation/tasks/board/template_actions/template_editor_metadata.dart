part of '../tasks_board_page.dart';

extension _TemplateEditorMetadata on _TaskTemplateEditorState {
  Widget _buildMetadataSection(
    BuildContext context,
    List<TaskLabelResponse> projectLabels,
  ) =>
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
                    backgroundColor: TaskBoardColorParser.parse(
                      label.color,
                    ).withValues(alpha: .14),
                    selected: _labels.any(
                      (selected) => selected.name == label.name,
                    ),
                    onSelected: _saving
                        ? null
                        : (selected) {
                            _markDirty();
                            _updateEditorState(() {
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
      );
}
