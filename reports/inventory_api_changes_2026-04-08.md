# Inwentaryzacja API - zmiany vs app (2026-04-08)

Zrodlo: http://192.168.170.20:8101/docs?api-docs.json

## Nowe endpointy w Swagger (brak w app)

1. `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/skanuj`
- Path: `inwentaryzacja_id` (required)
- Body: `SkanujRequest`
- Response: `SkanujResponse`

2. `POST /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy`
- Path: `arkusz_id` (required)
- Body: `AddNadwyzkaRequest`
- Response: `AddNadwyzkaResponse`

## Endpointy obecne w app i Swagger (parametry)

1. `GET /api/v1/inwentaryzacja`
- Query: `firma`, `status`, `numer`, `data_od_from`, `data_od_to`, `sort_by`, `sort_dir`

2. `POST /api/v1/inwentaryzacja`
- Body: `CreateInwentaryzacjaRequest`

3. `GET /api/v1/inwentaryzacja/{inwentaryzacja_id}`
- Path: `inwentaryzacja_id`

4. `DELETE /api/v1/inwentaryzacja/{inwentaryzacja_id}`
- Path: `inwentaryzacja_id`

5. `PUT /api/v1/inwentaryzacja/{inwentaryzacja_id}/komisja`
- Path: `inwentaryzacja_id`
- Body: `UpdateKomisjaRequest`

6. `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/zamknij`
- Path: `inwentaryzacja_id`
- Body: `ZamknijInwentaryzacjeRequest`

7. `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze`
- Path: `inwentaryzacja_id`
- Body: `CreateArkuszRequest`

8. `GET /api/v1/inwentaryzacja/arkusze/{arkusz_id}`
- Path: `arkusz_id`

9. `DELETE /api/v1/inwentaryzacja/arkusze/{arkusz_id}`
- Path: `arkusz_id`

10. `PUT /api/v1/inwentaryzacja/arkusze/{arkusz_id}/komisja`
- Path: `arkusz_id`
- Body: `UpdateKomisjaRequest`

11. `PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}`
- Path: `arkusz_id`, `element_id`
- Body: `UpdateElementRequest`

12. `GET /api/v1/inwentaryzacja/firmy`

13. `DELETE /api/v1/inwentaryzacja/firmy/{firma_id}`
- Path: `firma_id`

14. `GET /api/v1/inwentaryzacja/miejsca`
- Query: `firma`

15. `GET /api/v1/inwentaryzacja/stan_st`
- Query: `firma`, `nazwa`, `nrewid`, `kod_kreskowy`, `limit`, `offset`

## Zmiany schematow (wzgledem modeli app)

1. `GET /api/v1/inwentaryzacja/arkusze/{arkusz_id}` (`ArkuszElementItem`)
- Doszly pola: `nadw_idmiejsce`, `nadw_miejsce`, `nadw_lvl`

2. `PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}` (`UpdateElementRequest`)
- Dostepne pole: `nadw_idmiejsce` (w app obecnie brak w `PatchArkuszElementQuery`)

3. `GET /api/v1/inwentaryzacja/firmy` (`FirmaItem`)
- Kontrakt: `orunid` + `ndenam` (required)
- Model app mapuje to przez `@JsonKey` na `idFirmy` + `nazwa` (OK funkcjonalnie)

4. `GET /api/v1/inwentaryzacja` (`InwentaryzacjaListItem.status`)
- Swagger: `integer` (`0`, `1`, `2`)
- App: enum `InwentaryzacjaStatus` z `@JsonValue(int)` (powinno byc OK runtime)

## Schematy nowych endpointow

1. `SkanujRequest`
- `kod_kreskowy` (int, required, min 1)
- `arkusz_id` (int, required, min 1)

2. `SkanujResponseData`
- required: `status` (string)
- opcjonalne: `element_id`, `arkusz_id`, `kod_kreskowy`, `nazwa`, `nrewid`, `miejsce_ewidencja`, `miejsce_znalezienia`, `firma`, `firma_nazwa`

3. `AddNadwyzkaRequest`
- required: `kod_kreskowy` (int)
- opcjonalne: `nazwa`, `nrewid`, `osoba`

4. `AddNadwyzkaResponseData`
- required: `id`
- opcjonalne/default: `success=true`, `nadwyzka=1`

## Wnioski

1. Krytyczne do dopiecia po stronie app:
- dodac Retrofit + modele dla `/skanuj`
- dodac Retrofit + modele dla `POST /arkusze/{arkusz_id}/elementy`
- rozszerzyc modele szczegolow arkusza o `nadw_idmiejsce`, `nadw_miejsce`, `nadw_lvl`
- rozszerzyc `PatchArkuszElementQuery` o `nadwIdmiejsce`

2. Dodatkowo:
- odswiezyc generator modeli (`build_runner`) po zmianach
- odpalic kontrakt verifier i testy inventory
