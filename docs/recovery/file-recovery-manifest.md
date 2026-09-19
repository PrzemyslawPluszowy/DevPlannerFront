# Manifest odzyskania plików R01

Data: 2026-09-17. Status: **inwentaryzacja i staging, bez integracji z worktree**.

## Zasady i granice

Kopia R00 została zweryfikowana przed tym etapem. Ten manifest opisuje wyłącznie
odczyt danych z historii Codex i VS Code oraz ich zapis do osobnego katalogu
staging. Nie wykonano żadnego polecenia ani kodu z historycznych logów i nie
nadpisano plików w `lib/` ani `test/` Frontu. Nie wykonano restore, clean,
reset, commita ani push.

Katalog staging (poza repozytorium):

```text
/Users/przemyslawnowak/Desktop/dev/DevNote-recovery-staging/R01-20260917T182200+0200
```

`SHA256SUMS.txt` w tym katalogu obejmuje 14 plików Dart. Skan wzorców sekretów
(`password`, API key, access/refresh token, client secret i Bearer) nie zwrócił
trafień w staged źródłach. Hash manifestu: `8cfd8900f41ea3c3c1f30a313c8560c50d338d572667212062493d52c1e508e7`.

Statusy: **exact** — zachowany kompletny rekord bez późniejszego patcha;
**reconstructed** — złożony z jawnych patchy chronologicznych; **partial** —
ostatni znany patch nie został jeszcze odtworzony; **missing** — brak treści.
`exact` i `reconstructed` nie znaczą jeszcze, że plik jest zgodny z obecnym
kontraktem ani kompiluje się.

## Usunięte przez `git clean -fd`

Log Codex z 2026-09-17 17:34:19Z potwierdza usunięcie trzech adapterów SignalR,
całego `data/standalone/`, obu kompozycji, strony Workspaces, całych testów
standalone, testu katalogu i testu globalnego Chat. Poniższy staging obejmuje
rozpoznane pliki z tych katalogów; nie zakłada kompletności nieznanych plików
z katalogów usuniętych rekurencyjnie.

| Ścieżka docelowa | Status | Źródło i czas | Ostatni znany patch | SHA-256 staging |
|---|---|---|---|---|
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client.dart` | exact | Codex `01a0af07…`, 2026-09-17 11:53:41Z | add 11:53:41Z | `5a0ac8388385e3f0cb77c4d01d4a35b5fabca2f5149c9cea2429e4cfcfc81bce` |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client_stub.dart` | exact | Codex `01a0af07…`, 2026-09-17 11:53:41Z | add 11:53:41Z | `19831ef2270406a0ea19ef052586927eeab54bab8d495bca72c4f41c4ef3eaf8` |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client_web.dart` | reconstructed | Codex `01a0af07…`, 2026-09-17 11:53:41Z | add + update 11:56:00Z (`null` ctor argument) | `c10c6211408dbbe1f3e9f4f3b19b5c05f698d9dd8ae58e48da7c25083a02d416` |
| `lib/workspaces/data/standalone/devplanner_standalone_runtime.dart` | partial | Codex `01a0adda…`, 2026-09-17 05:38:15Z; R00 snapshot | add 05:38:20Z, późniejszy update 11:55:20Z nieodtworzony | `d05b70ba035d86783cfde5b3af149f065376cee64272af60ddc6ca77d356414c` |
| `lib/workspaces/presentation/chat/global_chat_composition.dart` | reconstructed | Codex `01a0ab4c…`, odczyt końcowy 2026-09-16 17:57:38Z | add 17:41:59Z + update 17:43:47Z | `7ea8bbf2b70e2d90dd3e53026e5804ace9b52c1b3c2d3e0d7a4aed1826ba69cb` |
| `lib/workspaces/presentation/notifications/global_notifications_composition.dart` | exact | Codex `01a0ab5e…`, odczyt 2026-09-16 18:08:08Z | add 18:00:05Z | `48e0f6990e20b0f592099cc65dcc570c3d342a3326ae7c1075adb700a52cdd69` |
| `lib/workspaces/presentation/devplanner_workspaces_page.dart` | reconstructed | Codex `01a0aaf7…`, 2026-09-16 | add 16:29:49Z + `DevPlannerRoutePlaceholderPage` 16:38:15Z | `1fe39063a110ada1e29cd05849fcc6de9ad8e9c646e8deb3646a54aefcc260fe` |
| `test/workspaces/data/standalone/devplanner_standalone_runtime_test.dart` | partial | Codex `01a0adda…`, 2026-09-17 05:41:23Z | add; update 11:56:58Z nieodtworzony | `659b8c510e961f9784c93368ea9222b6af1ac4ee33668ff9408de03241755d0f` |
| `test/workspaces/data/standalone/chat_notifications_api_contract_test.dart` | partial | Codex `01a0adc0…`, 2026-09-17 06:55:04Z | add; updates 06:56:18Z i 07:04:15Z nieodtworzone | `2c82431ef6d3ebc7fe2a0a756b4bbdedefb1392c7a81c47756b432a0c646399f` |
| `test/workspaces/data/standalone/identity_dto_userid_contract_test.dart` | exact | Codex `01a0ae65…`, 2026-09-17 08:14:48Z | add 08:14:48Z | `4d63c93069164fe31d920ad184a00d4930176bc38c07a70a4162f5e7ecdc322e` |
| `test/workspaces/data/standalone/projects_workspace_userid_contract_test.dart` | partial | Codex `01a0ae65…`, 2026-09-17 08:09:54Z | add; update 08:10:06Z nieodtworzony | `7a06eeb2a84b48e30303084f9fcf00f2766738b6022498c1e44f4f905345f3c4` |
| `test/workspaces/data/workspaces/workspace_members_directory_contract_test.dart` | partial | Codex `01a0ae65…`, 2026-09-17 07:55:48Z | add; updates 07:59:54Z i 08:00:43Z nieodtworzone | `28a453cce7633c6c07ceeddfc527abe112610de348c9a57b679cf0883b79fcdd` |
| `test/workspaces/presentation/chat/global_chat_integration_test.dart` | partial | Codex `01a0ab4c…`, 2026-09-16 17:48:12Z | add; updates 17:49:39Z, 17:50:29Z, 17:54:36Z, 17:56:06Z nieodtworzone | `f02f3f94a2ff8be6906d9b6293c299bc91cf163b93399a969f987d1bb9357379` |

## Poza logiem clean, lecz powiązane z globalnymi panelami

| Ścieżka docelowa | Status | Źródło i czas | Ostatni znany patch | SHA-256 staging |
|---|---|---|---|---|
| `test/app/router/devplanner_notifications_router_test.dart` | partial | Codex `01a0ab5e…`, 2026-09-16 18:03:51Z | add; updates 18:04:09Z, 18:05:40Z, 18:07:02Z nieodtworzone | `5497cdeca9dc5adcfdbe9881e3272ffd1afc026939f1ed7af680e3e7a78e7fd8` |

VS Code zachowało jeden record `ZOVk.dart` (router, 2026-09-17 05:13:07Z),
który importuje trzy utracone entry points. Jest dowodem ich konsumenta, ale
nie zawiera ich treści, więc nie podnosi statusu żadnego pliku.

## Pliki tracked nadpisane przed clean

`git restore --source=HEAD --worktree -- lib/workspaces test/workspaces` został
wykonany 2026-09-17 17:34:10Z. W rezultacie wszystkie wtedy zmodyfikowane,
śledzone pliki w tych dwóch drzewach zostały zastąpione wersją `HEAD`; historia
nie daje w tym miejscu kompletnej, bezpośredniej listy diffów. Bezpośredni
zapis stanu z 12:02:19Z identyfikuje co najmniej następujące nadpisane pliki
realtime: `chat_realtime_event_mapper.dart`, `workspace_chat_realtime_service.dart`,
`workspace_notifications_realtime_service.dart`, `workspace_scoped_realtime_service.dart`,
`workspace_signalr_client.dart` i `task_project_realtime_adapter.dart`.
Ich odtworzenie nie jest objęte tym stagingiem, bo nie wolno nadpisywać `lib/`
ani `test/` bez osobnego porównania patchy.

Pliki z brakiem źródła nie są deklarowane jako odzyskane. Następny etap musi
wyciągnąć wskazane ostatnie patche dla pozycji `partial`, porównać je ze
stagingiem oraz włączyć wyłącznie zatwierdzone wersje przez osobny pakiet R1.
