# R00 — baseline analizatora i grafu zależności

Status: **FAIL — stan wejściowy do odzyskiwania, nie dowód ukończenia pakietu.**  
Data audytu: 2026-09-17  
Zakres: wyłącznie odczyt kodu i uruchomienie analizatora; nie zmieniono kodu
aplikacji, generatorów ani plików platformowych.

## Stan badany

- Repozytorium: `Front`, branch `main`, commit bazowy
  `d1cc273401fd6db253ca18e54124ad767d4b2622`.
- Drzewo robocze było już rozlegle zmienione przed audytem: `git diff --stat`
  raportuje 698 plików, 2 018 dodanych i 104 076 usuniętych linii. Wśród zmian
  są zarówno pliki śledzone, jak i nowe, nieśledzone gałęzie `app`, `auth`,
  `foundation`, `admin`, `me` i `data/standalone`. Ten raport nie przypisuje
  ich autorstwa ani nie dokonuje restore/clean.
- Surowy pełny wynik polecenia zapisano lokalnie poza repozytorium jako
  `/tmp/devplanner-r00-flutter-analyze.txt` (7 501 012 B, 30 201 linii), aby
  nie dodawać wielomegabajtowego artefaktu do Gita.

## Wykonana bramka

```text
flutter analyze > /tmp/devplanner-r00-flutter-analyze.txt 2>&1
```

Wynik: exit code `1`, czas analizatora `18.4 s`, **30 195** diagnostyk.

| Poziom | Liczba |
|---|---:|
| error | 23 329 |
| warning | 2 345 |
| info | 4 521 |
| razem | 30 195 |

Najczęstsze reguły: `undefined_identifier` 4 715,
`non_type_as_type_argument` 4 439, `uri_does_not_exist` 3 179,
`depend_on_referenced_packages` 3 168, `undefined_class` 3 012,
`undefined_getter` 2 320 i `undefined_method` 1 572. Te liczby nie są liczbą
niezależnych usterek funkcjonalnych.

## Klasyfikacja przyczyn

### P0 — rozłączony graf importów Workspaces (pierwotne)

`pubspec.yaml` nazywa pakiet `devplanner`, ale w `lib/workspaces` nadal jest
497 plików z importem `package:ready_next/...`; w całym źródle jest ich tyle
samo. Testy mają dalsze 121 plików. Bezpośrednich deklaracji importu jest
odpowiednio 2 364 w `lib` i 801 w `test`.

To wyjaśnia co najmniej 3 168 informacji
`depend_on_referenced_packages` oraz zasadniczą część 3 179 błędów
`uri_does_not_exist`. Kolejne `undefined_*`, `non_type_*`, błędy `const`,
nullable i inferencji w importerach są w większości **kaskadowe**, dopóki
importowany typ nie zostanie ponownie rozpoznany. Nie należy ich naprawiać
pojedynczo ani dodawać zależności `ready_next` do `pubspec.yaml`: byłoby to
odtworzenie zabronionego legacy zamiast migracji do standalone `devplanner`.

Rozkład 497 importerów legacy w produkcyjnym Workspaces:

| Warstwa | Pliki z importem `ready_next` |
|---|---:|
| presentation | 302 |
| data | 125 |
| domain | 66 |
| shared | 4 |

W diagnostykach największe obszary to presentation Workspaces (17 101), testy
Workspaces (8 136), data Workspaces (3 726) i domain Workspaces (1 051).
To jest graf zależności od dołu do góry, a nie kolejność do mechanicznej
zamiany plików.

### P0 — brakujące węzły nowego rootu (pierwotne)

Brakuje poniższych plików wymaganych przez aktywny root/router/runtime:

| Brakujący plik | Bezpośredni konsumenci | Skutek |
|---|---|---|
| `lib/workspaces/presentation/chat/global_chat_composition.dart` | `app/devplanner_app.dart`, `app/router/devplanner_router.dart`, standalone runtime, test app | brak typowanej kompozycji chatu i kaskada błędów tras/panelu |
| `lib/workspaces/presentation/notifications/global_notifications_composition.dart` | analogiczne root/router/runtime/testy | brak kompozycji powiadomień |
| `lib/workspaces/presentation/devplanner_workspaces_page.dart` | router i test app | brak realnego wejścia `/workspaces` |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client.dart` | wymagany przez plan R1, obecnie nieobecny | brak odzyskanego klienta Web BFF SignalR |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client_stub.dart` | jw. | brak bezpiecznego adaptera platformowego |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client_web.dart` | jw. | brak implementacji webowej |

Wszystkie powyższe pliki są nieobecne także w `HEAD`, więc nie można udawać,
że zwykłe cofnięcie bieżącego worktree je odzyska. `devplanner_standalone_runtime.dart`
jest obecny, ale nie jest samodzielnym dowodem poprawności: importuje dwie
brakujące kompozycje i dlatego jego kontrakt nie może się skompilować.

### P0 — root/router ma brakujące definicje i placeholdery (pierwotne)

Graf wejściowy wygląda obecnie tak:

```text
main.dart
  -> bootstrap/app_bootstrap.dart
    -> app/devplanner_app.dart
      -> app/router/devplanner_router.dart
      -> standalone runtime
           -> [brak chat composition]
           -> [brak notifications composition]
      -> [brak chat/notifications composition]
router
  -> [brak DevPlannerWorkspacesPage]
  -> 10 tras z nieistniejącym DevPlannerRoutePlaceholderPage
  -> nieistniejące unavailable/placeholder pages i tytuły
  -> stare sygnatury Chat/Notifications pages
```

`devplanner_router.dart` odwołuje się do 10 tras przez
`DevPlannerRoutePlaceholderPage`, a także do nieistniejących
`DevPlannerPlaceholderPage`, `DevPlannerChatUnavailablePage` i
`DevPlannerNotificationsUnavailablePage`. To nie jest poprawna strategia
parity: plan R2/R6 wymaga podłączenia rzeczywistych ekranów i zachowania
stabilnych adresów, nie utrwalania placeholderów.

### P1 — rzeczywiste rozbieżności kontraktów po odblokowaniu importów

W produkcyjnym `lib` jest 1 810 wierszy z nazwami `coreUserId`, `readyUserId`,
`authorCoreUserId` lub `attachedByCoreUserId`; w testach jest ich dalsze 156.
Są to ślady kontraktów przed lokalnym UUID `userId`. Część dzisiejszych błędów
typów może być kaskadą importów, lecz migracja tych pól pozostaje osobnym,
rzeczywistym zadaniem po przywróceniu grafu. Nie wolno tego ukrywać aliasem,
dual-read/write ani fallbackiem Ready/Core.

`current_user_avatar_cubit.dart` ma już widoczne błędy typów (`Object?` zamiast
`ApiError`, niedostępne `id`/`downloadUrl`). Zależności Storage, które importuje,
są nadal rozłączone; klasyfikacja tego miejsca jest więc **P1 do ponownego
sprawdzenia po P0**, a nie kandydat do lokalnego obejścia `dynamic`.

### P1 — foundation/theme nie spełnia docelowej granicy

Jedyny bieżący plik `lib/foundation/theme/theme.dart` jest przejściowym
re-exportem `lib/core/theme/*`. Jest to sprzeczne z docelową regułą R5
(niezależny `foundation/theme`, dwa motywy, tokens i brak zależności od starego
`core/theme`). Nie jest główną przyczyną 30 tys. diagnostyk, ale jest blokadą
architektoniczną shella Gmail-inspired i należy ją rozwiązać po odzyskaniu
kompilowalnego rootu, bez masowego regexu kolorów.

### P1 — przekroczona granica odpowiedzialności plików

Po wyłączeniu artefaktów generatora i l10n jest 58 plików produkcyjnych oraz
16 testowych powyżej 400 linii. Krytyczne przykłady: board template actions
(2 112), `ProjectTasksListCubit` (1 621), `TasksBoardCubit` (1 264), router
(467), board header (1 484), modal ustawień projektu (1 150) i szczegóły zadania
(1 041). Widgety i Cubity trzeba dzielić przy przenoszeniu pionów według
odpowiedzialności; nie wolno tworzyć god Cubitów ani przenosić I/O do UI.
Wygenerowane `*.g.dart`, `*.freezed.dart` i l10n są wyjątkiem od tej metryki.

## Priorytetowana kolejność naprawy

1. **R1, właściciel recovery/root:** odtworzyć i udokumentować pięć brakujących
   plików z listy R1 (dwie kompozycje i trzy adaptery SignalR), osobno
   zrekonstruować brakujący ekran wejściowy Workspaces oraz ich testy z
   dostępnych patchy/historii. Potwierdzić źródło każdego pliku. Nie uruchamiać
   jeszcze masowego generatora.
2. **R1/R2, właściciel grafu Workspaces:** metodycznie przeprowadzić importy
   `ready_next` do istniejących `devplanner` ścieżek warstwa po warstwie,
   zaczynając od shared/domain/data. Każdy import trzeba potwierdzić jako
   istniejący plik i poprawny kontrakt, nie tylko zmienić prefiks.
3. **R2, właściciel root/router:** po odzyskaniu kompozycji połączyć
   `main → bootstrap → DevPlannerApp → router → workspace/chat/notifications`
   z rzeczywistymi ekranami. Zastąpić wszystkie 10 placeholderów aktualnymi
   ekranami albo jawnymi, zachowującymi semantykę redirectami wyłącznie tam,
   gdzie istnieje potwierdzony odpowiednik.
4. **R2, kontrakty:** zaktualizować pozostałe modele i testy do lokalnego
   `userId` na podstawie OpenAPI/backendu; po usunięciu P0 rozdzielić prawdziwe
   błędy typów od kaskady i naprawiać je pionami (spaces/projects, tasks,
   storage, chat/notifications, pozostałe zasoby).
5. **Po stabilnym grafie:** wykonać `dart run build_runner build
   --delete-conflicting-outputs` wyłącznie w pojedynczym, kontrolowanym pakiecie,
   sprawdzić diff wygenerowanych plików, potem `flutter gen-l10n`, analyze i
   targeted tests. Generator nie może działać równolegle z odzyskiwaniem albo
   przenoszeniem plików.
6. **R4–R7:** dopiero po kompilowalnym i połączonym produkcie przenosić gałęzie
   do drzewa feature/subfeature/data-domain-presentation, rozbijać pliki >400
   linii, wdrożyć niezależny theme i shell zgodny z `gmail-inspired-design-spec`.
   UI ma pozostać bez API/vault/SignalR; Cubity lokalne, małe i bez
   `BuildContext`/nawigacji.

## Ryzyka generatorów i walidacji

- Repo zawiera wiele artefaktów Retrofit/Freezed/JSON; ich regeneracja przed
  usunięciem pierwotnych importów może zasypać zmiany i utrudnić odtworzenie
  funkcjonalności. Generator nie naprawia brakujących plików ani kontraktów.
- Nie uruchomiono `build_runner`, `gen-l10n`, testów ani buildów platformowych
  w R0. Nie są one PASS i wymagają ponownego, aktualnego wyniku po R2.
- Analizator obejmuje źródła i testy. Aktualne liczby są tylko baseline'em;
  nie dowodzą działania backendu, desktop PKCE, SignalR, uploadu czy parity UI.
- Shell i router są wspólnymi węzłami. Ich zmiany muszą mieć jednego właściciela;
  gałęzie Workspaces można naprawiać równolegle dopiero po ustaleniu portów i
  odzyskaniu wymaganych kompozycji.

## Następny krok

Zamknąć R1 manifestem odzyskania brakujących plików oraz wynikami porównania
z dostępnymi patchami. Następnie wykonać ograniczony pakiet R2 dla root/router
i grafu importów. R0 pozostaje **FAIL** do czasu ponownego pełnego
`flutter analyze` na kompilowalnym standalone.
