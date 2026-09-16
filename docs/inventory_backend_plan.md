# Plan backend - arkusze, statusy, skanowanie

## Cel

Zbliżyć wynik biznesowy do Delphi tam, gdzie wpływa to na wynik pracy użytkownika i raporty, ale bez cofania obecnych ulepszeń backendu.

## Kontekst z rozmowy

Ten plan zbiera ustalenia z rozmowy o:

- parity wyniku biznesowego względem Delphi,
- tworzeniu arkuszy i elementów,
- skanowaniu i ręcznej korekcie po skanie,
- rozdzieleniu statusów backendowych,
- `aktualny_stan`,
- potrzebie poprawy Swagger/OpenAPI,
- potrzebie bardzo dobrych testów dla przypadków granicznych.

## Założenia już ustalone

- Zostawiamy `subtree`.
- Użytkownicy i tak zazwyczaj wybierają konkretne punkty, więc `subtree` nie cofamy.
- Nie mieszamy `status_spisu` z dawnym statusem ST.
- Dodajemy osobne pole `aktualny_stan`.
- `aktualny_stan` opisuje dawny `STAN` ze `stan_st`.
- `aktualny_stan` ma być zwracany dla pełnych payloadów elementu.
- W tabeli arkusza chcemy pokazywać `aktualny_stan`.
- Jeśli `aktualny_stan != w_uzytkowaniu`, chcemy to lepiej eksponować w UI.
- Obecnej logiki skanowania nie cofamy w ciemno do Delphi.
- Chcemy zachować nasze ulepszenia procesu, ale wynik biznesowy ma być podobny do Delphi tam, gdzie to ważne dla użytkownika.
- Użytkownik po skanie ma dalej móc ręcznie doprecyzować klasyfikację elementu.
- Automatyczne komunikaty systemowe o nietypowym stanie mają trafiać do `uwagi_loc`, bo użytkownik ma móc je potem normalnie edytować.
- Przy tworzeniu arkusza filtr po dawnym `STAN=1` jest obowiązkowy.

## Główny kierunek

Nie robimy parity 1:1 całego procesu Delphi.
Robimy porządek w modelu backendowym i tam, gdzie trzeba, zbliżamy wynik biznesowy.

## Co już wiadomo z analizy Delphi

### A. Tworzenie arkusza

- Delphi miało osobny moment tworzenia arkusza i osobny moment ładowania elementów.
- Przy startowym ładowaniu arkusza stare `CREATE_ARS` brało tylko rekordy z `STAN=1`.
- To dotyczyło wsadu startowego, nie całego późniejszego życia elementu.

### B. Wynik biznesowy elementów po załadowaniu

- Biznesowo startowo elementy działały jak pozycje niepotwierdzone / braki.
- Różnica między Delphi a nowym backendem nie leży głównie w tym, czy startowo to jest "brak", tylko w tym, jakie rekordy w ogóle trafiają do arkusza.

### C. Skanowanie w Delphi

- Jeśli element był już w aktywnym arkuszu, Delphi tylko go potwierdzało.
- Jeśli był znaleziony "w scope", dopisywało go jako zwykły znaleziony element, nie jako nadwyżkę.
- Jeśli był znaleziony poza bieżącą gałęzią, Delphi dopisywało go jako nadwyżkę.
- Jeśli nie było go w `STAN_ST`, Delphi tworzyło sztuczny wpis.
- Przy skanowaniu "w scope" Delphi nie filtrowało tego po `STAN=1`.

### D. Ręczna korekta po skanie w Delphi

- Użytkownik mógł ręcznie zmieniać klasyfikację elementu po skanie.
- To oznacza, że wynik skanu w Delphi też nie był zawsze stanem ostatecznym.

## Najważniejsze ryzyka rozjazdu z Delphi

1. Startowy wsad arkusza:
   - czy bierzemy tylko dawny odpowiednik `STAN=1`,
   - czy zostawiamy dzisiejszy szerszy wsad.

2. Nie sam zapis pól, tylko wynik biznesowy:
   - jakie rekordy trafiają do arkusza,
   - kiedy trafiają,
   - z jaką klasyfikacją wchodzą do dalszych raportów.

3. Skanowanie elementów o nietypowym stanie źródłowym:
   - nie chcemy zniszczyć obecnych ulepszeń,
   - ale chcemy użytkownikowi wyraźnie pokazać kontekst źródłowego stanu.

## Etap 1. Uporządkowanie statusów backendowych

### 1.1. Wprowadzić `aktualny_stan`

Backend ma zwracać dla pełnego elementu dwa różne byty:

- `aktualny_stan` - źródłowy status ST z `stan_st`
- `status_spisu` - klasyfikacja biznesowa inwentaryzacji

### 1.2. Nie ruszać `status_spisu`

`status_spisu` zostaje bez zmian i dalej opisuje m.in.:

- `nadwyzka`
- `nowy`
- `znaleziony_w_innej_firmie`
- `niejednoznaczny_kod`
- `sprzedany_w_trakcie`
- `zakupiony_w_trakcie`

### 1.3. Proponowane wartości `aktualny_stan`

Mapowanie z dawnego `STAN`:

- `0` -> `niezatwierdzony`
- `1` -> `w_uzytkowaniu`
- `2` -> `zlikwidowany`
- `4` -> `sprzedany`
- `5` -> `przeniesiony`
- `99` -> `poza_ewidencja`

## Etap 2. Zakres odpowiedzi backendowych

`aktualny_stan` dodajemy do pełnych payloadów elementu:

- szczegóły arkusza
- odpowiedź skanowania
- odpowiedź dodania po `nrewid`
- odpowiedź ręcznego dodania nadwyżki
- inne odpowiedzi, które zwracają pełny obiekt elementu

Jeśli jakiś endpoint dziś zwraca tylko techniczne `success/id`, to trzeba jawnie zdecydować:

- czy zostaje odpowiedzią techniczną,
- czy podnosimy go do pełnego payloadu elementu.

Nie dodajemy go do małych odpowiedzi technicznych typu:

- `success`
- `id`
- `element_id`

## Etap 3. Tworzenie arkusza

### 3.1. `subtree` zostaje

Nie cofamy tej funkcji.

### 3.2. Filtr wsadu startowego

Delphi przy `CREATE_ARS` ładowało startowo tylko rekordy z `STAN=1`.

To jest obowiązkowe założenie do wdrożenia po stronie backendu.

Zakładamy, że backend przy tworzeniu arkusza ma zawęzić wsad startowy do bardziej delphi-like `STAN=1`.

To jest jedyny punkt, który może realnie mocno zmienić wynik biznesowy tworzenia arkusza.

### 3.3. Na teraz

Zmiana jest uzgodniona jako obowiązkowa, ale implementacja ma być wykonana dopiero po domknięciu pełnych ustaleń kontraktowych i Swaggera.

## Etap 4. Skanowanie

### 4.1. Zasada ogólna

Nie mapujemy `aktualny_stan` na `status_spisu`.

### 4.2. Zachowujemy obecną logikę eventów skanowania

Obecne wyniki skanu pozostają:

- `zgodny`
- `brak_arkusza`
- `przeniesiony`
- `inna_firma`
- `nowy`
- `niejednoznaczny_kod`

Do tego nie dokładamy osobnego agresywnego automatyzmu opartego o `aktualny_stan`.

### 4.3. Zasada z Delphi, którą warto zachować koncepcyjnie

Skan ustawia stan początkowy elementu, ale użytkownik może potem ręcznie doprecyzować klasyfikację.

### 4.4. Logika "w scope"

Z analizy Delphi wynika:

- jeśli skan znajdował element w bieżącej gałęzi miejsca,
- to dopisywał go jako zwykły znaleziony element,
- nie jako nadwyżkę,
- i nie filtrował tego po `STAN=1`.

To jest ważna referencja do porównań, ale nie zmieniamy jeszcze backendu tylko na tej podstawie.

### 4.5. Jeśli skan znajdzie element z nietypowym źródłowym stanem

Przez "niepasujący" rozumiemy przypadki typu:

- `sprzedany`
- `zlikwidowany`
- `przeniesiony`
- inne stany źródłowe różne od standardowego `w_uzytkowaniu`

Założenie na teraz:

- nie blokujemy automatycznie skanu,
- nie mapujemy automatycznie `aktualny_stan` na `status_spisu`,
- skan dalej działa według obecnych reguł,
- `status_spisu` dalej wynika z obecnej logiki backendu,
- jeśli element ma być oznaczony jako `znaleziony_w_innej_firmie`, `nadwyzka`, `nowy` itd., to ta logika zostaje bez zmian,
- pełny payload elementu zwraca `aktualny_stan`,
- system ma dopisać automatyczną adnotację do `uwagi_loc`,
- użytkownik ma móc tę adnotację później ręcznie edytować albo usunąć,
- UI ma dodatkowo dostać możliwość wyraźnego ostrzeżenia użytkownika o rozjeździe między stanem źródłowym a wynikiem inwentaryzacji.

To pozwala zachować obecne ulepszenia procesu, a jednocześnie daje użytkownikowi pełniejszy kontekst decyzji.

Robocza forma komunikatu systemowego:

- `Uwaga: źródłowy aktualny stan środka trwałego to: <aktualny_stan>.`

Zasada:

- komunikat ma być dopisywany tylko wtedy, gdy `aktualny_stan != w_uzytkowaniu`,
- przy tworzeniu arkusza nie dopisujemy go, bo wsad startowy jest filtrowany do dawnego `STAN=1`,
- komunikat ma być traktowany jako startowa podpowiedź systemu,
- po zapisaniu użytkownik może go dowolnie zmienić w `uwagi_loc`.

### 4.6. Czego nie robimy przy skanowaniu

- nie nadpisujemy automatycznie `status_spisu` tylko dlatego, że `aktualny_stan` jest nietypowy,
- nie blokujemy automatycznie potwierdzenia elementu tylko przez źródłowy stan,
- nie cofamy obecnych eventów skanowania do starego, mniej jawnego modelu Delphi.

## Etap 5. UI wspierane przez backend

Backend ma dostarczyć dane tak, żeby UI mogło:

- pokazać `aktualny_stan` jako osobną kolumnę,
- wyróżnić przypadki, gdy `aktualny_stan != w_uzytkowaniu`,
- pokazać użytkownikowi, że element pochodzi z innego źródłowego stanu niż standardowy,
- bez mieszania tego z klasyfikacją inwentaryzacyjną.

Dodatkowo:

- jeśli `aktualny_stan != w_uzytkowaniu`, UI powinno to widocznie oznaczyć,
- użytkownik powinien widzieć systemową adnotację w `uwagi_loc`,
- użytkownik nadal ma mieć możliwość ręcznej korekty klasyfikacji.

## Etap 6. Kolejność wdrożenia

1. Dodać `aktualny_stan` do backendowych pełnych payloadów elementu.
2. Dodać mapowanie enum wartości `aktualny_stan`.
3. Zaktualizować schematy / kontrakty proxy.
4. Dopiero potem podpiąć to w UI tabeli arkusza.
5. Wdrożyć obowiązkowy filtr startowego wsadu arkusza do dawnego `STAN=1`.
6. Potem poprawić raporty / eksporty tylko tam, gdzie nowy model backendowy wpływa na wynik końcowy.

## Etap 7. Rzeczy, których teraz nie robimy

- Nie cofamy `subtree`.
- Nie przerabiamy całej logiki skanowania na Delphi.
- Nie mieszamy `aktualny_stan` z `status_spisu`.
- Nie zmieniamy jeszcze raportów backendowych pod nowy status.
- Nie podejmujemy jeszcze decyzji o pełnej parity 1:1 tworzenia arkusza z Delphi.

## Etap 8. Co jeszcze pasuje do przebudowy backendu

### 8.1. Jeden centralny mapper statusów ST

Warto mieć jedno miejsce w backendzie, które mapuje dawny `stan` liczbowy na:

- surowy kod liczbowy,
- `aktualny_stan` jako enum/string,
- etykietę czytelną dla UI lub logów.

Cel:

- uniknąć duplikacji mapowania,
- nie rozrzucać tej logiki po resource, service i proxy.

### 8.2. Rozdzielenie warstw znaczeniowych w odpowiedziach

W pełnym payloadzie elementu docelowo dobrze jest utrzymać wyraźny podział:

- `stan` - historyczny kod źródłowy,
- `aktualny_stan` - opisowy status źródłowy,
- `stan_inwent` - wynik potwierdzenia komisji,
- `status_spisu` - klasyfikacja biznesowa.

Cel:

- łatwiejsza interpretacja w UI,
- mniejsze ryzyko błędnych skrótów po stronie frontendu.

### 8.3. Testy kontraktowe dla pełnego elementu

Po dodaniu `aktualny_stan` warto dodać testy sprawdzające, że pełne payloady elementu zwracają spójnie:

- `stan`,
- `aktualny_stan`,
- `stan_inwent`,
- `status_spisu`.

Minimalnie dla:

- szczegółów arkusza,
- skanowania,
- dodania po `nrewid`,
- ręcznego dodania nadwyżki.

I dodatkowo trzeba zweryfikować, że Swagger / OpenAPI pokazuje dokładnie te pola, które realnie wychodzą z backendu.

### 8.4. Testy parity dla skanowania

Warto dopisać testy scenariuszy, które historycznie były ważne w Delphi:

- znaleziony w bieżącej gałęzi,
- znaleziony poza bieżącą gałęzią,
- znaleziony w innej firmie w scope,
- znaleziony poza zakresem firm,
- niejednoznaczny kod,
- ręczna zmiana klasyfikacji po skanie.

Cel:

- utrzymać nasze ulepszenia,
- ale pilnować podobnego wyniku biznesowego.

### 8.5. Testy dla "niepasującego" `aktualny_stan`

Ten obszar trzeba przetestować bardzo dobrze, bo łatwo tu o regresję lub zbyt agresywną automatyzację.

Minimalny zestaw testów:

- skan elementu z `aktualny_stan=w_uzytkowaniu`,
- skan elementu z `aktualny_stan=sprzedany`,
- skan elementu z `aktualny_stan=zlikwidowany`,
- skan elementu z `aktualny_stan=przeniesiony`,
- sprawdzenie, że backend nie nadpisuje automatycznie `status_spisu` tylko dlatego, że `aktualny_stan` jest nietypowy,
- sprawdzenie, że pełny payload elementu zwraca `aktualny_stan`,
- sprawdzenie, że dla nietypowego `aktualny_stan` backend dopisuje odpowiednią adnotację do `uwagi_loc`,
- sprawdzenie, że istniejące ręczne uwagi nie są niszczone w niekontrolowany sposób,
- sprawdzenie, że wynik skanu pozostaje zgodny z obecną logiką biznesową.

### 8.6. Swagger / OpenAPI

To jest osobny, ważny temat przebudowy backendu.

Musimy:

- poprawić Swagger tak, żeby był aktualny,
- uzupełnić poprawne success response payload,
- uzupełnić wszystkie ważne bad response,
- zweryfikować miejsca, gdzie dokumentacja response jest dziś uproszczona albo niespójna,
- zgrać Laravel resource, OpenAPI i schematy proxy `databus`.

#### 8.6.1. Zakres obowiązkowej weryfikacji Swaggera

Do sprawdzenia i poprawy są co najmniej:

- success response dla `GET /inwentaryzacja/arkusze/{arkuszId}`,
- success response dla `POST /inwentaryzacja/{id}/skanuj`,
- success response dla `POST /inwentaryzacja/arkusze/{arkuszId}/elementy`,
- success response dla `POST /inwentaryzacja/arkusze/{arkuszId}/elementy/nrewid`,
- success response dla `PATCH /inwentaryzacja/arkusze/{arkuszId}/elementy/{elementId}`,
- success response dla raportów, jeśli później zdecydujemy się wystawiać tam `aktualny_stan`,
- wszystkie bad response dla powyższych endpointów (`400`, `404`, `422` tam gdzie występuje).

#### 8.6.2. Zasada spójności kontraktu

Każdy endpoint ma być zweryfikowany w trzech miejscach jednocześnie:

- realny payload z Laravel resource / controller,
- deklaracja OpenAPI w Laravelu,
- schemat proxy `databus`.

Nie uznajemy Swaggera za poprawiony, jeśli tylko jedno z tych miejsc jest aktualne.

#### 8.6.3. Pole `aktualny_stan` w Swaggerze

Po dodaniu `aktualny_stan` ma być jasno opisane:

- że jest to źródłowy status ST,
- że nie jest tym samym co `status_spisu`,
- że nie zastępuje `stan_inwent`,
- jakie ma dopuszczalne wartości enum.

#### 8.6.4. Bad response

W dokumentacji trzeba doprecyzować nie tylko kody, ale też strukturę błędu.

Minimalna zasada:

- jeśli endpoint zwraca `errors: [...]`, to Swagger ma to pokazać,
- jeśli rozróżniamy `400` i `404`, to opis ma odpowiadać realnym przypadkom biznesowym,
- tam gdzie walidacja może zwrócić `422`, Swagger też ma to jawnie zawierać.

#### 8.6.5. Stan prac przy Swaggerze

Na teraz:

- mamy ustalenie, że Swagger wymaga pełnego przeglądu,
- nie wdrażamy jeszcze zmian,
- najpierw dokumentujemy zakres i zasady, potem dopiero poprawiamy implementację i kontrakty.

Cel:

- nie psuć obecnego procesu skanowania,
- nie mieszać statusu źródłowego z klasyfikacją inwentaryzacyjną,
- dać UI pełny kontekst do ostrzeżenia użytkownika.

### 8.7. Filtr startowego wsadu arkusza

Ten punkt jest już uzgodniony:

- nie zostawiamy obecnego pełnego ładowania bez zmian,
- wdrażamy filtr podobny do dawnego `STAN=1` przy tworzeniu arkusza.

To jest najważniejsza uzgodniona zmiana wpływająca na wynik tworzenia arkusza.

### 8.8. Ewentualne wystawienie `aktualny_stan` w raportach

Na razie tego nie robimy, ale warto zostawić jako osobny temat do decyzji:

- czy `aktualny_stan` ma być tylko w widoku arkusza,
- czy również w raportach i eksporcie PDF.

### 8.9. Dokumentacja API i frontend contract note

Po wdrożeniu `aktualny_stan` trzeba zaktualizować:

- schematy OpenAPI / proxy,
- notatkę dla frontendu, jak interpretować `aktualny_stan`,
- krótką zasadę: `aktualny_stan` to źródło, `status_spisu` to decyzja inwentaryzacyjna.

## Otwarte decyzje

- Czy `aktualny_stan` ma być zwracany także w raportach.
- Czy osobno utrzymywać event skanu w kontrakcie, czy zostawić to jak dziś.
- Czy endpointy tworzenia elementu mają dalej zwracać tylko techniczne `success/id`, czy przechodzimy na pełny payload elementu.

## Sugerowane decyzje do zatwierdzenia

### D1. Pole `stan`

- Decyzja do podjęcia:
  - czy zostawiamy stare `stan` w kontrakcie,
  - czy usuwamy je od razu.
- Moja rekomendacja:
  - zostawić `stan` tymczasowo jako `deprecated`,
  - dodać obok `aktualny_stan` jako pole docelowe.

Status decyzji:

- ZATWIERDZONE: zostawiamy `stan` tymczasowo jako `deprecated`.

### D2. Enum `aktualny_stan`

- Decyzja do podjęcia:
  - jakie dokładnie wartości ma mieć `aktualny_stan`.
- Moja rekomendacja:
  - `niezatwierdzony`
  - `w_uzytkowaniu`
  - `zlikwidowany`
  - `sprzedany`
  - `przeniesiony`
  - `poza_ewidencja`

Status decyzji:

- ZATWIERDZONE: `aktualny_stan` ma być string enum po polsku biznesowo (`w_uzytkowaniu`, `sprzedany`, `zlikwidowany` itd.).

### D3. Zakres wystawienia `aktualny_stan`

- Decyzja do podjęcia:
  - czy `aktualny_stan` ma wejść tylko do arkusza i skanowania,
  - czy od razu też do raportów.
- Moja rekomendacja:
  - na start tylko:
    - szczegóły arkusza,
    - skanowanie,
    - pełne payloady elementu,
  - raporty dopiero później.

Status decyzji:

- ZATWIERDZONE: na start `aktualny_stan` wchodzi do pełnych payloadów elementu, a docelowo ma też wejść do raportów.

### D4. Odpowiedzi endpointów tworzących element

- Decyzja do podjęcia:
  - czy `addNadwyzka` i `createElementByNrewid` mają dalej zwracać tylko `success/id`,
  - czy mają zwracać pełny payload elementu.
- Moja rekomendacja:
  - przejść na pełny payload elementu.

Powód:

- prostszy kontrakt dla frontendu,
- spójność z `skanuj`,
- od razu dostępny `aktualny_stan` bez dodatkowego odświeżania.

Status decyzji:

- ZATWIERDZONE: `addNadwyzka` i `createElementByNrewid` mają przejść na pełny payload elementu.

### D5. Systemowa adnotacja w `uwagi_loc`

- Decyzja do podjęcia:
  - jak dokładnie dopisywać komunikat systemowy do `uwagi_loc`.
- Moja rekomendacja:
  - dopisywać tylko gdy `aktualny_stan != w_uzytkowaniu`,
  - nie dopisywać przy tworzeniu arkusza, bo po filtrze `STAN=1` nie powinno być tam takich elementów,
  - nie duplikować tego samego komunikatu wiele razy,
  - nie nadpisywać agresywnie ręcznych uwag użytkownika.

Proponowany szablon komunikatu:

- `Uwaga: wykryto inny stan niż w użytkowaniu. Aktualny stan to: <aktualny_stan>.`

Status decyzji:

- ZATWIERDZONE: komunikat nie jest dopisywany przy tworzeniu arkusza; dotyczy tylko dalszych przypadków z nietypowym stanem źródłowym.
- ZATWIERDZONE: treść komunikatu ma zależeć od typu `aktualny_stan` i używać szablonu `Uwaga: wykryto inny stan niż w użytkowaniu. Aktualny stan to: <aktualny_stan>.`.
- ZATWIERDZONE: nie dodajemy osobnego pola systemowego; końcowy tekst ma trafiać bezpośrednio do `uwagi_loc`.

### D6. Nietypowy `aktualny_stan` przy skanie

- Decyzja do podjęcia:
  - czy sam nietypowy `aktualny_stan` ma wpływać na wynik skanu,
  - czy tylko daje ostrzeżenie.
- Moja rekomendacja:
  - nie zmieniać automatycznie `status_spisu`,
  - nie blokować skanu,
  - tylko dodać kontekst przez `aktualny_stan` i adnotację w `uwagi_loc`.

Status decyzji:

- ZATWIERDZONE: nietypowy stan źródłowy przy skanie daje tylko ostrzeżenie; logika `status_spisu` zostaje bez zmian.

### D7. Zakres poprawy Swaggera

- Decyzja do podjęcia:
  - czy poprawiamy tylko endpointy arkuszy i skanowania,
  - czy cały moduł inwentaryzacji na raz.
- Moja rekomendacja:
  - najpierw:
    - arkusze,
    - elementy,
    - skanowanie,
  - potem reszta modułu.

Status decyzji:

- ZATWIERDZONE: poprawę Swaggera robimy etapami, najpierw dla arkuszy, elementów i skanowania.

### D8. Event skanu w kontrakcie

- Decyzja do podjęcia:
  - czy zostawiamy osobny `event` skanu w kontrakcie,
  - czy opieramy się tylko na `data.element`.
- Moja rekomendacja:
  - zostawić osobny `event` skanu.

Powód:

- to już istnieje jako sensowna warstwa interpretacji operacji,
- frontend może szybciej reagować na wynik skanu bez zgadywania tylko po polach elementu,
- nie koliduje to z lepszym, pełnym payloadem elementu,
- nie miesza `status_spisu` z wynikiem operacji skanowania.

Status decyzji:

- ZATWIERDZONE: zostawiamy osobny `event` skanu w kontrakcie.

### D9. Wspólny schemat błędów `errors: []`

- Decyzja do podjęcia:
  - czy formalizujemy jeden wspólny schemat błędu w Swaggerze.
- Moja rekomendacja:
  - tak, formalizować wspólny schemat `errors: []`.

Ocena zmiany:

- to jest mała do średniej zmiana kontraktowo,
- głównie porządkowa i dokumentacyjna,
- nie powinna rozwalić logiki backendu,
- da większą spójność między Laravel, Swagger i proxy `databus`.

Status decyzji:

- ZATWIERDZONE: formalizujemy wspólny schemat błędów `errors: []` w Swaggerze.

### D10. Sposób pokazywania `aktualny_stan` w UI

- Decyzja do podjęcia:
  - czy pokazywać `aktualny_stan` jako tekst, badge czy oba.
- Moja rekomendacja:
  - backend ma być gotowy na oba warianty,
  - UI może użyć tekstu i badge jednocześnie albo zdecydować po testach w praktyce.

Status decyzji:

- ZATWIERDZONE: zakładamy, że UI może pokazywać `aktualny_stan` i jako tekst, i jako badge; najważniejszy jest backend.

## Checklista przed implementacją

### A. Decyzje biznesowe

- [x] Potwierdzić, że przy tworzeniu arkusza filtr po dawnym `STAN=1` jest obowiązkowy.
- [x] Potwierdzić, że `subtree` zostaje bez zmian.
- [x] Potwierdzić, że nietypowy `aktualny_stan` nie blokuje skanu automatycznie.
- [x] Potwierdzić, że dla nietypowego `aktualny_stan` system dopisuje adnotację do `uwagi_loc`.
- [x] Potwierdzić, że użytkownik może tę adnotację edytować lub usunąć.

### B. Decyzje kontraktowe

- [x] Potwierdzić finalną nazwę pola: `aktualny_stan`.
- [x] Potwierdzić finalny enum wartości `aktualny_stan`.
- [x] Potwierdzić, czy stare `stan` zostaje w kontrakcie jako `deprecated`.
- [x] Potwierdzić, w których endpointach zwracamy `aktualny_stan`.
- [x] Potwierdzić, czy endpointy tworzące element (`addNadwyzka`, `createElementByNrewid`) przechodzą na pełny payload elementu.
- [x] Potwierdzić, czy `aktualny_stan` na razie nie wchodzi do raportów.

### C. Decyzje o skanowaniu

- [x] Potwierdzić, że `aktualny_stan` nie mapuje się automatycznie na `status_spisu`.
- [x] Potwierdzić, że obecne eventy skanowania zostają (`zgodny`, `brak_arkusza`, `przeniesiony`, `inna_firma`, `nowy`, `niejednoznaczny_kod`).
- [x] Potwierdzić format komunikatu dopisywanego do `uwagi_loc`.
- [x] Potwierdzić zasadę nieduplikowania komunikatu w `uwagi_loc`.

### D. Swagger / OpenAPI

- [x] Potwierdzić, że poprawiamy Swagger dla arkuszy, elementów i skanowania w pierwszym kroku.
- [x] Potwierdzić wspólną strukturę błędów `errors: []` w dokumentacji.
- [x] Potwierdzić, że każdy endpoint będzie weryfikowany w 3 miejscach: Laravel payload, OpenAPI, schemat proxy `databus`.

### E. Testy

- [x] Potwierdzić listę testów kontraktowych dla pełnego elementu.
- [x] Potwierdzić listę testów dla nietypowego `aktualny_stan`.
- [x] Potwierdzić listę testów parity dla skanowania.

### F. Kolejność prac

- [x] Najpierw zamknąć decyzje kontraktowe.
- [x] Potem wdrożyć backend.
- [x] Potem poprawić Swagger/OpenAPI.
- [ ] Na końcu podpiąć frontend.

## Stan wdrożenia

### Zrobione

- dodano `aktualny_stan` do pełnych payloadów elementu po stronie backendu,
- zachowano stare `stan` jako pole tymczasowe / deprecated,
- włączono obowiązkowy filtr `STAN=1` przy tworzeniu arkusza,
- zachowano obecną logikę `status_spisu` przy skanowaniu,
- dodano dopisywanie systemowej adnotacji do `uwagi_loc` dla nietypowego `aktualny_stan`,
- `addNadwyzka` i `createElementByNrewid` zwracają pełny payload elementu,
- `event` skanu pozostaje w kontrakcie,
- zaktualizowano Swagger / OpenAPI dla arkuszy, elementów i skanowania,
- ujednolicono dokumentację błędów `errors: []` w tym obszarze,
- testy backendowe dla `ArkuszTest` i `SkanujTest` przeszły po zmianach.

### Pending

- decyzja i ewentualne wdrożenie `aktualny_stan` w raportach,
- frontend dla tabeli arkusza i wizualizacji `aktualny_stan`,
- końcowy code review backendu po całym zamknięciu tematu,
- pełny przegląd kodu backendu po zakończeniu prac,
- dopięcie reszty modułu inwentaryzacji w Swaggerze poza obszarem arkuszy / elementów / skanowania.

## Etap końcowy po wdrożeniu

Na samym końcu pracy trzeba obowiązkowo:

- zrobić code review backendu,
- sprawdzić dokładnie wszystkie punkty z tego planu,
- odpalić testy backendowe,
- jeszcze raz przejrzeć kod backendu po zakończeniu prac,
- dopiero po tym uznać temat za domknięty.
