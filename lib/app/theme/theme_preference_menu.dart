import 'package:devplanner/app/theme/theme_preference.dart';
import 'package:devplanner/app/theme/theme_preference_cubit.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wspólne menu belki pozwalające wrócić do motywu systemowego.
final class ThemePreferenceMenu extends StatefulWidget {
  const ThemePreferenceMenu({required this.iconColor, super.key});

  final Color iconColor;

  @override
  State<ThemePreferenceMenu> createState() => _ThemePreferenceMenuState();
}

final class _ThemePreferenceMenuState extends State<ThemePreferenceMenu> {
  bool _menuOpen = false;

  Future<void> _openMenu() async {
    if (_menuOpen) return;
    final cubit = context.read<ThemePreferenceCubit?>();
    if (cubit == null) return;
    final l10n = AppLocalizations.of(context)!;
    _menuOpen = true;
    try {
      final selected = await AppContextMenu.select<DevPlannerThemePreference>(
        context,
        globalPosition: AppContextMenu.positionFor(context),
        headerTitle: l10n.settingsAppearanceModeTitle,
        options: [
          for (final preference in DevPlannerThemePreference.values)
            AppContextMenuOption(
              value: preference,
              label: _label(preference, l10n),
              icon: _icon(preference),
              selected: cubit.state == preference,
            ),
        ],
      );
      if (!mounted || selected == null) return;
      final saved = await cubit.select(selected);
      if (!mounted || saved) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsThemeSaveFailed)),
      );
    } finally {
      _menuOpen = false;
    }
  }

  static String _label(
    DevPlannerThemePreference preference,
    AppLocalizations l10n,
  ) => switch (preference) {
    DevPlannerThemePreference.system => l10n.settingsThemeSystem,
    DevPlannerThemePreference.light => l10n.settingsThemeLight,
    DevPlannerThemePreference.dark => l10n.settingsThemeDark,
  };

  static IconData _icon(DevPlannerThemePreference preference) =>
      switch (preference) {
        DevPlannerThemePreference.system => Icons.brightness_auto_outlined,
        DevPlannerThemePreference.light => Icons.light_mode_outlined,
        DevPlannerThemePreference.dark => Icons.dark_mode_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ThemePreferenceCubit?>();
    if (cubit == null) return const SizedBox.shrink();
    return BlocBuilder<ThemePreferenceCubit, DevPlannerThemePreference>(
      bloc: cubit,
      builder: (context, preference) {
        final l10n = AppLocalizations.of(context)!;
        return IconButton(
          key: const ValueKey('devplanner-theme-menu'),
          tooltip:
              '${l10n.settingsAppearanceModeTitle}: ${_label(preference, l10n)}',
          onPressed: _openMenu,
          icon: Icon(_icon(preference), color: widget.iconColor),
        );
      },
    );
  }
}
