# Faza 4F — frontend auth identity `UserId`

**Status: implementation slice complete — 2026-09-17 (Front only).**

Ten bounded slice porządkuje aktywny auth core DevPlanner wokół lokalnego,
UUID-owego `userId`. Model sesji, stan, repozytorium oraz bezpośrednie call-site’y
nie publikują już `coreUserId`, `readyUserId` ani aliasów `username`/`token`.

## Kontrakt

- `GET /api/v1/me` jest autorytatywnym źródłem `userId`, loginu i permissions.
- Web korzysta z BFF cookie + CSRF przez istniejący `HttpWebBffSessionTransport`.
- Desktop korzysta z istniejącego PKCE i OS secure vault; transport nie udostępnia
  credentiali warstwie presentation.
- Parsowanie auth jest kanoniczne: `userId`, `login`, `displayName`,
  `accessToken`, `refreshToken`; nie ma dual-read/write, fallbacków ani aliasów.

## Zmienione elementy

- `lib/core/auth/auth_models.dart` — lokalny `String userId`, usunięte Core/Ready
  pola oraz legacy aliasy i dual parsing.
- `lib/core/auth/auth_state.dart`, `auth_cubit.dart`, `auth_repository.dart` —
  stan i lifecycle korzystają z kanonicznego `userId`/`login`.
- `lib/workspaces/data/auth/models/auth_models.dart` i generated outputs —
  `CurrentUserResponse.userId`; endpoint `lib/workspaces/data/auth/api/auth_api.dart`
  wskazuje `/api/v1/me`.
- Bezpośrednie call-site’y preference/chat/task/project profile używają lokalnej
  tożsamości. Ich niezależne DTO nie zostały masowo zmienione.
- Review domknął pozostały call-site auth w pickerze zadań, usunął nieefektywne
  mapowanie tekstowego `userId` oraz odświeżył testowy fake repozytorium do
  kanonicznego parametru `login`; niezależne pola `coreUserId` DTO zadań nadal
  pozostają poza zakresem.

## Poza zakresem

Pozostają legacy nazwy w niezależnych kontraktach domenowych Storage,
AccessControl, Projects oraz innych agregatach (w tym starsze DTO Kanban/tasks).
Ich migracja wymaga osobnych pakietów i kontraktów OpenAPI; ten slice nie dodaje
aliasów, mapowania ani backfillu dla tych domen.

## Walidacja

- `flutter test test/core/auth` — PASS, 48 testów.
- `flutter test test/auth` — PASS, 16 testów.
- `flutter test test/app/router` — PASS, 9 testów (łącznie target 4F: 73).
- `flutter test test/workspaces/presentation/chat/chat_thread_and_discussion_ui_test.dart`
  — PASS, 4 testy (regresja call-site).
- `dart run build_runner build --build-filter=...auth_models...` — PASS.
- `flutter analyze` — PASS, `No issues found!`.
- `git diff --check` — PASS.
