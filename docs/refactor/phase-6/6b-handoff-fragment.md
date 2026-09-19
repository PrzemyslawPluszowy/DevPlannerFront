# Handoff fragment — 6B Workspaces router migration

- **Status:** COMPLETE — aktywne importy Workspaces/shared prezentacji nie
  odwołują się do `app_router.dart`, `app_route_paths.dart` ani `AppRouter`.
- **Nowa granica:** `DevPlannerNavigation` (`GoRouter`-backed) oraz
  `DevPlannerRouteCatalog`; brak globalnych funkcji nawigacyjnych i brak
  kompatybilności ze starym routerem.
- **Kontrakty:** jawne buildery dla `/workspaces/:workspaceId`, project,
  task, resource, chat conversation i `/me/{tasks,files}`; router utrzymuje
  odpowiadające placeholder routes.
- **Deep link security:** `goDeepLink` akceptuje wyłącznie względne ścieżki
  z katalogu standalone; odrzuca scheme/authority i legacy paths.
- **Testy:** `test/app/router/devplanner_router_test.dart` obejmuje nested path
  builders i odrzucenie zewnętrznego deep linku.
- **Foundation boundary:** usunięte hosty modal/panel shell zastąpiono
  `DevPlannerModalHost`, `DevPlannerModalPickerHost` i
  `DevPlannerPanelsScope` w `lib/foundation/presentation`; nie odtworzono
  żadnego starego routera ani jego adaptera.
- **Analyzer:** pełny `flutter analyze` kończy się `No issues found!` (zero
  errorów, warningów i info).
- **Nie zmieniono:** BHP, Inventory, Dashboard deletion work ani wspólnych
  plan/handoff documents.
