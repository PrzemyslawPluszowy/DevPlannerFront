# Nowe lewe menu DevPlanner — plan produktu i implementacji

Status: plan do akceptacji przed implementacją  
Data: 2026-09-19  
Zakres: Flutter `Front`; bez zmian kontraktów Backend w pierwszym etapie

## 1. Cel

Zbudować nowe lewe menu, które zachowuje użyteczność poprzedniego menu
Workspace, ale nie przywraca jego kodu ani wyglądu. Menu ma być czytelniejsze,
szybsze i spójne z obecną kompaktową ramą DevPlanner.

Najważniejszy rezultat:

```text
DevPlanner                         [kontekst] [motyw] [chat] [powiadomienia]
────────────────────────────────────────────────────────────────────────────
Przegląd
Moje zadania
Moje pliki

WORKSPACE'Y                                      [+]
▼ Nazwa workspace'u                         [•••]
  Pliki
  ▼ Projekty
    ▼ Nazwa projektu                         [•••]
      Zadania
        Lista
        Kanban
      Pliki

Ustawienia
Administracja — tylko po potwierdzeniu uprawnienia
```

Chat i Powiadomienia pozostają globalnymi panelami po prawej stronie. Nie są
trasami ani pozycjami drzewa.

## 2. Zasady projektowe

1. **Nowy komponent, stary zakres funkcji.** Nie kopiujemy historycznego menu,
   jego Cubitów ani importów Ready/Core. Wykorzystujemy aktualne porty domenowe,
   `GoRouter`, theme tokens i lokalizacje.
2. **Najpierw dane nadrzędne.** Po wejściu do aplikacji pobieramy wyłącznie
   listę workspace'ów. Projekty pobieramy dopiero po pierwszym rozwinięciu
   konkretnego workspace'u.
3. **Trasa jest źródłem zaznaczenia.** Aktywny workspace, projekt i widok są
   wyliczane z aktualnego URL. Odświeżenie strony lub deep link odtwarza
   rozwinięte gałęzie bez dodatkowego globalnego stanu.
4. **Brak pozornych funkcji.** Klikalne są tylko aktywne piony: Workspace,
   Tasks/Lista, Kanban i Files. Whiteboard, Wiki, Corkboard i Automatyzacje
   pojawią się jako linki dopiero razem z prawdziwą stroną, portem i testami
   ACL. Nie tworzymy pustych ekranów.
5. **Uprawnienia są danymi, nie dekoracją.** UI może ukrywać niedostępne akcje,
   lecz Backend nadal sprawdza ACL. Administracja jest pokazywana dopiero po
   zweryfikowanym `/me`, a nie wszystkim użytkownikom.
6. **Jedna odpowiedzialność na komponent.** Shell odpowiada za geometrię,
   kontroler drzewa za dane, mapper tras za URL, a dialogi akcji za formularze.

## 3. Docelowe zachowanie

### 3.1. Nagłówek i sekcja Workspace'y

- Nagłówek marki pozostaje częścią lewej kolumny.
- Pod pozycjami osobistymi pojawia się etykieta sekcji `WORKSPACE'Y`.
- Przycisk `+` otwiera nowy dialog tworzenia workspace'u.
- Po utworzeniu lista odświeża się, nowy workspace zostaje rozwinięty i
  aplikacja przechodzi na jego kanoniczną trasę.
- Puste konto pokazuje w menu krótki stan pusty i wyraźną akcję
  `Utwórz workspace` — nie sam przycisk ponownego pobrania.

### 3.2. Drzewo i lazy loading

- Workspace rozwija się natychmiast do pozycji `Pliki` i `Projekty`.
- Pierwsze rozwinięcie `Projekty` uruchamia jedno żądanie dla danego
  `workspaceId`.
- Każdy workspace ma niezależny stan projektów: `idle`, `loading`, `ready`,
  `empty`, `failure`.
- Błąd jednego workspace'u nie usuwa pozostałych gałęzi. Przy błędzie pojawia
  się lokalny przycisk `Spróbuj ponownie` z zachowaniem `traceId` w modelu
  błędu, bez ujawniania go w niepotrzebnych miejscach UI.
- Ponowne zwinięcie i rozwinięcie korzysta z cache sesji. Jawne odświeżenie lub
  mutacja projektu unieważnia tylko właściwą gałąź.
- Deep link do projektu automatycznie ładuje jego workspace i rozwija ścieżkę
  do aktywnego widoku.

### 3.3. Nawigacja

Kanoniczne cele pierwszej wersji:

| Pozycja | Trasa |
|---|---|
| Przegląd | `/workspaces` |
| Moje zadania | `/me/tasks` |
| Moje pliki | `/me/files` |
| Workspace | `/workspaces/:workspaceId` |
| Pliki workspace'u | `/workspaces/:workspaceId/files` |
| Projekt | `/workspaces/:workspaceId/projects/:projectId/tasks` |
| Lista | `/workspaces/:workspaceId/projects/:projectId/tasks` |
| Kanban | `/workspaces/:workspaceId/projects/:projectId/tasks?view=kanban` |
| Pliki projektu | `/workspaces/:workspaceId/projects/:projectId/files` |
| Ustawienia | `/me` |
| Administracja | `/admin` |

Wszystkie adresy buduje wyłącznie `DevPlannerRouteCatalog`. Widgety menu nie
sklejają URL-i samodzielnie.

### 3.4. Akcje kontekstowe

- Workspace: otwórz, odśwież projekty, edytuj, przypnij/odepnij, ukryj oraz
  ustawienia członków — tylko jeśli dana akcja ma działający kontrakt.
- Projekt: otwórz listę, Kanban lub pliki; dalsze akcje dopiero po podłączeniu
  ich pionów.
- Operacje destrukcyjne nie są wykonywane jednym przypadkowym kliknięciem.
  Archiwizacja/usunięcie wymaga osobnego potwierdzenia i czytelnego skutku.

## 4. Wygląd i interakcja

- Szerokość rozwinięta: `256 px`; zwinięta: `52 px` zgodnie z obecną ramą.
- Wiersz podstawowy: `32 px`, ikona `18 px`, typografia Inter `11 px`.
- Workspace i projekt mają mocniejszą hierarchię niż dzieci zasobów: nazwa,
  akcent aktywnego elementu i subtelna prowadnica drzewa zamiast wielu
  identycznych ikon.
- Stan wybrany używa powierzchni z tokenu theme, nie hardkodowanego koloru.
- Hover, focus, loading, błąd i disabled są wizualnie rozróżnialne w jasnym i
  ciemnym motywie.
- Rozwijanie ma krótką animację wysokości/obrotu chevrona, bez animowania całej
  listy przy każdym żądaniu.
- W trybie zwiniętym widoczne są pozycje najwyższego poziomu, a workspace'y są
  dostępne przez lekki flyout lub tooltip + kliknięcie otwierające aktualny
  workspace. Nie pokazujemy nieczytelnego drzewa o szerokości 52 px.
- Menu ma własny scroll; dolne ustawienia pozostają stabilne. Przy małej
  wysokości także dolna sekcja musi być osiągalna klawiaturą i scrollem.

## 5. Docelowy podział kodu

```text
lib/app/shell/navigation/
  devplanner_sidebar.dart
  sidebar_header.dart
  sidebar_personal_section.dart
  sidebar_workspace_section.dart
  sidebar_footer.dart
  sidebar_tree_item.dart
  sidebar_collapsed_flyout.dart

lib/workspaces/domain/navigation/
  workspace_navigation_node.dart
  workspace_navigation_tree.dart
  workspace_navigation_route.dart

lib/workspaces/presentation/navigation/
  cubit/workspace_navigation_cubit.dart
  cubit/workspace_navigation_state.dart
  widgets/workspace_branch.dart
  widgets/project_branch.dart
  widgets/navigation_branch_status.dart
  actions/workspace_navigation_actions.dart
```

`WorkspaceNavigationCubit` przechowuje listę workspace'ów i mapę stanów
projektów per `workspaceId`. Nie zna `BuildContext`, `GoRouter`, dialogów ani
widgetów. Lokalny stan hover/focus/rozwinięcia może pozostać w małych
kontrolerach UI, ale stan ładowania danych należy do Cubita.

## 6. Etapy realizacji

### Etap A — kontrakt i testy charakterystyczne

- Zamrozić tabelę tras i aktywny zakres funkcji.
- Dodać testy stanu drzewa dla oddzielnego ładowania workspace'ów i projektów.
- Dodać testy złego scope projektu, duplikatów ID, 401/403 i awarii pojedynczej
  gałęzi.

Kryterium: można zmienić UI bez ryzyka zmiany kontraktu danych lub adresów.

### Etap B — nowy model danych nawigacji

- Zastąpić eager loading wszystkich projektów lazy loadingiem per workspace.
- Zachować ostatni poprawny snapshot innych gałęzi przy lokalnym błędzie.
- Dodać deduplikację równoległych żądań i ochronę przed emisją po `close()`.
- Dodać `refreshWorkspace` i odświeżenie katalogu po mutacji.

Kryterium: start menu wykonuje jedno żądanie katalogu; rozwinięcie jednego
workspace'u wykonuje najwyżej jedno żądanie jego projektów.

### Etap C — nowa kompozycja wizualna

- Rozdzielić obecne pliki-part shella na małe publiczne komponenty katalogu
  `app/shell/navigation`.
- Dodać nagłówek sekcji, prowadnice drzewa, lokalne stany gałęzi i dopracowane
  active/hover/focus.
- Utrzymać obecną geometrię 40/256/52 oraz content canvas.

Kryterium: brak overflow dla 1024×768, 1280×800, 1440×900 i 1920×1080 oraz
skalowania tekstu 100%, 125% i 150%.

### Etap D — tworzenie workspace'u

- Wydzielić wąski `WorkspaceManagementGateway` albo use case tworzenia;
  shell nie może zależeć od dużego historycznego `WorkspacesRepository`.
- Podłączyć istniejący formularz wizualny do nowego use case'u lub przepisać
  samą kompozycję dialogu bez przenoszenia starego Cubita ekranu katalogu.
- Po sukcesie odświeżyć katalog, rozwinąć i otworzyć utworzony workspace.
- Obsłużyć walidację, konflikt, brak uprawnień i błąd sieci bez zamykania
  dialogu oraz bez podwójnego wysłania.

Kryterium: utworzenie workspace'u działa z lewego menu, a nowa pozycja pojawia
się bez restartu aplikacji.

### Etap E — routing, collapsed mode i dostępność

- Automatycznie rozwijać przodków aktywnej trasy.
- Zbudować czytelny tryb zwinięty/flyout bez utraty klawiatury i tooltipów.
- Dodać semantykę drzewa, kolejność Tab, Enter/Space, strzałki, Escape i powrót
  fokusu po zamknięciu menu/dialogu.
- Nie zmieniać URL przy samym rozwijaniu i zwijaniu gałęzi.

Kryterium: deep link, Back/Forward, refresh web i desktop prowadzą do tego
samego zaznaczenia.

### Etap F — akcje zarządzania i dalsze piony

- Dopiero po odbiorze podstawy dodać menu `•••` workspace/projekt.
- Edit/pin/hide/members implementować pionami z prawdziwym kontraktem.
- Whiteboard/Wiki/Corkboard/Automations dodawać osobno: port → adapter → Cubit
  → page → route → menu → test ACL.

Kryterium: żadna pozycja nie jest klikalnym placeholderem.

## 7. Testy i bramki odbioru

### Automatyczne

- Cubit: lazy loading, cache, retry, refresh, race conditions, close lifecycle.
- Widget: expand/collapse, aktywna trasa, loading/empty/error per gałąź,
  tworzenie workspace'u, collapsed mode, keyboard/focus i brak overflow.
- Router: wszystkie kanoniczne URL-e, UUID validation, deep link, query Kanban,
  brak tras Chat/Notifications i brak martwych pionów.
- Autoryzacja: 401/403, admin widoczny dopiero po `/me`, brak eskalacji przez
  samo UI.
- Motywy i responsywność: light/dark, 100/125/150% tekstu.

Minimalne polecenia odbioru:

```bash
dart format <zmienione pliki>
flutter analyze
flutter test test/workspaces/presentation/navigation
flutter test test/app/shell test/app/router
flutter build web --wasm
flutter build macos --debug
git diff --check
```

### Manualne

1. Konto bez workspace'u → utworzenie pierwszego workspace'u.
2. Konto z wieloma workspace'ami → projekty ładowane tylko dla rozwiniętego.
3. Deep link do Lista/Kanban/Files → prawidłowo rozwinięte i zaznaczone menu.
4. Błąd projektów jednego workspace'u → pozostałe menu nadal działa.
5. Jasny/ciemny motyw, małe okno, 125/150% tekstu i obsługa tylko klawiaturą.
6. Chat/Powiadomienia otwierają overlay bez zmiany bieżącej trasy i drzewa.

## 8. Definition of Done

Menu można uznać za gotowe, gdy:

- ma parytet aktywnych funkcji poprzedniego menu bez importowania starej
  implementacji;
- tworzenie workspace'u działa z menu i odświeża drzewo;
- projekty są ładowane leniwie, izolowane per workspace i odporne na błędy;
- każda klikalna pozycja prowadzi do rzeczywistej strony;
- stan wybrany jest zgodny z URL po refreshu i deep linku;
- UI jest czytelne w obu motywach, trybie rozwiniętym/zwiniętym i przy 150%
  tekstu;
- testy routingu, shella, Cubita i uprawnień przechodzą;
- dokumenty planu i handoff w obu repozytoriach są zsynchronizowane dopiero po
  faktycznej implementacji i uruchomieniu zapisanych bramek.

## 9. Poza pierwszym zakresem

- zmiana Backend API bez wykazanego braku kontraktu;
- przywracanie starego menu albo dawnych tras Ready/Core;
- osobne ekrany Chat i Notifications;
- placeholdery Whiteboard/Wiki/Corkboard/Automations;
- duży wspólny Cubit obejmujący shell, routing, dane i formularze;
- deklarowanie E2E bez uruchomienia aplikacji z Backendem i realną sesją.
