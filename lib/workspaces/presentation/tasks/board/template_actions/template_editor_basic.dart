part of '../tasks_board_page.dart';

extension _TemplateEditorBasic on _TaskTemplateEditorState {
  Widget _buildBasicSection(BuildContext context) =>
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
      );
}
