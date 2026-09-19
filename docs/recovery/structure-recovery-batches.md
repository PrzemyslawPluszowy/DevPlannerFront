# DevPlanner Front — plan odzyskania struktury i funkcjonalności

Data: 2026-09-17  
Status: plan wykonawczy po odrzuceniu osobnego ekranu Chat  
Referencja UI: `docs/design/gmail-inspired-design-spec.md` oraz wyłącznie
lokalny, wyłączony z Gita `docs/design/reference-local/gmail-layout-reference.png`.

## Cel i granice

`Workspace` jest pełnoprawną aplikacją standalone. Docelowe drzewo ma być
czytelne i feature-first, pod jednym nazwanym korzeniem `features`:

```text
lib/
  app/                         # bootstrap, router, shell, overlay host
  foundation/                  # konfiguracja, HTTP, theme, l10n, platform
  features/
    <feature>/                  # workspace, tasks, files, chat, notifications...
      data/                    # Retrofit/DTO/repository implementation
      domain/                  # models, failures, repository ports, use cases
      presentation/            # Cubit/state/widgets/pages dla tej funkcji
```

Każdy katalog funkcji ma własne `data/domain/presentation`; wspólne elementy
trafiają do `foundation` tylko wtedy, gdy są naprawdę niezależne od funkcji.
Nie tworzyć równoległego `lib/workspaces` jako drugiego docelowego korzenia.

## Mapowanie obecnego drzewa `lib/workspaces`

Obecne `lib/workspaces` jest źródłem odzyskiwanych funkcji, a nie docelową
strukturą. Migracja przebiega etapami i nie przenosi pliku, dopóki jego importy
nie są zamknięte:

| Obecna gałąź | Docelowa gałąź | Zasada przejścia |
|---|---|---|
| `lib/workspaces/data/...` | `lib/features/workspaces/data/...` albo właściwy feature | Najpierw lokalne DTO/repository ports, potem adapter i test parsera. |
| `lib/workspaces/domain/...` | `lib/features/<feature>/domain/...` | Rozdzielić modele/porty według feature, usunąć importy Ready/Core/DataBus. |
| `lib/workspaces/presentation/tasks/...` | `lib/features/tasks/presentation/...` | Przenosić pionami: lista, szczegóły, Kanban; każdy pion kompilowalny osobno. |
| `lib/workspaces/presentation/storage/...` | `lib/features/files/presentation/...` | Zachować ACL/upload/download, ale z lokalnym portem Files. |
| `lib/workspaces/data/chat` i presentation Chat | `lib/features/chat/...` | Docelowo prawy overlay shellu, nie główna trasa ani osobny ekran. |
| `lib/workspaces/data/notifications` i presentation Notifications | `lib/features/notifications/...` | Docelowo prawy overlay shellu; REST i realtime rozdzielone portami. |
| `lib/workspaces/shared/...` | `lib/foundation/...` lub `lib/features/<feature>/...` | Przenieść tylko po potwierdzeniu braku zależności domenowej. |

Kolejność techniczna pojedynczego przeniesienia: (1) znaleźć wszystkie
importy i testy, (2) utworzyć docelowy port/model, (3) zmienić importy w całym
zamkniętym poddrzewie, (4) uruchomić analyze/test tego poddrzewa, (5) dopiero
usunąć stary plik i podłączyć composition root. Nie robić masowego rename’u
`lib/workspaces` bez przejścia tych bramek.

Nie przenosimy plików metodą „kopiuj i poprawiaj importy później”. Każdy plik
może zostać przeniesiony dopiero po zamknięciu importów do lokalnych domen i
po przejściu analizy pakietu. Import `ready_next`, Core, DataBus lub starego
hosta nie może trafić do nowej ścieżki runtime.

## Reguły jakościowe dla każdego batcha

1. Najpierw kontrakt domenowy i test, następnie adapter data, potem Cubit/state,
   na końcu widget i integracja z routerem/shellem.
2. UI nie zna Dio, Retrofit, tokenów, cookies, CSRF, SignalR ani storage.
   Wszystkie żądania przechodzą przez port/repository złożony w composition
   root.
3. Błędy są typowane (`ApiError`/kod domenowy); tekst użytkownika powstaje
   wyłącznie w presentation przez ARB. Data/domain nie zawierają komunikatów
   UI.
4. Jeden Cubit ma jedną odpowiedzialność. Nie tworzyć „god Cubitów”,
   globalnego mutable state, globalnych funkcji ani logiki biznesowej w UI.
5. Logika biznesowa ma być w domain/use case albo w adapterze repository,
   nie w callbackach widgetu. Nawigacja należy do routera/shella, nie Cubita.
6. Widget produkcyjny ma mniej niż 400 linii. Większy widok dzielić na
   małe prywatne komponenty lub podfeature.
7. Każdy batch ma testy portu, stanu błędnego/pustego, happy path oraz test
   integracji composition/routera, jeśli dodaje nową ścieżkę.
8. Po każdym batchu uruchomić `dart format`, kontrolowany `flutter analyze`,
   testy zakresu i `git diff --check`. Nie robić commit/push z poziomu agenta.

## Kolejność nadrzędna

Kolejność jest celowa: najpierw stabilna powłoka i menu, potem funkcje
workspace, a Chat/Notifications dopiero na końcu.

### Batch 0 — inwentaryzacja i blokada legacy

- Spisać aktualne importy oraz realne ekrany dostępne z root routera.
- Oznaczyć pliki starego dashboardu/BHP, Ready/Core/DataBus i osobnych
  backendów jako nieosiągalne runtime; nie przenosić ich do nowego drzewa.
- Zdefiniować listę tras i portów, które pozostają w standalone.
- Dodać raport z komendami bazowymi: `flutter analyze`, testy i `git diff
  --check`. Ten batch nie zmienia zachowania użytkownika.

### Batch 1 — shell, boczne menu i overlay host

To jest pierwszy pakiet implementacyjny.

- Zbudować nowy `app/shell` zgodnie z `gmail-inspired-design-spec.md`:
  stała górna belka o jawnej wysokości 64 logical px i zawsze zarezerwowanej
  geometrii, menu po lewej z trybem zwiniętym (64–72 px) i rozwiniętym
  (około 256 px), oraz obszar treści jako jedna zaokrąglona powierzchnia
  (promień około 20 px, margines 12–16 px).
- Utrzymać ramę: tło/gradient → top bar → sidebar + content → opcjonalna
  utility rail. Content nie może być przykryty przez belkę, modale ani panele.
- Użyć istniejącego lokalnego Inter, skali spacing 4/8/12/16/24 i typografii
  z tabeli specyfikacji; nie deklarować użycia Google Sans/Roboto i nie
  pobierać fontów z sieci.
- Wydzielić semantyczne tokeny jasnego/ciemnego motywu: backdrop turkusowy,
  content surface, toolbar, elevated surface, content/navigation text,
  accent, separator oraz stany. Oprzeć selected/hover menu o overlay nad
  tłem i sprawdzić kontrast minimum 4.5:1.
- Theme tokens (kolory, typografia, odstępy, promienie, cienie) trzymać w
  `foundation/theme`; jasny i ciemny motyw muszą korzystać z tych samych nazw
  semantycznych, bez kolorów rozsianych po widgetach.
- Menu jest częścią shellu, nie osobnym modułem legacy. Elementy bez realnego
  ekranu nie są klikalne ani nie prowadzą do placeholdera.
- Przygotować jeden lokalny `OverlayHost` w shellu: panel otwiera się nad
  obszarem treści, nie przykrywa zarezerwowanej górnej belki, zachowuje URL,
  ma fokus, zamyka się przez Escape i kliknięcie poza panelem.
- Chat i Notifications mają być prawymi overlayami poniżej belki, a nie
  głównymi trasami. Otwarcie nie zmienia wybranego projektu, URL, filtrów ani
  edycji. Utility rail może zawierać tylko realne, działające funkcje.
- Przetestować zwijanie menu, zmianę trasy bez utraty shellu, desktopowe
  szerokości oraz otwarcie/zamknięcie overlay.

### Batch 2 — Tasks i Kanban

- Wydzielić `tasks/domain`, `tasks/data`, `tasks/presentation` oraz osobny
  podfeature `tasks/kanban`.
- Najpierw ustalić lokalne modele, porty listy/edycji i kontrakt kolumn,
  potem adapter HTTP; żadnego mapowania backendu w widgetach.
- Kanban ma mieć osobny Cubit dla listy/filtrów i osobny owner dla operacji
  drag-and-drop. Aktualizacja kolejności musi być idempotentna i mieć typed
  failure/retry.
- Dodać trasy dopiero gdy ekran ma realny gateway. Menu wskazuje te trasy
  dopiero po ich akceptacji; brak placeholderów.
- Testy: parser DTO, repository, Cubit, pusta lista/błąd, przełączanie kolumn,
  reorder i test routingu desktop.

### Batch 3 — Files i dokumenty

- Utrzymać `files` jako feature workspace, z osobnym domain portem dla listy,
  folderów, wersji i autoryzowanego download/upload.
- Storage client, ticket uploadu, skan AV i OnlyOffice pozostają w data;
  presentation dostaje tylko typed state i bezpieczne akcje.
- Dodać własne overlay/modale w hostcie shellu, zawsze z rezerwacją miejsca,
  fokus trapem, Escape i l10n. Nie przywracać starego modułu Storage jako
  osobnej aplikacji.
- Testy: ACL/403, upload cancellation, błędna odpowiedź, wersjonowanie,
  render listy i desktopowy przepływ otwarcia pliku.

### Batch 4 — Chat jako globalny panel

- Chat nie jest osobną trasą ani ekranem root. Jest feature overlayu
  wywoływany z każdego miejsca przez shell/overlay host, zawsze pod stałą
  belką i w zarezerwowanej strefie prawej krawędzi.
- Użyć zmigrowanego `ChatRepository` i `ChatApi` z sesyjnym
  `DevPlannerHttpTransport`. Composition root przekazuje presentation tylko
  typed port.
- Minimalny pion panelu: lista rozmów, otwarcie rozmowy, historia i wysyłka.
  Stan błędny/pusty/retry musi być typowany i lokalizowany przez ARB.
- URL bieżącej strony nie może się zmienić. Panel nie może zasłaniać topbara;
  przy zamknięciu przywrócić fokus do przycisku otwierającego.
- Realtime SignalR, wątki, załączniki, reakcje i file-chat dodawać dopiero po
  stabilizacji REST panelu jako osobne podfeature, każde z własnym portem.

### Batch 5 — Notifications jako panel

- Notifications również nie tworzy placeholderowej trasy. Otwiera się w tym
  samym shell overlay host po prawej stronie, z własnym Cubitem listy/oznaczania i własnym
  repository portem.
- Rozdzielić REST listy od realtime SignalR; brak tokenu/transportu oznacza
  typed unavailable, nie anonimowe żądanie.
- Dodać filtry, unread count i deep-link do realnego zasobu dopiero po
  zatwierdzeniu kontraktu. Testy obejmują read/unread, empty/error i Escape.

### Batch 6 — finalizacja i usuwanie śmieci

- Po migracji wszystkich potrzebnych feature usunąć nieosiągalne pliki BHP,
  stary dashboard, legacy composition oraz importy Ready/Core/DataBus.
- Wykonać skan `rg` po `lib` i testach: `ready_next`, `coreUserId`, `DataBus`,
  stare hosty i nieużywane endpointy nie mogą występować w standalone runtime.
- Uruchomić pełny analyze/test/build macOS oraz ręczny desktop smoke test:
  login, shell/menu, Tasks/Kanban, Files, panel Chat i panel Notifications.
- Udokumentować znane ograniczenia i dopiero po zielonej walidacji uznać
  refaktoryzację za gotową do ręcznego review.

## Bramka akceptacyjna batcha

Batch można przekazać dalej tylko jeśli: nie ma nowych importów legacy,
composition jest typed, UI nie wykonuje API, teksty są w ARB, widgety mają
poniżej 400 linii, testy zakresu przechodzą, `flutter analyze` zakresu nie
zgłasza błędów, `git diff --check` jest czysty, a raport zawiera dokładne
komendy i wynik.
