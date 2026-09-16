# Workspaces Files — audyt i plan wdrożenia Flutter

Status: plan wykonawczy po audycie backendu i klienta z 2026-09-09.

## Handoff — stan roboczy po ostatniej sesji (2026-09-09)

To jest pierwsza sekcja, którą powinien przeczytać kolejny agent. Stan poniżej
jest oparty na bieżącym kodzie i wykonanych komendach; starsze checkboxy dalszej
części dokumentu nie zastępują tej bramki odbiorowej.

### Zrobione i zweryfikowane

- [x] Utworzenie dokumentu: backend `POST /api/v1/storage/files/create` ma
  allowlistę TXT, DOCX, XLSX, PPTX, ODT, ODS i ODP, generuje poprawne minimalne
  pakiety po stronie serwera, zachowuje zakres private/workspace/project,
  opcjonalny placement folderu, audyt i bezpieczne statusy Ready/Clean.
  Flutter udostępnia lokalizowany picker formatu w tych trzech zakresach i po
  sukcesie otwiera nowy plik przez istniejący preview/OnlyOffice.

- Backend zwraca capabilities `canPreview`, `canEditOnline`, `canDownload`,
  `canManageVersions`, `canRestore` i `canConvertToPdf`. Wspólna
  `StorageFileCapabilityPolicy` uwzględnia ACL, usunięcie, processing `Ready`,
  skan `Clean` oraz macierz formatów. Załączniki Tasks korzystają z tej samej
  polityki.
- Explorer ma scope private/workspace/project, routing/deep link, foldery,
  breadcrumbs, cursor pagination, debounce z ochroną przed starymi wynikami,
  zaznaczanie i operacje częściowe, upload/download, kosz, wersje i sharing.
- Podgląd obrazu, PDF (`pdfrx` z Range), audio/wideo (`media_kit`) i tekstu
  (stream z limitem 1 MiB) jest osadzony. Nie ma `dart:html`.
- Sharing wyszukuje użytkowników katalogu Ready przez osobny Cubit. Link
  publiczny obsługuje hasło, wygaśnięcie, pełny URL oraz anonimową trasę
  `/storage/public/:shareToken`, która wymienia token na download ticket.
- Przed rozpoczęciem ostatniej zmiany OnlyOffice potwierdzono na Flutter 3.47.2:
  `flutter analyze`, 40/40 testów Storage, Web/Wasm build i macOS debug build.
  Backendowy filtr Storage/OnlyOffice: 154/154 testów.

### Ostatnia zmiana — osadzony OnlyOffice (walidacja lokalna zakończona)

- Dodano `webview_all 1.4.1` i
  `StorageOnlyOfficeHost`, który ładuje HTML z podpisaną konfiguracją backendu
  wewnątrz pełnoekranowego dialogu. Usunięto poprzedni launcher otwierający
  osobne okno. Adapter ma loading, błąd zasobu głównego i retry.
- `StorageOnlyOfficeHost` ma wstrzykiwalny, typowany adapter kontrolera. Test
  widgetowy pokrywa loading, błąd zasobu głównego i retry bez uruchamiania
  natywnego WebView.
- Po tej zmianie: `flutter analyze` PASS, testy Storage 41/41 PASS,
  `flutter build web --wasm` PASS i `flutter build macos --debug` PASS.
- Workflow Linux instaluje `libwebkit2gtk-4.1-dev`, wymagane przez
  `webview_all_linux`. Natywne buildy/testy Linux i Windows nadal muszą zostać
  wykonane przez właściwe runnery; nie wolno uznać D4/F za zakończone na
  podstawie lokalnej walidacji macOS.
- Rozpoczęto audyt Etapu E: usunięto bezpośrednie polskie teksty z dialogu
  błędu sesji OnlyOffice i wierszy aktywnych udostępnień, a etykieta korzenia
  breadcrumbs jest teraz lokalizowana w warstwie widgetu dla każdego scope'u.
  Test widgetowy potwierdza angielski wariant korzenia. Po regeneracji l10n
  analyzer i testy Storage nadal przechodzą.
- Pełny pakiet 43 testów Storage przechodzi również w rzeczywistym Chrome dla
  obu kompilacji: JavaScript (`flutter test --platform chrome`) i WebAssembly
  (`flutter test --wasm --platform chrome`). Test `TextPreviewLoader` został
  przeniesiony z niedostępnego w Wasm `dart:io`/`HttpServer` na kontrolowany,
  strumieniowy `ResponseBody` wstrzykniętego Dio; nadal sprawdza limit bajtów
  oraz wymuszenie `ResponseType.stream`.
- Test responsywności obejmuje teraz zmianę szerokości 720→1280 px. Wykrył i
  zabezpiecza naprawę dwóch realnych overflowów: kompaktowy sidebar nie używa
  już `ListTile` w przestrzeni 40 px, a licznik elementów kafla folderu ma
  kontrolowane `maxLines` i ellipsis. Ten scenariusz przechodzi na VM i Wasm.
- Pełny `flutter test` nadal kończy się 24 błędami poza Storage (Tasks/Kanban):
  694 testy zaliczone, 4 pominięte. Etap F pozostaje z tego powodu otwarty.

### Następne kroki w obowiązkowej kolejności

1. Uruchomić zmieniony pipeline na prawdziwych runnerach Linux i Windows.
   Linux ma już instalację WebKitGTK 4.1; na Windows potwierdzić obecność
   WebView2 Runtime oraz build i uruchomienie osadzonego hosta.
2. Wykonać smoke-test z rzeczywistym OnlyOffice Document Server: view/edit,
   callback tworzący wersję, reconnect, wygasły JWT, odebrane ACL i zamknięcie
   widoku. Sprawdzić CSP/CORS/frame policy dla produkcyjnych originów.
3. Dopiero po tych dowodach zmienić D4/Etap 8 i Etap F na `[x]`. Następnie
   przejść przez otwarte punkty Etapu E i pełny `flutter test`; istniejące
   błędy Tasks/Kanban są osobnym problemem, ale pełny gate nadal pozostaje
   niespełniony.

### Ważne ograniczenia konfiguracji

- Target: Flutter 3.47.2 / Dart 3.13.2. Warstwa webowa ma używać wyłącznie
  `dart:js_interop`/`package:web`; zakaz dodawania `dart:html`.
- Pełny link publiczny na desktopie wymaga
  `--dart-define=PUBLIC_APP_BASE_URL=https://...`; Web/Wasm używa `Uri.base`.
- `media_kit` nadal zgłasza ostrzeżenie o braku Swift Package Manager na macOS;
  aktualny build CocoaPods działał przed dodaniem WebView.

## 0. Plan napraw po code review

Poniższa kolejność jest obowiązkowa; kolejny etap zaczynamy dopiero po
przejściu testów etapu wcześniejszego.

- [x] Etap A — bezpieczeństwo: capability zaznaczenia, gating akcji per scope,
  poprawny wynik placementu i typowane anulowanie uploadu.
- [x] Etap B — dane i nawigacja: foldery potomne, pełne breadcrumbs, scope
  workspace/projekt w routingu oraz odtwarzanie kontekstu z URL.
- [x] Etap C — spójność stanu: debounce i ochrona przed starymi odpowiedziami,
  infinite scroll, odświeżanie po mutacjach i wyniki częściowe.
- [ ] Etap D — funkcje użytkowe: rzeczywisty preview, sharing z kompletnym
  linkiem i katalogiem użytkowników, wersje oraz prawdziwy klient OnlyOffice.
- [ ] Etap E — jakość UI: pełne l10n, shared widgets, responsywność, focus,
  skróty klawiaturowe oraz menu kontekstowe spójne z Tasks/Kanban.
- [ ] Etap F — platformy: analyze, testy Storage i całego projektu, Web/Wasm,
  macOS oraz pipeline Windows. Build na jednej platformie nie zamyka etapu.

Stan weryfikacji 2026-09-09:

- `flutter analyze` — bez problemów,
- testy Flutter Storage — 36/36 zaliczone,
- `flutter build macos --debug` — zaliczony,
- `flutter build web` wraz z Wasm dry-run — zaliczony,
- testy backendu — 857 zaliczonych, 3 świadomie pominięte, 0 błędów,
- pełne `flutter test` — 24 błędy w istniejącym pakiecie Tasks/Kanban; testy
  Storage w tym samym przebiegu są zielone,
- workflow CI obejmuje teraz Storage oraz buildy Linux, Windows, macOS, Web i
  Web/Wasm. Etap F pozostaje otwarty do uzyskania zielonego pełnego pakietu i
  wykonania pipeline na natywnym runnerze Windows.

### Dziennik kontynuacji — 2026-09-09

- [x] D1 — kontrakt capabilities pliku został domknięty w backendzie C# i
  Flutterze (`canPreview`, `canEditOnline`, `canDownload`,
  `canManageVersions`, `canRestore`, `canConvertToPdf`). Backend wylicza flagi
  z efektywnych uprawnień oraz wspieranej macierzy formatów, a Flutter blokuje
  podgląd, gdy `canPreview` jest fałszywe.
- [x] D1 — ODT/ODS/ODP zostały włączone do rozpoznawania dokumentów
  OnlyOffice po stronie klienta zgodnie z istniejącą macierzą backendu.
- [x] D1 — dowody: test OpenAPI backendu rozszerzony o nowe pola; test
  deserializacji Fluttera zabezpiecza przeniesienie wszystkich capabilities.
  Po zmianie testy Storage Flutter: 35/35 PASS; testy backendu filtrowane dla
  Storage OpenAPI/HTTP/OnlyOffice: 29/29 PASS.
- [x] D2 — zewnętrzne otwieranie PDF/audio/video/text zastąpione rzeczywistym
  podglądem: `pdfrx` korzysta z HTTP Range, `media_kit` streamuje audio/wideo,
  a tekst jest czytany strumieniowo przez port domenowy z limitem 1 MiB.
  Warstwa webowa nie używa `dart:html`; target pozostaje zgodny z
  `dart:js_interop`/`package:web` i Flutter 3.47.2.
- [x] D2 — capabilities zostały przeniesione do wspólnej polityki backendowej,
  która blokuje odczyt plików usuniętych, niegotowych lub bez wyniku AV Clean;
  endpoint załączników Task korzysta z tej samej polityki.
- [x] D2 — dowody: `flutter analyze` PASS, Storage Flutter 36/36 PASS,
  `flutter build web --wasm` PASS, `flutter build macos --debug` PASS oraz
  backend Storage/capabilities/OpenAPI/OnlyOffice 33/33 PASS. Build macOS
  raportuje ostrzeżenie upstream o braku Swift Package Manager w pluginach
  `media_kit`; aktualny build CocoaPods działa i ostrzeżenie należy ponownie
  zweryfikować przy aktualizacji toolchainu/pluginu.
- [x] D3 — wyszukiwanie odbiorcy share'a korzysta z katalogu Ready przez
  osobny `StorageUserSearchCubit`: debounce 300 ms, ochrona przed starą
  odpowiedzią, filtrowanie kont bez `CoreUserId`, anulowanie timera w `close`
  i jawny stan braku kontekstu workspace. UI nie wysyła już surowego tekstu
  jako identyfikatora użytkownika.
- [x] D3 — formularz linku publicznego obsługuje hasło i datę wygaśnięcia,
  kopiuje pełny URL zamiast sekretnego tokenu bez kontekstu oraz prowadzi do
  anonimowej trasy `/storage/public/:shareToken`. Trasa wymienia token i
  opcjonalne hasło na krótkotrwały bilet backendu, a następnie korzysta ze
  wspólnego, platformowego transportu pobierania. Web/Wasm buduje URL przez
  `Uri.base`; desktop wymaga jawnego `PUBLIC_APP_BASE_URL`. Nie dodano
  `dart:html`.
- [x] D3 — dowody na Flutter 3.47.2: `flutter analyze` PASS, testy Storage
  40/40 PASS, `flutter build web --wasm` PASS i `flutter build macos --debug`
  PASS. Backend Storage/OnlyOffice: 154/154 PASS. Następny punkt D4: osadzony
  host OnlyOffice zamiast obecnego bezpiecznego hosta otwieranego w osobnym
  oknie.

## 1. Cel i źródła prawdy

Moduł `Files` ma udostępnić jeden spójny eksplorator dla:

- prywatnych plików użytkownika (`Moje pliki`),
- plików udostępnionych użytkownikowi,
- plików workspace'u i projektu,
- załączników zadań oraz innych zasobów Workspaces,
- dokumentów otwieranych i współedytowanych przez OnlyOffice,
- wersji, kosza, ulubionych, ostatnich plików i wyników wyszukiwania.

Źródłem kontraktu transportowego jest OpenAPI backendu
`veloryn-workspaces`. Ten dokument opisuje wdrożenie produktu i Fluttera, ale
nie zastępuje kontraktów OpenAPI ani ogólnego zakresu z
`workspace-implementation.md`.

## 2. Wynik audytu

### Backend

Backend Storage jest funkcjonalnie znacznie dalej niż sekcja 9 głównej
checklisty. W kodzie istnieją między innymi:

- prywatny S3/MinIO i bilety presigned upload/download,
- upload pojedynczy i zbiorczy oraz zbiorcze zatwierdzanie,
- prywatne, workspace'owe i projektowe foldery wirtualne,
- placementy pozwalające umieścić jeden plik w wielu folderach bez kopiowania,
- widoki `My`, `Shared`, `Recent`, `Favorites` i `Trash`,
- filtrowanie, wyszukiwanie tekstowe i semantyczne,
- udostępnienia plików i folderów użytkownikowi, workspace'owi, projektowi oraz
  przez link publiczny,
- poziomy dostępu Reader, Commenter, Editor i Owner,
- wersjonowanie, przywracanie wersji, soft delete i restore,
- streaming pliku i wersji oraz zbiorczy ZIP,
- OnlyOffice session/callback i konwersję do PDF,
- awatary, obrazy Quill, załączniki zadań i czatu,
- skanowanie antywirusowe, przetwarzanie multimediów, analizę AI, embeddingi,
  retencję oraz metryki.

Pakiet testów Storage/OnlyOffice/Chat attachments przechodzi: 165/165.

### Potwierdzone braki lub rzeczy do domknięcia w backendzie

Przed zamrożeniem kontraktu dla Fluttera należy rozstrzygnąć i ewentualnie
dodać:

1. Resumable/multipart upload dużych plików — nie ma publicznego kontraktu
   rozpoczęcia, wysyłki części, wznowienia i zakończenia sesji.
2. Operacje zbiorcze poza uploadem i ZIP-em — brakuje jednego kontraktu dla
   masowego usuwania, przywracania, przenoszenia, dodawania do ulubionych i
   udostępniania.
3. Jawna zmiana nazwy pliku. Obecny kontrakt zmienia opis, ale nie wystawia
   osobnej operacji rename.
4. Jawne kopiowanie/duplikowanie pliku i folderu. Placement nie kopiuje danych
   i powinien pozostać osobną akcją „Dodaj do folderu”.
5. Zachowanie usuwania folderu z zawartością — obecnie usuwany jest tylko pusty
   folder; UI potrzebuje kontraktu i komunikatu dla folderu niepustego.
6. Finalna macierz wspieranych formatów OnlyOffice, w szczególności ODT, ODS i
   ODP obok DOCX, XLSX, PPTX i PDF. UI nie może zgadywać na podstawie rozszerzenia.
7. Endpoint możliwości pliku (`capabilities`) albo komplet flag w szczególe:
   canPreview, canEditOnline, canDownload, canShare, canManageVersions,
   canDelete, canRestore i canConvertToPdf.
8. Produkcyjny test integracyjny z prawdziwymi kontenerami MinIO, ClamAV,
   OnlyOffice i workerami; obecne zielone testy nie potwierdzają całego
   wdrożenia infrastruktury.
9. Aktualizacja sekcji 9 głównego planu, ponieważ jej niezaznaczone pozycje nie
   odzwierciedlają obecnego kodu.

### Flutter

Warstwa `data/storage` zawiera szeroki klient Retrofit i modele większości
endpointów backendu. Istnieją także:

- upload wielu załączników zadania z pickerem i drag-and-drop,
- szczegół pliku dostępny przez deep link,
- podstawowa integracja avatara,
- katalog plików projektu oparty na uproszczonych metadanych.

Nie istnieje jeszcze pełny moduł prezentacji Files. `WorkspacesFilesPage` jest
placeholderem, a `StorageRepository` udostępnia głównie avatar i szczegół
jednego pliku. Brakuje eksploratora, folderów, operacji na zaznaczeniu,
udostępnień, wersji, kosza, podglądu i edycji OnlyOffice.

## 3. Docelowe miejsce kodu Flutter

Moduł pozostaje w `lib/workspaces`, ale Storage należy uporządkować jako pełny
feature z subfeature'ami:

```text
lib/workspaces/
├── data/storage/
│   ├── api/
│   ├── models/
│   ├── payloads/
│   ├── repositories/
│   └── services/
├── domain/storage/
│   ├── models/
│   ├── repositories/
│   └── services/
└── presentation/storage/
    ├── shell/
    ├── browser/
    │   ├── cubit/
    │   ├── toolbar/
    │   ├── breadcrumbs/
    │   ├── grid/
    │   ├── list/
    │   └── selection/
    ├── upload/
    ├── details/
    ├── preview/
    ├── sharing/
    ├── versions/
    ├── trash/
    ├── search/
    └── office/
```

Komponenty specyficzne dla plików nie trafiają do `lib/shared`. Integracje
platformowe — wybór pliku, zapis pobrania, drag-and-drop, otwarcie nowego okna
i osadzenie OnlyOffice — muszą być schowane za typowanymi adapterami z osobną
implementacją Web/Wasm i desktop.

## 3.1. Obowiązkowa instrukcja implementacyjna dla agenta

Ta sekcja jest kontraktem jakościowym, a nie sugestią. Agent przed zmianą kodu
musi przeczytać:

1. `AGENTS.md`,
2. `workspace-implementation.md`,
3. `workspace-implementation-plan.md`,
4. `docs/ai-ui-architecture-guidelines.md`,
5. ten dokument,
6. istniejące implementacje Tasks/Kanban i współdzielone widgety wskazane niżej.

Agent nie zaczyna od tworzenia ekranu. Najpierw dla aktualnego pakietu zapisuje
krótką macierz: endpoint → repository → Cubit → ekran/akcja → test. Nie wolno
zgadywać endpointów, pól, enumów ani uprawnień. Każda akcja musi mieć pokrycie
w OpenAPI lub zostać oznaczona jako blocker backendowy.

### Granice odpowiedzialności — zakaz „boskich Cubitów”

Nie wolno tworzyć jednego `FilesCubit`, `StorageCubit` ani `FileManagerCubit`,
który jednocześnie listuje dane, zarządza uploadem, zaznaczeniem, folderami,
sharingiem, wersjami, preview i OnlyOffice.

Wymagany podział stanu:

```text
StorageBrowserCubit
  odpowiedzialność: bieżący scope/folder, paginacja, filtry, sortowanie,
  odświeżenie listy i scalenie stron

StorageSelectionCubit
  odpowiedzialność: zaznaczenie, anchor Shift, select-all widocznej strony,
  wyliczenie wspólnych dozwolonych akcji; bez requestów listujących

StorageUploadCubit
  odpowiedzialność: kolejka uploadów, limit równoległości, postęp, anulowanie,
  retry i wynik częściowy

StorageFolderMutationCubit
  odpowiedzialność: create/rename/move/delete folderu i odświeżenie właściciela

StorageFileMutationCubit
  odpowiedzialność: favorite, rename, move/placement, delete/restore oraz bulk
  mutation; nie przechowuje całej listy eksploratora

StorageFileDetailsCubit
  odpowiedzialność: metadane jednego pliku i ich odświeżenie

StoragePreviewCubit
  odpowiedzialność: przygotowanie bezpiecznego źródła preview/streamu oraz
  lifecycle zasobu tymczasowego

StorageSharingCubit
  odpowiedzialność: lista grantów, utworzenie, odwołanie i public link

StorageVersionsCubit
  odpowiedzialność: historia wersji, download wersji i restore

StorageOfficeSessionCubit
  odpowiedzialność: utworzenie/odnowienie/zamknięcie sesji OnlyOffice i
  odświeżenie pliku po callbacku
```

Cubit wolno połączyć z innym tylko wtedy, gdy połączenie usuwa sztuczną granicę
i nadal pozostawia jedną odpowiedzialność. W takim przypadku agent opisuje
powód w dokumencie i w teście. Sam argument „mniej plików” nie jest powodem.

Każdy Cubit:

- ma własny plik stanu z niemutowalnymi `sealed class`, bez Freezed,
- żyje na najniższym wspólnym poziomie drzewa, który go potrzebuje,
- nie zna `BuildContext`, routera, dialogu, snackbara ani widgetu,
- nie wywołuje Dio/Retrofit — używa repozytorium lub typowanego portu,
- przekazuje `CancellationToken` tam, gdzie warstwa transportowa go wspiera,
- sprawdza `isClosed` przed każdym `emit` po `await`,
- anuluje subskrypcje, timery, uploady i zasoby tymczasowe w `close`,
- ma jawne stany initial/loading/ready/empty/failure/forbidden, jeśli dotyczą
  przepływu, oraz stan częściowego sukcesu dla operacji wielu plików,
- nie przechowuje równoległej kopii danych należących do innego Cubita; między
  gałęziami przekazuje się intencję lub mały wynik operacji.

### Struktura widgetów musi być drzewiasta

Ekran ma być kompozycją nazwanych gałęzi odpowiedzialności. Nie wolno tworzyć
jednego dużego pliku `files_page.dart` z dziesiątkami prywatnych klas ani
spłaszczać wszystkich elementów do jednego `widgets/`.

Docelowe drzewo pierwszego ekranu:

```text
StorageShellPage
└── StorageBrowserPage
    ├── StorageBrowserHeader
    │   ├── StorageScopeTitle
    │   ├── StorageViewSwitcher
    │   └── StoragePrimaryActions
    ├── StorageBrowserToolbar
    │   ├── StorageBreadcrumbs
    │   ├── StorageSearchField
    │   ├── StorageFilterMenu
    │   └── StorageSortMenu
    ├── StorageSelectionToolbar
    ├── StorageBrowserBody
    │   ├── StorageFolderGrid lub StorageFolderRows
    │   ├── StorageFileGrid lub StorageFileRows
    │   ├── StoragePageLoader
    │   └── StorageEmptyOrErrorState
    ├── StorageUploadQueueOverlay
    └── StorageDetailsPane
```

Zasady rozmiaru:

- żaden ręcznie napisany plik Dart w nowym module nie może przekroczyć 400
  linii; pliki generowane są wyjątkiem,
- cel dla zwykłego widgetu/Cubita to 80–250 linii,
- przy 300 liniach agent obowiązkowo ocenia podział przed dopisaniem kolejnej
  odpowiedzialności,
- jedna klasa może mieć małe prywatne metody renderujące, ale osobna gałąź z
  własnym lifecycle, stanem, requestem, focus managementem albo testami musi
  stać się osobną klasą i plikiem,
- nie używać `part` do ukrywania zbyt dużego ekranu; każdy subfeature ma normalne
  importy i własny barrel, jeśli jest publiczny wewnątrz modułu,
- nie tworzyć `widgets/` dla jednego przypadkowego elementu; katalog oznacza
  rzeczywistą gałąź odpowiedzialności.

### Zakaz globalnych funkcji i funkcji poza klasami

W kodzie Files nie wolno dodawać top-level functions, globalnego mutable state,
globalnych kontrolerów, globalnych kluczy ani singletonów stanu biznesowego.
Dotyczy to również wygodnych helperów typu `formatBytes()`, `iconForMime()` czy
`openFile()` umieszczonych luzem w pliku.

Logika ma należeć do:

- prywatnej metody klasy, jeśli jest lokalna dla jednego widgetu/Cubita,
- bezstanowej klasy helpera z metodami statycznymi, jeśli jest czystym
  mapowaniem używanym w kilku miejscach Files,
- serwisu domenowego, jeśli zawiera regułę biznesową,
- typowanego portu/adaptora, jeśli dotyka platformy lub I/O,
- extension tylko wtedy, gdy operacja jest naturalna dla rozszerzanego typu i
  nie ukrywa I/O ani zależności.

Nie dodawać nowych top-level typedefów callbacków, jeżeli wystarczy istniejący
typ Fluttera albo jawny typ pola w klasie. Istniejącego kodu spoza zakresu nie
refaktoryzować tylko po to, by zastosować tę zasadę.

### UI ma być spójne z Tasks i Kanban

Punktem odniesienia są przede wszystkim:

- `lib/workspaces/presentation/tasks/board/tasks_board_header.dart` — zwarty,
  responsywny header, kontekst, toolbar oraz przejście do bulk toolbar,
- `lib/workspaces/presentation/tasks/list/project_tasks_list.dart` i gałęzie
  `list/table`, `list/filters`, `list/bulk` — gęsty widok danych,
- `lib/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart` —
  lokalne tokeny komponentu zamiast magicznych liczb rozrzuconych po kodzie,
- `lib/workspaces/presentation/tasks/board/tasks_board_card_menu.dart` — wzorzec
  menu kontekstowego,
- `lib/workspaces/presentation/tasks/detail/task_details_attachments.dart` —
  obecny wzorzec picker/drop i prezentacji uploadu; należy go uogólnić przez
  wspólny transport, a nie kopiować.

Files ma wyglądać jak część tej samej aplikacji:

- font wyłącznie z `ThemeData`/`context.text`; aplikacja używa Inter,
- kolory wyłącznie z `context.colors`/`ColorScheme`, bez nowych stałych hex,
- odstępy i rozmiary z `Sizes` oraz `Gaps`, bez losowych wartości, chyba że
  lokalny token komponentu ma nazwę i uzasadnienie,
- ikony przez `AppIcons`/`WorkspaceIcons`; nie mieszać Lucide, Material Icons i
  emoji ad hoc. Gdy brakuje ikony, najpierw rozszerzyć centralne mapowanie,
- powierzchnie: `surface`, `surfaceContainerLow/High`, subtelny
  `outlineVariant`; bez ciężkich kart wokół każdego wiersza,
- aktywny/selected używa czytelnego primary tint, hover i focus muszą być
  widoczne, ale bez agresywnych ramek,
- typografia zwarta jak w Tasks: tytuł `titleSmall/titleMedium`, nazwa pliku
  `bodyMedium`, metadane `bodySmall/labelSmall`; nie ustawiać własnej rodziny
  fontu ani wielu niestandardowych rozmiarów,
- header na szerokim ekranie ma jeden zwarty wiersz, a przy mniejszej szerokości
  kontrolowany układ dwurzędowy; nie dopuszczać do przypadkowego `Wrap`, który
  zmienia kolejność akcji,
- po zaznaczeniu plików zwykły toolbar zmienia się w bulk toolbar analogicznie
  do Tasks, zamiast dokładać drugi pasek bez hierarchii,
- list/grid zachowują wspólne zaznaczenie, menu i akcje; nie implementować dwóch
  niezależnych produktów,
- dark mode, text scaling, 1280 px oraz zmiana rozmiaru okna są obowiązkowe.

### Najpierw użyj istniejących shared widgetów

Przed napisaniem komponentu agent przeszukuje
`lib/shared/presentation/widgets` oraz `lib/workspaces/shared`. Preferowane
elementy:

- `AppActionButton`, `AppActionChip`, `AppActionPill`,
- `AppContextMenu` i `AppContextMenuButton`,
- `AppSearchTextField`, `AppDropdown`, `AppTextField`,
- `AppModalSheet`, `AppConfirmDialog`, `AppExpandableSideSheet`,
- `AppEmptyState`, `AppAsyncStateBody`, `AppSpinner`, `AppShimmer`,
- `AppStatusBadge`, `AppTooltip`, `AppToast`,
- `AppSimpleTable` lub istniejące mechanizmy tabeli Tasks, jeśli spełniają
  wymagania selekcji i dużych danych,
- `AppModalAccessibilityBoundary` dla modali/drawerów,
- `AppTree` tylko wtedy, gdy jego kontrakt odpowiada folderom; nie naginać go.

Nowy shared widget wolno utworzyć tylko gdy:

1. ma neutralne API niezależne od Storage,
2. istnieją co najmniej dwa realne zastosowania w niezależnych modułach albo
   drugie zastosowanie jest wdrażane w tym samym pakiecie,
3. ma test widgetowy, dokumentację po polsku i nie łamie obecnego API,
4. używa theme tokens i działa w light/dark oraz z klawiaturą.

W przeciwnym razie komponent pozostaje w `workspaces/presentation/storage`.
Nie przenosić istniejącego widgetu do shared „na przyszłość”. Jeśli Files i
task attachments potrzebują wspólnej kolejki uploadu, najpierw wydzielić
neutralny kontrakt transportu i model postępu, a następnie podłączyć oba realne
użycia wraz z testami.

### Teksty, błędy i dostępność

- Każdy tekst widoczny dla użytkownika pochodzi z ARB przez `context.l10n`.
- Po zmianie ARB uruchomić generator lokalizacji i commitować wynik wymagany
  przez repozytorium.
- Nie tłumaczyć kodów błędów backendu na podstawie string contains; korzystać z
  typowanego `backendCode` i pokazywać bezpieczny polski komunikat backendu.
- Ikonowe akcje mają tooltip i semantic label; hit target minimum 40×40.
- Obsłużyć focus traversal, Escape, Enter/Space, menu key i widoczny focus ring.
- Dialog destrukcyjny używa `AppConfirmDialog`; wynik częściowy operacji bulk
  pokazuje listę sukcesów i błędów, nie jeden toast „nie udało się”.

### Dyscyplina zmian

- Nie refaktoryzować Tasks/Kanban/shared poza minimalnym zakresem potrzebnym do
  zgodnej integracji.
- Nie kopiować istniejącego komponentu i zmieniać tylko nazwy.
- Nie zostawiać placeholderów, atrap danych, `TODO`, pustych callbacków ani
  akcji widocznych bez działającego kontraktu.
- Nie kończyć pakietu, jeżeli ręcznie napisany plik przekracza 400 linii, Cubit
  ma więcej niż jedną odpowiedzialność lub UI używa hardcoded tekstów/kolorów.
- Po każdym pakiecie zaktualizować checklistę tego dokumentu i dopisać wynik
  testów oraz weryfikacji wizualnej.

## 4. Model nawigacji i ekranów

Trzy wejścia korzystają z tego samego eksploratora z innym zakresem:

```text
/workspaces/private/files
/workspaces/:workspaceId/files
/workspaces/:workspaceId/projects/:projectId/files
/storage/files/:fileId
```

Lewy panel eksploratora:

- Moje pliki,
- Udostępnione mi,
- Ostatnie,
- Ulubione,
- Kosz,
- foldery prywatne,
- foldery bieżącego workspace'u lub projektu zależnie od trasy.

Widok główny zapewnia listę i siatkę, breadcrumb, wyszukiwanie, sortowanie,
filtry, przełączanie zakresu oraz infinite scroll. Szczegół pliku otwiera panel
boczny na dużym ekranie i osobny pełny ekran na małym.

## 5. Plan realizacji

### Etap 0 — zamrożenie kontraktu backendu

- [x] Wygenerować aktualny OpenAPI i porównać wszystkie Storage DTO z Dartem.
- [x] Uzupełnić brakujące operacje backendowe wskazane w sekcji 2 albo jawnie
  oznaczyć je jako późniejszy zakres.
- [x] Dodać capability flags i macierz formatów podglądu/edycji.
- [x] Ujednolicić poziomy dostępu; klient używa Reader/Commenter/Editor/Owner,
  a wartości kompatybilności Read/Write nie mogą przeciekać do nowego UI.
- [x] Potwierdzić limity rozmiaru, dozwolone MIME, retencję kosza i limity
  publicznych linków w kontrakcie zwracanym klientowi.

### Etap 1 — kompletna domena i repozytorium Flutter

- [x] Rozszerzyć `StorageRepository` do listowania, folderów, uploadu,
  pobierania, placementów, favorite, delete/restore, shares, versions,
  OnlyOffice i PDF.
- [x] Nie wystawiać `StorageApi` bezpośrednio Cubitom.
- [x] Dodać typowany `StorageScope` (private/workspace/project/resource) zamiast
  luźnych kombinacji nullable parametrów w prezentacji.
- [x] Dodać testy mapowania błędów i zgodności enumów z OpenAPI.

### Etap 2 — transport plików Web/Wasm i desktop

- [x] Zbudować `FilePickerPort`, `UploadTransport`, `DownloadTransport`,
  `ExternalWindowPort` i `DropTargetPort`.
- [x] Web/Wasm: upload bez kopiowania całych dużych plików do pamięci, zapis
  pobrania przez wspierany interop i kontrolowane otwieranie nowego okna.
- [x] Desktop: picker, streaming do pliku tymczasowego/docelowego i otwieranie
  pliku przez system.
- [x] Dodać anulowanie, retry, równoległość z limitem i postęp per plik.
- [ ] Po udostępnieniu kontraktu resumable dodać wznowienie po utracie sieci.

### Etap 3 — explorer i foldery

- [x] Zaimplementować `StorageBrowserCubit` z cursor pagination, filtrami i
  zachowaniem lokalnego zaznaczenia przy dociąganiu stron.
- [x] Dodać breadcrumb, list/grid, responsywny toolbar i stany empty/error.
- [x] Dodać tworzenie, zmianę nazwy, przenoszenie i usuwanie folderów.
- [x] Dodać drag-and-drop uploadu oraz przenoszenia istniejących placementów.
- [x] Obsłużyć odświeżenie URL, Back i bezpośrednie wejście w Web.

### Etap 4 — praca na wielu plikach

- [x] Zaznaczenie myszą, Ctrl/Cmd, Shift oraz „zaznacz wszystkie na stronie”.
- [x] Pasek operacji: pobierz ZIP, przenieś/dodaj do folderu, udostępnij,
  favorite, usuń i przywróć.
- [x] Dla braku endpointu bulk stosować kontrolowaną kolejkę klienta wyłącznie
  jako etap przejściowy, z częściowym wynikiem i retry; preferowany jest
  atomowy lub raportowany kontrakt backendowy.
- [x] Menu kontekstowe i skróty Delete, F2, Ctrl/Cmd+A, Enter i Space z ochroną
  przed konfliktem z polami tekstowymi.

### Etap 5 — upload i cykl życia

- [x] Dialog/dropzone wielu plików z walidacją nazwy, MIME, rozmiaru i limitu.
- [x] Kolejka pokazująca queued/uploading/scanning/processing/ready/failed.
- [x] Możliwość pozostania w eksploratorze podczas uploadu.
- [x] Widok kosza z datą trwałego usunięcia i restore.
- [x] Obsługa konfliktów wersji i ponowienie nieudanych operacji.

### Etap 6 — szczegół, podgląd i wersje

- [x] Rozbudować istniejący deep-link detail o metadane, ACL, AI, placementy,
  udostępnienia i historię wersji.
- [x] Podgląd obrazów, PDF, audio, wideo i tekstu zależnie od capability flags.
- [x] Streaming/Range dla mediów bez pobierania całego pliku do pamięci.
- [x] Pobieranie oraz przywracanie wersji z jawnym potwierdzeniem utworzenia
  nowej wersji.

### Etap 7 — udostępnianie

- [x] Dialog wyszukiwania użytkownika i wyboru Reader/Commenter/Editor/Owner.
- [x] Udostępnianie workspace'owi/projektowi zgodnie z prawami właściciela.
- [x] Link publiczny: hasło, wygaśnięcie, limit pobrań, kopiowanie linku i
  natychmiastowe unieważnienie.
- [x] Pokazywać efektywne uprawnienie i jego źródło, w tym dziedziczenie z
  folderu, zamiast sugerować możliwość usunięcia odziedziczonego share'a.

### Etap 8 — OnlyOffice i OpenDocument

- [x] Akcję „Otwórz dokument” pokazywać wyłącznie według backendowych
  capabilities.
- [~] Osadzić OnlyOffice na Web oraz zapewnić równoważny przepływ desktopowy,
  najlepiej w kontrolowanym widoku webowym lub zewnętrznej sesji.
- [x] Obsłużyć tryb view/edit/comment, wygasłą sesję, utratę uprawnień,
  reconnect, callback tworzący wersję i odświeżenie szczegółu.
- [x] Potwierdzić i przetestować ODT/ODS/ODP. Jeżeli backend konwertuje je do
  OOXML, UI musi jasno pokazać, że zapis tworzy nowy format lub wersję.
- [x] PDF pozostaje podglądem/formularzem zgodnie z capabilities; nie obiecywać
  pełnej edycji, jeśli serwer jej nie wspiera.

### Etap 9 — integracje kontekstowe

- [x] Zastąpić uproszczony katalog plików projektu pełnym explorerem scoped.
- [x] Rozszerzyć załączniki taska o pobieranie, usuwanie, wersje, preview i
  otwieranie deep linku.
- [x] Zintegrować pliki Chat, Quill, Wiki, Whiteboard, Corkboard i OKR bez
  duplikowania transportu uploadu.
- [x] Zachować jeden identyfikator pliku i placementy zamiast kopiowania
  obiektu pomiędzy modułami.

### Etap 10 — testy i odbiór

- [x] Unit/widget tests każdego Cubita i krytycznych dialogów.
- [x] Contract tests wygenerowanego klienta względem OpenAPI.
- [x] E2E: private/workspace/project, share/revoke, upload wielu plików,
  częściowa awaria, kosz, wersje i OnlyOffice.
- [x] Test izolacji użytkowników i utraty uprawnień w otwartym ekranie.
- [~] Test Web/Wasm oraz Windows, macOS i Linux dla picker/drop/download/open.
- [x] Test dostępności klawiaturą, focusu, czytnika ekranu i dużych list.
- [x] Test pamięci dla dużych uploadów/downloadów i streamingu mediów.

## 6. Kolejność pierwszego pakietu implementacyjnego

Pierwszy bezpieczny pakiet powinien dostarczyć pionowy przepływ:

1. `Moje pliki` z cursor pagination i folderami prywatnymi.
2. Upload wielu plików z postępem i retry.
3. Pobieranie, favorite, usunięcie i przywrócenie.
4. Szczegół oraz podstawowy preview.
5. Testy Web/Wasm i jednego desktopowego targetu referencyjnego.

Dopiero po tym należy dodać współdzielone zakresy workspace/project, operacje
bulk, udostępnienia i OnlyOffice. Dzięki temu cały pion transport–repozytorium–
stan–UI zostanie sprawdzony najpierw na danych prywatnych, bez mieszania ACL
wielu kontekstów.

## 7. Kryterium ukończenia modułu

Moduł jest gotowy, gdy użytkownik może na Web/Wasm i każdym desktopie:

- zarządzać własnymi plikami i folderami,
- pracować na wielu plikach bez utraty informacji o częściowych błędach,
- przełączać zakres prywatny, shared, workspace, project i powiązany zasób,
- bezpiecznie udostępniać i odbierać dostęp,
- przeglądać, pobierać, wersjonować, usuwać i przywracać,
- otwierać wspierane dokumenty w OnlyOffice,
- wejść bezpośrednio przez deep link i poprawnie używać Back/refresh,
- otrzymać spójny komunikat dla każdej odmowy ACL i awarii infrastruktury.
