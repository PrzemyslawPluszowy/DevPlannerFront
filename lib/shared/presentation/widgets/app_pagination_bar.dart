import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Uniwersalny kontroler paginacji dla widoków web/desktop.
class AppPaginationBar extends StatelessWidget {
  /// Tworzy pasek paginacji.
  const AppPaginationBar({
    required this.total,
    required this.limit,
    required this.offset,
    required this.onPageChanged,
    required this.onLimitChanged,
    this.limitOptions = const [50, 100, 500, 1000],
    super.key,
  });

  /// Całkowita liczba rekordów.
  final int total;

  /// Liczba rekordów na stronę.
  final int limit;

  /// Bieżący offset.
  final int offset;

  /// Dostępne opcje liczby rekordów na stronę.
  final List<int> limitOptions;

  /// Callback wywoływany przy zmianie strony (nowy offset).
  final ValueChanged<int> onPageChanged;

  /// Callback wywoływany przy zmianie limitu (nowy limit).
  final ValueChanged<int> onLimitChanged;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) return const SizedBox.shrink();

    final totalPages = (total / limit).ceil();
    final currentPage = (offset / limit).floor() + 1;
    final canPrev = offset > 0;
    final canNext = offset + limit < total;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
      child: Row(
        children: [
          _PageInfo(
            total: total,
            offset: offset,
            limit: limit,
          ),
          const Spacer(),
          _PaginationNumbers(
            currentPage: currentPage,
            totalPages: totalPages,
            limit: limit,
            onPageSelected: (page) => onPageChanged((page - 1) * limit),
          ),
          Gaps.w16,
          _LimitSelector(
            currentLimit: limit,
            options: limitOptions,
            onChanged: onLimitChanged,
          ),
          Gaps.w16,
          Row(
            children: [
              AppActionButton.outlined(
                label: 'Poprzednia',
                icon: Icons.chevron_left_rounded,
                onPressed: canPrev ? () => onPageChanged(offset - limit) : null,
                tone: .neutral,
              ),
              Gaps.w8,
              AppActionButton.outlined(
                label: 'Następna',
                icon: Icons.chevron_right_rounded,
                onPressed: canNext ? () => onPageChanged(offset + limit) : null,
                tone: .neutral,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaginationNumbers extends StatelessWidget {
  const _PaginationNumbers({
    required this.currentPage,
    required this.totalPages,
    required this.limit,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final int limit;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    if (limit == -1) return const SizedBox.shrink();

    final children = <Widget>[];
    const maxVisiblePages = 5;

    // Logika wyświetlania numerów stron z "..."
    if (totalPages <= maxVisiblePages) {
      for (var i = 1; i <= totalPages; i++) {
        children.add(_buildPageButton(context, i));
      }
    } else {
      children.add(_buildPageButton(context, 1));

      var startRange = currentPage - 1;
      var endRange = currentPage + 1;

      if (startRange <= 2) {
        startRange = 2;
        endRange = 4;
      }
      if (endRange >= totalPages - 1) {
        startRange = totalPages - 3;
        endRange = totalPages - 1;
      }

      if (startRange > 2) {
        children.add(const _PageEllipsis());
      }

      for (var i = startRange; i <= endRange; i++) {
        children.add(_buildPageButton(context, i));
      }

      if (endRange < totalPages - 1) {
        children.add(const _PageEllipsis());
      }

      children.add(_buildPageButton(context, totalPages));
    }

    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  Widget _buildPageButton(BuildContext context, int page) {
    final isSelected = page == currentPage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: isSelected ? null : () => onPageSelected(page),
        borderRadius: const BorderRadius.all(.circular(4)),
        child: Container(
          width: 32,
          height: 32,
          alignment: .center,
          decoration: BoxDecoration(
            color: isSelected ? context.colors.primary : Colors.transparent,
            borderRadius: const BorderRadius.all(.circular(4)),
            border: Border.all(
              color: isSelected
                  ? context.colors.primary
                  : context.colors.outlineVariant.withValues(alpha: .5),
            ),
          ),
          child: AppText(
            '$page',
            style: context.text.labelSmall?.copyWith(
              color: isSelected
                  ? context.colors.onPrimary
                  : context.colors.onSurface,
              fontWeight: isSelected ? .bold : .normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _PageEllipsis extends StatelessWidget {
  const _PageEllipsis();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AppText(
        '...',
        style: context.text.labelSmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _LimitSelector extends StatelessWidget {
  const _LimitSelector({
    required this.currentLimit,
    required this.options,
    required this.onChanged,
  });

  final int currentLimit;
  final List<int> options;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          'Na stronie:',
          style: context.text.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Gaps.w8,
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colors.outlineVariant.withValues(alpha: .5),
            ),
            borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: options.contains(currentLimit)
                  ? currentLimit
                  : (currentLimit == -1 ? -1 : options.first),
              onChanged: (v) => v != null ? onChanged(v) : null,
              items: [
                ...options.map(
                  (opt) => DropdownMenuItem(
                    value: opt,
                    child: AppText(
                      '$opt',
                      style: context.text.labelSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                  ),
                ),
              ],
              icon: const Icon(Icons.arrow_drop_down, size: 16),
              style: context.text.labelSmall,
              dropdownColor: context.colors.surface,
            ),
          ),
        ),
      ],
    );
  }
}

class _PageInfo extends StatelessWidget {
  const _PageInfo({
    required this.total,
    required this.offset,
    required this.limit,
  });

  final int total;
  final int offset;
  final int limit;

  @override
  Widget build(BuildContext context) {
    const limitAllValue = -1;
    final isAllLoaded = limit == limitAllValue || limit >= total;
    final totalPages = (total / limit).ceil();
    final currentPage = (offset / limit).floor() + 1;

    if (isAllLoaded) {
      return Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          AppText(
            'Wszystkie rekordy',
            style: context.text.bodySmall?.copyWith(
              fontWeight: .w700,
              color: context.colors.onSurface,
            ),
          ),
          AppText(
            'Łącznie: $total rekordów',
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    final start = offset + 1;
    final end = (offset + limit) > total ? total : (offset + limit);

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        AppText(
          'Strona $currentPage z $totalPages',
          style: context.text.bodySmall?.copyWith(
            fontWeight: .w700,
            color: context.colors.onSurface,
          ),
        ),
        AppText(
          'Pokazano $start-$end z $total rekordów',
          style: context.text.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
