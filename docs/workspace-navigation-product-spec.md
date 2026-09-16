# Workspace navigation — decyzje produktu i UI

Ten dokument jest źródłem prawdy dla menu Workspace w Ready Next. Opisuje
ustalenia produktowe, które mają pozostać spójne przy kolejnych modułach i
refaktorach. Dokumentacja techniczna implementacji znajduje się w
`docs/ai-ui-architecture-guidelines.md`.

## Model dostępu

- Workspace nie jest modułem tylko dla administratora. Każdy uwierzytelniony
  użytkownik z aktywnym członkostwem widzi workspace, do którego należy.
- SuperAdmin z uprawnieniem `bswfms.custom_modules.RNext-admin` ma bypass
  członkostwa zgodnie z backendem.
- Nie tworzymy sztucznego uprawnienia `RNext-workspaces`; frontend nie może
  ukrywać workspace na podstawie niepotwierdzonego permission stringa.
- Błędy 401/403 i komunikaty backendu pokazujemy jawnie. Nie stosujemy
  cichego fallbacku do pustej listy.

## Hierarchia menu

Menu ma przedstawiać kontekst pracy, nie listę przypadkowych modułów:

```
Workspace
  Projekt (ładowany dopiero po rozwinięciu)
    Zadania
    Kanban
    Whiteboardy
    Wiki
    Pliki
    Automatyzacje
Prywatne
  elementy prywatne użytkownika (osobna gałąź, gdy backend je udostępnia)
```

Chat nie należy do menu workspace. Jest funkcją globalną otwieraną z górnego
paska jako drawer/overlay. Powiadomienia również są globalne.

Jeśli użytkownik nie ma żadnego workspace, ekran pokazuje jeden główny,
wyraźny przycisk „Utwórz swój pierwszy workspace” oraz opis korzyści. Nie
renderujemy pustego drzewa ani nie udajemy, że moduły są niedostępne z powodu
błędu.

## Zachowanie i responsywność

- Rail globalny ma 56 px w stanie zwiniętym i rozwija się do około 220 px jako
  overlay nad treścią; rozwinięcie nie przesuwa panelu workspace.
- Panel workspace można zwijać ręcznie. Aktywny workspace jest domyślnie
  rozwinięty, pozostałe są zwinięte.
- Do rozwijania używamy `Expansible` i własnego shared widgetu, nigdy
  `ExpansionTile`.
- Małe szerokości mają osobny, kompaktowy wariant katalogu, ale zachowują te
  same ścieżki routingu i akcje.
- Górny pasek jest globalny (macOS/web): kontekst, powiadomienia, chat i
  przyszłe akcje. Drawery mają animację, focus/escape/outside-dismiss i
  korzystają z Material Theme oraz przezroczystości/gradientów bez łamania
  kontrastu.

## Routing i deep linki

Każdy element zasobu ma adres zawierający `workspaceId`, `projectId` i
identyfikator zasobu, gdy backend go zwraca. Powiadomienie może otworzyć
konkretny workspace, projekt, zasób, rozmowę albo wiadomość. Router odrzuca
niepoprawne UUID i zewnętrzne ścieżki. Po odświeżeniu strony kontekst jest
odtwarzany z URL, a nie z lokalnego stanu widgetu.

## Reguły implementacyjne

- API wywołują wyłącznie repository/cubity; widgety są prezentacyjne.
- Projekty i zasoby są ładowane leniwie. Każdy kosztowny podkatalog ma lokalny
  Cubit, a nie globalny „boski” Cubit.
- Stany sealed class są jawne: loading, loaded/empty, unauthorized,
  forbidden i failure. `close()` wykonujemy przed końcowym `emit` w asynchronicznych
  ścieżkach.
- Widgety utrzymujemy w pobliżu 300 linii; duże rail/drawery dzielimy na
  osobne pliki. Wspólne rozszerzenia i klasy pomocnicze trafiają do
  `lib/workspaces/shared/helpers`.
- Ikony pochodzą z jednego adaptera `AppIcons` (Lucide), dzięki czemu można
  zmienić bibliotekę bez zmian w modułach.

## Kryteria akceptacji wizualnej

Menu ma być zwarte i czytelne przy dużej liczbie danych: neutralna powierzchnia,
subtelne obramowania, jeden wyraźny akcent aktywnego elementu, tooltipy w
trybie ikonowym, brak pionowych napisów i brak ciężkich kart. Inspiracja:
ClickUp/Monday/Asana, ale bez kopiowania 1:1. Weryfikujemy web 1280 px oraz
macOS desktop, a testy widgetów potwierdzają overlay railu i rozwijanie
projektów.
