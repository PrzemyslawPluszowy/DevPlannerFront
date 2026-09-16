part of 'framework_components_gallery_page.dart';

extension _FormSectionSection on _FrameworkComponentsGalleryPageState {
  Widget _buildFormSectionSection(AppControlSize controlSize) {
    return _GallerySection(
      title: 'Form Section',
      subtitle: 'Sekcja formularza z naglowkiem i gridem 1/2/3 kolumn.',
      codeSnippet: '''
AppFormSection(
  title: 'Dane kontrahenta',
  items: [
    AppFormSectionItem(child: AppTextField(labelText: 'Nazwa')),
  ],
)
''',
      child: AppFormSection(
        controlSize: controlSize,
        title: 'Dane kontrahenta',
        description:
            'Przyklad docelowej sekcji CRM: desktop 3 kolumny, tablet 2, mobile 1.',
        headerActions: AppActionButton.text(
          label: 'Historia zmian',
          icon: Icons.history_rounded,
          tone: .neutral,
          size: controlSize,
          onPressed: () => _showHint('Historia zmian'),
        ),
        items: [
          const AppFormSectionItem(
            child: AppTextField(
              inlineLabel: 'Nazwa firmy',
              isRequired: true,
              hintText: 'Wpisz nazwę',
              prefixIcon: Icons.business_outlined,
            ),
          ),
          const AppFormSectionItem(
            child: AppTextField(
              inlineLabel: 'NIP',
              isRequired: true,
              hintText: '0000000000',
              keyboardType: .number,
            ),
          ),
          AppFormSectionItem(
            child: AppDropdown<String>(
              size: controlSize,
              value: selectedStatusFilter,
              inlineLabel: 'Status',
              isRequired: true,
              options: const [
                AppDropdownOption(value: 'all', label: 'Nowy'),
                AppDropdownOption(value: 'open', label: 'Aktywny'),
                AppDropdownOption(value: 'closed', label: 'Zablokowany'),
              ],
              onChanged: (value) {
                _updateGalleryState(() => selectedStatusFilter = value);
              },
            ),
          ),
          const AppFormSectionItem(
            child: AppTextField(
              inlineLabel: 'Miasto',
              hintText: 'np. Warszawa',
            ),
          ),
          const AppFormSectionItem(
            child: AppTextField(
              inlineLabel: 'Telefon',
              hintText: '+48 000 000 000',
              keyboardType: .phone,
            ),
          ),
          const AppFormSectionItem(
            child: AppTextField(
              inlineLabel: 'E-mail',
              hintText: 'mail@firma.pl',
              keyboardType: .emailAddress,
            ),
          ),
          AppFormSectionItem(
            tabletSpan: 2,
            desktopSpan: 3,
            height: 112,
            child: AppTextField(
              inlineLabel: 'Notatka',
              hintText: 'Uwagi handlowe i techniczne...',
              size: controlSize,
              minLines: 3,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
