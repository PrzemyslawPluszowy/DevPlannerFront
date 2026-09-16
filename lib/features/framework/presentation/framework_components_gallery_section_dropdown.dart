part of 'framework_components_gallery_page.dart';

extension _DropdownSection on _FrameworkComponentsGalleryPageState {
  Widget _buildDropdownSection() {
    return _GallerySection(
      title: context.l10n.frameworkDropdownTitle,
      subtitle: context.l10n.frameworkDropdownSubtitle,
      codeSnippet: '''
AppDropdown<String>(
  value: selectedRange,
   labelText: context.l10n.frameworkDropdownLabel,
  options: const [
     AppDropdownOption(value: 'today', label: context.l10n.frameworkToday),
     AppDropdownOption(value: 'week', label: context.l10n.frameworkThisWeek),
  ],
  onChanged: (value) {},
)
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SizedBox(
            width: 280,
            child: AppDropdown<String>(
              value: selectedRange,
              labelText: context.l10n.frameworkOuterLabel,
              options: [
                AppDropdownOption(
                  value: 'today',
                  label: context.l10n.frameworkToday,
                  icon: Icons.today_rounded,
                ),
                AppDropdownOption(
                  value: 'week',
                  label: context.l10n.frameworkThisWeek,
                  icon: Icons.date_range_rounded,
                ),
              ],
              onChanged: (value) {
                if (value case final v?) {
                  _updateGalleryState(() => selectedRange = v);
                }
              },
            ),
          ),
          Gaps.h24,
          SizedBox(
            width: 280,
            child: AppDropdown<String>(
              value: selectedRange,
              inlineLabel: context.l10n.frameworkStatusLabel,
              hintText: context.l10n.frameworkChoose,
              options: [
                AppDropdownOption(
                  value: 'today',
                  label: context.l10n.frameworkToday,
                ),
                AppDropdownOption(
                  value: 'week',
                  label: context.l10n.frameworkThisWeek,
                ),
              ],
              onChanged: (value) {
                if (value case final v?) {
                  _updateGalleryState(() => selectedRange = v);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
