part of 'framework_components_gallery_page.dart';

extension _FiltersBarSection on _FrameworkComponentsGalleryPageState {
  Widget _buildFiltersBarSection(AppControlSize controlSize) {
    return _GallerySection(
      title: 'Filters Bar',
      subtitle: 'Prosty zestaw: search + 2 dropdowny + akcje.',
      codeSnippet: '''
Wrap(
  spacing: Sizes.p8,
  children: [
    AppSearchTextField(controller: searchController),
    AppDropdown<String>(value: status, options: statusOptions, onChanged: ...),
    AppActionButton.filled(label: 'Zastosuj', icon: Icons.filter_alt_rounded),
  ],
)
''',
      child: Container(
        padding: const .all(Sizes.p12),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
          border: Border.all(color: context.colors.outlineVariant),
        ),
        child: Wrap(
          spacing: Sizes.p8,
          runSpacing: Sizes.p8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 220,
              child: AppSearchTextField(
                size: controlSize,
                controller: filtersSearchController,
                debounce: const Duration(milliseconds: 400),
                onRawChanged: (value) {
                  _showHint('Raw: $value');
                },
                onChanged: (value) {
                  _showHint('Szukaj: $value');
                },
              ),
            ),
            SizedBox(
              width: 200,
              child: AppDropdown<String>(
                size: controlSize,
                value: selectedStatusFilter,
                labelText: 'Status',
                options: const [
                  AppDropdownOption(value: 'all', label: 'Wszystkie'),
                  AppDropdownOption(value: 'open', label: 'W toku'),
                  AppDropdownOption(value: 'closed', label: 'Zamknięte'),
                  AppDropdownOption(value: 'archived', label: 'Archiwum'),
                ],
                onChanged: (value) {
                  _updateGalleryState(() => selectedStatusFilter = value);
                },
              ),
            ),
            SizedBox(
              width: 200,
              child: AppDropdown<String>(
                size: controlSize,
                value: selectedOwnerFilter,
                labelText: 'Właściciel',
                options: const [
                  AppDropdownOption(value: 'all', label: 'Wszyscy'),
                  AppDropdownOption(value: 'anna', label: 'Anna'),
                  AppDropdownOption(value: 'marek', label: 'Marek'),
                  AppDropdownOption(value: 'kasia', label: 'Kasia'),
                ],
                onChanged: (value) {
                  _updateGalleryState(() => selectedOwnerFilter = value);
                },
              ),
            ),
            AppActionButton.text(
              label: 'Reset',
              icon: Icons.restart_alt_rounded,
              tone: .neutral,
              size: controlSize,
              onPressed: () {
                _updateGalleryState(() {
                  filtersSearchController.reset();
                  selectedStatusFilter = 'all';
                  selectedOwnerFilter = 'all';
                });
                _showHint('Reset filtrow');
              },
            ),
            AppActionButton.filled(
              label: 'Zastosuj',
              icon: Icons.filter_alt_rounded,
              size: controlSize,
              onPressed: () => _showHint('Zastosuj filtry'),
            ),
          ],
        ),
      ),
    );
  }
}
