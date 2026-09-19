# Faza 4L — frontendowe kontrakty Storage/Wiki/Whiteboard/OKR `UserId`

**Status:** COMPLETE w zakresie frontendowych kontraktów transportowych i
seamów testowych, 2026-09-17.

## Zakres

Pakiet obejmuje istniejące frontendowe kontrakty ACL używane przez Storage i
Wiki/Whiteboard, modele OKR oraz payloady konwersji Sticky Note do zadań.
Storage/Office/avatar/share/AI już używały lokalnego `userId`; w tym pakiecie
usunięto ostatnie pola legacy w zakresie 4L i wygenerowano artefakty Freezed/
JSON ponownie. Tasks/Kanban, Projects/Workspace, Members, Admin, Chat,
Notifications i Auth pozostają poza zakresem.

## Wykonane

- `WikiPageAccessGrantResponse.coreUserId` i
  `WhiteboardAccessGrantResponse.coreUserId` zastąpiono kanonicznym
  `userId`; JSON używa wyłącznie klucza `userId`.
- `ObjectiveResponse.createdByCoreUserId` zastąpiono `createdByUserId`;
  JSON używa wyłącznie klucza `createdByUserId`.
- `CreateTaskFromStickyNotePayload.assigneeCoreUserIds` oraz
  `BulkCreateTasksFromStickyNotesPayload.assigneeCoreUserIds` zastąpiono
  `assigneeUserIds`; JSON używa wyłącznie klucza `assigneeUserIds`.
- Wygenerowano odpowiednie pliki `.freezed.dart`, `.g.dart` i Retrofit bez
  aliasów, dual-read/write ani fallbacków Ready/Core.
- Zaktualizowano test OKR do lokalnego kontraktu `createdByUserId`.
- Nie dodano globalnych funkcji, logiki biznesowej w UI ani nowych zależności
  transportowych w presentation.

## Weryfikacja

- `dart run build_runner build` — PASS; generator zakończył się bez błędów.
- Targeted Storage/Office/share/AI + OKR suite: **23/23 PASS**.
- `flutter analyze` — PASS, `No issues found!`.
- Legacy scan w zakresie 4L (`CoreUserId`, `coreUserId`, `ReadyUserId`,
  `readyUserId`, `CoreUser`, `ReadyUser`) — brak wyników.
- `git diff --check` — PASS.

## Uwagi dla kolejnego agenta

Pełny build runner odświeżył również istniejące generated artifacts wymagane
przez równoległy pakiet 4E, ponieważ cache generatora był niespójny ze źródłem
`workspace_responses.dart`. Nie zmieniano ręcznie kodu domeny Projects/Workspace.
Przed kolejnym pakietem sprawdzić `git status` i nie cofać tych artefaktów.

Nie wykonano pełnej suite, platform builds ani HTTP/OpenAPI integration; te
bramki pozostają odpowiedzialnością koordynatora.
