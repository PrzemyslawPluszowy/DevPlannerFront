part of '../bhp_dashboard_page.dart';

/// Główna karta priorytetów dashboardu.
class _BhpDashboardHero extends StatelessWidget {
  /// Tworzy kartę priorytetów dashboardu.
  const _BhpDashboardHero({
    required this.data,
    required this.onRefresh,
    this.isRefreshing = false,
  });

  /// Dane dashboardu.
  final GetBhpDashboardResponseData data;

  /// Akcja odświeżenia dashboardu.
  final VoidCallback onRefresh;

  /// Czy dashboard jest właśnie odświeżany.
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final totalAttention = data.overdueCount + data.upcomingCount;
    final headline = totalAttention == 0
        ? 'Brak pozycji wymagających reakcji'
        : '$totalAttention pozycji wymaga uwagi';

    return AppSectionCard(
      padding: .zero,
      tone: .tinted,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(.circular(Sizes.p24)),
          gradient: LinearGradient(
            colors: [
              colors.primaryContainer.withValues(alpha: .82),
              colors.tertiaryContainer.withValues(alpha: .46),
              colors.surfaceContainerHighest.withValues(alpha: .92),
            ],
            stops: const [0, .38, 1],
            begin: .topLeft,
            end: .bottomRight,
          ),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .5),
          ),
        ),
        child: Padding(
          padding: const .symmetric(horizontal: Sizes.p20, vertical: Sizes.p18),
          child: _BhpDashboardHeroContent(
            data: data,
            headline: headline,
            onRefresh: onRefresh,
            isRefreshing: isRefreshing,
          ),
        ),
      ),
    );
  }
}

/// Treść tekstowa głównej karty dashboardu.
class _BhpDashboardHeroContent extends StatelessWidget {
  /// Tworzy treść tekstową głównej karty dashboardu.
  const _BhpDashboardHeroContent({
    required this.data,
    required this.headline,
    required this.onRefresh,
    required this.isRefreshing,
  });

  /// Dane dashboardu.
  final GetBhpDashboardResponseData data;

  /// Główny nagłówek.
  final String headline;

  /// Akcja odświeżenia dashboardu.
  final VoidCallback onRefresh;

  /// Czy dashboard jest właśnie odświeżany.
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 900;

            return compact
                ? Column(
                    crossAxisAlignment: .start,
                    children: [
                      _BhpDashboardHeroHeader(
                        headline: headline,
                        isPriority: data.overdueCount > 0,
                      ),
                      Gaps.h12,
                      _BhpDashboardHeroRefreshButton(
                        onRefresh: onRefresh,
                        isRefreshing: isRefreshing,
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(
                        child: _BhpDashboardHeroHeader(
                          headline: headline,
                          isPriority: data.overdueCount > 0,
                        ),
                      ),
                      Gaps.w16,
                      _BhpDashboardHeroRefreshButton(
                        onRefresh: onRefresh,
                        isRefreshing: isRefreshing,
                      ),
                    ],
                  );
          },
        ),
        Gaps.h8,
        Text(
          data.overdueCount > 0
              ? 'Najpierw zamknij pozycje po terminie, potem przejdź do tych, które wkrótce wygasną.'
              : 'Na ten moment nie ma zaległych wydań. Warto przejrzeć nadchodzące terminy i zaplanować kolejne ruchy.',
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        Gaps.h12,
        Wrap(
          spacing: Sizes.p10,
          runSpacing: Sizes.p10,
          children: [
            AppStatusBadge(
              label: 'Po terminie: ${data.overdueCount}',
              tone: .danger,
              icon: Icons.warning_rounded,
            ),
            AppStatusBadge(
              label: 'Nadchodzące: ${data.upcomingCount}',
              tone: .warning,
              icon: Icons.schedule_rounded,
            ),
            AppStatusBadge(
              label: 'Okno: ${data.monthsAhead} mies.',
              tone: .info,
              icon: Icons.calendar_month_rounded,
            ),
          ],
        ),
      ],
    );
  }
}

/// Nagłówek szerokiego hero dashboardu.
class _BhpDashboardHeroHeader extends StatelessWidget {
  /// Tworzy nagłówek szerokiego hero dashboardu.
  const _BhpDashboardHeroHeader({
    required this.headline,
    required this.isPriority,
  });

  /// Główny nagłówek.
  final String headline;

  /// Czy w widoku jest priorytet wymagający reakcji.
  final bool isPriority;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          context.l10n.bhpDashboardSectionTitle,
          style: context.text.titleLarge?.copyWith(
            fontWeight: .w800,
            letterSpacing: -.2,
          ),
        ),
        Gaps.h4,
        Text(
          headline,
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
            fontWeight: .w600,
          ),
        ),
        Gaps.h8,
        AppStatusBadge(
          label: isPriority ? 'Priorytet dnia' : 'Status spokojny',
          tone: isPriority ? .danger : .success,
          icon: isPriority
              ? Icons.priority_high_rounded
              : Icons.check_circle_outline_rounded,
        ),
      ],
    );
  }
}

/// Przycisk odświeżenia w górnym hero dashboardu.
class _BhpDashboardHeroRefreshButton extends StatelessWidget {
  /// Tworzy przycisk odświeżenia w górnym hero dashboardu.
  const _BhpDashboardHeroRefreshButton({
    required this.onRefresh,
    required this.isRefreshing,
  });

  /// Akcja odświeżenia.
  final VoidCallback onRefresh;

  /// Czy dashboard jest właśnie odświeżany.
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return AppActionPill(
      label: context.l10n.bhpRefreshAction,
      icon: Icons.refresh_rounded,
      trailingIcon: isRefreshing ? Icons.hourglass_top_rounded : null,
      tone: .contrast,
      selected: true,
      onPressed: isRefreshing ? null : onRefresh,
    );
  }
}
