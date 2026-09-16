part of 'framework_components_gallery_page.dart';

extension _ModalStatesSection on _FrameworkComponentsGalleryPageState {
  Widget _buildModalStatesSection() {
    return _GallerySection(
      title: 'Modal + BLoC States',
      subtitle: 'Przyklad modalu z przeplywem initial/loading/loaded/error.',
      codeSnippet: '''
await AppModalSheet.show(
  context,
  title: 'Nowy dokument',
  body: AppAsyncStateBody(
    status: AppAsyncViewStatus.loaded,
    loadedBuilder: (_) => const Text('Content'),
  ),
);
''',
      child: Wrap(
        spacing: Sizes.p12,
        runSpacing: Sizes.p12,
        children: [
          AppActionButton.filled(
            label: 'Otworz modal',
            icon: Icons.web_asset_outlined,
            onPressed: _openBlocModalPreview,
          ),
          AppActionButton.outlined(
            label: 'Otworz side sheet',
            icon: Icons.view_sidebar_outlined,
            onPressed: _openBlocSideSheetPreview,
          ),
        ],
      ),
    );
  }
}
