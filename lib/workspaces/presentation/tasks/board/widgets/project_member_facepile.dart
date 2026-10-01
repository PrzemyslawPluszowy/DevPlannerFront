part of '../tasks_board_page.dart';

/// Zwarty komponent prezentacji składu projektu (ProjectMemberFacepile).
///
/// Zgodnie ze specyfikacją naprawy UI (Etap D i sekcja 3.3):
/// - Źródłem są wszyscy członkowie projektu (`memberProfilesByUserId`).
/// - Prezentuje maksymalnie 3 awatary (24 px) + chip `+N` (24 px).
/// - Porządek: aktualny użytkownik → osoby online → pozostali alfabetycznie.
/// - Obecność całej aplikacji z autoryzowanych profili; subskrypcja projektu nie oznacza online.
/// - Zielony znacznik online, neutralny offline; nieaktualne dane mają stan nieznany.
/// - Dostępny hit-target i Semantics z liczbą członków i liczbą online.
/// - Kliknięcie otwiera prawy panel osób i ich obecności.
class ProjectMemberFacepile extends StatefulWidget {
  const ProjectMemberFacepile({
    required this.memberProfilesByUserId,
    required this.presence,
    required this.currentUserId,
    required this.onTap,
    this.maxVisible = 3,
    this.presenceIsFresh = false,
    super.key,
  });

  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final List<TaskProjectPresenceUser> presence;
  final String? currentUserId;
  final VoidCallback onTap;
  final int maxVisible;
  final bool presenceIsFresh;

  @override
  State<ProjectMemberFacepile> createState() => _ProjectMemberFacepileState();
}

class _ProjectMemberFacepileState extends State<ProjectMemberFacepile> {
  List<ProjectMemberProfile> _members = const [];
  Set<String> _onlineUserIds = const {};
  int _onlineCount = 0;

  @override
  void initState() {
    super.initState();
    _prepareMembers();
  }

  @override
  void didUpdateWidget(ProjectMemberFacepile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(
          oldWidget.memberProfilesByUserId,
          widget.memberProfilesByUserId,
        ) ||
        oldWidget.currentUserId != widget.currentUserId ||
        oldWidget.presenceIsFresh != widget.presenceIsFresh) {
      _prepareMembers();
    }
  }

  void _prepareMembers() {
    _onlineUserIds = widget.presenceIsFresh
        ? widget.memberProfilesByUserId.values
              .where((member) => member.isOnline == true)
              .map((member) => member.userId)
              .toSet()
        : const {};
    _members = widget.memberProfilesByUserId.values.toList()
      ..sort(_compareMembers);
    _onlineCount = _onlineUserIds.length;
  }

  int _compareMembers(ProjectMemberProfile a, ProjectMemberProfile b) {
    if (a.userId == b.userId) return 0;
    if (a.userId == widget.currentUserId) return -1;
    if (b.userId == widget.currentUserId) return 1;
    final aOnline = _onlineUserIds.contains(a.userId);
    final bOnline = _onlineUserIds.contains(b.userId);
    if (aOnline != bOnline) return aOnline ? -1 : 1;
    return (a.displayName ?? '').toLowerCase().compareTo(
      (b.displayName ?? '').toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final totalCount = _members.length;
    final onlineCount = _onlineCount;

    if (totalCount == 0) {
      return Tooltip(
        message: l10n.projectUserHubTitle,
        child: Semantics(
          button: true,
          label: l10n.projectUserHubTitle,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: .circular(Sizes.p8),
            child: Container(
              width: 32,
              height: 32,
              alignment: .center,
              decoration: BoxDecoration(
                borderRadius: .circular(Sizes.p8),
                border: .all(
                  color: colors.outlineVariant.withValues(alpha: .4),
                ),
              ),
              child: Icon(
                Symbols.group_rounded,
                size: 16,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    final visibleMembers = _members.take(widget.maxVisible).toList();
    final overflowCount = totalCount - visibleMembers.length;

    final hasKnownPresence =
        widget.presenceIsFresh &&
        _members.every((member) => member.isOnline != null);
    final presenceLabel = hasKnownPresence
        ? l10n.tasksPresenceCount(onlineCount)
        : l10n.tasksRealtimeConnecting;
    final semanticsLabel =
        '${l10n.projectUserHubTitle}: $totalCount ($presenceLabel)';

    return Tooltip(
      message: semanticsLabel,
      child: Semantics(
        button: true,
        label: semanticsLabel,
        child: InkWell(
          key: const ValueKey('project_member_facepile'),
          onTap: widget.onTap,
          borderRadius: .circular(Sizes.p12),
          hoverColor: colors.surfaceContainerHighest.withValues(alpha: .4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            child: Padding(
              padding: const .symmetric(horizontal: 4, vertical: 4),
              child: Center(
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    for (var i = 0; i < visibleMembers.length; i++) ...[
                      if (i > 0) const SizedBox(width: 4),
                      _FacepileAvatar(
                        member: visibleMembers[i],
                        isOnline: widget.presenceIsFresh
                            ? visibleMembers[i].isOnline
                            : null,
                      ),
                    ],
                    if (overflowCount > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          shape: .circle,
                          border: .all(
                            color: colors.surface,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '+$overflowCount',
                            style: context.tasksTheme.metaText.copyWith(
                              height: 1,
                              fontWeight: FontWeight.w700,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FacepileAvatar extends StatelessWidget {
  const _FacepileAvatar({
    required this.member,
    required this.isOnline,
  });

  final ProjectMemberProfile member;
  final bool? isOnline;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final displayName = member.displayName?.trim();
    final name = displayName?.isNotEmpty == true
        ? displayName!
        : l10n.tasksPresenceAnonymousUser;
    final statusText = switch (isOnline) {
      true => l10n.tasksPresenceOnline,
      false => l10n.tasksPresenceOffline,
      null => l10n.tasksRealtimeConnecting,
    };
    final tooltipText = '$name • $statusText';
    final avatarUrl = member.avatarUrl?.trim();

    return Tooltip(
      message: tooltipText,
      child: Stack(
        clipBehavior: .none,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: .circle,
              border: .all(
                color: colors.surface,
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              radius: 11,
              foregroundImage: avatarUrl?.isNotEmpty == true
                  ? NetworkImage(avatarUrl!)
                  : null,
              backgroundColor: _facepileColor(member.userId),
              child: avatarUrl?.isNotEmpty == true
                  ? null
                  : Text(
                      name.characters.first.toUpperCase(),
                      // Inicjał musi mieć kolor tokenu, a nie domyślny kolor
                      // tekstu, żeby był czytelny na kolorze awatara.
                      style: context.tasksTheme.metaText.copyWith(
                        height: 1,
                        fontWeight: FontWeight.w700,
                        color: context.tasksTheme.onAccent,
                      ),
                    ),
            ),
          ),
          if (isOnline != null)
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isOnline == true
                      ? context.feedback.successForeground
                      : colors.onSurfaceVariant,
                  shape: .circle,
                  border: .all(
                    color: colors.surface,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static Color _facepileColor(String id) {
    const palette = <Color>[
      Color(0xFF6C5CE7),
      Color(0xFF0984E3),
      Color(0xFF00A884),
      Color(0xFFE17055),
    ];
    return palette[id.hashCode.abs() % palette.length];
  }
}
