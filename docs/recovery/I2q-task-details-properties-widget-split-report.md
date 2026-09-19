# I2q — podział właściwości szczegółów zadania

## Cel

Wydzielić edytor planowania zadania z pliku `task_details_properties.dart`,
ponieważ plik przekraczał limit 400 linii. Refaktor nie zmienia kontraktu
widoku ani sposobu wykonywania mutacji: dialog nadal wywołuje istniejący
`TaskDetailsCubit.updatePlanning()` oraz `TaskScheduleRepository` dla podglądu
i zastosowania kaskady terminów.

## Wykonane zmiany

- `task_details_page.dart` dołącza nową część biblioteki
  `task_details_properties_planning.dart`.
- `task_details_properties.dart` zawiera teraz sekcję właściwości, wspólną
  sekcję nagłówkową i akcje otwierające dialogi.
- `task_details_properties_planning.dart` zawiera wyłącznie dialog edycji
  planowania oraz prezentację podglądu kaskady terminów.
- Zachowano prywatne symbole jako części tej samej biblioteki Dart, więc nie
  powstał sztuczny publiczny API ani globalny stan.
- Zachowano istniejące walidacje, komunikaty, loading, obsługę błędów,
  mutacje i zamykanie dialogu po sukcesie.

## Rozmiar plików

Pomiar po formatowaniu:

| Plik | Linie |
|---|---:|
| `lib/workspaces/presentation/tasks/detail/task_details_properties.dart` | 123 |
| `lib/workspaces/presentation/tasks/detail/task_details_properties_planning.dart` | 328 |

Oba pliki są poniżej limitu 400 linii.

## Walidacja

Uruchomiono:

```text
flutter analyze lib/workspaces/presentation/tasks/detail/task_details_page.dart \
  lib/workspaces/presentation/tasks/detail/task_details_properties.dart \
  lib/workspaces/presentation/tasks/detail/task_details_properties_planning.dart
```

Wynik: `No issues found!`.

```text
dart format lib/workspaces/presentation/tasks/detail/task_details_properties.dart \
  lib/workspaces/presentation/tasks/detail/task_details_properties_planning.dart \
  lib/workspaces/presentation/tasks/detail/task_details_page.dart
git diff --check
```

Wynik: formatowanie bez zmian i brak błędów whitespace.

## Zakres poza tym zadaniem

Nie zmieniano `TaskDetailsCubit`, routingu, shella, Files, Chat,
Notifications ani backendu. Testy widgetowe samego dialogu nie istniały w
aktualnym katalogu testów; istniejące testy Cubita pozostają własnością jego
osobnego zakresu refaktoryzacji.
