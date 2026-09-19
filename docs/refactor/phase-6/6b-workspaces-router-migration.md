# Faza 6B — migracja Workspaces do standalone routera

**Status: COMPLETE (2026-09-16).**

Ten slice odłącza prezentację Workspaces i wspólne widgety od usuniętych
`app_router.dart` oraz `app_route_paths.dart`. Nie przywraca aliasów, adapterów,
legacy redirectów ani starych ścieżek.

## Wykonane

- Dodano mały port `DevPlannerNavigation` oparty o `GoRouter`; widgety nie
  zależą od composition root ani od historycznego `AppRouter`.
- `DevPlannerRouteCatalog` jest źródłem kanonicznych builderów tras dla
  workspace/project/task/resource/chat oraz `/me/tasks` i `/me/files`.
- Router standalone ma jawne placeholder contracts dla workspace files,
  project tasks i `/me/:section`, więc nawigacja zachowuje nowe zagnieżdżone
  URL-e podczas podpinania kolejnych ekranów.
- Przeniesiono Workspaces/shared presentation navigation na port:
  directory menu, project tree, project/resource pages, task board/detail,
  chat, notifications, private section, workspace shell oraz global utility
  widgets.
- Deep linki powiadomień przechodzą przez `DevPlannerNavigation.goDeepLink`;
  odrzucane są adresy zewnętrzne, absolutne i ścieżki spoza standalone route
  inventory.

## Zakres plików

Zmiana obejmuje `lib/app/router/devplanner_navigation.dart`,
`lib/app/router/devplanner_router.dart`, odpowiadające pliki prezentacji
`lib/workspaces/presentation/**` oraz wspólne widgety nawigacyjne w
`lib/shared/presentation/**`. Usunięte pliki starego routera pozostają usunięte.

## Walidacja

- `dart format` — PASS dla zmienionych plików.
- `flutter test test/app/router/devplanner_router_test.dart` — testy portu,
  kontraktów tras i guardu.
- `flutter analyze` — PASS, zero errorów; pełny przebieg kończy się
  `No issues found!`.

## Następny krok

Podłączyć rzeczywiste ekrany Workspaces do jawnych placeholder contracts oraz
kontynuować usuwanie dormant kodu, bez odtwarzania legacy API.
