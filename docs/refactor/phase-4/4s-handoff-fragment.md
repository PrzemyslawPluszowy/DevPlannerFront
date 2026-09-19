# Handoff fragment — 4S frontend legacy auth prune

- **Status:** COMPLETE dla nieosiągalnego klienta auth (Front only).
- Usunięto cały `lib/core/auth`, w tym `CoreAuthApi`, Retrofit generated
  artifact, stare ścieżki logowania/refresh oraz dedykowane testy
  `test/core/auth`.
- Usunięto także legacy dormant widgets/routes; nie pozostawiono `AuthApi` ani
  innego portu kompatybilności.
- `lib/auth` pozostaje jedynym aktywnym standalone auth z BFF cookie/CSRF oraz
  desktop PKCE/vault. Nie dodano fallbacku ani aliasu.
- ARB/generowane lokalizacje usuwają user-facing „Core account”.
- `flutter gen-l10n`, `flutter analyze` po 4S i `git diff --check` są PASS.
  Web build z 4R przeszedł przed 4S; niezależny review build po 4S pozostaje
  pending.
- Następny krok: CI/review powinny wykonać pełny `flutter analyze` i zwykły
  Web build. Bez commit/push.
