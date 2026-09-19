# Handoff fragment — 3D auth composition runtime

- Dodano `AuthComposition.webBff(...)`/`fromWebBff(...)` oraz
  `AuthComposition.desktopPkce(...)`/`fromDesktopPkce(...)`.
  Obie ścieżki są jawne; `AuthComposition.unavailable()` nadal jest domyślnym
  fail-closed fallbackiem.
- Web używa `HttpWebBffSessionTransport`: `/bff/session` + `/api/v1/me`,
  cookie credentials i CSRF z `DevPlannerHttpTransport`, redirect przez
  `WebBffBrowserLauncher`. Odczyt webowego cookie CSRF jest zamknięty za
  `CsrfCookieReader`, bez top-level funkcji. Flutter nie wysyła ani nie
  przechowuje tokenów.
- Desktop zachowuje istniejący `DesktopPkceAuthAdapter` i
  `PlatformSecureRefreshTokenVault`; composition nie implementuje własnego
  OAuth/JWT i nie udostępnia refresh tokenu UI.
- Bootstrap przyjmuje wyłącznie jawne `auth`/`httpTransport`; brak hostowego
  seam pozostawia aplikację bezpiecznie niedostępną. Nie podłączono fikcyjnego
  endpointu loginu ani ekranu opartego o hasło, ponieważ backend publikuje BFF
  redirect, a nie credentials API.
- Testy: `flutter test test/auth/auth_composition_test.dart
  test/auth/auth_platform_adapters_test.dart test/auth/auth_foundation_test.dart`
  — 16/16 PASS. Pełne `flutter analyze` — `No issues found!`; `git diff --check`
  — PASS.
- Następny krok: host-specific web launcher, desktop loopback/custom-scheme
  callback i E2E sesji/revoke; utrzymać zasadę cookie-only Web oraz PKCE/vault
  Desktop.
