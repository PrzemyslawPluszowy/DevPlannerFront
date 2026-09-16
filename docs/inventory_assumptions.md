# Ustalenia robocze - inwentaryzacja

## 1. Założenia ogólne

- Chcemy zbliżać wynik biznesowy do Delphi tam, gdzie to ma znaczenie dla użytkownika.
- Nie cofamy na siłę obecnych ulepszeń backendu i aplikacji.
- Ustalenia zapisujemy krok po kroku, bez projektowania całego rozwiązania na przód.

## 2. Co zostawiamy

- Zostawiamy `subtree`.
- Nie mieszamy `status_spisu` z dawnym statusem ST.
- Obecną logikę skanowania traktujemy jako ulepszenie, które można doprecyzować, ale nie chcemy go cofać do 1:1 Delphi bez powodu.

## 3. PDF / raporty

- PDF został zbliżony do Delphi w nazwach i adnotacjach.
- Raport zbiorczy ma formalne nazwy sekcji, numerację 1-6 i bardziej dokumentowy styl.

## 4. Tworzenie arkusza

- `subtree` zostaje.
- Użytkownicy i tak zazwyczaj wybierają konkretne punkty.
- Startowy wynik biznesowy dla załadowanych elementów jest zbliżony do Delphi: na początku działają jak pozycje niepotwierdzone / braki.
- Przy tworzeniu arkusza filtrujemy `stan_st` bardziej delphi-like, tj. zgodnie z dawnym `STAN=1`.

## 5. Statusy

- `status_spisu` zostaje bez zmian.
- Dodajemy osobne pole `aktualny_stan`.
- `aktualny_stan` opisuje dawny `STAN` ze `stan_st`.
- `aktualny_stan` nie może być mieszany z `status_spisu`.

## 6. Gdzie ma być `aktualny_stan`

- Dodajemy go do pełnych response elementu.
- Nie dodajemy go do małych odpowiedzi technicznych typu tylko `success/id`.
- W tabeli arkusza wyświetlamy `aktualny_stan`.
- Do rozważenia w UI: jeśli `aktualny_stan != w_uzytkowaniu`, pokazujemy nazwę stanu wyraźniej.

## 7. Skanowanie w Delphi - wynik biznesowy

### 7.1. Jeśli element był już w aktywnym arkuszu

- Delphi tylko go potwierdzało.
- Ustawiało `STAN_INWENT=1` i `KK_WCZYTANY=1`.

Źródło:
- `baza_inetaryzacja.sql`, `P_READ_KK`, linie ok. 923-925
- `baza_inetaryzacja.sql`, `P_READ_NREWID`, linie ok. 1001-1003

### 7.2. Jeśli element został znaleziony "w scope"

- W Delphi "w scope" oznaczało: znaleziony w bieżącej gałęzi miejsca (`LVL like '%' || :LVL`).
- Taki element był dopisywany do arkusza jako zwykły znaleziony element, nie jako nadwyżka.
- W tej ścieżce Delphi nie filtrowało po `STAN=1`, więc taki wynik mógł zajść także dla elementu o innym `STAN` źródłowym.
- Ustawienia były następujące:
  - `STAN_INWENT=1`
  - `NADWYZKA=0`
  - `LIKWIDACJA=0`
  - `KK_WCZYTANY=1`

Źródło:
- `baza_inetaryzacja.sql`, `P_READ_KK`, linie ok. 938-945
- `baza_inetaryzacja.sql`, `P_READ_NREWID`, linie ok. 1013-1020

### 7.3. Jeśli element został znaleziony poza bieżącą gałęzią

- Delphi dopisywało go jako nadwyżkę.
- Ustawienia były następujące:
  - `STAN_INWENT=1`
  - `NADWYZKA=1`
  - `LIKWIDACJA=0`
  - ustawiane było miejsce znalezienia (`NADW_*`)

Źródło:
- `baza_inetaryzacja.sql`, `P_READ_KK`, linie ok. 952-960
- `baza_inetaryzacja.sql`, `P_READ_NREWID`, linie ok. 1024-1035

### 7.4. Jeśli elementu nie było w `STAN_ST`

- Delphi tworzyło sztuczny wpis typu "znaleziony tylko kod kreskowy".

Źródło:
- `baza_inetaryzacja.sql`, `P_READ_KK`, linie ok. 965-979

## 8. Edycja po skanie w Delphi

- Użytkownik mógł ręcznie zmienić klasyfikację elementu po skanie.
- Mógł ustawić:
  - `Stan inwentaryzacji`: `Brak` / `Jest`
  - `Nadwyżka`
  - `przeznaczony do likwidacji`
  - rodzaj: `Brak lub nadwyżka`, `Sprzedany w trakcie inwentaryzacji`, `Skasowany w trakcie inwentaryzacji`, `Zakupiony w trakcie inwentaryzacji`, `Składnik środka trwałego`

Źródło:
- `frmARKUSZ_SPISU_E_EDITUnit.dfm`, sekcje `edSTAN_INWENT`, `edNADWYZKA`, `edLIKWIDACJA`, `rdRODZAJBRAKNADW`
- `frmARKUSZ_SPISU_E_EDITUnit.pas`, zapis pól w `SaveData`

## 9. Aktualne pytania otwarte

- Jak dokładnie mapować wartości `aktualny_stan`.
- Gdzie poza tabelą arkusza chcemy pokazywać `aktualny_stan`.
