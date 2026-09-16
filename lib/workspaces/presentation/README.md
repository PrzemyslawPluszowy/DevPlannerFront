# Workspaces — warstwa prezentacji

Warstwa prezentacji nie zna `Dio`, Retrofit ani ścieżek HTTP. Ekrany korzystają
wyłącznie z kontraktów domenowych i lokalnych Cubitów. Każdy większy obszar
modułu powinien mieć własny katalog, żeby widgety, stan i testy pozostawały
blisko funkcji, której dotyczą.

Globalny wpis Workspaces jest dostępny po zalogowaniu. Backend filtruje listę
po aktywnym członkostwie; jedyny globalny wyjątek stanowi permission
`bswfms.custom_modules.RNext-admin`, który daje SuperAdminowi dostęp do
wszystkich workspace’ów. Nie ma osobnego prawa modułowego Workspaces.

## Aktualny shell modułu

- `workspaces_home_page.dart` — responsywny shell Web/Desktop z menu bocznym;
- `workspaces_home/` — ekran przeglądu workspace’ów, jego Cubit i widgety;
- `workspaces_home/cubit/` — sealed states oraz lokalny Cubit ładowania listy;
- `workspaces_home/widgets/` — karta workspace’u i widoki loading/empty/error;
- `sections/` — miejsce na osobne ekrany menu, gdy kontrakt danej domeny zostanie
  podłączony do warstwy domenowej.

## Mapa menu → kontrakt backendu

| Sekcja | Źródło danych | Planowany katalog prezentacji |
| --- | --- | --- |
| Przegląd | `GET /api/v1/workspaces/` | `workspaces_home/` |
| Projekty | `data/projects/` | `sections/projects/` |
| Zadania | `data/projects/tasks/` | `sections/tasks/` |
| Pliki i dokumenty | `data/storage/` | `sections/files/` |
| Chat | `data/chat/` | `sections/chat/` |
| Whiteboardy | `data/whiteboard/` i `data/corkboard/` | `sections/whiteboards/` |
| Wiki | `data/wiki/` | `sections/wiki/` |
| Powiadomienia | `data/notifications/` | `sections/notifications/` |

Placeholder sekcji nie udaje gotowych danych: komunikuje użytkownikowi, że
kontrakt UI nie został jeszcze podłączony. Błędy z podłączonych endpointów są
wyświetlane wraz z komunikatem backendu i kodem błędu.
