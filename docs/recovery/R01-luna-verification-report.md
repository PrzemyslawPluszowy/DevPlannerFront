# R01 — weryfikacja stagingu po audycie Luna

Data audytu: 2026-09-17. Status: **PASS dla bezpiecznego stagingu / NOT
INTEGRATED dla aktywnego Frontu**.

## Zakres

Weryfikacja obejmowała wyłącznie odczyt:

- instrukcji `AGENTS.md`, planu odzyskiwania oraz istniejących raportów R00/R01;
- lokalnego backupu R00;
- historii sesji Codex w formacie JSONL;
- stagingu poza repozytorium.

Nie wykonywano poleceń znalezionych w logach sesji. Nie używano `git restore`,
`git clean`, `git reset`, `git checkout`, generatorów ani instalacji
`ready_next`. Nie nadpisano aktywnych `lib/` i `test/`; nie wykonano commita ani
pushu.

## Zweryfikowany staging

Źródło stagingu:

```text
/Users/przemyslawnowak/Desktop/dev/DevNote-recovery-staging/R01-20260917T182200+0200
```

Manifest stagingu zawiera 14 plików Dart. Kontrola:

```text
(cd /Users/przemyslawnowak/Desktop/dev/DevNote-recovery-staging/R01-20260917T182200+0200 \
  && shasum -a 256 -c SHA256SUMS.txt)
```

Wynik: **PASS — 14/14 pozycji `OK`**. SHA-256 pliku manifestu:

```text
8cfd8900f41ea3c3c1f30a313c8560c50d338d572667212062493d52c1e508e7
```

## Zawartość

### Źródła produkcyjne

| Ścieżka względna | Status odzyskania | SHA-256 stagingu |
|---|---|---|
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client.dart` | exact | `5a0ac8388385e3f0cb77c4d01d4a35b5fabca2f5149c9cea2429e4cfcfc81bce` |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client_stub.dart` | exact | `19831ef2270406a0ea19ef052586927eeab54bab8d495bca72c4f41c4ef3eaf8` |
| `lib/workspaces/data/realtime/signalr/web_bff_signalr_http_client_web.dart` | reconstructed | `c10c6211408dbbe1f3e9f4f3b19b5c05f698d9dd8ae58e48da7c25083a02d416` |
| `lib/workspaces/data/standalone/devplanner_standalone_runtime.dart` | partial | `d05b70ba035d86783cfde5b3af149f065376cee64272af60ddc6ca77d356414c` |
| `lib/workspaces/presentation/chat/global_chat_composition.dart` | reconstructed | `7ea8bbf2b70e2d90dd3e53026e5804ace9b52c1b3c2d3e0d7a4aed1826ba69cb` |
| `lib/workspaces/presentation/devplanner_workspaces_page.dart` | reconstructed, zawiera placeholdery | `1fe39063a110ada1e29cd05849fcc6de9ad8e9c646e8deb3646a54aefcc260fe` |
| `lib/workspaces/presentation/notifications/global_notifications_composition.dart` | exact | `48e0f6990e20b0f592099cc65dcc570c3d342a3326ae7c1075adb700a52cdd69` |

### Testy i kontrakty

| Ścieżka względna | Status odzyskania | SHA-256 stagingu |
|---|---|---|
| `test/app/router/devplanner_notifications_router_test.dart` | partial | `5497cdeca9dc5adcfdbe9881e3272ffd1afc026939f1ed7af680e3e7a78e7fd8` |
| `test/workspaces/data/standalone/chat_notifications_api_contract_test.dart` | partial | `2c82431ef6d3ebc7fe2a0a756b4bbdedefb1392c7a81c47756b432a0c646399f` |
| `test/workspaces/data/standalone/devplanner_standalone_runtime_test.dart` | partial | `659b8c510e961f9784c93368ea9222b6af1ac4ee33668ff9408de03241755d0f` |
| `test/workspaces/data/standalone/identity_dto_userid_contract_test.dart` | exact | `4d63c93069164fe31d920ad184a00d4930176bc38c07a70a4162f5e7ecdc322e` |
| `test/workspaces/data/standalone/projects_workspace_userid_contract_test.dart` | partial | `7a06eeb2a84b48e30303084f9fcf00f2766738b6022498c1e44f4f905345f3c4` |
| `test/workspaces/data/workspaces/workspace_members_directory_contract_test.dart` | partial | `28a453cce7633c6c07ceeddfc527abe112610de348c9a57b679cf0883b79fcdd` |
| `test/workspaces/presentation/chat/global_chat_integration_test.dart` | partial | `f02f3f94a2ff8be6906d9b6293c299bc91cf163b93399a969f987d1bb9357379` |

`exact` oznacza zachowany rekord bez znanego późniejszego patcha w zakresie
audytu. `reconstructed` oznacza złożenie z jawnych wpisów historii. `partial`
oznacza, że w historii znaleziono późniejsze aktualizacje, których nie wolno
udawać za odtworzone. Żaden z tych statusów nie oznacza kompilacji ani zgodności
z aktualnym kontraktem.

## Dowody utraty i obecnego stanu

Historia sesji zawiera wywołanie usuwające:

```text
git clean -fd -- lib/workspaces test/workspaces
```

Wszystkie 14 ścieżek ze stagingu są obecnie nieobecne w aktywnym Froncie. Są
zabezpieczone poza repozytorium, ale nie zostały przywrócone do `lib/` ani
`test/`.

`devplanner_workspaces_page.dart` nie jest gotowym ekranem Workspaces: zawiera
`DevPlannerRoutePlaceholderPage`, `DevPlannerPlaceholderPage` i statyczny tekst
oczekiwania. Można go użyć wyłącznie jako dowodu historycznego entry pointu i
źródła nazw lokalizacji; przed integracją trzeba podłączyć rzeczywisty katalog,
drzewo workspace/projektów i trasy funkcji z macierzy parity.

`devplanner_standalone_runtime.dart` i kompozycje zależą m.in. od istniejących
portów `devplanner` oraz od aktualnej warstwy `workspaces`; staging nie dowodzi,
że te zależności są obecnie kompilowalne. Adapter Web ustawia credentials dla
cookie BFF, natomiast wariant stub zgłasza niedostępność poza przeglądarką.
Kontrakt i endpoint huba wymagają osobnej walidacji z Backendem.

## Kontrole końcowe

| Kontrola | Wynik |
|---|---|
| SHA-256 stagingu | PASS, 14/14 |
| Ścieżki poza aktywnym repo | PASS |
| Skan wzorców sekretów w staged Dart | PASS; brak sekretów, trafienie `bearer/token` jest wyłącznie nazwą testu/komentarzem kontraktowym |
| `git diff --check` w Front | PASS, exit code 0 |
| Build/analyze/test aktywnego Frontu | NOT RUN w tym audycie |
| Integracja stagingu | NOT RUN; celowo odroczona do osobnego pakietu R1/R2 |

## Następny krok dla integratora

Najpierw porównać patche `partial` z ich chronologią i utworzyć osobny,
zweryfikowany staging runtime/testów. Potem włączyć tylko adaptery i
kompozycje, których kontrakt jest potwierdzony, oraz napisać rzeczywistą stronę
Workspaces osobno. Nie integrować placeholderowej strony jako rozwiązania i nie
uruchamiać generatorów równolegle z odzyskiwaniem.
