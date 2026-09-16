part of 'framework_components_gallery_page.dart';

extension _DatePickersSection on _FrameworkComponentsGalleryPageState {
  Widget _buildDatePickersSection(AppControlSize controlSize) {
    return _GallerySection(
      title: 'Date Pickers',
      subtitle: 'Pojedyncza data i selector zakresu dat w stylu formularza.',
      codeSnippet: '''
AppDateRangePickerField(
  labelText: 'Zakres raportu',
  value: selectedDateRange,
  firstDate: DateTime(2020, 1, 1),
  lastDate: DateTime(2035, 12, 31),
  onChanged: (value) {},
)
''',
      child: Wrap(
        spacing: Sizes.p12,
        runSpacing: Sizes.p12,
        children: [
          SizedBox(
            width: 280,
            child: AppDatePickerField(
              size: controlSize,
              labelText: 'Data dokumentu',
              isRequired: true,
              value: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035, 12, 31),
              onChanged: (value) {
                _updateGalleryState(() => selectedDate = value);
              },
            ),
          ),
          SizedBox(
            width: 360,
            child: AppDateRangePickerField(
              size: controlSize,
              labelText: 'Zakres raportu',
              value: selectedDateRange,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035, 12, 31),
              onChanged: (value) {
                _updateGalleryState(() => selectedDateRange = value);
              },
            ),
          ),
          SizedBox(
            width: 280,
            child: AppDateRangePickerField(
              size: controlSize,
              inlineLabel: 'Filtruj daty',
              hintText: 'Wybierz',
              value: selectedDateRange,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035, 12, 31),
              variant: AppDateFieldVariant.filled,
              onChanged: (value) {
                _updateGalleryState(() => selectedDateRange = value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
