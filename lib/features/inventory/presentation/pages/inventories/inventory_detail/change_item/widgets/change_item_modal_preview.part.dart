part of '../change_item_modal.dart';

/// Podgląd zmian przed zapisaniem formularza.
class _ChangeItemChangesPreview extends StatelessWidget {
  /// Tworzy kartę podglądu zmian.
  const _ChangeItemChangesPreview({
    required this.item,
    required this.stanInwent,
    required this.statusSpisu,
    required this.likwidacja,
    required this.nadwyzka,
    required this.nrewid,
    required this.nowyKodKreskowy,
    required this.nowaOsoba,
    required this.nowaNazwa,
    required this.uwagi,
    required this.submittedLocationId,
    required this.submittedCompanyId,
    required this.selectedLocationLabel,
    required this.selectedCompanyLabel,
  });

  final GetArkuszDetailsElementItem item;
  final ArkuszElementInwentStatus stanInwent;
  final ArkuszElementStatusSpisu? statusSpisu;
  final bool likwidacja;
  final bool nadwyzka;
  final String? nrewid;
  final String? nowyKodKreskowy;
  final String? nowaOsoba;
  final String? nowaNazwa;
  final String? uwagi;
  final int? submittedLocationId;
  final int? submittedCompanyId;
  final String? selectedLocationLabel;
  final String? selectedCompanyLabel;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final changes = <({String label, String from, String to})>[];

    final currentInwent =
        item.inventoryStatus ?? ArkuszElementInwentStatus.brak;
    if (currentInwent != stanInwent) {
      changes.add((
        label: context.l10n.inventoryInventoryStateAvailable,
        from: inventoryAvailabilityLabel(context, currentInwent),
        to: inventoryAvailabilityLabel(context, stanInwent),
      ));
    }

    if (item.statusSpisu != statusSpisu) {
      changes.add((
        label: context.l10n.inventoryChangeItemStatusTitle,
        from: item.statusSpisu == null
            ? statusSpisuNoSelectionLabel(context)
            : item.statusSpisu!.localizedLabel(context),
        to: statusSpisu == null
            ? statusSpisuNoSelectionLabel(context)
            : statusSpisu!.localizedLabel(context),
      ));
    }

    if (item.isLiquidated != likwidacja) {
      changes.add((
        label: intl.inventoryLiquidation,
        from: item.isLiquidated ? intl.yes : intl.no,
        to: likwidacja ? intl.yes : intl.no,
      ));
    }

    if (item.hasSurplus != nadwyzka) {
      changes.add((
        label: intl.inventorySurplus,
        from: item.hasSurplus ? intl.yes : intl.no,
        to: nadwyzka ? intl.yes : intl.no,
      ));
    }

    if (nrewid != item.nrewid) {
      changes.add((
        label: intl.inventoryRegisterNumber,
        from: _displayValue(item.nrewid),
        to: nrewid ?? '-',
      ));
    }

    if (nowyKodKreskowy case final String value
        when value != item.kodKreskowy?.toString()) {
      changes.add((
        label: intl.inventoryNewBarcode,
        from: _displayValue(item.kodKreskowy?.toString()),
        to: value,
      ));
    }

    if (nowaOsoba case final String value when value != item.osoba) {
      changes.add((
        label: intl.inventoryNewPerson,
        from: _displayValue(item.osoba),
        to: value,
      ));
    }

    if (nowaNazwa case final String value when value != item.nazwa) {
      changes.add((
        label: intl.inventoryNewName,
        from: _displayValue(item.nazwa),
        to: value,
      ));
    }

    if (uwagi != item.uwagiLoc) {
      changes.add((
        label: intl.inventoryRemarks,
        from: _displayValue(item.uwagiLoc),
        to: uwagi ?? '-',
      ));
    }

    if (submittedLocationId != item.nadwIdmiejsce) {
      changes.add((
        label: intl.inventoryLocation,
        from: _displayValue(item.nadwMiejsce ?? item.miejsce),
        to: submittedLocationId == null ? '-' : (selectedLocationLabel ?? '-'),
      ));
    }

    if (submittedCompanyId != item.nadwIdFirmy) {
      changes.add((
        label: intl.inventoryCompany,
        from: _displayValue(item.nadwFirma),
        to: submittedCompanyId == null ? '-' : (selectedCompanyLabel ?? '-'),
      ));
    }

    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p10),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: switch (changes.isEmpty) {
        true => AppText(
          'Brak zmian do zapisania.',
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        false => Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            AppText(
              'Podgląd zmian',
              style: context.text.labelLarge?.copyWith(fontWeight: .w700),
            ),
            Gaps.h8,
            ...changes.map(
              (entry) => Padding(
                padding: const .only(bottom: Sizes.p8),
                child: AppText(
                  '${entry.label}: ${entry.from} -> ${entry.to}',
                  style: context.text.bodySmall,
                ),
              ),
            ),
          ],
        ),
      },
    );
  }
}
