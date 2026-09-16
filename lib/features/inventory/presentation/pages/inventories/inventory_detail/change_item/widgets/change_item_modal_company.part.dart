part of '../change_item_modal.dart';

/// Dropdown firmy nad drzewem lokalizacji.
class _ChangeItemLocationCompanyDropdown extends StatelessWidget {
  /// Tworzy dropdown firmy filtrowanej zależnie od typu niezgodności.
  const _ChangeItemLocationCompanyDropdown({
    required this.isSending,
    required this.selectedCompanyId,
    required this.companies,
    required this.companyOptionLabel,
    required this.labelText,
    required this.helperText,
    required this.onChanged,
  });

  final bool isSending;
  final int? selectedCompanyId;
  final List<GetFirmyItem> companies;
  final String Function(GetFirmyItem company) companyOptionLabel;
  final String labelText;
  final String helperText;
  final ValueChanged<GetFirmyItem> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        AppDropdown<int>(
          variant: .filled,
          size: .large,
          value: selectedCompanyId,
          labelText: labelText,
          hintText: labelText,
          options: companies
              .map(
                (company) => AppDropdownOption<int>(
                  value: company.idFirmy,
                  label: companyOptionLabel(company),
                ),
              )
              .toList(growable: false),
          onChanged: isSending
              ? null
              : (companyId) {
                  if (companyId == null) {
                    return;
                  }
                  final selected = companies
                      .where((company) => company.idFirmy == companyId)
                      .firstOrNull;
                  if (selected == null) {
                    return;
                  }
                  onChanged(selected);
                },
        ),
        Gaps.h4,
        AppText(
          helperText,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Prosta karta sekcji w formularzu modala.
class _ChangeItemSectionCard extends StatelessWidget {
  /// Tworzy kartę sekcji formularza.
  const _ChangeItemSectionCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AppText(
            title,
            style: context.text.labelLarge?.copyWith(fontWeight: .w700),
          ),
          Gaps.h12,
          ...children,
        ],
      ),
    );
  }
}
