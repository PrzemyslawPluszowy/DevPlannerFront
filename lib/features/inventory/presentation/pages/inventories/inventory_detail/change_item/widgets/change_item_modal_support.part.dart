part of '../change_item_modal.dart';

/// Karta informacyjna z podstawowymi danymi edytowanego elementu.
class _ItemInfoCard extends StatelessWidget {
  /// Tworzy karte podsumowania elementu.
  const _ItemInfoCard({required this.item});

  /// Edytowany element arkusza.
  final GetArkuszDetailsElementItem item;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final scanLabel = switch (item.kkWczytany) {
      false => intl.inventoryScannerNotRead,
      true => intl.inventoryScannerRead,
      _ => intl.inventoryUnknownWithCode('-'),
    };
    final scanColor = switch (item.kkWczytany) {
      false => context.colors.tertiary,
      true => context.colors.primary,
      _ => context.colors.onSurfaceVariant,
    };

    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p10),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          RichText(
            text: TextSpan(
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurface,
              ),
              children: [
                TextSpan(
                  text: '${intl.inventoryScan}: ',
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: .w700,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                TextSpan(
                  text: scanLabel,
                  style: context.text.bodySmall?.copyWith(
                    color: scanColor,
                    fontWeight: .w700,
                  ),
                ),
              ],
            ),
          ),
          Gaps.h4,
          _InfoRow(label: intl.id, value: '${item.id}'),
          _InfoRow(
            label: intl.inventoryRegisterNumberShort,
            value: _displayValue(item.nrewid),
          ),
          _InfoRow(label: intl.inventoryName, value: _displayValue(item.nazwa)),
          _InfoRow(
            label: intl.inventoryPerson,
            value: _displayValue(item.osoba),
          ),
          _InfoRow(
            label: intl.inventoryLocation,
            value: _displayValue(item.miejsce),
          ),
          _InfoRow(
            label: intl.inventoryPurchaseDate,
            value: item.dataZakupu.toAppDate(placeholder: '-'),
          ),
          _InfoRow(
            label: intl.inventoryValueP,
            value: item.wartoscP.toAppMoney(),
          ),
          _InfoRow(
            label: intl.inventoryValueA,
            value: item.wartoscA.toAppMoney(),
          ),
        ],
      ),
    );
  }
}

/// Wiersz danych w karcie informacyjnej elementu.
class _InfoRow extends StatelessWidget {
  /// Tworzy pojedynczy wiersz informacji.
  const _InfoRow({required this.label, required this.value});

  /// Etykieta pola.
  final String label;

  /// Wartosc pola.
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: Sizes.p2),
      child: RichText(
        text: TextSpan(
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurface,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: context.text.bodySmall?.copyWith(
                fontWeight: .w700,
                color: context.colors.onSurfaceVariant,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

/// Widok komunikatu bledu zapisu formularza.
class _ErrorBox extends StatelessWidget {
  /// Tworzy widok bledu formularza.
  const _ErrorBox({required this.message});

  /// Komunikat bledu do pokazania uzytkownikowi.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p10),
      decoration: BoxDecoration(
        color: context.colors.errorContainer.withValues(alpha: .35),
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        border: Border.all(
          color: context.colors.error.withValues(alpha: .35),
        ),
      ),
      child: AppText(
        message.trim(),
        style: context.text.bodySmall?.copyWith(
          color: context.colors.onErrorContainer,
          fontWeight: .w600,
        ),
      ),
    );
  }
}

String _displayValue(String? value) {
  final normalized = value?.trim();
  return switch (normalized) {
    final String v when v.isNotEmpty => v,
    _ => '-',
  };
}
