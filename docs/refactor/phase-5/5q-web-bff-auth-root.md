# Pakiet 5Q — webowy root autoryzacji BFF

Data: 2026-09-17  
Repozytorium: `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`  
Status: **zaimplementowane i zweryfikowane targeted gate**

## Zakres

Podłączono produkcyjną ścieżkę webowego BFF do standalone bootstrapu. Zakres
nie obejmuje desktopowego PKCE, refresh tokenów desktopowych ani żadnych
połączeń Ready/Core/DataBus.

## Wykonane zmiany

- Dodano warunkowy, platformowy `PlatformWebBffBrowserLauncher`.
  - Web ustawia top-level `window.location.href` na `/bff/auth/start`.
  - Pozostałe platformy pozostają fail-closed i nie emulują webowego BFF.
- Dodano `DevPlannerWebBffBootstrap`, który wymaga cookie transportu Web bez
  Bearera i składa `AuthComposition.webBff`.
- Standalone `bootstrap()` na Web tworzy domyślny transport z
  `DEVPLANNER_API_BASE_URL`, składa BFF composition i wykonuje
  `restoreSession()` przed `runApp()`.
- `HttpWebBffSessionTransport.signIn()` nie wykonuje `/bff/session` po
  prawdziwym top-level redirect. Po nawigacji nowy bootstrap odtwarza cookie
  sesję, a fake launchery mogą nadal testować powrót w tym samym procesie.
- Zachowano walidację lokalnego `returnTo` przez istniejące
  `AuthReturnTo.sanitize`; credentials formularza nie są wysyłane do BFF.

## Pliki

- `lib/auth/data/adapters/web_bff_auth_adapter.dart`
- `lib/auth/data/adapters/web_bff_browser_launcher.dart`
- `lib/auth/data/adapters/web_bff_browser_launcher_stub.dart`
- `lib/auth/data/adapters/web_bff_browser_launcher_web.dart`
- `lib/bootstrap/app_bootstrap.dart`
- `lib/bootstrap/web_bff_bootstrap.dart`
- `test/auth/auth_composition_test.dart`
- `test/auth/web_bff_bootstrap_test.dart`
- `test/auth/web_bff_browser_launcher_test.dart`
- `test/auth/auth_route_page_test.dart`

## Dowody walidacji

Targeted test command:

```bash
flutter test \
  test/auth/auth_composition_test.dart \
  test/auth/auth_platform_adapters_test.dart \
  test/auth/web_bff_bootstrap_test.dart \
  test/auth/web_bff_browser_launcher_test.dart \
  test/auth/auth_route_page_test.dart \
  test/foundation/http/devplanner_http_transport_test.dart \
  test/app/devplanner_app_test.dart \
  test/app/router/devplanner_router_test.dart \
  test/app/router/devplanner_notifications_router_test.dart
```

Wynik: **39/39 PASS, 0 fail, 0 skip**.

```bash
flutter analyze lib/auth lib/bootstrap lib/foundation/http lib/app
```

Wynik: **PASS — No issues found!**

```bash
flutter build web --debug --no-tree-shake-icons
```

Wynik: **PASS — `build/web` utworzony** (63,5 s).

```bash
git diff --check
```

Wynik: **PASS**.

## Następny krok

Ten pakiet nie jest dowodem prawdziwego E2E. Następny osobny pakiet powinien
uruchomić lokalny Backend, skonfigurować testowego administratora i przejść
przez realną przeglądarkę: `/bff/auth/start` → callback → cookie/CSRF →
`/api/v1/me`. Desktopowy PKCE pozostaje osobnym pakietem platformowym.

## Follow-up 5Q.1 — bezpieczny UX wejścia BFF

Przegląd wykrył, że wcześniejszy formularz przyjmował login i hasło, chociaż
transport BFF celowo ich nie wysyłał. Zostało to usunięte:

- dla `AuthClientKind.webBff` ekran renderuje wyłącznie opis i CTA
  `Przejdź do bezpiecznego logowania`;
- CTA uruchamia interaktywny redirect przez `AuthLoginCubit`, bez pól i bez
  przechowywania hasła w Flutterze;
- dla `AuthClientKind.desktopPkce` UI pokazuje jawny stan „systemowa
  przeglądarka nie jest jeszcze skonfigurowana”, bez pozornego formularza;
- decyzja wynika z `AuthUseCases.clientKind`, nie z platformowego if-a w UI;
- teksty są w ARB (`app_pl.arb`, `app_en.arb`).

Focused follow-up:

```bash
flutter test \
  test/auth/auth_route_page_test.dart \
  test/auth/auth_composition_test.dart \
  test/auth/auth_platform_adapters_test.dart \
  test/auth/web_bff_bootstrap_test.dart \
  test/auth/web_bff_browser_launcher_test.dart \
  test/auth/auth_foundation_test.dart \
  test/app/router/devplanner_router_test.dart \
  test/app/router/devplanner_notifications_router_test.dart
```

Wynik follow-up: **30/30 PASS, 0 fail, 0 skip**. Test widgetowy potwierdza
brak `TextFormField` dla BFF i wywołanie CTA.

Scoped analyze po follow-up:

```bash
flutter analyze lib/auth lib/bootstrap lib/app lib/foundation/http
git diff --check
```

Wynik: **PASS**, `No issues found!`; `git diff --check`: **PASS**.

## Follow-up 5Q.3 — cookie-aware Web BFF SignalR seam

Webowy realtime Chat i Notifications korzysta teraz z osobnego trybu BFF
cookie. Negocjacja używa browserowego `BrowserClient.withCredentials` oraz
dynamicznego `X-DevPlanner-CSRF`; adapter nie ustawia `Authorization`, nie
przekazuje Bearera i nie dodaje `access_token` do adresu WebSocket. Desktopowy
tryb bearer pozostał bez zmian.

Runtime tworzy webowy realtime wyłącznie dla aktywnej sesji
`AuthClientKind.webBff` i transportu `isBffCookieTransport`; niespełnienie
warunków pozostaje fail-closed. Logout udostępnia kolejno `dispose()` realtime
i dopiero potem sign-out BFF. Odpowiedzi 401/403 podczas reconnectu zatrzymują
ponowienie połączenia.

Walidacja targeted:

```bash
flutter analyze lib/workspaces/data/realtime \
  lib/workspaces/data/standalone lib/foundation/http
flutter test \
  test/workspaces/data/realtime/workspace_signalr_client_test.dart \
  test/workspaces/data/standalone/devplanner_standalone_runtime_test.dart \
  test/workspaces/presentation/chat/global_chat_integration_test.dart \
  test/workspaces/presentation/notifications/global_notifications_page_test.dart
flutter build web --debug --no-tree-shake-icons
git diff --check
```

Wynik: scoped analyze **PASS**, testy **16/16 PASS**, build Web **PASS**
(`build/web`), `git diff --check` **PASS**.

## Follow-up 5Q.2 — neutralny stan po rozpoczęciu redirectu

`PlatformWebBffBrowserLauncher` ustawia `window.location.href`, więc transport
zgłasza techniczny kod `auth.bff.redirect_started` przed opuszczeniem dokumentu.
Ten kod nie jest błędem produktu:

- `AuthLoginCubit` mapuje go na osobny `AuthLoginRedirecting`;
- ekran nie renderuje komunikatu błędu, pokazuje stan przekierowania i blokuje
  ponowne kliknięcie CTA;
- pozostałe `AuthFailure` nadal trafiają do `AuthLoginFailure` i są widoczne
  użytkownikowi.

Focused follow-up:

```bash
flutter test \
  test/auth/auth_foundation_test.dart \
  test/auth/auth_route_page_test.dart \
  test/auth/auth_composition_test.dart \
  test/auth/auth_platform_adapters_test.dart \
  test/auth/web_bff_bootstrap_test.dart \
  test/auth/web_bff_browser_launcher_test.dart
```

Wynik: **24/24 PASS, 0 fail, 0 skip**. Test Cubita pokrywa zarówno kod
redirectu, jak i zachowanie zwykłych błędów; test widgetowy potwierdza brak
flashu błędu i zablokowanie CTA.

Scoped analyze i kontrola diffu:

```bash
flutter analyze lib/auth lib/bootstrap lib/app lib/foundation/http
git diff --check
```

Wynik: **PASS**, `No issues found!`; `git diff --check`: **PASS**.
