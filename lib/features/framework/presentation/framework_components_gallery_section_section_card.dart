part of 'framework_components_gallery_page.dart';

extension _SectionCardSection on _FrameworkComponentsGalleryPageState {
  Widget _buildSectionCardSection() {
    return _GallerySection(
      title: 'Section Card',
      subtitle: 'Wspolny kontener sekcji dla dashboardow, formularzy i tabel.',
      codeSnippet: '''
AppSectionCard(
  title: 'Ostatnie zamowienia',
  subtitle: 'Widok ostatnio zmienianych rekordow',
  trailing: AppActionButton.text(
    label: 'Wiecej',
    icon: Icons.arrow_forward_rounded,
    onPressed: () {},
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Text('...')],
  ),
)
''',
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AppSectionCard(
            title: 'Ostatnie zamowienia',
            subtitle: 'Widok ostatnio zmienianych rekordow w module.',
            trailing: AppActionButton.text(
              label: 'Wiecej',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => _showHint('Wiecej'),
            ),
            child: const Column(
              crossAxisAlignment: .start,
              children: [
                AppStatusBadge(
                  label: '3 nowe',
                  tone: AppStatusBadgeTone.info,
                ),
                Gaps.h12,
                AppText('Zamowienie #RN-2103'),
                Gaps.h4,
                AppText('Klient: Excellent Sp. z o.o.'),
              ],
            ),
          ),
          Gaps.h16,
          const Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: AppSectionCard(
                  title: 'Magazyn',
                  subtitle: 'Szybki podglad sekcji',
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      AppText('Dostepne produkty: 182'),
                      Gaps.h8,
                      AppStatusBadge(
                        label: 'Stabilny',
                        tone: AppStatusBadgeTone.success,
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.w16,
              Expanded(
                child: AppSectionCard(
                  title: 'Alerty',
                  trailing: AppIcon(
                    Icons.notifications_active_outlined,
                    tone: AppIconTone.warning,
                    decorated: true,
                  ),
                  child: AppText(
                    '2 rekordy wymagaja recznej weryfikacji operatora.',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
