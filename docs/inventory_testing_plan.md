# Plan Testow Inwentaryzacji

## Cel
Podniesc jakosc testow tak, aby wykrywaly luki biznesowe i regresje w logice drzewa (`node/subtree`), mapowaniu danych oraz przeplywach Cubit/Repository.

## Zakres i status

### 1) Krytyczne E2E backend dla `node/subtree`
- [x] Test tworzy testowa inwentaryzacje.
- [x] Test tworzy arkusz `node` i `subtree`.
- [x] Test porownuje wynik z `stan_st` (licznosc + zakres miejsc + multiset kluczy biznesowych).
- [x] Test sprzata dane po wykonaniu.
- [x] Debug summary (`debugPrint`) z wybranym drzewem i licznikami.

### 2) Testy Cubit nastawione na wykrywanie luk
- [x] `CreateArkuszCubit`:
  - [x] sortowanie miejsc,
  - [x] fallback bez filtra firmy,
  - [x] obsluga bledu slownika,
  - [x] poprawny payload `createArkusz`,
  - [x] obsluga bledu submit,
  - [x] test luki walidacji (`selectedMiejsceId == null`).
- [x] `CreateInventoryCubit`:
  - [x] sortowanie firm i domyslna firma,
  - [x] obsluga bledu przy ladowaniu firm,
  - [x] aktualizacja wyboru firmy,
  - [x] sukces submit,
  - [x] blad submit,
  - [x] blokada submit poza stanem `Loaded`.

### 3) Logika drzewa jako testowalny modul
- [x] Wydzielenie logiki drzewa do `create_arkusz_tree_utils.dart`.
- [x] Podpiecie modala do wydzielonej logiki.
- [x] Testy unit dla:
  - [x] wykrycia trybu parent (`id` vs `id_miejsca`),
  - [x] `treeKey`,
  - [x] `resolveLocationScope` dla null/leaf/node z dziecmi/nieistniejacego wyboru.

### 4) Dalsze luki (nast epny etap)
- [x] Testy repository (`InventoriesRepositoryImpl`, `StockRepositoryImpl`, `LocationsRepositoryImpl`, `UsersRepositoryImpl`) z mockowanym `InventoryApi`:
  - [x] sukces + blad Dio,
  - [x] scenariusz parsing error,
  - [x] cache invalidation dla slownikow.
- [ ] Testy Cubit:
  - [x] `InventoryDetailCubit`,
  - [x] `ChangeItemCubit`,
  - [x] `EditCommissionCubit`,
  - [x] `StockCubit`, `LocationsCubit`, `CompaniesCubit`,
  - [x] `DeleteCompanyCubit`,
  - [x] `ArkuszPreviewCubit`, `InventoryPreviewCubit`.
- [ ] Dodatkowe E2E:
  - [ ] `subtree` dla liscia == `node`,
  - [ ] przypadek miejsca bez elementow,
  - [ ] duplikat arkusza dla tego samego miejsca (UNIQUE).
- [x] Testy modeli endpointow (krytyczne DTO i helpery enumow):
  - [x] `get_inwentaryzacje_models`,
  - [x] `get_stan_st_models`,
  - [x] `get_arkusz_details_models`,
  - [x] `get_miejsca_models`,
  - [x] `get_ready_users_search_models`.

## Kryterium gotowosci etapu
- Wszystkie nowe testy przechodza lokalnie.
- `dart analyze` przechodzi bez bledow dla nowych plikow.
- Każdy test ma opis po polsku i opisuje jaka luke/regresje wykrywa.
