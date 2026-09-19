# R00 — zabezpieczenie stanu obu repozytoriów

Data wykonania: 2026-09-17.
Status tego zakresu: **PASS — kopia lokalna została utworzona i zweryfikowana**.

Ten raport dotyczy wyłącznie zabezpieczenia bieżących plików Front i Backend.
Nie jest potwierdzeniem ukończenia całego pakietu R0 z planu odzyskiwania:
baseline analyzera, macierz równoważności oraz manifest odzyskiwania funkcji są
odrębnymi pracami. W ramach tego zakresu nie zmieniano kodu aplikacji, nie
wykonywano restore/clean/reset, nie tworzono commita i nie wykonywano push.

## 1. Źródła i stan wejściowy

| Repozytorium | Branch | Commit HEAD | Stan katalogu roboczego przy inwentaryzacji |
|---|---|---|---|
| Front | `main` | `d1cc273401fd6db253ca18e54124ad767d4b2622` | 105 zmodyfikowanych, 593 usunięte tracked, 167 untracked |
| Backend | `main` | `2edcee7aa03e4619909ca93ef0cc2b52678295e0` | czysty |

Liczba 593 opisuje pliki tracked, których nie było w bieżącym worktree Front w
momencie inwentaryzacji. Kopia nie rekonstruuje tych plików z Git — zabezpiecza
rzeczywisty, obecny stan katalogu roboczego. Commit i stan zapisano po to, aby
kolejne etapy mogły odróżnić pliki obecne, usunięte i nieśledzone.

## 2. Lokalizacja i zakres kopii

Pełna ścieżka kopii:

```text
/Users/przemyslawnowak/Desktop/dev/DevNote-recovery-backups/devplanner-r0-20260917T154500+0200
```

Katalog kopii znajduje się poza repozytoriami `Front` i `Backend`. Uprawnienia
całego drzewa zostały ograniczone do właściciela (`go-rwx`), również dla
prywatnego obrazu referencyjnego Gmaila.

Skopiowano aktualne pliki obu worktree, w tym obecne źródła, dokumentację,
testy, pliki tracked i nieśledzone. Kopia zawiera także lokalną referencję:

```text
Front/docs/design/reference-local/gmail-layout-reference.png
```

Świadomie pominięto:

- `.git`, `.dart_tool`, `build`, `bin`, `obj`;
- `node_modules`, `Pods`, katalogi `ephemeral`, cache narzędzi i IDE;
- `coverage`, `TestResults` i wygenerowane obrazy z katalogów `failures`;
- `.env`, `.env.*`, w tym przykładowe pliki środowiskowe zgodnie z wytyczną;
- lokalne pliki sekretów, prywatne certyfikaty/klucze oraz lokalne bazy;
- logi i pliki tymczasowe.

Spośród tracked pominięte zostały dokładnie:

- Front: `.env.example`, `.env.production.example` i 4 wygenerowane obrazy
  różnic testów golden w `test/workspaces/presentation/tasks/board/failures/`;
- Backend: `.env.example`.

Żaden obecny tracked lub untracked plik spoza powyższego filtra nie zniknął z
kopii. Dwa małe pliki sentinel narzędzia .NET zostały zachowane; nie zawierają
konfiguracji NuGet ani danych uwierzytelniających i nie stanowią dużego cache.

## 3. Manifest i liczby plików

W katalogu głównym kopii znajdują się:

- `SHA256SUMS.txt` — SHA-256 każdego pliku danych w `Front/` i `Backend/`;
- `SHA256SUMS.txt.sha256` — suma kontrolna samego manifestu.

Wyniki:

| Zakres | Liczba plików |
|---|---:|
| Front | 1415 |
| Backend | 1503 |
| Łącznie w manifeście | 2918 |

Rozmiar całej kopii: około 56 MB.

SHA-256 manifestu:

```text
9dc0c3b171b7c1cc77e0b7d2c4c7406a798bff3da576de938821fe73968609a9
```

Polecenie `shasum -a 256 -c SHA256SUMS.txt` zakończyło się kodem 0 po utworzeniu
kopii oraz ponownie po ograniczeniu uprawnień. Oznacza to zgodność wszystkich
2918 pozycji z manifestem.

## 4. Kontrola kompletności tracked i untracked

Porównanie list Git z zawartością snapshotu dało następujące wyniki:

| Kontrola | Wynik |
|---|---:|
| Front — obecne tracked zweryfikowane w kopii | 1242 |
| Front — tracked nieobecne w worktree (status `D`) | 593 |
| Front — świadomie wykluczone tracked | 6 |
| Front — nieoczekiwanie brakujące tracked | 0 |
| Front — untracked zweryfikowane w kopii | 167 |
| Front — nieoczekiwanie brakujące untracked | 0 |
| Backend — obecne tracked zweryfikowane w kopii | 1503 |
| Backend — świadomie wykluczone tracked | 1 |
| Backend — nieoczekiwanie brakujące tracked/untracked | 0 |

## 5. Próby odczytu wymaganych plików

Każdy plik był czytelny z kopii, a `cmp` ze źródłem zakończył się kodem 0.

| Rodzaj próby | Plik | SHA-256 |
|---|---|---|
| tracked, aktualnie zmodyfikowany | `Front/pubspec.yaml` | `4e93181afe9a53286592566150e1e0907efa2725eb01454e2bf349ebda37c769` |
| untracked, standalone runtime | `Front/lib/workspaces/data/standalone/devplanner_standalone_runtime.dart` | `d05b70ba035d86783cfde5b3af149f065376cee64272af60ddc6ca77d356414c` |
| przywrócony Kanban/board | `Front/lib/workspaces/presentation/tasks/board/tasks_board_page.dart` | `27e57d9a47ece7a8c66421b954000c8d066787845275b6c6c68dc9bf095df0f4` |

Dodatkowo potwierdzono odczyt lokalnego screenshotu referencyjnego. Jego sumy
nie powielono w raporcie, aby ograniczyć rozpowszechnianie metadanych prywatnego
materiału; znajduje się w lokalnym manifeście kopii.

## 6. Komendy kontrolne i wynik

| Kontrola | Wynik |
|---|---|
| `git status --porcelain=v1 --untracked-files=all` w obu repo | PASS, stan opisany w sekcji 1 |
| kopia `rsync -a` z filtrami bezpieczeństwa | PASS |
| obecne tracked poza filtrami vs snapshot | PASS, brak nieoczekiwanych braków |
| untracked poza filtrami vs snapshot | PASS, brak nieoczekiwanych braków |
| odczyt + `cmp` trzech plików kontrolnych | PASS |
| odczyt prywatnej referencji Gmaila | PASS |
| pełne `shasum -a 256 -c SHA256SUMS.txt` | PASS |

## 7. Następny bezpieczny krok

Kolejne zadania mogą pracować na istniejącym worktree bez wykonywania
masowego restore lub clean. Jeżeli trzeba odzyskiwać pliki, należy porównywać
konkretne ścieżki z tym snapshotem i historycznymi źródłami, a każdą integrację
opisywać w manifeście odzyskiwania. Ten raport nie upoważnia do usuwania
aktualnych untracked ani do zastępowania ich wersją z Git.
