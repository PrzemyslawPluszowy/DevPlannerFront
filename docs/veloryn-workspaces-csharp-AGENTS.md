# AGENTS.md — veloryn-workspaces backend

Ten plik jest instrukcją dla osobnego repozytorium C# `veloryn-workspaces`.
Po utworzeniu repozytorium należy przenieść go do jego katalogu głównego jako
`AGENTS.md`.

## Cel i granice

`veloryn-workspaces` jest produkcyjnym backendem ASP.NET Core dla zamkniętego
systemu workspace’ów użytkowników Ready. Jest osobną usługą od `veloryn-core`,
DataBus i `AIFastApi`.

- `veloryn-core` dostarcza tożsamość, JWT/JWKS, `CoreUserId`, `ReadyUserId` oraz
  globalną rolę `SuperAdmin`.
- Workspaces zarządza domeną workspace, projektów, zadań, plików, komentarzy,
  whiteboardów, Wiki, powiadomień i dashboardów.
- Pierwsza baza jest osobnym PostgreSQL ze schematem `veloryn_workspaces`.
- MinIO jest prywatne i dostępne wyłącznie przez backend po sprawdzeniu JWT oraz
  uprawnień.
- `AIFastApi` jest wywoływane przez backend, nigdy bezpośrednio przez Fluttera.

## Kontrakt z `veloryn-core`

Waliduj lokalnie RSA JWT przez JWKS Core pod `/.well-known/jwks.json`. Aktualny
kontrakt Core używa `sub`, `unique_name`, `ready_id` i powtarzalnych claimów
`permission`, z issuerem Core oraz audience `veloryn-modules`.

SuperAdmin jest już obsługiwany po stronie `veloryn-core`/Ready przez istniejący
mechanizm grup i praw administracyjnych. Workspaces nie tworzy drugiego źródła
SuperAdmina ani nie rozpoznaje go po loginie, e-mailu lub nazwie użytkownika.
Należy wykorzystać istniejące oznaczenie przekazane przez Core w JWT i zamknąć
jego interpretację w jednej, jawnej polityce/stałej Workspaces. Dokładną wartość
claimu trzeba potwierdzić na kontrakcie Core przed implementacją.

## E-mail

Nie wymagamy zewnętrznego dostawcy e-mail. Używamy interfejsu `IEmailSender` z
implementacją SMTP. Lokalnie SMTP wskazuje na Mailpit/MailHog, a produkcja na
istniejący serwer SMTP przez sekrety środowiskowe. Wysyłka zaproszeń i innych
wiadomości jest asynchroniczna, realizowana przez Outbox, z retry, idempotencją,
statusem i audytem.

## Git

- Cała praca nad `veloryn-workspaces` odbywa się wyłącznie na branchu
  `workspace`.
- Nie twórz osobnych feature branchy dla tego projektu.
- Zmiany, testy i commity wykonuj na branchu `workspace`.

## Obowiązkowy kontekst Workspaces

Przed rozpoczęciem pracy nad backendem agent musi przeczytać:

1. `workspace-implementation.md` — pełny zakres i decyzje produktowe,
2. `workspace-implementation-plan.md` — kolejność wdrażania i checklistę,
3. ten `AGENTS.md` — zasady backendu C#.

Jeżeli backend znajduje się w osobnym katalogu/repozytorium, kopia tych dwóch
plików planistycznych albo link do ich aktualnych wersji musi być dostępny w
repozytorium backendu. Agent nie powinien prosić użytkownika o ponowne opisanie
zakresu Workspaces; ma kontynuować od pierwszego niezakończonego punktu planu.
Po wykonaniu zadania aktualizuj checklistę i dokumentację, gdy zmieniły się
ustalenia.

## Architektura

Można wykorzystać dobry podział z Dev Note, ale nie kopiować implementacji 1:1.
Preferowana struktura:

```text
veloryn-workspaces/
├── Endpoints/
│   ├── Workspaces/
│   ├── Projects/
│   ├── Tasks/
│   ├── Whiteboards/
│   ├── Files/
│   ├── Comments/
│   ├── Notifications/
│   ├── Wiki/
│   ├── Dashboards/
│   └── Ai/
├── Application/
│   ├── Workspaces/
│   ├── Projects/
│   ├── Tasks/
│   └── Common/
├── Domain/
│   ├── Entities/
│   ├── Enums/
│   ├── Events/
│   └── Rules/
├── Infrastructure/
│   ├── Persistence/
│   ├── Minio/
│   ├── Core/
│   ├── Ai/
│   └── Notifications/
├── Contracts/
├── Validators/
├── Migrations/
├── Tests/
└── Program.cs
```

`Program.cs` jest composition rootem. Endpointy nie zawierają SQL ani reguł
biznesowych. Warstwa Application orkiestruje przypadki użycia, Domain zawiera
reguły, Infrastructure implementuje dostęp do bazy/usług, a Contracts zawiera
jawne requesty i response’y HTTP.

Stosujemy podejście feature-first w obrębie warstw. Kod dotyczący projektów nie
powinien być rozsiany po jednym globalnym folderze `Services`; powinien pozostać
zgrupowany pod `Projects`, a wspólne elementy trafiają do `Common` tylko wtedy,
gdy są rzeczywiście wspólne.

### Obowiązująca interpretacja feature-first

Wzorzec Dev Note zachowujemy na poziomie organizacji funkcjonalnej, ale
implementację dostosowujemy do nowego kontraktu Workspaces. Każda domena ma
jedno miejsce dla endpointów, przypadków użycia, kontraktów, walidatorów i
adapterów danych:

```text
Workspaces/
├── Endpoints/
├── Application/
├── Domain/
├── Contracts/
├── Validators/
└── Infrastructure/
```

Docelowy kod nie może mieszać domen w jednym globalnym `Services`, `Data` ani
`Validators`. Przykładowo wszystkie elementy tworzenia workspace pozostają
razem w `Workspaces/CreateWorkspace`, a elementy logowania w `Auth/Login`.
Warstwy opisują odpowiedzialność techniczną, natomiast foldery feature’ów
opisują odpowiedzialność biznesową. `Program.cs` rejestruje feature extensions,
ale nie zawiera reguł domenowych ani konfiguracji poszczególnych przypadków
użycia.

Przykładowy przypadek użycia:

```text
Tasks/
├── CreateTask/
│   ├── CreateTaskEndpoint.cs
│   ├── CreateTaskCommand.cs
│   ├── CreateTaskHandler.cs
│   ├── CreateTaskValidator.cs
│   └── CreateTaskResponse.cs
└── ListTasks/
    ├── ListTasksEndpoint.cs
    ├── ListTasksQuery.cs
    ├── ListTasksHandler.cs
    └── ListTasksResponse.cs
```

Nie wymuszaj jednak osobnego pliku dla banalnego typu. Najważniejsza jest
czytelna odpowiedzialność i możliwość testowania, a nie liczba plików.

## Zasady Dev Note, które zachowujemy

- endpointy pogrupowane według funkcji,
- serwisy przypadków użycia poza endpointami,
- repozytoria i adaptery infrastruktury za interfejsami,
- encje oddzielone od DTO HTTP,
- walidacja wejścia przed wykonaniem przypadku użycia,
- wspólny model błędów,
- mały i czytelny composition root,
- kontrola uprawnień w serwisie domenowym, nie tylko w endpointach.

## Standard C# i .NET

- Backend budujemy na najnowszym wspieranym Minimal API dostępnym dla wybranej
  wersji .NET. Nie używamy przestarzałych wzorców tylko dlatego, że występowały
  w Dev Note.
- Endpointy grupuj domenowo przez route groups i rozszerzenia rejestrujące
  endpointy; każdy endpoint powinien używać typed results, jawnych kontraktów i
  metadanych OpenAPI.
- Handler Minimal API ma pozostać cienki: binding, walidacja wejścia,
  autoryzacja i wywołanie przypadku użycia. Logika biznesowa nie może trafiać do
  lambda expressions endpointów.
- Cały kod powinien być możliwie silnie i jawnie typowany. Nie używaj `dynamic`,
  `object`, niejawnych słowników ani surowych stringów tam, gdzie można użyć
  konkretnego typu, enumu, rekordu lub value objectu.
- DTO, encje, komendy, zapytania, odpowiedzi, identyfikatory, statusy, role,
  uprawnienia i wyniki operacji muszą mieć jawne typy.
- Enumy wystawiane w HTTP serializuj jako stabilne wartości tekstowe, nigdy jako
  numery. Ich wartości i znaczenie muszą być opisane po polsku w OpenAPI.
- Identyfikatory domenowe powinny być typowane i rozróżnialne, np. nie przekazuj
  `ProjectId`, `TaskId` i `WorkspaceId` jako nieopisanych stringów w warstwie
  domenowej, jeśli można użyć odpowiednich typów.
- Dla opcjonalności używaj nullable reference types i typów nullable zamiast
  wartości specjalnych typu pusty string, `0` albo magiczny status.
- Wyniki przypadków użycia powinny być typowane; błędy mapuj przez wspólny,
  jawny model błędu zamiast zwracać dowolny obiekt.
- Używaj wersji .NET ustalonej dla repozytorium i najnowszej składni dostępnej w
  tej wersji SDK.
- Włącz nullable reference types, analyzers i ostrzeżenia traktowane jako błędy
  w kodzie produkcyjnym, jeżeli nie koliduje to z istniejącym kodem migracyjnym.
- Preferuj file-scoped namespaces, `sealed` dla klas bez planowanego dziedziczenia,
  `required`, collection expressions, pattern matching i primary constructors,
  gdy poprawiają czytelność.
- Requesty i response’y HTTP zapisuj jako jawne, niemutowalne `record`/`record`
  `struct`, jeśli nie ma powodu użyć klasy.
- Encje EF Core nie są kontraktami HTTP.
- Nie twórz globalnych funkcji ani globalnego stanu. Wspólną logikę umieszczaj w
  klasach o jednej odpowiedzialności, helperach domenowych albo metodach
  rozszerzających, gdy rozszerzenie jest naturalne dla danego typu.
- Nie używaj statycznych singletonów do stanu biznesowego, cache’u, sesji ani
  uprawnień.
- Każda klasa publiczna i każda nieoczywista reguła domenowa powinna mieć
  dokumentację XML `///` po polsku.

## DI, async i lifecycle

- Rejestruj zależności jawnie w rozszerzeniach DI; `Program.cs` pozostaje prosty.
- Domyślnie używaj scoped dla przypadków użycia i `DbContext`.
- Singleton może być użyty tylko dla bezstanowych, thread-safe usług lub jawnie
  zarządzanych klientów infrastruktury.
- Nigdy nie wstrzykuj scoped `DbContext` do singletona.
- Wszystkie operacje I/O implementuj asynchronicznie z `CancellationToken`.
- Przekazuj `CancellationToken` przez endpoint, handler, repozytorium i klienta
  infrastruktury.
- Nie używaj `.Result`, `.Wait()` ani blokowania wątku na operacjach async.
- Zapytania EF Core wykonuj z `AsNoTracking()` dla odczytu i z projekcją do DTO,
  zamiast ładować całe encje bez potrzeby.
- Transakcje obejmujące kilka zmian otwieraj w warstwie przypadku użycia.
- Operacje retry muszą być idempotentne albo zabezpieczone kluczem idempotencji.

## EF Core i PostgreSQL

- Każda zmiana modelu bazy wymaga migracji EF Core.
- W development i testach używamy lokalnego Dockera, więc bazę Workspaces można
  bezpiecznie czyścić, odtwarzać i wypełniać danymi testowymi.
- Z bazy produkcyjnej można pobierać dane potrzebne do developmentu, np. listę
  użytkowników, wyłącznie przez kontrolowany dostęp read-only i bez kopiowania
  sekretów, haseł ani wrażliwych danych.
- Po wdrożeniu produkcyjnym `veloryn-workspaces` może tworzyć i zmieniać wyłącznie
  obiekty w schemacie `veloryn_workspaces`. Nie modyfikuj tabel, widoków, funkcji,
  danych ani uprawnień należących do innych modułów.
- Jeżeli w przyszłości usługa korzysta ze wspólnej bazy z `veloryn-core`, zmiany
  w Core są dopuszczalne wyłącznie w jego własnym schema, po osobnej decyzji i
  kontrolowanej migracji.
- `DbContext` musi mieć jawnie ograniczony zakres modelu i schema; nie wolno
  uruchamiać migracji całej wspólnej bazy z konfiguracji Workspaces.
- Domyślnie nie piszemy ręcznych zapytań SQL. Odczyty i zapisy realizujemy przez
  EF Core oraz LINQ, z typowanymi projekcjami do DTO.
- `FromSql`/`ExecuteSql` oraz ręczny SQL są wyjątkami, a nie standardem. Można ich
  użyć tylko po uzasadnieniu technicznym, np. dla konkretnej optymalizacji,
  funkcji PostgreSQL albo raportu niemożliwego do czytelnego wyrażenia w LINQ.
- Każdy wyjątek z ręcznym SQL musi mieć test integracyjny, parametryzację,
  komentarz wyjaśniający powód oraz sprawdzenie planu wykonania, gdy dotyczy
  wydajności.
- Nie składaj SQL przez konkatenację stringów i nie przyjmuj nazw tabel, kolumn
  ani fragmentów sortowania bez jawnej białej listy.
- Wszystkie tabele Workspaces muszą mieć jawnie ustawiony schema
  `veloryn_workspaces`.
- Konfiguracje encji trzymaj w osobnych klasach `IEntityTypeConfiguration<T>`.
- Indeksy, klucze unikalne, długości pól, wartości wymagane i relacje definiuj
  jawnie w konfiguracji modelu.
- Daty zapisuj jako UTC i nazywaj je z sufiksem `Utc`.
- Nie wykonuj zapytań bez ograniczenia do `workspace_id`, gdy dane są własnością
  workspace’u.
- Nie używaj lazy loadingu dla głównych ścieżek API.
- Migracje muszą działać zarówno na pustej bazie, jak i na bazie po poprzednich
  wersjach aplikacji.
- Migracje produkcyjne muszą być bezpieczne i możliwie addytywne: najpierw dodaj
  nowe kolumny/tabele/indeksy, wprowadź kod korzystający z obu stanów, a dopiero
  po potwierdzeniu użycia usuń stare elementy w osobnej, zatwierdzonej migracji.
- Na lokalnym Dockerze można wykonywać `DROP`, reset bazy i destrukcyjne migracje,
  jeżeli środowisko nie zawiera danych produkcyjnych. Na produkcji nie wykonuj
  automatycznego `DROP`, destrukcyjnego `ALTER`, czyszczenia danych ani zmiany
  typu mogącej obciąć dane bez osobnej procedury, backupu, planu odtworzenia i
  akceptacji.
- Każda migracja musi mieć sprawdzenie zakresu obiektów, plan rollbacku lub
  procedurę naprawczą oraz test na kopii reprezentatywnej bazy.
- Projektuj indeksy na podstawie rzeczywistych zapytań, filtrów, sortowania i
  zakresu workspace’u. Indeksy definiuj w konfiguracji EF Core i dostarczaj przez
  migracje, a nie przez ręczne zmiany środowiska.
- Dla wyszukiwania semantycznego, kontekstu AI i przyszłych funkcji uczenia można
  używać rozszerzenia PostgreSQL `pgvector`.
- Embedding przechowuj z jawnym `model_version`, `dimensions`, typem treści,
  źródłowym identyfikatorem i zakresem dostępu (`workspace_id`/`project_id`).
- Nie mieszaj embeddingów między workspace’ami. Każde wyszukiwanie wektorowe musi
  najpierw respektować uprawnienia i scope użytkownika, a dopiero potem ranking.
- Indeks wektorowy dobieraj do skali danych i wymiaru embeddingów; jego użycie
  potwierdź testem integracyjnym oraz pomiarem zapytania.

## Endpointy i kontrakty API

- Endpoint ma odpowiadać za HTTP: routing, binding, autoryzację wejściową i
  mapowanie wyniku. Reguły biznesowe należą do Application/Domain.
- Swagger/OpenAPI jest obowiązkowym źródłem dokumentacji i kontraktu API.
- Sukces `200`/`201` zwraca bezpośrednio jawne DTO lub tablicę DTO; nie używaj
  ogólnej koperty `data`/`meta` dla prostych odpowiedzi.
- Paginacja ma własny, typowany kontrakt, np. `items` i `meta` z kursorem.
- Wszystkie błędy korzystają z jednego kontraktu: `code`, `message`, opcjonalne
  `fields` i `traceId`. `code` jest stabilnym kodem maszynowym po angielsku, a
  `message` jest po polsku i może być bezpośrednio wyświetlony przez Fluttera.
- Każdy endpoint musi mieć szczegółowy opis po polsku: przeznaczenie, zakres
  zwracanych danych, źródło danych, wymagane uprawnienia, filtry, sortowanie,
  paginację i skutki operacji zapisu.
- Każdy parametr route, query, header i body musi mieć opis po polsku oraz jawny
  typ, ograniczenia, wartość domyślną i informację, czy jest wymagany.
- Każdy endpoint musi dokumentować kody sukcesu, błędów walidacji, braku dostępu,
  braku zasobu, konfliktu i błędu serwera, a dla złożonych requestów/response’ów
  należy dodać przykłady.
- Dokumentuj wymagany JWT, role i scope dostępu w OpenAPI.
- Po zmianie endpointu aktualizuj kontrakt Swaggera, testy kontraktowe oraz
  klienta Flutter.
- Ścieżki używają `/api/v1/...` i rzeczowników domenowych.
- Zmiany kontraktu wymagają aktualizacji OpenAPI, testów kontraktowych i klienta
  Flutter, jeżeli odpowiedź lub request się zmieniły.
- Błędy zwracaj w jednym kontrakcie `code/message/fields/traceId`; nie ujawniaj
  stack trace ani szczegółów SQL.
- Nie zwracaj encji bezpośrednio z endpointu.
- Paginacja, filtrowanie, sortowanie i wyszukiwanie muszą być wykonywane w bazie.
- Dla dużych list preferuj cursor pagination; offset stosuj tylko tam, gdzie
  jest uzasadniony i stabilny.

## Uprawnienia i audyt

- Sprawdzaj JWT, aktywność użytkownika, SuperAdmina, członkostwo workspace,
  członkostwo projektu i uprawnienie do operacji.
- Nie ufaj `workspace_id` przesłanemu przez klienta bez sprawdzenia kontekstu.
- SuperAdmin ma globalny dostęp administracyjny, ale bez członkostwa nie otrzymuje
  powiadomień workspace.
- Każda zmiana członkostwa, roli, dostępu do pliku, statusu i konfiguracji musi
  mieć wpis w Activity/Audit.
- Audyt musi identyfikować aktora, rolę, workspace, zasób, operację, czas i
  wynik.
- Nie loguj tokenów, haseł, presigned URL-i ani prywatnej treści dokumentów.

## Testy i jakość

- Każdy przypadek użycia ma testy jednostkowe reguł i handlera.
- Każdy endpoint ma test poprawnej odpowiedzi, walidacji i autoryzacji.
- Obowiązkowe są testy izolacji workspace’ów i testy SuperAdmina z członkostwem
  oraz bez członkostwa.
- Testuj zaproszenia przed pierwszym logowaniem, MinIO, powiadomienia, paginację,
  realtime, audyt i integrację AI.
- Testy integracyjne mają używać realnego PostgreSQL/MinIO w środowisku testowym,
  a nie wyłącznie atrap, gdy testują mapowanie i zachowanie infrastruktury.
- Po każdej zmianie uruchom `dotnet format`, build, testy i sprawdzenie migracji.
- Nie scalaj kodu z pominiętymi testami bez jawnej decyzji i opisania ryzyka.

## Wydajność i optymalizacja

- Najpierw mierz problem, dopiero potem optymalizuj. Nie dodawaj indeksów,
  cache’u ani komplikacji architektury bez potwierdzonej potrzeby.
- Dla wolnych zapytań sprawdzaj plan wykonania, liczbę zwracanych rekordów,
  selektywność filtrów, użycie indeksów i czas w bazie.
- Preferuj projekcję tylko do potrzebnych pól, `AsNoTracking()` dla odczytów,
  paginację po stronie bazy i ograniczenie zakresu do `workspace_id`.
- Indeks dodaj, gdy wynika z częstego zapytania, filtra, sortowania lub relacji;
  nazwę i cel indeksu opisz w konfiguracji/migracji.
- Indeksy złożone projektuj zgodnie z kolejnością warunków i sortowania, a nie
  przez automatyczne indeksowanie każdej kolumny.
- Po dodaniu indeksu wykonaj pomiar przed/po na reprezentatywnych danych i dodaj
  test lub raport potwierdzający efekt.
- Optymalizacje nie mogą omijać autoryzacji, audytu ani izolacji workspace’ów.

## Niezawodność i spójność

- Zmiany równoległe obsługuj przez optimistic concurrency, np. wersję rekordu
  albo token concurrency; użytkownik nie może bez ostrzeżenia nadpisać cudzej
  zmiany.
- Operacje podatne na ponowienie muszą mieć idempotency key lub bezpieczną
  deduplikację, szczególnie zaproszenia, uploady, powiadomienia i operacje AI.
- Każdy klient zewnętrzny musi mieć timeout, a operacje I/O muszą respektować
  `CancellationToken`.
- Retry z exponential backoff stosuj wyłącznie dla błędów przejściowych i tylko
  dla operacji bezpiecznych do ponowienia.
- Zdarzenia powiadomień, webhooków i integracji zapisuj przez Outbox Pattern,
  aby transakcja domenowa i publikacja zdarzenia nie rozjechały się.
- Transakcje obejmujące bazę i operację zewnętrzną nie mogą udawać atomowości;
  używaj outboxa, statusu operacji i mechanizmu ponowienia.

## Obserwowalność i bezpieczeństwo operacyjne

- Każde żądanie ma correlation ID/trace ID przekazywane do logów i usług
  zależnych.
- Używaj logów strukturalnych, metryk i śladów OpenTelemetry.
- Dodaj health check, readiness, liveness, metryki czasu odpowiedzi, błędów,
  kolejek, zapytań i operacji AI.
- Włącz rate limiting osobno dla API, uploadów, wyszukiwania i AI.
- Sekrety przechowuj poza repozytorium i rotuj bez zmiany kodu.
- Nie uruchamiaj automatycznie migracji produkcyjnych przy każdym starcie usługi;
  migracje stosuj jako kontrolowany krok wdrożenia.

## Pliki, retencja i backupy

- Waliduj rozmiar, MIME type, rozszerzenie i faktyczny typ pliku przed zapisem.
- Nie ufaj nazwie pliku ani nagłówkom przesłanym przez klienta.
- Dla wymaganych formatów przewiduj skanowanie antywirusowe i status kwarantanny.
- Stosuj soft delete/archiwizację zgodnie z polityką domeny oraz jawny okres
  retencji dla plików, komentarzy, audytu i danych AI.
- Wykonuj backup PostgreSQL i MinIO, przechowuj je poza hostem produkcyjnym i
  regularnie testuj pełne odtworzenie.
- Cache stosuj tylko wtedy, gdy klucz uwzględnia scope i uprawnienia; invalidacja
  musi być częścią przepływu zmiany danych.

## Zgodność API i testy niefunkcjonalne

- Dopóki moduł nie został wdrożony produkcyjnie, nie utrzymuj sztucznej zgodności
  ze starym kontraktem. Zmieniaj endpoint, DTO, migrację, testy i klienta Flutter
  razem w jednym spójnym zadaniu.
- Nie zostawiaj deprecated endpointów, adapterów, pól, feature flagów, klas ani
  ścieżek kompatybilności tylko na wszelki wypadek.
- Po zmianie usuń nieużywany kod, stare kontrakty, martwe migracje i tymczasowe
  obejścia. Repozytorium ma pozostać czyste.
- Wersjonowanie i kontrolowana zgodność wsteczna obowiązują dopiero po pierwszym
  wdrożeniu produkcyjnym lub gdy istnieje rzeczywisty zewnętrzny konsument API.
- Po publikacji zmiany niekompatybilne wymagają nowej wersji kontraktu i planu
  migracji, ale również nie utrzymujemy starych ścieżek bez określonego terminu
  usunięcia.
- Testuj obciążenie list zadań, wyszukiwania, uploadów, powiadomień i AI.
- Testuj limity, timeouty, retry, ponowne dostarczenie zdarzeń, concurrency,
  odtworzenie po awarii oraz zachowanie po utracie połączenia z usługą zależną.

## Kryterium gotowości kodu

Kod jest gotowy dopiero wtedy, gdy ma implementację, migrację, kontrakt API,
autoryzację, audyt, testy, dokumentację i obsługę błędów. Sam działający endpoint
nie jest zakończeniem zadania.

## Zasady, których nie kopiujemy z Dev Note

- nie przechowujemy haseł Ready,
- nie używamy jednego refresh tokenu na użytkownika,
- nie używamy własnego modelu użytkownika zamiast `veloryn-core`,
- nie opieramy dostępu na członkostwie zapisanym w JWT,
- nie udostępniamy publicznych URL-i MinIO,
- nie mieszamy tablicy Kanban z whiteboardem,
- nie dodajemy użytkowników zewnętrznych ani roli Guest,
- nie zapisujemy bezpośrednio do baz Ready/eDokumenty.

## Tożsamość i SuperAdmin

Każde żądanie chronione wymaga poprawnego JWT Core. Dostęp do zasobu jest
sprawdzany przez `WorkspaceAccessService`.

### Osobiste preferencje listy workspace

Ukrycie, przypięcie i ręczna kolejność workspace są własnością `CoreUserId` w
`workspace_user_preferences`; nie są członkostwem ani mechanizmem uprawnień.
Preferencję można zapisać tylko dla aktywnego, dostępnego workspace. Lista jest
filtrowana i sortowana w PostgreSQL: przypięte, ręczna pozycja, nazwa,
identyfikator. Zapis kolejności przyjmuje pełny, unikalny zbiór widocznych
workspace bieżącego użytkownika i jest wykonywany atomowo.

### Katalog Ready i zaproszenia

`veloryn-workspaces` nigdy nie łączy się bezpośrednio z bazą Ready. Wyszukiwanie
kandydatów i ponowna weryfikacja `ReadyUserId` są wykonywane wyłącznie przez
read-only endpointy `veloryn-core`. Workspaces przekazuje JWT bieżącego użytkownika
oraz backendowy sekret `X-Veloryn-Internal-Key`; sekret istnieje tylko w konfiguracji
Core i Workspaces, nigdy w Flutterze ani w odpowiedzi HTTP.

Zaproszenie jest zapisane w schemacie `veloryn_workspaces`, nie daje dostępu przed
akceptacją i jest wiązane po stabilnym `ReadyUserId`, nigdy po loginie lub e-mailu.
Akceptacja porównuje `ReadyUserId` z JWT oraz atomowo tworzy członkostwo. Rola
`Owner` nie może zostać nadana przez zaproszenie.

`SuperAdmin` z Core ma pełny dostęp administracyjny do wszystkich workspace’ów,
projektów, zadań, plików, dokumentów, whiteboardów, członkostw i audytu, nawet
bez członkostwa w workspace. Nie oznacza to jednak subskrypcji powiadomień:
SuperAdmin otrzymuje powiadomienia, wzmianki i bieżącą aktywność workspace tylko
po dodaniu go do tego workspace jako członka.

Każda operacja SuperAdmina wykonywana poza członkostwem musi mieć w audycie:

- `actor_core_user_id`,
- `actor_role = SuperAdmin`,
- `workspace_membership_required = false`,
- rodzaj operacji i dotknięty zasób.

## Model uprawnień

- `Owner` — pełne zarządzanie workspace/projektem oraz usuwanie lub archiwizacja
  zgodnie z polityką domeny.
- `Admin` — zarządzanie konfiguracją i członkami bez prawa usunięcia projektu,
  jeśli tak definiuje polityka produktu.
- `Member` — praca z zasobami zgodnie z dostępem.
- `Observer` — odczyt bez zmian.
- `SuperAdmin` — globalny dostęp administracyjny, niezależny od członkostwa.

Sprawdzaj kolejno: poprawność JWT, aktywność użytkownika, globalne prawa
SuperAdmina, członkostwo workspace, członkostwo projektu oraz uprawnienie do
konkretnej operacji.

## Dane i infrastruktura

- EF Core i migracje są źródłem zmian schematu.
- Wszystkie tabele Workspaces trafiają do `veloryn_workspaces`.
- Pamiętaj o tenant/workspace scoping w zapytaniach.
- Każdy plik ma metadane w PostgreSQL i prywatny obiekt w MinIO.
- Presigned URL jest krótkotrwały i wydawany dopiero po autoryzacji.
- Operacje zapisu powinny obsługiwać idempotencję tam, gdzie może wystąpić retry.
- Zmiany statusu, ról, dostępu, plików i danych zadania zapisuj w Activity/Audit.

## API i jakość

- API musi być wersjonowane, obecnie `/api/v1`.
- Każdy endpoint ma jawny kontrakt OpenAPI, walidację i testy.
- DTO nie mogą ujawniać encji EF Core.
- Paginacja, filtrowanie, sortowanie i wyszukiwanie odbywają się po stronie
  backendu.
- Nie zwracaj danych, do których użytkownik nie ma dostępu.
- Testuj izolację workspace’ów, SuperAdmina z członkostwem i bez członkostwa,
  MinIO, zaproszenia, powiadomienia, realtime i AI.
- Nie loguj tokenów, haseł, presigned URL-i ani prywatnych treści.
- Każdą zmianę kończ `dotnet format`, buildem, testami i sprawdzeniem migracji.

## AI

AI może zwracać propozycje, podsumowania, analizy i artefakty. Nie może
samodzielnie usuwać ani modyfikować danych bez akceptacji użytkownika.
Każda propozycja przechowuje kontekst, źródło, autora, status, wynik i audyt.
