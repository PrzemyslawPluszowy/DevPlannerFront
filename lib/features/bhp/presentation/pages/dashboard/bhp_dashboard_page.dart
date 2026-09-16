import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/bhp_employee_name.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/dashboard/cubit/bhp_dashboard_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/dashboard/cubit/bhp_dashboard_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/bhp_user_issues_modal.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_banner.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';

part 'widgets/bhp_dashboard_page_alerts.part.dart';
part 'widgets/bhp_dashboard_page_summary.part.dart';

/// Ekran sekcji dashboardu BHP.
class BhpDashboardPage extends StatelessWidget {
  /// Tworzy ekran sekcji dashboardu BHP.
  const BhpDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = BhpDashboardCubit(
          repository: context.read<BhpDashboardRepository>(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _BhpDashboardContent(),
    );
  }
}

/// Zawartość sekcji dashboardu BHP.
class _BhpDashboardContent extends StatelessWidget {
  /// Tworzy zawartość sekcji dashboardu BHP.
  const _BhpDashboardContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpDashboardCubit, BhpDashboardState>(
      builder: (context, state) {
        final cubit = context.read<BhpDashboardCubit>();
        final intl = context.l10n;

        return switch (state) {
          BhpDashboardInitial() => const Center(child: AppSpinner()),
          BhpDashboardLoading(:final previousData) when previousData == null =>
            const Center(child: AppSpinner()),
          BhpDashboardLoading(:final previousData) when previousData != null =>
            _BhpDashboardLoaded(
              data: previousData,
              onRefresh: cubit.load,
              topBanner: AppBanner(
                title: intl.bhpDashboardSectionTitle,
                message: intl.bhpDashboardRefreshInProgress,
                trailing: const SizedBox.square(
                  dimension: Sizes.p16,
                  child: AppSpinner(size: Sizes.p16),
                ),
              ),
              isRefreshing: true,
            ),
          BhpDashboardLoading() => const Center(child: AppSpinner()),
          BhpDashboardError(:final message, :final previousData)
              when previousData != null =>
            _BhpDashboardLoaded(
              data: previousData,
              onRefresh: cubit.load,
              topBanner: AppBanner(
                title: intl.bhpDashboardErrorTitle,
                message: message,
                tone: .error,
                trailing: TextButton(
                  onPressed: cubit.load,
                  child: Text(intl.bhpDashboardRetryLabel),
                ),
              ),
            ),
          BhpDashboardError(:final message) => Center(
            child: AppEmptyState.error(
              title: intl.bhpDashboardErrorTitle,
              message: message,
            ),
          ),
          BhpDashboardSuccess(:final data) => _BhpDashboardLoaded(
            data: data,
            onRefresh: cubit.load,
          ),
        };
      },
    );
  }
}

/// Widok sukcesu sekcji dashboardu BHP.
class _BhpDashboardLoaded extends StatelessWidget {
  /// Tworzy widok sukcesu sekcji dashboardu BHP.
  const _BhpDashboardLoaded({
    required this.data,
    required this.onRefresh,
    this.topBanner,
    this.isRefreshing = false,
  });

  /// Dane dashboardu BHP.
  final GetBhpDashboardResponseData data;

  /// Akcja odświeżenia dashboardu.
  final VoidCallback onRefresh;

  /// Opcjonalny baner statusu nad kartą główną.
  final Widget? topBanner;

  /// Czy dashboard jest właśnie odświeżany.
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final overdue = [...data.overdue]..sort(_sortAlertsByUrgency);
    final upcoming = [...data.upcoming]..sort(_sortAlertsByUrgency);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1180;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              if (topBanner != null) ...[
                topBanner!,
                Gaps.h16,
              ],
              _BhpDashboardHero(
                data: data,
                onRefresh: onRefresh,
                isRefreshing: isRefreshing,
              ),
              Gaps.h16,
              if (isWide)
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: _BhpAlertsLane(
                        title: context.l10n.bhpDashboardOverdueTableTitle,
                        subtitle: context.l10n.bhpDashboardOverdueTableSubtitle,
                        emptyTitle: context.l10n.bhpDashboardNoOverdueTitle,
                        emptyMessage: context.l10n.bhpDashboardNoOverdueMessage,
                        rows: overdue,
                        tone: AppStatusBadgeTone.danger,
                      ),
                    ),
                    Gaps.w16,
                    Expanded(
                      child: _BhpAlertsLane(
                        title: context.l10n.bhpDashboardUpcomingTableTitle,
                        subtitle:
                            context.l10n.bhpDashboardUpcomingTableSubtitle,
                        emptyTitle: context.l10n.bhpDashboardNoUpcomingTitle,
                        emptyMessage:
                            context.l10n.bhpDashboardNoUpcomingMessage,
                        rows: upcoming,
                        tone: AppStatusBadgeTone.warning,
                        groupByUser: true,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _BhpAlertsLane(
                      title: context.l10n.bhpDashboardOverdueTableTitle,
                      subtitle: context.l10n.bhpDashboardOverdueTableSubtitle,
                      emptyTitle: context.l10n.bhpDashboardNoOverdueTitle,
                      emptyMessage: context.l10n.bhpDashboardNoOverdueMessage,
                      rows: overdue,
                      tone: AppStatusBadgeTone.danger,
                    ),
                    Gaps.h16,
                    _BhpAlertsLane(
                      title: context.l10n.bhpDashboardUpcomingTableTitle,
                      subtitle: context.l10n.bhpDashboardUpcomingTableSubtitle,
                      emptyTitle: context.l10n.bhpDashboardNoUpcomingTitle,
                      emptyMessage: context.l10n.bhpDashboardNoUpcomingMessage,
                      rows: upcoming,
                      tone: AppStatusBadgeTone.warning,
                      groupByUser: true,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
