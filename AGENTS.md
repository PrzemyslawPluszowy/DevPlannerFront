# DevPlanner Front — instrukcje dla agentów

## Zakres i źródło prawdy

To repozytorium jest samodzielną aplikacją Flutter DevPlanner dla Web, Windows,
macOS i Linux. Pracuj wyłącznie w tym repozytorium oraz, gdy zadanie obejmuje
kontrakt API, w sąsiednim repozytorium `../Backend`. Inne repozytoria są poza
zakresem i wolno je co najwyżej odczytać jako materiał porównawczy.

Przed zmianą przeczytaj w całości
`docs/devplanner-standalone-refactor-plan.md`. Plan określa docelowy auth,
samodzielny shell, kolejność usuwania starych feature’ów, bramki platform i
Definition of Done. Po każdym pakiecie aktualizuj checklistę planu oraz
`docs/devplanner-standalone-refactor-handoff.md` w obu repo, podając pliki,
decyzje, komendy, wyniki i następny krok.

Pracuj na `main` albo branchu utworzonym jawnie dla bieżącego zadania. Nie
commituj i nie pushuj bez polecenia użytkownika. Przed zmianą sprawdź `git
status`; zachowaj cudze i niezwiązane zmiany.

## Granice produktu i architektura

- Produkt obejmuje auth, administrację użytkownikami i domenę DevPlanner:
  workspace, projekty, zadania, Kanban, Storage, Wiki, Whiteboard, Chat,
  powiadomienia oraz ustawienia.
- Tożsamość jest lokalna, a publicznym identyfikatorem modelu jest `userId`
  UUID. Konta tworzy tylko administrator; aplikacja nie udostępnia rejestracji.
- Swagger/OpenAPI backendu jest jedynym źródłem kontraktu transportowego. Nie
  zgaduj ścieżek, pól ani enumów. Presentation nie importuje Dio, klienta OIDC,
  SignalR ani secure storage.
- Błąd mapowania enuma między API a klientem jest regresją kontraktu. W każdym
  zadaniu zmieniającym API, DTO, serializację, OpenAPI albo model klienta
  zinwentaryzuj **wszystkie enumy używane w dotkniętym przepływie**, również gdy
  zmiana nie dodaje enuma. Oznacz każdy jako transportowy request/response,
  persistence/wewnętrzny albo lokalny UI; nazwy C# i Darta nie muszą być takie
  same.
- Dla każdego enuma transportowego porównaj pełny zestaw wartości i dokładne
  wartości przewodowe/casing w OpenAPI, rzeczywistym JSON-ie backendu oraz
  dekoderze i enkoderze Fluttera. Sprawdź globalne/lokalne
  `JsonStringEnumConverter`, `JsonStringEnumMemberName`, `JsonConverter`,
  niestandardowe konwertery, aliasy, wartości domyślne i obsługę nieznanej
  wartości. Nazwa wariantu Darta ani `apiValue` używane tylko w query nie
  dowodzą wartości JSON. Sprawdź mapy `@JsonValue` i wygenerowane `.g.dart`; po
  zmianie źródła uruchom generator, nigdy nie edytuj ręcznie plików generowanych.
- Testuj każdą wartość przewodową w obu kierunkach: Flutter decode odpowiedzi i
  encode requestu oraz backend serialize/deserialize. Przy zmianie kontraktu
  aktualizuj backend, OpenAPI/generatory, Fluttera i testy razem. Dla enumów
  poza zmianą potwierdź zgodność całego zestawu; jeśli OpenAPI jest niedostępne,
  zapisz blokadę i źródło zastępcze. Build ani zgodność nazw nie wystarczą.
- Utrzymuj drzewo feature → subfeature → `data/domain/presentation`. Kosztowne
  gałęzie mają własny lifecycle i lokalny Cubit. Nie spłaszczaj struktury dla
  pozornego uproszczenia.
- Cubit ma jedną odpowiedzialność, nie zna `BuildContext`, nawigacji ani
  widgetów. Nie twórz globalnych/god Cubitów lub Bloców. Bloc stosuj tylko do
  rzeczywiście złożonej orkiestracji zdarzeń.
- Nie dodawaj globalnych funkcji ani globalnego mutowalnego stanu. Logika
  biznesowa, API, refresh sesji i mapowanie błędów pozostają poza UI.
- `setState`/`ValueNotifier` służą tylko krótkotrwałemu stanowi kontrolki.
  Subskrypcje, timery, kontrolery i Cubity mają jawnego właściciela i są
  zwalniane; opóźnione emisje sprawdzają lifecycle i eliminują wyścigi.
- Teksty użytkownika pochodzą z ARB przez `context.l10n`. Zachowuj wspólne theme
  tokens; nie hardkoduj tekstów lub kolorów jako obejścia refaktoryzacji.
- Nie usuwaj starego feature’u, foundation ani adaptera przed przeniesieniem
  potrzebnej funkcjonalności i przejściem testów. Sekrety i tokeny nigdy nie
  trafiają do logów, Hive ani web storage.

## Auth i platformy

- Web używa BFF i cookie `Secure`/`HttpOnly` z CSRF; kod Flutter Web nie czyta
  access/refresh tokenów.
- Desktop używa systemowej przeglądarki, Authorization Code + PKCE i systemowego
  secure storage. Embedded WebView do hasła jest zabroniony.
- Jeden transport HTTP działa w zakresie sesji. Obsługa 401/refresh jest
  serializowana i nie tworzy pętli retry. Wylogowanie czyści cache użytkownika i
  zamyka realtime.
- SignalR jest schowany za typowanym portem domenowym, obsługuje reconnect,
  replay/deduplikację i revoke dostępu.
- Każdą funkcję sprawdzaj na Web, Windows, macOS i Linux. Integracje platformowe
  zamykaj w adapterach; kod domenowy i widgety nie importują bibliotek
  specyficznych dla platformy.
- Routing/deep link/back/refresh działa na Web, a desktop zachowuje ten sam model
  tras. Widoki są responsywne i działają po zmianie rozmiaru okna.

## Obowiązkowe UI UX Pro Max (Backend + Front)

- Przy każdym projektowaniu, budowaniu, zmienianiu i review UI **bezwzględnie
  korzystaj z wtyczki UI UX Pro Max i jej skillu `ui-ux-pro-max`**. Przed pracą
  przeczytaj `SKILL.md`, zastosuj właściwy dla zadania workflow i wskazówki dla
  Fluttera; samo wspomnienie nazwy wtyczki nie spełnia tego obowiązku.
- Wymóg obejmuje całe UI i wszystkie stany kontrolek: modale, dropdowny, menu
  kontekstowe, pickery, formularze, czat, pliki, loading, błędy i puste widoki.
  Sprawdzaj także klawiaturę, focus, dostępność i zachowanie po zmianie rozmiaru
  okna. W handoffie odnotuj zastosowane wskazówki i faktycznie wykonaną walidację.
- DevPlanner ma stylistykę aplikacji webowej/desktopowej spójną z Listą i
  Kanbanem: wspólne tokeny kolorów, typografia, odstępy, obramowania, hover i
  focus, również we wszystkich otwartych powierzchniach. Material jest
  dozwoloną bazą techniczną, ale domyślna mobilna kolorystyka i wygląd kontrolek
  nie spełniają wymagań. Rekomendacje skillu dostosowuj do tych zasad i decyzji
  użytkownika; nie zastępuj nimi istniejącego systemu wizualnego.

## Shell i UI

- Docelowy router zawiera tylko auth/activation/reset/MFA, Workspaces i zasoby,
  Chat, Notifications, Storage, `/me` i `/admin`.
- Globalny Chat i Notifications są dostępne z całego chronionego shellu bez
  utraty bieżącej trasy. Root modal host ma poprawny barrier, focus, Escape i
  zarezerwowaną przestrzeń względem belki.
- UI renderuje permissions zwrócone przez domenę, ale backend zawsze ponownie je
  egzekwuje. Błędy zachowują kod, komunikat i `traceId`; nie zamieniaj błędu API
  w pozorny sukces z cache.
- Duże pliki/widgety dziel według gałęzi odpowiedzialności. Kompozycja ekranu,
  stan subfeature’u i drobne widgety nie trafiają do jednego „god file”.
- Pojedynczy ręcznie utrzymywany widget lub klasa produkcyjna mają twardy limit
  400 linii; typowe widgety celują w mniej niż 300. Plik zawierający zbyt wiele
  odpowiedzialności podziel na osobne klasy i pliki. Nie omijaj limitu przez
  przeniesienie całej klasy do `part`, mixina lub pliku o innej nazwie. Zachowuj
  czytelny podział presentation/domain/data. Artefakty wygenerowane i lokalizacje
  wygenerowane nie są objęte tym limitem.
- Dokumentacja repozytorium, wytyczne agentów, handoffy i komentarze opisujące
  architekturę pisane są po polsku. Teksty interfejsu pozostają w lokalizacjach
  ARB PL/EN.

## Weryfikacja

Minimalne bramki frontendu:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
flutter build web --wasm
flutter build windows       # na Windows
flutter build macos         # na macOS
flutter build linux         # na Linux
git diff --check
```

Dobierz testy do ryzyka: Cubit/repository, mapping kontraktu i błędów, router/auth
guard, widgety, shell/modal/realtime oraz testy integracyjne OIDC na rzeczywistej
platformie. Brak hosta platformy oznacza niewykonaną bramkę, nie sukces. Wynik
jest dowodem dopiero po faktycznym uruchomieniu komendy.

Przy ręcznej kontroli UI na desktopie utrzymuj najwyżej jedną instancję
aplikacji/testowego `flutter run`: użyj istniejącej sesji, jeśli działa, a po
kontroli zamknij ją i potwierdź, że proces zakończył działanie. Nie uruchamiaj
równoległych kopii ani nie zostawiaj instancji testowych otwartych po zakończeniu
pracy.

## Wspólna pamięć DevNote / DevPlanner

Repozytoria `Backend` (C#) i `Front` (Flutter) są jednym projektem pamięci: `devnote-system`, `recall.peer_scope=actor`. Jawny `.openviking/config.json` ma pierwszeństwo przed osobnym Git origin. Nie dołączaj tych repo do Ready Next/Databus ani WMS. Zasady technologiczne i lokalne AGENTS obowiązują w odpowiednim komponencie.

Wyszukuj w projectUri „baza wiedzy / wiki projektu DevNote DevPlanner”, limit=3 i około 800 tokenów. Aktualny indeks: viking://user/codex/peers/devnote-system/resources/docs/index.md. Dokumentacja źródłowa znajduje się w `Backend/docs/openviking/index.md`; frontend ma wskaźnik `Front/docs/openviking/index.md`. Kod i zweryfikowany OpenAPI mają pierwszeństwo; datowana mapa nie dowodzi wdrożenia ani zaliczenia bramek planu refaktoryzacji.

Po zadaniu zapisuj tylko trwałe, zweryfikowane fakty pod właściwym wspólnym peer z pełnym URI, po sprawdzeniu duplikatów. Bez sekretów, danych osobowych, klientów i pełnych rozmów; Compile tylko przy jawnie zleconej aktualizacji. Ogólny MCP write opisuje peers jako managed/read-only; publikację stron można wykonać oficjalnym uwierzytelnionym content API.

## Środowisko testowe i obowiązkowe wdrożenie

- Poprawki zbieraj i wdrażaj pakietami: najpierw przejdź powiązane scenariusze na stagingu, zapisz odtworzenie błędów, przygotuj wspólny zestaw napraw i wykonaj bramki kodu. Nie publikuj każdej drobnej poprawki osobno. Po jednym wdrożeniu pakietu sprawdź ponownie dokładnie zgłoszone błędy oraz powiązane regresje; nowe drobne usterki zbieraj do następnego pakietu.
- Wspólnym środowiskiem testowym Frontu i Backendu jest staging pod `https://devnote.flutter-dev.pl` (VPS `135.125.200.141`). Testy UI, testy przeglądarkowe/E2E, odbiór wizualny i scenariusze użytkownika wykonuj na tym środowisku po publikacji zmian, nie na localhost. Nie uruchamiaj lokalnego serwera ani lokalnej instancji aplikacji na potrzeby tych testów.
- Po zmianach w kodzie opublikuj aktualizowane komponenty na stagingu, aby testy dotyczyły faktycznie wdrożonej wersji. Przy zmianie kontraktu lub obu komponentów wdrażaj Backend i Front. Lokalne buildy, analyzer i testy jednostkowe pozostają bramkami kodu; nie zastępują odbioru UI na stagingu.
- Backend wdrażaj przez SSH jako `codex-staging`, dedykowanym kluczem `~/.ssh/id_ed25519_codex_devplanner_staging`, poleceniem `sudo -n /usr/local/sbin/devplanner-deploy-local`. Skrypt pobiera `main` przez `git pull --ff-only`, buduje obrazy na VPS i wykonuje migracje. Wymaga wcześniejszego commit/push źródeł; nie wdraża niezapisanych lokalnych poprawek. Stosuj istniejące zasady autoryzacji commit/push.
- Front publikuj **wyłącznie jako Web Wasm** skryptem `../Front/scripts/deploy_staging_wasm.sh` (z repo Front: `scripts/deploy_staging_wasm.sh`). Buduje `flutter build web --wasm --no-tree-shake-icons` ze stagingowym `DEVPLANNER_API_BASE_URL`, wysyła paczkę przez SSH i atomowo przełącza `current`. `--no-build` jest dozwolone wyłącznie dla już sprawdzonego, aktualnego builda Wasm.
- Nie używaj skryptu `deploy_ready_custom_flutter.sh`: dotyczy innego hosta i produktu. Nie uruchamiaj ręcznego deployu równolegle z GitHub Actions. W ręcznej ścieżce używaj `[skip ci]` w commicie wdrożeniowym.
- Po publikacji potwierdź SHA backendowego obrazu, readiness, wersję Frontu, dostępność `main.dart.wasm`, fallback SPA oraz wymagany scenariusz UI. Zapisz faktyczny wynik w handoffie. Kompilacja i samo przesłanie archiwum nie oznaczają wdrożenia.
- Użytkownik zezwala agentom na czyszczenie danych testowych i seedowanie **tej bazy stagingowej** w ramach testów. Przed zmianą danych potwierdź docelowy host i bazę. Seeder: `sudo -n /usr/local/sbin/devplanner-seed-demo`; dostęp do danych: `devplanner-observe db`. Usuwaj dane w zakresie scenariusza lub resetu testowego; zmiany schematu wykonuj migracjami. Zgoda nie obejmuje innych środowisk ani baz.
- Instrukcja dostępu: `Backend/deployment/staging/AGENT_ACCESS.md`; przekazanie publikacji: `docs/deployment-handoff-2026-10-01.md`. Jeśli uprawnienia konta blokują publikację, zapisz konkretną blokadę i wymagane uprawnienie; nie deklaruj wdrożenia.
