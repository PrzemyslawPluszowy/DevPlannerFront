part of 'arkusz_detail_modal.dart';

/// Karta naglowka szczegolow arkusza.
class _ArkuszHeaderCard extends StatelessWidget {
  /// Tworzy karte naglowka szczegolow arkusza.
  const _ArkuszHeaderCard({
    required this.placeName,
    required this.placeLevel,
    required this.elementsCount,
    required this.committeeCount,
    required this.startDateTime,
    required this.endDateTime,
    required this.committee,
    required this.onShowLegend,
    required this.onEditCommittee,
    required this.canEditCommittee,
  });

  final String? placeName;
  final String? placeLevel;
  final int elementsCount;
  final int committeeCount;
  final String? startDateTime;
  final String? endDateTime;
  final List<GetArkuszDetailsKomisjaItem> committee;
  final VoidCallback onShowLegend;
  final VoidCallback onEditCommittee;
  final bool canEditCommittee;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p12),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: .35),
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 760;

              final actions = Row(
                mainAxisSize: .min,
                children: [
                  Tooltip(
                    message:
                        '${intl.inventoryAssetStateLabel} / '
                        '${intl.inventoryInventoryStateShort} / ${intl.inventoryScan}',
                    child: IconButton(
                      onPressed: onShowLegend,
                      icon: const Icon(Icons.info_outline_rounded),
                      visualDensity: .compact,
                    ),
                  ),
                  Gaps.w8,
                  AppActionButton.outlined(
                    label: intl.inventoryCommissionLabel,
                    icon: Icons.group_outlined,
                    tone: .neutral,
                    onPressed: canEditCommittee ? onEditCommittee : null,
                  ),
                ],
              );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppText(
                      switch (placeName) {
                        final String place when place.trim().isNotEmpty =>
                          place.trim(),
                        _ => intl.inventorySheetLabel,
                      },
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h8,
                    actions,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: .start,
                children: [
                  Expanded(
                    child: AppText(
                      switch (placeName) {
                        final String place when place.trim().isNotEmpty =>
                          place.trim(),
                        _ => intl.inventorySheetLabel,
                      },
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                  ),
                  actions,
                ],
              );
            },
          ),
          Gaps.h8,
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: [
              _ArkuszMetaChip(
                label: intl.inventoryItemsLabel,
                value: '$elementsCount',
              ),
              _ArkuszMetaChip(
                label: intl.inventoryCommissionLabel,
                value: '$committeeCount',
              ),
              if (placeLevel case final String lvl when lvl.trim().isNotEmpty)
                _ArkuszMetaChip(
                  label: intl.inventoryLocationLevelLabel,
                  value: lvl.trim(),
                ),
              if (startDateTime case final String dateTime
                  when dateTime.trim().isNotEmpty)
                _ArkuszMetaChip(
                  label: intl.start,
                  value: _formatDateTime(dateTime),
                ),
              if (endDateTime case final String dateTime
                  when dateTime.trim().isNotEmpty)
                _ArkuszMetaChip(
                  label: intl.end,
                  value: _formatDateTime(dateTime),
                ),
            ],
          ),
          Gaps.h8,
          if (committee.isEmpty)
            AppText(
              intl.inventoryNoAssignedCommissionTitle,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            )
          else
            Wrap(
              spacing: Sizes.p8,
              runSpacing: Sizes.p8,
              children: committee
                  .map(
                    (member) => _ArkuszCommissionChip(name: member.displayName),
                  )
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(String isoDateTime) {
    final parsed = DateTime.tryParse(isoDateTime.trim());
    if (parsed == null) {
      return isoDateTime.toAppDate();
    }
    final formattedDate = parsed.toIso8601String().split('T').first.toAppDate();
    final hh = parsed.hour.toString().padLeft(2, '0');
    final mm = parsed.minute.toString().padLeft(2, '0');
    return '$formattedDate $hh:$mm';
  }
}

/// Chip pojedynczego czlonka komisji arkusza.
class _ArkuszCommissionChip extends StatelessWidget {
  /// Tworzy chip czlonka komisji.
  const _ArkuszCommissionChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return Container(
      padding: const .symmetric(horizontal: Sizes.p10, vertical: Sizes.p4),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: .6),
        borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
      ),
      child: AppText(
        name.trim().isEmpty ? intl.globalUserFallback : name.trim(),
        style: context.text.labelLarge?.copyWith(fontWeight: .w600),
      ),
    );
  }
}

/// Chip metadanych dla widoku arkusza.
class _ArkuszMetaChip extends StatelessWidget {
  /// Tworzy chip metadanych dla widoku arkusza.
  const _ArkuszMetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: .5),
        borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          AppText(
            '$label:',
            style: context.text.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          Gaps.w4,
          AppText(
            value,
            style: context.text.labelMedium?.copyWith(fontWeight: .w600),
          ),
        ],
      ),
    );
  }
}
