### 4K — frontend Projects/Workspace lokalny `UserId`

Frontendowe odpowiedzi Projects/Workspace oraz domenowy model listy workspace
używają kanonicznych pól `userId` i `createdByUserId`. Usunięto z tego zakresu
`createdByCoreUserId`, `coreUserId` i `readyUserId`, bez aliasów, dual-read/write
oraz fallbacków. Zaktualizowano mapery, call site’y prezentacji członków
projektu, testy i wygenerowaną serializację Freezed/JSON. Zakres nie obejmuje
Tasks/Kanban, 4J members/invites/directory, Storage, Wiki, Whiteboard, OKR,
Chat/Notifications ani Auth.

Dowody: build_runner zakończony poprawnie, kontrakt lokalnego `UserId` **1/1**,
targeted Projects/Workspace suite **27/27**, `flutter analyze` PASS. Pełny
frontend i bramki platformowe pozostają otwarte.
