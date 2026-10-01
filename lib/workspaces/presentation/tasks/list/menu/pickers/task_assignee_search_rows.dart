import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_assignee_profile_presentation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

final class TaskAssigneeClearPrimaryAction extends StatelessWidget {
  const TaskAssigneeClearPrimaryAction({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: onTap,
        hoverColor: context.colors.error.withValues(alpha: .09),
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: context.colors.error.withValues(alpha: .05),
          child: Row(
            children: [
              Icon(
                Symbols.person_off_rounded,
                size: 14,
                color: context.colors.error,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.tasksAssigneeClearPrimary,
                style: context.tasksTheme.controlText.copyWith(
                  color: context.colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      Divider(height: 1, color: context.tasksTheme.canvasBorder),
    ],
  );
}

final class TaskAssigneeSearchResultRow extends StatelessWidget {
  const TaskAssigneeSearchResultRow({
    required this.profile,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final ProjectMemberProfile profile;
  final bool selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
    );
    return Material(
      color: selected
          ? context.colors.surfaceContainerHighest
          : Colors.transparent,
      shape: shape,
      child: ListTile(
        dense: true,
        minTileHeight: 36,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        hoverColor: context.tasksTheme.selectionAccent.withValues(alpha: .08),
        shape: shape,
        leading: Icon(
          Symbols.person_outline_rounded,
          size: 17,
          color: context.colors.onSurfaceVariant,
        ),
        title: Text(
          TaskAssigneeProfilePresentation.label(context, profile),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.tasksTheme.controlText,
        ),
        trailing: Icon(
          selected ? Symbols.check_circle_rounded : Symbols.add_rounded,
          color: selected
              ? context.tasksTheme.selectionAccent
              : context.colors.onSurfaceVariant,
          size: 16,
        ),
        onTap: () => onSelected(profile.userId),
      ),
    );
  }
}

final class TaskAssigneeLoadingRow extends StatelessWidget {
  const TaskAssigneeLoadingRow({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Center(
      child: SizedBox.square(
        dimension: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.tasksTheme.selectionAccent,
        ),
      ),
    ),
  );
}
