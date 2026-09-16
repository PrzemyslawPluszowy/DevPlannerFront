part of '../bhp_dashboard_page.dart';

/// Kolumna alertów jednego typu.
class _BhpAlertsLane extends StatelessWidget {
  /// Tworzy kolumnę alertów jednego typu.
  const _BhpAlertsLane({
    required this.title,
    required this.subtitle,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.rows,
    required this.tone,
    this.groupByUser = false,
  });

  /// Tytuł sekcji.
  final String title;

  /// Podtytuł sekcji.
  final String subtitle;

  /// Tytuł pustego stanu.
  final String emptyTitle;

  /// Wiadomość pustego stanu.
  final String emptyMessage;

  /// Rekordy alertów.
  final List<GetBhpIssueAlertItem> rows;

  /// Ton sekcji.
  final AppStatusBadgeTone tone;

  /// Czy grupować alerty w kafelki pracowników.
  final bool groupByUser;

  @override
  Widget build(BuildContext context) {
    final visibleRows = rows;
    final groups = groupByUser ? _groupAlertsByUser(visibleRows) : null;
    final counterLabel = groups != null
        ? '${groups.length} osób / ${visibleRows.length} pozycji'
        : '${visibleRows.length}';

    return AppSectionCard(
      title: title,
      subtitle: subtitle,
      trailing: AppStatusBadge(label: counterLabel, tone: tone),
      child: visibleRows.isEmpty
          ? AppEmptyState.noData(
              title: emptyTitle,
              message: emptyMessage,
              compact: true,
            )
          : Column(
              children: [
                if (groups case final value?) ...[
                  for (var index = 0; index < value.length; index++) ...[
                    _BhpAlertCard(group: value[index], tone: tone),
                    if (index < value.length - 1) Gaps.h12,
                  ],
                ] else ...[
                  for (var index = 0; index < visibleRows.length; index++) ...[
                    _BhpAlertCard(
                      group: _BhpAlertGroup.single(visibleRows[index]),
                      tone: tone,
                    ),
                    if (index < visibleRows.length - 1) Gaps.h12,
                  ],
                ],
              ],
            ),
    );
  }
}

/// Karta pojedynczego alertu dashboardu.
class _BhpAlertCard extends StatelessWidget {
  /// Tworzy kartę pojedynczego alertu dashboardu.
  const _BhpAlertCard({required this.group, required this.tone});

  /// Grupa alertów jednego pracownika.
  final _BhpAlertGroup group;

  /// Ton wizualny alertu.
  final AppStatusBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primaryRow = group.rows.first;
    final urgentRow = group.rows.reduce((left, right) {
      return left.daysToDue <= right.daysToDue ? left : right;
    });
    final borderColor = switch (tone) {
      AppStatusBadgeTone.danger => colors.error.withValues(alpha: .18),
      AppStatusBadgeTone.warning => colors.tertiary.withValues(alpha: .2),
      _ => colors.outlineVariant.withValues(alpha: .5),
    };
    final backgroundColor = switch (tone) {
      AppStatusBadgeTone.danger => colors.errorContainer.withValues(alpha: .32),
      AppStatusBadgeTone.warning => colors.tertiaryContainer.withValues(
        alpha: .42,
      ),
      _ => colors.surfaceContainerLow,
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openUserIssues(context, primaryRow),
        borderRadius: const BorderRadius.all(.circular(Sizes.p18)),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(.circular(Sizes.p18)),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const .all(Sizes.p16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            primaryRow.formattedUserFullName,
                            style: context.text.titleSmall?.copyWith(
                              fontWeight: .w700,
                            ),
                          ),
                          if (primaryRow.stanowiskoNazwa
                              case final position?) ...[
                            Gaps.h4,
                            Text(
                              position,
                              style: context.text.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Gaps.w12,
                    AppStatusBadge(
                      label: group.rows.length > 1
                          ? '${group.rows.length} pozycje'
                          : _buildDueLabel(urgentRow.daysToDue),
                      tone: tone,
                      icon: tone == AppStatusBadgeTone.danger
                          ? Icons.warning_amber_rounded
                          : Icons.schedule_rounded,
                    ),
                  ],
                ),
                Gaps.h12,
                for (var index = 0; index < group.rows.length; index++) ...[
                  _BhpAlertEquipmentItem(row: group.rows[index]),
                  if (index < group.rows.length - 1) Gaps.h8,
                ],
                Gaps.h8,
                const AppStatusBadge(
                  label: 'Otwórz pracownika',
                  tone: .info,
                  icon: Icons.open_in_new_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pozycja wyposażenia widoczna w kafelku alertu.
class _BhpAlertEquipmentItem extends StatelessWidget {
  /// Tworzy pozycję wyposażenia widoczną w kafelku alertu.
  const _BhpAlertEquipmentItem({required this.row});

  /// Rekord alertu dla pozycji wyposażenia.
  final GetBhpIssueAlertItem row;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          '${_buildEquipmentLabel(row)} (${_buildDueLabel(row.daysToDue)})',
          style: context.text.bodyMedium?.copyWith(fontWeight: .w600),
        ),
        Gaps.h8,
        Wrap(
          spacing: Sizes.p8,
          runSpacing: Sizes.p8,
          children: [
            AppStatusBadge(
              label:
                  '${context.l10n.bhpTableDueDate}: ${row.dueDate.toAppDate(placeholder: row.dueDate)}',
              icon: Icons.event_outlined,
            ),
            AppStatusBadge(
              label:
                  'Przydział: ${row.dataPrzydzialu.toAppDate(placeholder: row.dataPrzydzialu)}',
              icon: Icons.history_toggle_off_rounded,
            ),
          ],
        ),
      ],
    );
  }
}

/// Grupa alertów przypisana do jednego pracownika.
class _BhpAlertGroup {
  /// Tworzy grupę alertów przypisaną do jednego pracownika.
  const _BhpAlertGroup({required this.userId, required this.rows});

  /// Tworzy grupę z pojedynczego rekordu.
  factory _BhpAlertGroup.single(GetBhpIssueAlertItem row) {
    return _BhpAlertGroup(userId: row.userId, rows: [row]);
  }

  /// Id pracownika.
  final int userId;

  /// Alerty pracownika.
  final List<GetBhpIssueAlertItem> rows;
}

Future<void> _openUserIssues(
  BuildContext context,
  GetBhpIssueAlertItem row,
) {
  return showBhpUserIssuesModal(
    context,
    user: GetBhpUserListItem(
      id: row.userId,
      aktywny: true,
      isArchived: false,
      imie: extractBhpEmployeeFirstName(row.userFullName),
      nazwisko: extractBhpEmployeeLastName(row.userFullName),
      stanowiskoId: row.stanowiskoId,
      stanowiskoNazwa: row.stanowiskoNazwa,
    ),
  );
}

List<_BhpAlertGroup> _groupAlertsByUser(List<GetBhpIssueAlertItem> rows) {
  final groupsByUser = <int, List<GetBhpIssueAlertItem>>{};

  for (final row in rows) {
    (groupsByUser[row.userId] ??= []).add(row);
  }

  return [
    for (final entry in groupsByUser.entries)
      _BhpAlertGroup(userId: entry.key, rows: entry.value),
  ];
}

String _buildEquipmentLabel(GetBhpIssueAlertItem row) {
  return [
    row.kartaWyposazeniaSymbol,
    row.kartaWyposazeniaNazwa,
  ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' • ');
}

String _buildDueLabel(int daysToDue) {
  if (daysToDue < 0) {
    return '${daysToDue.abs()} dni po terminie';
  }
  if (daysToDue == 0) {
    return 'termin dzisiaj';
  }
  return 'za $daysToDue dni';
}

int _sortAlertsByUrgency(
  GetBhpIssueAlertItem left,
  GetBhpIssueAlertItem right,
) {
  return left.daysToDue.compareTo(right.daysToDue);
}
