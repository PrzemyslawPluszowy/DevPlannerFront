import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_widget_support.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/positions/cubit/bhp_dashboard_positions_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_header_actions.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Definicja widgetu podglądu stanowisk BHP.
class BhpDashboardPositionsWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu podglądu stanowisk BHP.
  const BhpDashboardPositionsWidgetDefinition();

  @override
  String get typeId => 'bhp_dashboard_positions';

  @override
  String get requiredPermission => ReadyPermissions.bhp;

  @override
  String name(BuildContext context) => context.l10n.dashboardBhpPositionsName;

  @override
  String description(BuildContext context) =>
      context.l10n.dashboardBhpPositionsDescription;

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardBhpPositionsCategory;

  @override
  IconData get icon => Icons.work_outline_rounded;

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
      create: (context) => BhpDashboardPositionsCubit(
        repository: context.read<BhpPositionsRepository>(),
      ),
      child: _BhpDashboardPositionsBody(size: size),
    );
  }
}

/// Zawartość widgetu podglądu stanowisk BHP.
class _BhpDashboardPositionsBody extends StatelessWidget {
  /// Tworzy zawartość widgetu podglądu stanowisk BHP.
  const _BhpDashboardPositionsBody({required this.size});

  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    return _BhpDashboardPositionsBodyStateful(size: size);
  }
}

/// Stanowy wrapper zawartości widgetu podglądu stanowisk BHP.
class _BhpDashboardPositionsBodyStateful extends StatefulWidget {
  /// Tworzy stanowy wrapper zawartości widgetu podglądu stanowisk BHP.
  const _BhpDashboardPositionsBodyStateful({required this.size});

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize size;

  @override
  State<_BhpDashboardPositionsBodyStateful> createState() =>
      _BhpDashboardPositionsBodyStatefulState();
}

/// Stan zawartości widgetu podglądu stanowisk BHP.
class _BhpDashboardPositionsBodyStatefulState
    extends State<_BhpDashboardPositionsBodyStateful> {
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
        () => context.read<BhpDashboardPositionsCubit>().load(),
      );
    });

    _refreshActionRegistered = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpDashboardPositionsCubit, BhpDashboardPositionsState>(
      builder: (context, state) {
        return switch (state) {
          BhpDashboardPositionsInitial() ||
          BhpDashboardPositionsLoading() => const BhpDashboardSkeletonShimmer(),
          BhpDashboardPositionsError(:final message) => AppEmptyState.error(
            title: context.l10n.dashboardBhpPositionsErrorTitle,
            message: message,
            compact: true,
          ),
          BhpDashboardPositionsSuccess(:final items) =>
            _BhpDashboardPositionsCard(
              items: items,
              isLarge: widget.size.height >= 6,
            ),
        };
      },
    );
  }
}

/// Karta podglądu stanowisk BHP.
class _BhpDashboardPositionsCard extends StatelessWidget {
  /// Tworzy kartę podglądu stanowisk BHP.
  const _BhpDashboardPositionsCard({
    required this.items,
    required this.isLarge,
  });

  final List<GetBhpPositionListItem> items;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        BhpDashboardSectionHeader(
          title: context.l10n.dashboardBhpPositionsSectionTitle,
          onTap: () => context.router.navigatePath(AppRoutePaths.bhpPositions),
          badge: AppStatusBadge(
            label: '${items.length}',
            tone: AppStatusBadgeTone.info,
            icon: Icons.work_outline_rounded,
          ),
        ),
        Gaps.h12,
        Expanded(
          child: items.isEmpty
              ? AppEmptyState.noData(
                  title: context.l10n.dashboardBhpPositionsEmptyTitle,
                  message: context.l10n.dashboardBhpPositionsEmptyMessage,
                  compact: true,
                )
              : BhpDashboardSeparatedListView(
                  thumbVisibility: isLarge,
                  itemCount: items.length,
                  separatorBuilder: (context, index) => Gaps.h8,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _PreviewRow(
                      title: item.nazwa,
                      subtitle: item.uwagi?.isNotEmpty == true
                          ? item.uwagi!
                          : context.l10n.dashboardBhpPositionsNoNotesLabel,
                      badgeLabel: item.aktywny
                          ? context.l10n.dashboardBhpPositionsActiveLabel
                          : context.l10n.dashboardBhpPositionsInactiveLabel,
                      badgeTone: item.aktywny
                          ? AppStatusBadgeTone.success
                          : AppStatusBadgeTone.warning,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Pojedynczy wiersz podglądu stanowiska.
class _PreviewRow extends StatelessWidget {
  /// Tworzy wiersz podglądu.
  const _PreviewRow({
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.badgeTone,
  });

  final String title;
  final String subtitle;
  final String badgeLabel;
  final AppStatusBadgeTone badgeTone;

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
          ),
        ],
      ),
    );
  }
}
