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
