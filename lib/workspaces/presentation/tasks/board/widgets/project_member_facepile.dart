part of '../tasks_board_page.dart';

/// Zwarty komponent prezentacji składu projektu (ProjectMemberFacepile).
///
/// Zgodnie ze specyfikacją naprawy UI (Etap D i sekcja 3.3):
/// - Źródłem są wszyscy członkowie projektu (`memberProfilesByUserId`).
/// - Prezentuje maksymalnie 3 awatary (24 px) + chip `+N` (24 px).
/// - Porządek: aktualny użytkownik → osoby online → pozostali alfabetycznie.
/// - Zielona kropka 6 px z obrysem powierzchni (2 px) dla osób aktualnie obecnych w realtime.
/// - Dostępny hit-target i Semantics z liczbą członków i liczbą online.
/// - Kliknięcie otwiera modal członków projektu (`ProjectUserHubDialogs.show`).
class ProjectMemberFacepile extends StatelessWidget {
  const ProjectMemberFacepile({
    required this.memberProfilesByUserId,
    required this.presence,
    required this.currentUserId,
    required this.onTap,
    this.maxVisible = 3,
    super.key,
  });

  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final List<TaskProjectPresenceUser> presence;
  final String? currentUserId;
  final VoidCallback onTap;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final onlineUserIds = presence.map((p) => p.userId).toSet();
    final allMembers = memberProfilesByUserId.values.toList();

    // Sortowanie: 1) aktualny użytkownik, 2) online, 3) alfabetycznie
    allMembers.sort((a, b) {
      if (a.userId == currentUserId) return -1;
      if (b.userId == currentUserId) return 1;

      final aOnline = onlineUserIds.contains(a.userId);
      final bOnline = onlineUserIds.contains(b.userId);
      if (aOnline != bOnline) return aOnline ? -1 : 1;

      final nameA = a.displayName ?? '';
      final nameB = b.displayName ?? '';
      return nameA.toLowerCase().compareTo(nameB.toLowerCase());
    });

    final totalCount = allMembers.length;
    final onlineCount = allMembers
        .where((m) => onlineUserIds.contains(m.userId))
        .length;

    if (totalCount == 0) {
      return Tooltip(
        message: l10n.projectUserHubTitle,
        child: Semantics(
          button: true,
          label: l10n.projectUserHubTitle,
          child: InkWell(
            onTap: onTap,
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

    final visibleMembers = allMembers.take(maxVisible).toList();
    final overflowCount = totalCount - visibleMembers.length;

    final semanticsLabel =
        '${l10n.projectUserHubTitle}: $totalCount (${l10n.tasksPresenceCount(onlineCount)})';

    return Tooltip(
      message: semanticsLabel,
      child: Semantics(
        button: true,
        label: semanticsLabel,
        child: InkWell(
          key: const ValueKey('project_member_facepile'),
          onTap: onTap,
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
                        isOnline: onlineUserIds.contains(
                          visibleMembers[i].userId,
                        ),
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
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final displayName = member.displayName?.trim();
    final name = displayName?.isNotEmpty == true
        ? displayName!
        : l10n.tasksPresenceAnonymousUser;
    final statusText = isOnline
        ? l10n.tasksPresenceOnline
        : l10n.tasksPresenceOffline;
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
          if (isOnline)
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
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
