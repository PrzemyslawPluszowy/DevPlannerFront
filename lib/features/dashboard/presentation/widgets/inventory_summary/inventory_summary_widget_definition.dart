import 'package:flutter/material.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Definicja widgetu Podsumowania Inwentaryzacji.
class InventorySummaryWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu Podsumowania Inwentaryzacji.
  const InventorySummaryWidgetDefinition();

  @override
  String get typeId => 'inventory_summary';

  @override
  String name(BuildContext context) =>
      context.l10n.dashboardInventorySummaryName;

  @override
  String description(BuildContext context) =>
      context.l10n.dashboardInventorySummaryDescription;

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardInventorySummaryCategory;

  @override
  IconData get icon => Icons.fact_check_rounded;

  @override
  List<DashboardWidgetSize> get supportedSizes => const [
    DashboardWidgetSize(8, 4),
    DashboardWidgetSize(12, 4),
  ];

  @override
  Widget build(BuildContext context, DashboardWidgetSize size) {
    return _InventorySummaryBody(size: size);
  }
}

class _InventorySummaryBody extends StatelessWidget {
  const _InventorySummaryBody({required this.size});

  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    // Statystyki przykładowe (symulacja danych z API)
    const activeSheets = 3;
    const completedSheets = 14;
    const progressPercent = 0.82;

    return InkWell(
      onTap: () => context.router.navigatePath(AppRoutePaths.inventory),
      borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  AppText(
                    context.l10n.dashboardInventorySummaryActiveSheetsLabel,
                    style: context.text.labelMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: .w600,
                    ),
                  ),
                  Gaps.h4,
                  AppText(
                    '$activeSheets',
                    style: context.text.headlineMedium?.copyWith(
                      fontWeight: .w800,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: .end,
                children: [
                  AppText(
                    context.l10n.dashboardInventorySummaryCompletedLabel,
                    style: context.text.labelMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: .w600,
                    ),
                  ),
                  Gaps.h4,
                  AppText(
                    '$completedSheets',
                    style: context.text.titleLarge?.copyWith(
                      fontWeight: .w700,
                      color: context.colors.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gaps.h12,
          Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    context.l10n.dashboardInventorySummaryProgressLabel,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: .w500,
                    ),
                  ),
                  AppText(
                    '${(progressPercent * 100).toInt()}%',
                    style: context.text.labelSmall?.copyWith(
                      fontWeight: .w700,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              Gaps.h8,
              ClipRRect(
                borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 8,
                  backgroundColor: context.colors.primary.withValues(
                    alpha: 0.1,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
