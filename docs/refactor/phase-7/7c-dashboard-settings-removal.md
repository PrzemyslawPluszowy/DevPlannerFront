# 7C — usunięcie legacy dashboard/settings (Frontend)

**Stan:** COMPLETE dla zakresu dashboard/settings remnants, 2026-09-16.

Usunięto nieosiągalny ekran ustawień aplikacji wraz z jego `part` files i
eksportem, ponieważ ekran importował usunięty backend preferencji dashboardu,
stare ścieżki routera oraz katalog modułów. Usunięto również globalną tapetę
shellu, renderer tapety i sześć obrazów `std_bg_*`; po odłączeniu dashboardu
nie pozostały ich importy ani rejestracje assetów.

Zachowano używane przez DevPlanner fundamenty: `LocalSettingsCubit`, model i
repozytorium lokalnych preferencji menu oraz `CurrentUserAvatarCubit`. Są one
 nadal używane przez katalog Workspaces, globalny rail i Storage; ich testy nie
 są dashboardowymi testami legacy. Zachowano także wspólny theme/l10n oraz
 bieżące Workspaces/Settings domeny.

Usunięto wpisy typów Hive wyłącznie dla dawnych `DashboardPreferences`,
`DashboardShortcutPreference`, `DashboardWidgetPreference` i
`DashboardStartupModule`. Nie zmieniano istniejących identyfikatorów pozostałych
 typów ani nie dodawano adapterów kompatybilności.

Z `WorkspaceFeatureApi` i `WorkspaceFeaturesRepository` usunięto również
endpointy oraz modele wyłącznie dla dashboard preference layoutu. Pozostałe
kontrakty Workspaces (wyszukiwanie, aktywność i synchronizacja Wiki/Whiteboard)
pozostały bez zmian.

## Dowody

- `rg` nie znajduje `app_shell_wallpaper`, `app_wallpaper_background`,
  `settings_page` ani importów `features/dashboard` w aktywnym kodzie/testach.
- `git diff --check` — PASS.
- Added a standalone `hive_registrar.g.dart` containing only retained local
  settings/theme adapters (no removed dashboard adapters); the two local
  settings test files pass.
- Full `flutter analyze` currently reports 656 total issues / 76 errors; the
  remaining errors are unrelated router/modal-shell deletions, except for no
  remaining dashboard/settings/Hive errors in this slice.

## Następny krok

Kontynuować 7C/7D zero-reference scan po zakończeniu migracji routera i usunąć
wyłącznie pozostałe, potwierdzone nieużywane generated l10n/dashboard contracts.
