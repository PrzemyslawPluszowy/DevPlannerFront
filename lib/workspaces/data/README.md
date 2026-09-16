# Workspaces data

Warstwa odwzorowuje kontrakty HTTP z `veloryn-workspaces`.

- `shared/` — typy wspólne modułu, w tym `ApiErrorResponse`, enumy i cursor paging;
- `workspaces/` — workspace, członkostwa, zaproszenia i katalog Ready;
- `projects/` — projekty oraz kontrakty ich domen podrzędnych;
- w każdej domenie `api/` zawiera wyłącznie klientów Retrofit, a `models/`
  wyłącznie modele Freezed; payloady i odpowiedzi są w osobnych katalogach
  `payloads/` i `responses/`, gdy domena ma większy kontrakt;
- każdy klient HTTP jest deklarowany w Retrofit;
- payloady i odpowiedzi są typowane przez Freezed/json_serializable;
- nazwy pól JSON zachowują nazwy C#; wyjątkiem są słowa zarezerwowane w Dart, mapowane przez `@JsonKey`;
- komentarze `///` przy endpointach opisują działanie endpointu po polsku.

Źródła referencyjne:

- `veloryn-workspaces/Endpoints/**/*.cs` — metoda, ścieżka i parametry HTTP;
- `veloryn-workspaces/Contracts/**/*.cs` — payloady, odpowiedzi i enumy.

## Weryfikacja tras 1:1

Po wygenerowaniu Swaggera backendu można sprawdzić kompletność deklaracji Retrofit:

```bash
python3 tool/verify_workspaces_contracts.py /ścieżka/do/swagger.json
```

Audyt porównuje metodę HTTP i ścieżkę każdej operacji. Końcowy slash jest
normalizowany, ponieważ ASP.NET publikuje grupy zakończone `/` w OpenAPI bez
końcowego slash.
