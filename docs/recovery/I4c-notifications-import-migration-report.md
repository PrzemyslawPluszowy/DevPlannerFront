# I4c — audyt importów powiadomień

## Zakres

Audyt obejmował wyłącznie istniejący obszar powiadomień:

- `lib/workspaces/data/notifications/**`
- `lib/workspaces/domain/notifications/**`
- `lib/workspaces/domain/repositories/notifications_repository.dart`
- `lib/workspaces/presentation/notifications/**`

Nie implementowano nowego UI powiadomień, czatu, routingu, bootstrapu ani
transportu realtime.

## Wykonane zmiany

W plikach transportu, modeli, repozytoriów, Cubitów i prezentacji zmigrowano
importy `package:ready_next/...` na `package:devplanner/...` wyłącznie wtedy,
gdy odpowiadający plik istnieje już w repozytorium Front. Dotyczy to m.in.:

- API i repozytoriów powiadomień;
- modeli oraz enumów powiadomień;
- kontraktów domenowych i `NotificationsRepository`;
- Cubitów skrzynki, licznika i statusu realtime;
- preferencji i odpowiedzi na powiadomienie.

Przy migracji adaptera odpowiedzi dopasowano wyłącznie nazwy aktualnego
kontraktu lokalnych modeli Chat: `authorCoreUserId` → `authorUserId` oraz
`attachedByCoreUserId` → `attachedByUserId`. Nie zmieniono ścieżki API ani
logiki biznesowej.

## Wynik audytu zależności

Pozostały pięć importów `ready_next`, których nie wolno było podmienić
mechanicznie, bo w nowym repozytorium nie ma równoważnego kontraktu:

- `app/shell/overlay/app_modal_host.dart` — trzy modale powiadomień;
- `app/router/app_deep_link.dart` i `app/router/app_router.dart` — nawigacja
  z elementów skrzynki.

Obecny router DevPlanner i nowe komponenty modali mają inne API. Podstawienie
ich „na oko” byłoby implementacją funkcjonalności, a nie migracją importu;
pozostawiono to jako osobny etap refaktoryzacji powiadomień po ustaleniu
docelowego globalnego overlayu.

## Walidacja

Uruchomiono:

```text
flutter analyze lib/workspaces/data/notifications \
  lib/workspaces/domain/notifications \
  lib/workspaces/domain/repositories/notifications_repository.dart \
  lib/workspaces/presentation/notifications
```

Wynik: błędy pozostały wyłącznie w opisanych wyżej brakujących adapterach
routera/modala (`ready_next`) oraz wynikające z nich symbole `AppModalHost`,
`AppDeepLink` i `context.router`. Po migracji nazw modeli nie ma już błędów
kompilacji w adapterze odpowiedzi Chat. Pozostały komunikaty lintujące o
sortowaniu importów.

W istniejącym `notification_reply_modal.dart` nadal znajduje się wcześniejsze
`setState`; nie zmieniałem go w tym zadaniu, ponieważ migracja stanu lokalnego
na `ValueNotifier` wymaga osobnego refaktoru UI. Nowe zmiany nie dodały
`setState`, globalnych funkcji ani nowych klas przekraczających 400 linii.

## Następny krok

Najpierw należy przygotować wspólny, standalone adapter globalnego overlayu i
adapter nawigacji DevPlanner. Dopiero wtedy można usunąć ostatnie importy
`ready_next`, rozbić stare widoki powiadomień zgodnie z limitem 400 linii oraz
przenieść lokalny stan modala na `ValueNotifier`/`ValueListenableBuilder`.
