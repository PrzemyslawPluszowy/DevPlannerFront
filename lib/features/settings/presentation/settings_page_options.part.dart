part of 'settings_page.dart';

/// Reuzywalny kafelek opcji w ustawieniach.
class _SettingsOptionTile extends StatelessWidget {
  /// Tworzy kafelek opcji.
  const _SettingsOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaceRoles = context.surfaceRoles;

    return Material(
      color: isSelected
          ? surfaceRoles.tintedBackground
          : surfaceRoles.baseBackground,
      borderRadius: const .all(.circular(Sizes.p12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const .all(.circular(Sizes.p12)),
        child: Container(
          padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p12),
          decoration: BoxDecoration(
            borderRadius: const .all(.circular(Sizes.p12)),
            border: Border.all(
              color: isSelected
                  ? surfaceRoles.tintedBorder
                  : surfaceRoles.baseBorder.withValues(alpha: .9),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      title,
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h2,
                    Text(
                      subtitle,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: isSelected
                    ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey('selected'),
                        color: colors.primary,
                      )
                    : Icon(
                        Icons.radio_button_unchecked_rounded,
                        key: const ValueKey('unselected'),
                        color: colors.onSurfaceVariant.withValues(alpha: .8),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kafelek opcji palety kolorystycznej.
class _PaletteOptionTile extends StatelessWidget {
  /// Tworzy kafelek palety.
  const _PaletteOptionTile({
    required this.title,
    required this.subtitle,
    required this.palette,
    required this.selectedPalette,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final AppThemePalette palette;
  final AppThemePalette selectedPalette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedPalette == palette;
    final colors = context.colors;

    return _SettingsOptionTile(
      title: title,
      subtitle: subtitle,
      icon: Icons.color_lens_outlined,
      isSelected: isSelected,
      onTap: onTap,
    ).withPalettePreview(
      palette: palette,
      selected: isSelected,
      colorScheme: colors,
    );
  }
}

/// Kafelek opcji koloru seed dla palety Material.
class _SeedColorOptionTile extends StatelessWidget {
  /// Tworzy kafelek koloru seed.
  const _SeedColorOptionTile({
    required this.title,
    required this.subtitle,
    required this.seedColor,
    required this.selectedSeedColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final AppThemeSeedColor seedColor;
  final AppThemeSeedColor selectedSeedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedSeedColor == seedColor;
    final previewColor = switch (seedColor) {
      AppThemeSeedColor.blue => const Color(0xff0b57d0),
      AppThemeSeedColor.emerald => const Color(0xff0f766e),
      AppThemeSeedColor.amber => const Color(0xffb45309),
      AppThemeSeedColor.rose => const Color(0xffbe185d),
      AppThemeSeedColor.violet => const Color(0xff6d28d9),
      AppThemeSeedColor.teal => const Color(0xff0d9488),
      AppThemeSeedColor.indigo => const Color(0xff4338ca),
      AppThemeSeedColor.orange => const Color(0xffc2410c),
      AppThemeSeedColor.crimson => const Color(0xffbe123c),
    };

    return Stack(
      children: [
        _SettingsOptionTile(
          title: title,
          subtitle: subtitle,
          icon: Icons.colorize_rounded,
          isSelected: isSelected,
          onTap: onTap,
        ),
        Positioned(
          right: Sizes.p48,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Align(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: previewColor,
                  shape: .circle,
                  border: Border.all(
                    color: context.colors.outlineVariant,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Rozszerzenie dodajace podglad palety do bazowego kafelka opcji.
extension _SettingsTilePalettePreviewX on Widget {
  /// Owijka doklejajaca prosty podglad tonow kolorystycznych.
  Widget withPalettePreview({
    required AppThemePalette palette,
    required bool selected,
    required ColorScheme colorScheme,
  }) {
    final (c1, c2, c3) = switch (palette) {
      AppThemePalette.classic => (
        colorScheme.primary,
        colorScheme.tertiary,
        colorScheme.surfaceContainerHigh,
      ),
      AppThemePalette.material => (
        const Color(0xff0b57d0),
        const Color(0xff0f766e),
        const Color(0xff6d28d9),
      ),
    };

    return Stack(
      children: [
        this,
        Positioned(
          right: Sizes.p44,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Row(
              children: [
                _PreviewDot(color: c1),
                Gaps.w4,
                _PreviewDot(color: c2),
                Gaps.w4,
                _PreviewDot(color: c3),
                if (selected) Gaps.w8,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Kropka podgladu koloru dla opcji palety.
class _PreviewDot extends StatelessWidget {
  /// Tworzy kropke podgladu koloru.
  const _PreviewDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: .circle),
    );
  }
}
