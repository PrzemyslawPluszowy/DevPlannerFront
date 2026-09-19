# Faza 0B — manifest zależności frontendu do standalone

**Status:** COMPLETED
**Data:** 2026-09-16
**Zakres:** wyłącznie repozytorium `Front`; dokumentacja inwentaryzacyjna, bez zmian runtime.
**Źródło docelowe:** `docs/devplanner-standalone-refactor-plan.md`, sekcja 7 oraz pakiety 6A–6E.

## Metoda i evidence

Wykonano odczyt `git status --short`, `rg --files`, `rg -n`/`rg -l` dla importów, nazw legacy, tras, storage i platform oraz `sed` dla `pubspec.yaml`, katalogu tras, bootstrapu, katalogu modułów i storage sesji. Liczby poniżej są liczbą plików zawierających wzorzec (o ile nie zaznaczono inaczej), liczoną łącznie dla `lib/` i `test/`; wygenerowane pliki nie były wykluczane. To baseline do powtórzenia po każdym pakiecie.

Stan roboczy na wejściu zawiera niezwiązane zmiany: `AGENTS.md` (modified) oraz nieśledzone kopie planu i handoffu. Nie modyfikowano ich.

## Baseline ilościowy

| Obszar | Evidence (`rg`) | Wynik |
|---|---|---:|
| `lib/features/auth` | `rg --files lib/features/auth -g '*.dart'` | 1 plik |
| BHP | `rg --files lib/features/bhp -g '*.dart'` | 178 |
| Inventory | `rg --files lib/features/inventory -g '*.dart'` | 178 |
| Dashboard | `rg --files lib/features/dashboard -g '*.dart'` | 63 |
| Framework / inne / Orders / settings | analogicznie | 27 / 1 / 2 / 10 |
| Workspaces | `rg --files lib/workspaces -g '*.dart'` | 772 |
| Testy Dart | `rg --files test -g '*_test.dart'` | 210 |
| testy router / auth / shell | `rg --files test/app/router test/core/auth test/app/shell -g '*_test.dart'` | 3 / 4 / 8 |
| Importy `core` / `shared` / `workspaces` | `rg -l/-o 'package:ready_next/<prefix>/' lib test` | 626/1004; 230/711; 603/2703 (pliki/importy) |
| Importy BHP / Inventory / Dashboard | ten sam wzorzec | 136/426; 131/507; 55/189 (pliki/importy) |
| legacy `CoreUserId` / `coreUserId` | `rg -o` | 1466 / 1398 wystąpień |
| identyfikator package `ready_next` | `rg -o` | 5820 wystąpień |

Wyniki obejmują importy testowe i generowane (`.g.dart`, `.freezed.dart`), dlatego nie są estymacją rozmiaru docelowego kodu. Wymagają ponownej walidacji po rozdzieleniu package/importów.

## Macierz importów i decyzji

| Źródło | Potwierdzone zależności | Decyzja standalone | Ryzyko / kolejność |
|---|---|---|---|
| `lib/core/**`, 30 plików | error, config, theme, host, network, storage, auth; wiele importów `package:ready_next` | Rozbić na `foundation/{error,http,l10n,platform,secure_storage,theme}` oraz `auth/{data,domain,presentation}`. `core` nie pozostaje nazwą docelową. | Najpierw porty i kontrakty; nie przenosić token handlingu do presentation. |
| `lib/shared/**`, 75 plików | wspólne widgety, ikony, modele, utility; część odwołuje się do starych modułów | Zachować tylko elementy używane przez DevPlanner; przenieść do `foundation` albo lokalnego `workspaces/shared`. | Wymaga grafu użycia po odłączeniu BHP/Inventory. |
| `lib/workspaces/**`, 772 pliki | data/domain/presentation; API Retrofit, repositories, Chat, Storage, Wiki, Whiteboard, Kanban, OKR, realtime | Zachować i przemianować na `workspaces/{data,domain,presentation,shared}`. Wyciąć wyłącznie zależności Ready/Core, nie funkcje domeny. | Największa gałąź; migracja pionowymi slice’ami. |
| `lib/features/bhp/**`, 178 plików | API, repozytoria i UI BHP; katalog modułu wymaga `ReadyPermissions.bhp` | Usunąć w pakiecie 7C po odłączeniu tras/importów/testów i potwierdzeniu braku użycia. | Dashboard i l10n mają odwołania pośrednie; najpierw usunąć konfigurację startup/shortcut. |
| `lib/features/inventory/**`, 178 plików | API, repozytoria, eksport PDF, UI; `ReadyPermissions.inventory` | Usunąć w 7C po odłączeniu; nie usuwać foundation używanego przez Workspaces. | Najwięcej testów (41); osobna migracja testów i assetów. |
| `lib/features/dashboard/**`, 63 pliki | preferencje Hive/API, widgety BHP/Inventory/weather/startup | Ogólny dashboard Ready usunąć; ewentualne preferencje layoutu przenieść do shell/workspaces tylko po dowodzie użycia. | Nie mylić z docelowym shell’em; brak automatycznego zachowania starych shortcutów. |
| `framework`, `inne`, `orders`, zależne `settings` | odpowiednio 27/1/2/10 plików; katalog modułów wystawia je globalnie | Usunąć framework gallery, `inne`, Orders i ustawienia zależne od martwych modułów. Zachować tylko ustawienia DevPlanner (`/me`/workspace). | L10n i test `widget_test.dart` nadal asercyjnie uruchamiają Orders/Inventory. |

## Router, shell, startup i DI

### Stan obecny

`lib/app/router/app_route_paths.dart` definiuje 20 stałych: `/login`, `/dashboard`, `/inventory` (plus overview/stock/archive), `/bhp` (plus users/positions/equipment), `/workspaces`, `/me/tasks`, `/me/files`, `/notifications`, `/chat`, `/storage/files`, `/storage/public`, `/orders`, `/inne`, `/settings`, `/framework/components`. `app_router.dart` ma dodatkowo dynamiczne segmenty workspace/project/task/resource, pliki, wiki, whiteboard, automations, members, settings, corkboard, OKR i legacy redirects. Ochrona trasy jest w `redirect` i `auth_redirect_policy.dart`.

`lib/app/ready_next_app.dart` jest obecnie kompozytorem DI: importuje `Dio`, Provider, Flutter Bloc, auth, dashboard, BHP repozytoria, settings, realtime i kilkadziesiąt repozytoriów Workspaces. `app_runtime_bindings.dart` tworzy bindingi modułów. Globalny shell (`app_global_shell.dart`) ma top bar, panele Chat/Notifications i modal host; startup (`app_startup_page.dart`, `bootstrap/app_bootstrap.dart`) inicjalizuje MediaKit, Hive, filtr Inventory, settings, host bridge, sesję i Sentry.

### Decyzja docelowa

Zachować model drzewa z planu:

```text
lib/
├── app/{bootstrap,router,shell,startup}
├── auth/{data,domain,presentation}
├── foundation/{error,http,l10n,platform,secure_storage,theme}
├── workspaces/{data,domain,presentation,shared}
└── admin/{data,domain,presentation}
```

Router ma obejmować wyłącznie auth (login/activation/reset/MFA), Workspaces i zasoby, Chat, Notifications, Storage/public share po zatwierdzeniu, `/me` i `/admin`. Shell zachowuje globalne Chat/Notifications, modal host, belkę i responsywność, ale bez przełączników Ready. DI ma jeden transport API w zakresie sesji oraz jawne, lokalne Cubity/repositories; UI nie importuje Dio, SignalR ani secure storage. Żadnego globalnego/god Cubita, globalnego mutowalnego stanu ani logiki biznesowej w widgetach.

## Auth, token storage i API factory

| Element obecny | Evidence | Decyzja standalone |
|---|---|---|
| Auth model/repo/cubit/API | `lib/core/auth/{auth_models,auth_repository,auth_cubit,auth_api}.dart` | Przenieść do `auth/data|domain|presentation`; wspólny interfejs sesji bez tokenów w UI. |
| Sesja trwała | `HiveAuthSessionStorage`, box `auth_session`, klucze `standalone_access_token`, `standalone_refresh_token`, `standalone_user` | Usunąć zapis tokenów w Hive. Web: wyłącznie BFF cookie Secure/HttpOnly/CSRF. Desktop: access tylko pamięć procesu, refresh wyłącznie system secure storage przez port. |
| Fabryka HTTP | `core/network/app_api_factory.dart`, 310 wystąpień `Dio`, 87 `Retrofit` | Zachować jako `foundation/http` po dopięciu jednego transportu per sesja, serializowanego 401/refresh i redakcji sekretów. Presentation ma zależeć od portów/repozytoriów. |
| Realtime | `signalr_netcore` (8 wystąpień); Workspaces ma typed transport/adapters | Zachować adapter za portem domenowym; reconnect/replay/deduplikacja/revoke pozostają poza UI. |
| Auth package dependency | `flutter_secure_storage` (2), `webview_all` (3) | Secure storage tylko adapter platformowy; embedded WebView do hasła usunąć. OIDC system-browser + PKCE desktop i BFF web. |

## Platformy, Hive i persistence

Platform gates obejmują Web, Windows, macOS i Linux. Potwierdzone adaptery/plikowe warianty to `host_bridge_{stub,web}`, `main_web_url_strategy_{stub,web}`, `download_transport_{io,stub,web}`, `external_url_launcher_{io,stub,web}`, `public_share_link_builder_{io,stub,web}`, `storage_upload_body_{io,stub,web}`, `file_picker_port_impl.dart` oraz `arkusz_pdf_save_{io,web}`. Są to kandydaci do zachowania pod `foundation/platform` lub portami Workspaces; kod domeny nie może importować bibliotek platformowych.

Zależności z `pubspec.yaml`: `hive_ce`/`hive_ce_flutter`, `shared_preferences`, `path_provider`, `file_selector`, `desktop_drop`, `flutter_secure_storage`, `webview_all`, `signalr_netcore`, `dio`, `retrofit`, `sentry_*`, `media_kit`. Evidence wystąpień w `lib`/`test`: `Hive.` 24, `HiveHelper` 21, `shared_preferences` 10, `path_provider` 2, `file_selector` 9, `desktop_drop` 8.

Potwierdzone boxy Hive: `auth_session` oraz `inventory_runtime_box`; `HiveHelper` używa wspólnego `Hive.openBox`. `SharedPreferences` obsługuje m.in. preferencje widoku tabeli. W standalone należy nadać boxom prefix/version DevPlanner, nie migrować automatycznie cache Ready i nigdy nie persistować sekretów w Hive/web storage. Cache użytkownika musi być czyszczony przy logout/revoke.

## Katalogi i testy: zachować, przenieść, usunąć

| Zakres | Zachować/przenieść | Usunąć dopiero po bramce |
|---|---|---|
| Kod | `workspaces`, używane `app/shell`, modal host, theme/l10n, typed platform ports, error/http po ekstrakcji | `features/bhp`, `features/inventory`, Ready dashboard, framework gallery, `inne`, Orders, martwe settings |
| Testy | 121 testów Workspaces, router/auth/shell (3/4/8), testy kontraktów/mappingu i adapterów platformowych | Testy wyłącznie BHP/Inventory/Orders/dashboard gallery po usunięciu kodu i odwołań; zaktualizować `widget_test.dart` i testowe Hive prefixy |
| Assets/l10n | Inter/theme tokens i używane assets; ARB tylko dla aktywnych funkcji | Ready/BHP/Inventory/Orders/dashboard-only teksty i ikony po `rg` zero odwołań |
| Platform/project | adaptery i cztery hosty, po rename brandingowym | `ready_next` nazwy, bundle/application IDs, snap desktop i telemetry `ready_next` — dopiero pakiet 7D |

## Docelowa kolejność refaktoryzacji

1. **0B (ten manifest):** zamrozić baseline importów, tras, storage, testów i platform.
2. **1–3:** backend Identity/OIDC/admin/recovery; frontend nie usuwa jeszcze domen legacy.
3. **4–5:** po kontrakcie OpenAPI używać lokalnego `UserId`; bez importu, mapy, backfillu, dual-read/write i bez połączeń Ready/Core/DataBus.
4. **6A:** utworzyć docelowe foundation/auth/app tree, zmienić package/branding w kontrolowanym pakiecie.
5. **6B–6C:** router i standalone shell; zachować intended route, deep link/back/refresh i globalne panele.
6. **6D:** przenosić Workspaces pionowymi slice’ami (data/domain/presentation), z lokalnym Cubitem i testami.
7. **6E:** platform adapters, secure storage, namespaced Hive/cache i pełne gate’y Web/Windows/macOS/Linux.
8. **7C–7D:** usunąć martwe feature’y/assets/l10n oraz nazwy Ready po testach i zero-reference scan; bez okresu obserwacji/fallbacku.

## Standalone target i gate zero-reference

Flutter standalone całkowicie usuwa dashboard, BHP, Inventory, Orders, framework,
`inne` oraz zależne ustawienia. Workspaces staje się pełnoprawną aplikacją
DevPlanner z własnym app root, bootstrapem, shell/routerem i Identity; nie jest
modułem pod parent Ready shell. Gate wymaga zera importów, routingu, DI, assets,
l10n i testów tych legacy modułów oraz zera połączeń Ready/Core/DataBus w kodzie,
konfiguracji, startupie i sekretach. Baseline może zawierać dormant referencje,
ale Gate 1A wymaga zaakceptowanego planu ich usunięcia oraz blokady DNS/egress,
endpointów i sekretów. EXIT 1A wymaga zera w runtime/config, uruchamianych
testach i artefaktach; oznaczone dokumenty/ADR/manifesty/handoffy opisujące
baseline/historię migracji oraz niezmieniana historia EF są jedynymi wyjątkami.
Baza lokalna jest disposable; reset i reprovision poprzedzają wdrożenie, bez
migracji istniejących danych.

## Gate wejścia do Fazy 1

Faza 1 może wystartować dopiero, gdy ten manifest jest zaakceptowany, oba repo
mają uzgodnione kontrakty planu, baseline importów/trasy/storage jest
odtwarzalny, właściciel potwierdził brak zmian runtime w dokumentacji, a manifest
usunięcia baseline referencji i środowiskowa blokada połączeń są sprawdzone.
Przed implementacją należy mieć decyzję ADR 0C o OIDC/BFF/PKCE/hasher oraz
backendowy kontrakt `UserId`; brak tych artefaktów blokuje auth i zmianę
identyfikatorów. Brak hosta platformowego nie jest zaliczeniem gate’a.

## Ryzyka i niepewności

- Statystyki `rg` liczą także testy i generated code; po wygenerowaniu plików mogą się zmienić.
- Nie wykonano pełnego grafu zależności ani analizy transitive imports; status modułów „zachować/usunąć” wymaga powtórzenia `rg` po każdym slice’ie.
- `auth_session` obecnie zawiera access/refresh tokeny w Hive — to niezgodne z docelowym BFF/secure-storage i wymaga migracji bez odczytu starego cache Ready.
- `app/ready_next_app.dart` i `app_runtime_bindings.dart` są szerokimi punktami DI; bez rozbicia łatwo odtworzyć god composition root.
- Router nadal ma ścieżki BHP/Inventory/Orders/Framework/`inne`, a testy je uruchamiają; usunięcie przed odłączeniem testów byłoby przedwczesne.
- Package/desktop identifiers i snap nadal używają `ready_next`; rename wymaga osobnego audytu instalacji, deep linków i telemetry.
- Nie potwierdzono faktycznego działania czterech hostów platformowych w tym pakiecie; wymagają bramki 6E.

## Weryfikacja pakietu

Uruchomiono wyłącznie odczytowe, celowane `rg`/`sed` oraz wymagane `git status --short`. Nie uruchamiano Flutter, buildów ani pełnych testów. `git diff --check` należy wykonać po zapisaniu dokumentu jako jedyną bramkę jakości tego pakietu.
