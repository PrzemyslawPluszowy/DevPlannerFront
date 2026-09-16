# TODO - Inwentaryzacja API (panel) - 2026-04-08

## Zakres

- `POST /api/v1/inwentaryzacja/{inwentaryzacja_id}/skanuj`:
  - endpoint tylko dla aplikacji mobilnej,
  - poza zakresem panelu (nie implementujemy w panelu).

## TODO (panel)

1. [x] Rozszerzyć model elementu arkusza (`GET /api/v1/inwentaryzacja/arkusze/{arkusz_id}`)

- Dodać pola: `nadw_idmiejsce`, `nadw_miejsce`, `nadw_lvl`.
- Plik: `lib/features/inventory/data/models/endpoints/get_arkusz_details_models.dart`

2. [x] Rozszerzyć request aktualizacji elementu (`PATCH /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}`)

- Dodać pole: `nadw_idmiejsce`.
- Plik: `lib/features/inventory/data/models/endpoints/patch_arkusz_element_models.dart`

3. [x] Dodać endpoint nadwyżki do warstwy danych panelu

- Endpoint: `POST /api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy`
- Request: `kod_kreskowy` (required), `nazwa?`, `nrewid?`, `osoba?`
- Response: `id` (required), opcjonalnie `success`, `nadwyzka`
- Pliki:
  - `lib/features/inventory/data/api/inventory_api.dart`
  - `lib/features/inventory/data/models/endpoints/*`
  - repo/cubit/use-case używające tego flow (jeśli wymagane przez UI panelu)

4. [x] Wygenerować pliki po zmianach modeli/API

- `dart run build_runner build --delete-conflicting-outputs`

5. [ ] Weryfikacja końcowa

- `dart format ...`
- `flutter analyze`
- testy inventory (minimum smoke dla flow edycji elementu)
- ponowne porównanie kontraktu z aktualnym Swagger/OpenAPI backendu `8101`

Wynik:

- `dart format ...` wykonane.
- `flutter analyze` wykonane: brak problemów.
- kontrakt endpointów panelu sprawdzony po zmianach 1:1 (bez aliasów): `OK`.
- `flutter test test/features/inventory` nie przechodzi z powodów niezwiązanych z tym taskiem (istniejący błąd testu `InventoryUsersSearchPicker` i `l10n` null).
- `flutter test test/features/inventory/presentation/pages/inventories/cubit/inventories_cubit_test.dart` przechodzi.
- nowe zmiany z TODO wdrożone i zgodne ze Swagger.

## Definicja ukończenia

- [ ] Wszystkie punkty 1-5 odhaczone.
- [x] Brak błędów w `flutter analyze`.
- [x] Kontrakt endpointów panelu zgodny z aktywnym Swagger/OpenAPI backendu `8101`.

## Źródło kontraktu

- Swagger UI: `http://192.168.170.20:8101/api/documentation#/`
- OpenAPI JSON: `http://192.168.170.20:8101/docs?api-docs.json`
