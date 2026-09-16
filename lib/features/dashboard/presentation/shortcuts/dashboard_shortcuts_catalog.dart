import 'package:ready_next/app/modules/app_modules_catalog.dart';
import 'package:ready_next/features/dashboard/application/dashboard_shortcuts_state.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/presentation/shortcuts/dashboard_shortcut_definition.dart';
import 'package:ready_next/l10n/app_localizations.dart';

/// Katalog wszystkich wspieranych skrotow dashboardu.
abstract final class DashboardShortcutsCatalog {
  /// Lista wszystkich dostepnych definicji skrotow.
  static List<DashboardShortcutDefinition> definitionsFor(
    Set<String> permissions,
  ) => [
    for (final module in AppModulesCatalog.shortcutModulesFor(permissions))
      DashboardShortcutDefinition(
        id: module.shortcutId!,
        routePath: module.routePath,
        icon: module.icon,
        originalLabel: '',
      ),
  ];

  /// Buduje modele widoku na podstawie zapisanych preferencji.
  static List<DashboardShortcutItemViewModel> buildItems(
    List<DashboardShortcutPreference> preferences,
    Set<String> permissions,
  ) {
    final definitionsById = {
      for (final definition in definitionsFor(permissions))
        definition.id: definition,
    };
    final items = <DashboardShortcutItemViewModel>[];

    for (final preference in preferences) {
      final definition = definitionsById[preference.shortcutId];
      if (definition == null) {
        continue;
      }

      final normalizedUserLabel = preference.userLabel?.trim();

      items.add(
        DashboardShortcutItemViewModel(
          shortcutId: definition.id,
          routePath: definition.routePath,
          icon: definition.icon,
          userLabel: normalizedUserLabel == null || normalizedUserLabel.isEmpty
              ? null
              : normalizedUserLabel,
          isVisible: preference.isVisible,
          position: preference.position,
          gridColumn: preference.gridColumn,
          gridRow: preference.gridRow,
          exactDx: preference.exactDx,
          exactDy: preference.exactDy,
        ),
      );
    }

    items.sort((left, right) => left.position.compareTo(right.position));
    return items;
  }
}

/// Rozszerzenie dodajace wsparcie dla tlumaczen do modelu widoku skrotu.
extension DashboardShortcutItemViewModelL10n on DashboardShortcutItemViewModel {
  /// Zwraca oryginalna (katalogowa) nazwe skrotu w zaleznosci od jezyka.
  String originalLabel(AppLocalizations intl) {
    return AppModulesCatalog.findByPath(routePath)?.label(intl) ?? '';
  }

  /// Zwraca etykiete do wyswietlenia (wlasna nazwa uzytkownika lub oryginalna jezeli brak wlasnej).
  String displayLabel(AppLocalizations intl) {
    final normalizedUserLabel = userLabel?.trim();
    if (normalizedUserLabel == null || normalizedUserLabel.isEmpty) {
      return originalLabel(intl);
    }
    return normalizedUserLabel;
  }
}
