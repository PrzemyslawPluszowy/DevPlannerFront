part of '../change_item_modal.dart';

/// Obszar drzewa lokalizacji wraz z filtrem firm.
class _ChangeItemLocationTreeArea extends StatelessWidget {
  /// Tworzy obszar wyboru lokalizacji.
  const _ChangeItemLocationTreeArea({
    required this.isSending,
    required this.nadwyzka,
    required this.isFoundInOtherCompany,
    required this.companiesFuture,
    required this.locations,
    required this.selectedCompanyId,
    required this.selectedLocationId,
    required this.companyOptionLabel,
    required this.filterLocationCompanies,
    required this.onSyncSelectedCompany,
    required this.onCompanySelected,
    required this.onSyncSelectedLocationLabel,
    required this.onLocationSelected,
    required this.companiesErrorMessage,
  });

  final bool isSending;
  final bool nadwyzka;
  final bool isFoundInOtherCompany;
  final Future<List<GetFirmyItem>> companiesFuture;
  final List<GetMiejscaItem> locations;
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
  final String Function(Object? error) companiesErrorMessage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GetFirmyItem>>(
      future: companiesFuture,
      builder: (context, snapshot) {
        final availableCompanies = switch (snapshot.data) {
          final List<GetFirmyItem> items => filterLocationCompanies(
            items,
            locations,
          ),
          _ => const <GetFirmyItem>[],
        };
        onSyncSelectedCompany(availableCompanies, locations);

        final filteredLocations = switch (selectedCompanyId) {
          final int companyId =>
            locations
                .where((location) => location.idFirmy == companyId)
                .toList(growable: false),
          _ => const <GetMiejscaItem>[],
        };

        return Column(
          crossAxisAlignment: .start,
          children: [
            if (snapshot.hasError) ...[
              AppText(
                companiesErrorMessage(snapshot.error),
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                  fontWeight: .w600,
                ),
              ),
              Gaps.h12,
            ] else if (availableCompanies.isNotEmpty) ...[
              _ChangeItemLocationCompanyDropdown(
                isSending: isSending,
                selectedCompanyId: selectedCompanyId,
                companies: availableCompanies,
                companyOptionLabel: companyOptionLabel,
                labelText: nadwyzka
                    ? 'Firma w inwentaryzacji'
                    : 'Firma spoza inwentaryzacji',
                helperText: isFoundInOtherCompany
                    ? context.l10n.inventoryChooseCompanyOutsideMessage
                    : context.l10n.inventoryChooseCompanyInsideMessage,
                onChanged: onCompanySelected,
              ),
              Gaps.h12,
            ],
            Expanded(
              child: selectedCompanyId == null
                  ? AppEmptyState.noData(
                      title: context.l10n.inventoryChooseCompanyTitle,
                      message:
                          'Najpierw wybierz firme, aby zawezic drzewo miejsc.',
                      compact: true,
                    )
                  : _ChangeItemLocationTree(
                      isSending: isSending,
                      locations: filteredLocations,
                      selectedLocationId: selectedLocationId,
                      onSyncSelectedLocationLabel: onSyncSelectedLocationLabel,
                      onLocationSelected: onLocationSelected,
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// Drzewo miejsc dla wyboru lokalizacji elementu.
class _ChangeItemLocationTree extends StatelessWidget {
  /// Tworzy drzewo miejsc.
  const _ChangeItemLocationTree({
    required this.isSending,
    required this.locations,
    required this.selectedLocationId,
    required this.onSyncSelectedLocationLabel,
    required this.onLocationSelected,
  });

  final bool isSending;
  final List<GetMiejscaItem> locations;
  final int? selectedLocationId;
  final ValueChanged<List<GetMiejscaItem>> onSyncSelectedLocationLabel;
  final ValueChanged<GetMiejscaItem> onLocationSelected;

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return AppEmptyState.noData(
        title: context.l10n.inventoryNoLocationsTitle,
        message: context.l10n.inventoryLocationsBackendEmptyMessage,
        compact: true,
      );
    }

    onSyncSelectedLocationLabel(locations);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: AppTree<GetMiejscaItem>(
        padding: const .all(Sizes.p8),
        itemSpacing: Sizes.p2,
        nodes: _buildLocationNodes(context),
      ),
    );
  }

  List<AppTreeNode<GetMiejscaItem>> _buildLocationNodes(BuildContext context) {
    final parentUsesRecordId = createArkuszParentUsesRecordId(locations);
    final locationsByTreeKey = {
      for (final location in locations)
        createArkuszTreeKey(location, parentUsesRecordId): location,
    };
    final childrenByParent = <int, List<GetMiejscaItem>>{};
    for (final location in locations) {
      final parentId = location.idparent ?? 0;
      childrenByParent.putIfAbsent(parentId, () => []).add(location);
    }

    final roots =
        locations
            .where((location) {
              final parentId = location.idparent ?? 0;
              return parentId == 0 || !locationsByTreeKey.containsKey(parentId);
            })
            .toList(growable: false)
          ..sort(_compareTreeLocations);

    return roots
        .map(
          (location) => _buildLocationNode(
            context,
            location: location,
            childrenByParent: childrenByParent,
            parentUsesRecordId: parentUsesRecordId,
          ),
        )
        .toList(growable: false);
  }

  AppTreeNode<GetMiejscaItem> _buildLocationNode(
    BuildContext context, {
    required GetMiejscaItem location,
    required Map<int, List<GetMiejscaItem>> childrenByParent,
    required bool parentUsesRecordId,
  }) {
    final children = List<GetMiejscaItem>.from(
      childrenByParent[createArkuszTreeKey(location, parentUsesRecordId)] ??
          const <GetMiejscaItem>[],
    )..sort(_compareTreeLocations);

    return AppTreeNode<GetMiejscaItem>(
      value: location,
      title: _locationTreeTitle(context, location),
      titleSpan: _locationTreeTitleSpan(context, location),
      subtitle: _locationTreeSubtitle(location),
      selected: selectedLocationId == location.idMiejsca,
      enabled: !isSending,
      leading: Icon(
        children.isEmpty ? Icons.place_outlined : Icons.keyboard_arrow_right,
        size: Sizes.p18,
      ),
      trailing: selectedLocationId == location.idMiejsca
          ? Icon(Icons.check_circle_rounded, color: context.colors.primary)
          : null,
      initiallyExpanded: selectedLocationId == location.idMiejsca,
      children: [
        for (final child in children)
          _buildLocationNode(
            context,
            location: child,
            childrenByParent: childrenByParent,
            parentUsesRecordId: parentUsesRecordId,
          ),
      ],
      onTap: (_) {
        if (isSending) {
          return;
        }
        onLocationSelected(location);
      },
    );
  }

  String _locationTreeTitle(BuildContext context, GetMiejscaItem location) {
    final name = (location.nazwa ?? '').trim();
    return name.isNotEmpty
        ? name
        : context.l10n.inventoryIdWithValue(location.idMiejsca);
  }

  InlineSpan _locationTreeTitleSpan(
    BuildContext context,
    GetMiejscaItem location,
  ) {
    final baseTitle = _locationTreeTitle(context, location);
    final level = (location.lvl ?? '').trim();
    if (level.isEmpty) {
      return TextSpan(text: baseTitle);
    }

    return TextSpan(
      children: [
        TextSpan(text: baseTitle),
        TextSpan(
          text: ' ($level)',
          style: const TextStyle(fontStyle: .italic),
        ),
      ],
    );
  }

  String? _locationTreeSubtitle(GetMiejscaItem location) {
    final base = (location.baza ?? '').trim();
    if (base.isEmpty) {
      return null;
    }
    return base;
  }

  int _compareTreeLocations(GetMiejscaItem left, GetMiejscaItem right) {
    final leftName = (left.nazwa ?? '').trim().toLowerCase();
    final rightName = (right.nazwa ?? '').trim().toLowerCase();
    return leftName.compareTo(rightName);
  }
}
