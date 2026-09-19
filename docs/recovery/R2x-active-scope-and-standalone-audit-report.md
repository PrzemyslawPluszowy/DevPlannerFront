# R2x — aktywny zakres odzyskania i audyt standalone

Data: 2026-09-18  
Status: **zweryfikowano statycznie; nie jest to odbiór live**

## Uzgodniony zakres

Do stanu roboczego DevPlanner wracają wyłącznie piony, które istniały i są
potrzebne w bieżącej fazie:

1. **Pliki** — przeglądarka plików osobistych, workspace i projektu, upload
   desktopowy, foldery, udostępnianie oraz istniejące widoki szczegółów.
2. **Zadania** — lista, board, szczegóły, saved views, recurrence i ustawienia
   workflow, w granicach już istniejącego kontraktu Backend.
3. **Kanban** — widok Tasks pod kanonicznym `?view=kanban`, z zachowaniem
   historycznego URL projektu jako redirectu zgodnościowego.
4. **Chat** — część odzyskana jako panel z prawej, dostępny ponad każdą trasą;
   nie jest oddzielnym ekranem ani trasą.
5. **Powiadomienia** — część odzyskana jako niezależny panel z prawej, nie
   jako nowy ekran ani moduł.

W tej fazie nie budujemy nowych pionów Whiteboard, Wiki, Corkboard, OKR ani
automatyzacji. Historyczne elementy menu mogą pozostać nieaktywne, ale nie
mogą udawać gotowych tras lub ekranów.

## Dowody w aktywnym grafie Frontu

- `lib/app/router/devplanner_router.dart` oraz
  `devplanner_router_pages.part.dart` składają realne trasy katalogu,
  projektu, Files, listy Tasks, Kanbanu i szczegółu taska.
- `lib/app/shell/overlays/devplanner_global_panels_host.dart` jest wspólnym
  hostem overlayów Chat/Powiadomienia. Host rezerwuje belkę i przywraca focus;
  nie istnieje trasa `/chat` ani `/notifications`.
- `lib/app/shell/devplanner_shell_navigation.dart` daje menu z rozróżnieniem
  listy Tasks i Kanbanu, bez globalnego Cubita i bez I/O w UI.

## Audyt odcięcia poprzedniego systemu

W `../Backend` skan nazw zewnętrznego Ready/Core/DataBus nie wykrył klienta,
adresu ani konfiguracji integracyjnej. Jedyny traf to
`Infrastructure/Configuration/StandaloneConfigurationGuard.cs`, czyli
fail-closed blokada zakazanych fragmentów konfiguracji (w tym `DATABUS`).

## Uzupełnienie R3p — Files i Resource Chat

Aktywny router standalone udostępnia szczegół pliku pod
`/storage/files/:fileId`. Lista Files prowadzi do niego przez jawną akcję
„Szczegóły pliku”; strona odczytuje świeży `StorageFileDetailsResponse` przez
`StorageFileDetailsCubit`. Akcja „Czat pliku” pojawia się wyłącznie, gdy
backend potwierdzi `canOpenResourceChat` i bieżące prawo odczytu. Resolver
`ResourceChatCubit` nadal reautoryzuje plik po stronie backendu i otwiera
istniejący prawy globalny panel — bez nowej trasy Chat i bez zaufania do
uprawnień z listy.

Usunięto nieosiągalne pliki dawnych tras z placeholderami oraz dawne widoki
tras Whiteboard/Wiki/OKR. Przed usunięciem skan `lib` i `test` potwierdził
brak ich importów oraz wywołań. Nie usunięto Files, Tasks, Kanbanu, globalnego
Chatu ani powiadomień. `flutter analyze` PASS; testy nowego Resource Chat oraz
routera/Files **31/31 PASS**. Dodatkowy test katalogu tras potwierdza, że
`/storage/files/:fileId` pozostaje trasą standalone i nie przyjmuje
nieprawidłowego identyfikatora; kliknięcie Files → szczegóły → Cubit jest
pokryte (**14/14 PASS**). Brak testu live pozostaje
jawny.

Kompilacja:

```text
DOTNET_CLI_TELEMETRY_OPTOUT=1 dotnet build veloryn-workspaces.csproj --no-restore
```

Wynik: **0 ostrzeżeń, 0 błędów**.

## Walidacja Frontu

```text
flutter analyze lib test/app/router test/app/shell \
  test/workspaces/presentation/tasks test/workspaces/presentation/storage
```

Wynik: **No issues found**.

Nie uruchamiano aplikacji Flutter, Backend, MinIO, SignalR ani GUI. Nadal
potrzebny jest późniejszy odbiór desktop/staging: Files z MinIO, lista/
Kanban/szczegół taska oraz Chat/Powiadomienia z prawdziwym realtime.
