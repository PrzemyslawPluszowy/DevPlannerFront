# R1/B0 — bezpieczna integracja root entry points

Data: 2026-09-17. Repozytorium: `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`.
Status: **PARTIAL PASS — dwa porty kompozycji przywrócone; root nadal nie jest
kompilowalny jako całość**.

## Cel pakietu

Pakiet miał bezpiecznie włączyć wyłącznie odzyskane pliki produkcyjne, których
aktualny `DevPlannerApp` i `DevPlannerRouter` wymagają bezpośrednio. Nie miał
odtwarzać placeholdera Workspaces, integrować niepełnych artefaktów ani
maskować niespójności `ready_next` aliasem lub zależnością.

## Stan przed zmianą

Przed zmianą wykonano `git status --short`. Worktree był już silnie zmieniony
przez wcześniejsze pakiety; pliki rootu `lib/app/*`, `lib/bootstrap/*` oraz
`lib/workspaces/data/standalone/devplanner_standalone_runtime.dart` były
nieśledzone lub zmodyfikowane. Nie wykonywano `restore`, `clean`, `reset`,
`checkout`, commita ani pushu. Nie modyfikowano plików rootu ani plików
realtime, nad którymi pracują inne pakiety.

Aktywny root importował:

- `DevPlannerGlobalChatComposition`;
- `DevPlannerGlobalNotificationsComposition`;
- `DevPlannerStandaloneRuntime`.

Pierwsze dwa pliki nie istniały w aktywnym worktree. Runtime już istniał jako
plik nieśledzony i ma hash stagingu pozycji `partial`; w tym pakiecie nie został
zmieniony ani awansowany do integracji.

## Włączone pliki

Przywrócono z R01 stagingu, a następnie sformatowano:

1. `lib/workspaces/presentation/chat/global_chat_composition.dart`
2. `lib/workspaces/presentation/notifications/global_notifications_composition.dart`

Oba pliki są niemutowalnymi portami kompozycji. Nie tworzą klienta HTTP,
SignalR, storage ani stanu globalnego; otrzymują wyłącznie typowane porty od
composition rootu. Każdy plik ma mniej niż 400 linii i dokumentację po polsku.

Hash źródeł w stagingu R01:

- Chat: `7ea8bbf2b70e2d90dd3e53026e5804ace9b52c1b3c2d3e0d7a4aed1826ba69cb`
- Notifications: `48e0f6990e20b0f592099cc65dcc570c3d342a3326ae7c1075adb700a52cdd69`

Staging manifest: `8cfd8900f41ea3c3c1f30a313c8560c50d338d572667212062493d52c1e508e`.
Lokalny hash pliku Chat różni się od stagingu wyłącznie przez wynik
`dart format` (wcięcie operatorów warunkowych); plik Notifications zachował
hash stagingu.

## Świadomie niewłączone pliki

- `lib/workspaces/presentation/devplanner_workspaces_page.dart` — staging
  jednoznacznie oznacza plik jako placeholder (`DevPlannerRoutePlaceholderPage`,
  `DevPlannerPlaceholderPage`, tekst oczekiwania). Integracja udawałaby gotową
  funkcję Workspaces i byłaby sprzeczna z wymaganiem przywrócenia realnego
  katalogu workspace/projektów.
- `lib/workspaces/data/standalone/devplanner_standalone_runtime.dart` — status
  `partial`; późniejszy patch nie został odzyskany. Aktualny nieśledzony plik
  istnieje, ale nie został dotknięty w B0. Wymaga osobnego review i pełnego
  import graph.
- `web_bff_signalr_http_client*.dart` — nie są importowane przez aktualny root,
  a backend-contract-map-review potwierdza, że Web BFF SignalR nie ma jeszcze
  kompletnego, zweryfikowanego transportu cookie/CSRF/origin. Nie wolno
  integrować pozornej obsługi realtime.
- wszystkie staged testy `partial` — pominięte, ponieważ ich późniejsze patche
  nie zostały odtworzone; nie wolno traktować ich jako dowodu.

## Kontrole

Uruchomiono faktycznie:

```text
dart format --output=none \
  lib/workspaces/presentation/chat/global_chat_composition.dart \
  lib/workspaces/presentation/notifications/global_notifications_composition.dart
=> exit 0

flutter analyze \
  lib/workspaces/presentation/chat/global_chat_composition.dart \
  lib/workspaces/presentation/notifications/global_notifications_composition.dart
=> exit 0, No issues found!

git diff --check
=> exit 0
```

Nie uruchamiano pełnego `flutter analyze`, generatora ani pełnych testów, bo
aktywny graf Workspaces nadal zawiera liczne importy `package:ready_next` i
niezintegrowane, niezgodne kontrakty. Nie jest to PASS całości aplikacji.

## Aktualne blokery

1. `lib/workspaces/domain/**`, modele Chat/Notifications, repozytoria oraz
   realtime nadal importują `package:ready_next`; nie wolno dodawać tego pakietu
   do `pubspec.yaml`.
2. Część źródeł publikuje `coreUserId`/`actorCoreUserId`, podczas gdy backend
   publikuje lokalne `UserId`/`ActorUserId`. Wymaga to osobnego pionowego
   pakietu migracji źródło → mapper → call-site → generator.
3. Nie ma podstaw do uruchomienia Web SignalR z BFF bez domknięcia kontraktu
   cookie/CSRF/origin i testu z backendem.
4. Aktualna trasa `/workspaces` nadal nie ma realnego katalogu; placeholder nie
   został użyty jako obejście.

## Następny krok

Właściciel kolejnego pakietu powinien zmigrować jeden pion Chat/Notifications
od portów domenowych i modeli, usuwając `ready_next` z tego pionu zgodnie z
`docs/recovery/backend-contract-map.md`. Najpierw źródła i testy mapowania,
potem generator; nie wykonywać masowego rename ani generatora równolegle z
przenoszeniem źródeł. Po tym dopiero można ponownie ocenić runtime i podłączenie
realnych widoków.

## Synchronizacja dokumentacji

Zaktualizowano identycznie oba repozytoria:

- `docs/devplanner-standalone-refactor-plan.md`;
- `docs/devplanner-standalone-refactor-handoff.md`.

`cmp` obu par plików zakończył się PASS po zmianie. Raport ten jest źródłem
szczegółów integracji B0 i nie oznacza ukończenia produktu.
