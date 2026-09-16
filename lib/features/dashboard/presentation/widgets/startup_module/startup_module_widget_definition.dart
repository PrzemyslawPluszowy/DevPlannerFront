import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart' as provider;
import 'package:ready_next/app/modules/app_modules_catalog.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Definicja widgetu autostartu (wyboru modułu startowego) na pulpicie.
class StartupModuleWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu autostartu.
  const StartupModuleWidgetDefinition();

  @override
  String get typeId => 'startup_module';

  @override
  String name(BuildContext context) => context.l10n.dashboardStartupModuleName;

  @override
  String description(BuildContext context) =>
      context.l10n.dashboardStartupModuleDescription;

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardStartupModuleCategory;

  @override
  IconData get icon => Icons.rocket_launch_rounded;

  @override
  List<DashboardWidgetSize> get supportedSizes => const [
    DashboardWidgetSize(8, 4),
    DashboardWidgetSize(12, 4),
  ];

  @override
  Widget build(BuildContext context, DashboardWidgetSize size) {
    return _StartupModuleWidgetBody(size: size);
  }
}

/// Główna zawartość wizualna widgetu wyboru modułu startowego.
class _StartupModuleWidgetBody extends StatelessWidget {
  /// Tworzy zawartość widgetu.
  const _StartupModuleWidgetBody({required this.size});

  /// Wybrany rozmiar widgetu w siatce pulpitu.
  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    final cubit = provider.Provider.of<DashboardPreferencesCubit?>(
      context,
    );
    final currentModule =
        cubit?.state.startupModule ?? DashboardStartupModule.dashboard;
    final permissions = context.select<AuthCubit, Set<String>>(
      (cubit) => switch (cubit.state) {
        AuthAuthenticated(:final user) => user?.permissions ?? const {},
        _ => const {},
      },
    );

    final options = [
      for (final module in AppModulesCatalog.startupModulesFor(permissions))
        _StartupOption(
          module: module.startupModule!,
          label: module.label(context.l10n),
          icon: module.icon,
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Dostosowujemy liczbę kolumn do dostępnej szerokości
        final crossAxisCount = constraints.maxWidth >= 500 ? 4 : 2;
        final rowCount = (options.length / crossAxisCount).ceil();

        const spacing = Sizes.p8;
        final availableWidth =
            constraints.maxWidth - ((crossAxisCount - 1) * spacing);
        final availableHeight =
            constraints.maxHeight - ((rowCount - 1) * spacing);
        final tileWidth = availableWidth / crossAxisCount;
        final tileHeight = availableHeight / rowCount;
        final childAspectRatio = tileWidth / tileHeight;

        // Wyświetlamy opcje w elastycznej siatce
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            final isSelected = currentModule == option.module;

            return _StartupOptionTile(
              option: option,
              isSelected: isSelected,
              onTap: cubit == null
                  ? null
                  : () => cubit.setStartupModule(option.module),
            );
          },
        );
      },
    );
  }
}

/// Model danych dla pojedynczej opcji wyboru autostartu.
class _StartupOption {
  /// Tworzy definicję opcji startowej.
  const _StartupOption({
    required this.module,
    required this.label,
    required this.icon,
  });

  /// Moduł powiązany z daną opcją.
  final DashboardStartupModule module;

  /// Nazwa opcji wyświetlana użytkownikowi.
  final String label;

  /// Ikona prezentująca daną opcję.
  final IconData icon;
}

/// Pojedynczy kafelek reprezentujący opcję wyboru modułu startowego.
class _StartupOptionTile extends StatelessWidget {
  /// Tworzy kafelek opcji wyboru.
  const _StartupOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  /// Szczegółowe dane opcji.
  final _StartupOption option;

  /// Czy opcja jest w tym momencie zaznaczona.
  final bool isSelected;

  /// Akcja wywoływana przy kliknięciu opcji.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaceRoles = context.surfaceRoles;

    return Material(
      color: isSelected
          ? surfaceRoles.tintedBackground
          : surfaceRoles.baseBackground.withValues(alpha: .5),
      borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return surfaceRoles.pressedOverlay;
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return surfaceRoles.hoverOverlay;
          }
          return null;
        }),
        child: Container(
          padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            border: Border.all(
              color: isSelected
                  ? surfaceRoles.tintedBorder
                  : surfaceRoles.baseBorder.withValues(alpha: .5),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                option.icon,
                size: 20,
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
              Gaps.w12,
              Expanded(
                child: AppText(
                  option.label,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: context.text.titleSmall?.copyWith(
                    fontWeight: isSelected ? .w800 : .w600,
                    color: isSelected ? colors.primary : colors.onSurface,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: isSelected
                    ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey('selected'),
                        size: 18,
                        color: colors.primary,
                      )
                    : Icon(
                        Icons.radio_button_unchecked_rounded,
                        key: const ValueKey('unselected'),
                        size: 18,
                        color: colors.onSurfaceVariant.withValues(alpha: .5),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
