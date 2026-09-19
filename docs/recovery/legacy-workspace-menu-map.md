# Mapa dawnego menu Workspace → standalone DevPlanner

Status: mapa wykonawcza po audycie źródeł; nie jest deklaracją, że każdy pion
jest już działający.  
Data: 2026-09-18  
Źródło prawdy dla wyglądu ramy: `docs/design/gmail-inspired-design-spec.md`.

## Cel

Nowy shell ma mieć Gmailową ramę, lecz **nie może zastępować menu Workspace
kilkoma ogólnymi ikonami**. Drzewo musi zachować dawny kontekst:

```text
Przegląd
Zadania osobiste
Pliki osobiste
Workspace
  Pliki workspace'u
  Projekty
    Projekt
      Zadania
        Lista
        Kanban
        Automatyzacje
      Whiteboardy
      Tablica korkowa
      Wiki
      Pliki projektu
Ustawienia konta
Administracja (wyłącznie po autoryzacji serwera)
```

Chat i Powiadomienia są globalnymi overlayami belki. Nie są pozycjami drzewa
ani trasami, dlatego nie wolno ich ponownie implementować jako osobnych ekranów.

## Ustalona mapa źródeł i stanów

| Dawna pozycja | Zweryfikowane źródło historyczne | Standalone status | Kanoniczny URL / następny pion |
|---|---|---|---|
| Katalog, prywatne/team/favorites/ukryte workspace'y | `workspaces_home/directory_menu/**` | katalog przestrzeni jest aktywny; preferencje katalogu wymagają osobnego odbioru | `/workspaces` |
| Zadania osobiste | `directory_menu/widgets/workspace_directory_loaded_content.dart` | aktywne z kursorem, filtrami i retry; router składa tylko `TaskViewRepository` | `/me/tasks` |
| Pliki osobiste | ten sam katalog | aktywne | `/me/files` → `StorageScope.personal` |
| Workspace | `directory_menu/widgets/workspace_directory_item.dart` | aktywne wejście do rzeczywistego katalogu projektów | `/workspaces/:workspaceId` |
| Pliki workspace'u | `workspace_directory_item.dart` | aktywne | `/workspaces/:workspaceId/files` |
| Projekty | `projects_tree/workspace_project_menu.dart` | aktywna lista z `ProjectsGateway` | `/workspaces/:workspaceId` |
| Projekt | `workspace_project_menu.dart` | aktywne wejście przekierowuje na rzeczywistą listę zadań | `/workspaces/:workspaceId/projects/:projectId` → `/tasks` |
| Zadania → Lista | `workspace_project_menu.dart`, plan integracji menu | aktywne | `/workspaces/:workspaceId/projects/:projectId/tasks` |
| Zadania → Kanban | historyczny link `/kanban` oraz kontrakt Tasks | aktywne, bez drugiej strony Kanban | `/tasks?view=kanban` |
| Zadania → Automatyzacje | `project_resource_menu_branch.dart`, `ProjectMenuAction` | backend ma kontrakt, ale nie ma odzyskanego standalone page/composition | osobny pion `automations` |
| Whiteboardy | `project_menu_groups.dart`, `project_resource_menu_branch.dart` | nie podłączone; zachować widoczny węzeł bez fałszywego linku | osobny pion `whiteboard` |
| Tablica korkowa | `workspace_project_menu.dart` | nie podłączona | osobny pion `corkboard` |
| Wiki | `workspace_project_menu.dart`, `routing/*wiki*` | nie podłączone | osobny pion `wiki` |
| Pliki projektu | `workspace_project_menu.dart` | aktywne | `/workspaces/:workspaceId/projects/:projectId/files` |
| Ustawienia konta | root standalone | aktywne w ograniczonym zakresie obecnego profilu | `/me` |
| Administracja użytkownikami | root standalone | aktywna wyłącznie po zweryfikowanym `/me` i polityce serwera | `/admin` |

## Zasady implementacji nowego shella

1. `WorkspaceNavigationTree` opisuje wyłącznie drzewo domenowe. Nie importuje
   Fluttera, GoRoutera, DTO ani klienta HTTP.
2. Stan rozwinięcia należy do shella i używa lokalnego `ValueNotifier<Set>`;
   nie zmienia trasy, nie jest globalny i nie jest Cubitem domenowym.
3. Kliknięcie aktywnej pozycji przekazuje jedynie kanoniczny URL. Widget nie
   wykonuje HTTP, uploadu, SignalR ani odczytu storage.
4. Węzeł bez gotowego pionu pozostaje widoczny dla pełnej parytetowej
   hierarchii, ale nie ma `onTap`, trasy ani symulowanego ekranu. Przy jego
   odzyskiwaniu najpierw powstają: port domeny → adapter data → mały Cubit →
   page/route → testy zachowania i ACL.
5. Widok `Zadania` jest grupą; `Lista` i `Kanban` są dwoma realnymi widokami
   jednego kontraktu Tasks. Nie wolno stworzyć drugiego repozytorium Kanban.
6. Widoczne teksty pochodzą z ARB; ikony i kolory są tokenami shella.
7. Shell ma zachować zarezerwowaną belkę 64 px, sidebar 256/72 px i jeden
   canvas content. Modal/overlay nie może wejść pod belkę.

## Kolejność odzyskania brakujących pionów

1. Odbiór ręczny desktopu dla aktywnych elementów: Workspace → Projekt →
   Lista/Kanban → Pliki projektu oraz Pliki osobiste i osobiste zadania.
2. Whiteboardy, Wiki, Corkboard i Automatyzacje — każdy jako osobny pion
   feature, z prawdziwą trasą dopiero po page + typed gateway + testach ACL.
3. Funkcje zarządzania katalogiem i workspace'em: favorite/hide/reorder,
   create/edit/archive, members/invitations/settings; nie przenosić legacy
   UI z importami Ready/Core.
4. Dopiero po odzyskaniu tych pionów przejść do dalszych zmian designu
   ekranów. Chat/Notifications pozostają overlayami i nie blokują menu.

## Aktualny dowód kodowy

`WorkspaceNavigationTree` materializuje pełne poddrzewo projektu. Shell
rozwija gałęzie lokalnym stanem i automatycznie pokazuje przodków aktywnej
trasy. Testy obejmują pełne poddrzewo, jego rozwinięcie oraz rzeczywiste URL-e
Lista/Kanban/Files/Moje zadania; wyniki pakietów R2e/R2f zapisano w obu
dziennikach standalone.

Nie wolno oznaczać tej mapy jako pełnego odzyskania wszystkich modułów. Jest
to bezpieczna granica pomiędzy przywróconą strukturą menu a pionami, których
UI trzeba jeszcze odzyskać.
