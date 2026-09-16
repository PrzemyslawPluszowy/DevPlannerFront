import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_widget_support.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/users/cubit/bhp_dashboard_users_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_header_actions.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Definicja widgetu podglądu pracowników BHP.
class BhpDashboardUsersWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu podglądu pracowników BHP.
  const BhpDashboardUsersWidgetDefinition();

  @override
  String get typeId => 'bhp_dashboard_users';

  @override
  String get requiredPermission => ReadyPermissions.bhp;

  @override
  String name(BuildContext context) => context.l10n.dashboardBhpUsersName;

  @override
  String description(BuildContext context) =>
      context.l10n.dashboardBhpUsersDescription;

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardBhpUsersCategory;

  @override
  IconData get icon => Icons.badge_outlined;

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
      create: (context) => BhpDashboardUsersCubit(
        repository: context.read<BhpUsersRepository>(),
      ),
      child: _BhpDashboardUsersBody(size: size),
    );
  }
}

/// Zawartość widgetu podglądu pracowników BHP.
class _BhpDashboardUsersBody extends StatelessWidget {
  /// Tworzy zawartość widgetu podglądu pracowników BHP.
  const _BhpDashboardUsersBody({required this.size});

  /// Rozmiar widgetu.
  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    return _BhpDashboardUsersBodyStateful(size: size);
  }
}

/// Stanowy wrapper zawartości widgetu podglądu pracowników BHP.
class _BhpDashboardUsersBodyStateful extends StatefulWidget {
  /// Tworzy stanowy wrapper zawartości widgetu podglądu pracowników BHP.
  const _BhpDashboardUsersBodyStateful({required this.size});

  /// Rozmiar widgetu.
  final DashboardWidgetSize size;

  @override
  State<_BhpDashboardUsersBodyStateful> createState() =>
      _BhpDashboardUsersBodyStatefulState();
}

/// Stan zawartości widgetu podglądu pracowników BHP.
class _BhpDashboardUsersBodyStatefulState
    extends State<_BhpDashboardUsersBodyStateful> {
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
        () => context.read<BhpDashboardUsersCubit>().load(),
      );
    });

    _refreshActionRegistered = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpDashboardUsersCubit, BhpDashboardUsersState>(
      builder: (context, state) {
        return switch (state) {
          BhpDashboardUsersInitial() ||
          BhpDashboardUsersLoading() => const BhpDashboardSkeletonShimmer(),
          BhpDashboardUsersError(:final message) => AppEmptyState.error(
            title: context.l10n.dashboardBhpUsersErrorTitle,
            message: message,
            compact: true,
          ),
          BhpDashboardUsersSuccess(:final items) => _BhpDashboardUsersCard(
            items: items,
            isLarge: widget.size.height >= 6,
          ),
        };
      },
    );
  }
}

/// Karta podglądu pracowników BHP.
class _BhpDashboardUsersCard extends StatelessWidget {
  /// Tworzy kartę podglądu pracowników BHP.
  const _BhpDashboardUsersCard({
    required this.items,
    required this.isLarge,
  });

  /// Lista pracowników.
  final List<GetBhpUserListItem> items;

  /// Czy widget korzysta z większego wariantu.
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        BhpDashboardSectionHeader(
          title: context.l10n.dashboardBhpUsersSectionTitle,
          onTap: () => context.router.navigatePath(AppRoutePaths.bhpUsers),
          badge: AppStatusBadge(
            label: '${items.length}',
            tone: AppStatusBadgeTone.info,
            icon: Icons.people_outline_rounded,
          ),
        ),
        Gaps.h12,
        Expanded(
          child: items.isEmpty
              ? AppEmptyState.noData(
                  title: context.l10n.dashboardBhpUsersEmptyTitle,
                  message: context.l10n.dashboardBhpUsersEmptyMessage,
                  compact: true,
                )
              : BhpDashboardSeparatedListView(
                  thumbVisibility: isLarge,
                  itemCount: items.length,
                  separatorBuilder: (context, index) => Gaps.h8,
                  itemBuilder: (context, index) {
                    return _PreviewRow(
                      title: items[index].fullName,
                      subtitle:
                          items[index].stanowiskoNazwa ??
                          context.l10n.dashboardBhpUsersNoPositionLabel,
                      badgeLabel: _userDeadlineLabel(context, items[index]),
                      badgeTone: _userDeadlineTone(items[index]),
                      badgeIcon: _userDeadlineIcon(items[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Pojedynczy wiersz podglądu.
class _PreviewRow extends StatelessWidget {
  /// Tworzy wiersz podglądu.
  const _PreviewRow({
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.badgeTone,
    required this.badgeIcon,
  });

  final String title;
  final String subtitle;
  final String badgeLabel;
  final AppStatusBadgeTone badgeTone;
  final IconData badgeIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p10),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest.withValues(alpha: .48),
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: .45),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                AppText(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall?.copyWith(
                    fontWeight: .w700,
                  ),
                ),
                Gaps.h4,
                AppText(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Gaps.w8,
          AppStatusBadge(
            label: badgeLabel,
            tone: badgeTone,
            icon: badgeIcon,
          ),
        ],
      ),
    );
  }
}

String _userDeadlineLabel(BuildContext context, GetBhpUserListItem row) {
  final intl = context.l10n;
  final daysOverdue = row.daysOverdue;
  if (daysOverdue != null && daysOverdue > 0) {
    return intl.dashboardBhpUsersDeadlineOverdueLabel(daysOverdue);
  }
  final daysUntilDue = row.daysUntilDue;
  if (daysUntilDue != null) {
    if (daysUntilDue == 0) {
      return intl.dashboardBhpUsersDeadlineTodayLabel;
    }
    if (daysUntilDue > 0) {
      return intl.dashboardBhpUsersDeadlineUpcomingLabel(daysUntilDue);
    }
  }
  if (row.overdueCount > 0) {
    return intl.dashboardBhpUsersDeadlineOverdueCountLabel(row.overdueCount);
  }
  if (row.upcomingCount > 0) {
    return intl.dashboardBhpUsersDeadlineUpcomingCountLabel(
      row.upcomingCount,
    );
  }
  return intl.dashboardBhpUsersDeadlineOkLabel;
}

AppStatusBadgeTone _userDeadlineTone(GetBhpUserListItem row) {
  if ((row.daysOverdue ?? 0) > 0 || row.overdueCount > 0) {
    return AppStatusBadgeTone.danger;
  }
  if ((row.daysUntilDue ?? 999) <= 30 || row.upcomingCount > 0) {
    return AppStatusBadgeTone.warning;
  }
  return AppStatusBadgeTone.success;
}

IconData _userDeadlineIcon(GetBhpUserListItem row) {
  if ((row.daysOverdue ?? 0) > 0 || row.overdueCount > 0) {
    return Icons.warning_amber_rounded;
  }
  return Icons.schedule_rounded;
}
