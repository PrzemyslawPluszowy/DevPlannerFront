# Faza 4S — usunięcie nieosiągalnego legacy auth klienta

**Status: COMPLETE — Front only, 2026-09-17.**

Pakiet domyka pozostałość wykrytą w audycie 4R. Zakres ograniczono do kodu,
który nie jest osiągalny z `lib/main.dart` → standalone bootstrap →
`DevPlannerApp`. Nie usuwano ani nie zmieniano `lib/auth` (BFF/PKCE), aktywnego
transportu sesyjnego ani backendu.

## Usunięte

- cały katalog `lib/core/auth`, w tym `CoreAuthApi`, Retrofit implementation,
  endpointy `/auth/login` i `/auth/refresh` oraz wygenerowany artefakt;
- dedykowane testy nieosiągalnego legacy auth z `test/core/auth/`;
- nieosiągalne legacy dormant widgets i routes zależne od starego drzewa auth;
- w aktywnym UI usunięto pozostały tekst „Core account”; komunikat używa
  „local account”/„konta lokalnego”, a ARB i wygenerowane lokalizacje są zgodne.

Nie pozostawiono `AuthApi` ani żadnego portu kompatybilności. Standalone auth
pozostaje wyłącznie w `lib/auth`; aktywny Chat otrzymuje jawny `userId` z
kompozycji użytkownika i nie odtwarza starego lookupu auth.

## Skan

Skan źródeł i konfiguracji (z wyłączeniem dokumentacji, cache builda i
generated Dart artifacts) nie znalazł `CoreAuthApi`, `DioAuthApi`, starego
Swagger URL, endpointów legacy auth ani kluczy Ready/Core/DataBus. Pozostałe
wystąpienia `core/...`, `Ready` w nazwach stanów oraz `core22` Snap są nazwami
technicznymi/naturalnym tekstem i nie wskazują na połączenie z dawnymi
usługami.

Skan źródeł i konfiguracji nie znalazł `lib/core/auth`, `CoreAuthApi`,
`DioAuthApi`, `AuthApi`, starych endpointów auth ani kluczy Ready/Core/DataBus.
Nie pozostały też legacy dormant widgets/routes.

## Walidacja

- `flutter gen-l10n` — PASS; generator użył istniejącego `l10n.yaml`.
- `git diff --check` — PASS.
- `flutter analyze` po 4S — PASS (`No issues found!`).
- `flutter build web --debug --no-tree-shake-icons` przeszedł w 4R, przed 4S;
  niezależny review Web build po 4S pozostaje pending i nie jest tu
  przedstawiany jako PASS.
