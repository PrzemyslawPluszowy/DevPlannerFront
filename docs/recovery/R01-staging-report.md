# R01 — read-only staging odzyskania

Data: 2026-09-17. Status: **PARTIAL — staging utworzony, bez przywrócenia do aplikacji.**

## Wynik

Utworzono 14-plikowy staging poza Frontem:

```text
/Users/przemyslawnowak/Desktop/dev/DevNote-recovery-staging/R01-20260917T182200+0200
```

Zawiera on trzy adaptery Web BFF/SignalR, runtime standalone, kompozycje
globalnego Chat i Notifications, wejście Workspaces oraz związane testy
standalone, katalogu, globalnego Chat i routera Notifications. Suma plików jest
w `SHA256SUMS.txt`; suma tego manifestu to
`8cfd8900f41ea3c3c1f30a313c8560c50d338d572667212062493d52c1e508e7`.

Nie włączono żadnego pliku ze stagingu do worktree. Aktualne `lib/` i `test/`
Frontu nie zostały nadpisane.

## Źródła i chronologia

1. 2026-09-16: Codex utworzył stronę Workspaces (16:29:49Z), dodał jej route
   placeholder (16:38:15Z), a następnie kompozycję globalnego Chat (17:41:59Z,
   update 17:43:47Z) i Notifications (18:00:05Z). Powstały również testy
   globalnego Chat i routera Notifications, później wielokrotnie aktualizowane.
2. 2026-09-17 05:38–11:56Z: Codex dodał runtime standalone i jego testy,
   testy kontraktów standalone/directory oraz trzy adaptery SignalR. W tym
   okresie wystąpiły późniejsze patche runtime, testów i adaptera webowego.
3. 2026-09-17 17:34:10Z: `git restore --source=HEAD --worktree --
   lib/workspaces test/workspaces` nadpisał zmodyfikowane tracked zmiany w tych
   katalogach. Wcześniejszy zapis potwierdza co najmniej sześć zmienionych
   tracked adapterów realtime wymienionych w manifeście.
4. 2026-09-17 17:34:19Z: `git clean -fd -- lib/workspaces test/workspaces`
   usunął nieśledzone pliki i katalogi; jego output jest bezpośrednim dowodem
   dla objętych stagingiem ścieżek.

Historia VS Code zawiera pojedynczą wersję routera, która importuje utracone
kompozycje i stronę Workspaces; nie zawiera ich treści. Wykorzystano ją wyłącznie
jako potwierdzenie relacji konsumentów.

## Klasyfikacja

Pełny status, źródło, timestamp, ostatni patch i hash każdego pliku znajdują
się w [file-recovery-manifest.md](file-recovery-manifest.md). Siedem plików
jest `exact` lub `reconstructed`; siedem jest `partial`, ponieważ wiadomo o
późniejszym patchu, lecz nie został on jeszcze bezpiecznie złożony. Nie ma
pozycji oznaczonych `missing` w ograniczonym, nazwanym zakresie, ale usunięte
rekurencyjnie katalogi mogą zawierać dodatkowe, nadal niezinwentaryzowane pliki.

## Kontrole

- R00 backup: wcześniej PASS, bez używania go do nadpisania Frontu.
- Walidacja ścieżek: PASS — wszystkie staged pliki leżą pod osobnym katalogiem
  staging, zachowując relatywne ścieżki Frontu.
- Skan sekretów staged `*.dart`: PASS — brak trafień zdefiniowanych wzorców.
- SHA-256 staged źródeł: PASS — 14 wpisów w `SHA256SUMS.txt`.
- Build/analyze/test: NOT RUN — staging nie jest zintegrowanym drzewem i część
  testów jest jawnie `partial`.

## Następny bezpieczny krok

Osobny właściciel R1 powinien najpierw odtworzyć tylko ostatnie patche pozycji
`partial` do kolejnego stagingu, porównać hash i diff z tym manifestem, a potem
zaproponować małe, jawne włączenie wybranych plików. Nie uruchamiać generatorów
równolegle i nie używać `restore`, `clean` ani `reset`.
