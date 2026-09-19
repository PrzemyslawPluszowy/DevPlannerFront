# R3a — regresja rdzenia Kanban

Data: 2026-09-18  
Status: **40/40 PASS w testach automatycznych; live desktop/staging nadal wymagany**

## Potwierdzony zakres

Testy `tasks_board_route_page_test.dart` oraz `tasks_board_cubit_test.dart`
potwierdzają, że Kanban nie jest atrapą:

- trasa projektu składa listę/board oraz granice loading, empty i forbidden;
- DnD wykonuje ruch optymistyczny, koryguje indeks w kolumnie i cofa wyłącznie
  właściwą kartę przy błędzie;
- workflow blokuje niedozwolone przejścia;
- quick create obsługuje status systemowy i własny, a także szablony;
- bulk selection/move/priority/due date używa aktualnych wersji;
- preferencje kolumn i filtry zachowują stan;
- realtime resync zachowuje rewizję oraz nie przywraca starych danych.

```text
flutter test tasks_board_route_page_test.dart tasks_board_cubit_test.dart
40/40 PASS
```

Auto-scroll i podzadania są osobnym następnym przebiegiem, aby wynik każdego
pliku pozostał jednoznaczny. Ten raport nie zastępuje testu desktopowego ze
stagingowym Backendem i SignalR.
