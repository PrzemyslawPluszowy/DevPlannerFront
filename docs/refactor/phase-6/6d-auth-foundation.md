# Faza 6D — standalone auth foundation

**Status: COMPLETE (2026-09-16).**

Ten slice wprowadza samodzielną granicę auth dla nowego DevPlanner. Nie
przywraca `core/auth`, starego routera, Ready/Core/DataBus, embedded WebView
ani żadnego klienta HTTP przed opublikowaniem kontraktów backendu faz 2/3.

## Wykonane

- `lib/auth/domain` zawiera modele sesji, bezpieczny `returnTo`, `AuthGateway`,
  `AuthSessionPort` oraz use cases dla restore/sign-in/sign-out i lifecycle
  konta/MFA.
- `lib/auth/data/AuthComposition.unavailable()` jest jawną kompozycją bez
  transportu i bez magazynu tokenów; `UnavailableAuthGateway` komunikuje brak
  kontraktu zamiast wykonywać wymyślone wywołania endpointów.
- Dodano typowane porty hostów: `WebBffAuthPort` (sesja HttpOnly cookie +
  CSRF), `DesktopPkceAuthPort` (system browser, Code + PKCE) i
  `SecureRefreshTokenVault` (OS secure vault). Frontend nie zapisuje tokenów w
  Hive, `localStorage` ani innym browser storage; access token nie trafia do UI.
- `AuthRoutePage` zastępuje placeholder loginem oraz lifecycle route shellami;
  formularze używają `AuthLoginCubit`/`AuthActionCubit`, a cubity wywołują
  wyłącznie domain use cases.
- `DevPlannerRouter` otrzymuje jawny `AuthComposition`, odświeża guard przez
  `AuthSessionPort` i zachowuje wyłącznie bezpieczne wewnętrzne `returnTo`.
  Auth paths są `/login`, `/auth/activate`, `/auth/reset`, `/auth/mfa`.
- Usunięto `standalone_auth_placeholder_page.dart`; aktywna prezentacja auth
  nie ma importów starego `core/auth`.

## Testy i walidacja

- `test/auth/auth_foundation_test.dart` — `returnTo`, stany sesji oraz login
  cubit z wstrzykniętym gatewayem.
- `test/app/router/devplanner_router_test.dart` — guard, nested routes i
  odrzucenie zewnętrznego/legacy deep linku.
- `flutter test test/auth/auth_foundation_test.dart test/app/router/devplanner_router_test.dart` — **PASS, 9 tests**.
- `flutter analyze` — **PASS, `No issues found!`** (zero errors, warnings i
  infos).

## Następny krok

Po uzgodnieniu OpenAPI backendu faz 2/3 należy dostarczyć adaptery
`WebBffAuthPort`/`DesktopPkceAuthPort` i platformowy `SecureRefreshTokenVault`,
bez zmiany route boundary ani dodawania legacy aliasów.
