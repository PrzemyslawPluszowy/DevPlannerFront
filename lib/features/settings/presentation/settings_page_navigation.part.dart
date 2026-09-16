part of 'settings_page.dart';

/// Model pozycji nawigacji po sekcjach ustawien.
class _SettingsSectionItem {
  /// Tworzy opis pozycji menu ustawien.
  const _SettingsSectionItem({
    required this.section,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEnabled,
  });

  final _SettingsSection section;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isEnabled;
}

/// Karta z nawigacja po sekcjach ustawien.
class _SettingsNavigationCard extends StatelessWidget {
  /// Tworzy karte nawigacji po sekcjach.
  const _SettingsNavigationCard({
    required this.selectedSection,
    required this.onSectionSelected,
  });

  final _SettingsSection selectedSection;
  final ValueChanged<_SettingsSection> onSectionSelected;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final items = <_SettingsSectionItem>[
      _SettingsSectionItem(
        section: _SettingsSection.profile,
        title: intl.settingsSectionProfileTitle,
        subtitle: intl.settingsSectionProfileSubtitle,
        icon: Icons.account_circle_outlined,
        isEnabled: true,
      ),
      _SettingsSectionItem(
        section: _SettingsSection.appearance,
        title: intl.settingsSectionAppearanceTitle,
        subtitle: intl.settingsSectionAppearanceSubtitle,
        icon: Icons.palette_outlined,
        isEnabled: true,
      ),
      _SettingsSectionItem(
        section: _SettingsSection.language,
        title: intl.settingsSectionLanguageTitle,
        subtitle: intl.settingsSectionLanguageSubtitle,
        icon: Icons.language_rounded,
        isEnabled: true,
      ),
      _SettingsSectionItem(
        section: _SettingsSection.modules,
        title: intl.settingsSectionModulesTitle,
        subtitle: intl.settingsSectionModulesSubtitle,
        icon: Icons.space_dashboard_outlined,
        isEnabled: true,
      ),
    ];

    return AppSectionCard(
      title: intl.settingsCategoriesTitle,
      subtitle: intl.settingsCategoriesSubtitle,
      child: Column(
        children: [
          for (final item in items) ...[
            _SettingsSectionTile(
              item: item,
              isSelected: selectedSection == item.section,
              onTap: item.isEnabled
                  ? () => onSectionSelected(item.section)
                  : null,
            ),
            if (item != items.last) Gaps.h8,
          ],
        ],
      ),
    );
  }
}

/// Pojedynczy kafelek sekcji ustawien.
class _SettingsSectionTile extends StatelessWidget {
  /// Tworzy kafelek sekcji ustawien.
  const _SettingsSectionTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _SettingsSectionItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaceRoles = context.surfaceRoles;
    final background = isSelected
        ? surfaceRoles.tintedBackground
        : surfaceRoles.baseBackground;
    final border = isSelected
        ? surfaceRoles.tintedBorder
        : surfaceRoles.baseBorder.withValues(alpha: .8);
    final iconColor = item.isEnabled
        ? (isSelected ? colors.primary : colors.onSurfaceVariant)
        : colors.onSurfaceVariant.withValues(alpha: .65);

    return Material(
      color: background,
      borderRadius: const .all(.circular(Sizes.p12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const .all(.circular(Sizes.p12)),
        child: Container(
          padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p12),
          decoration: BoxDecoration(
            borderRadius: const .all(.circular(Sizes.p12)),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: iconColor),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      item.title,
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w700,
                        color: item.isEnabled
                            ? colors.onSurface
                            : colors.onSurfaceVariant,
                      ),
                    ),
                    Gaps.h2,
                    Text(
                      item.subtitle,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!item.isEnabled)
                Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
