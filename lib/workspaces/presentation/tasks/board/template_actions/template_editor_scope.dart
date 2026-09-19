part of '../tasks_board_page.dart';

extension _TemplateEditorScope on _TaskTemplateEditorState {
  Widget _buildScopeSection(BuildContext context) =>
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
              _updateEditorState(() => _checklistItems = items);
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
              _updateEditorState(() => _acceptanceCriteria = items);
            },
          ),
        ],
      );
}
