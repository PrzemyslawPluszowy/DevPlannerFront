import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Buduje etykietę sprzętu z alertu dashboardu BHP.
String buildBhpDashboardEquipmentLabel(GetBhpIssueAlertItem row) {
  return [
    row.kartaWyposazeniaSymbol,
    row.kartaWyposazeniaNazwa,
  ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' • ');
}

/// Buduje etykietę terminu dla alertu dashboardu BHP.
String buildBhpDashboardDueLabel(BuildContext context, int daysToDue) {
  final intl = context.l10n;
  if (daysToDue < 0) {
    return intl.dashboardBhpUsersDeadlineOverdueLabel(daysToDue.abs());
  }
  if (daysToDue == 0) {
    return intl.dashboardBhpUsersDeadlineTodayLabel;
  }
  return intl.dashboardBhpUsersDeadlineUpcomingLabel(daysToDue);
}

/// Otwiera widok wydań pracownika dla alertu dashboardu BHP.
void openBhpDashboardDetails(BuildContext context) {
  unawaited(context.router.navigatePath(AppRoutePaths.bhp));
}

/// Klkalny nagłówek widgetu dashboardu BHP bez przejmowania scrolla treści.
class BhpDashboardSectionHeader extends StatelessWidget {
  /// Tworzy klikalny nagłówek sekcji dashboardu BHP.
  const BhpDashboardSectionHeader({
    required this.title,
    required this.badge,
    required this.onTap,
    super.key,
  });

  /// Tytuł sekcji.
  final String title;

  /// Badge wyświetlany po prawej stronie.
  final Widget badge;

  /// Akcja otwarcia pełnego widoku.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        child: Padding(
          padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  title,
                  style: context.text.titleMedium?.copyWith(
                    fontWeight: .w800,
                  ),
                ),
              ),
              Gaps.w8,
              badge,
            ],
          ),
        ),
      ),
    );
  }
}

/// Wspólna lista BHP ze scrollbar'em i obsługą drag-scroll na desktopie.
class BhpDashboardSeparatedListView extends StatefulWidget {
  /// Tworzy wspólną listę dashboardu BHP.
  const BhpDashboardSeparatedListView({
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.thumbVisibility = false,
    super.key,
  });

  /// Liczba elementów listy.
  final int itemCount;

  /// Buduje pojedynczy element listy.
  final IndexedWidgetBuilder itemBuilder;

  /// Buduje separator pomiędzy elementami.
  final IndexedWidgetBuilder? separatorBuilder;

  /// Czy suwak przewijania ma być stale widoczny.
  final bool thumbVisibility;

  @override
  State<BhpDashboardSeparatedListView> createState() =>
      _BhpDashboardSeparatedListViewState();
}

/// Stan wspólnej listy dashboardu BHP.
class _BhpDashboardSeparatedListViewState
    extends State<BhpDashboardSeparatedListView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.invertedStylus,
          PointerDeviceKind.unknown,
        },
      ),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: widget.thumbVisibility,
        interactive: true,
        child: ListView.separated(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.itemCount,
          separatorBuilder:
              widget.separatorBuilder ??
              (_, _) => const SizedBox(height: Sizes.p8),
          itemBuilder: widget.itemBuilder,
        ),
      ),
    );
  }
}

/// Kafelek pojedynczego alertu dashboardu BHP.
class BhpDashboardAlertTile extends StatelessWidget {
  /// Tworzy kafelek alertu dashboardu BHP.
  const BhpDashboardAlertTile({
    required this.row,
    required this.tone,
    super.key,
  });

  /// Dane alertu.
  final GetBhpIssueAlertItem row;

  /// Ton wizualny.
  final AppStatusBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderColor = switch (tone) {
      AppStatusBadgeTone.danger => colors.error.withValues(alpha: .16),
      AppStatusBadgeTone.warning => colors.tertiary.withValues(alpha: .16),
      _ => colors.outlineVariant.withValues(alpha: .4),
    };
    final backgroundColor = switch (tone) {
      AppStatusBadgeTone.danger => colors.errorContainer.withValues(alpha: .22),
      AppStatusBadgeTone.warning => colors.tertiaryContainer.withValues(
        alpha: .26,
      ),
      _ => colors.surfaceContainerLow,
    };

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
                        row.formattedUserFullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.titleSmall?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                    ),
                    Gaps.w8,
                    AppStatusBadge(
                      label: buildBhpDashboardDueLabel(context, row.daysToDue),
                      tone: tone,
                      icon: tone == AppStatusBadgeTone.danger
                          ? Icons.warning_amber_rounded
                          : Icons.schedule_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Spójny stan pusty lub błędu dla widgetów alertów.
class BhpDashboardAlertsFallback extends StatelessWidget {
  /// Tworzy fallback dla alertów dashboardu BHP.
  const BhpDashboardAlertsFallback({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onActionPressed,
    super.key,
  });

  /// Tytuł komunikatu.
  final String title;

  /// Treść komunikatu.
  final String message;

  /// Etykieta akcji.
  final String actionLabel;

  /// Akcja ponowienia.
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState.error(
      title: title,
      message: message,
      compact: true,
      action: TextButton.icon(
        onPressed: onActionPressed,
        icon: const Icon(Icons.refresh_rounded),
        label: AppText(actionLabel),
      ),
    );
  }
}

/// Efekt szkieletu ładowania danych z animacją shimmer dla widgetów BHP,
/// który dynamicznie wypełnia całą dostępną przestrzeń widgetu.
class BhpDashboardSkeletonShimmer extends StatelessWidget {
  /// Tworzy szkielet ładowania danych dla widgetów BHP.
  const BhpDashboardSkeletonShimmer({super.key});

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
        // Obliczamy liczbę kafelków tak, aby dokładnie wypełnić 100% wysokości widgetu
        const headerHeight = 36.0;
        const spacing = Sizes.p8;
        const tileHeight = 56.0;
        const stride = tileHeight + spacing;
        final availableHeight = (constraints.maxHeight - headerHeight).clamp(
          0.0,
          double.infinity,
        );
        final calculatedCount = (availableHeight / stride).ceil().clamp(
          1,
          15,
        );

        return RepaintBoundary(
          child: ClipRect(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // Szkielet nagłówka sekcji
                Padding(
                  padding: const .symmetric(
                    horizontal: Sizes.p4,
                    vertical: Sizes.p4,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 130,
                        height: 16,
                        decoration: BoxDecoration(
                          color: blockColor,
                          borderRadius: const BorderRadius.all(
                            .circular(Sizes.p8),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 44,
                        height: 20,
                        decoration: BoxDecoration(
                          color: blockColor,
                          borderRadius: const BorderRadius.all(
                            .circular(Sizes.p12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.h8,
                // Dynamiczna lista kafelków szkieletowych
                Expanded(
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: calculatedCount,
                    separatorBuilder: (context, index) => Gaps.h8,
                    itemBuilder: (context, index) {
                      final titleWidth = (index % 3 == 0)
                          ? 150.0
                          : (index % 3 == 1)
                          ? 120.0
                          : 170.0;
                      final subtitleWidth = index.isEven ? 95.0 : 75.0;

                      return Container(
                        height: tileHeight,
                        padding: const .symmetric(
                          horizontal: Sizes.p12,
                          vertical: Sizes.p8,
                        ),
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
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: blockColor,
                                borderRadius: const BorderRadius.all(
                                  .circular(Sizes.p8),
                                ),
                              ),
                            ),
                            Gaps.w8,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: .start,
                                mainAxisAlignment: .center,
                                children: [
                                  Container(
                                    width: titleWidth,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: blockColor,
                                      borderRadius: const BorderRadius.all(
                                        .circular(Sizes.p4),
                                      ),
                                    ),
                                  ),
                                  Gaps.h4,
                                  Container(
                                    width: subtitleWidth,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: blockSubColor,
                                      borderRadius: const BorderRadius.all(
                                        .circular(Sizes.p4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gaps.w8,
                            Container(
                              width: 60,
                              height: 22,
                              decoration: BoxDecoration(
                                color: blockColor,
                                borderRadius: const BorderRadius.all(
                                  .circular(Sizes.p12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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

/// Widok ładowania dla widgetów dashboardu BHP ze szkieletem shimmer.
class BhpDashboardLoadingView extends StatelessWidget {
  /// Tworzy widok ładowania.
  const BhpDashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const BhpDashboardSkeletonShimmer();
  }
}
