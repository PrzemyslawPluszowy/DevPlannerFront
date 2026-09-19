# 4K — frontend Projects/Workspace lokalny `UserId`

Status: wykonane do review; zakres obejmuje wyłącznie frontendowe kontrakty i
call site’y Projects oraz podstawowe odpowiedzi Workspace.

## Zakres

- `ProjectResponse.createdByUserId` zamiast `createdByCoreUserId`;
- `ProjectMemberResponse.userId` zamiast `coreUserId` i usunięcie
  `readyUserId`;
- `PortfolioResponse.createdByUserId`;
- `WorkspaceListItemResponse.createdByUserId` oraz
  `WorkspaceResponse.createdByUserId`;
- domenowy `WorkspaceListItem.createdByUserId` i mapery Workspace;
- bezpośrednie widgety, cubity i testy Projects korzystające z członkostwa;
- wygenerowane kontrakty Freezed/JSON odtworzone przez build runner (w tym
  serializacja wyłącznie kluczy `userId`/`createdByUserId`).

Nie zmieniano Tasks/Kanban, Workspace members/invites/directory (4J), Storage,
Wiki, Whiteboard, OKR, Chat/Notifications/Auth ani wspólnych dokumentów planu.

## Decyzje jakościowe

Transport Fluttera odwzorowuje dokładnie kontrakt OpenAPI backendu 4E. Nie ma
aliasów `CoreUserId`/Ready, `@JsonKey` mapujących stare nazwy, dual parsing ani
fallbacków. Prezentacja porównuje i przekazuje wyłącznie lokalny `userId`.

## Walidacja

- `dart run build_runner build --delete-conflicting-outputs` — zakończone
  poprawnie; generator zgłosił jedynie istniejące ostrzeżenie wersji
  `json_annotation`;
- `flutter test test/workspaces/data/standalone/projects_workspace_userid_contract_test.dart` — PASS 1/1;
- targeted Projects/Workspace presentation/data suite — PASS 27/27;
- `flutter analyze` — PASS, `No issues found`;
- `git diff --check` — do wykonania przez review po synchronizacji.

## Następny krok

Root agent powinien przejrzeć diff, dopisać zaakceptowany pakiet 4K do obu
wspólnych planów/handoffów byte-for-byte i uruchomić końcowy selektywny gate
klienta Projects/Workspace.
