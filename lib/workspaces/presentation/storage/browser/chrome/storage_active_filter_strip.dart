import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Pasek aktywnych filtrów z jednym wyjściem do ich zdjęcia.
///
/// Bez niego zawężona lista wyglądałaby jak pusty katalog, a użytkownik nie
/// wiedziałby, że patrzy na wynik filtra.
final class StorageActiveFilterStrip extends StatelessWidget {
  /// Tworzy pasek aktywnych filtrów.
  const StorageActiveFilterStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    final cubit = context.read<StorageBrowserCubit>();

    return BlocSelector<StorageBrowserCubit, StorageBrowserState, bool>(
      selector: (_) => cubit.currentFilter.hasActiveFilters,
      builder: (context, isActive) {
        if (!isActive) return const SizedBox.shrink();
        final chips = _activeChips(context, cubit);
        return Padding(
          padding: EdgeInsets.only(top: common.tightGap),
          child: Row(
            key: const ValueKey('storage_active_filter_strip'),
            children: [
              Icon(
                Symbols.filter_alt_rounded,
                size: 16,
                color: colors.onSurfaceVariant,
              ),
              SizedBox(width: common.controlGap),
              Text(
                context.l10n.storageFilterActiveLabel,
                style: common.metaText.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              SizedBox(width: common.controlGap),
              Expanded(
                child: Wrap(
                  spacing: common.controlGap,
                  runSpacing: common.controlGap,
                  children: [
                    for (final chip in chips) chip,
                  ],
                ),
              ),
              TextButton(
                key: const ValueKey('storage_active_filter_clear'),
                onPressed: () => unawaited(
                  cubit.setFilter(const StorageBrowserFilter()),
                ),
                child: Text(context.l10n.storageFilterClear),
              ),
            ],
          ),
        );
      },
    );
  }

  static List<Widget> _activeChips(
    BuildContext context,
    StorageBrowserCubit cubit,
  ) {
    final filter = cubit.currentFilter;
    return [
      if (filter.extension case final extension?)
        _FilterChip(
          label: extension.toUpperCase(),
          onDeleted: () =>
              unawaited(cubit.setFilter(filter.copyWith(clearExtension: true))),
        ),
      if (filter.aiStatus case final status?)
        _FilterChip(
          label: switch (status) {
            StorageAiStatus.none => context.l10n.storageFilterStatusNone,
            StorageAiStatus.queued => context.l10n.storageFilterStatusQueued,
            StorageAiStatus.processing =>
              context.l10n.storageFilterStatusProcessing,
            StorageAiStatus.completed =>
              context.l10n.storageFilterStatusCompleted,
            StorageAiStatus.failed => context.l10n.storageFilterStatusFailed,
          },
          onDeleted: () =>
              unawaited(cubit.setFilter(filter.copyWith(clearAiStatus: true))),
        ),
      if (filter.createdFromUtc != null)
        _FilterChip(
          label: _windowLabel(context, filter.createdFromUtc!),
          onDeleted: () => unawaited(
            cubit.setFilter(filter.copyWith(clearCreatedFromUtc: true)),
          ),
        ),
    ];
  }

  static String _windowLabel(BuildContext context, DateTime from) {
    final delta = DateTime.now().toUtc().difference(from);
    if (delta <= const Duration(days: 1)) {
      return context.l10n.storageFilterDateToday;
    }
    if (delta <= const Duration(days: 7)) {
      return context.l10n.storageFilterDateWeek;
    }
    return context.l10n.storageFilterDateMonth;
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onDeleted});

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) => InputChip(
    label: Text(label),
    onDeleted: onDeleted,
    deleteIcon: const Icon(Symbols.close_rounded, size: 14),
    visualDensity: VisualDensity.compact,
    labelStyle: context.filesTheme.common.metaText,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}
