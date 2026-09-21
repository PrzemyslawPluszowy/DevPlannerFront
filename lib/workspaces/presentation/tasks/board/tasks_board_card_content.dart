part of 'tasks_board_page.dart';

/// Prezentacyjna zawartość karty Kanban z uporządkowaną hierarchią.
///
/// Entry point pozostaje cienki; ramka, tożsamość i metadane są wydzielone do
/// plików `cards/content`, aby każda odpowiedzialność była łatwa do utrzymania.
class KanbanTaskCard extends StatelessWidget {
  const KanbanTaskCard({
    required this.task,
    required this.workspaceId,
    required this.projectId,
    required this.visibleCardFields,
    required this.density,
    required this.isSelected,
    required this.memberProfilesByUserId,
    this.statusBadge,
    this.isPending = false,
    this.hasError = false,
    this.focusNode,
    super.key,
  });

  final KanbanTaskCardResponse task;
  final String workspaceId;
  final String projectId;
  final List<KanbanCardField> visibleCardFields;
  final KanbanCardDensity density;
  final bool isSelected;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;

  /// Status karty jako badge; widok osób pokazuje go, bo tam kolumna opisuje
  /// osobę, a nie etap workflow.
  final KanbanCardStatusBadge? statusBadge;

  /// Czy zapis tej karty trwa (stan pending z tokenów).
  final bool isPending;

  /// Czy ostatni zapis tej karty się nie udał (stan error z tokenów).
  final bool hasError;
  final FocusNode? focusNode;

  bool get _isCompact => density == KanbanCardDensity.compact;
  bool get _isDetailed => density == KanbanCardDensity.detailed;
  bool shows(KanbanCardField field) => visibleCardFields.contains(field);

  /// Sekcja podzadań jest montowana zawsze, gdy pole jest widoczne — także dla
  /// zadania bez podzadań, bo inaczej karta nie ma żadnej akcji dodania
  /// (a licznik w metadanych nigdy się nie pokazywał).
  bool get _hasSubtasksSection => shows(KanbanCardField.subtasks);

  bool get _hasPrimaryMeta =>
      (shows(KanbanCardField.assignee) && task.primaryAssigneeUserId != null) ||
      (shows(KanbanCardField.dueDate) && task.dueAtUtc != null) ||
      (shows(KanbanCardField.checklist) && task.checklistTotal > 0);

  bool get _hasDetailedMeta =>
      (shows(KanbanCardField.timeTracking) &&
          (task.loggedMinutes != null || task.estimatedMinutes != null)) ||
      (shows(KanbanCardField.blockers) && task.isBlocked) ||
      (shows(KanbanCardField.coverAttachment) &&
          task.coverAttachmentId != null) ||
      (shows(KanbanCardField.customFields) &&
          (task.customFieldsSummary ?? const []).isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final contentPadding = _isCompact
        ? KanbanCardTokens.contentPaddingCompact
        : KanbanCardTokens.contentPaddingComfortable;
    final spacing = _isCompact
        ? KanbanCardTokens.sectionSpacingCompact
        : KanbanCardTokens.sectionSpacingComfortable;

    void openDetails() {
      final router = GoRouter.maybeOf(context);
      if (router == null) return;
      unawaited(
        DevPlannerNavigation(router).go(
          '/workspaces/$workspaceId/projects/$projectId/tasks/${task.id}',
        ),
      );
    }

    void openContextMenu([Offset? globalPosition]) {
      unawaited(
        KanbanCardContextMenuHelper.show(
          context: context,
          task: task,
          workspaceId: workspaceId,
          projectId: projectId,
          memberProfilesByUserId: memberProfilesByUserId,
          globalPosition: globalPosition,
        ),
      );
    }

    return KanbanCardFrame(
      isSelected: isSelected,
      isPending: isPending,
      hasError: hasError,
      focusNode: focusNode,
      padding: contentPadding,
      semanticsLabel: context.l10n.tasksOpenTask(task.taskCode, task.title),
      onTap: openDetails,
      onSecondaryTapUp: (details) => openContextMenu(details.globalPosition),
      onShowContextMenu: openContextMenu,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _CardIdentity(
              task: task,
              isSelected: isSelected,
              workspaceId: workspaceId,
              projectId: projectId,
              memberProfilesByUserId: memberProfilesByUserId,
            ),
            const SizedBox(height: KanbanCardTokens.identityToTitleSpacing),
            Text(
              task.title,
              maxLines: _isCompact
                  ? 2
                  : _isDetailed
                  ? 3
                  : 2,
              overflow: TextOverflow.ellipsis,
              style: KanbanCardTokens.parentTitle(context),
            ),
            if (statusBadge != null) ...[
              SizedBox(height: spacing),
              _CardStatusBadge(badge: statusBadge!),
            ],
            if (shows(KanbanCardField.labels) &&
                (task.labels ?? const []).isNotEmpty) ...[
              SizedBox(height: spacing),
              _CardLabels(labels: task.labels!),
            ],
            if (_hasPrimaryMeta) ...[
              SizedBox(height: spacing),
              _CardPrimaryMeta(
                task: task,
                visibleCardFields: visibleCardFields,
                detailed: _isDetailed,
                memberProfilesByUserId: memberProfilesByUserId,
                hasSubtasksSection: _hasSubtasksSection,
              ),
            ],
            if (_hasSubtasksSection) ...[
              SizedBox(height: spacing),
              KanbanCardSubtasksSection(
                task: task,
                workspaceId: workspaceId,
                projectId: projectId,
                memberProfilesByUserId: memberProfilesByUserId,
                density: density,
              ),
            ],
            if (_isDetailed && _hasDetailedMeta) ...[
              SizedBox(height: spacing),
              _CardDetailedMeta(
                task: task,
                visibleCardFields: visibleCardFields,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

typedef _TaskCard = KanbanTaskCard;
