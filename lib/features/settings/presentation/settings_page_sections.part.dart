part of 'settings_page.dart';

/// Karta ustawien wygladu aplikacji.
class _AppearanceSettingsCard extends StatelessWidget {
  /// Tworzy karte ustawien wygladu.
  const _AppearanceSettingsCard();

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocBuilder<LocalSettingsCubit, LocalSettingsModel>(
      builder: (context, settings) {
        final cubit = context.read<LocalSettingsCubit>();

        return Column(
          children: [
            AppSectionCard(
              title: intl.settingsAppearanceModeTitle,
              subtitle: intl.settingsAppearanceModeSubtitle,
              child: Column(
                children: [
                  _SettingsOptionTile(
                    title: intl.settingsThemeSystem,
                    subtitle: intl.settingsThemeSystemSubtitle,
                    icon: Icons.settings_brightness_outlined,
                    isSelected: settings.themeMode == ThemeMode.system,
                    onTap: () => cubit.setThemeMode(ThemeMode.system),
                  ),
                  Gaps.h8,
                  _SettingsOptionTile(
                    title: intl.settingsThemeLight,
                    subtitle: intl.settingsThemeLightSubtitle,
                    icon: Icons.wb_sunny_outlined,
                    isSelected: settings.themeMode == ThemeMode.light,
                    onTap: () => cubit.setThemeMode(ThemeMode.light),
                  ),
                  Gaps.h8,
                  _SettingsOptionTile(
                    title: intl.settingsThemeDark,
                    subtitle: intl.settingsThemeDarkSubtitle,
                    icon: Icons.nightlight_round,
                    isSelected: settings.themeMode == ThemeMode.dark,
                    onTap: () => cubit.setThemeMode(ThemeMode.dark),
                  ),
                ],
              ),
            ),
            Gaps.h16,
            AppSectionCard(
              title: intl.settingsPaletteTitle,
              subtitle: intl.settingsPaletteSubtitle,
              child: Column(
                children: [
                  _PaletteOptionTile(
                    title: intl.settingsPaletteClassicTitle,
                    subtitle: intl.settingsPaletteClassicSubtitle,
                    palette: AppThemePalette.classic,
                    selectedPalette: settings.themePalette,
                    onTap: () => cubit.setThemePalette(AppThemePalette.classic),
                  ),
                  Gaps.h8,
                  _PaletteOptionTile(
                    title: intl.settingsPaletteMaterialTitle,
                    subtitle: intl.settingsPaletteMaterialSubtitle,
                    palette: AppThemePalette.material,
                    selectedPalette: settings.themePalette,
                    onTap: () =>
                        cubit.setThemePalette(AppThemePalette.material),
                  ),
                  if (settings.themePalette == AppThemePalette.material) ...[
                    Gaps.h12,
                    AppSectionCard(
                      title: intl.settingsSeedColorTitle,
                      subtitle: intl.settingsSeedColorSubtitle,
                      child: Column(
                        children: [
                          _SeedColorOptionTile(
                            title: intl.settingsSeedColorBlueTitle,
                            subtitle: intl.settingsSeedColorBlueSubtitle,
                            seedColor: AppThemeSeedColor.blue,
                            selectedSeedColor: settings.themeSeedColor,
                            onTap: () => cubit.setThemeSeedColor(
                              AppThemeSeedColor.blue,
                            ),
                          ),
                          Gaps.h8,
                          _SeedColorOptionTile(
                            title: intl.settingsSeedColorEmeraldTitle,
                            subtitle: intl.settingsSeedColorEmeraldSubtitle,
                            seedColor: AppThemeSeedColor.emerald,
                            selectedSeedColor: settings.themeSeedColor,
                            onTap: () => cubit.setThemeSeedColor(
                              AppThemeSeedColor.emerald,
                            ),
                          ),
                          Gaps.h8,
                          _SeedColorOptionTile(
                            title: intl.settingsSeedColorAmberTitle,
                            subtitle: intl.settingsSeedColorAmberSubtitle,
                            seedColor: AppThemeSeedColor.amber,
                            selectedSeedColor: settings.themeSeedColor,
                            onTap: () => cubit.setThemeSeedColor(
                              AppThemeSeedColor.amber,
                            ),
                          ),
                          Gaps.h8,
                          _SeedColorOptionTile(
                            title: intl.settingsSeedColorRoseTitle,
                            subtitle: intl.settingsSeedColorRoseSubtitle,
                            seedColor: AppThemeSeedColor.rose,
                            selectedSeedColor: settings.themeSeedColor,
                            onTap: () =>
                                cubit.setThemeSeedColor(AppThemeSeedColor.rose),
                          ),
                          Gaps.h8,
                          _SeedColorOptionTile(
                            title: intl.settingsSeedColorVioletTitle,
                            subtitle: intl.settingsSeedColorVioletSubtitle,
                            seedColor: AppThemeSeedColor.violet,
                            selectedSeedColor: settings.themeSeedColor,
                            onTap: () => cubit.setThemeSeedColor(
                              AppThemeSeedColor.violet,
                            ),
                          ),
                          Gaps.h8,
                          _SeedColorOptionTile(
                            title: intl.settingsSeedColorTealTitle,
                            subtitle: intl.settingsSeedColorTealSubtitle,
                            seedColor: AppThemeSeedColor.teal,
                            selectedSeedColor: settings.themeSeedColor,
                            onTap: () => cubit.setThemeSeedColor(
                              AppThemeSeedColor.teal,
                            ),
                          ),
                          Gaps.h8,
                          _SeedColorOptionTile(
                            title: intl.settingsSeedColorIndigoTitle,
                            subtitle: intl.settingsSeedColorIndigoSubtitle,
                            seedColor: AppThemeSeedColor.indigo,
                            selectedSeedColor: settings.themeSeedColor,
                            onTap: () => cubit.setThemeSeedColor(
                              AppThemeSeedColor.indigo,
                            ),
                          ),
                          Gaps.h8,
                          _SeedColorOptionTile(
                            title: intl.settingsSeedColorOrangeTitle,
                            subtitle: intl.settingsSeedColorOrangeSubtitle,
                            seedColor: AppThemeSeedColor.orange,
                            selectedSeedColor: settings.themeSeedColor,
                            onTap: () => cubit.setThemeSeedColor(
                              AppThemeSeedColor.orange,
                            ),
                          ),
                          Gaps.h8,
                          _SeedColorOptionTile(
                            title: intl.settingsSeedColorCrimsonTitle,
                            subtitle: intl.settingsSeedColorCrimsonSubtitle,
                            seedColor: AppThemeSeedColor.crimson,
                            selectedSeedColor: settings.themeSeedColor,
                            onTap: () => cubit.setThemeSeedColor(
                              AppThemeSeedColor.crimson,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Karta ustawien jezyka interfejsu.
class _LanguageSettingsCard extends StatelessWidget {
  /// Tworzy karte ustawien jezyka.
  const _LanguageSettingsCard();

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return BlocBuilder<LocalSettingsCubit, LocalSettingsModel>(
      builder: (context, settings) {
        final cubit = context.read<LocalSettingsCubit>();

        return AppSectionCard(
          title: intl.settingsLanguageTitle,
          subtitle: intl.settingsLanguageSubtitle,
          child: Column(
            children: [
              _SettingsOptionTile(
                title: intl.settingsLanguagePolish,
                subtitle: intl.settingsLanguagePolishSubtitle,
                icon: Icons.flag_outlined,
                isSelected: settings.language == AppLanguage.pl,
                onTap: () => cubit.setLanguage(AppLanguage.pl),
              ),
              Gaps.h8,
              _SettingsOptionTile(
                title: intl.settingsLanguageEnglish,
                subtitle: intl.settingsLanguageEnglishSubtitle,
                icon: Icons.language_rounded,
                isSelected: settings.language == AppLanguage.en,
                onTap: () => cubit.setLanguage(AppLanguage.en),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Karta ustawien startupu modułów po zalogowaniu.
class _ModulesSettingsCard extends StatelessWidget {
  /// Tworzy karte ustawien modułów.
  const _ModulesSettingsCard();

  @override
  Widget build(BuildContext context) {
    final readyUserId = _resolveReadyUserId(context);

    return BlocProvider(
      key: ValueKey('settings-modules-$readyUserId'),
      create: (context) {
        final cubit = DashboardPreferencesCubit(
          repository: context.read<DashboardPreferencesRepository>(),
          readyUserId: readyUserId,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: BlocBuilder<DashboardPreferencesCubit, DashboardPreferences>(
        builder: (context, preferences) {
          final cubit = context.read<DashboardPreferencesCubit>();
          final intl = context.l10n;
          final permissions = context.select<AuthCubit, Set<String>>(
            (cubit) => switch (cubit.state) {
              AuthAuthenticated(:final user) => user?.permissions ?? const {},
              _ => const {},
            },
          );
          final startupModules = AppModulesCatalog.startupModulesFor(
            permissions,
          );

          return AppSectionCard(
            title: intl.settingsStartupModuleTitle,
            subtitle: intl.settingsStartupModuleSubtitle,
            child: Column(
              children: [
                for (var i = 0; i < startupModules.length; i++) ...[
                  _SettingsOptionTile(
                    title: startupModules[i].label(intl),
                    subtitle: startupModules[i].startupSubtitle(intl) ?? '',
                    icon: startupModules[i].icon,
                    isSelected:
                        preferences.startupModule ==
                        startupModules[i].startupModule,
                    onTap: () => cubit.setStartupModule(
                      startupModules[i].startupModule!,
                    ),
                  ),
                  if (i < startupModules.length - 1) Gaps.h8,
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _resolveReadyUserId(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final launchContext = context.read<HostLaunchContext>();
    return switch (authState) {
      AuthAuthenticated(:final user) => resolveReadyUserId(
        user: user,
        hostUserId: launchContext.userId,
      ),
      _ => resolveReadyUserId(
        user: null,
        hostUserId: launchContext.userId,
      ),
    };
  }
}
