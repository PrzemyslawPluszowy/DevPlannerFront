import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/alerts/cubit/bhp_dashboard_alerts_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/alerts/cubit/bhp_dashboard_upcoming_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_widget_support.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_header_actions.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Definicja widgetu alertów BHP nadchodzących.
class BhpDashboardUpcomingWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu alertów BHP nadchodzących.
  const BhpDashboardUpcomingWidgetDefinition();

  @override
  String get typeId => 'bhp_dashboard_upcoming';

  @override
  String get requiredPermission => ReadyPermissions.bhp;

  @override
  String name(BuildContext context) => context.l10n.dashboardBhpUpcomingName;

  @override
  String description(BuildContext context) =>
      context.l10n.dashboardBhpUpcomingDescription;

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardBhpUpcomingCategory;

  @override
  IconData get icon => Icons.schedule_rounded;

  @override
  List<DashboardWidgetSize> get supportedSizes => const [
    DashboardWidgetSize(8, 8),
    DashboardWidgetSize(8, 12),
    DashboardWidgetSize(8, 14),
    DashboardWidgetSize(8, 16),
  ];

  @override
  Widget build(BuildContext context, DashboardWidgetSize size) {
    return BlocProvider(
      create: (context) => BhpDashboardUpcomingCubit(
        repository: context.read<BhpDashboardRepository>(),
      ),
      child: _BhpDashboardUpcomingBody(size: size),
    );
  }
}

/// Zawartość widgetu alertów nadchodzących.
class _BhpDashboardUpcomingBody extends StatefulWidget {
  /// Tworzy zawartość widgetu alertów nadchodzących.
  const _BhpDashboardUpcomingBody({required this.size});

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize size;

  @override
  State<_BhpDashboardUpcomingBody> createState() =>
      _BhpDashboardUpcomingBodyState();
}

/// Stan zawartości widgetu alertów nadchodzących.
class _BhpDashboardUpcomingBodyState extends State<_BhpDashboardUpcomingBody> {
  bool _refreshActionRegistered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_refreshActionRegistered) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final controller = DashboardWidgetHeaderActionScope.maybeOf(context);
      if (controller == null) {
        return;
      }

      controller.setRefreshAction(
        () => context.read<BhpDashboardUpcomingCubit>().load(),
      );
    });

    _refreshActionRegistered = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpDashboardUpcomingCubit, BhpDashboardAlertsState>(
      builder: (context, state) {
        return switch (state) {
          BhpDashboardAlertsInitial() ||
          BhpDashboardAlertsLoading() => const BhpDashboardLoadingView(),
          BhpDashboardAlertsError(:final message) => BhpDashboardAlertsFallback(
            title: context.l10n.dashboardBhpUpcomingErrorTitle,
            message: message,
            actionLabel: context.l10n.dashboardBhpUpcomingRefreshLabel,
            onActionPressed: () =>
                context.read<BhpDashboardUpcomingCubit>().load(),
          ),
          BhpDashboardAlertsSuccess(:final rows) => _BhpDashboardAlertsCard(
            title: context.l10n.dashboardBhpUpcomingSectionTitle,
            rows: rows,
            tone: AppStatusBadgeTone.warning,
            emptyTitle: context.l10n.dashboardBhpUpcomingEmptyTitle,
            emptyMessage: context.l10n.dashboardBhpUpcomingEmptyMessage,
            isLarge: widget.size.height >= 6,
          ),
        };
      },
    );
  }
}

/// Karta z listą alertów BHP.
class _BhpDashboardAlertsCard extends StatelessWidget {
  /// Tworzy kartę z listą alertów BHP.
  const _BhpDashboardAlertsCard({
    required this.title,
    required this.rows,
    required this.tone,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.isLarge,
  });

  /// Tytuł sekcji.
  final String title;

  /// Rekordy alertów.
  final List<GetBhpIssueAlertItem> rows;

  /// Ton sekcji.
  final AppStatusBadgeTone tone;

  /// Tytuł pustego stanu.
  final String emptyTitle;

  /// Treść pustego stanu.
  final String emptyMessage;

  /// Czy widget korzysta z wyższego wariantu.
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final groups = _groupUpcomingAlertsByUser(rows);
    final counterLabel = '${groups.length} os. / ${rows.length} poz.';

    return Column(
      crossAxisAlignment: .start,
      children: [
        BhpDashboardSectionHeader(
          title: title,
          onTap: () => openBhpDashboardDetails(context),
          badge: AppStatusBadge(
            label: counterLabel,
            tone: tone,
          ),
        ),
        Gaps.h12,
        Expanded(
          child: rows.isEmpty
              ? AppEmptyState.noData(
                  title: emptyTitle,
                  message: emptyMessage,
                  compact: true,
                )
              : BhpDashboardSeparatedListView(
                  thumbVisibility: isLarge,
                  itemCount: groups.length,
                  separatorBuilder: (context, index) => Gaps.h8,
                  itemBuilder: (context, index) {
                    return _BhpDashboardUpcomingGroupTile(
                      group: groups[index],
                      tone: tone,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Kompaktowy kafelek nadchodzących alertów pogrupowanych po pracowniku.
class _BhpDashboardUpcomingGroupTile extends StatelessWidget {
  /// Tworzy kompaktowy kafelek nadchodzących alertów.
  const _BhpDashboardUpcomingGroupTile({
    required this.group,
    required this.tone,
  });

  /// Grupa alertów jednego pracownika.
  final _BhpDashboardUpcomingGroup group;

  /// Ton wizualny.
  final AppStatusBadgeTone tone;

  static const int _visibleItemsLimit = 2;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primaryRow = group.rows.first;
    final urgentRow = group.rows.reduce((left, right) {
      return left.daysToDue <= right.daysToDue ? left : right;
    });
    final visibleRows = group.rows
        .take(_visibleItemsLimit)
        .toList(
          growable: false,
        );
    final hiddenRowsCount = group.rows.length - visibleRows.length;
    final borderColor = colors.tertiary.withValues(alpha: .16);
    final backgroundColor = colors.tertiaryContainer.withValues(alpha: .26);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => openBhpDashboardDetails(context),
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const .symmetric(
              horizontal: Sizes.p12,
              vertical: Sizes.p10,
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        primaryRow.formattedUserFullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.titleSmall?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                    ),
                    Gaps.w8,
                    AppStatusBadge(
                      label: group.rows.length > 1
                          ? '${group.rows.length} poz.'
                          : buildBhpDashboardDueLabel(
                              context,
                              urgentRow.daysToDue,
                            ),
                      tone: tone,
                      icon: Icons.schedule_rounded,
                    ),
                  ],
                ),
                Gaps.h8,
                for (final row in visibleRows) ...[
                  AppText(
                    '${buildBhpDashboardEquipmentLabel(row)} (${buildBhpDashboardDueLabel(context, row.daysToDue)})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: .w600,
                    ),
                  ),
                ],
                if (hiddenRowsCount > 0) ...[
                  Gaps.h4,
                  AppText(
                    '+$hiddenRowsCount poz.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: .w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grupa nadchodzących alertów jednego pracownika.
class _BhpDashboardUpcomingGroup {
  /// Tworzy grupę nadchodzących alertów jednego pracownika.
  const _BhpDashboardUpcomingGroup({required this.userId, required this.rows});

  /// Id pracownika.
  final int userId;

  /// Alerty pracownika.
  final List<GetBhpIssueAlertItem> rows;
}

List<_BhpDashboardUpcomingGroup> _groupUpcomingAlertsByUser(
  List<GetBhpIssueAlertItem> rows,
) {
  final groupsByUser = <int, List<GetBhpIssueAlertItem>>{};

  for (final row in rows) {
    (groupsByUser[row.userId] ??= []).add(row);
  }

  return [
    for (final entry in groupsByUser.entries)
      _BhpDashboardUpcomingGroup(userId: entry.key, rows: entry.value),
  ];
}
