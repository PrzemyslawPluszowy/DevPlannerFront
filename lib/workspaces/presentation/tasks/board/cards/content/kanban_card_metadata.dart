part of '../../tasks_board_page.dart';

/// Podstawowe metadane karty: termin, checklistę, podzadania i wykonawcę.
class _CardPrimaryMeta extends StatelessWidget {
  const _CardPrimaryMeta({
    required this.task,
    required this.visibleCardFields,
    required this.detailed,
    required this.memberProfilesByUserId,
    required this.hasSubtasksSection,
  });

  final KanbanTaskCardResponse task;
  final List<KanbanCardField> visibleCardFields;
  final bool detailed;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final bool hasSubtasksSection;

  bool shows(KanbanCardField field) => visibleCardFields.contains(field);

  @override
  Widget build(BuildContext context) {
    final showAssignee =
        shows(KanbanCardField.assignee) && task.primaryAssigneeUserId != null;
    final showDueDate = shows(KanbanCardField.dueDate) && task.dueAtUtc != null;
    final showChecklist =
        shows(KanbanCardField.checklist) && task.checklistTotal > 0;
    final showSubtasksCounter =
        shows(KanbanCardField.subtasks) &&
        !hasSubtasksSection &&
        task.subtaskTotal > 0;
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (showDueDate)
                _MetaText(
                  icon: Symbols.event_rounded,
                  value: MaterialLocalizations.of(
                    context,
                  ).formatMediumDate(task.dueAtUtc!.toLocal()),
                ),
              if (showChecklist)
                _MetaText(
                  icon: Symbols.checklist_rounded,
                  value: '${task.checklistCompleted}/${task.checklistTotal}',
                ),
              if (showSubtasksCounter)
                _MetaText(
                  icon: Symbols.account_tree_rounded,
                  value: '${task.subtaskCompleted}/${task.subtaskTotal}',
                ),
            ],
          ),
        ),
        if (showAssignee) ...[
          const SizedBox(width: 8),
          _CardAssigneeAvatar(
            userId: task.primaryAssigneeUserId!,
            profile: memberProfilesByUserId[task.primaryAssigneeUserId!],
            radius: KanbanCardTokens.parentAvatarRadius,
          ),
        ],
      ],
    );
  }
}

/// Szczegółowe metadane: czas, blokady, okładka i pola niestandardowe.
class _CardDetailedMeta extends StatelessWidget {
  const _CardDetailedMeta({
    required this.task,
    required this.visibleCardFields,
  });

  final KanbanTaskCardResponse task;
  final List<KanbanCardField> visibleCardFields;

  bool shows(KanbanCardField field) => visibleCardFields.contains(field);

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 10,
    runSpacing: 4,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      if (shows(KanbanCardField.blockers) && task.isBlocked)
        Semantics(
          label: context.l10n.tasksKanbanFieldBlockers,
          child: Icon(
            Symbols.block_rounded,
            size: KanbanCardTokens.metaIconSize,
            color: context.colors.error,
          ),
        ),
      if (shows(KanbanCardField.timeTracking) &&
          (task.loggedMinutes != null || task.estimatedMinutes != null))
        _MetaText(icon: Symbols.timer_rounded, value: _timeValue(task)),
      if (shows(KanbanCardField.coverAttachment) &&
          task.coverAttachmentId != null)
        Semantics(
          label: context.l10n.tasksKanbanFieldCoverAttachment,
          child: Icon(
            Symbols.image_rounded,
            size: KanbanCardTokens.metaIconSize,
            color: context.colors.onSurfaceVariant,
          ),
        ),
      if (shows(KanbanCardField.customFields) &&
          (task.customFieldsSummary ?? const []).isNotEmpty)
        _CustomFieldSummary(fields: task.customFieldsSummary!),
    ],
  );

  static String _timeValue(KanbanTaskCardResponse task) {
    final logged = task.loggedMinutes;
    final estimated = task.estimatedMinutes;
    if (logged == null) return _duration(estimated!);
    if (estimated == null) return _duration(logged);
    return '${_duration(logged)} / ${_duration(estimated)}';
  }

  static String _duration(int minutes) {
    final hours = minutes ~/ 60;
    final remainder = minutes % 60;
    if (hours == 0) return '${remainder}m';
    if (remainder == 0) return '${hours}h';
    return '${hours}h ${remainder}m';
  }
}

/// Etykiety statusu/klasyfikacji renderowane jako krótkie znaczniki.
class _CardLabels extends StatelessWidget {
  const _CardLabels({required this.labels});

  final List<KanbanCardLabelResponse> labels;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 5,
    runSpacing: 4,
    children: [
      for (final label in labels.take(2))
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: TaskBoardColorParser.parse(label.color)
                .withValues(alpha: .13),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label.name,
            style: KanbanCardTokens.metaText(context, weight: FontWeight.w500),
          ),
        ),
      if (labels.length > 2)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHighest.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            '+${labels.length - 2}',
            style: KanbanCardTokens.metaText(context, weight: FontWeight.w500),
          ),
        ),
    ],
  );
}

class _CustomFieldSummary extends StatelessWidget {
  const _CustomFieldSummary({required this.fields});

  final List<KanbanCardCustomFieldResponse> fields;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: 4,
    children: [
      for (final field in fields.take(2))
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHighest.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${field.name}: ${field.valueJson}',
            style: KanbanCardTokens.metaText(context),
          ),
        ),
    ],
  );
}

class _CardAssigneeAvatar extends StatelessWidget {
  const _CardAssigneeAvatar({
    required this.userId,
    required this.profile,
    required this.radius,
  });

  final String userId;
  final ProjectMemberProfile? profile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final displayName = profile?.displayName?.trim();
    final label = displayName?.isNotEmpty == true
        ? displayName!
        : context.l10n.tasksPresenceAnonymousUser;
    final avatarUrl = profile?.avatarUrl?.trim();
    return Semantics(
      label: label,
      child: CircleAvatar(
        radius: radius,
        foregroundImage: avatarUrl?.isNotEmpty == true
            ? NetworkImage(avatarUrl!)
            : null,
        backgroundColor: TaskBoardAvatarPalette.colorFor(userId),
        child: avatarUrl?.isNotEmpty == true
            ? null
            : Text(
                label.characters.first.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: radius > 11 ? 10 : 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

final class TaskBoardAvatarPalette {
  const TaskBoardAvatarPalette._();

  static Color colorFor(String id) {
    const palette = <Color>[
      Color(0xFF6C5CE7),
      Color(0xFF0984E3),
      Color(0xFF00A884),
      Color(0xFFE17055),
    ];
    return palette[id.hashCode.abs() % palette.length];
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: KanbanCardTokens.metaIconSize,
        color: context.colors.onSurfaceVariant,
      ),
      const SizedBox(width: 4),
      Text(value, style: KanbanCardTokens.metaText(context)),
    ],
  );
}

/// Semantyczny wskaźnik priorytetu zadania.
class _PriorityIndicator extends StatelessWidget {
  const _PriorityIndicator({required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final label = switch (priority) {
      TaskPriority.low => context.l10n.tasksPriorityLow,
      TaskPriority.normal => context.l10n.tasksPriorityNormal,
      TaskPriority.high => context.l10n.tasksPriorityHigh,
      TaskPriority.critical => context.l10n.tasksPriorityCritical,
    };
    final color = switch (priority) {
      TaskPriority.low => const Color(0xFF3B82F6),
      TaskPriority.normal => const Color(0xFF10B981),
      TaskPriority.high => const Color(0xFFF59E0B),
      TaskPriority.critical => const Color(0xFFEF4444),
    };
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: Icon(Symbols.flag_rounded, size: 14, color: color),
      ),
    );
  }
}
