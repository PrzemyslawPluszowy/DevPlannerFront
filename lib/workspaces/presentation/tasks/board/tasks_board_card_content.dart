part of 'tasks_board_page.dart';

/// Prezentacyjna zawartość karty Kanban z punktowym obrysem i uporządkowaną hierarchią.
///
/// Zgodnie ze specyfikacją visual reset:
/// - Ramka `KanbanDottedCardFrame` odpowiada za klipowanie, stan hover/focus/selected oraz punktowy obrys (Dotted).
/// - Spokojna powierzchnia karty bez cienia w spoczynku, stapiająca się z tłem kolumny.
/// - Uporządkowana kolejność sekcji: identity → title → labels → primary meta → subtasks → detailed meta.
/// - Stabilna oś pionowa lewej krawędzi tekstu i kodu.
/// - Licznik podzadań ukryty z metadanych karty, gdy podzadania są obecne.
class KanbanTaskCard extends StatelessWidget {
  const KanbanTaskCard({
    required this.task,
    required this.workspaceId,
    required this.projectId,
    required this.visibleCardFields,
    required this.density,
    required this.isSelected,
    required this.memberProfilesByCoreUserId,
    this.focusNode,
    super.key,
  });

  final KanbanTaskCardResponse task;
  final String workspaceId;
  final String projectId;
  final List<KanbanCardField> visibleCardFields;
  final KanbanCardDensity density;
  final bool isSelected;
  final Map<String, ProjectMemberProfile> memberProfilesByCoreUserId;
  final FocusNode? focusNode;

  bool get _isCompact => density == KanbanCardDensity.compact;
  bool get _isDetailed => density == KanbanCardDensity.detailed;
  bool shows(KanbanCardField field) => visibleCardFields.contains(field);
  bool get _hasSubtasksSection =>
      shows(KanbanCardField.subtasks) && task.subtaskTotal > 0;

  bool get _hasPrimaryMeta =>
      (shows(KanbanCardField.assignee) &&
          task.primaryAssigneeCoreUserId != null) ||
      (shows(KanbanCardField.dueDate) && task.dueAtUtc != null) ||
      (shows(KanbanCardField.checklist) && task.checklistTotal > 0) ||
      (shows(KanbanCardField.subtasks) &&
          !_hasSubtasksSection &&
          task.subtaskTotal > 0);

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
      final router = context.read<AppRouter?>();
      if (router != null) {
        unawaited(
          router.navigatePath(
            '/workspaces/$workspaceId/projects/$projectId/tasks/${task.id}',
          ),
        );
      }
    }

    void openContextMenu([Offset? globalPosition]) {
      unawaited(
        KanbanCardContextMenuHelper.show(
          context: context,
          task: task,
          workspaceId: workspaceId,
          projectId: projectId,
          memberProfilesByCoreUserId: memberProfilesByCoreUserId,
          globalPosition: globalPosition,
        ),
      );
    }

    return KanbanCardFrame(
      isSelected: isSelected,
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
            // 1. Tożsamość: kod zadania, stała oś, subtelny checkbox, priorytet i menu
            _CardIdentity(
              task: task,
              isSelected: isSelected,
              workspaceId: workspaceId,
              projectId: projectId,
              memberProfilesByCoreUserId: memberProfilesByCoreUserId,
            ),
            const SizedBox(height: KanbanCardTokens.identityToTitleSpacing),

            // 2. Tytuł zadania: 15 px / 20 px, w500, zaczyna się na stałej osi pionowej
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

            // 3. Etykiety
            if (shows(KanbanCardField.labels) &&
                (task.labels ?? const []).isNotEmpty) ...[
              SizedBox(height: spacing),
              _CardLabels(labels: task.labels!),
            ],

            // 4. Primary Meta (termin, wykonawca 24 px, checklist progress)
            if (_hasPrimaryMeta) ...[
              SizedBox(height: spacing),
              _CardPrimaryMeta(
                task: task,
                visibleCardFields: visibleCardFields,
                detailed: _isDetailed,
                memberProfilesByCoreUserId: memberProfilesByCoreUserId,
                hasSubtasksSection: _hasSubtasksSection,
              ),
            ],

            // 5. Sekcja podzadań (jedyny licznik i rozwijanie podzadań na karcie)
            if (_hasSubtasksSection) ...[
              SizedBox(height: spacing),
              KanbanCardSubtasksSection(
                task: task,
                workspaceId: workspaceId,
                projectId: projectId,
                memberProfilesByCoreUserId: memberProfilesByCoreUserId,
                density: density,
              ),
            ],

            // 6. Detailed Meta (pola niestandardowe, czas, blokady, załączniki)
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

/// Ramka karty Kanban z subtelnym, ciągłym obrysem (1 px) i obsługą stanów hover/focus/selected.
///
/// Zgodnie ze specyfikacją naprawy UI (Etap B):
/// - Posiada ciągły, precyzyjny obrys 1 px o niskim kontraście w spoczynku.
/// - Na hover zwiększa kontrast obrysu oraz dodaje subtelną elewację (2 px) bez przesuwania geometrii layoutu.
/// - Na focus wyświetla 2 px focus ring w kolorze primary.
/// - Przy zaznaczeniu karty podświetla obrys kolorem primary i wypełnia tło delikatnym odcieniem.
class KanbanCardFrame extends StatefulWidget {
  const KanbanCardFrame({
    required this.child,
    this.isSelected = false,
    this.onTap,
    this.onSecondaryTapUp,
    this.onShowContextMenu,
    this.semanticsLabel,
    this.padding,
    this.focusNode,
    super.key,
  });

  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap;
  final void Function(TapUpDetails details)? onSecondaryTapUp;
  final VoidCallback? onShowContextMenu;
  final String? semanticsLabel;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;

  @override
  State<KanbanCardFrame> createState() => _KanbanCardFrameState();
}

class _KanbanCardFrameState extends State<KanbanCardFrame> {
  var _isHovered = false;
  var _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = widget.isSelected
        ? KanbanCardTokens.cardBorderSelected(colors)
        : _isHovered
        ? KanbanCardTokens.cardBorderHover(colors, isDark: isDark)
        : KanbanCardTokens.cardBorderRest(colors, isDark: isDark);

    final cardBackgroundColor = widget.isSelected
        ? colors.primaryContainer.withValues(alpha: .14)
        : _isHovered
        ? colors.surfaceContainerHighest.withValues(alpha: .30)
        : colors.surface;

    final elevation = _isHovered
        ? KanbanCardTokens.cardElevationHover
        : KanbanCardTokens.cardElevationRest;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .30 : .08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
        child: InkWell(
          focusNode: widget.focusNode,
          onTap: widget.onTap,
          onSecondaryTapUp: widget.onSecondaryTapUp,
          borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: Padding(
            padding:
                widget.padding ?? KanbanCardTokens.contentPaddingComfortable,
            child: widget.child,
          ),
        ),
      ),
    );

    final keyboardEnabledCard = widget.onShowContextMenu == null
        ? card
        : Shortcuts(
            shortcuts: const <ShortcutActivator, Intent>{
              SingleActivator(LogicalKeyboardKey.f10, shift: true):
                  _ShowKanbanContextMenuIntent(),
              SingleActivator(LogicalKeyboardKey.contextMenu):
                  _ShowKanbanContextMenuIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                _ShowKanbanContextMenuIntent:
                    CallbackAction<_ShowKanbanContextMenuIntent>(
                      onInvoke: (_) {
                        widget.onShowContextMenu?.call();
                        return null;
                      },
                    ),
              },
              child: card,
            ),
          );

    final framedCard = _isFocused
        ? DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                KanbanCardTokens.cardRadius + 2.0,
              ),
              border: Border.all(color: colors.primary, width: 2.0),
            ),
            child: keyboardEnabledCard,
          )
        : keyboardEnabledCard;

    final result = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: framedCard,
    );

    if (widget.semanticsLabel case final label?) {
      return Semantics(button: true, label: label, child: result);
    }
    return result;
  }
}

class _ShowKanbanContextMenuIntent extends Intent {
  const _ShowKanbanContextMenuIntent();
}

/// Alias kompatybilności wstecznej dla KanbanCardFrame.
typedef KanbanDottedCardFrame = KanbanCardFrame;

/// Górny wiersz tożsamości karty (subtelny checkbox, kod 11 px, priorytet, menu "…").
class _CardIdentity extends StatefulWidget {
  const _CardIdentity({
    required this.task,
    required this.isSelected,
    required this.workspaceId,
    required this.projectId,
    required this.memberProfilesByCoreUserId,
  });

  final KanbanTaskCardResponse task;
  final bool isSelected;
  final String workspaceId;
  final String projectId;
  final Map<String, ProjectMemberProfile> memberProfilesByCoreUserId;

  @override
  State<_CardIdentity> createState() => _CardIdentityState();
}

class _CardIdentityState extends State<_CardIdentity> {
  var _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showCheckbox = widget.isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        children: [
          // Subtelny checkbox: widoczny przy selection lub hover, a w spoczynku
          // niewidoczny, lecz zajmujący dokładnie tę samą szerokość (18 px + 4 px gap),
          // by kod zadania i cała reszta nigdy nie skakały.
          SizedBox(
            width: 18,
            height: 18,
            child: Opacity(
              opacity: showCheckbox ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !showCheckbox,
                child: Semantics(
                  label: context.l10n.tasksSelectTask(widget.task.taskCode),
                  child: Checkbox(
                    value: widget.isSelected,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (_) => context
                        .read<TasksBoardCubit>()
                        .toggleTaskSelection(widget.task),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),

          // Kod zadania: 11 px / 16 px, w500, onSurfaceVariant (pomocniczy)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              widget.task.taskCode,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: KanbanCardTokens.taskCode(context),
            ),
          ),

          // Aktywny wskaźnik cykliczności (jeśli występuje)
          if (widget.task.recurrence case final recurrence?) ...[
            const SizedBox(width: 6),
            Icon(
              recurrence.isActive
                  ? Symbols.repeat_rounded
                  : Symbols.repeat_one_on_rounded,
              size: 13,
              color: recurrence.isSourceTask
                  ? context.colors.primary
                  : context.colors.onSurfaceVariant.withValues(alpha: .7),
            ),
          ],

          const Spacer(),

          // Prawa strona: semantyczny znacznik priorytetu (ikona flagi z tooltipem i etykietą)
          _PriorityIndicator(priority: widget.task.priority),
          const SizedBox(width: 4),

          // Menu akcji "..."
          Builder(
            builder: (buttonContext) => IconButton(
              tooltip: context.l10n.tasksListMoreOptionsTooltip,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints.tightFor(
                width: KanbanCardTokens.minTouchTarget,
                height: KanbanCardTokens.minTouchTarget,
              ),
              padding: EdgeInsets.zero,
              onPressed: () => unawaited(
                KanbanCardContextMenuHelper.show(
                  context: buttonContext,
                  task: widget.task,
                  workspaceId: widget.workspaceId,
                  projectId: widget.projectId,
                  memberProfilesByCoreUserId: widget.memberProfilesByCoreUserId,
                ),
              ),
              icon: const Icon(Symbols.more_horiz_rounded, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// Główny wiersz metadanych karty: termin i postęp po lewej, awatar po prawej.
class _CardPrimaryMeta extends StatelessWidget {
  const _CardPrimaryMeta({
    required this.task,
    required this.visibleCardFields,
    required this.detailed,
    required this.memberProfilesByCoreUserId,
    required this.hasSubtasksSection,
  });

  final KanbanTaskCardResponse task;
  final List<KanbanCardField> visibleCardFields;
  final bool detailed;
  final Map<String, ProjectMemberProfile> memberProfilesByCoreUserId;
  final bool hasSubtasksSection;

  bool shows(KanbanCardField field) => visibleCardFields.contains(field);

  @override
  Widget build(BuildContext context) {
    final showAssignee =
        shows(KanbanCardField.assignee) &&
        task.primaryAssigneeCoreUserId != null;
    final showDueDate = shows(KanbanCardField.dueDate) && task.dueAtUtc != null;
    final showChecklist =
        shows(KanbanCardField.checklist) && task.checklistTotal > 0;
    // Licznik podzadań jest pokazywany w meta TYLKO gdy sekcja podzadań nie jest renderowana na karcie
    final showSubtasksCounter =
        shows(KanbanCardField.subtasks) &&
        !hasSubtasksSection &&
        task.subtaskTotal > 0;

    return Row(
      children: [
        // Lewa strona meta: termin, postęp checklisty / podzadania
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

        // Prawa strona meta: awatar osoby wykonującej (24 px)
        if (showAssignee) ...[
          const SizedBox(width: 8),
          _CardAssigneeAvatar(
            coreUserId: task.primaryAssigneeCoreUserId!,
            profile:
                memberProfilesByCoreUserId[task.primaryAssigneeCoreUserId!],
            radius: KanbanCardTokens.parentAvatarRadius,
          ),
        ],
      ],
    );
  }
}

/// Szczegółowe metadane widoczne wyłącznie w trybie detailed (czas, blokady, załączniki, custom fields).
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
            color: _parseColor(label.color).withValues(alpha: .13),
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
    required this.coreUserId,
    required this.profile,
    required this.radius,
  });

  final String coreUserId;
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
        backgroundColor: _cardAvatarColor(coreUserId),
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

Color _cardAvatarColor(String id) {
  const palette = <Color>[
    Color(0xFF6C5CE7),
    Color(0xFF0984E3),
    Color(0xFF00A884),
    Color(0xFFE17055),
  ];
  return palette[id.hashCode.abs() % palette.length];
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

/// Semantyczny wskaźnik priorytetu zadania: flaga w kolorze priorytetu z etykietą semantyczną i tooltipem.
class _PriorityIndicator extends StatelessWidget {
  const _PriorityIndicator({
    required this.priority,
  });

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
        child: Icon(
          Symbols.flag_rounded,
          size: 14,
          color: color,
        ),
      ),
    );
  }
}
