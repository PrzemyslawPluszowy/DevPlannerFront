# Plan integracji menu Workspace w Flutterze

## Status

- [x] Grupowanie `Zadania → Lista/Kanban/Automatyzacje`.
- [x] Automatyczne rozwijanie aktywnego workspace’u przy wejściu.
- [x] Zachowanie ręcznego zwijania workspace’u.
- [x] Widoczna akcja dodania projektu i akcje `+` przy sekcjach menu.
- [x] Obsługa wielu whiteboardów w drzewie menu.
- [x] Walidacja `flutter analyze` oraz testów menu.
- [ ] Implementacja właściwych ekranów domenowych — poza zakresem tego planu.

## Cel

Uporządkować menu po wejściu do workspace'u i konkretnego projektu. Zakres
tego planu obejmuje wyłącznie menu, drzewo nawigacji, routing oraz stany
potrzebne do jego poprawnego renderowania.

Nie budujemy w ramach tego planu widoków Lista, Kanban, Automatyzacje,
Whiteboard, Wiki, Pliki ani Tablica korkowa. Menu ma jedynie prowadzić do
odpowiednich tras i prezentować dostępne zasoby.

## Docelowa hierarchia menu

```text
Workspace
  Projekty
    Projekt
      Zadania
        Lista
        Kanban
        Automatyzacje
      Whiteboardy
        Whiteboard 1
        Whiteboard 2
      Wiki
      Pliki
      Tablica korkowa
```

### Zasady informacji

- `Zadania` jest jedną sekcją projektu.
- `Lista`, `Kanban` i `Automatyzacje` są zakładkami/podpozycjami tej sekcji,
  a nie trzema niezależnymi modułami głównego menu.
- Lista i Kanban odnoszą się do tego samego zbioru zadań, ale są różnymi
  ścieżkami nawigacji.
- Automatyzacje pozostają osobną podzakładką funkcjonalną związaną z zadaniami.
- `Whiteboardy` jest sekcją mnogą. Projekt może zawierać wiele whiteboardów.
- `Wiki`, `Pliki` i `Tablica korkowa` pozostają osobnymi sekcjami projektu.
- Tablica korkowa jest obecnie pojedynczym zasobem projektu; menu nie powinno
  udawać listy wielu tablic, dopóki kontrakt domenowy tego nie przewiduje.

## Zakres implementacji Flutter

### 1. Model menu

Wprowadzić osobne typy dla struktury menu, bez mieszania ich z DTO API:

```dart
enum ProjectMenuGroup {
  work,
  whiteboards,
  wiki,
  files,
  corkboard,
}

enum ProjectWorkTab {
  list,
  kanban,
  automations,
}
```

`ProjectResourceKind` może nadal opisywać zasoby ładowane z backendu.
Grupowanie `Zadania → Lista/Kanban/Automatyzacje` powinno być odpowiedzialnością
warstwy menu, a nie repository.

### 2. Zachowanie menu

- Workspace jest rozwijany dopiero po wybraniu go przez użytkownika.
- Projekty są ładowane leniwie po rozwinięciu workspace'u.
- Zasoby projektu są ładowane dopiero po rozwinięciu konkretnego projektu.
- Każda kosztowna gałąź ma własny lokalny Cubit.
- Rozwinięcie jednej gałęzi nie może uruchamiać zapytań dla pozostałych gałęzi.
- Aktywny element menu wynika z bieżącej trasy, nie z lokalnego `setState`.
- Stan rozwinięcia może być lokalny dla widgetu menu, ale stan dostępu,
  zasobów i błędów pozostaje w Cubitach.
- `ExpansionTile` nie używamy; stosujemy istniejący shared widget `Expansible`.

### 3. Puste stany menu

Puste stany powinny pokazywać akcję kontekstową, ale nie otwieramy w tym planie
żadnego właściwego widoku domenowego:

- brak projektów: `Utwórz pierwszy projekt`,
- brak whiteboardów: `Dodaj whiteboard`,
- brak plików: `Dodaj plik` albo `Utwórz folder`,
- brak automatyzacji: `Utwórz automatyzację`,
- brak kart tablicy korkowej: `Dodaj karteczkę`.

Akcje mogą na tym etapie prowadzić do istniejącej trasy, otwierać uzgodniony
dialog albo emitować typowaną intencję do warstwy nadrzędnej. Nie implementujemy
w tym zadaniu formularzy ani ekranów tworzenia.

Pusty stan nie może oznaczać błędu. Stany `401`, `403`, `404` i pozostałe
błędy backendu muszą być prezentowane osobno, zgodnie z komunikatem API.

## Routing

Menu powinno używać tych samych kontekstowych tras z `workspaceId` i
`projectId`:

```text
/workspaces/{workspaceId}/projects/{projectId}/tasks
/workspaces/{workspaceId}/projects/{projectId}/kanban
/workspaces/{workspaceId}/projects/{projectId}/automations
/workspaces/{workspaceId}/projects/{projectId}/whiteboards/{whiteboardId}
/workspaces/{workspaceId}/projects/{projectId}/wiki/{pageId}
/workspaces/{workspaceId}/projects/{projectId}/files/{folderId-or-fileId}
/workspaces/{workspaceId}/projects/{projectId}/corkboard
```

Zakładka `Zadania` może domyślnie otwierać `/tasks`. Kliknięcie `Kanban` albo
`Automatyzacje` zmienia trasę, ale nie zmienia nadrzędnej sekcji menu.

Router musi:

- odtwarzać kontekst z URL po odświeżeniu Web,
- odrzucać niepoprawne UUID,
- poprawnie obsługiwać Back/deep link,
- zaznaczać aktywną zakładkę na podstawie bieżącej trasy.

## Zasady architektury aplikacji i AI

### Dokumentacja jako kontrakt

- [workspace-navigation-product-spec.md](workspace-navigation-product-spec.md)
  jest źródłem prawdy dla hierarchii i zachowania menu.
- Ten plik opisuje kolejność integracji i ograniczenie zakresu do menu.
- Swagger/OpenAPI backendu jest jedynym źródłem nazw tras, parametrów, typów
  i uprawnień. Nie zgadujemy kontraktów na podstawie nazw w UI.
- Każda zmiana menu powinna aktualizować odpowiednią dokumentację produktu,
  plan implementacji i testy akceptacyjne.
- Dokumentacja techniczna ma jasno rozdzielać: model menu, routing, kontrakt
  API, stan Cubita i zachowanie widgetu.
- AI nie powinno dopisywać widoków domenowych tylko dlatego, że menu posiada
  link do danej sekcji.

### Zasady dla aplikacji

- Widgety menu są prezentacyjne; nie wywołują HTTP ani klienta realtime.
- Przepływ ma mieć postać: API client → repository → Cubit → widget.
- Stany Cubitów muszą być jawne i niemutowalne: `loading`, `loaded`, `empty`,
  `unauthorized`, `forbidden`, `failure`.
- `ProjectWorkTab` jest stanem nawigacji menu/sekcji, nie stanem widoku Kanbana
  ani listy zadań.
- Teksty widoczne dla użytkownika pochodzą z `intl`/ARB i `context.l10n`.
- Ikony menu pochodzą z `AppIcons`.
- Nie logujemy JWT, presigned URL-i, danych prywatnych ani treści zasobów.
- SuperAdmin nie otrzymuje automatycznie dodatkowych pozycji menu bez
  potwierdzonego dostępu zwróconego przez backend.
- Nie tworzymy globalnego Cubita menu dla całej aplikacji; zakres Cubita ma
  odpowiadać workspace'owi, projektowi albo konkretnej gałęzi.
- Na Web i desktopie zachowujemy tę samą hierarchię, trasy i akcje.
- Nie używamy `dart:html`; różnice platformowe zamykamy w abstrakcjach.

## Kolejność prac

1. Ujednolicić hierarchię menu w `workspace_project_menu.dart`.
2. Zgrupować `Lista`, `Kanban` i `Automatyzacje` pod jedną sekcją `Zadania`.
3. Zachować listę wielu whiteboardów pod sekcją `Whiteboardy`.
4. Dodać `ProjectWorkTab` oraz mapowanie aktywnej trasy na zakładkę.
5. Dodać brakującą pozycję `Tablica korkowa` jako pojedynczą sekcję projektu.
6. Uzupełnić puste stany i same intencje akcji `Dodaj/Utwórz`, bez budowania
   ekranów docelowych.
7. Przenieść wszystkie teksty menu i pustych stanów do ARB.
8. Uzupełnić testy widgetów, routingu i stanów błędów.
9. Zweryfikować menu przy szerokości web 1280 px oraz na macOS desktop.

## Kryteria akceptacji

- Menu pokazuje `Zadania` jako jedną sekcję.
- `Lista`, `Kanban` i `Automatyzacje` są dostępne z jednego miejsca.
- Projekt może pokazywać wiele whiteboardów.
- Pusty katalog każdej obsługiwanej sekcji ma właściwy przycisk akcji.
- Pusty stan nie jest używany dla `401`, `403` ani błędów technicznych.
- Rozwijanie projektu nie ładuje niepotrzebnych danych przed rozwinięciem
  odpowiedniej gałęzi.
- Odświeżenie strony zachowuje workspace, projekt i aktywną zakładkę.
- Nie powstaje żaden nowy ekran domenowy w ramach tej integracji.
- Testy potwierdzają zachowanie menu na Web i desktopie.
