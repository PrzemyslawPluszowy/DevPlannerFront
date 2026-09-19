# R01b — rekonstrukcja ostatnich patchy plików częściowych

Data: 2026-09-17. Status: **PASS dla bezpiecznego stagingu; NOT INTEGRATED**.

## Granice pracy

Praca została wykonana wyłącznie w katalogu poza repozytorium:

```text
/Users/przemyslawnowak/Desktop/dev/DevNote-recovery-staging/R01b-20260917T205304+0200
```

Nie wykonywałem `git clean`, `restore`, `reset` ani `checkout`. Nie kopiowałem
żadnego pliku z tego stagingu do `Front/lib/` ani `Front/test/`. Nie uruchamiałem
poleceń ani kodu wyciągniętego z logów sesji. Rekonstrukcja oznacza tu
chronologiczne zastosowanie jawnych patchy zapisanych w historii Codex do kopii
stagingowej; nie oznacza zgodności z docelowym kontraktem standalone.

## Dowody walidacji

- `dart format --output=none` dla 20 plików Dart: **PASS**; formatowanie stagingu
  zmieniło 9 plików.
- `shasum -a 256 -c SHA256SUMS.txt`: **PASS** dla 20 plików.
- skan sekretów (hasła, client secret, access/refresh token, Bearer): **brak
  trafień**.
- `git diff --check` aktywnego Frontu: **PASS** w chwili audytu.
- Skan zależności legacy: **FAIL celowo odnotowany** — odzyskane historyczne
  pliki realtime zawierają importy `package:ready_next`. Nie zmieniałem ich
  mechanicznie, ponieważ byłaby to nowa transformacja, a nie udowodnione
  odzyskanie. R2 musi zastąpić te importy przez kontrakty `devplanner` i
  naprawić zależności.

## Rekonstruowane pliki częściowe i utracone entry-pointy

| Ścieżka | Wcześniej → teraz w R01b | Źródło / czas ostatniego patcha | SHA-256 | Status | Zależności / uwaga |
|---|---|---|---|---|---|
| `lib/workspaces/data/standalone/devplanner_standalone_runtime.dart` | plik usunięty → wersja po add, korekcie typu i web BFF SignalR | Codex `01a0adda…` ord. 256, `2026-09-17T05:38:15Z`; ord. 263 `05:38:20Z`; Codex `01a0af07…` ord. 1011 `11:55:20Z` | `6ce240b8b45459dddba52fcb7073c6286a267f83b271daad515f0a520c3285a7` | reconstructed | `AuthComposition`, HTTP transport, Chat/Notifications API i realtime; zawiera historyczne importy sprawdzone w raporcie |
| `test/workspaces/data/standalone/devplanner_standalone_runtime_test.dart` | test usunięty → test z asercjami web-cookie SignalR | `01a0adda…` ord. 370 `05:41:23Z`; `01a0af07…` ord. 1059 `11:56:58Z` | `a8449bd2ae6676b59eb722863319de4040a46cc29bce86fe3363925565ada73d` | reconstructed | wymaga aktualnych kompozycji i `devplanner` importów |
| `test/workspaces/data/standalone/chat_notifications_api_contract_test.dart` | test usunięty → kontrakt z `userId` i enumami PascalCase | `01a0ae20…` ord. 279 `06:55:04Z`; ord. 332 `06:56:18Z`; ord. 614 `07:04:15Z` | `2c82431ef6d3ebc7fe2a0a756b4bbdedefb1392c7a81c47756b432a0c646399f` | reconstructed | modele Chat/Notifications; nie uruchomiony w izolowanym stagingu |
| `test/workspaces/data/standalone/projects_workspace_userid_contract_test.dart` | test usunięty → kontrakt z lokalnym `userId` i enumami backendu | `01a0ae65…` ord. 313 `08:09:54Z`; ord. 327 `08:10:06Z` | `d4737061a8ec54bb13fee40ea3a605223deac542820f60aa4301f292fc819ca8` | reconstructed | modele Projects/Workspaces/Portfolios |
| `test/workspaces/data/workspaces/workspace_members_directory_contract_test.dart` | test usunięty → katalog członków i zaproszenia | `01a0ae58…` ord. 308 `07:55:48Z`; zapisany patch ord. 557 `08:00:43Z` był już obecny w wyciągniętej treści | `28a453cce7633c6c07ceeddfc527abe112610de348c9a57b679cf0883b79fcdd` | reconstructed | modele members/directory/invitations; wymaga potwierdzenia finalnego OpenAPI |
| `test/workspaces/presentation/chat/global_chat_integration_test.dart` | test usunięty → panel kompozycji i bezpieczna asercja widgetu | `01a0ab4c…` ord. 408 `2026-09-16T17:48:12Z`; ord. 477 `17:49:39Z`; ord. 527 `17:50:29Z`; ord. 596 `17:54:36Z`; ord. 656 `17:56:06Z` | `aafd3b18c43f8eda991d548184c81489d17dd4faf5338c1a74e39a594d9a5fb8` | reconstructed | globalny Chat, router navigation i l10n; historyczne API może wymagać migracji |
| `test/app/router/devplanner_notifications_router_test.dart` | test usunięty → deep link + fail-closed transport | `01a0ab5e…` ord. 273 `2026-09-16T18:03:51Z`; ord. 412 `18:05:40Z`; ord. 488 `18:07:02Z` | `6b5c91b9ff0d15d1d8da965a4a691a91f9aff219330d74ae2de66690312ca3fa` | reconstructed | router, AuthComposition, l10n i Notifications composition |
| `lib/workspaces/presentation/chat/global_chat_composition.dart` | utracony entry-point → ostatnia znana kompozycja | `01a0ab4c…`, add `2026-09-16T17:41:59Z` + update `17:43:47Z` | `7ea8bbf2b70e2d90dd3e53026e5804ace9b52c1b3c2d3e0d7a4aed1826ba69cb` | reconstructed | repository, Cubity, upload/file picker; nie integrować bez mapy importów |
| `lib/workspaces/presentation/notifications/global_notifications_composition.dart` | utracony entry-point → ostatnia znana kompozycja | `01a0ab5e…`, add `2026-09-16T18:00:05Z` | `48e0f6990e20b0f592099cc65dcc570c3d342a3326ae7c1075adb700a52cdd69` | exact | Notifications repository/realtime; wymaga migracji importów |
| `lib/workspaces/presentation/devplanner_workspaces_page.dart` | utracona strona → ostatnia znana strona z placeholder route | `01a0aaf7…`, add `2026-09-16` + update `16:38:15Z` | `1fe39063a110ada1e29cd05849fcc6de9ad8e9c646e8deb3646a54aefcc260fe` | reconstructed | to nie jest dowód pełnego ekranu Workspaces; placeholder nie spełnia odbioru produktu |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client.dart` | utracony adapter web → adapter conditional import | `01a0af07…` ord. 976 `11:53:05Z` | `5a0ac8388385e3f0cb77c4d01d4a35b5fabca2f5149c9cea2429e4cfcfc81bce` | exact | zależy od `signalr_netcore` i wariantu web/stub |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client_stub.dart` | utracony stub → stub UnsupportedError | `01a0af07…` ord. 976 `11:53:05Z` | `19831ef2270406a0ea19ef052586927eeab54bab8d495bca72c4f41c4ef3eaf8` | exact | platform conditional import |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client_web.dart` | utracony klient browser → klient z credentials | `01a0af07…` ord. 976 `11:53:05Z`; ord. 1032 `11:56:00Z` | `c10c6211408dbbe1f3e9f4f3b19b5c05f698d9dd8ae58e48da7c25083a02d416` | reconstructed | `http/browser_client`, SignalR; wymaga przeglądarkowego testu BFF |
| `test/workspaces/data/standalone/identity_dto_userid_contract_test.dart` | test usunięty → zachowana treść add | `01a0ae65…`, add `2026-09-17T08:14:48Z` | `4d63c93069164fe31d920ad184a00d4930176bc38c07a70a4162f5e7ecdc322e` | exact | lokalny UUID `userId` |

## Tracked realtime nadpisany przed `git clean`

Poniższe pliki zostały skopiowane do R01b jako osobna kopia poza repozytorium.
Tam, gdzie historia zawierała jawny patch, zastosowałem go do kopii wersji
`HEAD`. Samo skopiowanie wersji `HEAD` nie jest deklarowane jako odzyskanie.

| Ścieżka | Stan w R01b | Źródło / czas | SHA-256 | Status | Zależności / uwaga |
|---|---|---|---|---|---|
| `lib/workspaces/data/realtime/signalr/workspace_signalr_client.dart` | `HEAD` + web BFF constructor, CSRF headers, cookie client i auth-fail close | `01a0af07…` ord. 997 `11:54:31Z`; ord. 1004 `11:54:39Z` | `e5839404906641a24bc4732307e8388a676abe4ce509bb670ac1eae965580ee1` | reconstructed | `signalr_netcore`; wymaga aktualnego backendowego handshake i testu 401/403 |
| `lib/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart` | `HEAD` + BFF factory oraz finalne poprawki konstruktora/formatowania | `01a0af07…` ord. 1011 `11:55:20Z`; ord. 1032 `11:56:00Z`; ord. 1074 `11:57:44Z`; ord. 1088 `11:58:26Z`; ord. 1109 `11:58:49Z` | `22299f3c1ca75ee69c4208edb4fc7395934ec8e2204e7d1bf3e83b5af4f9d31b` | reconstructed | nadal zawiera historyczny `package:ready_next`; wymaga migracji przed integracją |
| `lib/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart` | `HEAD` + factory BFF | `01a0af07…` ord. 1011 `11:55:20Z` | `4385687ecffc13a1a021f4d8dd2bf7993fcb07dea36327f50bcb8583a36bf03f` | reconstructed | nadal zawiera historyczny `package:ready_next`; wymaga migracji |
| `lib/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart` | `HEAD` + mapowanie `authorUserId` | `01a0ae20…` ord. 722 `07:05:53Z` | `40ccf1c8e2fe1dbafc102dce2524b328b8b11b493e7b514b2c281b5079236e76` | partial | historia nie zawiera pełnego stanu tuż przed restore; możliwe wcześniejsze patche |
| `lib/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart` | `HEAD` + mapowanie `actorUserId`/presence `userId` | `01a0ae57…` ord. 236 `07:54:21Z` | `5b02c868c93d3555a920f84f0459cfc2081c8194280a2b326b82449edab0e84e` | partial | historia nie zawiera pełnego stanu tuż przed restore; wymaga porównania z backendowym kontraktem |
| `lib/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart` | kopia wersji `HEAD`, bez dowodu historycznego patcha | brak bezpośredniego `FileChange` dla ścieżki | `c5f8ad874f60bc052f6f56256d60eba79bb88bae8422cd1ab3398ce3eaabbad9` | missing | nie traktować jako odzyskane; odtworzyć dopiero z pełnego źródła lub napisać zgodną implementację po kontrakcie |

## Czego nie deklaruję jako odzyskane

Nie ma dowodu kompletnego stanu plików `workspace_scoped_realtime_service.dart`
ani wszystkich wcześniejszych zmian mappera i adaptera tasków. Nie podnoszę ich
statusu do `exact`. Nie ma też dowodu, że odzyskana strona Workspaces zastępuje
wcześniejszą funkcjonalność — zawiera znany placeholder i musi zostać podłączona
do prawdziwych ekranów w R2/R3.

R01b jest więc materiałem do kontrolowanego pakietu integracyjnego, a nie zgodą
na bezpośrednie skopiowanie całego stagingu do aktywnego Frontu. Następny agent
powinien porównać każdy plik z aktualnym OpenAPI/backendem, zastąpić importy
Ready/legacy przez `devplanner`, uruchomić testy targeted i dopiero wtedy
integrować małe, zatwierdzone porcje.
