# R3a — Workspaces typed error boundary i l10n

Data: 2026-09-17  
Zakres: tylko Front; bez zmian Backend, routingu, planu/handoffu, commit/push.

## Problem

Review R3 wykazał, że nowy gateway i Cubit zawierały polskie teksty użytkownika
oraz że Cubit przenosił gotowy komunikat zamiast typowanego powodu błędu. Było to
niezgodne z zasadą ARB i mieszało warstwę transportu z presentation.

## Naprawa

- Dodano domenowy enum `WorkspacesFailureReason`:
  `transportUnavailable`, `unauthorized`, `forbidden`, `requestFailed`,
  `invalidResponse`.
- `WorkspacesGatewayException` przenosi wyłącznie reason, HTTP status i
  opcjonalny backend code; nie ma pola `message`.
- Adapter data mapuje statusy HTTP, błędy transportu i błędy parsowania na
  typowane powody. Nie zawiera tekstów prezentacyjnych.
- Cubit emituje `DevPlannerWorkspacesFailure` z reason/status/backendCode.
  Nie zawiera tekstów użytkownika ani logiki lokalizacji.
- Ekran Workspaces mapuje reason na `context.l10n`.
- Dodano polskie i angielskie klucze ARB dla tytułów/komunikatów transportu,
  sesji, uprawnień, błędnej odpowiedzi, błędu serwera i statusu HTTP.
- Wykonano kontrolowane `flutter gen-l10n`; wygenerowane pliki lokalizacji są
  zgodne z ARB.

## Walidacja

### Lokalizacja

```bash
flutter gen-l10n
```

Wynik: **PASS**. Flutter użył istniejącego `l10n.yaml` i wygenerował pliki
`lib/l10n/app_localizations.dart`, `app_localizations_pl.dart` oraz
`app_localizations_en.dart`.

### Scoped analyze

```bash
dart analyze lib/main.dart lib/bootstrap/app_bootstrap.dart \
  lib/app/devplanner_app.dart lib/app/router/devplanner_router.dart \
  lib/app/shell/devplanner_shell.dart \
  lib/workspaces/domain/models/workspace_summary.dart \
  lib/workspaces/domain/ports/workspaces_gateway.dart \
  lib/workspaces/data/standalone/workspaces_gateway.dart \
  lib/workspaces/presentation/cubit/devplanner_workspaces_cubit.dart \
  lib/workspaces/presentation/devplanner_workspaces_page.dart
```

Wynik: **No issues found!**

### Router tests

```bash
flutter test \
  test/app/router/devplanner_root_router_compile_test.dart \
  test/app/router/devplanner_router_test.dart
```

Wynik: **10/10 PASS**. Zaktualizowano oczekiwanie testu braku transportu do
angielskiego komunikatu z `app_en.arb`, ponieważ testowa aplikacja używa
domyślnej lokalizacji angielskiej.

### macOS build

```bash
flutter build macos --debug
```

Wynik: **PASS** — `build/macos/Build/Products/Debug/DevPlanner.app`.
Pozostało tylko istniejące ostrzeżenie pluginów `media_kit` bez Swift Package
Manager; nie blokuje kompilacji.

### Diff hygiene

```bash
dart format lib/workspaces/domain/ports/workspaces_gateway.dart \
  lib/workspaces/data/standalone/workspaces_gateway.dart \
  lib/workspaces/presentation/cubit/devplanner_workspaces_cubit.dart \
  lib/workspaces/presentation/devplanner_workspaces_page.dart \
  test/app/router/devplanner_root_router_compile_test.dart
git diff --check
```

Wynik: **PASS**, bez błędów whitespace. Kontrolny scan nowych warstw nie
wykazuje już user-visible tekstów poza ARB/presentation `context.l10n`.
