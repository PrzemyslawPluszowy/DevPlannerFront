# R2t — rozdzielenie odpowiedzialności routera

Data: 2026-09-18  
Status: zakończony automatyczny odbiór; desktop/staging: **NIE URUCHAMIANO**.

## Problem

`DevPlannerRouter` łączył konfigurację `GoRouter`, guard sesji, katalog URL,
tworzenie ekranów Files/Tasks oraz bezpieczne składanie `/admin`. Jedna klasa
przekraczała limit 400 linii i utrudniała review zachowania tras.

## Zmiana

- `lib/app/router/devplanner_router.dart` pozostaje właścicielem konfiguracji,
  guardu, zależności i lifecycle `GoRouter`.
- `lib/app/router/devplanner_router_pages.part.dart` zawiera wyłącznie mixin
  budujący strony i redirecty. Ma jawny kontrakt getterów do zależności
  routera, więc nie tworzy globalnego stanu ani nie omija composition root.
- Nie zmieniono publicznego konstruktora `DevPlannerRouter`, tras, query
  `?view=kanban`, UUID validation, ACL ani sposobu tworzenia adapterów.

## Zachowane krytyczne ścieżki

- Workspace i katalog projektów.
- Files osobiste, workspace i projektu; upload pozostaje desktop-only, Web BFF
  jest fail-closed dla bezpośredniego PUT.
- Lista Tasks, Kanban, historyczny redirect `/kanban` i szczegół taska.
- Publiczny share poza shellem oraz `/admin` wymagający zweryfikowanego `/me`.

## Odbiór

```text
flutter analyze lib/app/router
PASS — no issues found

flutter test [devplanner_root_router_compile, devplanner_router,
  devplanner_notifications_router]
PASS 31/31
```

Brak GUI, backendu, MinIO i stagingu w tym pakiecie. Testy dowodzą zgodności
kompozycji/tras i bezpieczeństwa fallbacków, nie połączenia desktopowego.
