import 'package:devplanner/workspaces/presentation/tasks/detail/task_detail_person.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

export 'task_edit_assignees_dialog.dart';

/// Sekcja obserwowania zadania z kompaktowym stosem avatarów.
class TaskWatchersSection extends StatelessWidget {
  const TaskWatchersSection({
    required this.details,
    required this.isSaving,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 460;
      final action = TaskWatchToggleButton(
        details: details,
        isSaving: isSaving,
      );
      return Section(
        title: context.l10n.taskDetailsWatchers,
        action: compact ? null : action,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (compact) Align(alignment: Alignment.centerLeft, child: action),
            TaskWatchersAvatars(details: details),
          ],
        ),
      );
    },
  );
}

final class TaskWatchToggleButton extends StatelessWidget {
  const TaskWatchToggleButton({
    required this.details,
    required this.isSaving,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: isSaving
        ? null
        : () => context.read<TaskDetailsCubit>().toggleWatching(),
    icon: Icon(
      details.isWatchedByMe
          ? Symbols.notifications_active
          : Symbols.notifications_none_rounded,
      size: 18,
    ),
    label: Text(
      details.isWatchedByMe
          ? context.l10n.taskDetailsStopWatching
          : context.l10n.taskDetailsWatch,
      softWrap: true,
    ),
  );
}

final class TaskWatchersAvatars extends StatelessWidget {
  const TaskWatchersAvatars({required this.details, super.key});

  final ProjectTaskDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    if (details.watchers.isEmpty) {
      return Text(
        context.l10n.taskDetailsNoWatchers,
        style: context.text.bodyMedium?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      );
    }
    final visible = details.watchers.take(5);
    final remaining = details.watchers.length - visible.length;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final watcher in visible)
          TaskDetailPerson(
            userId: watcher.userId,
            user: details.includedUsers
                .where((user) => user.userId == watcher.userId)
                .firstOrNull,
          ),
        if (remaining > 0) WatcherOverflow(count: remaining),
      ],
    );
  }
}

class WatcherAvatar extends StatelessWidget {
  const WatcherAvatar({required this.user, super.key});

  final UserReferenceResponse? user;

  @override
  Widget build(BuildContext context) {
    final label = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : context.l10n.taskDetailsProjectMember;
    final initial = label.characters.first.toUpperCase();
    final avatarUrl = user?.avatarUrl?.trim();
    return Tooltip(
      message: label,
      child: CircleAvatar(
        radius: 17,
        foregroundImage: avatarUrl?.isNotEmpty == true
            ? NetworkImage(avatarUrl!)
            : null,
        backgroundColor: TaskCollaboratorAvatarPalette.colorFor(label),
        child: Text(
          initial,
          style: context.tasksTheme.metaText.copyWith(
            height: 1,
            fontWeight: FontWeight.w700,
            color: context.tasksTheme.onAccent,
          ),
        ),
      ),
    );
  }
}

class WatcherOverflow extends StatelessWidget {
  const WatcherOverflow({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 17,
    backgroundColor: context.colors.surfaceContainerHighest,
    child: Text(
      context.l10n.taskDetailsWatchersMore(count),
      style: context.text.labelSmall?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

/// Deterministyczna paleta awatarów współpracowników bez stanu i I/O.
final class TaskCollaboratorAvatarPalette {
  const TaskCollaboratorAvatarPalette._();

  static Color colorFor(String value) {
    const palette = [
      Color(0xFF4F46E5),
      Color(0xFF0F766E),
      Color(0xFF92400E),
      Color(0xFFBE123C),
      Color(0xFF7C3AED),
    ];
    return palette[value.hashCode.abs() % palette.length];
  }
}
