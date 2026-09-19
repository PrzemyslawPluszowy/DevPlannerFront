# Handoff fragment — 6E platform adapters/cache

- **Status:** typed transport boundary complete; macOS desktop E2E is blocked
  by launcher URL delivery and manual native verification remains pending.
- **Web:** `WebBffAuthAdapter` delegates a cookie/BFF transport and has no token
  storage. The unavailable transport fails closed. Do not add localStorage,
  IndexedDB, Hive or an OAuth token parser to this path.
- **Desktop:** `DesktopPkceAuthAdapter` delegates system-browser PKCE to a typed
  transport. `PlatformSecureRefreshTokenVault` uses the OS secure store on
  `dart.library.io`; the non-IO implementation throws and has no fallback.
  The transport owns state/nonce/verifier, uses randomized loopback ports
  `49152..65535`, keeps access tokens in memory, rotates refresh values in the
  vault, reads `GET /api/v1/me/`, and revokes through
  `POST /connect/revocation`. Launcher paths cover Windows/macOS/Linux.
- **Cache:** `HiveDevPlannerCacheStore` owns only `devplanner_cache_v1`, uses
  versioned JSON documents and per-user keys, rejects secret-like fields, and
  clears only the selected user namespace.
- **Tests:** focused 6E suite is green (11 tests); `flutter analyze` and
  `git diff --check` are green.
- **Next agent:** run manual native login/callback/refresh/logout verification
  on Windows/macOS/Linux without changing the auth route boundary. The current
  tests do not prove native keychain/credential-manager behavior; real browser
  E2E remains intentionally deferred. On macOS, both `Process.open` and
  `url_launcher` report launch success but fail to deliver `/connect/authorize`
  to the browser; no callback/session/me/refresh/revocation result is proven.
- **Do not:** touch Backend from this package, add guessed URLs, implement
  custom OAuth, store tokens in Hive/browser storage, or add platform imports to
  widgets/Cubits.
