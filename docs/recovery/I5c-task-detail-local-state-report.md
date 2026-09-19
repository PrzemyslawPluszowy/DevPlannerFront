# I5c — lokalny stan widoku szczegółów zadania

Data: 2026-09-18

## Cel i granice

Pakiet usuwa `setState` wyłącznie z
`lib/workspaces/presentation/tasks/detail/**`. Nie zmienia kontraktów API,
modeli, routingu, modułów Board/List, Chat, Notifications ani Backendu.

## Zmiany

- Dialogi edycji podstaw, opisu, etykiet, przypisań, pól własnych, podzadań,
  zależności, planowania i ręcznego wpisu czasu przechowują krótkotrwały stan
  UI w prywatnych `ValueNotifier`ach.
- Widoki formularzy obserwują stan przez `ValueListenableBuilder` albo
  `AnimatedBuilder` z `Listenable.merge`; wartości kolekcji są zapisywane jako
  niemutowalne kopie, aby zmiana była jednoznaczna dla obserwatora.
- Wszystkie nowe notifiery mają jawne `dispose`. Operacje zapisu, pobierania i
  odświeżenia nadal delegują do istniejących, wyspecjalizowanych Cubitów lub
  repozytoriów istniejących przed tym pakietem; nie dodano API ani logiki
  biznesowej do widgetów.
- Lokalny stan drag-and-drop załączników również używa
  `ValueListenableBuilder`, więc zmiana obramowania nie przebudowuje sekcji
  przez `setState`.
- Plik zależności po dodaniu obsługi notifierów przekroczył limit 400 linii.
  Wydzielono współdzielony widget pól harmonogramu do
  `task_details_dependency_fields.dart`; żaden plik Dart w katalogu detail nie
  przekracza teraz 400 linii.

## Walidacja

Wykonano w katalogu `Front`:

```bash
dart format lib/workspaces/presentation/tasks/detail
rg -n 'setState' lib/workspaces/presentation/tasks/detail
find lib/workspaces/presentation/tasks/detail -name '*.dart' -exec wc -l {} + | awk '$1 > 400 { print }'
flutter analyze lib/workspaces/presentation/tasks/detail
flutter test test/workspaces/presentation/tasks/detail --reporter compact
git diff --check
```

Wyniki:

- brak wyników dla `setState` w objętym katalogu;
- brak plików Dart dłuższych niż 400 linii;
- scoped analyzer: `No issues found!`;
- suite szczegółów zadania: **24/24 PASS**;
- `git diff --check`: PASS.

## Następny krok

Pakiet nie buduje globalnego Chat ani Notifications i nie rozszerza routingu.
Kolejne zadania mogą refaktoryzować inne piony wyłącznie w osobnych pakietach,
z zachowaniem private local state, Cubitów dla operacji biznesowych oraz limitu
400 linii na plik/widget.
