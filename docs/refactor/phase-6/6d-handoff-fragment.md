# Handoff fragment — 6D standalone auth foundation

- **Status:** COMPLETE — nowy auth tree działa przez `AuthGateway`,
  `AuthSessionPort` i `AuthUseCases`; nie ma aktywnych importów legacy routera
  ani `core/auth` w `lib/auth`.
- **Host contracts:** `WebBffAuthPort` dla HttpOnly cookie/CSRF,
  `DesktopPkceAuthPort` dla system-browser Code + PKCE oraz
  `SecureRefreshTokenVault` dla OS secure vault. Brak Hive/localStorage,
  embedded WebView i realnego transportu do czasu kontraktów backendu.
- **Router integration:** `DevPlannerRouter` przyjmuje `AuthComposition`,
  guard obserwuje `AuthSessionPort`, a `AuthReturnTo` dopuszcza tylko nowe
  wewnętrzne ścieżki (`/workspaces`, `/chat`, `/notifications`, `/storage`,
  `/me`, `/admin`).
- **Presentation:** `AuthRoutePage` + `AuthLoginCubit` + `AuthActionCubit`; UI
  nie zna transportu ani magazynu sesji. Placeholder auth page została usunięta.
- **Validation:** focused suite PASS (9 tests); full `flutter analyze` PASS,
  `No issues found!`.
- **Scope:** nie zmieniano wspólnych plan/handoff documents ani prac usuwania
  BHP, Inventory i Dashboard.
