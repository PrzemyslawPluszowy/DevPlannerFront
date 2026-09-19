# Faza 3D — standalone auth composition runtime

**Status: IMPLEMENTATION SLICE COMPLETE — 2026-09-17.**

Ten slice domyka kompozycję auth dla standalone DevPlanner bez wymyślania
endpointów i bez przenoszenia credentiali do UI. Domyślny bootstrap pozostaje
fail-closed; produkcyjny host musi jawnie dostarczyć zweryfikowany transport.

## Kontrakty użyte w implementacji

- Web BFF: `GET /bff/session`, `GET /bff/csrf`, `GET /bff/auth/start`,
  `POST /bff/auth/logout`. Backend trzyma OIDC access/refresh tokeny po swojej
  stronie i zwraca przeglądarce jedynie cookie sesji oraz nie-HttpOnly cookie
  synchronizera CSRF.
- Profil sesji: `GET /api/v1/me` jest jedynym źródłem `userId`, loginu,
  display name i permissions używanych przez frontend.
- Desktop: Authorization Code + PKCE przez systemową przeglądarkę; transport
  callbacku pozostaje jawnie wstrzykniętym `DesktopPkceSessionTransport`, a
  refresh credential trafia wyłącznie do `PlatformSecureRefreshTokenVault`.

## Wykonane zmiany

- `AuthComposition.webBff(...)` składa `HttpWebBffSessionTransport` z
  `WebBffAuthAdapter`; `fromWebBff(...)` pozwala hostowi wstrzyknąć wcześniej
  zweryfikowany typed transport. Konstruktor HTTP odrzuca transport z
  bearerem/vaultem.
- `HttpWebBffSessionTransport` odtwarza sesję przez `/bff/session`, wymaga
  `authenticated=true` i `csrfTokenAvailable=true`, a następnie pobiera
  autorytatywny `/api/v1/me`. Brak CSRF kończy się bezpiecznym signed-out i nie
  wywołuje profilu.
- Start logowania webowego otwiera wyłącznie wewnętrzne `/bff/auth/start` przez
  `WebBffBrowserLauncher`; formularz nie wysyła loginu ani hasła do Fluttera.
  `returnTo` jest ograniczany przez `AuthReturnTo` do ścieżek wewnętrznych.
- Wylogowanie webowe wysyła `POST /bff/auth/logout`; odpowiedź `401` jest
  traktowana jako idempotentny brak sesji, pozostałe błędy są propagowane.
- `AuthComposition.desktopPkce(...)`/`fromDesktopPkce(...)` wymaga transportu
  PKCE i używa jawnego OS secure vaultu. Refresh token nie jest dostępny w
  `AuthUser`, widgetach, Hive ani browser storage.
- `bootstrap()` przyjmuje opcjonalne, jawne `auth` i `httpTransport`; bez nich
  uruchamia istniejącą kompozycję unavailable. Nie tworzy domyślnego klienta,
  nie zgaduje callbacku i nie łączy się z backendem anonimowo.

## Testy i walidacja

- `flutter test test/auth/auth_composition_test.dart
  test/auth/auth_platform_adapters_test.dart test/auth/auth_foundation_test.dart`
  — PASS, 16 testów.
- Testy sprawdzają mapowanie `/bff/session` + `/api/v1/me`, fail-closed bez
  CSRF, sanitizację redirectu, brak nagłówka Authorization w Web, odrzucenie
  desktop bearer transportu oraz użycie injected secure vault.
- `flutter analyze` — PASS, `No issues found!` (pełne drzewo Front).
- `git diff --check` — PASS.

## Jawne ograniczenia

- Backend nie publikuje formularzowego endpointu loginu; nie dodano nowego
  ekranu ani własnego JWT. `WebBffBrowserLauncher` i desktopowy PKCE callback
  są seamami hosta/platformy.
- Nie deklaruje się E2E BFF/OIDC ani testów systemowego Credential Manager,
  Keychain i Secret Service. Wymagają uruchomionego backendu oraz bramek Web,
  Windows, macOS i Linux.
- Pełny bootstrap produkcyjny pozostaje fail-closed dopóty, dopóki host nie
  dostarczy konkretnego launchera przeglądarki i desktopowego transportu PKCE.
