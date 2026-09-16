part of 'arkusz_detail_modal.dart';

/// Otwiera legende statusow dla statusu spisu, skanu i aktualnego stanu.
Future<void> _showArkuszStatusesLegendDialog(BuildContext context) {
  final intl = context.l10n;
  const assetStatuses = SrodekTrwalyStatus.values;

  final scannerEntries = <AppStatusBadge>[
    AppStatusBadge(
      label: '0 - ${intl.inventoryScannerNotRead}',
      tone: AppStatusBadgeTone.warning,
      icon: Icons.radio_button_unchecked_rounded,
      showBorder: false,
    ),
    AppStatusBadge(
      label: '1 - ${intl.inventoryScannerRead}',
      tone: AppStatusBadgeTone.success,
      icon: Icons.qr_code_scanner_rounded,
      showBorder: false,
    ),
  ];

  return AppModalSheet.show<void>(
    context,
    title: intl.inventorySheetDetailsTitle,
    minBodyHeight: 0,
    maxBodyHeight: 420,
    body: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        AppText(
          context.l10n.inventoryStatusSpisuFieldLabel,
          style: context.text.labelLarge?.copyWith(fontWeight: .w700),
        ),
        Gaps.h4,
        AppText(
          inventoryStatusSpisuOptionsHelperText(context),
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Gaps.h8,
        Column(
          mainAxisSize: .min,
          children: kVisibleStatusSpisuOptions
              .map(
                (status) => Padding(
                  padding: const .only(bottom: Sizes.p8),
                  child: _ArkuszStatusLegendRow(status: status),
                ),
              )
              .toList(growable: false),
        ),
        Gaps.h12,
        AppText(
          intl.inventoryScan,
          style: context.text.labelLarge?.copyWith(fontWeight: .w700),
        ),
        Gaps.h8,
        Wrap(
          spacing: Sizes.p8,
          runSpacing: Sizes.p8,
          children: scannerEntries,
        ),
        Gaps.h12,
        AppText(
          '${intl.inventoryCurrentState} (pobierany z snapshotu Stanu ST)',
          style: context.text.labelLarge?.copyWith(fontWeight: .w700),
        ),
        Gaps.h8,
        Column(
          mainAxisSize: .min,
          children: assetStatuses
              .map(
                (status) => Padding(
                  padding: const .only(bottom: Sizes.p8),
                  child: _ArkuszAssetStatusLegendRow(status: status),
                ),
              )
              .toList(growable: false),
        ),
      ],
    ),
  );
}

/// Wiersz legendy dla pojedynczego statusu srodka trwalego.
class _ArkuszAssetStatusLegendRow extends StatelessWidget {
  /// Tworzy wiersz legendy statusu srodka trwalego.
  const _ArkuszAssetStatusLegendRow({required this.status});

  /// Status prezentowany w legendzie.
  final SrodekTrwalyStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        AppStatusBadge(label: status.label, showBorder: false),
        Gaps.w12,
        Expanded(
          child: Padding(
            padding: const .only(top: Sizes.p4),
            child: AppText(
              assetStatusDescription(context, status),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Wiersz legendy dla pojedynczego statusu spisu.
class _ArkuszStatusLegendRow extends StatelessWidget {
  /// Tworzy wiersz legendy statusu spisu.
  const _ArkuszStatusLegendRow({required this.status});

  /// Status prezentowany w legendzie.
  final ArkuszElementStatusSpisu status;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        AppStatusBadge(
          label: status.localizedLabel(context),
          tone: status.tone,
          icon: status.icon,
          showBorder: false,
        ),
        Gaps.w12,
        Expanded(
          child: Padding(
            padding: const .only(top: Sizes.p4),
            child: AppText(
              status.description(context),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
