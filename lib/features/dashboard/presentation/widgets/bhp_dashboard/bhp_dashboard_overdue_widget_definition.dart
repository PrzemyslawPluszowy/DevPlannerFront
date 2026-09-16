import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';

import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/alerts/cubit/bhp_dashboard_alerts_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/alerts/cubit/bhp_dashboard_overdue_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/bhp_dashboard_widget_support.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_header_actions.dart';

import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';

/// Definicja widgetu alertów BHP po terminie.
class BhpDashboardOverdueWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu alertów BHP po terminie.
  const BhpDashboardOverdueWidgetDefinition();

  @override
  String get typeId => 'bhp_dashboard_overdue';

  @override
  String get requiredPermission => ReadyPermissions.bhp;

  @override
  String name(BuildContext context) => context.l10n.dashboardBhpOverdueName;

  @override
  String description(BuildContext context) =>
      context.l10n.dashboardBhpOverdueDescription;

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardBhpOverdueCategory;

  @override
  IconData get icon => Icons.warning_amber_rounded;

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
      create: (context) => BhpDashboardOverdueCubit(
        repository: context.read<BhpDashboardRepository>(),
      ),
      child: _BhpDashboardOverdueBody(size: size),
    );
  }
}

/// Zawartość widgetu alertów po terminie.
class _BhpDashboardOverdueBody extends StatelessWidget {
  /// Tworzy zawartość widgetu alertów po terminie.
  const _BhpDashboardOverdueBody({required this.size});

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    return _BhpDashboardOverdueBodyStateful(size: size);
  }
}

/// Stanowy wrapper zawartości widgetu alertów po terminie.
class _BhpDashboardOverdueBodyStateful extends StatefulWidget {
  /// Tworzy stanowy wrapper zawartości widgetu alertów po terminie.
  const _BhpDashboardOverdueBodyStateful({required this.size});

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize size;

  @override
  State<_BhpDashboardOverdueBodyStateful> createState() =>
      _BhpDashboardOverdueBodyStatefulState();
}

/// Stan zawartości widgetu alertów po terminie.
class _BhpDashboardOverdueBodyStatefulState
    extends State<_BhpDashboardOverdueBodyStateful> {
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
        () => context.read<BhpDashboardOverdueCubit>().load(),
      );
    });

    _refreshActionRegistered = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpDashboardOverdueCubit, BhpDashboardAlertsState>(
      builder: (context, state) {
        return switch (state) {
          BhpDashboardAlertsInitial() ||
          BhpDashboardAlertsLoading() => const BhpDashboardLoadingView(),
          BhpDashboardAlertsError(:final message) => BhpDashboardAlertsFallback(
            title: context.l10n.dashboardBhpOverdueErrorTitle,
            message: message,
            actionLabel: context.l10n.dashboardBhpOverdueRefreshLabel,
            onActionPressed: () =>
                context.read<BhpDashboardOverdueCubit>().load(),
          ),
          BhpDashboardAlertsSuccess(:final rows) => _BhpDashboardAlertsCard(
            title: context.l10n.dashboardBhpOverdueSectionTitle,
            rows: rows,
            tone: AppStatusBadgeTone.danger,
            emptyTitle: context.l10n.dashboardBhpOverdueEmptyTitle,
            emptyMessage: context.l10n.dashboardBhpOverdueEmptyMessage,
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
    return Column(
      crossAxisAlignment: .start,
      children: [
        BhpDashboardSectionHeader(
          title: title,
          onTap: () => openBhpDashboardDetails(context),
          badge: AppStatusBadge(
            label: '${rows.length}',
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
                  itemCount: rows.length,
                  separatorBuilder: (context, index) => Gaps.h8,
                  itemBuilder: (context, index) {
                    return BhpDashboardAlertTile(
                      row: rows[index],
                      tone: tone,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
