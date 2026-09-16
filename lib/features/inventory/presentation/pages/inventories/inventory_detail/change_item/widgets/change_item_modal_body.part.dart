part of '../change_item_modal.dart';

const _nonSelectableStatusSpisuOptions = <ArkuszElementStatusSpisu>{
  ArkuszElementStatusSpisu.nowy,
  ArkuszElementStatusSpisu.niejednoznacznyKod,
};

/// Główna kolumna formularza modala zmiany elementu.
class _ChangeItemMainColumn extends StatelessWidget {
  /// Tworzy główny układ formularza.
  const _ChangeItemMainColumn({
    required this.item,
    required this.isSending,
    required this.submitError,
    required this.shouldShowDiscrepancySection,
    required this.shouldShowDiscrepancyDetailsSection,
    required this.inventoryStatus,
    required this.lockInventoryStatus,
    required this.statusSpisu,
    required this.likwidacja,
    required this.lockLiquidation,
    required this.nadwyzka,
    required this.lockSurplus,
    required this.nrewidController,
    required this.nowyKodKreskowyController,
    required this.usersRepository,
    required this.nowaOsobaController,
    required this.nowaNazwaController,
    required this.uwagiController,
    required this.lockManualCorrections,
    required this.validateNowyKodKreskowy,
    required this.onInventoryStatusChanged,
    required this.onStatusSpisuChanged,
    required this.onLikwidacjaChanged,
    required this.onSurplusChanged,
    required this.onTextChanged,
    required this.changesPreview,
    this.inlineLocationPanel,
  });

  final GetArkuszDetailsElementItem item;
  final bool isSending;
  final String? submitError;
  final bool shouldShowDiscrepancySection;
  final bool shouldShowDiscrepancyDetailsSection;
  final ArkuszElementInwentStatus inventoryStatus;
  final bool lockInventoryStatus;
  final ArkuszElementStatusSpisu? statusSpisu;
  final bool likwidacja;
  final bool lockLiquidation;
  final bool nadwyzka;
  final bool lockSurplus;
  final TextEditingController nrewidController;
  final TextEditingController nowyKodKreskowyController;
  final UsersRepository usersRepository;
  final SearchController nowaOsobaController;
  final TextEditingController nowaNazwaController;
  final TextEditingController uwagiController;
  final bool lockManualCorrections;
  final String? Function(String?) validateNowyKodKreskowy;
  final ValueChanged<ArkuszElementInwentStatus?> onInventoryStatusChanged;
  final ValueChanged<ArkuszElementStatusSpisu?> onStatusSpisuChanged;
  final ValueChanged<bool?> onLikwidacjaChanged;
  final ValueChanged<bool?> onSurplusChanged;
  final VoidCallback onTextChanged;
  final Widget? inlineLocationPanel;
  final Widget changesPreview;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final orderedStatusSpisuOptions = [
      ...kVisibleStatusSpisuOptions.where(
        (status) => !_nonSelectableStatusSpisuOptions.contains(status),
      ),
      ...kVisibleStatusSpisuOptions.where(
        (status) => _nonSelectableStatusSpisuOptions.contains(status),
      ),
    ];

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        _ItemInfoCard(item: item),
        Gaps.h12,
        if (submitError case final String message
            when message.trim().isNotEmpty) ...[
          _ErrorBox(message: message),
          Gaps.h12,
        ],
        _ChangeItemSectionCard(
          title: context.l10n.inventoryChangeItemResultTitle,
          children: [
            AppDropdown<ArkuszElementInwentStatus>(
              variant: .filled,
              size: .large,
              value: inventoryStatus,
              labelText: context.l10n.inventoryChangeItemResultLabel,
              hintText: context.l10n.inventoryChangeItemChooseResultHint,
              options: [
                ArkuszElementInwentStatus.brak.toDropdownOption(context),
                ArkuszElementInwentStatus.zgodny.toDropdownOption(context),
                ArkuszElementInwentStatus.przeniesiony.toDropdownOption(
                  context,
                ),
              ],
              onChanged: isSending || lockInventoryStatus
                  ? null
                  : onInventoryStatusChanged,
            ),
            Gaps.h8,
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _showInventoryResultHelpModal(context),
                icon: const Icon(Icons.help_outline_rounded),
                label: const Text('Jak ustawic status spisu'),
              ),
            ),
          ],
        ),
        Gaps.h8,
        if (shouldShowDiscrepancySection) ...[
          _ChangeItemSectionCard(
            title: context.l10n.inventoryChangeItemAdditionalTitle,
            children: [
              AppDropdown<ArkuszElementStatusSpisu?>(
                variant: .filled,
                size: .large,
                value: statusSpisu,
                labelText: context.l10n.inventoryChangeItemTypeLabel,
                hintText: statusSpisuNoSelectionLabel(context),
                enabled: !isSending,
                options: [
                  AppDropdownOption<ArkuszElementStatusSpisu?>(
                    value: null,
                    label: statusSpisuNoSelectionLabel(context),
                  ),
                  ...orderedStatusSpisuOptions.map(
                    (status) => AppDropdownOption<ArkuszElementStatusSpisu?>(
                      value: status,
                      label: status.localizedLabel(context),
                      icon: status.icon,
                      foregroundColor: status.dropdownForegroundColor(context),
                      enabled: !_nonSelectableStatusSpisuOptions.contains(
                        status,
                      ),
                    ),
                  ),
                ],
                onChanged: isSending ? null : onStatusSpisuChanged,
              ),
              Gaps.h8,
              LayoutBuilder(
                builder: (context, constraints) {
                  final useColumn = constraints.maxWidth < 720;
                  final statusWidgets = [
                    Expanded(
                      child: AppDropdown<bool>(
                        variant: .filled,
                        size: .large,
                        value: likwidacja,
                        labelText: intl.inventoryLiquidation,
                        hintText: intl.inventoryLiquidation,
                        enabled: !isSending && !lockLiquidation,
                        options: [
                          AppDropdownOption<bool>(value: false, label: intl.no),
                          AppDropdownOption<bool>(
                            value: true,
                            label: intl.yes,
                            foregroundColor: statusToneForegroundColor(
                              context,
                              AppStatusBadgeTone.danger,
                            ),
                          ),
                        ],
                        onChanged: isSending || lockLiquidation
                            ? null
                            : onLikwidacjaChanged,
                      ),
                    ),
                    Expanded(
                      child: AppDropdown<bool>(
                        variant: .filled,
                        size: .large,
                        value: nadwyzka,
                        labelText: intl.inventorySurplus,
                        hintText: intl.inventorySurplus,
                        enabled: !isSending && !lockSurplus,
                        options: [
                          AppDropdownOption<bool>(value: false, label: intl.no),
                          AppDropdownOption<bool>(
                            value: true,
                            label: intl.yes,
                            foregroundColor: statusToneForegroundColor(
                              context,
                              AppStatusBadgeTone.warning,
                            ),
                          ),
                        ],
                        onChanged: isSending || lockSurplus
                            ? null
                            : onSurplusChanged,
                      ),
                    ),
                  ];

                  if (useColumn) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: statusWidgets[0],
                        ),
                        Gaps.h8,
                        SizedBox(
                          width: double.infinity,
                          child: statusWidgets[1],
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: .start,
                    children: [
                      statusWidgets[0],
                      Gaps.w8,
                      statusWidgets[1],
                    ],
                  );
                },
              ),
              Gaps.h8,
              AppText(
                'Dodatkowe ustalenia opisuja rodzaj sytuacji. '
                'Nadwyzka oznacza, ze element znaleziono w innym miejscu niz wynika z ewidencji. '
                'Sekcja lokalizacji ponizej pokazuje lub pozwala wskazac miejsce, w ktorym element faktycznie znaleziono.',
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Gaps.h8,
        ],
        if (shouldShowDiscrepancyDetailsSection) ...[
          _ChangeItemSectionCard(
            title: context.l10n.inventoryLocationSection,
            children: [
              ?inlineLocationPanel,
            ],
          ),
          Gaps.h8,
        ],
        _ChangeItemSectionCard(
          title: context.l10n.inventoryChangeItemCorrectionTitle,
          children: [
            // Tymczasowo ukryte: zmiana numeru ewidencyjnego.
            // AppTextField(
            //   controller: nrewidController,
            //   enabled: !isSending && !lockManualCorrections,
            //   labelText: intl.inventoryRegisterNumber,
            //   hintText: _displayValue(item.nrewid),
            //   onChanged: (_) => onTextChanged(),
            // ),
            // Gaps.h8,
            AppTextField(
              controller: nowyKodKreskowyController,
              enabled: !isSending && !lockManualCorrections,
              labelText: intl.inventoryNewBarcode,
              hintText: _displayValue(item.kodKreskowy?.toString()),
              validator: validateNowyKodKreskowy,
              onChanged: (_) => onTextChanged(),
            ),
            Gaps.h8,
            InventoryPersonSuggestionField(
              repository: usersRepository,
              controller: nowaOsobaController,
              enabled: !isSending && !lockManualCorrections,
              labelText: intl.inventoryNewPerson,
              hintText: _displayValue(item.osoba),
              onChanged: onTextChanged,
            ),
            Gaps.h8,
            AppTextField(
              controller: nowaNazwaController,
              enabled: !isSending && !lockManualCorrections,
              labelText: intl.inventoryNewName,
              hintText: _displayValue(item.nazwa),
              onChanged: (_) => onTextChanged(),
            ),
            Gaps.h8,
            AppTextField(
              labelText: intl.inventoryRemarks,
              controller: uwagiController,
              enabled: !isSending && !lockManualCorrections,
              hintText: intl.inventoryLocalRemarksHint,
              minLines: 3,
              maxLines: 3,
              onChanged: (_) => onTextChanged(),
            ),
          ],
        ),
        Gaps.h12,
        changesPreview,
      ],
    );
  }
}

Future<void> _showInventoryResultHelpModal(BuildContext context) {
  Widget sectionTitle(BuildContext context, String text) {
    return AppText(
      text,
      style: context.text.titleSmall?.copyWith(fontWeight: .w700),
    );
  }

  Widget bullet(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Icon(
            Icons.circle,
            size: 8,
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Gaps.w8,
        Expanded(
          child: AppText(
            text,
            style: context.text.bodyMedium,
          ),
        ),
      ],
    );
  }

  return AppModalSheet.show<void>(
    context,
    title: 'Instrukcja wyniku spisu',
    subtitle: 'Jak ustawic status elementu',
    body: Builder(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle(context, 'Statusy wyniku spisu'),
            Gaps.h8,
            Wrap(
              spacing: Sizes.p8,
              runSpacing: Sizes.p8,
              children: [
                ArkuszElementInwentStatus.zgodny.toBadge(context),
                ArkuszElementInwentStatus.przeniesiony.toBadge(context),
                ArkuszElementInwentStatus.brak.toBadge(context),
              ],
            ),
            Gaps.h8,
            bullet(
              context,
              '"Jest" - podstawowy status po potwierdzeniu elementu.',
            ),
            Gaps.h8,
            bullet(
              context,
              '"Jest (niezgodnosc)" - status tymczasowy konfliktu (np. znaleziony_w_innej_firmie, niejednoznaczny_kod).',
            ),
            Gaps.h8,
            bullet(
              context,
              'Po wyjasnieniu konfliktu recznie zmien na "Jest".',
            ),
            Gaps.h12,
            sectionTitle(context, 'Raporty'),
            Gaps.h8,
            bullet(
              context,
              'Nadwyzki obejmuja: nadwyzka, nowy, zakupiony_w_trakcie.',
            ),
            Gaps.h8,
            bullet(
              context,
              'Status "nowy" tworzy sie automatycznie podczas skanowania i wymaga recznej weryfikacji przez komisje.',
            ),
            Gaps.h8,
            bullet(
              context,
              'sprzedany_w_trakcie nie trafia do Nadwyzek; trafia do sprzedane_w_trakcie oraz braki_nieskompensowane.',
            ),
            Gaps.h8,
            bullet(
              context,
              'znaleziony_w_innej_firmie trafia do raportu wewnetrznego i nie trafia do standardowych raportow Nadwyzki/Kompensaty.',
            ),
          ],
        );
      },
    ),
  );
}
