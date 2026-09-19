# Faza 4M — frontend final identity DTOs `UserId`

**Status: implementation slice complete — 2026-09-17 (Front only).**

Ten bounded slice domyka pozostałe bezpośrednie kontrakty identity w aktywnym
admin Ops oraz workspace feature adapters. Publiczne pola Fluttera są lokalne
(`userId`, `actorUserId`, `authorUserId`) i odpowiadają docelowemu kontraktowi
standalone DevPlanner.

## Zmienione elementy

- `lib/workspaces/data/admin/models/admin_models.dart` i wygenerowane artefakty:
  `SystemErrorLogResponse.userId` serializowane jako `userId`.
- `lib/workspaces/data/admin/api/admin_api.dart` i Retrofit output: filtr
  diagnostyki używa query `userId`.
- `lib/workspaces/data/workspaces/models/workspace_feature_models.dart` i
  generated Freezed/JSON: aktywność używa `actorUserId`, a wynik globalnego
  wyszukiwania Chat używa `authorUserId`.
- Dodano kontraktowe testy JSON w
  `test/workspaces/data/standalone/identity_dto_userid_contract_test.dart`.

Nie dodano aliasów, legacy `@JsonKey`, dual-read/write ani fallbacków. Zakres
nie zmienia niezależnych accepted DTO ani testowych fixture'ów realtime spoza
tych bezpośrednich konsumentów.

## Walidacja

- `dart run build_runner build --delete-conflicting-outputs` — PASS, 185
  artefaktów wygenerowanych; znane ostrzeżenia wersji analyzer/json_annotation.
- focused DTO/workspace suite — PASS, 7/7.
- `flutter analyze` — PASS, `No issues found!`.
- `git diff --check` — PASS.
- scoped scan admin/workspace feature models i generated outputs — brak
  `CoreUserId`, `coreUserId`, `ReadyUserId`, `readyUserId`, `ready_id`.

## Zależność kontraktowa

Backend musi publikować te same nazwy JSON/query (`userId`, `actorUserId`,
`authorUserId`) w odpowiadającym pakiecie backendowym. Front nie utrzymuje
kompatybilności z wcześniejszymi nazwami.
