# I3o — anonimowy odbiorca publicznego linku

## Zakres

Public-link jest teraz domknięty end-to-end. Odbiorca linku nie potrzebuje
sesji DevPlanner i trafia do trasy `/storage/public/:shareToken`, która działa
poza uwierzytelnionym ShellRoute. Trasa nie została dodana do starego Ready
hosta.

## Implementacja

- `StoragePublicSharePage` i `StoragePublicShareCubit` używają wyłącznie
  kontraktów `devplanner`;
- Cubit wysyła opcjonalne, przycięte hasło do
  `StorageRepository.getPublicShareDownloadTicket`;
- po otrzymaniu biletu używa istniejącego `DownloadTransport`, bez pobierania
  pliku przez UI i bez przechowywania fałszywego stanu;
- błędy backendu zachowują komunikat i kod, więc 403 (błędne hasło), 404
  (brak/wygasły link) oraz inne typowane błędy są widoczne użytkownikowi;
- desktop zapisuje plik przez platformowy transport, a web uruchamia bezpieczny
  download anchor/blob zgodnie z istniejącą implementacją transportu;
- brak kompozycji Storage kończy się fail-closed komunikatem, a nie próbą
  anonimowego wywołania z przypadkowego miejsca.
- komunikat fail-closed jest zdefiniowany w `app_en.arb` i `app_pl.arb`, a widok
  korzysta z `context.l10n`; nie ma tekstu użytkownika hardcoded w widżecie.

## Routing i bezpieczeństwo

`DevPlannerAuthGuard` przepuszcza wyłącznie kanoniczny wzorzec
`/storage/public/<token>`. Pusty token, dodatkowy segment oraz inne ścieżki
pozostają odrzucone. Link builder z I3n generuje dokładnie ten sam wzorzec.
Trasa nie jest opakowana w `DevPlannerShellRoute` i nie wymaga cookie ani
Bearer sesji; autoryzacja odbywa się wyłącznie przez token publicznego grantu
i opcjonalne hasło na backendzie.

## Walidacja

```text
flutter analyze \
  lib/app/router/devplanner_router.dart \
  lib/workspaces/presentation/storage/public_share \
  test/app/router/devplanner_router_test.dart \
  test/workspaces/presentation/storage/public_share
```

Wynik: `No issues found!`.

```text
flutter test test/app/router/devplanner_router_test.dart --reporter compact
```

Wynik: 14 testów passed, w tym anonimowy deep-link poza shellem.

```text
flutter test \
  test/workspaces/presentation/storage/public_share/storage_public_share_cubit_test.dart \
  --reporter compact
```

Wynik: 3 testy passed: poprawne hasło i pobranie biletu, 403 oraz 404.

Żaden widget tego pionu nie przekracza 400 linii. W aktywnych plikach public
share nie ma importów `package:ready_next`.

Po poprawce odbiorowej `flutter analyze` dla strony public-share i testu routera
przechodzi bez uwag, a test Cubita public-share nadal przechodzi w komplecie
(3 testy). Pełny test routera może być uruchomiony po zakończeniu równoległej
naprawy istniejącego pionu Tasks, który obecnie blokuje kompilację niezależnymi
błędami `part`.
