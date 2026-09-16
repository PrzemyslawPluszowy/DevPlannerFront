import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/active_inventories/cubit/active_inventories_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_header_actions.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Definicja widgetu aktywnych inwentaryzacji (w toku) na pulpicie.
class ActiveInventoriesWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu aktywnych inwentaryzacji.
  const ActiveInventoriesWidgetDefinition();

  @override
  String get typeId => 'active_inventories';

  @override
  String get requiredPermission => ReadyPermissions.inventory;

  @override
  String name(BuildContext context) =>
      context.l10n.dashboardActiveInventoriesName;

  @override
  String description(BuildContext context) =>
      context.l10n.dashboardActiveInventoriesDescription;

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardActiveInventoriesCategory;

  @override
  IconData get icon => Icons.play_circle_outline_rounded;

  @override
  List<DashboardWidgetSize> get supportedSizes => const [
    DashboardWidgetSize(8, 4),
    DashboardWidgetSize(12, 4),
  ];

  @override
  Widget build(BuildContext context, DashboardWidgetSize size) {
    // Hermetyczne wstrzykiwanie zależności i Cubita dla zachowania niezależności widgetu pulpitu.
    // Dostarczamy jedynie repozytorium inwentaryzacji potrzebne do załadowania listy w toku.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<InventoryApi>(
          create: (context) => InventoryApi(context.read<Dio>()),
        ),
        RepositoryProvider<InventoriesRepository>(
          create: (context) =>
              InventoriesRepositoryImpl(api: context.read<InventoryApi>()),
        ),
      ],
      child: BlocProvider<ActiveInventoriesCubit>(
        create: (context) => ActiveInventoriesCubit(
          repository: context.read<InventoriesRepository>(),
        ),
        child: _ActiveInventoriesBody(size: size),
      ),
    );
  }
}

/// Główna zawartość wizualna widgetu w zależności od stanu Cubita.
class _ActiveInventoriesBody extends StatelessWidget {
  const _ActiveInventoriesBody({required this.size});

  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    return _ActiveInventoriesBodyStateful(size: size);
  }
}

/// Stanowy wrapper głównej zawartości wizualnej widgetu.
class _ActiveInventoriesBodyStateful extends StatefulWidget {
  const _ActiveInventoriesBodyStateful({required this.size});

  final DashboardWidgetSize size;

  @override
  State<_ActiveInventoriesBodyStateful> createState() =>
      _ActiveInventoriesBodyStatefulState();
}

/// Stan głównej zawartości wizualnej widgetu.
class _ActiveInventoriesBodyStatefulState
    extends State<_ActiveInventoriesBodyStateful> {
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
        () => context.read<ActiveInventoriesCubit>().load(),
      );
    });

    _refreshActionRegistered = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveInventoriesCubit, ActiveInventoriesState>(
      builder: (context, state) {
        return switch (state) {
          ActiveInventoriesInitial() || ActiveInventoriesLoading() =>
            const _ActiveInventoriesSkeletonShimmer(),
          ActiveInventoriesError(:final message) => Column(
            mainAxisAlignment: .center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: context.colors.error,
                size: 28,
              ),
              Gaps.h8,
              AppText(
                context.l10n.dashboardActiveInventoriesErrorTitle,
                style: context.text.labelLarge?.copyWith(fontWeight: .w700),
              ),
              Gaps.h4,
              AppText(
                message,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gaps.h12,
              TextButton.icon(
                onPressed: () => context.read<ActiveInventoriesCubit>().load(),
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: Text(context.l10n.dashboardActiveInventoriesRetryLabel),
              ),
            ],
          ),
          ActiveInventoriesLoaded(:final items) =>
            items.isEmpty
                ? Column(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        Icons.fact_check_outlined,
                        color: context.colors.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                        size: 32,
                      ),
                      Gaps.h8,
                      AppText(
                        context.l10n.dashboardActiveInventoriesEmptyTitle,
                        style: context.text.labelMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => Gaps.h8,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _ActiveInventoryTile(item: item);
                    },
                  ),
        };
      },
    );
  }
}

/// Pojedynczy wiersz/kafelek aktywnej inwentaryzacji na liście.
class _ActiveInventoryTile extends StatelessWidget {
  const _ActiveInventoryTile({required this.item});

  final GetInwentaryzacjeItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dateStr = item.dataOd.toAppDate();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          unawaited(context.router.navigatePath(AppRoutePaths.inventory));
        },
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        child: Container(
          padding: const .all(Sizes.p12),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest.withValues(alpha: 0.4),
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              // Zielony, pulsujący wizualnie wskaźnik inwentaryzacji w toku
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppText(
                      item.numer,
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w800,
                        color: colors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.h4,
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 12,
                          color: colors.onSurfaceVariant,
                        ),
                        Gaps.w4,
                        AppText(
                          dateStr,
                          style: context.text.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: .w500,
                          ),
                        ),
                        Gaps.w12,
                        Icon(
                          Icons.description_rounded,
                          size: 12,
                          color: colors.onSurfaceVariant,
                        ),
                        Gaps.w4,
                        AppText(
                          context.l10n.dashboardActiveInventoriesSheetsLabel(
                            item.arkuszeCount,
                          ),
                          style: context.text.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: .w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Szkielet ładowania danych dla widgetu aktywnych inwentaryzacji.
class _ActiveInventoriesSkeletonShimmer extends StatelessWidget {
  const _ActiveInventoriesSkeletonShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = context.colors;

    final cardBgColor = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : colors.surfaceContainerLowest.withValues(alpha: 0.65);
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : colors.outlineVariant.withValues(alpha: 0.35);
    final blockColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : colors.onSurface.withValues(alpha: 0.08);
    final blockSubColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : colors.onSurface.withValues(alpha: 0.04);
    final shimmerHighlight = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.white.withValues(alpha: 0.65);

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = Sizes.p8;
        const tileHeight = 58.0;
        const stride = tileHeight + spacing;
        final calculatedCount = (constraints.maxHeight / stride).ceil().clamp(
          1,
          10,
        );

        return RepaintBoundary(
          child:
              ClipRect(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: calculatedCount,
                      separatorBuilder: (context, index) => Gaps.h8,
                      itemBuilder: (context, index) {
                        return Container(
                          height: tileHeight,
                          padding: const .all(Sizes.p12),
                          decoration: BoxDecoration(
                            color: cardBgColor,
                            borderRadius: const BorderRadius.all(
                              .circular(Sizes.p12),
                            ),
                            border: Border.all(color: cardBorderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: blockColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Gaps.w12,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  mainAxisAlignment: .center,
                                  children: [
                                    Container(
                                      width: index.isEven ? 140.0 : 180.0,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: blockColor,
                                        borderRadius: const BorderRadius.all(
                                          .circular(Sizes.p4),
                                        ),
                                      ),
                                    ),
                                    Gaps.h4,
                                    Row(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: blockSubColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                  .circular(Sizes.p4),
                                                ),
                                          ),
                                        ),
                                        Gaps.w12,
                                        Container(
                                          width: 80,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: blockSubColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                  .circular(Sizes.p4),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: blockSubColor,
                                  borderRadius: const BorderRadius.all(
                                    .circular(Sizes.p4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: const Duration(milliseconds: 1300),
                    color: shimmerHighlight,
                  ),
        );
      },
    );
  }
}
