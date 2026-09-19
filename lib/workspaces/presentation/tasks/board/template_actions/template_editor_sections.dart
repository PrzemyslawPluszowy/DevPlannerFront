part of '../tasks_board_page.dart';

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
  final ValueNotifier<String> _query = ValueNotifier('');

  @override
  void dispose() {
    _searchController.dispose();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
    valueListenable: _query,
    builder: (context, query, _) => _buildPicker(context, query),
  );

  Widget _buildPicker(BuildContext context, String query) {
    final selectedMembers = widget.members
        .where((m) => widget.selectedUserIds.contains(m.userId))
        .toList(growable: false);

    final filteredMembers = widget.members
        .where((m) {
          if (query.trim().isEmpty) return true;
          final name = _TemplateEditorHelpers.memberLabel(
            context,
            m,
          ).toLowerCase();
          return name.contains(query.trim().toLowerCase());
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
                    backgroundColor: TaskBoardAvatarPalette.colorFor(
                      member.userId,
                    ),
                    foregroundColor: context.tasksTheme.onAccent,
                    child: Text(
                      _TemplateEditorHelpers.memberInitial(member),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  label: Text(
                    _TemplateEditorHelpers.memberLabel(context, member),
                  ),
                  onDeleted: widget.enabled
                      ? () => widget.onToggle(member.userId)
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
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Symbols.clear_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _query.value = '';
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          onChanged: (value) => _query.value = value,
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
                  member.userId,
                );
                return Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: TaskBoardAvatarPalette.colorFor(
                        member.userId,
                      ),
                      foregroundColor: context.tasksTheme.onAccent,
                      child: Text(
                        _TemplateEditorHelpers.memberInitial(member),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    title: Text(
                      _TemplateEditorHelpers.memberLabel(context, member),
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
                        ? () => widget.onToggle(member.userId)
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

final class _TemplateEditorHelpers {
  const _TemplateEditorHelpers._();

  static List<SelectedTemplateStatus> buildAvailableStatuses(
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
            customStatusCategory: mapTaskStatusToCategory(col.status),
          ),
      ];
    }
    return [
      for (final status in ProjectTaskStatus.values)
        SelectedTemplateStatus(
          fallbackStatus: status,
          displayName: TaskStatusVisualHelper.label(context, status),
          color: '#2563EB',
          customStatusCategory: mapTaskStatusToCategory(status),
        ),
    ];
  }

  static TaskStatusCategory mapTaskStatusToCategory(ProjectTaskStatus status) =>
      switch (status) {
        ProjectTaskStatus.backlog ||
        ProjectTaskStatus.todo => TaskStatusCategory.todo,
        ProjectTaskStatus.inProgress ||
        ProjectTaskStatus.blocked => TaskStatusCategory.inProgress,
        ProjectTaskStatus.done => TaskStatusCategory.done,
        ProjectTaskStatus.cancelled => TaskStatusCategory.cancelled,
      };

  static String memberLabel(
    BuildContext context,
    ProjectMemberProfile member,
  ) {
    final displayName = member.displayName?.trim();
    return displayName?.isNotEmpty == true
        ? displayName!
        : context.l10n.tasksPresenceAnonymousUser;
  }

  static String memberInitial(ProjectMemberProfile member) {
    final displayName = member.displayName?.trim();
    if (displayName?.isNotEmpty == true) {
      return displayName!.characters.first.toUpperCase();
    }
    return '?';
  }
}

/// Kompaktowa lista zakresu pracy. Każdy wpis jest osobnym elementem, a nie
/// fragmentem wielowierszowego tekstu wymagającym ręcznego separatora.
