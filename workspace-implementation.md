# Workspace — analiza i plan wdrożenia w Veloryn

Status: dokument roboczy do wspólnego planowania wdrożenia.

## Decyzja architektoniczna nr 1 — osobny backend i etapowa baza danych

`Workspace` będzie wdrażany jako osobny backend:

```text
veloryn-workspaces
```

Nie będzie modułem wewnątrz `veloryn-core`. `veloryn-core` pozostaje usługą tożsamości, logowania, sesji i wystawiania tokenów.

### Etap początkowy

`veloryn-workspaces` korzysta z własnej, osobnej bazy PostgreSQL. Oznacza to niezależne:

- połączenie bazodanowe,
- migracje EF Core,
- backupy i odtwarzanie,
- cykl wdrożeniowy,
- testy integracyjne.

Na tym etapie baza może być na tej samej maszynie, ale logicznie i konfiguracyjnie pozostaje odseparowana od bazy Core.

### Etap docelowy

Docelowo dane Workspace mogą zostać przeniesione do wspólnej instancji/bazy PostgreSQL używanej przez Core, ale nadal pozostaną w osobnym schemacie:

```text
veloryn_core.*
veloryn_workspaces.*
```

Wspólna baza nie oznacza połączenia modeli domenowych. `veloryn-workspaces` nadal będzie właścicielem swoich tabel, encji i migracji. Nie należy dodawać bezpośrednich kluczy obcych między schematami bez wyraźnej decyzji architektonicznej.

### Konsekwencje dla implementacji

- Od początku stosujemy schemat `veloryn_workspaces`, również w osobnej bazie.
- Connection string musi być konfigurowalny bez zmian w kodzie.
- Encje Workspace przechowują `CoreUserId` jako identyfikator zewnętrzny, bez lokalnego kopiowania użytkownika.
- Migracje muszą być uruchamiane przez `veloryn-workspaces`, nie przez Core.
- Przeniesienie do wspólnej bazy będzie zmianą konfiguracji i procesu migracji, a nie zmianą modelu domenowego.
- Core nie otrzymuje referencji do `WorkspaceDbContext`.
- DataBus nie otrzymuje bezpośredniego dostępu do tabel Workspace.

### Warunek przed migracją do wspólnej bazy

Przed przeniesieniem należy ustalić właściciela backupów, kolejność migracji, uprawnienia PostgreSQL oraz czy usługi będą używać jednego użytkownika DB, czy osobnych użytkowników z ograniczeniami do schematów. Rekomendowane są osobne użytkowniki DB i minimalne uprawnienia do własnego schematu.

## 1. Cel

Wprowadzić do ekosystemu Veloryn usługę `veloryn-workspaces`, inspirowaną architekturą starego backendu Dev Note i zaimplementowaną jako osobny backend w C# / ASP.NET Core.

`ready_next` jest klientem Flutter. Dokument znajduje się tutaj, aby plan backendu i późniejszej integracji UI był dostępny obok aplikacji.

Workspace ma być warstwą organizacyjną dla przyszłych modułów Veloryn:

```text
użytkownik Core
    └── Workspace
          ├── członkostwa i role
          ├── zaproszenia
          └── później: projekty, moduły, zakresy firm/spółek
```

## 2. Źródła i zakres odpowiedzialności

### Dev Note — wzorzec domenowy

Stary backend Dev Note posiada już większość potrzebnych pojęć:

- `WorkspaceEntity` z nazwą, opisem, ikoną i kolorem,
- `WorkspaceUserRole` jako tabelę członkostw użytkownika,
- role `Admin` i `User`,
- zaproszenia z cyklem życia `Pending`, `Accepted`, `Declined`, `Cancelled`,
- osobne repozytoria i serwisy dla workspace oraz zaproszeń,
- dziedziczenie dostępu z workspace do project, board i work item,
- sprawdzanie uprawnień w warstwie serwisowej przed operacją biznesową.

To jest dobry wzorzec podziału odpowiedzialności, ale nie należy przenosić bezpośrednio jego implementacji. Dev Note ma starszy model uwierzytelnienia, własnych użytkowników, inne konwencje błędów i inne założenia dotyczące ról.

### Obowiązująca architektura backendu — feature-first

Backend `veloryn-workspaces` zachowuje organizację Dev Note według domen
biznesowych, ale używa nowoczesnego podziału warstw ASP.NET Core. Nie tworzymy
płaskich, globalnych katalogów z przypadkami użycia wszystkich domen.

```text
veloryn-workspaces/
├── Endpoints/
│   ├── Auth/
│   ├── Workspaces/
│   ├── Projects/
│   ├── Tasks/
│   ├── Files/
│   └── ...
├── Application/
│   ├── Auth/
│   ├── Workspaces/
│   ├── Projects/
│   └── ...
├── Domain/
│   ├── Entities/
│   ├── Enums/
│   ├── Rules/
│   └── Events/
├── Contracts/
│   ├── Auth/
│   ├── Workspaces/
│   └── Common/
├── Validators/
│   ├── Auth/
│   ├── Workspaces/
│   └── ...
├── Infrastructure/
│   ├── Persistence/
│   ├── Core/
│   ├── Minio/
│   ├── Notifications/
│   └── Ai/
├── Migrations/
└── Tests/
```

Przykładowy przypadek użycia powinien być skupiony funkcjonalnie:

```text
Workspaces/CreateWorkspace/
├── CreateWorkspaceEndpoint.cs
├── CreateWorkspaceCommand.cs
├── CreateWorkspaceHandler.cs
├── CreateWorkspaceValidator.cs
└── CreateWorkspaceResponse.cs
```

Endpoint pozostaje cienki, Application prowadzi przypadek użycia, Domain
egzekwuje reguły, Infrastructure obsługuje EF Core i usługi zewnętrzne, a
Contracts są wyłącznie kontraktami HTTP. Ta decyzja obowiązuje przed rozpoczęciem
implementacji kolejnych endpointów.

### Veloryn Core — dostawca tożsamości

`Admin` z `veloryn-core` jest również `SuperAdmin` systemu Workspace. Jest to rola systemowa, niezależna od członkostwa w konkretnym workspace. SuperAdmin ma dostęp do wszystkich workspace’ów, projektów, zadań, plików, whiteboardów, dokumentów, członkostw, konfiguracji i historii audytowej. Może wykonywać operacje dostępne dla właściciela workspace, nawet jeśli nie został dodany do jego członkostwa.

SuperAdmin nie staje się właścicielem biznesowym workspace i nie zmienia automatycznie właściciela zapisanego w domenie. Globalny dostęp administracyjny nie oznacza automatycznego członkostwa ani subskrypcji komunikacji. SuperAdmin otrzymuje powiadomienia, wzmianki i bieżącą aktywność workspace tylko wtedy, gdy jest dodany do tego workspace jako członek. Każda operacja wykonana w trybie globalnym musi być oznaczona w audycie jako działanie SuperAdmina.

`veloryn-core` już zapewnia:

- `CoreUser` powiązany z `ReadyUserId`,
- własną bazę PostgreSQL i schemat `veloryn_core`,
- sesje refresh tokenów z rotacją i hashowaniem,
- JWT podpisywany RSA oraz JWKS,
- odczyt praw użytkownika z Ready,
- audyt zdarzeń,
- wspólny kontrakt błędów API i Minimal API.

Workspace powinien być osobną usługą, a nie tabelami w bazie Ready/eDokumenty ani częścią Pythonowego DataBus. `veloryn-core` dostarcza tożsamość i token, ale nie zarządza domeną Workspace.

### DataBus

DataBus pozostaje adapterem danych biznesowych z Firebird/PostgreSQL. Nie powinien przejmować zarządzania workspace, użytkownikami ani członkostwami. W przyszłości może:

- korzystać z tokenu Core,
- walidować JWT lokalnie przez JWKS,
- ograniczać dostęp do danych według `workspace_id`, jeśli pojawi się taki zakres biznesowy,
- ewentualnie dostarczać dane modułom działającym w workspace.

## 3. Docelowy zakres produktu

### Workspace

- utworzenie workspace przez zalogowanego użytkownika,
- automatyczne nadanie twórcy roli `Owner` albo `Admin`,
- lista workspace'ów użytkownika,
- szczegóły workspace,
- edycja nazwy, opisu, ikony i koloru przez administratora,
- usunięcie lub archiwizacja workspace przez administratora,
- bezpieczne sprawdzenie członkostwa przy każdej operacji.

### Osobiste preferencje listy workspace

- ukrywanie i ponowne pokazywanie workspace wyłącznie dla bieżącego użytkownika,
- przypinanie workspace na początku własnej listy,
- ręczna kolejność wszystkich widocznych workspace użytkownika,
- brak wpływu preferencji na członkostwo, role, dostęp oraz listy innych osób,
- sortowanie i filtrowanie wykonywane po stronie PostgreSQL.

### Członkostwa

- lista członków workspace,
- zmiana roli członka przez administratora,
- usunięcie członka przez administratora,
- opuszczenie workspace przez zwykłego członka,
- ochrona przed usunięciem lub obniżeniem ostatniego administratora.

### Zaproszenia

- wysłanie zaproszenia na istniejące konto Ready/Core,
- lista zaproszeń wysłanych w workspace,
- lista zaproszeń otrzymanych przez bieżącego użytkownika,
- akceptacja i odrzucenie zaproszenia,
- anulowanie oczekującego zaproszenia przez administratora,
- unikalność aktywnego zaproszenia dla pary workspace + użytkownik,
- jawna data wygaśnięcia zaproszenia.

### Zakres poza bieżącym etapem implementacji

- projekty, boardy i work itemy,
- wielopoziomowe role konfigurowane przez administratora,
- zakresy per firma/spółka (`ent_id`),
- billing i limity planów,
- zewnętrzni użytkownicy bez konta Ready,
- synchronizacja workspace z DataBus.

## 4. Model danych `veloryn-workspaces`

Tabele powinny od początku trafiać do schematu `veloryn_workspaces` i być zarządzane migracjami EF Core usługi `veloryn-workspaces`. W pierwszym etapie schemat znajduje się w osobnej bazie; docelowo może znaleźć się obok `veloryn_core` we wspólnej bazie PostgreSQL.

### `workspaces`

- `id uuid` — klucz główny,
- `name varchar(160)` — wymagane,
- `description varchar(2000)` — opcjonalne,
- `icon varchar(100)` — opcjonalne, wartość semantyczna zamiast ścieżki do pliku,
- `primary_color varchar(32)` — opcjonalne, zwalidowany format,
- `created_at_utc timestamptz`,
- `updated_at_utc timestamptz`,
- `archived_at_utc timestamptz` — zamiast natychmiastowego usuwania danych,
- `created_by_core_user_id uuid` — audyt twórcy.

### `workspace_memberships`

- `id uuid` — klucz główny,
- `workspace_id uuid`,
- `core_user_id uuid`,
- `role varchar` albo enum mapowany jawnie,
- `created_at_utc timestamptz`,
- `updated_at_utc timestamptz`,
- `revoked_at_utc timestamptz` — opcjonalnie przy historii członkostwa.

Indeks unikalny: `(workspace_id, core_user_id)`.

### `workspace_user_preferences`

- `id uuid` — klucz główny,
- `workspace_id uuid` — klucz obcy do `workspaces`,
- `core_user_id uuid` — właściciel osobistej preferencji,
- `is_hidden boolean` — ukrycie tylko na liście tego użytkownika,
- `is_pinned boolean` — przypięcie tylko na liście tego użytkownika,
- `sort_position bigint` — ręczna kolejność; `null` oznacza bezpieczną kolejność domyślną,
- `updated_at_utc timestamptz`,
- `xmin` — optimistic concurrency.

Indeks unikalny: `(workspace_id, core_user_id)`. Indeks listy użytkownika:
`(core_user_id, is_hidden, is_pinned, sort_position)`. Preferencja nie daje dostępu
do workspace i jest odrzucana dla użytkownika bez aktywnego dostępu.

### `workspace_invitations`

- `id uuid`,
- `workspace_id uuid`,
- `invited_core_user_id uuid` — zaproszenia dotyczą użytkowników istniejących w Ready,
- `invited_email varchar(320)` — kopia pomocnicza do wyświetlania i audytu,
- `invited_by_core_user_id uuid`,
- `role varchar`,
- `status varchar`,
- `message varchar(500)`,
- `created_at_utc timestamptz`,
- `expires_at_utc timestamptz`,
- `responded_at_utc timestamptz`,
- `cancelled_at_utc timestamptz`.

Indeks unikalny częściowy dla aktywnych zaproszeń: `(workspace_id, invited_core_user_id)` dla statusu `pending`.

### Role systemowe

Rekomendowane nazwy są bardziej jednoznaczne niż `Admin` / `User` z Dev Note:

- `SuperAdmin` — administrator systemowy pochodzący z `veloryn-core`; ma pełny dostęp do wszystkich workspace’ów i działa z uprawnieniami Ownera.
- `Owner` — właściciel workspace; co najmniej jeden musi istnieć,
- `Admin` — zarządza workspace i członkostwami,
- `Member` — korzysta z zasobów workspace,
- `Observer` — ma dostęp wyłącznie do odczytu.

Jeżeli chcemy zachować prostotę Dev Note, można zacząć od `Admin` i `Member`, ale model powinien być gotowy na `Owner` bez przebudowy API.

## 5. Uprawnienia

Workspace powinien używać dwóch poziomów autoryzacji:

1. `RequireAuthorization()` — token Core jest ważny.
2. Policy/serwis domenowy — użytkownik ma odpowiednią rolę w konkretnym workspace.

Nie należy wkładać członkostwa w claimy JWT. Członkostwa zmieniają się często, a token ma być ważny przez kilka minut i wspólny dla modułów. Token może zawierać prawa modułowe z Ready, natomiast dostęp do konkretnego workspace powinien być sprawdzany w Core na podstawie bazy.

Proponowane uprawnienia domenowe:

| Operacja | Wymagana rola |
|---|---|
| pełny dostęp do dowolnego workspace | SuperAdmin |
| otrzymywanie powiadomień workspace | członkostwo w workspace; SuperAdmin bez członkostwa nie otrzymuje |
| odczyt workspace i własnego członkostwa | Member |
| utworzenie workspace | zalogowany użytkownik |
| edycja danych workspace | Admin |
| archiwizacja workspace | Owner lub SuperAdmin |
| lista członków | Member |
| zmiana ról | Admin |
| zapraszanie użytkowników | Admin |
| anulowanie zaproszenia | Admin |
| akceptacja własnego zaproszenia | odbiorca zaproszenia |
| usunięcie członka | Admin; Owner chroniony; SuperAdmin bez ograniczenia workspace |
| opuszczenie workspace | Member, ale nie ostatni Admin/Owner |

Logika uprawnień powinna być w `WorkspaceAccessService` albo `WorkspaceAuthorizationService`, a nie duplikowana w endpointach.

## 6. Proponowany układ kodu w `veloryn-core`

```text
Features/Workspace/
  WorkspaceFeatureExtensions.cs
  WorkspaceOptions.cs
  Entities/
    Workspace.cs
    WorkspaceMembership.cs
    WorkspaceInvitation.cs
  Contracts/
    CreateWorkspaceRequest.cs
    UpdateWorkspaceRequest.cs
    WorkspaceResponse.cs
    WorkspaceMemberResponse.cs
    WorkspaceInvitationResponse.cs
    ChangeWorkspaceMemberRoleRequest.cs
  Services/
    IWorkspaceService.cs
    WorkspaceService.cs
    IWorkspaceAccessService.cs
    WorkspaceAccessService.cs
    IWorkspaceInvitationService.cs
    WorkspaceInvitationService.cs
  Endpoints/
    WorkspaceEndpoints.cs
    WorkspaceMemberEndpoints.cs
    WorkspaceInvitationEndpoints.cs

Infrastructure/Database/
  WorkspaceDbContext.cs
  Migrations/...

Tests/Features/Workspace/
  WorkspaceServiceTests.cs
  WorkspaceAccessServiceTests.cs
  WorkspaceInvitationServiceTests.cs
  WorkspaceEndpointTests.cs
```

Rejestracja usługi powinna mieć własne `AddWorkspaceServices()` i `MapWorkspaceEndpoints()`, w stylu feature extensions Core, ale bez dodawania zależności do `CoreDbContext`.

## 7. API v1 — propozycja

```text
POST   /api/v1/workspaces
GET    /api/v1/workspaces
PATCH  /api/v1/workspaces/{workspaceId}/preferences
PUT    /api/v1/workspaces/preferences/order
GET    /api/v1/workspaces/{workspaceId}
PATCH  /api/v1/workspaces/{workspaceId}
DELETE /api/v1/workspaces/{workspaceId}       # preferowana semantyka: archiwizacja

GET    /api/v1/workspaces/{workspaceId}/members
PATCH  /api/v1/workspaces/{workspaceId}/members/{coreUserId}/role
DELETE /api/v1/workspaces/{workspaceId}/members/{coreUserId}
POST   /api/v1/workspaces/{workspaceId}/leave

GET    /api/v1/workspaces/{workspaceId}/invitations
POST   /api/v1/workspaces/{workspaceId}/invitations
DELETE /api/v1/workspaces/{workspaceId}/invitations/{invitationId}

GET    /api/v1/me/workspace-invitations
POST   /api/v1/me/workspace-invitations/{invitationId}/accept
POST   /api/v1/me/workspace-invitations/{invitationId}/decline
```

Każda odpowiedź powinna używać kompatybilnego kontraktu błędów z Core. Warto przyjąć `404` także dla braku dostępu do nieistniejącego workspace, aby ograniczyć ujawnianie jego istnienia.

## 8. Integracja z `ready_next`

Flutter powinien dostać osobny feature:

```text
lib/features/workspace/
  data/api/workspace_api.dart
  data/models/workspace_models.dart
  data/repositories/workspace_repository.dart
  application/workspace_cubit.dart
  presentation/pages/workspaces_page.dart
  presentation/pages/workspace_detail_page.dart
  presentation/pages/workspace_members_page.dart
  presentation/pages/workspace_invitations_page.dart
```

Integracja powinna wykorzystać istniejące:

- `AuthRepository` i interceptor odświeżania tokenu,
- `AppApiFactory` / klient Core,
- AutoRoute i istniejące guardy,
- wspólne komponenty layoutu, formularzy, dialogów i stanów ładowania.

Menu modułu powinno pokazywać workspace dopiero po zalogowaniu. Samo ukrycie przycisku nie jest zabezpieczeniem — autoryzacja pozostaje w Core.

## 9. Integracja z DataBus

Na początku brak bezpośredniej zależności Workspace → DataBus.

Jeśli dane DataBus będą później izolowane per workspace, należy ustalić jeden z wariantów:

1. `workspace_id` jest lokalnym kontekstem aplikacyjnym, a DataBus otrzymuje je w nagłówku i sam mapuje na dozwolone źródła danych.
2. `veloryn-workspaces` wystawia endpoint sprawdzający członkostwo, a DataBus używa go tylko przy operacjach wymagających świeżej autoryzacji.
3. Token zawiera stabilny identyfikator użytkownika, a DataBus ma własną tabelę mapowań użytkownik → workspace.

Rekomendacja: nie rozszerzać JWT o listę workspace'ów. Dla zwykłych zapytań DataBus powinien używać własnego cache/mapowania, a dla operacji administracyjnych pytać `veloryn-workspaces` albo korzystać z krótkiego cache decyzji.

## 10. Kolejność wdrożenia

### Etap 0 — decyzje przed kodem

- potwierdzić `Owner/Admin/Member` albo prostsze `Admin/Member`,
- potwierdzić archiwizację zamiast twardego usuwania,
- ustalić, czy zaproszenia są tylko dla istniejących użytkowników,
- ustalić czas ważności zaproszenia,
- ustalić, które moduły będą pierwszymi klientami `veloryn-workspaces`.

### Etap 1 — model i migracja

- encje i konfiguracja EF Core,
- relacje do `CoreUser`,
- indeksy i ograniczenia unikalności,
- migracja PostgreSQL,
- test migracji i modelu.

### Etap 2 — dostęp i serwis domenowy

- `WorkspaceAccessService`,
- reguły ostatniego administratora,
- serwis CRUD workspace,
- audyt utworzenia, edycji, archiwizacji i zmian członkostwa.

### Etap 3 — członkostwa i zaproszenia

- listowanie członków,
- zmiana ról i usuwanie członków,
- wysyłanie/anulowanie/akceptacja/odrzucenie zaproszeń,
- testy wyścigów i podwójnej akceptacji.

### Etap 4 — API i kontrakt OpenAPI

- endpointy `/api/v1/workspaces`,
- statusy HTTP i kontrakty błędów,
- opisy Swaggera po polsku,
- testy 401/403/404/409,
- testy izolacji workspace między użytkownikami.

### Etap 5 — klient Flutter

- modele i repository,
- cubity/stany,
- lista workspace,
- formularz tworzenia i edycji,
- członkowie i zaproszenia,
- routing i menu.

### Etap 6 — integracja modułów

- przekazywanie aktywnego workspace w kontekście aplikacji,
- kontrakt dla przyszłych modułów,
- dopiero potem decyzja o integracji z DataBus.

## 11. Testy wymagane przed uznaniem modułu za produkcyjny

- użytkownik bez JWT dostaje `401`,
- SuperAdmin z `veloryn-core` widzi i administruje każdym workspace niezależnie od członkostwa,
- użytkownik spoza workspace nie widzi jego danych,
- Member nie może edytować workspace ani zarządzać członkami,
- Admin może zarządzać członkami tylko własnego workspace,
- nie można usunąć ostatniego administratora,
- zaproszenie nie może zostać zaakceptowane dwa razy,
- nie można utworzyć dwóch aktywnych zaproszeń dla tej samej osoby,
- akceptacja zaproszenia atomowo tworzy członkostwo i zamyka zaproszenie,
- równoległa zmiana roli nie powoduje utraty danych,
- usunięty/nieaktywny użytkownik nie otrzymuje dostępu,
- archiwizowany workspace nie pojawia się na liście aktywnych workspace'ów,
- migracja działa na pustej i istniejącej bazie `veloryn-workspaces`.

## 12. Ryzyka i decyzje architektoniczne

### Najważniejsze ryzyka

- umieszczenie członkostw w JWT doprowadziłoby do nieaktualnych uprawnień,
- twarde usuwanie workspace może zniszczyć historię audytową i dane modułów,
- brak ograniczeń unikalności pozwoli na duplikaty członkostw/zaproszeń,
- akceptacja zaproszenia bez transakcji może utworzyć członkostwo bez zamknięcia zaproszenia,
- cache uprawnień lokalny dla procesu nie jest odpowiedni jako jedyne źródło prawdy przy wielu instancjach.

### Rekomendacje

- `veloryn-workspaces` jest źródłem prawdy dla workspace i członkostw,
- Ready jest źródłem tożsamości i istniejących praw systemowych,
- JWT zawiera identyfikację i prawa modułowe, ale nie członkostwa workspace,
- operacje zaproszeń i członkostw używają transakcji oraz ograniczeń DB,
- zamiast kopiować Dev Note 1:1 stosujemy feature-based structure inspirowaną Core,
- DataBus nie przejmuje domeny Workspace.

## 13. Pierwszy pakiet implementacyjny

Najmniejszy sensowny pierwszy increment:

1. `Workspace`, `WorkspaceMembership` i migracja.
2. `POST /api/v1/workspaces`.
3. `GET /api/v1/workspaces`.
4. `GET /api/v1/workspaces/{id}`.
5. `WorkspaceAccessService` z rolami `Admin`/`Member`.
6. Testy izolacji i autoryzacji.

Zaproszenia i ekran członków powinny wejść w następnym pakiecie, po ustabilizowaniu modelu członkostwa.

## 14. Otwarte pytania na dzisiejsze planowanie

- Czy workspace jest globalnym kontenerem dla całego Veloryn, czy początkowo tylko dla konkretnego modułu?
- Czy wybieramy `Owner/Admin/Member`, czy zachowujemy `Admin/Member` z Dev Note?
- Czy usunięcie oznacza archiwizację?
- Czy workspace może mieć wielu administratorów?
- Czy zaproszenia wysyłamy tylko do istniejących kont Ready?
- Czy użytkownik może należeć do wielu workspace'ów?
- Czy jeden aktywny workspace będzie przechowywany lokalnie w `ready_next`?
- Kiedy i czy `workspace_id` ma być przekazywany do DataBus?

## 15. Rozdzielenie zadań i tablic z karteczkami

To są dwa różne narzędzia i nie powinny być traktowane wyłącznie jako dwa widoki tego samego obiektu.

### Lista zadań

Lista zadań służy do uporządkowanej realizacji pracy. Zadanie może posiadać podzadania, ale tylko jeden poziom w dół:

```text
Zadanie główne: Przygotować ofertę dla klienta
  ├── Podzadanie: Zebrać wymagania
  ├── Podzadanie: Przygotować kalkulację
  └── Podzadanie: Wysłać ofertę
```

Model nie powinien pozwalać na `podzadanie → kolejne podzadanie`. Jednopoziomowa hierarchia uprości interfejs, raportowanie, zapytania i synchronizację z innymi modułami.

Zadanie powinno obsługiwać:

- tytuł i opis,
- status,
- osobę odpowiedzialną,
- obserwujących,
- termin rozpoczęcia i termin wykonania,
- priorytet,
- etykiety,
- estymację i rzeczywisty czas,
- komentarze i wzmianki,
- załączniki,
- checklistę,
- zależności od innych zadań,
- historię zmian,
- archiwizację.

### Tablica z karteczkami

Tablica jest przestrzenią wizualnej współpracy przy projekcie. Karteczka może reprezentować:

- pomysł,
- problem,
- ryzyko,
- pytanie,
- decyzję,
- temat do omówienia,
- notatkę,
- tymczasowy element planowania.

Karteczka nie musi mieć osoby odpowiedzialnej, terminu ani pełnego workflow zadania.

Przykładowa tablica:

```text
Pomysły       Do omówienia       Zaakceptowane       Odrzucone
-------------------------------------------------------------
Nowy moduł    Problem z API      Wersja mobilna      Stary pomysł
```

### Powiązanie karteczki z zadaniem

`BoardCard` powinien być osobnym obiektem, który może opcjonalnie wskazywać zadanie:

- karteczka może istnieć samodzielnie,
- karteczkę można zamienić w zadanie,
- karteczka może być powiązana z istniejącym zadaniem,
- zadanie może mieć odnośnik do karteczki,
- konwersja nie powinna kopiować i utrzymywać dwóch niezależnych treści.

Po konwersji karteczka powinna pozostać w historii z oznaczeniem `Converted` i odnośnikiem do utworzonego zadania.

### Umiejscowienie w projekcie

```text
Workspace
└── Projekt
    ├── Lista zadań
    ├── Tablice z karteczkami
    ├── Pliki
    └── Dokumenty
```

Projekt może mieć wiele tablic, np. tablicę pomysłów, planowania sprintu, ryzyk albo retrospektywy. W późniejszym etapie można dodać tablice dostępne dla całego workspace.

## 16. Rekomendowany zestaw funkcji produktu

### Pełny zakres funkcji produktu

Pierwsza wersja powinna koncentrować się na funkcjach, które tworzą użyteczny przepływ pracy:

- tworzenie i archiwizowanie workspace,
- zapraszanie użytkowników,
- role i uprawnienia workspace,
- tworzenie projektów,
- lista zadań,
- zadania główne i jednopoziomowe podzadania,
- podstawowe statusy i priorytety,
- przypisanie użytkownika,
- terminy,
- komentarze,
- załączniki w MinIO,
- podstawowa tablica z karteczkami,
- konwersja karteczki w zadanie,
- historia aktywności,
- wyszukiwanie w obrębie workspace.

### Funkcje pracy zespołowej

- komentarze z `@wzmiankami`,
- obserwowanie zadań i projektów,
- powiadomienia o przypisaniu, komentarzu i terminie,
- centrum powiadomień,
- aktywność projektu i workspace,
- zespoły w ramach workspace,
- status obecności lub ostatniej aktywności użytkownika,
- wspólne dashboardy.

### Funkcje zarządzania zadaniami

- filtrowanie po statusie, osobie, terminie, priorytecie i etykiecie,
- zapisane widoki,
- sortowanie i grupowanie,
- checklisty,
- zależności `blocked by` / `blocks`,
- kamienie milowe,
- zadania cykliczne,
- szablony zadań,
- archiwum i przywracanie,
- masowe zmiany zadań.

### Funkcje tablic

- tworzenie wielu tablic w projekcie,
- kolumny i własne nazwy statusów,
- przeciąganie karteczek,
- kolory karteczek,
- tagi i filtry,
- komentarze na karteczkach,
- przypinanie plików i linków,
- historia przesuwania karteczki,
- tryb prezentacji lub pełnoekranowej tablicy,
- konwersja karteczki do zadania.

### Pliki i dokumenty

### Pliki, Magazyn i Uniwersalny Storage Engine

Pliki są realizowane jako **uniwersalny feature w backendzie `veloryn-workspaces`** (`Storage Engine`), zaprojektowany w taki sposób, aby w przyszłości mogły z niego korzystać bez duplikacji kodu także inne moduły systemu (np. **Inwentaryzacja**, **BHP**, **IQC**, **Flota**, **Zamówienia**).

MinIO / S3 przechowuje wyłącznie binarne dane obiektów, natomiast baza PostgreSQL w schemacie `veloryn_workspaces` przechowuje kompletne metadane:

- `Id` (GUID / UUID),
- `Module` — moduł źródłowy (`workspaces`, `inventory`, `bhp`, `iqc`, `fleet`, `orders`, `shared`),
- `ResourceType` / `EntityType` — typ encji (`task`, `comment`, `sheet`, `accident_protocol`, `machine`, `user_avatar`, `workspace_doc`),
- `ResourceId` / `EntityId` — identyfikator obiektu domenowego,
- `StorageObjectKey` — ścieżka obiektu w MinIO,
- `OriginalFileName`, `Extension`, `MimeType`, `FileSizeBytes`, `ContentSha256` (deduplikacja),
- `OwnerUserId`, `CreatedByUserId`, `CreatedAtUtc`, `UpdatedAtUtc`,
- `Version` — numer wersji pliku (wersjonowanie),
- `ScanStatus` (`Pending`, `Clean`, `Infected`, `Skipped`) — status skanowania antywirusowego (ClamAV),
- `ProcessingStatus` (`None`, `Processing`, `Ready`, `Failed`) — optymalizacja multimediów,
- `IsDeleted`, `DeletedAtUtc`, `DeletedByUserId` (soft-delete / kosz z 30-dniową retencją),
- **Pola i metadane AI:**
  - `AiStatus` (`None`, `Queued`, `Processing`, `Completed`, `Failed`),
  - `AiDescription` — automatyczny opis zawartości wygenerowany przez AI (ze zdjęć, rysunków, schematów),
  - `AiTags` — tagi i słowa kluczowe wykryte przez AI,
  - `AiSummary` — streszczenie długich dokumentów i protokołów,
  - `AiOcrText` — tekst wyekstrahowany z obrazów/skanów przez OCR/AI,
  - `AiProcessedAtUtc` — stempel czasu ostatniej analizy AI.

### Edycja i współbieżna praca na dokumentach Office — OnlyOffice Docs

Do edycji i podglądu dokumentów biurowych wykorzystujemy kontener Docker **OnlyOffice Document Server** (`onlyoffice/documentserver`):

1. **Współpraca wielu osób w czasie rzeczywistym:**
   - Tryb *Fast* (jak w Google Docs — widok zmian na żywo znak po znaku) lub *Strict* (blokada akapitu do zatwierdzenia),
   - Wspólne komentowanie, czat w dokumencie, śledzenie zmian (Track Changes / rewizje) oraz historia wersji.
2. **Obsługiwane formaty:**
   - Pełna natywna edycja `DOCX`, `XLSX`, `PPTX` oraz formularzy `OFORM`,
   - Przeglądarka i wypełnianie formularzy `PDF`.
3. **Protokół integracji (Callback API & JWT):**
   - Backend `veloryn-workspaces` generuje zabezpieczony token JWT i konfigurację sesji dla edytora w przeglądarce (we Flutterze renderowany przez iframe / webview).
   - Po zamknięciu lub w trakcie sesji edycji OnlyOffice wysyła callback do backendu, a backend atomowo tworzy nową wersję pliku (`v2`, `v3`...) w MinIO i bazie.

### Optymalizacja multimediów po stronie serwera

Wszystkie wgrywane zdjęcia i materiały wideo są asynchronicznie przetwarzane i optymalizowane w tle:

1. **Zdjęcia i grafiki:**
   - Pipeline przetwarzania (np. `ImageSharp` w .NET):
     - Kaskada miniaturek: `thumb` (150px), `preview` (600px), `full` (1920px),
     - Automatyczna konwersja do nowoczesnych formatów webowych (**WebP / AVIF**), redukująca rozmiar o 70–80%,
     - Oczyszczanie niepotrzebnych metadanych EXIF (np. GPS z powodów prywatności), z opcją zachowania daty i parametrów technicznych (kluczowe przy inspekcjach BHP/inwentaryzacji).
2. **Wideo i Streaming:**
   - Asynchroniczny worker z narzędziem **FFmpeg**:
     - Transkodowanie i kompresja do zoptymalizowanego formatu webowego **MP4 (H.264 / AAC)** z flagą `faststart` (`moov atom` na początku pliku), umożliwiającą natychmiastowe odtwarzanie bez czekania na pobranie całego pliku,
     - Opcjonalne generowanie segmentów **HLS (HTTP Live Streaming — `.m3u8` / `.ts`)** z adaptacyjną jakością (1080p, 720p, 480p) dopasowującą się do przepustowości łącza użytkownika,
     - Obsługa **HTTP Byte-Range Requests (`206 Partial Content`)** pozwalająca na płynne przewijanie (`seek`) wideo w odtwarzaczu Flutter / Web,
     - Automatyczne generowanie klatki podglądu (plakat wideo / poster frame),
     - Zapis metadanych wideo: rozdzielczość, bitrate, czas trwania w sekundach.

### Zaawansowane funkcje Enterprise Storage

1. **Wersjonowanie i przywracanie:**
   - Zapis każdej modyfikacji pliku z historią autorów zmian, możliwością pobrania historycznej wersji i przywrócenia jej jako aktywnej.
2. **Konwersja formatów i eksport do PDF w locie (OnlyOffice Conversion API):**
   - Bezstratna konwersja `DOCX`, `XLSX`, `PPTX`, `ODT` -> `PDF` na żądanie (np. do druku, pobrania raportu, oficjalnych protokołów BHP i arkuszy inwentaryzacji).
3. **Masowe operacje i paczki ZIP w locie (Bulk ZIP Download & Multi-upload):**
   - Generowanie i strumieniowanie archiwum `.zip` w locie bezpośrednio ze storage'u dla wszystkich załączników zadania, projektu lub arkusza bez obciążania pamięci RAM serwera.
   - Wsparcie dla masowego uploadu wielu plików równolegle z raportowaniem postępu.
4. **Deduplikacja danych (Content-Addressable Storage — SHA-256):**
   - Wykrywanie istniejącego hasha zawartości w MinIO — unikanie duplikowania identycznych dużych plików między różnymi modułami i użytkownikami.
5. **Wyszukiwanie pełnotekstowe (Full-Text Search) i OCR:**
   - Indeksowanie treści z `PDF`, `DOCX`, `XLSX`, `TXT` do wyszukiwarki globalnej,
   - OCR dla zdjęć i skanów dokumentów.
6. **Znakowanie wodne w locie (Watermarking):**
   - Dynamiczny znak wodny nakładany na poufne dokumenty PDF/obrazy (np. *„Pobrano: Jan Kowalski, 2026-08-17”*).
7. **Kosz (Trash), retencja i odzyskiwanie:**
   - Soft-delete z 30-dniowym okresem ochronnym przed trwałym usunięciem z MinIO.
8. **Bezpieczne linki zewnętrzne (Public Sharing):**
   - Generowanie linku z hasłem, datą wygaśnięcia i limitem pobrań dla zewnętrznych podwykonawców/audytorów.
9. **Skaner antywirusowy (ClamAV w Dockerze):**
   - Asynchroniczne sprawdzanie plików w tle przed udostępnieniem statusu `Clean`.
10. **Resumable / Chunked Upload:**
    - Obsługa wznawiania uploadu dla dużych plików i materiałów wideo.

### Rozdzielenie obszarów plików w UI

Użytkownik widzi logicznie rozdzielone widoki:

```text
Pliki
├── Moje pliki (prywatna przestrzeń użytkownika)
├── Udostępnione mi (pliki od innych osób i zespołów)
├── Pliki workspace / modułu (wspólne zasoby zespołu, dokumenty)
└── Pliki powiązane (załączniki projektów, zadań, arkuszy, protokołów)
```

#### Moje pliki

Prywatna przestrzeń użytkownika:

- właścicielem jest konkretny użytkownik (`OwnerUserId`),
- domyślnie nikt poza nim nie ma dostępu,
- użytkownik może tworzyć foldery i kolekcje,
- użytkownik może udostępniać wybrane pliki innym użytkownikom z poziomem uprawnień (`Viewer`, `Editor`, `Owner`),
- plik może zostać dołączony do projektu lub zadania bez utraty pierwotnego właściciela,
- usunięcie pliku przenosi go do kosza użytkownika.

#### Udostępnione mi

Widok plików i folderów, do których użytkownik otrzymał jawne uprawnienia od innych osób lub zespołów, ze wskazaniem właściciela i zakresu praw.

#### Pliki workspace / modułu

Wspólna przestrzeń organizacji i zespołów:

- logicznym właścicielem jest workspace lub moduł (np. Inwentaryzacja / BHP),
- dostęp wynika z członkostwa i ról w danej domenie,
- pliki i szablony nie znikają po odejściu użytkownika,
- zachowana pełna historia utworzenia, modyfikacji i audytu pobrań.

#### Pliki powiązane (załączniki kontekstowe)

Załączniki do konkretnych obiektów biznesowych:

- zadania, podzadania, komentarze, arkusze inwentaryzacyjne, protokoły wypadkowe BHP, karty urządzeń IQC itp.,
- dostęp dziedziczony z uprawnień do obiektu nadrzędnego,
- usunięcie zadania lub obiektu nie kasuje natychmiast fizycznego pliku bez polityki retencji.

### Rekomendacja dla MinIO i Bezpieczeństwo

Pliki są całkowicie prywatne. Bucket MinIO nie może być publiczny, a obiekty nie mogą być dostępne przez stały, anonimowy URL.

Prawidłowy przepływ:

```text
Klient (Flutter / Web)
  │ Authorization: Bearer <JWT Core>
  ▼
veloryn-workspaces (Storage Feature)
  ├── waliduje podpis, issuer, audience i termin JWT
  ├── weryfikuje uprawnienia użytkownika do modułu / obiektu / pliku
  └── wydaje dostęp wyłącznie do konkretnego pliku
       │
       ├── krótkotrwały presigned URL (upload PUT / pobieranie GET)
       └── token sesji OnlyOffice (do edycji i podglądu DOCX/XLSX/PDF)
             ▼
       Prywatny MinIO & OnlyOffice Document Server
```

Sugerowany układ kluczy obiektów w MinIO:

```text
workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}/{fileId}/{version}/{fileName}
workspaces/{workspaceId}/shared/{fileId}/{version}/{fileName}
inventory/{sheetId}/{fileId}/{version}/{fileName}
bhp/{protocolId}/{fileId}/{version}/{fileName}
users/{userId}/private/{fileId}/{version}/{fileName}
thumbnails/{fileId}/{size}/{format}
```

### Funkcje administracyjne

- panel administratora systemu,
- lista wszystkich workspace,
- blokowanie i odblokowanie workspace,
- podgląd liczby użytkowników i wykorzystania plików,
- audyt operacji administracyjnych,
- zarządzanie limitami,
- konfiguracja retencji danych,
- raport błędów i zdarzeń bezpieczeństwa.

SuperAdmin ma dostęp administracyjny do wszystkich workspace i uprawnienia Ownera, ale wszystkie operacje muszą być rejestrowane w audycie wraz z informacją, że zostały wykonane poza członkostwem workspace.

### Funkcje późniejszego etapu

- widok listy, Kanban, kalendarz i Gantt dla zadań,
- sprinty i backlog,
- pola niestandardowe,
- automatyzacje,
- formularze tworzące zadania,
- cele i OKR,
- raportowanie czasu,
- integracja z kalendarzem,
- integracja z pocztą i komunikatorami,
- publiczne linki do wybranych projektów,
- zewnętrzni goście bez konta Ready.

## 17. Zasada produktowa

System powinien rozróżniać trzy poziomy pracy:

1. **Zadanie** — konkretna praca do wykonania.
2. **Podzadanie** — mniejszy krok należący do zadania głównego.
3. **Karteczka** — wizualna informacja, pomysł lub temat współpracy, który nie musi być zadaniem.

To rozdzielenie pozwoli połączyć prostotę Asany i Monday z elastycznością ClickUpa oraz kontrolą workflow znaną z Jiry, bez zmuszania użytkownika do traktowania każdej notatki jako formalnego zadania.

## 18. Synteza produktu — funkcje wybrane do wdrożenia

### Kierunek produktu

Budujemy system zarządzania pracą dla zespołów, który łączy:

- prostotę Asany,
- wizualność Monday,
- elastyczność ClickUpa,
- kontrolę workflow i audyt z Jiry,
- własne tablice z niezależnymi karteczkami,
- prywatne i współdzielone pliki zabezpieczone przez backend i MinIO.

System nie powinien od początku kopiować wszystkich funkcji konkurencji. Najpierw należy zbudować stabilny model Workspace → Project → Task oraz osobny model BoardCard.

### Fundament produktu — P0

To funkcje wymagane, aby system miał sens jako pierwsza wersja:

#### Workspace i użytkownicy

- tworzenie workspace przez każdego użytkownika,
- członkowie z Ready, również przed pierwszym logowaniem do RNext,
- zaproszenia e-mailowe,
- role `SuperAdmin`, `Owner`, `Admin`, `Member`,
- ochrona przed usunięciem ostatniego administratora,
- lista workspace użytkownika,
- panel administratora systemu z dostępem do wszystkich workspace,
- audyt działań administratora.

#### Projekty

- tworzenie projektów w workspace,
- archiwizacja projektu,
- opis projektu i właściciel,
- członkowie projektu lub dziedziczenie dostępu z workspace,
- status projektu: planowany, aktywny, wstrzymany, zakończony,
- podstawowy widok projektu z opisem, zadaniami, plikami i aktywnością.

#### Zadania

- zadanie główne,
- podzadania tylko jeden poziom w dół,
- jeden główny assignee,
- obserwujący,
- status,
- priorytet,
- termin wykonania,
- opis,
- komentarze,
- załączniki,
- checklisty,
- etykiety,
- historia zmian,
- archiwizacja zamiast natychmiastowego usuwania.

#### Tablice karteczek

- wiele tablic w projekcie,
- kolumny konfigurowane przez użytkownika,
- niezależne karteczki,
- kolor i etykiety karteczek,
- komentarze i załączniki,
- przeciąganie między kolumnami,
- historia zmian pozycji,
- konwersja karteczki do zadania,
- oznaczenie karteczki jako `Converted` po konwersji.

#### Pliki

- `Moje pliki`,
- `Udostępnione mi`,
- `Pliki workspace`,
- pliki projektów i zadań,
- MinIO jako prywatny storage,
- metadane plików w bazie Workspace,
- sprawdzanie JWT i uprawnień przed dostępem,
- krótkotrwałe presigned URL-e,
- kosz i przywracanie,
- limit przestrzeni workspace.

#### Współpraca

- komentarze,
- wzmianki `@user`,
- aktywność workspace, projektu, zadania i karteczki,
- podstawowe powiadomienia,
- centrum powiadomień,
- wyszukiwanie w obrębie workspace.

### Kolejny etap implementacji — P1

Po wdrożeniu fundamentów technicznych należy dodać funkcje zwiększające produktywność:

- `My Tasks` — wszystkie zadania przypisane do użytkownika,
- Inbox powiadomień i zmian,
- zapisane filtry i widoki,
- sortowanie i grupowanie zadań,
- kamienie milowe,
- zależności `blocks` / `blocked by`,
- kalendarz zadań,
- timeline projektu,
- zadania cykliczne,
- szablony projektów i zadań,
- formularze tworzące zadania,
- podstawowe reguły automatyzacji,
- zespoły w workspace,
- dashboard projektu,
- wersjonowanie plików,
- podgląd PDF i obrazów,
- pełny audyt zmian uprawnień.

### Trzeci etap — P2

Funkcje zaawansowane, które powinny powstać dopiero po zebraniu danych od użytkowników:

- tablice Kanban pokazujące zadania jako widok operacyjny,
- backlog i sprinty,
- Gantt z zależnościami,
- pola niestandardowe,
- wieloprojektowe dashboardy,
- portfolio projektów,
- workload i obciążenie zespołów,
- raportowanie czasu,
- cele i OKR,
- publiczne formularze,
- zaawansowane automatyzacje,
- integracje z kalendarzem, pocztą i komunikatorami,
- zewnętrzni goście bez konta Ready.

### Zasady, których nie zmieniamy

- `BoardCard` i `Task` są różnymi obiektami.
- Podzadania mają maksymalnie jeden poziom.
- Tablica karteczek nie jest automatycznie tablicą zadań.
- Workspace jest właścicielem plików workspace.
- Użytkownik jest właścicielem swoich prywatnych plików.
- „Udostępnione mi” jest widokiem, a nie osobnym magazynem.
- MinIO nie jest publiczne.
- JWT jest sprawdzany w backendzie przed wydaniem dostępu do pliku.
- Zaproszenie może istnieć przed pierwszym logowaniem użytkownika do RNext.
- `ReadyUserId` służy do powiązania zaproszenia, a `CoreUserId` do aktywnej sesji.
- Administrator systemu ma dostęp do wszystkich workspace, ale każda operacja jest audytowana.
- Usunięcie oznacza domyślnie archiwizację i możliwość przywrócenia.

## 19. Plan działania

### Krok 1 — zamknięcie decyzji produktowych

Przed rozpoczęciem implementacji należy zatwierdzić:

- nazwy i znaczenie ról,
- czy w przyszłości potrzebna będzie rola `Guest` (obecnie system jest zamknięty),
- czy projekt dziedziczy dostęp z workspace,
- czy każdy projekt może mieć prywatnych członków,
- czas ważności zaproszenia,
- limity plików i użytkowników,
- politykę archiwizacji,
- sposób wysyłki wiadomości e-mail,
- czy pierwszy ekran po zalogowaniu pokazuje listę workspace czy ostatni aktywny workspace.

### Krok 2 — kontrakt domenowy

Spisać i zatwierdzić encje:

```text
Workspace
WorkspaceMembership
WorkspaceInvitation
Project
ProjectMembership
Task
TaskComment
TaskAttachment
Subtask
Board
BoardColumn
BoardCard
BoardCardComment
File
FileShare
ActivityEvent
Notification
```

Na tym etapie należy również ustalić, które relacje są wymagane, a które opcjonalne.

### Krok 3 — przepływy użytkownika

Najpierw opisać scenariusze, zanim powstanie API:

1. utworzenie workspace,
2. zaproszenie użytkownika Ready, który nie logował się jeszcze do RNext,
3. otrzymanie e-maila,
4. pierwsze logowanie,
5. akceptacja zaproszenia,
6. utworzenie projektu,
7. utworzenie zadania i podzadań,
8. utworzenie tablicy karteczek,
9. konwersja karteczki do zadania,
10. upload i pobranie prywatnego pliku,
11. odebranie dostępu użytkownikowi,
12. archiwizacja i przywrócenie projektu.

### Krok 4 — Implementacja techniczna

Kolejność prac:

1. osobny backend `veloryn-workspaces`,
2. osobna baza PostgreSQL ze schematem `veloryn_workspaces`,
3. walidacja JWT Core przez JWKS,
4. Workspace i członkostwa,
5. zaproszenia Ready i e-mail,
6. Projekty,
7. Zadania i jednopoziomowe podzadania,
8. BoardCard i tablice,
9. pliki i MinIO,
10. komentarze, aktywność i powiadomienia,
11. API i testy izolacji danych,
12. integracja z `ready_next`.

### Krok 5 — kryteria gotowości produkcyjnej

Zakres można uznać za gotowy produkcyjnie, gdy:

- użytkownik może utworzyć workspace,
- może zaprosić użytkownika istniejącego tylko w Ready,
- zaproszony użytkownik otrzymuje e-mail,
- użytkownik może zalogować się później i zaakceptować zaproszenie,
- workspace jest niewidoczny dla osób spoza niego,
- można utworzyć projekt i zadania,
- podzadania nie mogą tworzyć kolejnego poziomu,
- karteczki działają niezależnie od zadań,
- karteczkę można zamienić w zadanie,
- pliki są niedostępne bez JWT i odpowiednich uprawnień,
- administrator może zobaczyć wszystkie workspace,
- usunięte dane można przywrócić zgodnie z polityką,
- każda istotna operacja jest zapisana w aktywności lub audycie.

## 20. Użytkownicy Ready, którzy nie zalogowali się jeszcze do RNext

### Problem

Nie każdy użytkownik istniejący w Ready ma już rekord `CoreUser`. W obecnym modelu Core użytkownik jest tworzony lub synchronizowany podczas pierwszego logowania do RNext.

Workspace nie może więc zakładać, że osoba zapraszana przez administratora posiada już `CoreUser` albo własny token Core.

Nie powinniśmy:

- tworzyć użytkownikowi tymczasowego hasła,
- tworzyć sztucznego konta niezależnego od Ready,
- wymagać wcześniejszego logowania tylko po to, aby wysłać zaproszenie,
- kopiować pełnego katalogu użytkowników Ready do bazy Workspace.

### Rekomendowane rozwiązanie — zaproszenie do tożsamości zewnętrznej

Zaproszenie powinno być kierowane do użytkownika Ready, a nie wyłącznie do istniejącego `CoreUser`.

Najważniejszym identyfikatorem zaproszenia jest:

```text
ReadyUserId
```

`CoreUserId` jest opcjonalne do czasu pierwszego logowania.

Model zaproszenia powinien więc obsługiwać:

- `ReadyUserId` — wymagany identyfikator użytkownika Ready,
- `CoreUserId` — opcjonalne powiązanie po synchronizacji z Core,
- login i nazwę wyświetlaną jako dane pomocnicze z katalogu Ready,
- workspace,
- zapraszającego,
- proponowaną rolę,
- status i termin ważności.

Podobnie członkostwo może początkowo posiadać `ReadyUserId`, a `CoreUserId` zostanie uzupełnione po pierwszym logowaniu. Dzięki temu członkostwo może istnieć zanim użytkownik pojawi się w RNext.

### Przepływ zaproszenia

```text
1. Administrator workspace wyszukuje użytkownika z Ready
       │
       ▼
2. veloryn-workspaces zapisuje zaproszenie z ReadyUserId
       │
       ├── opcjonalnie wysyła powiadomienie na adres z Ready
       │
       ▼
3. Użytkownik po raz pierwszy loguje się do RNext
       │
       ▼
4. veloryn-core synchronizuje ReadyUserId → CoreUserId
       │
       ▼
5. Zaproszenie zostaje automatycznie powiązane z CoreUser
       │
       ▼
6. Użytkownik widzi zaproszenie po zalogowaniu i może je zaakceptować
```

Akceptacja zaproszenia powinna być możliwa dopiero po poprawnym zalogowaniu. Samo otrzymanie zaproszenia nie daje dostępu do workspace.

### Skąd Workspace pobiera użytkowników Ready?

`veloryn-workspaces` nie powinien bezpośrednio łączyć się z bazą Ready. Są dwa dobre warianty:

#### Wariant rekomendowany — katalog użytkowników w Core

`veloryn-core` udostępnia wewnętrzny, bezpieczny mechanizm wyszukiwania użytkowników Ready:

- wyszukiwanie po loginie, imieniu lub adresie e-mail,
- zwracanie tylko minimalnych danych,
- brak haseł i hashy,
- autoryzacja service-to-service,
- filtrowanie użytkowników aktywnych lub dopuszczonych do pracy,
- opcjonalne utworzenie dormant `CoreUser` bez tworzenia sesji.

Workspace korzysta wtedy z Core jako źródła mapowania tożsamości:

```text
Ready → veloryn-core → veloryn-workspaces
```

#### Wariant przejściowy — identyfikator Ready w Workspace

Jeżeli katalog Core nie jest jeszcze gotowy, Workspace może przechowywać `ReadyUserId` i dane pomocnicze przekazane przez zaufany adapter. Ten wariant powinien być tymczasowy, ponieważ tworzy drugą integrację z Ready.

### Czy tworzyć `CoreUser` przed pierwszym logowaniem?

Można utworzyć rekord techniczny `CoreUser`, ale nie może on oznaczać aktywnej sesji ani lokalnego konta z hasłem. Powinien mieć stan np.:

- `Provisioned` — znaleziony w Ready, jeszcze nie zalogował się do RNext,
- `Active` — zalogował się i może korzystać z Core,
- `Disabled` — zablokowany lub usunięty w Ready.

W praktyce najprostszy model to:

- Workspace przechowuje `ReadyUserId` w zaproszeniu,
- Core tworzy `CoreUser` dopiero przy pierwszym logowaniu,
- po loginie Core lub Workspace wykonuje bezpieczne powiązanie zaproszenia z `CoreUserId`.

Jeżeli potrzebujemy wysyłać zaproszenia i śledzić użytkownika w Core przed logowaniem, można dodać stan `Provisioned`. Nie tworzymy jednak żadnego hasła ani refresh tokenu.

### Warunek bezpieczeństwa przy automatycznym powiązaniu

Powiązanie musi używać stabilnego `ReadyUserId`, a nie samego loginu lub adresu e-mail. Login i e-mail mogą się zmienić albo nie być unikalne w danym momencie.

Przy pierwszym logowaniu Core powinien:

1. zweryfikować konto i hasło w Ready,
2. odczytać stabilny `ReadyUserId`,
3. znaleźć lub utworzyć mapowanie Core,
4. przekazać `CoreUserId` do Workspace podczas synchronizacji albo umożliwić Workspace bezpieczne powiązanie,
5. dopiero wtedy dopuścić użytkownika do akceptacji zaproszenia.

### Rekomendacja końcowa

Najlepszy model dla Veloryn to:

- Ready jest źródłem katalogu i tożsamości użytkownika,
- Core jest źródłem sesji i stabilnego `CoreUserId`,
- Workspace jest źródłem zaproszeń, członkostw i ról,
- zaproszenie może istnieć przed pierwszym logowaniem,
- `ReadyUserId` jest kluczem przejściowym,
- `CoreUserId` jest uzupełniany przy pierwszym logowaniu,
- dostęp do workspace zaczyna się dopiero po akceptacji zaproszenia przez zalogowanego użytkownika.

## 21. Powiadomienie e-mail o zaproszeniu

Zaproszenie powinno wysyłać wiadomość e-mail do użytkownika Ready, jeżeli jego adres e-mail jest dostępny i zweryfikowany w katalogu Ready.

### Przepływ wysyłki

```text
Administrator
    │ wybiera użytkownika Ready i rolę
    ▼
veloryn-workspaces
    ├── pobiera minimalne dane użytkownika z Core
    ├── zapisuje zaproszenie jako Pending
    ├── generuje jednorazowy token zaproszenia
    └── zleca wysyłkę wiadomości
             ▼
           e-mail użytkownika
             │
             ▼
       link do RNext
             │
             ▼
       logowanie w Core
             │
             ▼
       podgląd i akceptacja zaproszenia
```

### Link w wiadomości

Link nie powinien przyznawać dostępu bez logowania. Powinien jedynie otworzyć RNext i wskazać oczekujące zaproszenie:

```text
https://ready.example.pl/invitations/{opaque-token}
```

Token powinien być:

- losowy i nieprzewidywalny,
- jednorazowy,
- ważny przez określony czas, np. 7 dni,
- przechowywany w bazie wyłącznie w postaci hasha,
- niezawierający `ReadyUserId`, adresu e-mail ani danych workspace wprost.

Po otwarciu linku użytkownik może zostać przekierowany do logowania. Po zalogowaniu backend porównuje hash tokenu, sprawdza zgodność `ReadyUserId` zalogowanego użytkownika i dopiero wtedy pokazuje szczegóły zaproszenia.

### Treść wiadomości

E-mail powinien zawierać:

- nazwę workspace,
- nazwę lub login osoby zapraszającej,
- proponowaną rolę,
- informację o dacie wygaśnięcia,
- przycisk „Zobacz zaproszenie”,
- informację, że wymagane jest logowanie kontem Ready,
- link do zgłoszenia problemu lub kontaktu z administratorem.

Nie należy umieszczać w wiadomości:

- haseł,
- tokenów JWT,
- danych innych członków workspace,
- bezpośrednich danych poufnych projektu.

### Stany wysyłki

Zaproszenie powinno mieć osobny stan biznesowy oraz stan dostarczenia wiadomości:

```text
InvitationStatus:
Pending → Accepted
Pending → Declined
Pending → Cancelled
Pending → Expired

DeliveryStatus:
NotSent → Queued → Sent → Delivered
                  └── Failed
```

Błąd wysyłki e-maila nie powinien pozostawiać niejasności. Rekomendowany model:

- zaproszenie zostaje zapisane,
- wysyłka trafia do kolejki/outboxa,
- system ponawia wysyłkę,
- administrator widzi status `Failed`,
- można użyć opcji „Wyślij ponownie”.

Nie warto wykonywać wysyłki SMTP w tej samej transakcji co zapis zaproszenia, ponieważ awaria dostawcy poczty mogłaby blokować operację biznesową.

### Ponowne wysłanie

Administrator powinien móc ponownie wysłać zaproszenie, ale z ograniczeniami:

- tylko dla statusu `Pending`,
- po minimalnym odstępie czasowym, np. 1 minuta,
- z limitem liczby wysyłek,
- z unieważnieniem poprzedniego tokenu,
- z nowym terminem ważności tylko według ustalonej polityki.

### Brak adresu e-mail

Jeżeli użytkownik Ready nie ma dostępnego adresu e-mail:

- zaproszenie nadal może zostać zapisane,
- administrator otrzymuje informację, że wiadomości nie wysłano,
- użytkownik może zobaczyć zaproszenie po zalogowaniu, jeżeli system potrafi je powiązać po `ReadyUserId`,
- opcjonalnie można wygenerować link do ręcznego przekazania, ale powinien mieć krótki termin ważności i wymagać późniejszego logowania.

### Właściciel wysyłki

Na początku wysyłkę może realizować `veloryn-workspaces`, korzystając z osobnej konfiguracji SMTP lub dostawcy e-mail. Docelowo warto wydzielić wspólną usługę powiadomień, jeżeli zaproszenia, reset haseł, komentarze i alerty będą używane przez wiele modułów.

W każdym przypadku `veloryn-workspaces` pozostaje właścicielem zdarzenia „zaproszenie utworzone”, a usługa pocztowa odpowiada tylko za dostarczenie wiadomości.

## 22. Zadania, komentarze, realtime i widoki pracy

### Załączniki do zadań i integracja z Quill Delta

Każde zadanie główne i każde podzadanie pozwala na dodawanie plików oraz osadzanie multimediów w treści opisu:

1. **Załączniki kontekstowe do zadania:**
   - Bezpośrednie dodawanie plików do zadania/podzadania przez uniwersalny Storage Engine (`resource_type = 'task'`, `resource_id = taskId`),
   - Listowanie załączników z podglądem miniaturek, rozmiarem, autorem i datą wgrania,
   - Pobieranie pojedyncze lub masowe jako `.zip`,
   - Usuwanie załącznika przez uprawnionego użytkownika.
2. **Osadzanie zdjęć i plików w edytorze Quill (Flutter Quill):**
   - Wklejanie lub dodawanie grafiki z dysku w opisie zadania (rich-text) uruchamia asynchroniczny upload do Storage Engine przez presigned URL,
   - W dokumencie Quill Delta JSON wstawiany jest węzeł typu `image` lub `file_attachment` wskazujący na stabilny identyfikator pliku (`fileId`) lub zoptymalizowany podgląd WebP,
   - Flutter Quill renderuje obraz z obsługą powiększenia (lightbox), a w przypadku utraty uprawnień do zadania obraz nie jest dostępny.

### Awatary użytkowników

Moduł Storage Engine obsługuje opcjonalne awatary użytkowników w całym ekosystemie:
- `resource_type = 'user_avatar'`, `resource_id = CoreUserId`,
- Automatyczne skalowanie i kadrowanie do rozmiarów `150x150` oraz `64x64` w formacie **WebP**,
- Zwracanie adresu URL awatara w profilu użytkownika (`CoreUser` / `ReadyUser`),
- Cache'owanie awatarów po stronie klienta Flutter z unieważnianiem cache przy zmianie zdjęcia profilowego.

### Komentarze rich-text

Komentarz powinien być osobnym obiektem powiązanym z kontekstem:

- zadaniem,
- podzadaniem,
- projektem,
- karteczką,
- plikiem,
- dokumentem.

Minimalne funkcje komentarzy:

- formatowanie tekstu,
- nagłówki,
- listy numerowane i punktowane,
- pogrubienie, kursywa i przekreślenie,
- linki,
- cytaty,
- bloki kodu,
- język składni w bloku kodu,
- załączniki,
- wzmianki użytkowników,
- odpowiedzi do komentarza,
- edycja z historią zmian,
- usuwanie przez autora lub uprawnionego administratora,
- reakcje/emotikony jako późniejsze rozszerzenie.

Treść komentarza najlepiej przechowywać jako bezpieczny dokument strukturalny, np. JSON rich-text/Markdown z kontrolowanym renderowaniem. Nie należy zapisywać nieoczyszczonego HTML bez sanitizacji.

### Wzmianki użytkowników

W komentarzach, zadaniach i opisach powinno być możliwe oznaczanie:

- użytkowników workspace,
- członków projektu,
- osób przypisanych do zadania,
- zespołów — w późniejszym etapie.

Wzmianka powinna być zapisana jako stabilny identyfikator użytkownika, a nie tylko tekst `@login`. Dzięki temu zmiana nazwy użytkownika nie zniszczy powiązania.

Wzmianka tworzy zdarzenie powiadomienia, ale system powinien zabezpieczać przed spamem, np. przez ograniczenie liczby powiadomień z jednego komentarza.

### Długie teksty i pliki tekstowe

Długie wklejone treści, logi lub fragmenty dokumentacji mogą być trudne do czytania w komentarzu. Rekomendowany przepływ:

1. użytkownik wkleja długi tekst,
2. edytor wykrywa przekroczenie ustalonego progu,
3. pokazuje propozycję „Dodaj jako plik tekstowy”,
4. użytkownik potwierdza operację,
5. system tworzy plik `.txt` albo `.md` i dodaje go do komentarza/zadania,
6. komentarz zachowuje krótki podgląd i odnośnik do pliku.

Nie należy automatycznie usuwać ani zamieniać tekstu bez potwierdzenia użytkownika. Próg powinien być konfigurowalny, np. liczba znaków lub wysokość treści.

### Realtime i WebSocket

Komentarze, aktywność i powiadomienia powinny działać w czasie rzeczywistym. WebSocket powinien być wspólnym mechanizmem infrastrukturalnym, a nie funkcją napisaną wyłącznie dla komentarzy.

Proponowane kanały:

```text
user:{coreUserId}
workspace:{workspaceId}
project:{projectId}
task:{taskId}
```

Przykładowe zdarzenia:

- `comment.created`,
- `comment.updated`,
- `comment.deleted`,
- `mention.created`,
- `task.updated`,
- `task.assigned`,
- `task.status_changed`,
- `file.added`,
- `notification.created`,
- `notification.read`.

WebSocket powinien:

- wymagać JWT podczas nawiązywania połączenia,
- sprawdzać członkostwo przed subskrypcją kanału workspace/projektu/zadania,
- nie wysyłać danych z kanału, do którego użytkownik utracił dostęp,
- obsługiwać ponowne połączenie,
- obsługiwać heartbeat/ping-pong,
- dostarczać identyfikator zdarzenia i czas utworzenia,
- umożliwiać odtworzenie brakujących zdarzeń po reconnect.

### Globalny i uniwersalny system powiadomień

Powiadomienia powinny być osobnym komponentem wspólnym dla całego ekosystemu Veloryn, a nie funkcją tylko `veloryn-workspaces`.

Pierwsza implementacja działa fizycznie w `veloryn-workspaces`, jako pierwszy
producent i odbiorca. Model, kontrakt zdarzeń i outbox muszą jednak umożliwić
późniejsze wydzielenie wspólnego Notification Service bez zmiany semantyki API.

Powinny móc korzystać z niego:

- `veloryn-workspaces`,
- BHP,
- Inwentaryzacja,
- DataBus,
- przyszłe moduły Veloryn.

Źródło powiadomienia powinno przekazywać standardowy kontrakt:

```text
Notification
├── Id
├── RecipientCoreUserId
├── SourceModule
├── EventType
├── EntityType
├── EntityId
├── Title
├── Body
├── DeepLink
├── CreatedAtUtc
├── ReadAtUtc
├── ContractVersion
└── Metadata
```

Przykłady:

```text
workspace.invitation.created
task.assigned
task.mentioned
task.due_date_approaching
bhp.training.expiring
inventory.session.completed
```

System powinien obsługiwać kanały dostarczenia:

- realtime przez WebSocket,
- centrum powiadomień w aplikacji,
- e-mail,
- później push/mobile i inne komunikatory.

Pierwszy wdrożony kontrakt Workspaces ma `ContractVersion = 1`, ograniczone długości
tekstu i idempotentny `EventId`. Zdarzenie jest najpierw zapisywane wraz z rekordem
outbox w tej samej transakcji PostgreSQL, a dopiero worker publikuje je do SignalR.
Po reconnect klient pobiera brakujące elementy z `GET /api/v1/notifications` przez
kursor i deduplikuje je po `EventId`; hub nie jest źródłem prawdy.

Przy tworzeniu zaproszenia Workspaces pobiera z chronionego, read-only katalogu
Core opcjonalne `CoreUserId` odpowiadające `ReadyUserId`. Jeżeli adresat zalogował
się już kiedyś do Veloryn, dostaje jednocześnie e-mail i powiadomienie in-app;
gdy nie ma jeszcze konta Core, wysyłany jest wyłącznie e-mail, a zaproszenie nadal
pozostaje dostępne po pierwszym logowaniu przez standardowy endpoint zaproszeń.

Ręczne komunikaty operacyjne są dostępne wyłącznie dla SuperAdmina pod
`POST /api/v1/admin/notifications`. Przechodzą przez dokładnie ten sam inbox i
outbox co zdarzenia domenowe. `DeepLink` jest opcjonalną, walidowaną wewnętrzną
ścieżką Fluttera (nie callbackiem ani zewnętrznym URL-em); klient po kliknięciu
przekazuje go do routera i nadal pobiera docelowy zasób przez autoryzowane API.

Notifications pozostają na stałe komponentem Workspaces. Inne moduły publikują
do jego stabilnego kontraktu, a nie do osobnej usługi. Każde powiadomienie ma
`Category`, opcjonalny `GroupKey` i ograniczone `Metadata`, dzięki czemu Flutter
może grupować płaską, paginowaną listę bez zmiany semantyki cursor pagination.

Rekomendowana architektura:

```text
moduł biznesowy
    → zdarzenie/outbox
    → Notification Service
    ├── zapis powiadomienia
    ├── WebSocket
    ├── e-mail
    └── push w przyszłości
```

Moduły nie powinny wywoływać się nawzajem bezpośrednio tylko po to, aby utworzyć powiadomienie. Każdy moduł publikuje zdarzenie, a wspólny system decyduje o dostarczeniu.

### Dodatkowe zasady fundamentu powiadomień

- powiadomienie ma retencję i archiwizację; przeczytane wpisy nie są kasowane
  automatycznie bez jawnej polityki;
- preferencje użytkownika są per kanał i typ zdarzenia (`in_app`, `email`,
  później `push`), a ich brak oznacza bezpieczne domyślne zachowanie;
- kontrakt zdarzenia jest wersjonowany i zawiera `event_id`, aby odbiorca mógł
  bezpiecznie eliminować duplikaty;
- payload jest ograniczony rozmiarem i nie zawiera pełnej prywatnej treści;
- powiadomienie może wskazywać zasób, ale nigdy nie przyznaje do niego dostępu;
- akcje biznesowe, np. akceptacja zaproszenia, wykonuje endpoint właściciela
  domeny po ponownej autoryzacji, a nie sam moduł powiadomień.

### Historia zadania

Każde zadanie powinno posiadać niezmienną historię zdarzeń. Historia powinna rejestrować co najmniej:

- utworzenie zadania,
- zmianę tytułu i opisu,
- zmianę statusu,
- zmianę osoby odpowiedzialnej,
- zmianę terminu,
- zmianę priorytetu,
- dodanie/usunięcie etykiety,
- utworzenie/zmianę/usunięcie podzadania,
- dodanie/usunięcie pliku,
- utworzenie/edycję/usunięcie komentarza,
- zmianę dostępu,
- archiwizację i przywrócenie.

Historia powinna przechowywać:

- typ zdarzenia,
- użytkownika wykonującego akcję,
- czas UTC,
- identyfikator obiektu,
- wartości przed i po zmianie albo bezpieczny opis zmiany,
- źródło modułu,
- correlation/request id.

Historia nie powinna być nadpisywana razem z bieżącym stanem zadania. Bieżący stan służy do szybkiego odczytu, a historia do audytu i osi czasu.

### Widoki zadań

Zadania powinny mieć kilka sposobów prezentacji:

#### Lista

Podstawowy widok do filtrowania i masowej pracy:

- status,
- assignee,
- termin,
- priorytet,
- etykiety,
- podzadania,
- sortowanie i grupowanie.

#### Kanban zadań

Późniejszy widok operacyjny zadań:

- kolumny oparte na statusach,
- przeciąganie zadania,
- filtry,
- swimlanes według osoby, priorytetu albo sprintu,
- limit zadań w toku jako funkcja późniejsza.

To nie zastępuje osobnej tablicy z karteczkami.

#### Timeline

Widok planowania:

- daty rozpoczęcia i zakończenia,
- kamienie milowe,
- zależności,
- grupowanie po projekcie lub osobie,
- zaznaczanie opóźnionych zadań.

#### Kalendarz

Widok terminów i obciążenia w czasie. Warto wprowadzić przed pełnym Ganttem, bo jest prostszy i szybciej użyteczny.

### Dashboard z widgetami

Dashboard może działać na poziomie użytkownika, projektu i workspace.

Przydatne widgety:

- ostatnio utworzone zadania,
- ostatnio zmienione zadania,
- moje zadania,
- zadania przeterminowane,
- zadania na dziś i ten tydzień,
- zadania według statusu,
- zadania według osoby,
- aktywność zespołu,
- ostatnie komentarze,
- ostatnie pliki,
- oczekujące zaproszenia,
- wykorzystanie przestrzeni MinIO,
- projekty zagrożone opóźnieniem,
- otwarte karteczki na tablicach.

Widgety powinny być konfigurowalne i zapisywane per użytkownik. Dashboard nie powinien zawierać danych, do których użytkownik nie ma dostępu.

## 23. Rozszerzenia produkcyjnego zakresu funkcjonalnego

Po dodaniu komentarzy, plików, historii i realtime minimalny produkt powinien obejmować:

1. zadania i jednopoziomowe podzadania,
2. załączniki do zadań i komentarzy,
3. komentarze rich-text z kodem i wzmiankami,
4. historię każdego zadania,
5. globalne powiadomienia,
6. WebSocket dla komentarzy, zmian i powiadomień,
7. widok listy,
8. widok Kanban zadań,
9. osobne tablice karteczek,
10. podstawowy timeline,
11. dashboard użytkownika i projektu.

System powiadomień i realtime należy zaprojektować jako wspólną infrastrukturę Veloryn od początku, nawet jeżeli pierwszym klientem będzie `veloryn-workspaces`.

## 24. Analiza brakujących funkcji względem Jiry, Asany i ClickUpa

Poniższe funkcje są obecne w konkurencyjnych systemach, a w naszym planie nie były jeszcze opisane wystarczająco dokładnie albo nie zostały jeszcze przypisane do etapu wdrożenia.

### 24.1. Cele, OKR i powiązanie strategii z zadaniami

Asana i ClickUp pozwalają łączyć cele organizacji z projektami i zadaniami. W naszym systemie brakuje warstwy nadrzędnej nad workspace:

```text
Cel
└── Kluczowy rezultat
    └── Projekt
        └── Zadania
```

Rekomendacja: dodać w późniejszym etapie:

- cele workspace,
- cele zespołu,
- kluczowe rezultaty,
- właściciela celu,
- termin i status celu,
- ręczny lub automatyczny postęp,
- powiązanie celu z projektami i zadaniami.

Priorytet: P2.

### 24.2. Portfolio projektów

Brakuje widoku zarządzania wieloma projektami jednocześnie. Portfolio powinno odpowiadać na pytania:

- które projekty są aktywne,
- które są opóźnione,
- kto jest właścicielem projektu,
- ile zadań jest otwartych,
- które projekty mają ryzyko,
- jakie projekty realizują konkretny cel.

Portfolio nie powinno być kolejnym poziomem obowiązkowej hierarchii. Lepiej potraktować je jako grupę lub widok nad projektami.

Priorytet: P1/P2.

### 24.3. Workload i obciążenie zespołu

Asana i ClickUp mają widoki pokazujące pojemność zespołu. U nas brakuje:

- liczby aktywnych zadań na użytkownika,
- estymacji pracy,
- planowanej dostępności,
- przeciążenia użytkownika,
- przesuwania zadań na inną osobę lub termin,
- widoku obciążenia w czasie.

Do workload potrzebujemy wcześniej:

- estymacji zadania,
- opcjonalnej liczby godzin,
- terminów,
- zespołów,
- kalendarza nieobecności.

Priorytet: P1, jeżeli system będzie używany do zarządzania zespołami; P2 dla pierwszej wersji.

### 24.4. Formularze przyjmowania zgłoszeń

Asana, Jira i ClickUp pozwalają tworzyć zadania przez formularze. To przyda się do:

- zgłoszeń serwisowych,
- próśb o zakup,
- zgłoszeń BHP,
- zgłoszeń inwentaryzacyjnych,
- próśb klientów,
- rejestracji pomysłów.

Formularz powinien mieć:

- własne pola,
- walidację,
- możliwość dodania pliku,
- wybór projektu i statusu,
- przypisanie domyślnej osoby,
- publiczny lub tylko wewnętrzny dostęp,
- automatyczne utworzenie zadania.

Priorytet: P1.

### 24.5. Workflow, approvals i bramki procesu

Mamy statusy, ale nie mamy jeszcze formalnych przejść i akceptacji. Warto dodać:

- dozwolone przejścia między statusami,
- wymagane pola przed zamknięciem zadania,
- akceptację przez jedną lub kilka osób,
- status `Waiting for approval`,
- decyzje `Approved`, `Rejected`, `Changes requested`,
- komentarz wymagany przy odrzuceniu,
- historię decyzji.

Przykład:

```text
Draft → In review → Approved → Done
                    └→ Changes requested
```

Priorytet: P1 dla procesów formalnych, P2 dla prostych projektów.

### 24.6. Pola niestandardowe

ClickUp i Asana pozwalają dodawać własne pola do projektów i zadań. W naszym planie są wspomniane, ale wymagają osobnego modelu:

- tekst,
- liczba,
- wybór jednej wartości,
- wybór wielu wartości,
- data,
- osoba,
- checkbox,
- URL,
- kwota,
- procent,
- formuła jako późniejsze rozszerzenie.

Pola muszą mieć właściciela kontekstu, np. workspace albo projekt, oraz uprawnienia do definiowania i edycji wartości.

Priorytet: P1/P2.

### 24.7. Szablony i standardy pracy

System powinien pozwalać zapisać jako szablon:

- projekt,
- listę zadań,
- podzadania,
- statusy,
- kolumny tablicy,
- formularz,
- pola niestandardowe,
- reguły automatyzacji.

To ważne dla powtarzalnych procesów, np. wdrożenia pracownika, kontroli BHP czy okresowej inwentaryzacji.

Priorytet: P1.

### 24.8. Automatyzacje

Konkurencyjne systemy mają reguły typu:

```text
Gdy status zmieni się na „Done”
→ ustaw datę zakończenia
→ powiadom właściciela projektu
→ utwórz następne zadanie
```

Pierwsza wersja automatyzacji powinna obsługiwać tylko ograniczony zestaw:

- zmiana statusu,
- utworzenie zadania,
- zbliżający się termin,
- przypisanie użytkownika,
- ukończenie zadania,
- utworzenie komentarza,
- wejście formularza.

Automatyzacje muszą mieć właściciela, historię uruchomień, limit i możliwość wyłączenia. Nie należy zaczynać od całkowicie dowolnego silnika skryptów.

Priorytet: P1/P2.

### 24.9. Rejestrowanie czasu pracy

ClickUp oferuje timer i ręczne wpisy czasu. U nas brakuje:

- start/stop timera,
- ręcznego wpisu czasu,
- oznaczenia czasu jako billable/non-billable,
- raportu czasu per zadanie, projekt i użytkownik,
- korekty wpisu z historią,
- eksportu do rozliczeń.

Priorytet: P2, chyba że Veloryn ma od początku obsługiwać rozliczenia godzinowe.

### 24.10. Dokumenty i wiki

Pliki i komentarze nie zastępują dokumentów. Brakuje osobnego obiektu `Document` z:

- stronami i podstronami,
- formatowaniem rich-text,
- historią wersji,
- współedycją,
- linkami do projektów i zadań,
- uprawnieniami,
- możliwością przypięcia jako dokument projektu.

Tablica karteczek nie powinna być używana jako wiki. Dokumenty są miejscem dla instrukcji, procedur i wiedzy trwałej.

Priorytet: P1 dla pełnego produktu.

### 24.11. Pełny whiteboard i mind map

Nasze `BoardCard` obejmują karteczki w kolumnach, ale nie dają swobodnego płótna. ClickUp ma whiteboardy i mind mapy. W przyszłości można dodać:

- swobodne rozmieszczanie elementów,
- połączenia między elementami,
- obrazy i linki,
- osadzanie zadań,
- zamianę elementu w zadanie,
- współpracę realtime.

Nie należy mieszać whiteboardu z tablicą Kanban ani z listą zadań.

Priorytet: P2.

### 24.12. Import i eksport danych

Brakuje mechanizmów migracji oraz wyjścia z systemu:

- import CSV,
- import z Jiry/Asany/ClickUpa w późniejszym etapie,
- eksport zadań do CSV/XLSX,
- eksport plików i metadanych,
- eksport historii,
- pełny eksport workspace,
- bezpieczne usunięcie workspace.

Priorytet: eksport podstawowy P1, import P2.

### 24.13. Integracje i API dla innych modułów

Globalne powiadomienia to dopiero początek. Potrzebujemy także:

- publicznego API z wersjonowaniem,
- webhooków,
- zdarzeń domenowych,
- idempotencji,
- kluczy integracyjnych dla usług,
- ograniczania liczby żądań,
- dokumentacji OpenAPI,
- możliwości osadzenia zadań i powiadomień w BHP oraz Inwentaryzacji.

Każdy moduł powinien móc utworzyć powiadomienie, link do zadania lub zdarzenie aktywności bez znajomości wewnętrznej bazy Workspace.

Priorytet: fundament techniczny P0/P1, kolejne integracje P2.

### 24.14. Funkcje zewnętrznego gościa

Współpraca z osobą spoza Ready może wymagać:

- roli `Guest`,
- dostępu tylko do jednego projektu,
- ograniczenia plików,
- ograniczenia komentarzy,
- zaproszenia z wygasającym linkiem,
- osobnego audytu.

Nie dodajemy tego do obecnego zakresu, ponieważ system jest zamknięty dla użytkowników Ready.

Priorytet: P2.

### 24.15. Funkcje, których nie kopiujemy bezpośrednio

Nie warto od razu kopiować:

- głębokiej hierarchii ClickUpa,
- zagnieżdżonych podzadań,
- wielkiej liczby typów issue z Jiry,
- całkowicie dowolnego silnika automatyzacji,
- AI jako obowiązkowej części produktu,
- wielu poziomów portfolio przed stabilizacją projektów,
- multi-homing zadań w wielu projektach, jeśli komplikuje uprawnienia.

Najpierw stabilizujemy prosty model, a dopiero potem zwiększamy elastyczność.

## 25. Uzupełniona mapa funkcji produktu

```text
Fundament
├── Workspace, użytkownicy, role, zaproszenia
├── Projekty i członkostwa
├── Zadania i jednopoziomowe podzadania
├── BoardCard i tablice współpracy
├── Pliki prywatne, współdzielone i kontekstowe
├── Komentarze rich-text, wzmianki i realtime
├── Historia i aktywność
└── Globalne powiadomienia

Zarządzanie pracą
├── Lista, Kanban, kalendarz, timeline
├── Dashboardy
├── Filtry i zapisane widoki
├── Milestones i zależności
├── Workflow i approvals
├── Formularze
├── Szablony
└── Automatyzacje

Zarządzanie organizacją
├── Portfolio
├── Cele i OKR
├── Workload
├── Czas pracy
├── Raporty
└── Statusy projektów

Platforma
├── API i webhooki
├── Notification Service
├── WebSocket
├── MinIO
├── Import/eksport
├── Dokumenty/wiki
└── Integracje modułów Veloryn
```

## 26. Konfiguracja pól zadań przez administratora projektu

Projekt powinien mieć własną konfigurację pól zadań. Dzięki temu jeden projekt może być prosty, a inny może wymagać dodatkowych informacji biznesowych.

Przykład:

```text
Projekt: Rozwój aplikacji
├── Typ zadania
├── Status
├── Priorytet
├── Wielkość
├── Skomplikowanie
├── Komponent
└── Kryteria akceptacji

Projekt: Obsługa dokumentów
├── Typ zadania
├── Status
├── Priorytet
├── Klient
├── Numer dokumentu
├── Termin formalny
└── Osoba zatwierdzająca
```

### Dwa rodzaje pól

#### Pola systemowe

Są dostępne w każdym projekcie i mają stałe znaczenie:

- tytuł,
- opis,
- status,
- typ zadania,
- priorytet,
- osoba odpowiedzialna,
- współpracownicy,
- obserwujący,
- termin,
- projekt,
- podzadanie,
- komentarze,
- pliki,
- historia.

Pól systemowych nie można całkowicie usunąć, ale administrator projektu może zdecydować, czy wybrane z nich są widoczne na liście lub karcie zadania.

#### Pola konfigurowalne

Administrator projektu albo właściciel workspace może dodawać pola takie jak:

- wielkość zadania,
- stopień skomplikowania,
- estymowany wysiłek,
- ważność biznesowa,
- ryzyko,
- komponent,
- źródło zadania,
- klient,
- numer dokumentu,
- środowisko,
- kryteria akceptacji,
- dowolne pola specyficzne dla projektu.

### Ustawienia pola

Każde pole powinno mieć:

- nazwę,
- typ,
- opis pomocniczy,
- ikonę lub kolor,
- kolejność,
- widoczność,
- wymaganie lub opcjonalność,
- wartość domyślną,
- listę dostępnych wartości,
- możliwość filtrowania,
- możliwość sortowania,
- możliwość grupowania,
- uprawnienia do edycji.

Przykład konfiguracji:

```text
Nazwa: Wielkość zadania
Typ: Wybór jednej wartości
Wymagane: Tak
Widoczne na liście: Tak
Filtrowanie: Tak
Sortowanie: Tak
Wartości:
  XS — bardzo małe
  S  — małe
  M  — średnie
  L  — duże
  XL — bardzo duże
```

### Typy pól konfigurowalnych

W podstawowym modelu produkcyjnym wystarczy:

- tekst,
- długi tekst,
- liczba,
- wybór jednej wartości,
- wybór wielu wartości,
- checkbox,
- data,
- użytkownik,
- URL,
- procent.

Później można dodać kwoty, formuły, zależności między polami oraz automatyczne wartości.

### Widoczność pól

Administrator powinien konfigurować widoczność niezależnie w kilku miejscach:

- lista zadań,
- karta zadania na Kanbanie,
- szczegóły zadania,
- formularz tworzenia zadania,
- formularz edycji zadania,
- timeline,
- dashboard.

To ważne, ponieważ nie każde pole musi być widoczne wszędzie. Na karcie Kanbanie powinny znaleźć się tylko najważniejsze informacje, a pełny zestaw pól w szczegółach zadania.

### Wymagalność pól

Administrator może ustawić, że pole jest wymagane:

- przy tworzeniu zadania,
- przy przejściu do konkretnego statusu,
- przed zamknięciem zadania,
- tylko dla określonego typu zadania.

Przykład:

```text
Przejście: W trakcie → Do sprawdzenia
Wymagane:
  - osoba odpowiedzialna
  - opis rozwiązania
  - kryteria akceptacji
  - załącznik testów
```

### Konfiguracja statusów projektu

Administrator projektu powinien również ustalać workflow:

- nazwy statusów,
- kolory,
- kolejność,
- grupa statusu: nie rozpoczęte, aktywne, zakończone, zablokowane,
- dozwolone przejścia,
- wymagane pola przed przejściem,
- czy status może być używany dla podzadań.

Przykład:

```text
Backlog → Do zrobienia → W trakcie → Do akceptacji → Gotowe
                              └────── Zablokowane
```

### Kto może konfigurować pola?

Proponowane uprawnienia:

- `Workspace Owner` — pełna konfiguracja,
- `Workspace Admin` — pełna konfiguracja w workspace,
- `Project Admin` — konfiguracja konkretnego projektu,
- `Member` — korzysta z pól i uzupełnia wartości,
- `Guest` — nie występuje w obecnym zamkniętym modelu systemu.

Konfiguracja projektu powinna mieć historię zmian. Zmiana nazwy pola, usunięcie wartości albo ustawienie pola jako wymaganego może wpływać na istniejące zadania.

### Zasada dotycząca usuwania pól

Nie należy fizycznie usuwać pola razem z jego wartościami. Administrator powinien móc:

- wyłączyć pole w projekcie,
- ukryć je w interfejsie,
- zarchiwizować pole,
- przywrócić je później.

Wartości historyczne muszą pozostać dostępne w historii zadania i audycie.

### Proponowany ekran ustawień projektu

```text
Ustawienia projektu
├── Informacje
├── Członkowie i uprawnienia
├── Statusy i workflow
├── Pola zadań
│   ├── Widoczne pola
│   ├── Pola wymagane
│   ├── Pola konfigurowalne
│   └── Kolejność pól
├── Widoki
├── Powiadomienia
└── Archiwizacja
```

Najlepszy model to: system dostarcza stabilne pola podstawowe, a administrator projektu decyduje, które z nich i jakie pola dodatkowe są używane w konkretnym projekcie.

## 27. Presety ustawień projektów

Projekt powinien można utworzyć na podstawie gotowego presetu. Preset jest punktem startowym zawierającym konfigurację projektu, ale po utworzeniu administrator może go dowolnie zmienić.

### Sposób działania

```text
Utwórz projekt → Wybierz preset → System tworzy konfigurację → Administrator ją dostosowuje
```

Użytkownik powinien móc użyć gotowego presetu, utworzyć pusty projekt albo skopiować konfigurację z istniejącego projektu.

### Co zawiera preset

Preset może definiować:

- statusy, kolejność i kolory,
- dozwolone przejścia między statusami,
- typy zadań i priorytety,
- domyślne i wymagane pola zadań,
- wartości pól wyboru,
- etykiety,
- domyślne widoki i widok startowy,
- konfigurację Kanbanu zadań,
- konfigurację tablicy karteczek,
- podstawowe widgety dashboardu,
- ustawienia powiadomień,
- domyślne checklisty,
- szablony zadań.

Automatyzacje i formularze można dodać do presetów dopiero po wprowadzeniu tych funkcji do systemu.

### Gotowe presety

#### Projekt ogólny

```text
Nowe → W toku → Do sprawdzenia → Gotowe
```

Pola: priorytet, osoba odpowiedzialna, termin, wielkość, skomplikowanie i etykiety. Widoki: lista, Kanban i kalendarz.

#### Rozwój systemu

```text
Backlog → Do zrobienia → W trakcie → Code Review → Testy → Gotowe
```

Typy zadań: funkcja, błąd, refaktoryzacja, dokumentacja i test. Pola: typ, komponent, priorytet, wielkość, skomplikowanie, środowisko, kryteria akceptacji i osoba odpowiedzialna. Widoki: lista, Kanban, timeline i kalendarz.

#### Obsługa zgłoszeń

```text
Nowe → Analiza → Przyjęte → W realizacji → Oczekuje → Zamknięte
```

Pola: źródło zgłoszenia, kategoria, priorytet, ważność biznesowa, osoba odpowiedzialna, termin i opis rozwiązania. Widoki: lista, Kanban i dashboard zgłoszeń.

#### Projekt dokumentacyjny

```text
Do opracowania → W opracowaniu → Do akceptacji → Opublikowane
```

Pola: typ dokumentu, właściciel, osoba zatwierdzająca, termin przeglądu, ważność i status publikacji. Widoki: lista, kalendarz, pliki i aktywność.

#### Planowanie

```text
Pomysły → Do analizy → Zaakceptowane → Zaplanowane → Zrealizowane
```

Pola: wartość pomysłu, skomplikowanie, ryzyko, ważność biznesowa, osoba odpowiedzialna i przewidywany termin. Tablica karteczek jest włączona domyślnie.

#### Projekt pusty

Minimalna konfiguracja:

- statusy `Nowe`, `W toku`, `Gotowe`,
- pola systemowe,
- lista zadań,
- podstawowy Kanban,
- podstawowa tablica karteczek,
- aktywność projektu.

### Własne presety

Administrator powinien móc zapisać konfigurację projektu jako własny preset:

```text
Projekt → Ustawienia → Zapisz jako preset
```

Preset może być dostępny tylko dla autora, dla administratorów albo dla wszystkich członków workspace. Powinien mieć nazwę, opis, ikonę i autora.

### Duplikowanie projektu

Przy duplikowaniu projektu administrator wybiera, czy skopiować:

- statusy,
- pola zadań,
- widoki,
- tablice,
- dashboard,
- członków projektu,
- zadania jako szablony,
- checklisty.

Domyślnie nie kopiujemy komentarzy, historii aktywności, prywatnych plików ani niepotrzebnych danych osobowych.

### Preset jako kopia konfiguracji

Po utworzeniu projektu preset nie powinien być żywo połączony z projektem. Zmiana presetu nie może automatycznie modyfikować istniejących projektów.

```text
Preset → konfiguracja projektu → niezależny projekt
```

Ewentualna późniejsza aktualizacja projektu z presetu musi pokazywać listę zmian i wymagać potwierdzenia.

### Uprawnienia

- `Workspace Owner` — pełne zarządzanie presetami,
- `Workspace Admin` — zarządzanie presetami workspace,
- `Project Admin` — używanie presetów i zapis własnego presetu, jeśli ma takie prawo,
- `Member` — używanie udostępnionych presetów przy tworzeniu projektu.

### Zakres pierwszej wersji

Wprowadzamy sześć presetów: Projekt ogólny, Rozwój systemu, Obsługa zgłoszeń, Projekt dokumentacyjny, Planowanie i Projekt pusty. Każdy preset można zmienić po utworzeniu projektu, a administrator workspace może zapisać własny preset.

## 28. Whiteboard jako następca tablic karteczek

Zamiast utrzymywać osobno `BoardCard` i `Whiteboard`, przyjmujemy jeden moduł whiteboardu. Karteczka pozostaje funkcją, ale staje się jednym z elementów swobodnego płótna.

### Nowy model

```text
Projekt
└── Whiteboard
    ├── StickyNote
    ├── Text
    ├── Shape
    ├── Arrow
    ├── TaskReference
    ├── FileReference
    └── Image
```

Dotychczasowa karteczka `BoardCard` zostaje zastąpiona przez element `StickyNote`.

### Element StickyNote

Karteczka zachowuje tytuł, treść, kolor, autora, komentarze, pliki, tagi i możliwość konwersji do zadania. Whiteboard dodaje pozycję `x/y`, szerokość, wysokość, swobodne przesuwanie, zmianę rozmiaru, łączenie z innymi elementami i opcjonalne grupowanie.

### Presety whiteboardów

Przy tworzeniu whiteboardu użytkownik może wybrać:

- pusty whiteboard,
- planowanie,
- retrospektywę,
- mapę procesu,
- backlog pomysłów.

Przykładowy preset retrospektywy:

```text
Co poszło dobrze | Co nie zadziałało | Co poprawić
```

Przykładowy preset planowania:

```text
Pomysły | Analiza | Decyzja | Zadania
```

Preset tworzy początkowy układ elementów, ale administrator może go później zmienić.

### Zakres whiteboardu

Pierwsza wersja powinna obsługiwać:

- przesuwanie i powiększanie płótna,
- tworzenie i edycję karteczek,
- zmianę koloru,
- dodawanie tekstu,
- dodawanie strzałek,
- grupowanie elementów,
- dodanie istniejącego zadania jako `TaskReference`,
- konwersję karteczki do zadania,
- komentarze,
- pliki,
- zapis układu,
- kontrolę dostępu na poziomie workspace/projektu.

Nie należy zaczynać od rysowania odręcznego, wspólnych kursorów, pełnej współpracy realtime, rozbudowanych diagramów ani eksportu do PDF/obrazu.

### Realtime whiteboardu — późniejszy etap

Po ustabilizowaniu podstaw można dodać WebSocket i zdarzenia:

- `whiteboard.element_created`,
- `whiteboard.element_updated`,
- `whiteboard.element_moved`,
- `whiteboard.element_deleted`,
- `whiteboard.selection_changed`.

Realtime powinien działać na poziomie projektu lub konkretnego whiteboardu i wymagać JWT oraz sprawdzenia dostępu użytkownika.

### Zasada projektowa

Whiteboard zastępuje osobną tablicę karteczek, ale nie zastępuje listy zadań ani Kanbanu zadań:

```text
Lista zadań   — uporządkowana realizacja pracy
Kanban zadań  — wizualny widok statusów zadań
Whiteboard    — swobodne planowanie i współpraca wizualna
```

Karteczka może zostać zamieniona w zadanie, ale zadanie nie musi być przedstawiane jako karteczka.

## 29. Projekty, procesy i statusy

Statusy, pola i workflow powinny być konfigurowane per projekt, ponieważ różne projekty mogą obsługiwać zupełnie różne procesy.

### Przykład produktu i zgłoszeń

```text
Workspace
├── Projekt: Szkło
│   ├── rozwój produktu,
│   ├── zadania techniczne,
│   ├── whiteboardy,
│   └── dokumentacja
│
└── Projekt: Zgłoszenia — Szkło
    ├── zgłoszenia,
    ├── statusy obsługi,
    └── dashboard zgłoszeń
```

Projekt `Szkło` może mieć workflow:

```text
Pomysł → Analiza → Projektowanie → Implementacja → Testy → Gotowe
```

Projekt `Zgłoszenia — Szkło` może mieć workflow:

```text
Nowe → Przyjęte → Analiza → W realizacji → Oczekuje → Rozwiązane → Zamknięte
```

Nie należy mieszać tych procesów w jednym projekcie, ponieważ powodowałoby to zbyt wiele statusów, nieczytelny Kanban i różne wymagania pól.

### Powiązania między projektami

Zadanie z projektu zgłoszeniowego może być powiązane z zadaniem z projektu produktowego:

```text
Zgłoszenie: Błąd w module Szkło
        ↓ powiązane z
Zadanie: Poprawić obsługę szkła
```

Relacje powinny obejmować:

- `related_to` — powiązane,
- `blocks` — blokuje,
- `blocked_by` — zablokowane przez,
- `created_from` — utworzone na podstawie zgłoszenia,
- `duplicate` — duplikat.

W docelowym modelu wystarczy `Workspace → Projekty`. Nadrzędne produkty lub obszary można obsłużyć przez tag, pole `Produkt` albo grupę projektów, bez wprowadzania kolejnego obowiązkowego poziomu hierarchii.

## 30. Wyświetlanie rosnącej liczby zadań

Lista zadań nie powinna pobierać wszystkich rekordów jednocześnie. Zadania będą rosły, dlatego backend i Flutter muszą używać paginacji, filtrów i widoków ograniczających zakres danych.

### Paginacja

Podstawowy widok listy powinien pobierać zadania stronami:

```text
GET /projects/{projectId}/tasks?page=1&pageSize=50
```

Rekomendowane wartości:

- domyślnie 25–50 zadań,
- maksymalnie 100 zadań na żądanie,
- pobieranie kolejnej strony przy scrollowaniu albo przez przycisk „Załaduj więcej”.

Dla bardzo dużych projektów lepsza będzie paginacja kursorowa:

```text
GET /projects/{projectId}/tasks?limit=50&cursor=...
```

Cursor pagination jest stabilniejsza, gdy w czasie przeglądania ktoś dodaje lub zmienia zadania.

### Filtrowanie i sortowanie

Użytkownik powinien móc filtrować po:

- statusie,
- osobie odpowiedzialnej,
- priorytecie,
- typie zadania,
- terminie,
- etykiecie,
- wielkości,
- skomplikowaniu,
- polach konfigurowalnych,
- zadaniach głównych lub podzadaniach.

Sortowanie:

- kolejność ręczna,
- ostatnia zmiana,
- termin,
- priorytet,
- data utworzenia,
- osoba odpowiedzialna.

Filtry i sortowanie powinny być częścią zapisanego widoku użytkownika albo projektu.

### Co widzimy domyślnie?

Domyślna lista projektu nie powinna pokazywać wszystkiego bez ograniczenia. Proponowany widok:

- aktywne zadania,
- zadania bez statusu zakończonego,
- sortowanie według kolejności projektu albo priorytetu,
- zakończone zadania ukryte w osobnym filtrze.

Widoki:

```text
Aktywne
Moje zadania
Przeterminowane
Na dziś
Ostatnio zakończone
Archiwum
Wszystkie
```

### Kiedy zadania znikają?

Zadanie nie powinno znikać po zmianie na `Gotowe`. Zostaje w bazie i historii, ale domyślnie przestaje być widoczne w aktywnej liście.

Proponowany cykl:

```text
Aktywne → Gotowe → Zakończone → Zarchiwizowane
```

#### Gotowe

Zadanie jest zakończone, ale nadal łatwo dostępne:

- widoczne w historii,
- widoczne w filtrze „Zakończone”,
- może być przywrócone,
- pozostaje w raportach.

#### Zarchiwizowane

Zadanie jest ukryte w standardowych widokach:

- nie pojawia się w aktywnym Kanbanie,
- nie pojawia się w domyślnej liście,
- pozostaje w wyszukiwarce i archiwum,
- może zostać przywrócone przez Ownera/Admina.

Archiwizacja może być ręczna albo później automatyczna, np. po 90 dniach od zakończenia. Automatycznej archiwizacji nie wprowadzamy bez potwierdzenia polityki workspace.

#### Usunięcie

Fizyczne usunięcie powinno być wyjątkowe. Rekomendowany model:

- Owner może usunąć lub trwale zarchiwizować projekt,
- Admin może archiwizować dane operacyjnie, ale nie usuwać projektu,
- zadania trafiają najpierw do kosza/archiwum,
- trwałe usunięcie wymaga osobnej akcji i może podlegać retencji.

### Kanban a paginacja

Kanban także nie powinien pobierać nieskończonej liczby zadań. Powinien:

- ładować zadania osobno dla każdej kolumny,
- pokazywać liczbę wszystkich zadań w kolumnie,
- wyświetlać pierwszą partię kart,
- oferować „Załaduj więcej”,
- używać filtrów projektu,
- po zmianie statusu przenosić kartę lokalnie i synchronizować zmianę z backendem.

Przykład:

```text
W toku — 148 zadań
[pierwsze 25 kart]
[Załaduj więcej]
```

### Timeline i dashboard

Timeline nie powinien pobierać całego projektu bez filtrów. Użytkownik wybiera:

- zakres dat,
- osoby,
- statusy,
- projekty,
- typy zadań.

Dashboard pobiera agregaty, a nie wszystkie zadania:

- liczba aktywnych,
- liczba zakończonych,
- liczba przeterminowanych,
- postęp projektu,
- zadania według statusu.

Szczegóły są pobierane dopiero po kliknięciu widgetu.

### Wyszukiwanie

Wyszukiwarka globalna powinna przeszukiwać:

- tytuły i opisy zadań,
- komentarze,
- pliki i ich nazwy,
- projekty,
- whiteboardy,
- karteczki,
- użytkowników.

Wyniki muszą być filtrowane przez uprawnienia użytkownika. Użytkownik nie może znaleźć prywatnego projektu lub zadania, którego nie może normalnie zobaczyć.

### Rekomendacja techniczna dla UI

Flutter powinien mieć osobne stany dla:

- pierwszego ładowania,
- doładowywania kolejnej strony,
- odświeżania,
- pustego wyniku,
- błędu,
- braku kolejnych danych.

Użytkownik nie powinien tracić aktualnych filtrów i pozycji scrolla przy przejściu z listy do szczegółów zadania i powrocie.

## 31. Dokumentacja i Wiki

Dokumentacja powinna być osobnym modułem, niezależnym od komentarzy i zwykłych plików.

```text
Komentarz  — rozmowa dotycząca zadania lub elementu
Plik       — załącznik albo materiał binarny
Dokument   — trwała treść robocza lub instrukcja
Wiki       — uporządkowana wiedza Workspace albo projektu
```

Wiki będzie hierarchią stron Workspace/projektu, z rich-textem, podstronami, blokami kodu, tabelami, linkami do zadań, wzmiankami, załącznikami, komentarzami, wersjonowaniem i przywracaniem poprzednich wersji.

Przykład:

```text
Wiki Workspace
├── Jak pracujemy
├── Procedury
│   ├── Tworzenie zadania
│   └── Akceptacja pracy
├── Architektura systemu
└── FAQ
```

Owner/Admin zarządza strukturą, Member edytuje zgodnie z dostępem, a Observer ma dostęp tylko do odczytu. Dokumenty i strony Wiki muszą być uwzględnione w wyszukiwarce z pełnym respektowaniem uprawnień.

## 32. Zaakceptowane rozszerzenia produktu

Do dalszego planu dodajemy:

1. cele i OKR,
2. automatyzacje,
3. import i eksport danych,
4. dokumentację i Wiki.

### Cele i OKR

```text
Cel Workspace
└── Kluczowy rezultat
    └── Projekt
        └── Zadania
```

Cel powinien mieć nazwę, opis, właściciela, okres, status, wartość początkową, wartość docelową, postęp, powiązane projekty i historię aktualizacji. Na początku postęp może być aktualizowany ręcznie; automatyczne wyliczanie z zadań dodamy później.

### Automatyzacje

Podstawowy model:

```text
Gdy: zdarzenie
Jeżeli: warunek
Wykonaj: akcję
```

Pierwsze zdarzenia: utworzenie zadania, zmiana statusu, zmiana osoby, zmiana terminu, ukończenie zadania i utworzenie komentarza.

Pierwsze akcje: zmiana statusu, przypisanie użytkownika, zmiana priorytetu, ustawienie terminu, dodanie etykiety, komentarz systemowy, powiadomienie i utworzenie zadania z szablonu.

Każda automatyzacja musi mieć właściciela, zakres projektu, status aktywna/wstrzymana, historię uruchomień, limit i obsługę błędów. Nie wprowadzamy dowolnych skryptów ani niekontrolowanych zmian poza projektem.

### Import i eksport

Eksport powinien obejmować zadania do CSV, projekty z metadanymi, komentarze, historię zmian, listę plików i metadane oraz pełny eksport Workspace dla Ownera/Admina.

Import CSV powinien działać przez:

```text
Wybierz plik → Mapowanie kolumn → Walidacja → Podgląd błędów → Import
```

Import powinien obsługiwać zadania, statusy, użytkowników, terminy, etykiety i relacje parent/subtask. Import z Jira, Asany i ClickUpa pozostaje funkcją późniejszą.

### Kolejność wdrożenia rozszerzeń

1. podstawowa dokumentacja i Wiki,
2. eksport CSV,
3. podstawowe cele i kluczowe rezultaty,
4. proste automatyzacje statusów i terminów,
5. import CSV z podglądem,
6. wersjonowanie i rozbudowa Wiki,
7. automatyczne wyliczanie postępu celów,
8. importy zewnętrzne.

## 33. Integracja AI przez AIFastApi

System Workspace powinien korzystać z istniejącego projektu `AIFastApi` jako wyspecjalizowanej usługi AI. AIFastApi posiada już interfejsy dla czatu, RAG, analizy dokumentów, podsumowań, embeddingów, generowania obrazów, generowania wykresów, transkrypcji i zadań asynchronicznych.

### Zasada integracji

```text
Flutter
   ↓
veloryn-workspaces
   ├── sprawdza JWT i uprawnienia
   ├── pobiera kontekst projektu/zadania
   ├── wysyła ograniczony kontekst do AIFastApi
   └── zapisuje zatwierdzony rezultat
             ↓
        AIFastApi
```

AIFastApi nie powinno bezpośrednio zapisywać zadań, komentarzy, projektów ani dokumentów w bazie `veloryn-workspaces`. Powinno zwracać propozycję albo wynik analizy, a zapis następuje dopiero po akceptacji użytkownika.

### Zakres kontekstu AI

Każde żądanie AI powinno być ograniczone do odpowiedniego kontekstu:

```text
ready_id
workspace_id
project_id
task_id
whiteboard_id
document_id
```

Proponowane scope'y wiedzy:

```text
workspace:{workspaceId}
project:{projectId}
task:{taskId}
whiteboard:{whiteboardId}
document:{documentId}
```

AI nie może otrzymywać danych z prywatnego projektu, zadania lub dokumentu, którego użytkownik nie może normalnie zobaczyć.

## 34. Funkcje AI dla zadań

### Pomoc przy tworzeniu zadania

Użytkownik wpisuje zwykły opis, a AI proponuje:

- lepszy tytuł,
- opis rich-text,
- typ zadania,
- priorytet,
- wielkość,
- stopień skomplikowania,
- ryzyko,
- kryteria akceptacji,
- podzadania,
- etykiety,
- sugerowany status,
- sugerowaną osobę odpowiedzialną.

AI nie zapisuje propozycji automatycznie. Użytkownik może zaakceptować całość albo wybrane pola.

### Rozbijanie zadania na podzadania

```text
Zadanie: Przygotować moduł dokumentów
    ↓
AI proponuje:
    ├── zaprojektować model danych,
    ├── przygotować API,
    ├── przygotować ekran Flutter,
    ├── dodać uprawnienia,
    ├── przygotować testy,
    └── przygotować dokumentację.
```

System musi przestrzegać zasady, że podzadanie nie może posiadać własnego podzadania.

### Ulepszanie opisu

AI może:

- uporządkować chaotyczny opis,
- poprawić język,
- dodać nagłówki,
- utworzyć checklistę,
- wydzielić kryteria akceptacji,
- wykryć brakujące informacje,
- oznaczyć niejasne wymagania.

### Podsumowanie zadania

AI analizuje opis, komentarze, historię i podzadania oraz tworzy:

- aktualny stan,
- wykonane elementy,
- pozostałe elementy,
- decyzje,
- blokery,
- ryzyka,
- następne kroki.

Podsumowanie powinno mieć datę wygenerowania i informację, na jakich danych powstało.

### Wykrywanie ryzyk i blockerów

AI może wykrywać:

- zadania długo pozostające w jednym statusie,
- opóźnione terminy,
- brak osoby odpowiedzialnej,
- sprzeczne informacje w komentarzach,
- powtarzające się problemy,
- zależności blokujące inne zadania,
- zbyt duży zakres zadania,
- brak kryteriów akceptacji.

Wyniki powinny być sugestiami lub oznaczeniami do potwierdzenia, a nie automatycznymi zmianami priorytetu.

### Podobne zadania i duplikaty

Przy tworzeniu zadania AI może wyszukać podobne zadania na podstawie znaczenia, nie tylko identycznych słów:

```text
Znaleziono podobne zadania:
- Naprawić import XLSX
- Błąd podczas importu dokumentów
```

Użytkownik może otworzyć istniejące zadanie, połączyć je, oznaczyć jako duplikat albo kontynuować tworzenie.

## 35. Podsumowania projektów i pracy

### Podsumowanie projektu

AI może analizować zadania, komentarze, historię, dokumenty i aktywność oraz przygotować:

- postęp projektu,
- najważniejsze ukończone zadania,
- zadania opóźnione,
- zadania zbliżające się do terminu,
- blokery,
- ryzyka,
- ostatnie decyzje,
- rekomendowane następne działania.

### Podsumowanie tygodniowe

```text
Tygodniowe podsumowanie projektu

Wykonano:
- 12 zadań

Najważniejsze zmiany:
- zakończono moduł plików

Ryzyka:
- opóźnione testy

Plan na kolejny tydzień:
- dokończyć komentarze,
- przygotować wersję testową.
```

Podsumowania mogą być dostępne w projekcie, na dashboardzie i opcjonalnie wysyłane e-mailem.

### Aktualizacje statusu projektu

AI może przygotować propozycję statusu:

- `On track`,
- `At risk`,
- `Off track`,
- `Completed`.

Owner lub Admin zatwierdza publikację statusu.

## 36. AI w komentarzach i dokumentacji

AI może pomagać w:

- formatowaniu komentarza,
- tworzeniu listy decyzji,
- wyciąganiu zadań z komentarza,
- tworzeniu kryteriów akceptacji,
- poprawie języka,
- skróceniu lub rozszerzeniu tekstu,
- tłumaczeniu,
- wyjaśnieniu fragmentu kodu,
- przygotowaniu odpowiedzi do komentarza.

### Długi tekst

Jeśli komentarz jest bardzo długi, AI może zaproponować:

- skrócenie komentarza,
- utworzenie podsumowania,
- utworzenie dokumentu Markdown,
- dołączenie pliku tekstowego.

Oryginalna treść nie może zostać automatycznie usunięta bez potwierdzenia użytkownika.

### Dokumentacja Wiki

AI może tworzyć lub aktualizować propozycje:

- opisu projektu,
- specyfikacji,
- procedury,
- FAQ,
- dokumentu decyzji,
- dokumentacji API,
- changelogu,
- instrukcji użytkownika.

Propozycja musi zostać zatwierdzona przed opublikowaniem w Wiki.

## 37. AI dla plików i dokumentów

AIFastApi może analizować m.in. PDF, DOCX, XLSX, CSV, obrazy i strony internetowe.

Możliwe akcje:

- podsumowanie pliku,
- zadanie pytania do pliku,
- wyciągnięcie najważniejszych informacji,
- znalezienie terminów i osób,
- stworzenie checklisty,
- wygenerowanie zadań na podstawie dokumentu,
- porównanie dwóch dokumentów,
- znalezienie sprzeczności,
- stworzenie dokumentacji Wiki.

Przykład:

```text
Przeanalizuj ten dokument i zaproponuj listę zadań wdrożeniowych.
```

AI powinno zwrócić listę propozycji, które użytkownik może wybrać i utworzyć.

## 38. AI dla Whiteboardu

AI może analizować elementy whiteboardu i rozpoznawać:

- pomysły,
- decyzje,
- problemy,
- zadania,
- zależności,
- grupy tematyczne.

Przepływ:

```text
Whiteboard
    ↓
AI analizuje elementy
    ↓
Proponuje zadania i relacje
    ↓
Użytkownik wybiera elementy
    ↓
Workspace zapisuje zatwierdzone dane
```

AI może także zaproponować uporządkowanie płótna albo wygenerować opis procesu przedstawionego na whiteboardzie.

## 39. Generowanie obrazów i wykresów

### Obrazy

Istniejące generowanie obrazów można wykorzystać do:

- okładek projektów,
- ikon projektów,
- ilustracji dokumentacji,
- wizualizacji pomysłów,
- grafik na whiteboardzie,
- diagramów koncepcyjnych.

Wygenerowany obraz powinien być zapisany jako plik lub zasób projektu z metadanymi promptu, autora i daty utworzenia.

### Wykresy

Na podstawie danych Workspace można generować:

- postęp projektu,
- zadania według statusu,
- zadania według priorytetu,
- opóźnienia,
- aktywność zespołu,
- postęp celów.

Dane do wykresu powinny pochodzić z backendu Workspace, a AIFastApi może przygotować specyfikację i opis wykresu. AI nie powinno samodzielnie pobierać danych z bazy Workspace.

## 40. Transkrypcja spotkań i zadania

Wykorzystując istniejącą transkrypcję audio można zbudować przepływ:

```text
Nagranie spotkania
    ↓
Transkrypcja
    ↓
Podsumowanie
    ↓
Decyzje i ustalenia
    ↓
Proponowane zadania
```

Użytkownik zatwierdza zadania przed ich utworzeniem. Każde zadanie powinno mieć odnośnik do źródłowej transkrypcji.

## 41. Zasady bezpieczeństwa i kontroli AI

- AI zawsze działa w kontekście uprawnień użytkownika.
- `veloryn-workspaces` sprawdza JWT przed wywołaniem AIFastApi.
- Do AIFastApi wysyłany jest tylko potrzebny zakres danych.
- Prywatne projekty i dokumenty nie mogą trafić do nieuprawnionego kontekstu.
- AI nie usuwa danych automatycznie.
- AI nie zmienia statusu, priorytetu ani osoby odpowiedzialnej bez zatwierdzenia, poza jawnie włączoną automatyzacją.
- Każda propozycja AI ma autora, czas, źródło i status: `proposed`, `accepted`, `rejected`.
- Należy rejestrować użycie AI i koszt/limit operacji.
- Długie operacje działają jako joby asynchroniczne.
- Użytkownik widzi, że treść została wygenerowana lub zmieniona przez AI.
- Odpowiedzi dotyczące dokumentów powinny zawierać źródła lub odnośniki do materiałów.

## 42. Kontrakt propozycji AI

Każda funkcja modyfikująca dane powinna zwracać propozycję, np.:

```text
AiProposal
├── id
├── type
├── source_module
├── workspace_id
├── project_id
├── task_id
├── source_ids
├── changes
├── explanation
├── confidence
├── status
├── created_by
└── created_at_utc
```

Przykładowy status:

```text
proposed → accepted
         └→ rejected
         └→ expired
```

Flutter powinien pokazywać różnice przed zatwierdzeniem:

```text
Tytuł: zmiana proponowana
Priorytet: Normalny → Wysoki
Dodano: 5 podzadań

[Zatwierdź wszystkie] [Wybierz zmiany] [Odrzuć]
```

## 43. Kolejność wdrażania AI

1. pomoc przy tworzeniu i formatowaniu zadania,
2. generowanie podzadań i kryteriów akceptacji,
3. podsumowanie zadania,
4. analiza plików i dokumentów,
5. podsumowanie projektu,
6. tygodniowe podsumowania,
7. wyszukiwanie semantyczne i duplikaty,
8. generowanie dokumentacji Wiki,
9. analiza whiteboardu,
10. generowanie wykresów,
11. generowanie obrazów,
12. transkrypcja spotkań i propozycje zadań,
13. automatyzacje wspierane przez AI.

Najważniejsza zasada integracji brzmi:

```text
AI proponuje → użytkownik zatwierdza → Workspace zapisuje
```

## 31. Dokumentacja i Wiki

Dokumentacja powinna być osobnym modułem, niezależnym od komentarzy i zwykłych plików.

```text
Komentarz  — rozmowa dotycząca zadania lub elementu
Plik       — załącznik albo materiał binarny
Dokument   — trwała treść robocza lub instrukcja
Wiki       — uporządkowana wiedza Workspace albo projektu
```

### Struktura dokumentów

```text
Workspace
├── Dokumenty Workspace
│   ├── Procedury
│   ├── Instrukcje
│   └── Wiedza zespołu
└── Projekt
    └── Dokumenty projektu
        ├── Opis projektu
        ├── Specyfikacja
        └── Decyzje
```

Dokument powinien mieć tytuł, treść rich-text, podstrony, właściciela, wersje, komentarze, wzmianki, załączniki, linki do projektów/zadań/whiteboardów, status oraz datę ostatniego przeglądu.

Edytor powinien obsługiwać nagłówki, akapity, listy, tabele, linki, cytaty, bloki kodu, obrazy, pliki, wzmianki, odnośniki do zadań i historię wersji.

### Wiki

Wiki jest hierarchią stron:

```text
Wiki Workspace
├── Jak pracujemy
├── Procedury
│   ├── Tworzenie zadania
│   └── Akceptacja pracy
├── Architektura systemu
└── FAQ
```

Może być dostępne dla całego Workspace albo ograniczone do projektu. Owner/Admin zarządza strukturą, Member edytuje zgodnie z dostępem, a Observer ma dostęp tylko do odczytu.

Każda opublikowana zmiana tworzy wersję z autorem, datą, opisem, możliwością porównania i przywrócenia.

## 32. Zaakceptowane rozszerzenia produktu

Do dalszego planu dodajemy:

1. cele i OKR,
2. automatyzacje,
3. import i eksport danych,
4. dokumentację i Wiki.

### Cele i OKR

```text
Cel Workspace
└── Kluczowy rezultat
    └── Projekt
        └── Zadania
```

Cel powinien mieć nazwę, opis, właściciela, okres, status, wartość początkową, wartość docelową, postęp, powiązane projekty i historię aktualizacji. Na początku postęp może być aktualizowany ręcznie; automatyczne wyliczanie z zadań dodamy później.

### Automatyzacje

Podstawowy model:

```text
Gdy: zdarzenie
Jeżeli: warunek
Wykonaj: akcję
```

Pierwsze zdarzenia: utworzenie zadania, zmiana statusu, zmiana osoby, zmiana terminu, ukończenie zadania i utworzenie komentarza.

Pierwsze akcje: zmiana statusu, przypisanie użytkownika, zmiana priorytetu, ustawienie terminu, dodanie etykiety, komentarz systemowy, powiadomienie i utworzenie zadania z szablonu.

Każda automatyzacja musi mieć właściciela, zakres projektu, status aktywna/wstrzymana, historię uruchomień, limit i obsługę błędów. Nie wprowadzamy dowolnych skryptów ani niekontrolowanych zmian poza projektem.

### Import i eksport

Eksport powinien obejmować zadania do CSV, projekty z metadanymi, komentarze, historię zmian, listę plików i metadane oraz pełny eksport Workspace dla Ownera/Admina.

Pełny eksport powinien być zadaniem asynchronicznym, a użytkownik powinien otrzymać powiadomienie po przygotowaniu paczki.

Import CSV powinien działać przez:

```text
Wybierz plik → Mapowanie kolumn → Walidacja → Podgląd błędów → Import
```

Import powinien obsługiwać zadania, statusy, użytkowników, terminy, etykiety i relacje parent/subtask. Import z Jira, Asany i ClickUpa pozostaje funkcją późniejszą.

### Kolejność wdrożenia rozszerzeń

1. podstawowa dokumentacja i Wiki,
2. eksport CSV,
3. podstawowe cele i kluczowe rezultaty,
4. proste automatyzacje statusów i terminów,
5. import CSV z podglądem,
6. wersjonowanie i rozbudowa Wiki,
7. automatyczne wyliczanie postępu celów,
8. importy zewnętrzne.
