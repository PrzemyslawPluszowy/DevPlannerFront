# R1 — manifest importów `package:ready_next`

Status: **AUDYT READ-ONLY — bez zmiany kodu produkcyjnego.**
Data pomiaru: 2026-09-17.
Repozytorium: `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`, pakiet
`devplanner` z `pubspec.yaml:1`.

Ten dokument opisuje rzeczywisty graf importów aktualnego worktree. Nie jest
zgodą na automatyczne podmienienie tekstu w całym repozytorium. Każdy import
ma zostać sprawdzony względem istniejącego pliku, kontraktu Backend oraz
odpowiedzialności warstwy. Obowiązują `AGENTS.md` i
`docs/devplanner-recovery-and-ui-plan.md`.

## 1. Jak wykonano pomiar

Użyte polecenia (odczyt plików, bez generatora i bez modyfikacji drzewa):

```bash
rg -n --glob '*.dart' "package:ready_next/" lib test
rg -o --glob '*.dart' "package:ready_next/[^'\"]+" lib test
rg -l --glob '*.dart' "package:ready_next/" lib test
```

Wynik bieżącego pomiaru:

| Zakres | Pliki zawierające import | Deklaracje importu |
|---|---:|---:|
| `lib` | 498 | 2 375 |
| `test` | 121 | 801 |
| razem | 619 | 3 176 |

Raport R00 miał snapshot **497/2 364** dla `lib` oraz **121/801** dla
`test` (`docs/recovery/R00-analyzer-baseline.md`). Różnica 11 deklaracji i
jednego pliku jest cechą współdzielonego, brudnego worktree; nie wolno jej
traktować jako dowodu regresji ani usuwać przez `restore`, `clean` lub `reset`.
Przed pierwszym pakietem importowym należy ponownie zapisać manifest ścieżek
i przyjąć jeden snapshot jako punkt odniesienia.

Wszystkie 498 produkcyjnych importerów znajdują się pod
`lib/workspaces/`; wszystkie 121 importerów testowych pod `test/workspaces/`.
Nie znaleziono importu `package:ready_next` w aktualnym `lib/app`, `lib/auth`,
`lib/foundation` ani w innych nowych korzeniach. Oznacza to, że migration
dotyczy obecnie starego drzewa Workspaces i jego testów, a nie tylko jednego
widgetu.

## 2. Dokładne grupy źródłowe i częstotliwość

### 2.1. Rodziny najwyższego poziomu

Poniższe liczby są liczbą deklaracji importu, nie liczbą plików. `files` to
liczba unikalnych importerów w danym zakresie.

| Źródłowa rodzina | `lib` occurrences / files | `test` occurrences / files | Realna granica odpowiedzialności |
|---|---:|---:|---|
| `workspaces/**` | 1 790 / 468 | 695 / 120 | domena DevPlanner; początkowo można utrzymać relatywne ścieżki, potem przenieść do `features/*` |
| `core/**` | 463 / 300 | 70 / 68 | error, transport, config, auth, theme i l10n; wymaga rozdzielenia foundation/auth |
| `shared/**` | 77 / 55 | 4 / 3 | wspólne kontrolki/presentation; nie może stać się globalnym stanem |
| `app/**` | 38 / 33 | 2 / 1 | router, overlay i panele; część ma nowe odpowiedniki, część jest brakująca |
| `l10n/**` | 5 / 5 | 29 / 29 | wygenerowane lokalizacje; nie zmieniać ręcznie generatora |
| `features/**` | 2 / 2 | 1 / 1 | pozostałość settings; sprawdzić granicę z `features/settings` |
| **razem** | **2 375 / 498** | **801 / 121** | — |

### 2.2. Pełna lista rodzin Workspaces w produkcji

To jest aktualny podział `package:ready_next/workspaces/...` po pierwszych
trzech segmentach ścieżki. Liczby są deklaracjami importu i stanowią zakres
batchy; po każdej partii trzeba je przeliczyć, bo zmiana importu usuwa wpis.

| Rodzina | Importy `lib` |
|---|---:|
| `workspaces/data/shared` | 264 |
| `workspaces/data/projects` | 253 |
| `workspaces/presentation/tasks` | 225 |
| `workspaces/domain/repositories` | 184 |
| `workspaces/presentation/storage` | 124 |
| `workspaces/data/storage` | 105 |
| `workspaces/domain/chat` | 91 |
| `workspaces/domain/models` | 82 |
| `workspaces/presentation/chat` | 69 |
| `workspaces/domain/storage` | 62 |
| `workspaces/presentation/projects` | 47 |
| `workspaces/domain/notifications` | 32 |
| `workspaces/data/workspaces` | 32 |
| `workspaces/presentation/workspaces_home` | 32 |
| `workspaces/data/realtime` | 25 |
| `workspaces/presentation/navigation` | 18 |
| `workspaces/presentation/workspaces_settings` | 16 |
| `workspaces/data/notifications` | 15 |
| `workspaces/presentation/notifications` | 14 |
| `workspaces/data/chat` | 14 |
| `workspaces/data/kanban` | 8 |
| `workspaces/data/okr` | 6 |
| `workspaces/presentation/workspace_shell` | 6 |
| `workspaces/presentation/private` | 6 |
| `workspaces/data/wiki` | 4 |
| `workspaces/data/whiteboard` | 3 |
| `workspaces/data/corkboard` | 3 |
| `workspaces/presentation/okr` | 3 |
| `workspaces/presentation/members` | 3 |
| `workspaces/domain/services` | 3 |
| `workspaces/shared/presentation` | 20 |
| `workspaces/shared/helpers` | 12 |
| `workspaces/presentation/workspaces_section.dart` | 2 |
| `workspaces/presentation/routing` | 2 |
| `workspaces/data/admin` | 2 |
| `workspaces/data/auth` | 1 |
| `workspaces/data/access_control` | 1 |
| `workspaces/presentation/sections` | 1 |

Największe źródła nie są niezależnymi pionami: `data/shared` dostarcza enumy,
DTO i wspólne odpowiedzi dla tasks/storage/workspaces, a
`domain/repositories`, `domain/models`, `domain/chat` i `domain/storage`
mają konsumentów w wielu ekranach. Dlatego nie wolno zaczynać od
`presentation/tasks` mimo jego dużej częstotliwości.

### 2.3. Pełna lista rodzin w testach

| Rodzina | Importy `test` |
|---|---:|
| `workspaces/data/shared` | 137 |
| `workspaces/domain/repositories` | 95 |
| `workspaces/data/projects` | 62 |
| `workspaces/presentation/tasks` | 58 |
| `workspaces/domain/chat` | 46 |
| `workspaces/presentation/chat` | 43 |
| `workspaces/data/storage` | 41 |
| `workspaces/presentation/storage` | 38 |
| `l10n` | 29 |
| `workspaces/domain/storage` | 28 |
| `workspaces/data/realtime` | 25 |
| `workspaces/domain/models` | 22 |
| `workspaces/domain/notifications` | 16 |
| `workspaces/presentation/notifications` | 14 |
| `workspaces/data/kanban` | 11 |
| `workspaces/data/workspaces` | 10 |
| `workspaces/data/notifications` | 10 |
| `workspaces/presentation/navigation` | 9 |
| `workspaces/data/chat` | 9 |
| `workspaces/presentation/workspaces_home` | 5 |
| `workspaces/presentation/projects` | 4 |
| `shared/presentation` | 4 |
| `core/error` | 66 |
| `core/auth` | 3 |
| `core/theme` | 1 |
| mniejsze rodziny (`app`, `features`, `workspace_shell`, `private`, `members`, `okr`, `services`, `routing`) | 15 |

Testy muszą być migrowane z produkcyjnym kontraktem tego samego batcha. Samo
przepisanie importów testu, przy pozostawieniu niezgodnego modelu lub mocka,
nie jest przejściem partii.

## 3. Zależności i odpowiedniki DevPlanner

### 3.1. Status ścieżek źródłowych

Spośród 549 unikalnych ścieżek importowanych w `lib` i `test`:

- 511 ścieżek `workspaces/**` ma obecnie plik o tej samej ścieżce pod
  `lib/workspaces/`; to **nie** oznacza poprawnego kontraktu, tylko że
  początkowe `ready_next → devplanner` może zachować fizyczną lokalizację.
- 11 ścieżek `core/**` jest obecnych; brakujące cztery to `core/auth/*`.
- 16 ścieżek `shared/**` jest obecnych; brakujący jest
  `shared/presentation/widgets/app_navigation_preference_key.dart`.
- Wszystkie siedem ścieżek `app/**` są nieobecne w dawnej lokalizacji.
- `l10n/app_localizations.dart` i dwie ścieżki `features/settings` są obecne.

Kontrolę wykonano przez porównanie unikalnych wyników `rg -o` z
`rg --files lib`; pełna lista brakujących ścieżek jest poniżej. Nie tworzyć
pustych plików tylko po to, by przejść ten test.

### 3.2. Brakujące ścieżki i realne zamienniki

| Import legacy | Status w drzewie | Realny odpowiednik/akcja | Konsumenci i ryzyko |
|---|---|---|---|
| `core/auth/auth_cubit.dart` | brak | `lib/auth/domain/ports/auth_session_port.dart` + `lib/auth/presentation/cubit/*`; nie ma bezpośredniego `AuthCubit`, trzeba zastąpić konsumentów portem sesji albo lokalnym, małym Cubitem | sześć plików presentation, m.in. `tasks_board_page.dart` i `task_permission_helper.dart`; nie używać aliasu globalnego |
| `core/auth/auth_state.dart` | brak | `lib/auth/domain/models/auth_models.dart` (`AuthSessionSnapshot`, `AuthSessionStatus`) oraz `AuthSessionPort` | te same widoki członkostwa, ustawień i uprawnień; trzeba zachować semantykę signed-out/loading/signed-in |
| `core/auth/auth_models.dart` | brak | `lib/auth/domain/models/auth_models.dart`; sprawdzić każdy używany typ, nie robić ślepego re-exportu | `test/.../chat_thread_and_discussion_ui_test.dart`; test wymaga aktualnego modelu auth |
| `core/auth/auth_repository.dart` | brak | `lib/auth/domain/ports/auth_gateway.dart`, `auth_session_port.dart` i `lib/auth/data/auth_composition.dart`; data/presentation ma dostać port, nie repozytorium z UI | chat/storage/task details; ryzyko pomieszania I/O z presentation |
| `shared/presentation/widgets/app_navigation_preference_key.dart` | brak | brak potwierdzonego odpowiednika; utworzyć typowaną preferencję w `app/shell/navigation` lub `foundation` dopiero po odczycie użycia w `workspace_shell.dart` i `workspaces_home_page.dart` | stan zwijania menu; nie zastępować losowym stringiem/globalnym stanem |
| `app/router/app_deep_link.dart` | brak | `lib/app/router/devplanner_navigation.dart` ma `goDeepLink`; trzeba zachować walidację dozwolonych ścieżek jako mały port | `notification_widgets.dart`; wymaga testu deep-link/zakaz URL zewnętrznego |
| `app/router/app_route_paths.dart` | brak | `DevPlannerRouteCatalog` w `lib/app/router/devplanner_router.dart`; router ma zostać rozdzielony od katalogu tras, nie kopiować stałych do widgetów | menu Workspaces i home content; ryzyko duplikacji tras |
| `app/router/app_router.dart` | brak | `lib/app/router/devplanner_router.dart` + `DevPlannerNavigation`; jest to zmiana API, nie rename pliku | 18 importerów presentation; placeholdery routera muszą zostać zastąpione rzeczywistymi ekranami zgodnie z `feature-parity.md` |
| `app/shell/overlay/app_modal_host.dart` | brak | `lib/foundation/presentation/devplanner_modal_host.dart`, tymczasowo; później docelowy `app/shell/overlays` z reserved topbar/focus/Escape | modale notifications/chat/storage/tasks; sprawdzić barrier i lifecycle |
| `app/shell/overlay/app_modal_picker_host.dart` | brak | `DevPlannerModalPickerHost` jest obecnie w tym samym `devplanner_modal_host.dart`; docelowo rozdzielić kontrakt pickerów od root hosta | filtry, daty, recurrence, details; nie wywoływać pickerów z cubita |
| `app/shell/panels/app_global_panels_controller.dart` | brak | `lib/foundation/presentation/devplanner_panels.dart` istnieje, ale jest przejściowy i używa `ChangeNotifier`; finalnie `app/shell/overlays` z jawnym właścicielem | test resource-chat i globalne panele; nie scalać z auth/workspace Cubitem |
| `app/shell/panels/app_global_panels_scope.dart` | brak | `DevPlannerPanelsScope` z `lib/foundation/presentation/devplanner_panels.dart`; przenieść po stabilizacji publicznego portu | `workspace_resource_pages.dart` i test global panel; sprawdzić `openResourceConversation` |

Ścieżki istniejące z tą samą lokalizacją nadal mają ryzyka:

- `core/data/api_repository.dart` jest bazą dla implementacji repository, np.
  `lib/workspaces/data/notifications/repositories/*` i
  `lib/workspaces/data/kanban/repositories/kanban_repository_impl.dart`.
  Przed rename trzeba sprawdzić, czy jego Dio i mapowanie błędu są zgodne z
  `lib/foundation/http/devplanner_http_transport.dart`; nie przenosić API do
  UI.
- `core/theme/*` (`theme.dart`, `theme_extensions.dart`, `util.dart`) ma wiele
  konsumentów, ale `lib/foundation/theme/theme.dart` jest obecnie tylko
  re-exportem. Nie uznawać tego za finalny theme z planu R5.
- `core/l10n/l10n_extensions.dart` może dostać tymczasowy import
  `package:devplanner/core/l10n/...`; teksty nadal muszą pochodzić z ARB.
- `core/config/*` i `core/network/*` wymagają porównania z
  `lib/foundation/config/*` oraz `lib/foundation/http/*`; usuwanie starego
  transportu przed migracją repository przerwie funkcje.

### 3.3. Zależności funkcjonalne

Potwierdzone źródłami kodu i raportem Backend:

```text
core/error + l10n + theme + config
        ↓
data/shared (DTO, enumy, cursor, wspólne odpowiedzi)
        ↓
domain/models + domain/repositories + domain/chat/storage/notifications
        ↓
data/workspaces/projects/tasks/kanban/storage/chat/notifications/realtime
        ↓
presentation/navigation + workspace shell/home
        ↓
presentation/projects + tasks (board/list/details)
        ↓
presentation/storage
        ↓
presentation/chat + notifications + resource chat
        ↓
app/router + app/shell/overlay + testy integracyjne
```

To jest kolejność zależności, nie lista do mechanicznego przeniesienia. Źródła
potwierdzające kontrakty to `docs/recovery/backend-contract-map.md`,
`docs/recovery/feature-parity.md` oraz C# `../Backend/Endpoints/`. W
szczególności tasks/kanban korzystają z `/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks`
i `/kanban`, storage z `StorageEndpoints.cs`, chat z `ChatEndpoints.cs`, a
notifications z `NotificationEndpoints.cs`. Import nie może zmienić tych
ścieżek ani pól `userId`.

## 4. Bezpieczna kolejność małych batchy

Każdy batch ma jednego właściciela i własny raport `docs/recovery/Rxx-report.md`.
Nie uruchamiać `build_runner` jednocześnie z batchami źródłowymi. Każdy batch
kończy się skanem importów, formatowaniem, testami dotkniętej gałęzi oraz
`git diff --check`; pełny analyzer pozostaje `FAIL` do zakończenia grafu i nie
może być „naprawiany” przez `ignore`.

### B0 — zamrożenie stanu i brakujący root

**Wejście:** backup R00, staging R01 i ten manifest; `git status` zapisany.

**Zakres:** nie zmieniać importów. Uzgodnić wersje z
`docs/recovery/file-recovery-manifest.md`, odzyskać brakujące kompozycje Chat,
Notifications, runtime, Workspaces page i trzy adaptery SignalR tylko przez
jawne porównanie stagingu. Przywrócone pliki muszą pozostać bez zależności od
Ready/Core/DataBus.

**Wyjście:** raport źródła/hashu każdego odzyskanego pliku, testy odzyskanych
kontraktów w stagingu oraz lista pozycji `partial`. Warunek niepowodzenia:
brak treści lub konflikt kontraktu — nie tworzyć placeholdera.

### B1 — foundation i lokalizacja (około 463 `core` + 77 `shared` + 5 `l10n`)

**Wejście:** B0 i potwierdzone pliki `core/error`, `core/l10n`, `core/config`,
`core/data`, `core/theme`, `shared/presentation`, `l10n`. Brakujące `core/auth`
i app router pozostają poza B1.

**Zmiana:** najpierw importy w portach/domain/data używających błędu,
transportu, configu i l10n; mapowanie do `package:devplanner/...` tylko wtedy,
gdy docelowy plik istnieje i zachowuje kontrakt. `core/theme` ma mapę
tymczasową, a nie deklarację ukończenia R5.

**Wyjście:** brak `ready_next` w wybranych plikach, wszystkie importowane ścieżki
istnieją, brak importu Dio/theme w presentation poza dopuszczonym tokenem,
targeted tests `api_error`, l10n i repository mapping. `flutter analyze` całego
repo może nadal FAIL z powodu innych rodzin; raport ma rozdzielać te błędy.

### B2 — typy współdzielone i domain (około 264 `data/shared` + 82
`domain/models` + 184 `domain/repositories` + domain chat/storage/notifications)

**Wejście:** B1; `data/shared` nie może mieć nierozwiązanych importów core.

**Zmiana:** zachować jeden model Task i jeden model Storage; przenieść później
fizycznie do `features`, ale teraz ustabilizować publiczne porty, enumy,
cursor/pagination, `userId` i mapowanie błędów. Repositories są interfejsami
domain; implementacje i HTTP pozostają w data.

**Wyjście:** targeted tests modeli, serializacji, kontraktu userId i repository
portów; żadnego `coreUserId`/`readyUserId` ukrytego aliasem; brak UI importującego
repository implementation.

### B3 — data workspace/project/tasks/kanban (około 253 `data/projects`, 32
`data/workspaces`, 8 `data/kanban` oraz reszta task-related)

**Wejście:** B2, endpointy i DTO sprawdzone w
`Backend/Endpoints/Workspaces`, `Projects`, `Tasks`, `Kanban`.

**Zmiana:** migrować API/repository implementacje małymi podrodzinami:
workspaces → projects → task operations/list configuration → kanban →
milestones/workflow/automation/capacity/time. Nie zmieniać URL tylko dlatego,
że zmieniamy package prefix.

**Wyjście:** testy repository/mapping/mutation i concurrency, brak `ready_next`
w danym poddrzewie, `flutter analyze` na zmienionych ścieżkach oraz testy
kontraktu `/tasks` i `/kanban`. Nie podłączać placeholderowego routera jako
substytutu ekranu.

### B4 — data storage i realtime (105 `data/storage`, 25 `data/realtime`)

**Wejście:** B2/B3, `StorageEndpoints.cs`, hub contract z
`backend-contract-map.md`, odzyskane adaptery SignalR z B0.

**Zmiana:** storage API, upload/download/preview/ACL/Office oraz typed realtime
ports. Desktop może używać vaultu, Web wyłącznie BFF cookie/CSRF. Nie wysyłać
tokenu w Web i nie używać `actorCoreUserId` — Backend emituje `ActorUserId`/
`UserId`.

**Wyjście:** testy ticket/progress/cancel/retry, ACL/error mapping, reconnect,
replay/dedupe/revoke oraz static scan UI bez Dio/SignalR/vault. MinIO/OnlyOffice
brak usługi oznacza `BLOCKED`, nie pusty sukces.

### B5 — navigation, workspace home, projects i shell (32 `workspaces_home`,
18 `navigation`, 16 `workspaces_settings`, 6 `workspace_shell`)

**Wejście:** B2/B3, odzyskana strona Workspaces i mapowanie brakujących router
paths/overlay. Wymagana macierz NAV-* z `feature-parity.md`.

**Zmiana:** rzeczywiste menu i tree projektu, uprawnienia i deep link przez
mały port nawigacji. Nie używać `WorkspaceStaticMenu` jako kompletnego źródła.
Nie wdrażać jeszcze hurtowo Gmail theme; root ma tylko stabilną geometrię i
reserved topbar.

**Wyjście:** widget/cubit tests expanded/collapsed/deep link, 403/empty/error,
brak `BuildContext`/router w cubitach, wszystkie importy app ścieżek mają
potwierdzony odpowiednik.

### B6 — tasks presentation (225 `presentation/tasks`)

**Wejście:** B2–B5, wspólne task snapshot/repository oraz trasy projektu.

**Zmiana:** board/list/details, inline edit, drag/drop, filters, saved views,
subtasks, recurrence, templates, time tracking i historia; dzielić pliki >400
linii według branchy. UI tylko renderuje stan i emituje intencję.

**Wyjście:** targeted cubit/repository/widget tests dla success/loading/empty/
forbidden/failure/retry/conflict oraz desktop smoke list → kanban → details.

### B7 — storage presentation (124 `presentation/storage`)

**Wejście:** B4/B5, aktywne route codecs i storage contracts.

**Zmiana:** browser/list/grid/upload/preview/sharing/office; zachować upload
progress/cancel/retry, download, foldery, ACL i file chat. Żaden ekran nie
tworzy klienta HTTP ani nie odświeża sesji.

**Wyjście:** storage shell testy, deep link, ACL/403, file persistence i ręczny
desktop smoke z działającą usługą; brak usługi raportować osobno.

### B8 — chat, notifications i globalne overlay (69 `presentation/chat`, 14
`presentation/notifications`, 14 `data/chat`, 15 `data/notifications`, 91
`domain/chat`, 32 `domain/notifications`)

**Wejście:** B2/B4/B5, prawdziwe kompozycje odzyskane w B0 oraz `ChatEndpoints.cs`
i `NotificationEndpoints.cs`.

**Zmiana:** pełna trasa i globalny prawy panel, rozmowy/wątki/załączniki/drafts/
retry/unread, inbox/read/all-read/reply/preferences, realtime i resource chat.
Jeden root overlay host pod reserved topbar; focus, Escape, barrier i powrót
fokusu.

**Wyjście:** tests global panel bez zmiany trasy/utraty edycji, dwaj lokalni
użytkownicy, live update, reconnect/replay/revoke, notification deep-link oraz
manualny desktop smoke. `unavailable`/`SizedBox.shrink()` nie jest wyjściem.

### B9 — pozostałe zasoby i testy

**Zakres:** Wiki, Whiteboard, Corkboard, OKR (`data/wiki`, `data/whiteboard`,
`data/corkboard`, `data/okr`, `presentation/okr`) oraz wszystkie testy, które
pozostały na `ready_next`.

**Wyjście:** każdy zasób ma prawdziwą trasę albo jawnie udokumentowany status
`plan`/`BLOCKED` z backendowym powodem; nie kierować go do ogólnego placeholdera.

### B10 — końcowy rename i fizyczne R4

Dopiero gdy B1–B9 przejdą kontraktowo, wykonać mapę
`lib/workspaces/* → lib/features/*` zgodnie z `file-moves.md`. Każda gałąź
przenoszona razem z testami, eksportami, generated files i composition root.
Po zakończeniu `rg -n "package:ready_next/" lib test` musi zwrócić kod 1,
`pubspec.yaml`/lock nie mogą zawierać `ready_next`, a `lib/workspaces` nie może
pozostać kontenerem całej aplikacji.

## 5. Walidacja powtarzana po każdym batchu

Minimalny skrypt kontrolny nie zapisuje plików:

```bash
# zakres zmienionego batcha należy zawęzić do jawnych katalogów
flutter analyze lib/<zmieniony-katalog> test/<zmieniony-katalog>
dart format --output=none --set-exit-if-changed lib/<zmienione-pliki> test/<zmienione-pliki>
flutter test test/<zmieniony-katalog>
rg -n --glob '*.dart' "package:ready_next/" <zmieniony-katalog>
git diff --check
```

Ostatnie `rg` musi mieć wynik pusty dla ukończonego batcha. Jeśli pełny
`flutter analyze` jest uruchamiany przed końcem B10, raport ma podać jego kod i
liczbę diagnostyk oraz odseparować kaskadę nieukończonych rodzin. Po B10
obowiązują bramki z `AGENTS.md`: `flutter pub get`, generator kontrolowany,
`flutter gen-l10n`, pełny `flutter analyze`, `flutter test`, build desktop/Web
i manualny scenariusz z `feature-parity.md`.

## 6. Blokery, których nie wolno maskować

1. **Brakujące rooty:** trzy adaptery SignalR, runtime, kompozycje Chat/
   Notifications i strona Workspaces są w stagingu R01, ale nie są jeszcze
   zintegrowane; patrz `docs/recovery/file-recovery-manifest.md`.
2. **Brak bezpośredniego auth legacy:** `core/auth/*` nie istnieje. Nowy auth
   ma `userId` UUID i porty w `lib/auth`; nie tworzyć fałszywego `AuthCubit` ani
   importować Ready/Core.
3. **Router/overlay:** siedem ścieżek app jest nieobecnych, a bieżący router
   zawiera placeholdery; mapowanie wymaga realnych tras i testu deep-link.
4. **Transport:** repository dziedziczą po `core/data/api_repository.dart`,
   więc trzeba sprawdzić zgodność z `foundation/http`, CSRF/BFF i refresh przed
   usunięciem starej nazwy.
5. **Identity/realtime:** raport Backend wskazuje `coreUserId` i różnicę pól
   huba (`ActorUserId`, `UserId`). Ślepy rename importów zostawi błąd kontraktu.
6. **Generated/l10n:** generator może nadpisać źródła lub zmienić importy;
   uruchomić dopiero w kontrolowanym batchu, po ustabilizowaniu grafu.
7. **Pion UI:** placeholder, `SizedBox.shrink`, pusty repository lub cache nie
   rozwiązuje importu. Pusty stan jest poprawny tylko po udanym odczycie API.

## 7. Kryterium odbioru i przekazanie

Manifest jest zrealizowany dopiero, gdy:

- nie ma `package:ready_next` w `lib` ani `test`, a każdy import wskazuje
  istniejący plik `devplanner` albo świadomie zaprojektowany publiczny port;
- `core/auth`, stare router paths i global panels mają jawne, przetestowane
  odpowiedniki, bez globalnych funkcji i globalnego mutowalnego stanu;
- transport/API/refresh/realtime są poza UI, cubity są lokalne dla subfeature’u,
  a widgety produkcyjne nie przekraczają 400 linii bez udokumentowanego wyjątku;
- testy importowanego pionu przechodzą, a pełny analyzer/test/build i desktopowy
  scenariusz są aktualnie uruchomione, nie odziedziczone z historycznego PASS;
- następny agent ma raport z dokładnymi ścieżkami, komendami, wynikiem,
  nierozwiązanymi blokadami i następnym batch’em.

Następny bezpieczny krok: właściciel R1 powinien zintegrować i zreviewować B0,
następnie rozpocząć B1 na jednym małym podzbiorze (`core/error` + l10n/error
repository consumers), zapisać liczby przed/po i dopiero wtedy kontynuować.
Nie wolno jednocześnie przenosić fizycznych katalogów, uruchamiać generatora i
podmieniać routera.
