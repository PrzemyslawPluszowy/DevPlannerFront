# R4a — Chat standalone foundation

Data: 2026-09-17  
Repozytorium: `Front`  
Backend: tylko audyt kontraktu; bez zmian.

## Cel i granica pakietu

Zbudowano mały, zamknięty pion wymagany przez globalny composition root:

1. listowanie dostępnych rozmów,
2. cursorowa historia wiadomości,
3. publikacja wiadomości z `clientMessageId`.

Pion transportowy nie tworzy UI, routingu ani realtime. Nie integruje jeszcze
Storage, rewizji, wątków, placementów, reakcji, załączników ani SignalR.
Rozszerzenia zostały świadomie odseparowane, aby nie przenosić niegotowych
zależności Ready/Core do działającej podstawy globalnego Chat.

## Audyt kontraktu Backend

- `Backend/Endpoints/Chat/ChatEndpoints.cs:15-25` — chroniony hub realtime i
  grupa REST `/api/v1/chat`; `GET /conversations` zwraca rozmowy dostępne
  bieżącemu użytkownikowi zgodnie z członkostwem i Scope.
- `ChatEndpoints.cs:149-161` — resolve rozmowy oraz
  `GET /conversations/{conversationId}/messages`; historia jest cursorowa i
  nie ujawnia logicznie usuniętych wiadomości.
- `Backend/Contracts/Chat/ChatContracts.cs:7-20` — request resolve używa
  `IReadOnlyList<Guid>? UserIds`, a nie identyfikatorów Ready/Core.
- `ChatContracts.cs:28-40` — odpowiedź rozmowy ma UUID, scope, workspace/project,
  wersję i datę utworzenia.
- `ChatContracts.cs:73-79` — publikacja używa `ClientMessageId`, `Text`,
  opcjonalnego Delta/reply/attachment UUID.
- `ChatContracts.cs:148-166` — wiadomość ma `AuthorUserId`, a załącznik ma
  lokalne UUID; `Version` jest `long` po stronie C# i jest mapowany do Dart `int`.

## Zmienione pliki

- `lib/workspaces/data/chat/models/chat_models.dart` — kontrakty DTO Chat
  przełączone na `userId`, `userIds`, `authorUserId`, `recipientUserId`,
  `createdByUserId`, `attachedByUserId`, `pinnedByUserId` i pozostałe lokalne
  UUID; importy enumów przełączone na drzewo `devplanner`.
- `lib/workspaces/data/chat/models/chat_models.freezed.dart` oraz `.g.dart` —
  wygenerowane serializery po zmianie nazw pól JSON.
- `lib/workspaces/data/chat/api/chat_api.dart` oraz `.g.dart` — API importuje
  lokalne modele i lokalny cursor response; endpointy zachowują kontrakt
  `/api/v1/chat`.
- `lib/workspaces/domain/repositories/chat_repository.dart` — port używa
  lokalnego `ApiError` i lokalnych Chat DTO.
- `lib/workspaces/data/chat/repositories/chat_repository_impl.dart` — mały
  adapter portu dla trzech bazowych operacji, z lokalnym mapowaniem błędów
  Dio/parsing i bez zależności do Core/Ready/Storage.
- `lib/workspaces/domain/chat/conversation/models/chat_message.dart` oraz
  `chat_message_attachment.dart` — lokalne modele domenowe używają `userId`;
  zachowano je jako przygotowanie następnego pionu mapowania wiadomości.
- `test/workspaces/data/chat/global_chat_contract_test.dart` — testy UUID
  uczestników i autora/załącznika oraz brak starych kluczy JSON.

## Skan legacy

W zamkniętym pionie bazowym nie ma już `package:ready_next`, `coreUserId`,
`readyUserId`, `authorCoreUserId` ani `attachedByCoreUserId`:

```text
rg -n "coreUser|readyUser|CoreUser|Ready|package:ready_next" \
  lib/workspaces/data/chat/models/chat_models.dart \
  lib/workspaces/data/chat/models/chat_models.freezed.dart \
  lib/workspaces/data/chat/models/chat_models.g.dart \
  lib/workspaces/data/chat/api/chat_api.dart \
  lib/workspaces/data/chat/api/chat_api.g.dart \
  lib/workspaces/domain/repositories/chat_repository.dart \
  lib/workspaces/domain/chat/conversation/models/chat_message.dart \
  lib/workspaces/domain/chat/conversation/models/chat_message_attachment.dart \
  lib/workspaces/data/chat/repositories/chat_repository_impl.dart
=> 0 wyników
```

`avatarUrl` pozostaje wyłącznie jako nazwa backendowego pola sugestii wzmianki,
potwierdzona `ChatContracts.cs:56-61`; nie jest identyfikatorem Ready/Core.

## Walidacja

- `flutter test test/workspaces/data/chat/global_chat_contract_test.dart` — PASS, 2/2.
- `flutter analyze` na 5 plikach bazowego pionu — PASS, `No issues found!`.
- `dart format` dla źródeł, generatorów i testu — PASS.
- `git diff --check` — PASS.
- `build_runner` dla Chat DTO/API — PASS; ostrzeżenie dotyczy wyłącznie
  istniejącego constraintu `json_annotation`.

## Następny krok

Najpierw podłączyć ten port do nowego composition rootu po zakończeniu triage
roota. Następne pakiety mogą osobno dodać mapowanie domenowe, rewizje/wątki,
załączniki Storage i SignalR. Nie należy przywracać starych aliasów ani
importów `ready_next` jako skrótu integracyjnego.
