part of '../tasks_board_page.dart';

extension _TemplateEditorResponsibility on _TaskTemplateEditorState {
  Widget _buildResponsibilitySection(BuildContext context) =>
      // 3. Odpowiedzialność
      _TemplateSectionCard(
        title: context.l10n.tasksTemplatesSectionResponsibility,
        icon: Symbols.people_rounded,
        children: [
          _AssigneePickerSection(
            members: widget.members,
            selectedUserIds: _assigneeUserIds,
            enabled: !_saving,
            onToggle: (userId) {
              _markDirty();
              _updateEditorState(() {
                if (_assigneeUserIds.contains(userId)) {
                  _assigneeUserIds.remove(userId);
                } else {
                  _assigneeUserIds.add(userId);
                }
              });
            },
          ),
        ],
      );
}
