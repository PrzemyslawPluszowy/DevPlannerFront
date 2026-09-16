part of '../change_item_modal.dart';

/// Panel wyboru lokalizacji dla danych niezgodności.
class _ChangeItemLocationPanelCard extends StatelessWidget {
  /// Tworzy panel lokalizacji z drzewem miejsc.
  const _ChangeItemLocationPanelCard({
    required this.isSending,
    required this.nadwyzka,
    required this.isFoundInOtherCompany,
    required this.selectedLocationLabel,
    required this.locationError,
    required this.locationsFuture,
    required this.companiesFuture,
    required this.selectedCompanyId,
    required this.selectedLocationId,
    required this.companyOptionLabel,
    required this.filterLocationCompanies,
    required this.onSyncSelectedCompany,
    required this.onCompanySelected,
    required this.onSyncSelectedLocationLabel,
    required this.onLocationSelected,
    required this.locationsErrorMessage,
    required this.companiesErrorMessage,
  });

  final bool isSending;
  final bool nadwyzka;
  final bool isFoundInOtherCompany;
  final String? selectedLocationLabel;
  final String? locationError;
  final Future<List<GetMiejscaItem>> locationsFuture;
  final Future<List<GetFirmyItem>> companiesFuture;
  final int? selectedCompanyId;
  final int? selectedLocationId;
  final String Function(GetFirmyItem company) companyOptionLabel;
  final List<GetFirmyItem> Function(
    List<GetFirmyItem> companies,
    List<GetMiejscaItem> locations,
  )
  filterLocationCompanies;
  final void Function(List<GetFirmyItem>, List<GetMiejscaItem>)
  onSyncSelectedCompany;
  final ValueChanged<GetFirmyItem> onCompanySelected;
  final ValueChanged<List<GetMiejscaItem>> onSyncSelectedLocationLabel;
  final ValueChanged<GetMiejscaItem> onLocationSelected;
  final String Function(Object? error) locationsErrorMessage;
  final String Function(Object? error) companiesErrorMessage;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return _ChangeItemSectionCard(
      title: nadwyzka ? 'Miejsce nadwyzki' : intl.inventoryLocation,
      children: [
        Container(
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
              switch (selectedLocationLabel) {
                final String label when label.trim().isNotEmpty => Container(
                  width: double.infinity,
                  padding: const .all(Sizes.p10),
                  decoration: BoxDecoration(
                    color: context.colors.primaryContainer,
                    borderRadius: const BorderRadius.all(
                      .circular(Sizes.p8),
                    ),
                    border: Border.all(color: context.colors.primary),
                  ),
                  child: Row(
                    crossAxisAlignment: .start,
                    children: [
                      Icon(
                        Icons.place_rounded,
                        color: context.colors.onPrimaryContainer,
                        size: Sizes.p18,
                      ),
                      Gaps.w8,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            AppText(
                              'Wybrane miejsce',
                              style: context.text.labelMedium?.copyWith(
                                color: context.colors.onPrimaryContainer,
                                fontWeight: .w700,
                              ),
                            ),
                            Gaps.h4,
                            AppText(
                              label.trim(),
                              style: context.text.bodyMedium?.copyWith(
                                color: context.colors.onPrimaryContainer,
                                fontWeight: .w600,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _ => AppText(
                  intl.inventorySelectLocationFromTree,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              },
              if (locationError case final String error
                  when error.trim().isNotEmpty) ...[
                Gaps.h8,
                AppText(
                  error.trim(),
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.error,
                    fontWeight: .w600,
                  ),
                ),
              ],
              Gaps.h12,
              SizedBox(
                height: 480,
                child: FutureBuilder<List<GetMiejscaItem>>(
                  future: locationsFuture,
                  builder: (context, snapshot) {
                    return switch (snapshot.connectionState) {
                      ConnectionState.waiting => const Center(
                        child: AppSpinner(),
                      ),
                      _ when snapshot.hasError => AppEmptyState.error(
                        title: context.l10n.inventoryLoadLocationsErrorTitle,
                        message: locationsErrorMessage(snapshot.error),
                        compact: true,
                      ),
                      _ => _buildLocationPanelBody(
                        context,
                        locations: snapshot.data ?? const <GetMiejscaItem>[],
                      ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPanelBody(
    BuildContext context, {
    required List<GetMiejscaItem> locations,
  }) {
    return _ChangeItemLocationTreeArea(
      isSending: isSending,
      nadwyzka: nadwyzka,
      isFoundInOtherCompany: isFoundInOtherCompany,
      companiesFuture: companiesFuture,
      locations: locations,
      selectedCompanyId: selectedCompanyId,
      selectedLocationId: selectedLocationId,
      companyOptionLabel: companyOptionLabel,
      filterLocationCompanies: filterLocationCompanies,
      onSyncSelectedCompany: onSyncSelectedCompany,
      onCompanySelected: onCompanySelected,
      onSyncSelectedLocationLabel: onSyncSelectedLocationLabel,
      onLocationSelected: onLocationSelected,
      companiesErrorMessage: companiesErrorMessage,
    );
  }
}
