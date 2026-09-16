## Plan dostosowania mobile `excellent_inventaryzacja` do nowych kontraktow inwentaryzacji

### Cel

Dostosowac aplikacje mobilna `excellent_inventaryzacja` do aktualnego backendowego kontraktu inwentaryzacji po zmianach w `databus` i Laravelu, bez polegania na online Swaggerze jako source of truth.

### Zrodla prawdy na teraz

- backend Laravel / databus po ostatnim PR,
- frontend web `ready_next` jako aktualna implementacja referencyjna kontraktu,
- lokalne pliki OpenAPI w repo backendowym, a nie Swagger online.

### Najwazniejsze zmiany kontraktowe do uwzglednienia

1. `databus` jest read only i nie nalezy juz opierac decyzji implementacyjnych o online Swagger.
2. Pole `aktualny_stan` staje sie zrodlowym stanem ST elementu.
3. `stan_inwent` zostaje osobnym polem wyniku inwentaryzacji.
4. `status_spisu` zostaje osobna klasyfikacja biznesowa.
5. `uwagi_loc` moze zawierac systemowy dopisek ostrzegawczy dla nietypowego `aktualny_stan`.
6. Odpowiedzi skanowania i wybranych akcji na elemencie zwracaja pelny payload elementu.
7. Kontrakt skanowania zachowuje `event` i pelny `element`.

### Miejsca do zmiany w mobile

#### 1. DTO arkusza elementow

Plik:
- `excellent_inventaryzacja/lib/data_source/models/inventory/endpoints/get_arkusz_details_models.dart`

Zakres:
- zamienic mapowanie pola `stan` na `aktualny_stan`,
- nazwac pole modelu jednoznacznie, np. `aktualnyStan`,
- zostawic helper prezentacyjny typu `assetStatus`,
- nie mieszac `aktualny_stan` z `stan_inwent`.

Uwagi:
- obecnie mobile nadal czyta stare `stan`, podczas gdy `ready_next` jest juz przepiety na `aktualny_stan`.

#### 2. Wygenerowane pliki DTO

Pliki:
- `excellent_inventaryzacja/lib/data_source/models/inventory/endpoints/get_arkusz_details_models.g.dart`
- ewentualnie inne `.g.dart` zalezne od tego DTO

Zakres:
- przebudowac generatory po zmianie modelu,
- sprawdzic czy serializacja/deserializacja nadal zgadza sie z backendem.

#### 3. Odpowiedz skanowania

Plik:
- `excellent_inventaryzacja/lib/data_source/models/inventory/endpoints/post_skanuj_inwentaryzacja_models.dart`

Zakres:
- potwierdzic finalny shape odpowiedzi skanu (`event` + `element`),
- jesli mobile nie uzywa `event`, to co najmniej nie moze go gubic przy deserializacji, jezeli envelope tego wymaga,
- utrzymac logike oparta o pelny payload `element`.

Ryzyko:
- obecny helper `resolvedStatus` robi lokalna heurystyke na podstawie `statusSpisu`, `stanInwent` i `nadwyzka`; trzeba potwierdzic, czy dalej jest potrzebny, czy ma byc zastapiony bardziej jednoznacznym mapowaniem.

#### 4. Heurystyka `resolvedStatus` i historia synchronizacji

Pliki:
- `excellent_inventaryzacja/lib/data_source/models/inventory/endpoints/post_skanuj_inwentaryzacja_models.dart`
- `excellent_inventaryzacja/lib/feautures/home/cubit/inventory_scanner_cubit.dart`
- `excellent_inventaryzacja/lib/feautures/home/cubit/pending_sync_cubit.dart`

Zakres:
- przejrzec wszystkie miejsca, gdzie zapisywany jest `responseStatus`,
- upewnic sie, ze mobile nie redukuje odpowiedzi backendu do zbyt ubogiego stringa,
- rozdzielic przypadki:
  - `status_spisu` jako klasyfikacja biznesowa,
  - `stan_inwent` jako wynik skanu/inwentaryzacji,
  - `aktualny_stan` jako status zrodlowy ST,
- jesli `responseStatus` ma zostac w ObjectBox tylko do filtrowania historii, ustalic jeden kanoniczny sposob wyliczenia i opisac go testami.

#### 5. Preview arkusza na mobile

Plik:
- `excellent_inventaryzacja/lib/feautures/home/view/arkusz_preview/arkusz_preview_screen.dart`

Zakres:
- przepiac badge ST z `item.status` na nowe pole `item.aktualnyStan` / `item.assetStatus`,
- utrzymac osobne badge dla:
  - stanu ST,
  - `stan_inwent`,
  - opcjonalnie `status_spisu`, jesli jest potrzebny operatorowi,
- sprawdzic wyszukiwarke i ewentualnie dodac `uwagi_loc`, jesli ostrzezenia systemowe maja byc widoczne w preview.

#### 6. Snapshot offline w ObjectBox

Pliki:
- `excellent_inventaryzacja/lib/data_source/local/models/inventory_scan_local_models.dart`
- `excellent_inventaryzacja/lib/data_source/local/inventory_scan_local_data_source.dart`

Zakres:
- rozszerzyc snapshot elementu o dane potrzebne po nowym kontrakcie, co najmniej:
  - `aktualny_stan`,
  - opcjonalnie `status_spisu`,
  - opcjonalnie `uwagi_loc`, jesli ma byc pokazywane offline,
- sprawdzic, czy obecne pola `stanInwent` i `kkWczytany` nadal wystarczaja do lokalnego preview,
- przygotowac migracje ObjectBox, jesli zmienia sie model encji.

#### 7. Ekran historii skanow

Pliki do przegladu:
- `excellent_inventaryzacja/lib/feautures/home/view/scanner_widgets/inventory_scanner_scan_tile_part.dart`
- `excellent_inventaryzacja/lib/feautures/home/view/scanner_widgets/inventory_scanner_ready_view_part.dart`

Zakres:
- sprawdzic mapowanie `responseStatus` na UI zakladek i badge,
- upewnic sie, ze nowe przypadki biznesowe (`zakupiony_w_trakcie`, `sprzedany_w_trakcie`, `znaleziony_w_innej_firmie`, itp.) sa dalej poprawnie klasyfikowane,
- sprawdzic, czy systemowe ostrzezenia z `uwagi_loc` powinny byc widoczne w historii operatora.

### Kolejnosc wdrozenia

1. Zmienic DTO `GetArkuszDetailsElementItem` na `aktualny_stan`.
2. Zregenerowac pliki `.g.dart`.
3. Naprawic preview arkusza i badge statusow.
4. Przejrzec odpowiedz skanowania i logike `resolvedStatus`.
5. Dostosowac ObjectBox snapshot i ewentualne migracje lokalne.
6. Poprawic historię skanow i zakladki filtrowania.
7. Dodac/regenerowac testy kontraktowe i integracyjne.

### Minimalny zestaw testow po migracji

1. Test DTO: `aktualny_stan` mapuje sie poprawnie i nie nadpisuje `stan_inwent`.
2. Test DTO skanu: odpowiedz skanu z pelnym `element` deserializuje sie bez bledow.
3. Test cubita skanera: zapisuje poprawny `responseStatus` dla nowych przypadkow.
4. Test preview arkusza: badge stanu ST korzysta z `aktualny_stan`.
5. Test offline sync: wpis po synchronizacji zachowuje oczekiwane dane statusowe.

### Otwarte decyzje przed implementacja mobile

1. Czy mobile ma wyswietlac `status_spisu` obok `stan_inwent` i `aktualny_stan`, czy tylko w historii / detalach?
2. Czy `event` ze skanu ma byc zapisany lokalnie jawnie, czy wystarczy sam `element` + wyliczony status pomocniczy?
3. Czy ostrzezenia zapisane w `uwagi_loc` maja byc widoczne w glownej liscie operatora, czy tylko w szczegolach elementu?
4. Czy snapshot offline ma przechowywac pelny mini-payload elementu, czy tylko pola potrzebne do skanera?

### Rekomendacja

Najpierw wdrozyc w mobile tylko zgodnosc kontraktowa DTO + preview + sync statusow, bez przebudowy UX. To najmniejsza bezpieczna zmiana i pozwoli szybko dogonic backend/front web bez ryzyka rozwalenia flow offline.
