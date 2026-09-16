import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_widget_support.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/equipment/cubit/bhp_dashboard_equipment_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_header_actions.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Definicja widgetu podglądu wyposażenia BHP.
class BhpDashboardEquipmentWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu podglądu wyposażenia BHP.
  const BhpDashboardEquipmentWidgetDefinition();

  @override
  String get typeId => 'bhp_dashboard_equipment';

  @override
  String get requiredPermission => ReadyPermissions.bhp;

  @override
  String name(BuildContext context) => context.l10n.dashboardBhpEquipmentName;

  @override
  String description(BuildContext context) =>
      context.l10n.dashboardBhpEquipmentDescription;

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardBhpEquipmentCategory;

  @override
  IconData get icon => Icons.inventory_2_outlined;

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
      create: (context) => BhpDashboardEquipmentCubit(
        repository: context.read<BhpEquipmentRepository>(),
      ),
      child: _BhpDashboardEquipmentBody(size: size),
    );
  }
}

/// Zawartość widgetu podglądu wyposażenia BHP.
class _BhpDashboardEquipmentBody extends StatelessWidget {
  /// Tworzy zawartość widgetu podglądu wyposażenia BHP.
  const _BhpDashboardEquipmentBody({required this.size});

  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    return _BhpDashboardEquipmentBodyStateful(size: size);
  }
}

/// Stanowy wrapper zawartości widgetu podglądu wyposażenia BHP.
class _BhpDashboardEquipmentBodyStateful extends StatefulWidget {
  /// Tworzy stanowy wrapper zawartości widgetu podglądu wyposażenia BHP.
  const _BhpDashboardEquipmentBodyStateful({required this.size});

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize size;

  @override
  State<_BhpDashboardEquipmentBodyStateful> createState() =>
      _BhpDashboardEquipmentBodyStatefulState();
}

/// Stan zawartości widgetu podglądu wyposażenia BHP.
class _BhpDashboardEquipmentBodyStatefulState
    extends State<_BhpDashboardEquipmentBodyStateful> {
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
        () => context.read<BhpDashboardEquipmentCubit>().load(),
      );
    });

    _refreshActionRegistered = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpDashboardEquipmentCubit, BhpDashboardEquipmentState>(
      builder: (context, state) {
        return switch (state) {
          BhpDashboardEquipmentInitial() ||
          BhpDashboardEquipmentLoading() => const BhpDashboardSkeletonShimmer(),
          BhpDashboardEquipmentError(:final message) => AppEmptyState.error(
            title: context.l10n.dashboardBhpEquipmentErrorTitle,
            message: message,
            compact: true,
          ),
          BhpDashboardEquipmentSuccess(:final items) =>
            _BhpDashboardEquipmentCard(
              items: items,
              isLarge: widget.size.height >= 6,
            ),
        };
      },
    );
  }
}

/// Karta podglądu wyposażenia BHP.
class _BhpDashboardEquipmentCard extends StatelessWidget {
  /// Tworzy kartę podglądu wyposażenia BHP.
  const _BhpDashboardEquipmentCard({
    required this.items,
    required this.isLarge,
  });

  final List<GetBhpEquipmentListItem> items;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        BhpDashboardSectionHeader(
          title: context.l10n.dashboardBhpEquipmentSectionTitle,
          onTap: () => context.router.navigatePath(AppRoutePaths.bhpEquipment),
          badge: AppStatusBadge(
            label: '${items.length}',
            tone: AppStatusBadgeTone.info,
            icon: Icons.inventory_2_outlined,
          ),
        ),
        Gaps.h12,
        Expanded(
          child: items.isEmpty
              ? AppEmptyState.noData(
                  title: context.l10n.dashboardBhpEquipmentEmptyTitle,
                  message: context.l10n.dashboardBhpEquipmentEmptyMessage,
                  compact: true,
                )
              : BhpDashboardSeparatedListView(
                  thumbVisibility: isLarge,
                  itemCount: items.length,
                  separatorBuilder: (context, index) => Gaps.h8,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _PreviewRow(
                      title: '${item.symbol} • ${item.nazwa}',
                      subtitle:
                          item.okresUzywalnosci ??
                          context.l10n.dashboardBhpEquipmentNoPeriodLabel,
                      badgeLabel: _equipmentBadgeLabel(
                        context,
                        item.okresUzywalnosci,
                      ),
                      badgeIcon: _equipmentBadgeIcon(item.okresUzywalnosci),
                      badgeTooltip: _equipmentBadgeTooltip(
                        context,
                        item.okresUzywalnosci,
                      ),
                      badgeTone: _equipmentBadgeTone(item.okresUzywalnosci),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Pojedynczy wiersz podglądu wyposażenia.
class _PreviewRow extends StatelessWidget {
  /// Tworzy wiersz podglądu.
  const _PreviewRow({
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.badgeIcon,
    required this.badgeTooltip,
    required this.badgeTone,
  });

  final String title;
  final String subtitle;
  final String badgeLabel;
  final IconData badgeIcon;
  final String badgeTooltip;
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
            icon: badgeIcon,
            tooltip: badgeTooltip,
          ),
        ],
      ),
    );
  }
}

String _equipmentBadgeLabel(
  BuildContext context,
  String? okresUzywalnosci,
) {
  final period = okresUzywalnosci?.trim();
  if (period case final value? when value.isNotEmpty) {
    return value.toLowerCase().endsWith('mies') ? value : '$value mies.';
  }

  return context.l10n.dashboardBhpEquipmentActiveLabel;
}

IconData _equipmentBadgeIcon(String? okresUzywalnosci) {
  if (okresUzywalnosci case final period? when period.trim().isNotEmpty) {
    return Icons.schedule_rounded;
  }

  return Icons.check_circle_outline_rounded;
}

String _equipmentBadgeTooltip(
  BuildContext context,
  String? okresUzywalnosci,
) {
  final period = okresUzywalnosci?.trim();
  if (period case final value? when value.isNotEmpty) {
    return 'Okres używalności: $value miesięcy';
  }

  return context.l10n.bhpEquipmentStatusActiveTooltip;
}

AppStatusBadgeTone _equipmentBadgeTone(String? okresUzywalnosci) {
  if (okresUzywalnosci case final period? when period.trim().isNotEmpty) {
    return AppStatusBadgeTone.info;
  }

  return AppStatusBadgeTone.success;
}
