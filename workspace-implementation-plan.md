# Veloryn Workspaces — kolejność wdrażania

## Cel dokumentu

Ten dokument opisuje kolejność wdrażania pełnego, produkcyjnego zakresu `veloryn-workspaces`.

Nie dzielimy produktu na MVP. Kolejne etapy opisują zależności techniczne i bezpieczną kolejność dostarczania funkcji. Każdy etap powinien być zakończony kodem produkcyjnym, testami, migracją, dokumentacją API i aktualizacją klienta Flutter, jeżeli dana funkcja tego wymaga.

Szczegółowy zakres funkcjonalny znajduje się w [workspace-implementation.md](workspace-implementation.md).

Plik jest dokumentem żywej checklisty. Nowy czat lub agent pracujący nad
Workspaces ma najpierw odczytać ten plan, zakres funkcjonalny oraz właściwy
`AGENTS.md`, a następnie kontynuować od pierwszego niezakończonego punktu.

---

## 0. Kontrola i przygotowanie Git

### Aktualny stan

- [x] Repozytorium Git istnieje.
- [x] Repozytorium ma skonfigurowany remote `origin`.
- [x] Aktywny branch: `workspace`.
- [x] Repozytorium posiada historię commitów.
- [x] Ustalono, że cała praca odbywa się wyłącznie na branchu `workspace`.
- [x] Zmiany, testy i commity wykonujemy na branchu `workspace`; nie tworzymy
  osobnych feature branchy dla tego projektu.
- [ ] Zweryfikować ochronę brancha głównego na GitHubie.
- [ ] Zweryfikować wymaganie przeglądu kodu przed merge’em.
- [ ] Zweryfikować wymagane kontrole CI przed merge’em.
- [x] Dodać i sprawdzić `.gitignore` dla Fluttera, .NET, IDE, sekretów, plików lokalnych i artefaktów builda.
- [x] Nie commitować `.env`, kluczy JWT, haseł, tokenów ani konfiguracji produkcyjnej.
- [ ] Ustalić konwencję commitów.
- [ ] Ustalić wersjonowanie backendu i kontraktów API.
- [ ] Zacommitować dokumentację planistyczną przed rozpoczęciem implementacji.
- [ ] Utworzyć osobne repozytorium dla backendu `veloryn-workspaces` albo potwierdzić docelowe repozytorium monorepo.
- [ ] Ustalić, gdzie będą przechowywane migracje, kontrakty API i dokumentacja backendu.

### Ustalone decyzje techniczne

- [x] Backend będzie osobnym folderem/projektem `veloryn-workspaces`.
- [x] Główną platformą klienta jest Flutter Web, z pełnym wsparciem desktopu.
- [ ] Zweryfikować osobno pliki, drag-and-drop, skróty klawiaturowe i menu
  kontekstowe na Web oraz desktopie.
- [x] Backend będzie używał najnowszej stabilnej, wspieranej wersji .NET zgodnej
  z aktualnym `veloryn-core` — obecnie `net10.0`.
- [x] Wszystkie zmiany wykonujemy wyłącznie na branchu `workspace`.
- [x] Lokalnie używamy Dockera; lokalną bazę można czyścić i odtwarzać.
- [x] Z produkcyjnej bazy można pobierać wyłącznie kontrolowane dane read-only,
  np. użytkowników potrzebnych do developmentu.

### Kontrakt z `veloryn-core`

- [x] Walidacja JWT odbywa się lokalnie przez RSA/JWKS Core.
- [x] JWKS: `/.well-known/jwks.json`.
- [x] Issuer i audience są zgodne z konfiguracją Core; aktualnie audience to
  `veloryn-modules`.
- [x] Workspaces wykorzystuje claimy `sub`, `unique_name`, `ready_id` oraz
  wielokrotne claimy `permission`.
- [x] SuperAdmin jest już obsługiwany po stronie `veloryn-core`/Ready przez
  istniejący mechanizm grup i praw administracyjnych. Workspaces ma odczytać
  istniejące oznaczenie z JWT, bez dodawania drugiego modelu SuperAdmina.
- [x] Potwierdzić dokładną wartość claimu/prawa, które Core przekazuje dla
  SuperAdmina: `bswfms.custom_modules.RNext-admin`; Core i Workspaces używają
  jednej jawnej stałej kontraktowej.

### Wysyłka e-maili

- [x] Nie potrzebujemy osobnego zewnętrznego serwisu e-mail.
- [x] Backend używa interfejsu `IEmailSender` i implementacji SMTP.
- [x] Lokalnie SMTP obsługuje Mailpit/MailHog.
- [ ] Produkcja otrzymuje konfigurację istniejącego serwera SMTP przez sekrety
  środowiskowe.
- [x] Wysyłka odbywa się asynchronicznie przez Outbox, z retry, idempotencją i
  historią statusu wysyłki.

### Kontrakt odpowiedzi API

Odpowiedź sukcesu `200` lub `201` zwraca bezpośrednio typ domenowy albo tablicę
typów domenowych. Nie owijamy poprawnych danych w `data`, `meta` ani komunikat.

```json
{
  "id": "...",
  "name": "Marketing"
}
```

Listy bez paginacji zwracają bezpośrednio tablicę. Dopiero endpoint wymagający
paginacji zwraca jawny, typowany kontrakt z `items` i `meta`.

Wspólny format obowiązuje wyłącznie dla błędów:

```json
{
  "code": "auth.unauthorized",
  "message": "Wymagane jest poprawne uwierzytelnienie.",
  "fields": null,
  "traceId": "..."
}
```

- `code` jest stabilnym kodem maszynowym po angielsku.
- `message` jest komunikatem po polsku przeznaczonym do wyświetlenia we
  Flutterze.
- `fields` opcjonalnie zawiera błędy walidacji według pól.
- `traceId` pozwala połączyć błąd z logami backendu.
- Nie tworzymy osobnego, niespójnego formatu dla wyjątków.
- Przed produkcją można ujednolicić istniejący format Core `{ error: ... }` do
  wspólnego kontraktu, ponieważ nie utrzymujemy starej zgodności API.

### Kryterium zakończenia

Repozytoria, branche, zasady merge’owania, CI i ochrona sekretów są ustalone. Każda zmiana może być odtworzona z historii Git.

---

## 1. Zamknięcie kontraktów architektonicznych

- [x] Potwierdzić osobny backend C# `veloryn-workspaces`.
- [x] Potwierdzić osobną bazę PostgreSQL na początku wdrożenia.
- [x] Utworzyć od początku schema `veloryn_workspaces`.
- [x] Potwierdzić późniejszą możliwość przeniesienia schematu do wspólnej bazy z `veloryn_core`.
- [x] Potwierdzić `veloryn-core` jako źródło JWT, `CoreUserId`, `ReadyUserId` i roli `SuperAdmin`.
- [x] Zdefiniować walidację JWT przez JWKS.
- [x] Zdefiniować model błędów API, paginację, filtrowanie i sortowanie.
- [x] Zdefiniować wersjonowanie API, obecnie `/api/v1`.
- [x] Zdefiniować audyt jako obowiązkowy element każdej operacji administracyjnej i zmiany uprawnień.
- [ ] Potwierdzić MinIO jako prywatny storage.
- [ ] Potwierdzić integrację z `AIFastApi` przez kontrolowany backend Workspaces.

## 2. Przygotowanie środowisk

- [x] Przygotować lokalne środowisko .NET i PostgreSQL.
- [x] Przygotować Docker Compose dla PostgreSQL i MinIO.
- [ ] Przygotować osobne konfiguracje Development, Test, Staging i Production.
- [x] Skonfigurować sekrety poza repozytorium.
- [x] Skonfigurować logowanie strukturalne i correlation ID.
- [x] Skonfigurować health checki, readiness i liveness.
- [ ] Przygotować pipeline CI: restore, build, test, lint/analyzer, migracje testowe i publikacja artefaktu.
- [ ] Przygotować pipeline CD zgodny z procesem wdrożeniowym.

## 3. Fundament backendu

- [x] Utworzyć strukturę rozwiązania C# i projektów w układzie feature-first.
- [x] Skonfigurować EF Core i migracje.
- [x] Skonfigurować schema `veloryn_workspaces`.
- [ ] Wprowadzić globalne filtrowanie tenant/workspace tam, gdzie jest wymagane.
- [ ] Utworzyć middleware autoryzacji i odczytu tożsamości z Core.
- [x] Utworzyć fundament `WorkspaceAccessService` do sprawdzania aktywnego członkostwa.
- [x] Wprowadzić role: `SuperAdmin`, `Owner`, `Admin`, `Member`, `Observer`.
- [x] Zdefiniować rozdzielenie globalnego dostępu SuperAdmina od członkostwa i powiadomień.
- [ ] Dodać wspólny model aktywności i audytu.
- [x] Dodać podstawowe testy modelu danych i mapowania tożsamości JWT.

## 4. Workspace, członkostwa i zaproszenia

### Aktualnie wdrażany pakiet — Workspace foundation

Następny pakiet obejmuje wyłącznie fundament domeny Workspace. Nie implementujemy
jeszcze projektów, zadań, plików, zaproszeń ani e-maili.

#### Zakres implementacji

- [x] Dodać typowane requesty i response’y dla Workspace.
- [x] Dodać `POST /api/v1/workspaces`.
- [x] Automatycznie utworzyć członkostwo twórcy z rolą `Owner` w tej samej transakcji.
- [x] Dodać `GET /api/v1/workspaces` z listą aktywnych workspace użytkownika.
- [x] Dodać `GET /api/v1/workspaces/{workspaceId}`.
- [x] Dodać `PATCH /api/v1/workspaces/{workspaceId}` dla nazwy, opisu, ikony i koloru.
- [x] Dodać archiwizację oraz przywracanie workspace zgodnie z uprawnieniami.
- [x] Uzupełnić `WorkspaceAccessService` o role `Owner`, `Admin`, `Member`, `Observer`.
- [x] Przygotować jawne miejsce na politykę `SuperAdmin` po potwierdzeniu claima z Core.

#### Zasady bezpieczeństwa

- [x] Każdy endpoint wymaga poprawnego JWT Core.
- [x] Dostęp do workspace jest sprawdzany w bazie, nigdy w claimach członkostwa.
- [x] Użytkownik widzi wyłącznie aktywne workspace, do których ma członkostwo.
- [x] `SuperAdmin` może uzyskać dostęp globalny po sprawdzeniu dokładnego claima Core.
- [x] Archiwizacja nie usuwa danych i nie pozwala na zwykły dostęp operacyjny.
- [x] Aktualizacje używają optimistic concurrency przez PostgreSQL `xmin`.

#### Kontrakt API i dokumentacja

- [x] Każdy endpoint ma `/api/v1`, tag `Workspaces`, opis po polsku i security Bearer.
- [x] Każdy parametr route/body ma jawny typ, walidację i opis po polsku.
- [x] Sukcesy zwracają bezpośrednie DTO, a błędy wspólny kontrakt
  `code/message/fields/traceId`.
- [x] Udokumentować odpowiedzi `200`, `201`, `400`, `401`, `403`, `404`, `409`.
- [x] Zaktualizować wygenerowany Swagger/OpenAPI przed rozpoczęciem prac Fluttera.

#### Migracje i testy

- [x] Utworzyć migrację tylko wtedy, gdy model wymaga zmiany względem aktualnego snapshotu.
- [ ] Sprawdzić migrację na pustej bazie i na bazie z istniejącymi workspace.
- [x] Dodać test utworzenia workspace i automatycznego Ownera.
- [ ] Dodać test listowania z izolacją użytkowników.
- [ ] Dodać test `Member` kontra `Admin`/`Owner`.
- [ ] Dodać test archiwizacji i przywracania.
- [ ] Dodać test optimistic concurrency.
- [ ] Dodać testy HTTP `200/201/400/401/403/404/409`.

#### Kryterium zakończenia pakietu

Pakiet uznajemy za zakończony, gdy użytkownik może utworzyć, odczytać,
zmodyfikować, zarchiwizować i przywrócić workspace, a drugi użytkownik nie może
odczytać jego danych. Wszystkie operacje muszą mieć kontrakt OpenAPI, migrację
jeżeli jest potrzebna, testy oraz wspólną obsługę błędów.

- [x] Utworzyć workspace.
- [x] Utworzyć właściciela workspace.
- [x] Obsłużyć członkostwa i role.
- [x] Obsłużyć SuperAdmina z globalnym dostępem.
- [x] Obsłużyć listę workspace’ów użytkownika.
- [x] Obsłużyć archiwizację i przywracanie workspace.
- [x] Zapraszać użytkownika po `ReadyUserId` przed jego pierwszym logowaniem do RNext.
- [x] Wysyłać e-mail z zaproszeniem wyłącznie na zweryfikowany adres lub kontrolowany sandbox.
- [x] Dokończyć mapowanie `ReadyUserId` → `CoreUserId` po pierwszym logowaniu.
- [x] Obsłużyć odrzucenie, anulowanie, ponowienie i automatyczne wygaśnięcie zaproszenia.
- [ ] Zabezpieczyć ostatniego Ownera/Admina; ochrona ostatniego Ownera jest
  wdrożona, natomiast docelowa polityka ostatniego Admina pozostaje do ustalenia.
- [x] Rejestrować wszystkie operacje w audycie.

### Osobiste preferencje listy workspace

- [x] Dodać `workspace_user_preferences` w schemacie `veloryn_workspaces`, z migracją,
  unikalnością `(workspace_id, core_user_id)` i indeksem listy użytkownika.
- [x] Dodać osobiste ukrywanie/pokazywanie i przypinanie workspace bez zmiany
  członkostwa, ról lub widoczności dla innych użytkowników.
- [x] Dodać atomowy zapis pełnej ręcznej kolejności widocznych workspace bieżącego użytkownika.
- [x] Zwracać preferencje i wykonywać filtrowanie/sortowanie listy po stronie PostgreSQL.
- [x] Dodać OpenAPI, audyt zmian preferencji oraz testy izolacji użytkowników i walidacji kolejności.

### Następny pakiet — katalog Ready, członkostwa i zaproszenia

Pakiet pozwala administratorowi workspace wyszukać aktywnego użytkownika Ready,
zaprosić go przed pierwszym logowaniem do RNext oraz bezpiecznie zarządzać
członkostwami. Nie tworzymy lokalnych kont, haseł ani kopii całego katalogu
Ready. `veloryn-core` pozostaje jedynym adapterem między Ready a Workspaces.

#### Warunek wejściowy: kontrakt katalogu z `veloryn-core`

- [x] Potwierdzono w kodzie Core, że istnieje adapter `ReadyReadDbContext` do
  `public.users`, wymuszający wyłącznie odczyt i blokujący `SaveChanges`.
- [x] Potwierdzono, że obecny `IReadyIdentityProvider` obsługuje tylko aktywnego
  użytkownika po loginie; katalog ani endpoint wyszukiwania jeszcze nie istnieją.
- [x] Wykonać kontrolowany audyt read-only rzeczywistego schematu Ready przez
  konfigurację Core: potwierdzono `e_mail`, flagi aktywności `is_del` i
  `is_del2`, oraz indeksy `usr_id`, `ent_id`, `usrnam`, bez odczytu hashów lub
  pełnego katalogu.
- [x] Rozszerzyć Core o wyszukiwanie aktywnych użytkowników Ready po loginie,
  imieniu, nazwisku i — tylko po potwierdzeniu kolumny — e-mailu.
- [x] Core udostępnia zabezpieczony service-to-service endpoint katalogu oraz
  odczytu pojedynczego użytkownika Ready po `ReadyUserId`.
- [x] Kontrakt katalogu zwraca wyłącznie minimalne dane: `ReadyUserId`, opcjonalny
  `CoreUserId`, login, nazwę wyświetlaną i zweryfikowany e-mail, jeżeli istnieje.
- [x] Core gwarantuje, że `ReadyUserId` jest stabilnym identyfikatorem; Workspaces
  nie opiera powiązania na loginie ani e-mailu.
- [x] Core definiuje bezpieczny mechanizm przekazania mapowania
  `ReadyUserId` → `CoreUserId` po pierwszym logowaniu do RNext.
- [ ] Uzgodniono uwierzytelnianie service-to-service, limity i obsługę błędów
  katalogu. Workspaces nie łączy się bezpośrednio z bazą Ready — bezpośredni
  odczyt Ready pozostaje wyłączną odpowiedzialnością Core.

#### Etap 0 — kontrolowany audyt danych Ready przez Core

- [x] Połączyć się przez konfigurację Core bez wypisywania ani kopiowania
  sekretów do terminala, logów lub dokumentacji; sesja używała wymuszonego
  `default_transaction_read_only=on` oraz `BEGIN TRANSACTION READ ONLY`.
- [x] Wykonać wyłącznie zapytania metadanych `information_schema`: potwierdzono
  `usr_id`, `usrnam`, `firnam`, `lasnam`, `e_mail`, `is_del`, `is_del2` oraz
  brak odczytu kolumny `passwd`.
- [x] Zweryfikować plan wykonania i indeksy: zapytania prefiksowe sortowane po
  loginie używają `users_usrnam_idx`; wyszukiwanie po imieniu, nazwisku i e-mailu
  pozostaje filtrem, więc wymaga limitu wyników i kontroli wydajności.
- [x] Zapisać wynik audytu jako decyzję techniczną bez danych osobowych i bez
  wartości połączenia.

#### Etap 0.1 — katalog użytkowników w Core

- [x] Dodać do `IReadyIdentityProvider` typowane zapytanie `SearchActiveUsers`
  oraz odczyt aktywnego użytkownika po `ReadyUserId`.
- [x] Zastosować `AsNoTracking`, projekcję minimalnego DTO, limit maksymalnie 20
  wyników, minimalną długość frazy, stabilne sortowanie i parametryzowane LINQ.
- [x] Pierwszą wersję wyszukiwania ograniczyć do prefiksu loginu albo jawnie
  zmierzyć obciążenie filtrowania po imieniu, nazwisku i `e_mail`; nie dodawać
  indeksów ani innych obiektów do produkcyjnej bazy Ready z Workspaces.
- [x] Traktować `e_mail` wyłącznie jako dane pomocnicze — audyt nie potwierdził
  flagi weryfikacji adresu, więc wysyłka e-mail wymaga osobnej polityki Core.
- [x] Nigdy nie wystawiać `PasswordHash`, tokenów Ready, grup ani pełnych danych
  z tabeli `public.users`.
- [x] Dodać wewnętrzny endpoint Core: wyszukiwanie z krótką frazą oraz odczyt
  jednego aktywnego użytkownika po `ReadyUserId`.
- [x] Zabezpieczyć endpoint uwierzytelnianiem service-to-service i zakresem
  tylko do odczytu katalogu; nie opierać dostępu na danych przesłanych przez UI.
- [ ] Dodać timeout, limit żądań, audyt wywołania bez logowania frazy lub PII oraz
  bezpieczne odpowiedzi `400/401/403/404/429/503`. Timeout i odpowiedzi są
  wdrożone, podobnie jak limit 30 żądań/minutę; trwały audyt pozostaje otwarty.

#### Etap 0.2 — integracja katalogu w Workspaces

- [x] Dodać typowany klient HTTP Core z konfiguracją przez sekrety środowiskowe,
  timeoutem, `CancellationToken` i kontraktami niezależnymi od DTO Core.
- [x] Udostępnić `GET /api/v1/workspaces/{workspaceId}/users/search?query=...` wyłącznie dla
  `Admin`/`Owner`; endpoint przekazuje minimalne wyniki z Core i nie zapisuje
  katalogu Ready lokalnie.
- [x] Przed utworzeniem zaproszenia Workspaces ponownie weryfikuje wskazany
  `ReadyUserId` w Core, zamiast ufać loginowi, e-mailowi lub nazwie z klienta.

#### Etap A — model domeny i migracja Workspaces

- [x] Rozszerzyć `WorkspaceMembership` o opcjonalny, stabilny `ReadyUserId`
  obok istniejącego `CoreUserId`, zachowując historię przez `RevokedAtUtc`.
  Pole pozostaje opcjonalne do czasu bezpiecznego backfillu istniejących danych.
- [x] Dodać `WorkspaceInvitation` z `ReadyUserId`, opcjonalnym `CoreUserId`,
  pomocniczymi danymi wyświetlania, rolą, statusem, wiadomością, terminem
  ważności i metadanymi audytowymi.
- [x] Wprowadzić jawny enum statusów zaproszenia: `Pending`, `Accepted`,
  `Declined`, `Cancelled`, `Expired`.
- [x] Dodać indeksy oraz ograniczenia: jedno aktywne członkostwo i jedno aktywne
  zaproszenie dla pary `workspace_id` + `ready_user_id`.
- [x] Wygenerować migrację wyłącznie dla schematu `veloryn_workspaces` i
  zastosować ją na istniejącej lokalnej bazie.

#### Etap B — członkostwa i reguły dostępu

- [x] Udostępnić listę członków workspace dla roli co najmniej `Member`.
- [x] Udostępnić zmianę roli i usunięcie członka wyłącznie dla `Admin`/`Owner`,
  zgodnie z ustaloną macierzą uprawnień.
- [x] Udostępnić opuszczenie workspace przez bieżącego użytkownika.
- [x] Zablokować usunięcie, opuszczenie lub obniżenie roli ostatniego `Ownera`;
  ochrona ostatniego `Admina` zostanie zastosowana zgodnie z końcową polityką
  ról w specyfikacji.
- [x] Przenieść wszystkie decyzje uprawnień do `WorkspaceAccessService` lub
  dedykowanej reguły domenowej, bez duplikacji w endpointach.

#### Etap C — zaproszenia i integracja katalogu Core

- [x] Dodać adapter `veloryn-core` dla wyszukiwania użytkowników Ready, z
  timeoutem, anulowaniem, typowanym kontraktem i bez logowania danych wrażliwych.
- [x] Udostępnić administratorowi `GET /api/v1/workspaces/{workspaceId}/users/search` oraz
  `POST /api/v1/workspaces/{workspaceId}/invitations`; request zaproszenia
  przyjmuje `ReadyUserId`, rolę i opcjonalną wiadomość, nigdy e-mail jako klucz.
- [x] Zapisać zaproszenie; jego utworzenie nie daje dostępu do
  workspace.
- [x] Udostępnić listę wysłanych i otrzymanych zaproszeń oraz endpoint akceptacji.
- [x] Udostępnić endpointy anulowania i odrzucenia.
- [x] Obsłużyć akceptację, odrzucenie, anulowanie, ponowienie i wygaśnięcie.
- [x] Akceptacja tworzy w jednej transakcji członkostwo i
  zamknąć zaproszenie; ponowna akceptacja ma być bezpieczna.
- [x] Po pierwszym logowaniu powiązać zaproszenie i członkostwo przez
  stabilne `ReadyUserId` z `CoreUserId`, bez przyznawania dostępu przed akceptacją.

#### Etap D — e-mail, outbox i audyt

- [x] Dodać `IEmailSender` z implementacją SMTP oraz konfiguracją wyłącznie przez
  sekrety środowiskowe. Produkcyjna wysyłka jest domyślnie wyłączona.
- [x] Dodać transactional outbox dla e-maili zaproszeń: deduplikacja po
  zaproszeniu, retry, status wysyłki i historia błędów.
- [x] Dodać responsywny szablon HTML zaproszenia wraz z tekstowym fallbackiem,
  kodowaniem danych użytkownika oraz bez linku/tokenu dostępu w wiadomości.
- [x] Dodać sterowanie SMTP przez środowisko: pełne wyłączenie oraz sandbox,
  który przekierowuje wszystkie wiadomości na jeden adres testowy i jest
  blokowany w środowisku Production.
- [x] Wysyłać e-mail tylko na zweryfikowany adres zwrócony przez Core/Ready.
  Adres bez potwierdzenia jest bezpiecznie pomijany, poza świadomie ustawionym
  lokalnym sandboxem.
- [x] Rejestrować audyt utworzenia, zmiany, anulowania i akceptacji zaproszenia
  oraz zmian członkostw, z oznaczeniem wykonawcy.

#### Kontrakt API, testy i kryterium odbioru

- [x] Każdy endpoint Workspaces otrzymuje `/api/v1`, tag, opis i parametry OpenAPI po polsku,
  Bearer security, bezpośrednie DTO dla sukcesu oraz kontrakt błędu
  `code/message/fields/traceId`.
- [x] Dodać test integracyjny atomowej akceptacji zaproszenia; osobne testy
  migracji i ograniczeń unikalności pozostają do dodania.
- [ ] Dodać testy HTTP dla ról `Owner`, `Admin`, `Member`, `Observer` oraz
  odpowiedzi `400/401/403/404/409`.
- [x] Dodać test HTTP macierzy `Owner`/`Admin`/`Member`/`Observer` dla operacji
  administracyjnej workspace oraz test adaptera Core dla kontraktu, błędów i timeoutu.
- [x] Dodać test równoległej akceptacji jednego zaproszenia, potwierdzający
  utworzenie dokładnie jednego członkostwa.
- [ ] Dodać testy wyścigów: podwójna akceptacja, równoległe zaproszenie i próba
  odebrania ostatniego Ownera.
- [ ] Dodać test adaptera Core dla poprawnej odpowiedzi, timeoutu, błędu
  autoryzacji i nieaktywnego użytkownika.
- [ ] Dodać test Core, że wyszukiwanie nie zwraca usuniętych kont, hashów haseł
  ani wyników ponad limit, a zapytanie ma plan używający właściwych indeksów.
- [ ] Pakiet jest gotowy, gdy można zaprosić aktywnego użytkownika Ready przed
  jego pierwszym logowaniem, po zalogowaniu bezpiecznie zmapować tożsamość i
  zaakceptować zaproszenie bez naruszenia izolacji workspace.

## 5. Projekty i widoczność

- [x] Utworzyć projekt.
- [x] Obsłużyć projekty wspólne i prywatne.
- [x] Obsłużyć członkostwa projektów.
- [x] Dodać Ownera, Admina, Membera i Observera projektu zgodnie z modelem uprawnień.
- [x] Dodać kolor i ikonę projektu.
- [x] Dodać archiwizację, przywracanie i usuwanie zgodnie z uprawnieniami.
- [x] Dodać osobiste ukrywanie, pokazywanie, przypinanie i sortowanie projektów.
- [x] Dodać presety projektów.

### Decyzje wdrożone dla Projects

- Przy utworzeniu projektu `Private` jawne członkostwo otrzymuje wyłącznie
  twórca jako `Owner`; projekt `Shared` dziedziczy odczyt z aktywnego
  członkostwa workspace bez masowego tworzenia członkostw projektu.
- `Private` jest strict: projekt widzą i nim zarządzają wyłącznie aktywni
  członkowie projektu; globalny wyjątek stanowi wyłącznie `SuperAdmin`.
- `Shared` dziedziczy odczyt z workspace, ale cofnięte członkostwo projektu
  pozostaje skuteczne także po ponownym dołączeniu użytkownika do workspace.
- Cofnięcie członkostwa wysyła prywatne powiadomienie wyłącznie odebranemu
  użytkownikowi, a dla pozostałych członków zapisuje neutralną aktywność.

## 6. Zadania i konfiguracja projektu

Stan po audycie i poprawkach backendu z 2026-08-17. Checkbox oznacza funkcję
zweryfikowaną w kodzie oraz odpowiednich testach HTTP/PostgreSQL/SignalR.

- [x] Utworzyć zadania główne.
- [x] Utworzyć podzadania z ograniczeniem do jednego poziomu.
- [x] Dodać pola systemowe zadania.
- [x] Dodać głównego wykonawcę, współpracowników i obserwatorów.
- [x] Dodać statusy, workflow, priorytety, rozmiar, złożoność, ryzyko i ważność biznesową.
- [x] Dodać checklisty, kryteria akceptacji i etykiety.
- [x] Dodać terminy i zależności z kontrolą cykli dla relacji blokujących.
- [x] Dodać podstawowe pola niestandardowe: tekst, liczba, data, boolean, użytkownik, single-select i multi-select.
- [ ] Dodać konfigurację widoczności, wymagań przed przejściem statusu, kolejności i uprawnień pól.
- [x] Zapisywać kompletną historię każdego zadania, również zmian obserwatorów, etykiet, custom fields i kryteriów akceptacji.
- [x] Dodać archiwizację i przywracanie zadań.
- [x] Dodać cursor pagination, filtrowanie i wyszukiwanie po stronie backendu.
- [ ] Dodać wybieralne sortowanie i grupowanie po statusie, osobie, terminie oraz custom fields.
- [x] Domknąć optimistic concurrency dla każdej mutacji zadania, nie tylko pełnej edycji.
- [x] Domknąć bezpieczny realtime: Observer może subskrybować odczyt, a odebranie członkostwa natychmiast usuwa aktywne subskrypcje.
- [x] Dodać historię zdarzeń/reconnect cursor dla kanału Tasks oraz kontrakt deduplikacji `event_id` po stronie klienta.
- [x] Dodać rich text opisu jako Quill Delta JSON wraz z tekstem do wyszukiwania; obrazy i załączniki pozostają zależne od modułu Files.
- [x] Wdrożyć formatki zadań (Task Templates) z obsługą wielu formatek w workspace, dokładnie jednej osobistej formatki domyślnej per użytkownik, tworzeniem od zera oraz endpointem szybkiego tworzenia (`quick-create`) aplikującym formatkę z zachowaniem podanego tytułu i placementu.

## 7. Widoki pracy

- [ ] Lista zadań z paginacją i infinite scroll we Flutterze.
- [ ] Kanban jako widok zadań pogrupowanych po statusach.
- [ ] Kalendarz zadań.
- [ ] Timeline projektu.
- [ ] Dashboard projektu z konfigurowalnymi widgetami.
- [ ] `My Tasks` i widok zadań użytkownika.
- [ ] Globalne wyszukiwanie z respektowaniem uprawnień.

## 8. Whiteboard

- [ ] Utworzyć whiteboard projektu lub workspace’u.
- [ ] Dodać płótno z przesuwaniem i powiększaniem.
- [ ] Dodać StickyNote, tekst, kształty, strzałki i grupy.
- [ ] Dodać referencje do zadań i plików.
- [ ] Dodać konwersję StickyNote do zadania.
- [ ] Zintegrować kanał Chat/Messaging i załączniki z elementami whiteboardu.
- [ ] Dodać presety whiteboardów.
- [ ] Dodać realtime/WebSocket.
- [ ] Dodać historię zmian whiteboardu.

## 9. Pliki, Uniwersalny Storage Engine i OnlyOffice

Szczegółowy audyt istniejącego backendu oraz plan wykonawczy Fluttera znajduje
się w [docs/workspaces-files-implementation-plan.md](docs/workspaces-files-implementation-plan.md).
Stan checkboxów poniżej jest historyczny i wymaga osobnej aktualizacji na
podstawie kontraktu OpenAPI; kod backendu realizuje już większość tej sekcji.

- [x] Utworzyć prywatny bucket MinIO oraz konfigurację klienta S3 w backendzie `veloryn-workspaces`.
- [x] Zapisać metadane plików w schemacie `veloryn_workspaces` w uniwersalnym modelu wspierającym wiele modułów (`Module`, `ResourceType`/`EntityType`, `ResourceId`/`EntityId`).
- [x] Obsłużyć pliki użytkownika, workspace’u, projektów, zadań, wiadomości Chat oraz modułów zewnętrznych (Inwentaryzacja, BHP, IQC).
- [x] Wymuszać kontrolę JWT Core i dynamiczną autoryzację zasobów przed każdym dostępem.
- [x] Wydawać krótkotrwałe presigned URL-e (`PUT` dla uploadu, `GET` dla pobierania).
- [ ] Dodać resumable chunked upload dla dużych plików; zwykły upload i konfigurowalne limity już działają.
- [x] Dodać wersjonowanie plików (`v1`, `v2`...), kosz z 30-dniową retencją, przywracanie oraz pełny audyt operacji i pobrań.
- [x] Dodać integrację z **OnlyOffice Document Server** (Docker) dla współdzielonej edycji `DOCX`, `XLSX`, `PPTX` oraz podglądu i formularzy `PDF`.
- [x] Wdrożyć asynchroniczną optymalizację zdjęć: generowanie miniaturek (`thumb`, `preview`, `full`), konwersję do WebP/AVIF oraz czyszczenie wrażliwych metadanych EXIF.
- [x] Wdrożyć asynchroniczne przetwarzanie i streaming wideo (FFmpeg): kompresję do MP4 `faststart`, obsługę HTTP Byte-Range (`206 Partial Content`), opcjonalny adaptacyjny HLS (`.m3u8`), plakat wideo (poster frame) i ekstrakcję metadanych.
- [x] Dodać dodawanie, listowanie, pobieranie i usuwanie załączników w Zadaniach (`ProjectTask`).
- [x] Dodać opcjonalne awatary użytkowników (`user_avatar`) z automatycznym skalowaniem do WebP (150x150 / 64x64).
- [x] Zintegrować edytor **Flutter Quill** z uploadem i osadzaniem obrazów/załączników w Quill Delta JSON (z podglądem lightbox i weryfikacją uprawnień).
- [x] Dodać deduplikację zawartości (SHA-256 Content-Addressable Storage).
- [ ] Dodać limit pobrań do linków zewnętrznych; hasło i data ważności już działają.

## 10. Chat/Messaging, aktywność i powiadomienia

Pełny audyt roota UI, kolejność naprawy globalnej belki i warstw modalnych oraz
plan wykonawczy klienta Chat, Notifications i Resource Chat plików znajduje się
w [docs/global-shell-chat-notifications-implementation-plan-2026-09-13.md](docs/global-shell-chat-notifications-implementation-plan-2026-09-13.md).

Naprawa globalnego shellu i kontraktu `Overlay` jest bramką wejściową przed
rozwojem docelowego panelu Chat.

### Fundament Notifications w Workspaces

- [x] Utworzyć trwałą skrzynkę in-app, event outbox i wersjonowany kontrakt zdarzeń.
- [x] Dodać retencję, archiwizację, deduplikację `eventId` oraz limit payloadu.
- [x] Dodać cursor pagination, licznik nieprzeczytanych i status przeczytania.
- [x] Emitować zdarzenia zaproszeń i zmian członkostwa Workspaces.
- [x] Dodać JWT-protected WebSocket/SignalR, reconnect i odtworzenie zdarzeń przez API.
- [x] Zachować możliwość wydzielenia wspólnego Notification Service dla innych modułów.
- [x] Umożliwić SuperAdminowi wysłanie ręcznego komunikatu z opcjonalnym, bezpiecznym deepLinkiem Fluttera.

- [ ] Wdrożyć jeden niezależny moduł Chat/Messaging dla rozmów globalnych oraz
  automatycznych kanałów workspace/project/task; pełny zakres opisuje
  `veloryn-workspaces/docs/chat-messaging-implementation-plan.md`.
- [ ] Dodać plain/rich text, Quill Delta opcjonalnie, kod, obrazy, załączniki,
  linki, odpowiedzi, reakcje, wzmianki i wyszukiwanie.
- [x] Etap 7A: dodać lokalny, typowany fundament wyboru załączników Chat z
  limitami 20 plików / 50 MiB na plik / 100 MiB na wiadomość, maszyną stanów
  bezpieczeństwa i fail-closed revoke; upload i powiązanie z wiadomością czekają
  na jawny kontrakt backendu.
- [x] Etap 7E-B: dodać niezależną od UI kolejkę wielu załączników nad ownerami
  uploadu: przyjmuje wyłącznie zaakceptowany snapshot 7A, zachowuje kolejność
  wyboru mimo równoległego uploadu, ujawnia UUID tylko po pełnym `Clean+Ready`
  oraz anulowuje wszystkie sesje przy błędzie, revoke i zamknięciu.
- [x] Etap 7E-C: dodać ownera composera, który łączy selection 7A z kolejką
  7E-B i wpisuje do draftu wyłącznie pełny, uporządkowany snapshot `Ready`;
  sukces send konsumuje sesje jednokrotnie, retry zachowuje UUID, a revoke
  czyści sesje oraz identyfikatory draftu.
- [x] Etap 7E-D: wstrzyknąć port uploadu Chat przez composition root oraz
  połączyć coordinator composera z osobnym potwierdzeniem create-message;
  event zawiera `clientMessageId` i uporządkowane `attachmentFileIds`, nie
  występuje przy optimistic enqueue ani failure i uruchamia consumption tylko
  po zaakceptowanej odpowiedzi backendu.
- [x] Etap 7E-E: dodać do composera picker przez `FilePickerPort`, DropTarget,
  chipy statusu i usuwanie z cleanupem; wybór jest blokowany podczas oczekiwania
  na confirmation, a send podczas przygotowania/błędu/awaiting.
- [ ] Dodać członkostwa, grupowanie rozmów, awatary, presence online/offline,
  mute/pin/archive oraz read states.
- [ ] Dodać historię zmian, optimistic concurrency, idempotentne wysyłanie,
  cursor pagination i bezpieczne usuwanie.
- [ ] Zintegrować Chat ze Storage, istniejącym Notifications/outbox i SignalR;
  nie tworzyć równoległego systemu powiadomień.
- [ ] Dodać konfigurowalne skracanie kontekstu bez usuwania źródłowej historii.
- [x] Powiadamiać tylko użytkowników mających dostęp do danego obiektu.
- [x] Nie wysyłać SuperAdminowi powiadomień workspace, jeśli nie jest jego członkiem.
- [ ] Dodać produkcyjne testy REST/PostgreSQL/SignalR, bezpieczeństwa,
  concurrency, reconnect, search, Storage i grupowania powiadomień.

## 11. Dokumentacja i Wiki

- [ ] Utworzyć dokumenty, strony i podstrony.
- [ ] Dodać rich text, tabele, kod, linki i załączniki.
- [ ] Dodać wersjonowanie i przywracanie.
- [ ] Dodać wzmianki i linkowanie zadań.
- [ ] Dodać uprawnienia dokumentów.
- [ ] Dodać wyszukiwanie w Wiki.

## 12. Dashboardy, raporty i eksport

- [ ] Dodać widgety dashboardów użytkownika, projektu i workspace’u.
- [ ] Dodać raporty statusu, priorytetów, opóźnień i aktywności.
- [ ] Dodać podsumowania tygodniowe projektów.
- [ ] Dodać eksport zadań, plików, dokumentów i historii.
- [ ] Dodać pełny eksport workspace’u.

## 13. AI przez `AIFastApi`

- [ ] Zabezpieczyć komunikację Workspaces → AIFastApi.
- [ ] Przekazywać wyłącznie dane dostępne dla aktualnego użytkownika.
- [ ] Dodać pomoc przy tworzeniu i formatowaniu zadania.
- [ ] Dodać generowanie checklist, kryteriów i jednopoziomowych podzadań.
- [ ] Dodać podsumowania zadań i projektów.
- [ ] Dodać wykrywanie ryzyk, blokad i duplikatów.
- [ ] Dodać analizę dokumentów, plików, komentarzy i Wiki.
- [ ] Dodać analizę whiteboardów.
- [ ] Dodać generowanie wykresów i obrazów.
- [ ] Dodać transkrypcję audio i tworzenie propozycji zadań.
- [ ] Zapisywać propozycje AI z możliwością akceptacji/odrzucenia.
- [ ] Nie wykonywać destrukcyjnych zmian bez potwierdzenia użytkownika.
- [ ] Rejestrować źródło, kontekst, użytkownika i wynik każdej operacji AI.

## 14. Jakość i gotowość produkcyjna

- [ ] Testy jednostkowe domeny i uprawnień.
- [ ] Testy integracyjne PostgreSQL, MinIO i `veloryn-core`.
- [ ] Testy kontraktowe API i Fluttera.
- [ ] Testy izolacji workspace’ów.
- [ ] Testy SuperAdmina z członkostwem i bez członkostwa.
- [ ] Testy powiadomień z uwzględnieniem członkostwa SuperAdmina.
- [ ] Testy uploadu, pobierania i odebrania dostępu do plików.
- [ ] Testy paginacji i dużej liczby zadań.
- [ ] Testy WebSocketów i ponownego połączenia.
- [ ] Testy migracji na pustej i istniejącej bazie.
- [ ] Testy bezpieczeństwa i rate limiting.
- [ ] Dokumentacja OpenAPI i scenariuszy użytkownika.
- [ ] Monitoring, alerty, backupy i procedura odtworzenia.
- [ ] Test wdrożenia na stagingu.
- [ ] Odbiór produkcyjny całego zakresu opisanego w `workspace-implementation.md`.

## Zasada dodawania kolejnych funkcji

Każda nowa funkcja musi przejść tę samą ścieżkę:

1. opis funkcjonalny i wpływ na istniejące moduły,
2. decyzja o uprawnieniach i widoczności,
3. model danych oraz migracja,
4. kontrakt API,
5. implementacja backendu,
6. testy backendu i bezpieczeństwa,
7. implementacja Fluttera,
8. testy UI i integracyjne,
9. dokumentacja,
10. obserwowalne wdrożenie na stagingu,
11. wdrożenie produkcyjne,
12. aktualizacja tej checklisty.
