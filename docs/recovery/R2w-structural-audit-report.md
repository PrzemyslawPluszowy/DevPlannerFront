# R2w — audyt struktury aktywnego Frontu

Data: 2026-09-18  
Status: automatyczny audit zakończony; desktop/staging: **NIE URUCHAMIANO**.

## Kontrole wykonane po R2r–R2v

| Kontrola | Wynik | Znaczenie |
|---|---|---|
| `rg` Ready/Core/DataBus w `app`, `auth`, `foundation`, `workspaces` | brak wyników | Nie znaleziono pozostałości zewnętrznych integracji w aktywnym kodzie Fluttera. |
| `rg setState` w `app`, `foundation`, Tasks i Files | brak wyników | Nowy/refaktorowany aktywny kod nie używa `setState`; krótkie stany UI są `ValueNotifier` albo Cubit. |
| Skan plików >400 linii | 3 pliki | To nie jest automatycznie naruszenie: plik routera ma kilka klas i wydzielony part builder; plik automatyzacji ma osobny stan/loader/dry-run; transport ma kilka adapterów. |

## Zweryfikowane granice klas

- `AutomationSettingsCubit`: 392 linii, bez `BuildContext` i bez UI.
- `DevPlannerRouter`: konfiguracja tras/guard/lifecycle; builder stron jest w
  `devplanner_router_pages.part.dart` (209 linii).
- `DevPlannerHttpTransport`: plik ma osobne request/response/adaptery;
  sama klasa transportu nie przekracza limitu.

Kontrola plikowa pozostaje tylko wskazówką do review. Nie rozbijać klas
mechanicznie według liczby linii ani nie przenosić działających pionów do
pustych katalogów. Każdy następny podział musi zachować testy i odpowiedzialność
feature → subfeature → data/domain/presentation.

## Brak fałszywego odbioru live

Audyt nie dowodzi połączenia z lokalnym backendem, MinIO, SignalR, OnlyOffice
ani stagingiem. Te elementy pozostają **NOT RUN** zgodnie z decyzją, aby nie
uruchamiać aplikacji lokalnie w tej fazie.
