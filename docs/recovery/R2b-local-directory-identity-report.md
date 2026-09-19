# R2b — lokalny katalog użytkowników i zaproszenia Workspaces

Data: 2026-09-17  
Repozytorium: `Front`  
Zakres: wyłącznie transport i kontrakt domenowy katalogu lokalnych użytkowników,
zaproszeń oraz bezpośrednio powiązanej odpowiedzi członkostwa.

## Cel

Usunięto z tego pionu identyfikatory Ready/Core i podłączono modele do
kanonicznego `UserId` (UUID) z backendu DevPlanner. Nie dodano aliasów,
fallbacków ani zgadywanych pól. Nie zmieniano Cubitów prezentacji, storage,
czatu, realtime, routingu, roota ani powiadomień.

## Dowód kontraktu Backend

Źródła zostały przeczytane, ale Backend nie był modyfikowany. Istotne linie:

- `Backend/Endpoints/Workspaces/WorkspaceEndpoints.cs:149-159` — `GET
  /{workspaceId}/users/search`, odpowiedź `IReadOnlyList<LocalUserDirectoryResponse>`;
  wyszukiwanie 2–80 znaków, maksymalnie 20 aktywnych i potwierdzonych kont,
  bez kont oczekujących, zablokowanych i dezaktywowanych.
- `WorkspaceEndpoints.cs:161-172` — `POST /{workspaceId}/invitations`, zaproszenie
  dotyczy istniejącego aktywnego i potwierdzonego konta wskazanego przez `UserId`;
  endpoint nie tworzy konta.
- `WorkspaceEndpoints.cs:174-192` oraz `194-204` — lista wysłanych/otrzymanych
  zaproszeń i akceptacja przez kanoniczny lokalny identyfikator użytkownika.
- `WorkspaceEndpoints.cs:416-443` — handler wyszukiwania zwraca lokalny katalog,
  a handler tworzenia przekazuje żądanie z `UserId` do backendu.
- `Backend/Contracts/Directory/LocalUserDirectoryResponse.cs:6-18` — pola:
  `Guid UserId`, `Login`, `DisplayName`, `string? Email`, `EmailVerified`,
  `Guid? AvatarFileId`.
- `Backend/Contracts/Workspaces/CreateWorkspaceInvitationRequest.cs:7-13` —
  `Guid UserId`, `WorkspaceRole Role`, opcjonalny `Message`.
- `Backend/Contracts/Workspaces/WorkspaceInvitationResponse.cs:7-19` —
  `Guid Id`, `WorkspaceId`, `UserId`, rola/status, snapshot loginu/nazwy/emailu
  oraz daty zaproszenia.
- `Backend/Contracts/Workspaces/WorkspaceMemberResponse.cs:7-13` — członkostwo
  zawiera `Guid Id`, `Guid UserId`, rolę i daty.

## Zmienione pliki

- `lib/workspaces/data/workspaces/responses/workspace_responses.dart` —
  `LocalUserDirectoryResponse`, `userId` w zaproszeniu i członkostwie,
  `avatarFileId`; importy lokalnego drzewa `devplanner`.
- `lib/workspaces/data/workspaces/responses/workspace_responses.freezed.dart` i
  `.g.dart` — wygenerowane serializery po zmianie kontraktu.
- `lib/workspaces/data/workspaces/payloads/workspace_payloads.dart` —
  `CreateWorkspaceInvitationPayload.userId: String` i lokalny import enumu.
- `lib/workspaces/data/workspaces/payloads/workspace_payloads.freezed.dart` i
  `.g.dart` — wygenerowane serializery emitujące JSON `userId`.
- `lib/workspaces/data/workspaces/api/workspaces_api.dart` i `.g.dart` —
  `searchLocalUsers`, typ `List<LocalUserDirectoryResponse>`, bez zmiany URL.
- `lib/workspaces/data/workspaces/repositories/workspaces_repository_impl.dart`
  — port i adapter używają `searchLocalUsers`, bez komunikatu Ready.
- `lib/workspaces/domain/repositories/workspaces_repository.dart` — port
  domenowy lokalnego katalogu i lokalnych zaproszeń.
- `test/workspaces/data/workspaces/local_directory_identity_contract_test.dart` —
  testy mapowania DTO, serializacji requestu i zgodności UserId między katalogiem,
  zaproszeniem i członkostwem.

## Skan przed/po

Przed zmianą w tym pionie występowały: `ReadyDirectoryUserResponse`,
`readyUserId`, `coreUserId`, `avatarUrl` oraz `searchReadyUsers`. Po zmianie:

```text
rg -n "ReadyDirectoryUserResponse|readyUserId|coreUserId|avatarUrl|searchReadyUsers" \
  lib/workspaces/data/workspaces/responses/workspace_responses.dart \
  lib/workspaces/data/workspaces/payloads/workspace_payloads.dart \
  lib/workspaces/data/workspaces/api/workspaces_api.dart \
  lib/workspaces/data/workspaces/api/workspaces_api.g.dart \
  lib/workspaces/data/workspaces/repositories/workspaces_repository_impl.dart \
  lib/workspaces/domain/repositories/workspaces_repository.dart \
  test/workspaces/data/workspaces
=> 0 wyników
```

To skan pionu katalogu/zaproszeń. Niezależne pola `createdByCoreUserId` w
`WorkspaceListItemResponse` i `WorkspaceResponse` pozostają poza tym pakietem;
ich migracja jest osobnym zadaniem workspace identity.

## Walidacja

- `flutter test test/workspaces/data/workspaces/local_directory_identity_contract_test.dart` — PASS, 3/3.
- `flutter analyze` dla modeli DTO, API, wygenerowanego API i testu — brak
  błędów; pozostały wyłącznie istniejące/automatyczne lint `info` w kodzie
  Retrofit (raw strings/document ignore) oraz sortowanie importów przed korektą.
- `dart format --output=none` dla wszystkich zmienionych źródeł i testu — PASS
  po korekcie importów.
- `git diff --check` — PASS.
- `dart run build_runner build --build-filter='lib/workspaces/data/workspaces/**'`
  nie jest globalnie zielony, ponieważ repo zawiera inne niekompletne modele
  bez rozwiązywalnych typów (`InvalidType`). Wygenerowane pliki tego pionu
  zostały zweryfikowane i pozostawiono tylko oczekiwane zmiany.

## Blokery i następny krok

Poza zakresem pozostały prezentacyjne i storage testy Cubitów, które nadal
odwołują się do starego API `searchReadyUsers`/starych nazw. Nie dodano aliasów,
aby nie utrwalać kontraktu Ready/Core; ich migracja wymaga osobnego pakietu
prezentacyjnego po ustabilizowaniu kompilacji roota.

Następny krok zgodnie z priorytetem nadrzędnym: compile/start root triage w
kolejności bootstrap → auth → app/router/shell → `/workspaces`. Nie należy
wracać do placeholdera strony Workspaces jako rozwiązania.
