part of 'framework_components_gallery_page.dart';

extension _StatusBadgesSection on _FrameworkComponentsGalleryPageState {
  Widget _buildStatusBadgesSection() {
    return const _GallerySection(
      title: 'Status Badges',
      subtitle:
          'Male statusy do tabel, kart i list: aktywny, szkic, w toku, blad.',
      codeSnippet: '''
AppStatusBadge(
  label: 'Aktywny',
  tone: AppStatusBadgeTone.success,
  icon: Icons.check_circle_outline_rounded,
)
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: [
              AppStatusBadge(
                label: 'Neutralny',
                icon: Icons.label_outline_rounded,
              ),
              AppStatusBadge(
                label: 'Informacja',
                tone: AppStatusBadgeTone.info,
                icon: Icons.info_outline_rounded,
              ),
              AppStatusBadge(
                label: 'Aktywny',
                tone: AppStatusBadgeTone.success,
                icon: Icons.check_circle_outline_rounded,
              ),
              AppStatusBadge(
                label: 'Weryfikacja',
                tone: AppStatusBadgeTone.warning,
                icon: Icons.schedule_rounded,
              ),
              AppStatusBadge(
                label: 'Blad',
                tone: AppStatusBadgeTone.danger,
                icon: Icons.error_outline_rounded,
              ),
            ],
          ),
          Gaps.h12,
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: [
              AppStatusBadge(
                label: 'Szkic',
                icon: Icons.edit_note_rounded,
              ),
              AppStatusBadge(
                label: 'Do wysylki',
                tone: AppStatusBadgeTone.info,
                icon: Icons.send_outlined,
              ),
              AppStatusBadge(
                label: 'Zaksiegowany',
                tone: AppStatusBadgeTone.success,
                icon: Icons.task_alt_rounded,
              ),
              AppStatusBadge(
                label: 'Wstrzymany',
                tone: AppStatusBadgeTone.warning,
                icon: Icons.pause_circle_outline_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
