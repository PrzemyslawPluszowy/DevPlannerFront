# Project Instructions

## Stała instrukcja dla nowych chatów — `veloryn-workspaces`

Jeżeli użytkownik mówi o wdrażaniu modułu `workspace` albo `Workspaces`,
traktuj to jako pracę nad nowym, osobnym backendem C# `veloryn-workspaces`, a
nie nad istniejącym `veloryn-databus`, `veloryn-core` ani innym modułem.

- Cała praca odbywa się wyłącznie na branchu `workspace`.
- Przed działaniem przeczytaj `workspace-implementation.md`,
  `workspace-implementation-plan.md` oraz
  `docs/veloryn-workspaces-csharp-AGENTS.md`.
- Backend ma używać najnowszego wspieranego .NET zgodnego z Core — obecnie
  `net10.0` — oraz PostgreSQL z własnym schematem `veloryn_workspaces`.
- `veloryn-core` jest wyłącznie źródłem JWT/JWKS, `CoreUserId`, `ReadyUserId` i
  roli `SuperAdmin`; Workspaces lokalnie waliduje JWT przez JWKS.
- DataBus, BHP, Inwentaryzacja, IQC i inne moduły pozostają poza zakresem, chyba
  że użytkownik wyraźnie poprosi o integrację.
- Nie rozpoczynaj od pisania kodu, jeśli użytkownik prosi o analizę, plan lub
  przygotowanie środowiska.
- Kontynuuj od pierwszego niezakończonego punktu w
  `workspace-implementation-plan.md` i aktualizuj checklistę po zakończonej
  pracy.

## Veloryn Workspaces — Flutter

`veloryn-workspaces` jest zamkniętym modułem aplikacji `ready_next`, przeznaczonym
wyłącznie dla użytkowników pochodzących z Ready. Frontend komunikuje się z osobnym
backendem C# `veloryn-workspaces`; nie odwołuje się bezpośrednio do PostgreSQL,
MinIO ani `AIFastApi`.

### Granice modułu

- `veloryn-core` jest źródłem tożsamości, JWT, `CoreUserId`, `ReadyUserId` i roli
  `SuperAdmin`.
- Backend Workspaces sprawdza dostęp do workspace, projektu, zadania, pliku,
  whiteboardu i dokumentu.
- `SuperAdmin` może administracyjnie widzieć każdy workspace, ale otrzymuje jego
  powiadomienia tylko po dodaniu do workspace jako członek.
- Flutter nie może traktować globalnego dostępu SuperAdmina jako automatycznej
  subskrypcji powiadomień.
- AI wywołujemy przez backend Workspaces; klient nie wywołuje `AIFastApi` z
  pominięciem kontroli uprawnień.

### Platformy docelowe

- Docelowymi platformami są Flutter Web oraz wszystkie desktopowe targety
  wspierane przez aplikację: Windows, macOS i Linux. Żaden z nich nie jest
  wariantem drugiej kategorii ani zubożoną wersją przepływu.
- Dla Web preferuj build WebAssembly (`wasm`) zgodny z wersją Flutter/Dart
  projektu; funkcje niedostępne w Wasm muszą mieć jawnie udokumentowany fallback.
- Integracje webowe realizuj przez aktualny interop Darta, przede wszystkim
  `dart:js_interop` oraz wspierane biblioteki interop, a nie przez `dart:html`.
- Aplikacja musi jednocześnie działać na desktopie bez osobnego, zubożonego
  przepływu funkcjonalnego.
- Widoki projektuj responsywnie dla dużych ekranów webowych i desktopowych oraz
  dla zmiany rozmiaru okna.
- Routing, deep linki, odświeżenie strony i przycisk Back muszą działać w Web;
  desktop nie może zakładać istnienia adresu URL, ale powinien zachować ten sam
  model tras i kontekstu nawigacji.
- Dostęp do plików, drag-and-drop, skróty klawiaturowe, menu kontekstowe i
  otwieranie nowych widoków sprawdzaj osobno dla Web i desktopu.
- Nie używaj `dart:html` ani platformowych obejść w feature’ach; integracje
  platformowe zamykaj w abstrakcjach i implementacjach per platforma.
- Kod Wasm/interop trzymaj poza logiką domenową i widgetami; wystawiaj typowane
  abstrakcje, które mogą mieć implementację webową oraz desktopową.
- Testuj ścieżki interop w rzeczywistym środowisku Web/Wasm, a nie wyłącznie w
  testach jednostkowych uruchamianych na VM.
- Testy kluczowych ekranów i routingu uruchamiaj co najmniej dla Web oraz
  desktopowego targetu projektu.

### Git

- Cała praca nad Workspaces odbywa się wyłącznie na branchu `workspace`.
- Nie twórz osobnych feature branchy dla tego projektu.
- Zmiany, testy i commity wykonuj na `workspace`.

### Obowiązkowy kontekst Workspaces

Przed rozpoczęciem nowego zadania lub nowego czatu dotyczącego `veloryn-workspaces`
agent musi przeczytać i stosować:

1. `workspace-implementation.md` — pełny zakres i decyzje produktowe,
2. `workspace-implementation-plan.md` — kolejność wdrażania i checklistę,
3. ten `AGENTS.md` — zasady Fluttera, platform i pracy w repozytorium.

Nie wymagaj od użytkownika ponownego opisywania, że wdrażamy Workspaces ani
ponownego przekazywania zakresu. Kontynuuj od pierwszego niezakończonego punktu
planu, chyba że użytkownik jawnie zmieni decyzję. Po wykonaniu zadania aktualizuj
checklistę planu i dokumentację, jeśli zmieniły się ustalenia.

### Struktura modułu

Preferuj podział funkcjonalny zgodny z domeną:

```text
lib/modules/workspaces/
├── data/
├── domain/
├── presentation/
└── workspaces_export.dart
```

Główne obszary to `workspace`, `project`, `task`, `whiteboard`, `files`,
`comments`, `notifications`, `wiki`, `dashboard` i `ai`. Networking pozostaje w
warstwie `data`, reguły widoczności i stany w `domain`, a widgety i bloc/cubit w
`presentation`.

### Kontrakty i bezpieczeństwo

- Swagger/OpenAPI backendu C# jest jedynym źródłem kontraktu transportowego.
- Nie zgaduj nazw pól, ścieżek, parametrów ani typów odpowiedzi.
- Każdy obiekt z API musi zachować identyfikator i poziom dostępu potrzebny UI.
- Nie pokazuj danych lub akcji tylko dlatego, że użytkownik jest SuperAdminem;
  sprawdzaj uprawnienia zwrócone przez API oraz stan członkostwa.
- Nie loguj JWT, presigned URL-i, treści prywatnych plików ani danych AI.
- Zmiany AI pokazuj jako propozycję/diff i wymagaj akceptacji, jeżeli zmiana
  zapisuje dane.
- Realtime musi obsługiwać ponowne połączenie, duplikaty zdarzeń i aktualizację
  cache bez utraty lokalnych zmian.

### UX Workspaces

- Duże listy zadań używają paginacji backendu i infinite scroll.
- Kanban ładuje dane per kolumna i respektuje filtry oraz uprawnienia.
- Ukrywanie, przypinanie i sortowanie workspace’ów/projektów jest preferencją
  użytkownika, nie zmianą uprawnień.
- Whiteboard jest osobnym widokiem od listy zadań i Kanbana.
- Nie dodawaj ekranów dla `Guest`, ponieważ system jest zamknięty.

### Organizacja feature’ów i subfeature’ów

Kod Workspaces musi zachowywać hierarchię domeny i mieć jednoznaczne miejsce dla
każdej odpowiedzialności. Stosujemy podział `feature → subfeature`, na przykład:

```text
lib/modules/workspaces/
└── whiteboard/
    ├── whiteboard_export.dart
    ├── data/
    ├── domain/
    ├── presentation/
    │   ├── list/
    │   │   ├── bloc/
    │   │   └── widgets/
    │   ├── create_node/
    │   │   ├── bloc/
    │   │   └── widgets/
    │   └── editor/
    │       ├── bloc/
    │       └── widgets/
    └── shared/
```

- `whiteboard` jest feature’em, a `list`, `create_node` i `editor` są jego
  subfeature’ami.
- Każdy subfeature ma własne stany/zdarzenia, kontrolery, strony i widgety,
  jeśli rzeczywiście posiada własny przepływ.
- Nie umieszczaj całej logiki feature’u w jednym dużym pliku.
- Widgety dziel na mniejsze, gdy mieszają layout, stan, nawigację lub logikę
  prezentacji.
- Większość widgetów powinna mieścić się w około 300 liniach. Formularze mogą
  przekraczać ten rozmiar, jeśli zawierają jeden spójny i uzasadniony przepływ,
  ale również należy dzielić ich sekcje, pola i elementy pomocnicze tam, gdzie
  poprawia to czytelność.
- Unikaj globalnych funkcji. Logikę trzymaj w odpowiedzialnych klasach,
  serwisach, helperach lub lokalnie w widgetach, jeżeli jest drobna i używana
  tylko w tym jednym miejscu.
- Eksportuj publiczne elementy przez barrel z końcówką `*_export.dart`.
- Domyślnym miejscem kodu Workspaces jest `lib/workspaces`, również dla jego
  widgetów, helperów i komponentów współdzielonych wewnątrz modułu. Kod trafia
  do `lib/shared` wyłącznie wtedy, gdy faktycznie jest potrzebny przez co
  najmniej dwa niezależne moduły aplikacji.
- Jeden feature może i powinien zawierać katalogi subfeature’ów, ich widgetów i
  lokalnych Cubitów, gdy ułatwia to odczytanie właściciela odpowiedzialności.
  Nie spłaszczaj struktury wyłącznie dla zmniejszenia liczby katalogów.
- Dla złożonego widoku najpierw wyodrębnij jego **gałęzie odpowiedzialności**,
  a dopiero potem pliki: ekran/kompozycja trafia do `presentation/<feature>/`,
  samodzielna gałąź z własnym stanem, żądaniem lub lifecycle do
  `presentation/<feature>/<subfeature>/`, a jej drobne elementy wyłącznie do
  `widgets/` wewnątrz tego subfeature’u. Przykład dla menu:
  `workspaces_home/directory_menu/widgets/`,
  `workspaces_home/projects_tree/widgets/` i
  `workspaces_home/manage_workspace/widgets/`.
- Nie twórz katalogu `widgets/` dla pojedynczego pliku bez własnej granicy
  odpowiedzialności. Gdy komponent jest tylko fragmentem jednej kompozycji,
  pozostaje obok niej; gdy ma własny Cubit, lazy-loading, obsługę błędu albo
  testy, staje się nazwanym subfeature’em. Nie umieszczaj widgetów z różnych
  gałęzi w jednym ogólnym `widgets/`.
- Drzewo UI musi odzwierciedlać drzewo danych i lifecycle: element nadrzędny
  jest właścicielem rozwinięcia, a każda kosztowna gałąź ma lokalny Cubit oraz
  ładuje się dopiero po rozwinięciu. Nie łącz niezależnych zapytań (np. typów
  zasobów projektu) w jeden nieprecyzyjny stan.
- Wszystkie teksty widoczne dla użytkownika, także w wydzielonych subwidgetach,
  pochodzą z `intl`/ARB przez `context.l10n`. Po zmianie ARB uruchom generator
  lokalizacji; nie dodawaj stałych tekstów jako wygodnego obejścia refaktoryzacji.
- Jeżeli układ małego ekranu istotnie różni się od desktopowego, trzymaj jego
  kompozycję w osobnym, nazwanym katalogu blisko ekranu, np.
  `presentation/project_overview/mobile/`. Współdziel modele, Cubit i drobne
  komponenty, ale nie buduj nieczytelnych drzew warunków responsywnych.
- Zmiana shared widgetu używanego poza Workspaces musi zachować jego obecne API
  i zachowanie. Zamiast łamiącej zmiany preferuj kompatybilne rozszerzenie API
  albo nowy, celowany komponent.

### Stan i lifecycle

- Cubit jest domyślnym mechanizmem zarządzania stanem i komunikacji między
  warstwą prezentacji a domeną. Pełnego Bloc używaj wyłącznie dla rzeczywiście
  złożonej orkiestracji wielu typów zdarzeń; nie wprowadzaj go ceremonialnie.
- Nie tworzymy globalnych Bloców. Bloc powinien żyć tak długo, jak jego feature,
  subfeature lub ekran.
- Preferuj `BlocProvider` na najniższym wspólnym poziomie drzewa, który obejmuje
  potrzebne widgety.
- `setState` stosuj tylko dla lokalnego, krótkotrwałego stanu UI, gdy Bloc byłby
  nieproporcjonalny. Przykłady: otwarcie menu, lokalny hover, chwilowa zmiana
  rozmiaru lub stan kontrolki.
- Przy prostym lokalnym stanie preferuj `ValueNotifier`/`ValueListenableBuilder`,
  jeżeli nie ma zdarzeń domenowych ani potrzeby komunikacji z API.
- Nie przenoś stanu biznesowego do `setState` ani do globalnych singletonów.
- Stany Bloców i zdarzenia mają być jawne, typowane i testowalne.
- Trzymaj możliwie mały scope Bloców: `BlocProvider` umieszczaj na poziomie
  feature’u, subfeature’u lub ekranu, który jest właścicielem danego stanu.
- Bloc powinien być zamykany razem z zakresem, który go utworzył. Korzystaj z
  automatycznego zamykania przez `BlocProvider(create: ...)` albo jawnie zamknij
  Bloc w jego właścicielu, jeśli został utworzony ręcznie.
- Widget, który otrzymał Bloc przez `BlocProvider.value` lub konstruktor, nie
  zamyka go, jeśli nie jest jego właścicielem.
- W callbackach asynchronicznych, timerach, streamach i operacjach sieciowych
  sprawdzaj `isClosed` przed `emit`/`add`, aby nie używać zamkniętego Bloc’a.
- Po zamknięciu Bloc’a anuluj subskrypcje, timery i pozostałe źródła zdarzeń,
  żeby nie utrzymywały widgetu ani kontekstu feature’u przy życiu.
- Stany Cubitów deklaruj jako niemutowalne `sealed class` z wyczerpującym
  pattern matchingiem. Nie używaj Freezed do stanów Cubitów; Freezed pozostaje
  dopuszczalny dla modeli transportowych i danych, dla których generator jest
  uzasadniony.
- Cubit ma jedną odpowiedzialność i nie zna `BuildContext`, nawigacji,
  snackbara ani widgetów. Widget nie wykonuje logiki biznesowej: wywołuje
  intencję Cubita i renderuje stan.
- Używaj `BlocSelector` i małych `BlocBuilder`ów, aby zmiana pojedynczego pola
  nie przebudowywała całego ekranu.
- RxDart stosuj do strumieni wymagających operatorów, np. `debounce`,
  `distinct` i `switchMap` dla wyszukiwania. Każda subskrypcja, timer i
  kontroler ma jawnego właściciela oraz jest zwalniany w `close`/`dispose`.
- Sprawdzaj `isClosed` bezpośrednio przed każdym opóźnionym `emit`; przy
  odświeżaniu i wyszukiwaniu eliminuj wyścigi requestów oraz emisję
  nieaktualnej odpowiedzi.

### API, realtime i błędy

- UI nigdy nie łączy się bezpośrednio z API, klientem realtime/WebSocket ani klientem
  HTTP. Komunikacja przebiega przez typowany klient data, repository/use case i
  Cubit. Warstwa `presentation` zależy od `domain`, a `data` implementuje
  kontrakty określone przez `domain`; zależności nie mogą prowadzić z domeny do
  konkretnego klienta HTTP ani pakietu realtime.
- Wdrażaj pełny zakres kontraktu backendu, a nie tylko pola chwilowo widoczne na
  pierwszym ekranie. Nie zgaduj kontraktów: Swagger/OpenAPI i implementacja C# są
  źródłem prawdy.
- Błędy backendu mapuj do typowanego błędu domenowego z zachowaniem komunikatu,
  kodu i identyfikatora korelacji, jeśli backend je zwraca. UI pokazuje ten
  komunikat użytkownikowi; nie ukrywaj go fallbackiem ani nie zastępuj sukcesem
  z cache. Retry jest świadomą akcją użytkownika albo udokumentowaną,
  bezpieczną polityką techniczną.
- Realtime implementuj przez abstrakcję domenową, np. `WorkspaceRealtimeClient`,
  z jedną implementacją wybranego protokołu w `data/realtime/`. Cubity dostają
  wyłącznie strumienie typowanych zdarzeń. Implementacja obsługuje token JWT,
  automatyczne ponowne połączenie, duplikaty, utratę połączenia oraz anulowanie
  subskrypcji przy `close`.
- Backend `veloryn-workspaces` używa ASP.NET Core SignalR (nie surowego
  WebSocketa). Huby są pod `/api/v1/realtime/notifications`,
  `/api/v1/realtime/tasks`, `/api/v1/realtime/chat`,
  `/api/v1/realtime/whiteboard` i `/api/v1/realtime/wiki`; JWT przekazuj jako
  `access_token` podczas handshake. Bibliotekę SignalR zamknij w adapterze, aby
  jej API nie przedostało się poza `data/realtime/`.
- Po reconnect odtwarzaj brakujące zdarzenia odpowiednią metodą huba i
  deduplikuj je stabilnym `eventId`/`operationId`; przy sygnale resynchronizacji
  pobieraj aktualny snapshot REST. Nie zakładaj, że sam reconnect odzyska
  pominięte dane.
- Przed przyjęciem biblioteki realtime wykonaj mały test integracyjny z faktycznym
  endpointem: połączenie po JWT, reconnect, odbiór zdarzenia i rozłączenie na
  Web, Windows, macOS oraz Linux. Nie rozlewaj API zewnętrznej paczki poza
  adapter.

### Shared widgets, motywy i formatowanie

- Najpierw używaj istniejących widgetów z `lib/shared` oraz komponentów projektu.
- Jeżeli komponent jest potrzebny tylko w Workspaces, utwórz go w
  `lib/workspaces` blisko feature’u, który jest jego właścicielem. Przenieś go
  do `lib/shared` dopiero po potwierdzeniu użycia przez niezależny moduł.
- Przed utworzeniem nowego shared widgetu sprawdź, czy istniejący komponent można
  rozszerzyć bez pogorszenia jego API.
- Kolory, odstępy, typografia i kształty muszą pochodzić z motywu oraz jego
  extensions; nie twórz lokalnych stylów bez uzasadnienia.
- Ikony aplikacji pobieraj przez `AppIcons`; nie mieszaj przypadkowo ikon
  Material i zewnętrznego zestawu w jednym shellu. Zmiana biblioteki ikon ma
  być możliwa przez adapter bez przepisywania feature’ów.
- Własne rozszerzenia `ThemeData`/`ColorScheme`, gradienty glass i klasy
  pomocnicze dla Workspaces trzymaj w `lib/workspaces/shared/helpers` i
  eksportuj przez barrel; nie umieszczaj ich bezpośrednio w ekranie.
- Daty, godziny, liczby, wartości lokalizowane i formaty użytkownika obsługuj
  przez `intl` oraz istniejącą warstwę lokalizacji.
- Nie implementuj własnych formatterów, jeśli odpowiednik istnieje w projekcie
  albo w `intl`.
- Używaj `intl` dla wszystkich dat, godzin, liczb, walut i formatów zależnych od
  lokalizacji. Nie pisz własnych formatterów tych wartości.
- Kolory korzystają z `ThemeData`, `ColorScheme`, `MaterialColor` oraz
  extensions motywu; nie koduj wartości kolorów w feature’ach.

### Projektowanie UI Workspaces

- UI Workspaces ma dorównywać ergonomią narzędziom takim jak Jira, Asana i
  ClickUp: jest zwarte, szybkie w skanowaniu i umożliwia równoczesne oglądanie
  dużej liczby informacji bez utraty hierarchii.
- Gęstość informacji nie może pogarszać czytelności: priorytet, status,
  przypisanie, termin, liczniki i najważniejsze akcje mają konsekwentną
  hierarchię wizualną, pełne etykiety dostępności oraz obsługę klawiatury.
- Każdy ekran ma jawne stany ładowania, danych, pustego wyniku, błędu i braku
  uprawnienia. Nie używaj cichych fallbacków ani nie ukrywaj błędów.
- Funkcjonalny szkielet nie jest akceptacją UI: przed oznaczeniem menu jako
  ukończonego musi ono mieć produktową gęstość i hierarchię porównywalną klasą
  do Monday/ClickUp/Asana, bez kopiowania ich 1:1.
- Globalny shell musi rozdzielać lekki topbar, rail modułów i kontekstowy panel
  Workspace. W panelu mają być widoczne sekcje Prywatne, Ulubione i Workspace’y,
  a aktywny kontekst ma być oczywisty bez dodatkowego klikania.
- Globalny Chat i Powiadomienia są panelami overlay/drawer z prawej strony lub
  warstwą nad treścią, nigdy domyślnie osobną pełną stroną. Muszą zachować
  bieżący kontekst routingu, mieć animowane otwieranie/zamykanie, Escape,
  kliknięcie poza panelem, focus trap i pełny backendowy kontrakt akcji.
- Przezroczystości i gradienty paneli wyliczaj z `ColorScheme`, aby zachować
  Material Theme w jasnym i ciemnym trybie; nie hardkoduj palety panelu.
- Weryfikacja wizualna obejmuje co najmniej Web 1280 px oraz macOS/Desktop:
  sprawdzamy gęstość, overflow, selected/hover/focus, stan zwinięty i stan
  pusty. Sam `flutter analyze` ani build nie dowodzi jakości interfejsu.

### Dart i dokumentacja

- Używaj najnowszej składni Dart wspieranej przez wersję SDK projektu.
- Preferuj dot shorthands, pattern matching, exhaustive `switch` oraz primary
  constructors, gdy są poprawne i czytelne w danym miejscu.
- Każda jawnie deklarowana klasa musi mieć komentarz dokumentacyjny `///` po
  polsku opisujący jej odpowiedzialność.
- Dokumentuj również nieoczywiste decyzje, zależności i ograniczenia przepływu.
- Nazwy klas, metod i stanów pozostają po angielsku zgodnie z kodem projektu;
  komentarze dokumentacyjne pisz po polsku.
- Dokumentacja jest częścią implementacji: opisuj po polsku odpowiedzialność
  każdego pliku publicznego, klasy, Cubita, stanu, adaptera i nieoczywistej
  decyzji. Komentarz ma wyjaśniać co element robi, za co odpowiada oraz dlaczego
  istnieje — nie tylko powtarzać jego nazwę.

### Routing i web

- Routing musi obsługiwać webowe deep linki, odświeżenie strony oraz bezpośredni
  dostęp do konkretnego workspace, projektu, zadania, whiteboardu i dokumentu.
- Każdy ekran dostępny z dashboardu powinien mieć własną trasę, a nie tylko
  lokalny przełącznik widoku.
- Parametry routingu muszą być jawne, typowane i wystarczające do odtworzenia
  kontekstu po odświeżeniu przeglądarki.
- Guardy routingu sprawdzają uwierzytelnienie, aktywny workspace i uprawnienia;
  nie wolno polegać wyłącznie na ukryciu przycisku w UI.
- Po wejściu z dashboardu zachowuj możliwość użycia przycisku Back i deep linku.

### Produkcyjny standard i testy

- Każdą funkcję implementuj jako kod produkcyjny, bez tymczasowych skrótów i
  atrap pozostawionych w ścieżce użytkownika.
- Nowy subfeature powinien mieć testy Bloców, logiki domenowej i kluczowych
  widgetów, a przepływy routingu oraz API — testy integracyjne, gdy są istotne.
- Po zmianach uruchamiaj `dart format`, `flutter analyze` oraz właściwe testy.
- Nie duplikuj kodu tylko po to, aby szybko zamknąć ekran; wydziel shared widget,
  helper lub komponent domenowy, jeśli powtarzalność jest rzeczywista.

## Dart Style

- In this project, prefer Dart dot shorthand syntax whenever the context type is clear.
- Use forms such as `.all(...)`, `.circular(...)`, `.symmetric(...)`, `.center`, `.bold`, `.parse(...)`, and enum values like `.inventory`.
- This also applies to enum-like framework values such as `crossAxisAlignment: .start`, `mainAxisSize: .min`, `fontWeight: .w700`, `alignment: .centerLeft`, `clipBehavior: .antiAlias`, and similar cases where the target type is obvious.
- Do not expand dot shorthand to fully qualified forms such as `EdgeInsets.all(...)` or `Radius.circular(...)` unless the shorthand would be ambiguous or invalid in that context.
- When editing existing UI code, preserve and continue the project's dot shorthand style.
- If a construct can't legally start with dot shorthand in that position, use standard Dart syntax only for that specific case instead of rewriting surrounding code away from dot shorthand.
- Prefer modern Dart pattern matching (`switch` expressions/statements and `if-case`) over legacy type-check chains with `is` where practical.
- For state-driven UI, prefer exhaustive `switch` handling for predictable rendering paths.

## UI And Theme

- Use the Material color palette defined in the project theme. Do not introduce ad-hoc colors in widgets when an equivalent color exists in `ThemeData.colorScheme`.
- Use text styles and fonts from the project theme. Do not hardcode font families in feature code.
- Use theme extensions and theme access helpers consistently. In UI code, prefer project extensions such as `context.colors`, `context.text`, and future theme helpers over raw `Theme.of(context)` access when equivalent helpers exist.
- Keep UI consistent with the shared theme layer instead of creating one-off visual rules inside feature widgets.

## Code Quality

- Write code to the highest standard: clear structure, strong naming, minimal duplication, predictable composition, and production-quality readability.
- Prefer simple, maintainable solutions over clever shortcuts unless the project explicitly requires the shortcut style, such as Dart dot shorthands.
- Avoid magic numbers in UI and layout code when shared constants or theme helpers already exist.
- New code should feel intentional, cohesive, and ready to scale.
- Every explicit class declaration must include `///` documentation comments in Polish.
- Widget/UI files should normally stay within roughly 300 lines and should be split earlier when responsibilities start to mix.
- This size limit applies to widget and presentation files, not automatically to small functional classes, helpers, models, converters, or other non-UI support code.

## State And Models

- In blocs and bloc-related state/events, do not use `freezed`.
- For blocs, prefer `sealed class` hierarchies with `equatable` where value equality is needed.
- Keep bloc state and event definitions explicit, readable, and easy to navigate without code generation.
- `freezed` may be used in REST/API models when the structures are more complex or when it meaningfully improves immutable modeling and JSON handling.
- `freezed` and `json_serializable` are acceptable for transport models, especially for more complex response bodies, nested payloads, and serialization-heavy code.
- Swagger/OpenAPI is the source of truth for transport models: map fields 1:1 with the contract names/types.
- Do not invent or rename API fields unless explicitly confirmed by backend docs.
- If some response fields are not needed by UI/business logic, they may be omitted from model serialization, but existing mapped fields must remain contract-accurate.

## Networking

- Use `retrofit` for API queries and HTTP client definitions.
- Keep request contracts explicit and generated from Retrofit interfaces instead of hand-writing ad-hoc request layers when the endpoint fits the Retrofit approach.
- For every API endpoint change, verify the exact method, path, request body, query parameters, path parameters, and response schema against Swagger/OpenAPI before implementing. This is mandatory and categorical: do not infer whether a value belongs in query or body from existing code, naming, or similar endpoints.
- When adding or changing an endpoint contract, leave the direct Swagger link used for verification in the relevant code comment, report note, or implementation summary so the source of truth is traceable.
- Required Swagger reference for komisja arkusza verification: http://192.168.170.20:8101/api/documentation#/Inwentaryzacja%20%E2%80%94%20Arkusze/update_arkusz_komisja_api_v1_inwentaryzacja_arkusze__arkusz_id__komisja_put

## Engineering Guardrails

- Use project theme extensions and shared helpers first; avoid introducing parallel utility paths when an equivalent helper already exists.
- Prefer shared UI components from `lib/shared` over feature-local widget duplication.
- If a reusable shared component is missing and should be created, explicitly inform the user before or while adding it.
- Do not leave deprecated APIs/usages in the codebase; when migration is needed, migrate fully instead of keeping deprecated paths.
- Install new dependencies via CLI and prefer the latest stable version available at installation time.
- On Web, do not use obsolete `dart:html` patterns; use `dart:js_interop`-based integrations.
- Use barrel `export` files to expose module/public API surfaces in a predictable way.
- Barrel files must use the `*_export.dart` suffix (for example `inventory_pages_export.dart`).
- If a widget is not meant to be reused across the whole app, keep it local as a `part of` the feature/page file instead of promoting it to shared/global scope.
- Keep strict layer boundaries: feature presentation should not contain ad-hoc networking logic.
- Report backend contract issues immediately when discovered (for example: missing Swagger requestBody/parameters, schema mismatches, inconsistent response envelopes).
- Treat logging as production-safe: do not expose tokens, secrets, or sensitive payload fields in logs.
- Write production-quality code by default: DRY (Do Not Repeat Yourself), clear naming, predictable composition, and no temporary hack patterns.
- Avoid hardcoded API URLs, auth values, and one-off constants in feature code; keep configuration centralized.
- After meaningful changes, run relevant verification (`format`, `analyze`, generators/tests when applicable) before finalizing.

## Notes

- This project intentionally uses modern Dart syntax supported by dot shorthands.
- Reference: https://dart.dev/language/dot-shorthands
- Lokalny backend BHP jest w osobnym repo: `/Users/przemyslawnowak/Desktop/dev/Excellent dev/excellent_databus/databus/veloryn-bhp`.
- Kluczowe pliki backendu BHP:
  - `routes/api.php`
  - `app/Http/Middleware/VerifyReadyToken.php`
  - `app/Modules/Bhp/Users/Http/UserController.php`
  - `app/Modules/Bhp/Users/Presentation/UserIssueResource.php`
- Backend BHP wymaga `Authorization: Bearer <token>` i weryfikuje token przez `ready.auth` z `config/services.php`.

## graphify

This project has a graphify knowledge graph at graphify-out/.

Rules:
- Before answering architecture or codebase questions, read graphify-out/GRAPH_REPORT.md for god nodes and community structure
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- For cross-module "how does X relate to Y" questions, prefer `graphify query "<question>"`, `graphify path "<A>" "<B>"`, or `graphify explain "<concept>"` over grep — these traverse the graph's EXTRACTED + INFERRED edges instead of scanning files
- After modifying code files in this session, run `graphify update .` to keep the graph current (AST-only, no API cost)
