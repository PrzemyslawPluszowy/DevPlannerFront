# Faza 4J — Workspace members, invitations i lokalny katalog

## Zakres

Pakiet migracji frontendowych kontraktów członkostwa workspace, zaproszeń oraz
wyszukiwania użytkowników do kanonicznego lokalnego `UserId` zgodnego z
backendowym OpenAPI. Zakres nie obejmuje Tasks/Kanban, Projects,
Storage/Office, Wiki, Whiteboard, OKR, Chat/Notifications ani Auth.

## Wykonane zmiany

- `WorkspaceMemberResponse` publikuje wyłącznie `userId` i nie ma pól
  `coreUserId`/`readyUserId`.
- `WorkspaceInvitationResponse` oraz `CreateWorkspaceInvitationPayload`
  używają `userId` jako UUID w reprezentacji JSON.
- `LocalDirectoryUserResponse` zastąpił nazwę zewnętrznego katalogu i używa
  dokładnych pól backendu: `userId`, `login`, `displayName`, `email`,
  `emailVerified`, `avatarFileId`.
- Retrofit i repozytorium wywołują `GET /api/v1/workspaces/{workspaceId}/users/search`
  jako `searchLocalUsers`; nie ma fallbacku ani dual-read/write.
- Cubity zaproszeń i widoki members używają lokalnego `userId`; usunięto
  etykiety Ready/Core z tabeli i dialogu.
- Bez migracji niezależnych DTO Projects/Storage zaktualizowano ich
  bezpośrednie call-site’y `WorkspaceMemberResponse` i lokalnego katalogu,
  aby cały frontend kompilował się na nowym kontrakcie.
- Wartości lokalizacji dialogu zaproszeń opisują lokalny katalog użytkowników.
- Wygenerowano Freezed/JSON/Retrofit po zmianie kontraktów.

## Walidacja

- `flutter test test/workspaces/presentation/members/workspace_members_cubit_test.dart test/workspaces/presentation/workspaces_home_cubit_test.dart` — PASS (10 testów).
- `flutter test test/workspaces/data/workspaces/workspace_members_directory_contract_test.dart` — PASS (3 testy).
- `flutter test test/workspaces/presentation/projects/settings test/workspaces/presentation/storage/sharing/storage_user_search_cubit_test.dart test/workspaces/presentation/members/workspace_members_cubit_test.dart test/workspaces/data/workspaces/workspace_members_directory_contract_test.dart` — PASS (11 testów).
- `dart run build_runner build --delete-conflicting-outputs` — PASS; wygenerowano 5 artefaktów.
- `flutter analyze` — PASS, `No issues found!`.
- `git diff --check` — PASS.

## Następny krok

Nie przywracać aliasów `ReadyDirectoryUser`, `readyUserId` ani `coreUserId` do
kontraktów workspace. Niezależne DTO Projects/Storage pozostają poza zakresem
4J i mogą być migrowane w osobnych pakietach.
