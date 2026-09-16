part of 'framework_components_gallery_page.dart';

extension _DraggableSheetSection on _FrameworkComponentsGalleryPageState {
  Widget _buildDraggableSheetSection() {
    return _GallerySection(
      title: 'Draggable Sheet',
      subtitle:
          'Materialowy DraggableScrollableSheet: bottom + warianty middle left/center/right.',
      codeSnippet: '''
await AppDraggableSheet.show(
  context,
  title: 'Filtry',
  anchor: AppSheetAnchor.middleRight, // left / center / right
  width: 420,
  minHeight: 280,
  initialHeight: 460,
  maxHeight: 760,
  builder: (context, scrollController) => ListView(
    controller: scrollController,
    children: const [Text('Content')],
  ),
);
''',
      child: Wrap(
        spacing: Sizes.p12,
        runSpacing: Sizes.p12,
        children: [
          AppActionButton.outlined(
            label: 'Open Left',
            icon: Icons.vertical_split_rounded,
            tone: .neutral,
            onPressed: () => _openDraggablePreview(.middleLeft),
          ),
          AppActionButton.outlined(
            label: 'Open Center',
            icon: Icons.crop_square_rounded,
            tone: .neutral,
            onPressed: () => _openDraggablePreview(.middleCenter),
          ),
          AppActionButton.outlined(
            label: 'Open Right',
            icon: Icons.view_sidebar_outlined,
            tone: .neutral,
            onPressed: () => _openDraggablePreview(.middleRight),
          ),
        ],
      ),
    );
  }

  Future<void> _openDraggablePreview(AppSheetAnchor anchor) async {
    await AppDraggableSheet.show<void>(
      context,
      title: 'Filtry i szybkie akcje',
      anchor: anchor,
      width: 420,
      initialHeight: 460,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const .all(Sizes.p16),
          children: [
            const AppBanner(
              title: 'Podglad',
              message: 'To jest zawartosc draggable sheet.',
            ),
            Gaps.h12,
            const AppTextField(labelText: 'Fraza', hintText: 'Wpisz fraze...'),
            Gaps.h12,
            AppDropdown<String>(
              labelText: 'Status',
              value: 'open',
              options: const [
                AppDropdownOption(value: 'open', label: 'W toku'),
                AppDropdownOption(value: 'closed', label: 'Zamkniete'),
              ],
              onChanged: (_) {},
            ),
            Gaps.h12,
            AppDateRangePickerField(
              labelText: 'Zakres',
              value: AppDateRangeValue(
                start: DateTime(2026, 4),
                end: DateTime(2026, 4, 15),
              ),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035, 12, 31),
              onChanged: (_) {},
            ),
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: 'Anuluj',
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: 'Zastosuj',
                  icon: Icons.check_rounded,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
