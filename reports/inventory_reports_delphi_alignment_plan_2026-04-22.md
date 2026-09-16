# Plan Dopasowania Raportów I PDF Do Delphi

## Cel

Doprowadzić raporty inwentaryzacji w Flutterze do stanu możliwie bliskiego staremu programowi Delphi po stronie:

- listy raportów
- opisów biznesowych
- układu tabel
- wyglądu PDF

Jednocześnie zachować nowszą logikę backendu tam, gdzie system został świadomie rozszerzony, zwłaszcza:

- `Raport ogólny`
- `Znaleziono w innych firmach`
- statusy procesu typu `nowy`, `sprzedany_w_trakcie`, `zakupiony_w_trakcie`

## Stan Referencyjny

### Flutter

Aktualny feature raportów:

- [inventory_report_definition.dart](/Users/przemyslawnowak/Desktop/dev/Excellent/ready_next/lib/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_definition.dart)
- [inventory_reports_flow.dart](/Users/przemyslawnowak/Desktop/dev/Excellent/ready_next/lib/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_reports_flow.dart)
- [inventory_report_result_sheet.dart](/Users/przemyslawnowak/Desktop/dev/Excellent/ready_next/lib/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_result_sheet.dart)
- [inventory_report_pdf_export.dart](/Users/przemyslawnowak/Desktop/dev/Excellent/ready_next/lib/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_pdf_export.dart)

### Delphi

Źródła starej logiki i wyglądu:

- [frmINWENTARYZACJAMDUnit.pas](/Users/przemyslawnowak/Desktop/inwetaryzaja%20delphi/inwentaryzacja/frmINWENTARYZACJAMDUnit.pas)
- [brakiNadwyzki.fr3](/Users/przemyslawnowak/Desktop/inwetaryzaja%20delphi/inwentaryzacja/brakiNadwyzki.fr3)
- [kompensaty.fr3](/Users/przemyslawnowak/Desktop/inwetaryzaja%20delphi/inwentaryzacja/kompensaty.fr3)

### Baza Delphi

Źródło brakującej logiki kompensat:

- [baza_inetaryzacja.sql](/Users/przemyslawnowak/Desktop/baza_inetaryzacja.sql)

Najważniejsza procedura:

- `P_LIST_KOMP2`

## Ustalenia Biznesowe

### Raporty, które miał Delphi

1. `Braki inwentaryzacyjne`
2. `Nadwyżki inwentaryzacyjne`
3. `Kompensaty`
4. `Kasacje`
5. `Braki inwentaryzacyjne nieskompensowane`
6. `Nadwyżki inwentaryzacyjne nieskompensowane`
7. `Protokół kasacji`

### Raporty nowe względem Delphi

1. `Raport ogólny`
2. `Znaleziono w innych firmach`

### Najważniejsze porównanie biznesowe

- `Braki` w Delphi: `STAN_INWENT=0`
- `Nadwyżki` w Delphi: `NADWYZKA=1`
- `Kasacje` w Delphi: `LIKWIDACJA=1`
- `Braki nieskompensowane` w Delphi: brak bez pary nadwyżki po `NREWID`
- `Nadwyżki nieskompensowane` w Delphi: nadwyżka bez pary braku po `NREWID`
- `Kompensaty` w Delphi: para `brak + nadwyżka` dla zwykłych przypadków, wyznaczana przez `P_LIST_KOMP2`

### Ważny wniosek

`Znaleziono w innych firmach` to nowa logika i nie należy tego wciskać do `Kompensat`.

## Backend

### Status

Backend od tego momentu jest `READ-ONLY`.

Nie planować już dalszych zmian backendowych w tym wątku, chyba że pojawi się nowy bug kontraktu.

### Odroczone TODO backendowe

Tego nie robimy dzisiaj. To jest świadomie odłożony temat pod pełne dopięcie raportu `Kompensaty` w stylu Delphi.

- [ ] rozszerzyć payload raportu `kompensaty`, żeby frontend dostał pełny obraz obu stron pary kompensacyjnej

Minimalny zakres danych potrzebnych do pełnego raportu Delphi:

1. `miejsce_brak`
2. `osoba_brak`
3. `miejsce_nadwyzka`
4. `osoba_nadwyzka`

Najlepiej zwrócić to w sekcji `compensation`, obok już istniejących pól:

- `pair_element_id`
- `pair_arkusz_id`
- `match_key`

Najczystszy docelowy kształt:

- `compensation.brak.miejsce`
- `compensation.brak.osoba`
- `compensation.nadwyzka.miejsce`
- `compensation.nadwyzka.osoba`

albo płasko, jeśli backend woli prostszy kontrakt:

- `compensation_missing_place`
- `compensation_missing_person`
- `compensation_surplus_place`
- `compensation_surplus_person`

Ważne:

- to wygląda na małą lub średnią zmianę kontraktu
- nie powinno wymagać migracji bazy
- chodzi o rozszerzenie response, nie o nowy model trwały w DB
- bez tych pól frontend nie odtworzy `kompensaty.fr3` 1:1

### Co już zostało domknięte na backendzie

- [x] `data_zakupu` zwracane w raportach
- [x] `data_zakupu` obsługiwane przez `PATCH elementu`
- [x] `data_zakupu` obsługiwane przy ręcznym tworzeniu elementu
- [x] skanowanie nowego placeholdera ustawia dzisiejszą `data_zakupu`
- [x] ręczne tworzenie elementu zostawia `data_zakupu = null`, jeśli pole nie jest podane
- [x] Swagger/OpenAPI poprawiony dla `data_zakupu`
- [x] Swagger raportów uzupełniony o `meta.totals`
- [x] testy backendowe przechodzą na dockerze

## Co Jest Już Zrobione W Flutterze

- [x] feature raportów jako osobny moduł
- [x] panel raportów w szczegółach inwentaryzacji
- [x] `Raport ogólny`
- [x] `Braki`
- [x] `Nadwyżki`
- [x] `Kompensaty`
- [x] `Braki nieskompensowane`
- [x] `Nadwyżki nieskompensowane`
- [x] `Znaleziono w innych firmach`
- [x] czerwony badge `Raport wewnętrzny` dla `Znaleziono w innych firmach`
- [x] PDF raportów istnieje

## Co Nadal Brakuje

### Raporty

- [ ] dodać `Kasacje` do listy raportów w UI
- [ ] zdecydować, czy `Protokół kasacji` będzie:
  - osobnym raportem w liście
  - czy osobną akcją dokumentową wewnątrz `Kasacje`

### Opisy biznesowe

- [ ] przejrzeć wszystkie opisy raportów pod kątem prostego, biznesowego języka
- [ ] upewnić się, że `Kompensaty` nie sugerują cross-company
- [ ] utrzymać `Znaleziono w innych firmach` jako osobny raport wewnętrzny

### Tabele ekranowe

- [ ] przebudować kolumny raportów na układ bliższy Delphi

Docelowy standardowy układ kolumn:

1. `Nr ewidencyjny`
2. `Nazwa`
3. `Miejsce`
4. `Osoba`
5. `Kod kreskowy`
6. `Wartość brutto`
7. `Wartość netto`
8. `Data zakupu`
9. `Uwagi` jako kolumna opcjonalna po przełączniku `Pokaż uwagi`

- [ ] dodać przełącznik `Pokaż uwagi`
- [ ] domyślnie nie pokazywać kolumny `Uwagi`

### PDF

- [ ] upodobnić PDF raportów do Delphi

Docelowe cechy PDF raportowych:

- poziome A4
- formalny nagłówek
- tytuł dokumentu na środku
- blok `Data od / Data do`
- blok firmy
- blok komisji
- duża sekcja z nazwą raportu
- tabela z cienkimi obramowaniami
- stopka `strona x / y`

- [ ] zrobić osobny layout PDF dla `Kompensat`

Kompensaty powinny mieć układ podobny do starego `kompensaty.fr3`:

- `Lp`
- `Nr ewidencyjny`
- `Nazwa`
- `Kod kreskowy`
- sekcja `Braki`: `Miejsce`, `Osoba`
- sekcja `Nadwyżki`: `Miejsce`, `Osoba`

- [ ] dopracować layout PDF standardowych raportów na wzór `brakiNadwyzki.fr3`
- [ ] dodać `Kasacje` do PDF
- [ ] dopiero potem zrobić osobny builder dla `Protokół kasacji`

## Rekomendowana Kolejność Dalszych Prac

1. dodać `Kasacje` do listy raportów
2. zmienić kolumny tabel ekranowych na układ delphi-like
3. dodać przełącznik `Pokaż uwagi`
4. przebudować standardowy PDF raportów pod styl Delphi
5. zrobić osobny PDF `Kompensaty`
6. na końcu dodać `Protokół kasacji`

## Zasady Dla Kolejnego AI / Następnej Sesji

1. Nie ruszać backendu, chyba że wyjdzie nowy realny bug kontraktu.
2. Traktować stare Delphi jako wzór layoutu i nazewnictwa, nie jako absolutne źródło nowej logiki biznesowej.
3. Nie mieszać `Znaleziono w innych firmach` z `Kompensatami`.
4. Utrzymać nowy backend jako source of truth dla doboru rekordów.
5. Po stronie UI/PDF dążyć do rozpoznawalności dla użytkownika znającego Delphi.

## Krótkie Podsumowanie Decyzji

- backend jest gotowy
- logika raportów nowego systemu zostaje
- frontend i PDF mają zostać dopracowane wizualnie i użytkowo pod styl Delphi
- brakujące legacy coverage to głównie `Kasacje` i później `Protokół kasacji`
- jedyne świadomie odłożone TODO backendowe dotyczy wzbogacenia payloadu `Kompensaty` o pełne dane obu stron pary

## Skrót Na Desktopie

1. Otwórz szczegóły inwentaryzacji.
2. Kliknij `Raporty`.
3. Wybierz raport z listy po lewej.
4. Użyj `Pobierz PDF` albo `Drukuj PDF`.
5. Na macOS druk zwykle otwiera podgląd PDF zamiast bezpośredniego okna drukowania.

### Szybkie komendy w UI

- `Raporty` - otwiera panel raportów.
- `Pobierz PDF` - zapisuje plik lokalnie.
- `Drukuj PDF` - otwiera drukowanie albo podgląd.
- `Pobierz protokół` - generuje protokół kasacji dla `Kasacje`.
