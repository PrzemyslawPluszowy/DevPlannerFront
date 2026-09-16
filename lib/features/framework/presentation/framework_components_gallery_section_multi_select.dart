part of 'framework_components_gallery_page.dart';

extension _MultiSelectSection on _FrameworkComponentsGalleryPageState {
  Widget _buildMultiSelectSection(AppControlSize controlSize) {
    return _GallerySection(
      title: 'Multi Select',
      subtitle: 'Wielokrotny wybor opcji w stylu formularza CRM.',
      codeSnippet: '''
AppMultiSelectDropdown<String>(
  labelText: 'Zakres',
  selectedValues: selectedScopes,
  options: const [
    AppMultiSelectOption(value: 'inventory', label: 'Inwentaryzacje'),
  ],
  onChanged: (values) {},
)
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            width: 320,
            child: AppMultiSelectDropdown<String>(
              size: controlSize,
              labelText: 'Uprawnienia modułowe',
              isRequired: true,
              hintText: 'Wybierz zakres',
              selectedValues: selectedScopes,
              options: const [
                AppMultiSelectOption(
                  value: 'inventory',
                  label: 'Inwentaryzacje',
                  icon: Icons.fact_check_outlined,
                ),
                AppMultiSelectOption(
                  value: 'orders',
                  label: 'Zamówienia',
                  icon: Icons.shopping_bag_outlined,
                ),
              ],
              onChanged: (values) {
                _updateGalleryState(() => selectedScopes = values);
              },
            ),
          ),
          Gaps.h24,
          SizedBox(
            width: 320,
            child: AppMultiSelectDropdown<String>(
              size: controlSize,
              inlineLabel: 'Uprawnienia',
              hintText: 'Wybierz',
              selectedValues: selectedScopes,
              options: const [
                AppMultiSelectOption(
                  value: 'inventory',
                  label: 'Inwentaryzacje',
                ),
                AppMultiSelectOption(value: 'orders', label: 'Zamówienia'),
              ],
              onChanged: (values) {
                _updateGalleryState(() => selectedScopes = values);
              },
            ),
          ),
        ],
      ),
    );
  }
}
