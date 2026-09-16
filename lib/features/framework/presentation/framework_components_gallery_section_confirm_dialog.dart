part of 'framework_components_gallery_page.dart';

extension _ConfirmDialogSection on _FrameworkComponentsGalleryPageState {
  Widget _buildConfirmDialogSection() {
    return _GallerySection(
      title: 'Confirm Dialog',
      subtitle:
          'Potwierdzenia dla usuwania, opuszczania bez zapisu i akcji krytycznych.',
      codeSnippet: '''
final confirmed = await AppConfirmDialog.show(
  context,
  title: 'Usun dokument?',
  message: 'Tej operacji nie da sie cofnac.',
  confirmLabel: 'Usun',
  tone: AppConfirmDialogTone.danger,
);
''',
      child: Wrap(
        spacing: Sizes.p8,
        runSpacing: Sizes.p8,
        children: [
          AppActionButton.outlined(
            label: 'Opusc bez zapisu',
            icon: Icons.exit_to_app_rounded,
            tone: .neutral,
            onPressed: () async {
              final confirmed = await AppConfirmDialog.show(
                context,
                title: 'Opuścić formularz?',
                message: 'Niezapisane zmiany zostana utracone.',
                confirmLabel: 'Opuść',
                tone: AppConfirmDialogTone.warning,
              );
              if (confirmed && mounted) {
                _showHint('Opuść');
              }
            },
          ),
          AppActionButton.filled(
            label: 'Usun rekord',
            icon: Icons.delete_outline_rounded,
            tone: .danger,
            onPressed: () async {
              final confirmed = await AppConfirmDialog.show(
                context,
                title: 'Usun rekord?',
                message: 'Tej operacji nie da sie cofnac.',
                confirmLabel: 'Usun',
                tone: AppConfirmDialogTone.danger,
              );
              if (confirmed && mounted) {
                _showHint('Usun');
              }
            },
          ),
        ],
      ),
    );
  }
}
