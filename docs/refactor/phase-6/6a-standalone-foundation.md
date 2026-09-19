# Faza 6A — standalone foundation i branding

**Status: IN PROGRESS (2026-09-16).**

Ten slice ustanawia samodzielny root DevPlanner i odcina aktywny startup od
Ready/Core/DataBus oraz od modułów BHP, Inventory, Dashboard, Orders, framework
i inne. Nie deklaruje jeszcze migracji wszystkich Workspaces ani pełnego auth.

## Wykonane

- Zmieniono pakiet Flutter na `devplanner` oraz branding web/native, manifesty,
  nazwy binariów i przykładowe konfiguracje.
- Dodano canonical tree `lib/foundation/{config,error,http,l10n,platform,secure_storage,theme}`.
  `DEVPLANNER_API_BASE_URL` jest jedynym adresem API i domyślnie wskazuje
  loopback DevPlanner (`http://localhost:5072`).
- `lib/main.dart` uruchamia `app/bootstrap/app_bootstrap.dart` →
  `DevPlannerApp`; bootstrap nie używa embedded-host bridge, `postMessage`,
  Ready/Core/DataBus ani hostowego token hand-off.
- `lib/app/devplanner_app.dart` jest cienkim rootem, a
  `lib/app/router/devplanner_router.dart` rejestruje wyłącznie standalone
  auth lifecycle (`/login`, `/auth/activate`, `/auth/reset`, `/auth/mfa`),
  Workspaces oraz zatwierdzone powierzchnie DevPlanner (`/chat`,
  `/notifications`, `/storage`, `/me`, `/admin`). Inwentaryzacja zawiera też
  jawne placeholder routes dla workspace/project/task/resource/file/wiki/
  whiteboard, bez przywracania starych ścieżek.
- Auth guard jest scentralizowany w `DevPlannerAuthGuard`; niezalogowany
  intended route jest kodowany jako `returnTo`, bez legacy redirectów.
- Usunięto z workspace aktywny stary root, router, shell, host bridge web,
  host launch parser, adaptery dashboard/BHP/Inventory/Orders i ich testy.
  Pozostałe nieodłączone pliki Workspaces są poza aktywnym grafem i są
  następnymi kandydatami do migracji albo usunięcia.
- Foundation storage nie rejestruje już adapterów usuniętego dashboardu.

## Dowody

- `flutter pub get` — PASS.
- Targeted `flutter analyze` dla main/bootstrap/root/router/shell/auth/
  foundation/host/storage — PASS (brak errorów; tylko istniejące lint info).
- `flutter test test/app/router/devplanner_router_test.dart
  test/foundation/config/app_env_test.dart
  test/core/network/app_api_factory_test.dart` — PASS (7 tests).
- `git diff --check` — PASS.

## Dlaczego status pozostaje IN PROGRESS

Placeholder Workspaces/auth nie jest jeszcze pełną implementacją sesji ani
podpięciem wszystkich istniejących ekranów Workspaces. Zostawiono też dormant
graf dokładnie 25 plików prezentacyjnych Workspaces/shared/settings, który nie
jest importowany przez nowy root, lecz wymaga osobnego audytu przed dalszym
usuwaniem.

## Następne bezpieczne slice’y

1. Auth: standalone session contract i guard state bez rozszerzania token
   storage.
2. Workspaces: przeniesienie ekranów przez wąskie kontrakty do
   `lib/workspaces`, usuwając importy starego routera/settings.
3. Po zamknięciu tego import graphu: usunięcie pozostałych dormant shared
   widgetów/testów i nieużywanych zależności.
