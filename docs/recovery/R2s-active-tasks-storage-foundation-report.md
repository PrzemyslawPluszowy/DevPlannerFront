# R2s — foundation w aktywnych Tasks i Files

Data: 2026-09-18  
Status: zakończony automatyczny odbiór; desktop/staging: **NIE URUCHAMIANO**.

## Cel

Usunąć sprzężenie aktywnie używanych ekranów Tasks i Files z historycznymi
fasadami `core/l10n` i `core/theme`. Nie jest to usuwanie lokalnych narzędzi
ani integracji sieciowej; celem jest to, aby presentation korzystało wyłącznie
z publicznego `foundation`.

## Zakres zmiany

Zmigrowano 24 pliki:

- Shell Plików: `storage_shell_page.dart`, `storage_sidebar.dart`,
  `storage_status_views.dart`.
- Edytory i widoki recurrence Tasks.
- Saved Views Tasks wraz z sekcjami filtrów, sortowania, osób, grupowania,
  kolumn i dialogami.

Każdy import `core/l10n/l10n_extensions.dart`, `core/theme/theme.dart` lub
`core/theme/theme_extensions.dart` w tym zakresie zastąpiono odpowiednio
publiczną fasadą `foundation/l10n/l10n.dart` albo `foundation/theme/theme.dart`.
Nie zmieniano modeli, repository, endpointów, routera, Cubitów ani layoutu.

## Walidacja

```text
flutter analyze lib/workspaces/presentation/storage/shell \
  lib/workspaces/presentation/tasks/recurrence \
  lib/workspaces/presentation/tasks/views
PASS — no issues found

flutter test [storage shell, saved views, recurrence]
PASS 29/29

rg "package:devplanner/core/(l10n|theme)" [Tasks + Files]
brak wyników
```

Testy obejmują m.in. zapisane widoki i konflikt 409, recurrence i event
realtime, shell plików, menu desktopowe, skróty klawiaturowe oraz zachowanie
layoutu przy zwężeniu okna. Nie uruchamiano aplikacji, backendu, MinIO,
OnlyOffice ani stagingu.

## Następny krok

Kontynuować audyt pozostałych aktywnych pionów według odpowiedzialności klas.
Priorytet funkcjonalny pozostaje bez zmian: Pliki, lista zadań i Kanban oraz
częściowe globalne panele Chat/Powiadomień. Nie tworzyć osobnych ekranów
Chatu ani nie implementować zasobów, które nie były wcześniej gotowe.
