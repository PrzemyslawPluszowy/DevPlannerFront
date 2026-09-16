part of 'framework_components_gallery_page.dart';

extension _SearchDropdownSection on _FrameworkComponentsGalleryPageState {
  Widget _buildSearchDropdownSection(AppControlSize controlSize) {
    return _GallerySection(
      title: 'Search Dropdown',
      subtitle: 'Rozwijane wyszukiwanie (SearchAnchor) do krótkich lookupów.',
      codeSnippet: '''
AppSearchDropdown<String>(
  hintText: 'Szukaj kontrahenta...',
  options: const [
    AppSearchDropdownOption(value: 'id', label: 'Nazwa'),
  ],
  onSelected: (option) {},
)
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AppSearchDropdown<String>(
            size: controlSize,
            width: 320,
            hintText: 'Szukaj kontrahenta...',
            options: const [
              AppSearchDropdownOption(
                value: 'excellent',
                label: 'Excellent Sp. z o.o.',
                subtitle: 'NIP: 5250000001',
                icon: Icons.business_outlined,
                keywords: ['warszawa', 'crm'],
              ),
              AppSearchDropdownOption(
                value: 'nova',
                label: 'Nova Trade',
                subtitle: 'NIP: 5250000002',
                icon: Icons.storefront_outlined,
                keywords: ['hurt', 'poznan'],
              ),
              AppSearchDropdownOption(
                value: 'argo',
                label: 'Argo Logistics',
                subtitle: 'NIP: 5250000003',
                icon: Icons.local_shipping_outlined,
                keywords: ['wroclaw', 'transport'],
              ),
            ],
            onChangedDebounced: (query) {
              _showHint('Search debounced: $query');
            },
            onSelected: (option) {
              _updateGalleryState(() => selectedCustomerLabel = option.label);
              _showHint('Wybrano: ${option.label}');
            },
          ),
          Gaps.h8,
          Text(
            'Wybrany: $selectedCustomerLabel',
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
