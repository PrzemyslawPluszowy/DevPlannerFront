# Review `backend-contract-map.md` — Backend ↔ Front

Status: review kodu wykonany 2026-09-17. Dokument nie implementuje zmian i nie
jest dowodem przejścia E2E. Każdy wiersz poniżej opisuje twierdzenie z mapy,
jego status, dowód w aktualnym kodzie oraz wymagane sprostowanie.

## Werdykt skrócony

Mapa jest dobrym szkieletem kontraktów i poprawnie ostrzega przed osieroconymi
klientami `ready_next`, `CoreUserId` oraz niepełnym realtime. Nie może jednak
być traktowana jako bezwarunkowy kontrakt produkcyjny: część wpisów opisuje
backendowe trasy, ale klient Fluttera nie jest jeszcze z nimi spięty w runtime.
Najważniejsze rozbieżności to:

1. avatar publiczny został opisany jako chroniony;
2. revocation jest częścią middleware OpenIddict, a nie osobną trasą BFF;
3. wyszukiwanie użytkowników ma już kontrakt `LocalUserDirectoryResponse`,
   podczas gdy Flutter nadal ma `ReadyDirectoryUserResponse` z polami Core/Ready;
4. backend publikuje więcej zdarzeń Chat niż rejestruje obecny adapter Fluttera;
5. backendowy policy scheme akceptuje BFF cookie albo bearer, lecz bieżący
   Flutter tworzy SignalR tylko dla desktopowego bearera — web BFF nie ma
   jeszcze połączenia SignalR z cookie/CSRF.

Statusy: **potwierdzone** = twierdzenie zgadza się z kodem; **częściowo** =
poprawne, ale wymaga doprecyzowania; **niepotwierdzone** = nie ma dowodu
runtime lub dowód jest tylko deklaracją; **błędne** = mapa mówi coś sprzecznego
z kodem.

## Auth lokalny, BFF, PKCE i `/me`

| Twierdzenie z mapy | Status | Dowód | Poprawka dla dokumentu / implementacji |
|---|---|---|---|
| Chronione API używa `DevPlanner.Api`: bearer kieruje do OpenIddict, a brak bearera do BFF cookie. | **potwierdzone** | `Backend/Extensions/WorkspaceServiceExtensions.cs:652-664` | Zachować. Dodać uwagę, że to wybór schematu po nagłówku, nie dowód, że każdy klient wspiera obie drogi. |
| BFF mutacje wymagają cookie sesji, CSRF cookie + nagłówka oraz zaufanego Origin; bearer nie wymaga CSRF. | **potwierdzone** | `Backend/Infrastructure/Bff/BffCsrfProtection.cs:11-43` | Zachować. W checklistach web wymagać `/bff/csrf` i wysyłania CSRF przy każdej mutacji. |
| `/bff/session` może być wywołane anonimowo, ale bez sesji zwraca 401; callback/start/logout są częścią BFF. | **częściowo** | `Backend/Endpoints/Auth/BffEndpoints.cs:19-47,98-112` | Opisać wyraźnie: `AllowAnonymous` na grupie nie oznacza odpowiedzi 200 dla anonimowego użytkownika. |
| `GET /connect/authorize` i `POST /connect/token` są ścieżką desktopowego PKCE. | **potwierdzone** | `Backend/Endpoints/Auth/BffEndpoints.cs:19-47`; `Backend/Infrastructure/Identity/LocalOpenIddictServiceCollectionExtensions.cs:39-58` | Zachować. Dopisać wymaganie PKCE S256 i rozdzielić protocol endpoint od BFF web. |
| `/connect/revocation` jest mapowane w `BffEndpoints`. | **błędne** | `Backend/Infrastructure/Identity/LocalOpenIddictServiceCollectionExtensions.cs:39-58` konfiguruje authorization/token/revocation w OpenIddict; `BffEndpoints.cs:19-47` pokazuje tylko BFF i authorize/token | Zmienić dowód w mapie: revocation jest endpointem middleware OpenIddict. Nie tworzyć drugiego ręcznego endpointu; klient ma używać ścieżki zgodnej z konfiguracją OpenIddict. |
| Local login nie ma publicznej rejestracji. | **potwierdzone** | `Backend/Endpoints/Auth/LocalLoginEndpoints.cs:19-29,47-82` | Zachować. Dodać, że konto i role tworzy admin przez `/api/v1/admin/users`. |
| `/api/v1/me` jest chronione i operuje na `sub`; profil, avatar, sesje i zmiana hasła są w jednym obszarze auth. | **potwierdzone** | `Backend/Endpoints/Auth/MeEndpoints.cs:18-79,93-104` | Zachować; w testach asertywnie sprawdzać UUID `sub`, bez fallbacku Ready/Core. |
| `GET /api/v1/users/{userId}/avatar` wymaga Auth. | **błędne** | `Backend/Endpoints/Auth/MeEndpoints.cs:81-91` ma grupę `.AllowAnonymous()` | Oznaczyć trasę jako publiczny odczyt obrazu (z osobną decyzją bezpieczeństwa: czy avatar ma pozostać publiczny). Flutter nie powinien zakładać `401` jako kontraktu. |
| Admin user CRUD wymaga `DevPlanner.Admin.UsersManage`. | **potwierdzone** | `Backend/Endpoints/Auth/LocalUserAdminEndpoints.cs:17-82`; `Backend/Extensions/WorkspaceServiceExtensions.cs:710-716` | Zachować; rozdzielić w mapie permission `users.manage` od wewnętrznej roli SuperAdmin. |
| Recovery/MFA są dostępne po stronie backendu, ale brak potwierdzonego klienta Fluttera. | **potwierdzone** | `Backend/Endpoints/Auth/AccountRecoveryEndpoints.cs:18-68`; `Backend/Endpoints/Auth/MfaEndpoints.cs`; brak aktywnego adaptera potwierdzony w mapie | Zachować status BRAK. Nie uznawać samego DTO/route za gotową funkcję UI; dodać zadanie kontraktowego klienta i testy błędów. |
| `GET|POST /api/v1/auth/me` jest aktywną trasą. | **błędne / osierocone FE** | `Backend/Endpoints/Auth/MeEndpoints.cs:18-79` mapuje `/api/v1/me`; `Front/lib/workspaces/data/auth/api/auth_api.dart` jest klientem starego `/auth/me` | W mapie pozostawić jako świadomie nieistniejący endpoint do usunięcia z Frontu. Jedynym profilem runtime ma być `/api/v1/me`. |

## Workspaces, użytkownicy i projekty

| Twierdzenie z mapy | Status | Dowód | Poprawka dla dokumentu / implementacji |
|---|---|---|---|
| Workspace CRUD, preferencje, członkowie, zaproszenia i lokalne wyszukiwanie są pod `WorkspaceEndpoints`. | **potwierdzone** | `Backend/Endpoints/Workspaces/WorkspaceEndpoints.cs:27-262,416-428` | Zachować grupowanie i dopisać, że wyszukiwanie zwraca lokalny katalog, nie Ready Directory. |
| Wyszukiwanie użytkowników zwraca `ReadyDirectoryUserResponse` z `readyUserId/coreUserId`. | **błędne** | Backend route opisuje `LocalUserDirectoryResponse` (`WorkspaceEndpoints.cs:149-153,416-428`; `Backend/Contracts/Directory/LocalUserDirectoryResponse.cs`); Front używa `Front/lib/workspaces/data/workspaces/responses/workspace_responses.dart:127-143` | Zaktualizować kontrakt Frontu do lokalnego `userId`/lokalnego profilu i usunąć `ReadyDirectoryUserResponse`, `readyUserId`, `coreUserId`. |
| Role workspace/project to Observer, Member, Admin, Owner i ACL jest egzekwowany w serwisach. | **potwierdzone** | `Backend/Domain/Enums/WorkspaceRole.cs:4-10`; `Backend/Domain/Enums/ProjectRole.cs:4-10`; endpointy workspace/project | Zachować; nie modelować tych ról jako nazwanych policy HTTP. |
| Frontowy klient workspace jest gotowy jako standalone. | **niepotwierdzone** | `Front/lib/workspaces/data/workspaces/api/workspaces_api.dart:1-7,84-89` importuje `ready_next` i udostępnia `searchReadyUsers`; `Front/lib/workspaces/data/workspaces/responses/workspace_responses.dart:127-143` ma pola Ready/Core | Mapę oznaczyć jako kontrakt backendowy, nie gotowość runtime. Przed akceptacją migracji usunąć importy i typy legacy. |
| Projekty, portfolio, milestones i custom workflow mają odpowiadające backendowe rodziny endpointów. | **potwierdzone** | `Backend/Endpoints/Projects/ProjectEndpoints.cs:18-97`; `PortfolioEndpoints.cs:22-61`; `ProjectMilestoneEndpoints.cs:21-57`; `ProjectCustomStatusEndpoints.cs:16-23` | Zachować. Dla każdej rodziny dodać później test kontraktowy request/response; nie dopisywać nieobecnych pól z dawnych modułów. |

## Tasks, Kanban i realtime zadań

| Twierdzenie z mapy | Status | Dowód | Poprawka dla dokumentu / implementacji |
|---|---|---|---|
| `ProjectTaskEndpoints` obejmuje CRUD zadań, bulk, zależności, assignees, checklisty, watchers, attachments, recurrence, templates, views i wyszukiwanie. | **potwierdzone** | `Backend/Endpoints/Tasks/ProjectTaskEndpoints.cs:29-162` | Zachować, ale utrzymywać mapę rodzinami endpointów zamiast kopiować każdy wariant do UI. |
| Kanban board/settings/move i preferencje użytkownika są osobnymi kontraktami. | **potwierdzone** | `Backend/Endpoints/Kanban/KanbanEndpoints.cs:19-72`; `Backend/Endpoints/Kanban/KanbanUserPreferenceEndpoints.cs` | Zachować. Sprawdzić w implementacji, że preferencje są stanem bieżącego `sub`, nie globalnym ustawieniem. |
| Realtime task ma `[Authorize]`, subskrypcję projektu i replay po kursorze. | **potwierdzone** | `Backend/Infrastructure/Tasks/TaskEventsHub.cs:10-47,50-68`; `Backend/Contracts/Tasks/TaskRealtimeEventResponse.cs:7-43` | Zachować. Dodać do testu: `SubscribeProject` sprawdza ACL, a kursor jest nieprzezroczysty dla klienta. |
| Task realtime identyfikuje aktora wyłącznie lokalnym `ActorUserId`/`UserId`. | **częściowo** | Backend DTO: `TaskRealtimeEventResponse.cs:7-43`; Front nadal odczytuje `actorCoreUserId`/`coreUserId` w `Front/lib/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart:107,140-145` | Backendowy kontrakt jest lokalny, ale Front nie jest zmigrowany. Usunąć odczyty Core i dodać mapowanie tylko na `userId`. |

## Storage i pliki

| Twierdzenie z mapy | Status | Dowód | Poprawka dla dokumentu / implementacji |
|---|---|---|---|
| Upload, files, versions, shares, folders, placements i AI reports są w `StorageEndpoints`. | **potwierdzone** | `Backend/Endpoints/Storage/StorageEndpoints.cs:48-117,144-321` | Zachować. Rozdzielić w kliencie normalne trasy użytkownika od administracyjnych. |
| Public share ticket/file routes są częścią zwykłego chronionego klienta. | **częściowo** | `StorageEndpoints.cs:122-142` ma `.AllowAnonymous()` dla public share | W mapie oznaczyć jako publiczne tokenized routes. Nie dołączać cookie ani bearer jako wymogu; token musi pozostać ograniczony do udziału. |
| `/office-callback` jest zwykłą operacją Fluttera. | **błędne** | `StorageEndpoints.cs:323-329` ma `.AllowAnonymous()` i jest callbackiem OnlyOffice z weryfikacją podpisu | Usunąć callback z publicznego API Fluttera. Traktować jako integracyjny callback serwer-serwer; nie mylić z `office-session`. |
| Storage admin ma dwie rodziny tras i wymaga SuperAdmina. | **potwierdzone** | `StorageEndpoints.cs:307-321`; `Backend/Endpoints/Admin/AdminOpsEndpoints.cs:16-32`; ACL w serwisach | Zachować, ale nie umieszczać ich w zwykłym workspace repository bez osobnego admin gateway. |
| `storage_api.dart` dowodzi, że pliki działają end-to-end. | **niepotwierdzone** | Mapa sama definiuje FE jako klient, ale Front instructions wymagają odróżnienia pliku klienta od runtime; aktualne importy legacy w workspace potwierdzają nieskończoną migrację | Dodać status runtime/E2E osobno. Potwierdzeniem jest dopiero test upload ticket → upload → complete → list/download z lokalną sesją. |

## Chat i powiadomienia

| Twierdzenie z mapy | Status | Dowód | Poprawka dla dokumentu / implementacji |
|---|---|---|---|
| Chat ma REST dla rozmów, wiadomości, wątków, załączników, reakcji, read/delivery, draftów i członków. | **potwierdzone** | `Backend/Endpoints/Chat/ChatEndpoints.cs:17-429` | Zachować. Kontrakt każdej mutacji wiązać z conversation ACL i lokalnym `sub`. |
| Notifications mają listę, unread/groups/digest/preferences, actions/reply i admin create. | **potwierdzone** | `Backend/Endpoints/Notifications/NotificationEndpoints.cs:20-39` | Zachować, ale admin create oznaczyć jako osobną ścieżkę uprawnień. |
| Chat realtime obejmuje wyłącznie message/member eventy wymienione w obecnym adapterze Fluttera. | **błędne / niepełne** | Front rejestruje tylko `chat.message.*` i wybrane `chat.member.*` w `Front/lib/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart:321-330`; backend publikuje m.in. `chat.typing.changed`, `chat.user_status.changed`, `chat.presence.changed` w `Backend/Infrastructure/Chat/ChatRealtimeConnectionManager.cs:87-89,256-276`, a serwis publikuje też delivery/read/reaction/pin/attachment/member zdarzenia | Rozszerzyć tabelę eventów o pełny backendowy katalog i jawnie oznaczyć, które eventy Flutter obsługuje. Nie deklarować pełnego czatu realtime przed testem subscribe → event → reconnect. |
| Notifications realtime ma osobne hub i zdarzenia grup. | **potwierdzone** | `Backend/Endpoints/Notifications/NotificationEndpoints.cs:39`; `Backend/Infrastructure/Notifications/INotificationRealtimePublisher.cs:17-24` | Zachować nazwy `notification.created`, `notification.group.updated`, `notification.group.removed`; dopisać, czy adapter Fronta je konsumuje i jak odtwarza stan po reconnect. |
| Chat/Notifications huby są dostępne na BFF cookie w aktualnym Flutterze web. | **błędne dla Front runtime** | Backend huby mają `[Authorize]` (`Backend/Infrastructure/Chat/ChatEventsHub.cs:10-12`, `Backend/Infrastructure/Notifications/NotificationsHub.cs:6-8`), ale `Front/lib/workspaces/data/realtime/signalr/workspace_signalr_client.dart:42-92` wymaga `accessTokenFactory`; runtime tworzy realtime wyłącznie, gdy provider bearera istnieje (`Front/lib/workspaces/data/standalone/devplanner_standalone_runtime.dart:79-121`) | Rozdzielić w mapie capability Backend vs Front: desktop PKCE bearer jest obecnie jedyną drogą SignalR; web BFF wymaga klienta cookie-aware oraz handshake/origin/CSRF zgodnego z `BffRealtimeOriginMiddleware`. |
| Web BFF SignalR wymaga ochrony Origin tak samo jak REST CSRF. | **potwierdzone po stronie backendu** | `Backend/Infrastructure/Bff/BffRealtimeOriginMiddleware.cs:25-44` | Dodać osobny kontrakt testowy WebSocket: poprawny Origin → handshake, obcy Origin → odmowa; nie wysyłać sztucznego bearer tokena z weba. |

## Realtime routes i pozostałe zależności

| Twierdzenie z mapy | Status | Dowód | Poprawka dla dokumentu / implementacji |
|---|---|---|---|
| Backend mapuje realtime dla tasks, chat, notifications, whiteboard i wiki. | **potwierdzone** | `Backend/Extensions/WorkspaceEndpointExtensions.cs:62-70`; `ProjectTaskEndpoints.cs:29`; `ChatEndpoints.cs:17`; `NotificationEndpoints.cs:39` | Zachować. W tabeli rozdzielić huby używane w MVP workspace od Whiteboard/Wiki. |
| Front jest już całkowicie standalone i nie ma Ready/Core/DataBus. | **błędne** | Przykłady: `Front/lib/workspaces/data/workspaces/api/workspaces_api.dart:1-7`, `Front/lib/workspaces/presentation/notifications/global_notifications_page.dart:6-16`, `Front/lib/workspaces/presentation/storage/shell/storage_shell_page.dart:6-19` importują `package:ready_next`; DTO/realtime nadal zawierają Core/Ready | Mapa ma pozostać ostrzeżeniem migracyjnym. Przed oznaczeniem standalone wykonać pełny import/source scan i usunąć runtime zależności, nie tylko zmienić nazwy endpointu. |
| Backend nie ma pozostałości Core/Ready. | **błędne jako kryterium cleanup** | `Backend/Application/Workspaces/Access/WorkspaceAccessService.cs:18-26` zawiera permission `bswfms.custom_modules.RNext-admin`; tekst Core pozostaje w `Backend/Domain/Entities/UserNotificationDeliveryPreference.cs:17`, `StorageUserNotificationPreference.cs:12`, `ChatUserNotificationPreference.cs:12`, a opis Core w `Backend/Endpoints/Kanban/KanbanEndpoints.cs:33` | Oznaczyć jako legacy debt. Przed finalnym standalone usunąć/zmigrować permission i nazewnictwo po potwierdzeniu, że nie jest używane przez dane lokalne; nie robić ślepej zmiany claimu bez migracji polityk. |
| Front klient API jest dowodem, że backend nie używa DataBus. | **niepotwierdzone** | Samo istnienie adaptera nie dowodzi runtime; mapa definiuje ten warunek w `backend-contract-map.md:12-14`, a aktualny import graph zawiera legacy | Dodać do review oddzielny gate: `rg` po Backend/Front + uruchomienie lokalnego API i logi requestów. Żadna trasa workspace nie może przechodzić przez Ready/Core/DataBus. |

## Wymagane zmiany w samej mapie

1. Przy avatarze `/api/v1/users/{userId}/avatar` zmienić ACL na `AllowAnonymous` i
   oznaczyć to jako decyzję do potwierdzenia bezpieczeństwa.
2. Przy revocation wskazać middleware OpenIddict, nie `BffEndpoints`.
3. Zastąpić `ReadyDirectoryUserResponse` przez `LocalUserDirectoryResponse`;
   w tabeli pól zakazać `readyUserId` i `coreUserId`.
4. Dodać kolumnę `Backend capability` / `Front runtime status`, aby nie mylić
   istniejącej trasy z gotową integracją Fluttera.
5. Rozszerzyć katalog Chat realtime o typing, presence, user status,
   reactions, delivery/read, pins i attachments oraz oznaczyć implementację
   Front per event.
6. Przy SignalR dopisać dwa warianty transportu: desktop bearer (obecnie
   istniejący) i web BFF cookie/origin (backendowa możliwość, brak kompletnego
   klienta Front).
7. Przenieść OnlyOffice callback i public share do kategorii integracyjnej /
   public tokenized, nie do zwykłych operacji użytkownika.
8. Zachować sekcję legacy debt dla wszystkich importów `ready_next`, pól
   `CoreUserId`/`ReadyUserId`, permission `RNext-admin` i komentarzy Core.

## Kolejność naprawy kontraktów

1. Najpierw ustalić finalny lokalny model identity (`Guid sub`) i usunąć z
   DTO/adaptorów Ready/Core; sprawdzić `/api/v1/me`, admin users i recovery.
2. Następnie zbudować typed local directory client oraz workspace/project/task
   clients na aktualnych kontraktach C#.
3. Oddzielić publiczne share/avatar/callback od chronionych repository i
   usunąć OnlyOffice callback z Fluttera.
4. Ustalić wspólny katalog eventów i testy SignalR: desktop bearer oraz web BFF
   cookie/origin. Dla weba nie stosować fikcyjnego JWT.
5. Dopiero po tym wykonywać pełny import scan, build Front, backend tests i
   prawdziwe E2E login → `/me` → workspace → task/Kanban → file → chat /
   notification → logout.

## Walidacja review

- Review jest dokumentacyjny; nie zmieniono kodu ani historii Git.
- Nie zapisano sekretów, tokenów ani danych użytkowników.
- Po zapisaniu pliku należy wykonać `git diff --check` oraz sprawdzić lokalny
  diff pliku. Brak błędów whitespace jest warunkiem przekazania review.
