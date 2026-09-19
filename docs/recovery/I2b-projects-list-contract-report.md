# I2b — lokalny kontrakt listy projektów

Data: 2026-09-17  
Repozytorium: `Front`  
Zakres: lista projektów jednego workspace’u i bezpośrednie Cubity nawigacji.  
Backend: tylko odczyt jako źródło prawdy; bez zmian w repozytorium Backend.

## Wynik

Dodano lokalny, list-only pion:

```text
WorkspaceProjectsCubit / WorkspaceProjectAccessCubit
  └─ ProjectsGateway
       └─ ProjectsGatewayImpl
            ├─ ProjectsListApi
            │    └─ DevPlannerProjectsListApi
            │         └─ DevPlannerHttpTransport
            ├─ DevPlannerProjectListItemResponse
            └─ ProjectListItemMapper
```

Żaden plik tego pionu nie importuje `package:ready_next`. Nie ma fallbacku z
przykładowym projektem, globalnej funkcji ani dostępu do HTTP w Cubicie/UI.
Identyfikacja użytkownika nie jest tworzona po stronie klienta: endpoint jest
wywoływany przez sesyjny `DevPlannerHttpTransport`, a odpowiedź zawiera tylko
backendowe `myRole`. Nie wprowadzono `coreUserId`, `readyUserId` ani zewnętrznej
tożsamości.

## Kontrakt backendu — dowody

Źródło: sąsiednie repozytorium `Backend`.

- `Backend/Endpoints/Projects/ProjectEndpoints.cs:18` — grupa wymaga
  autoryzacji i ma ścieżkę `/api/v1/workspaces/{workspaceId:guid}/projects`.
- `ProjectEndpoints.cs:24-27` — `GET /` zwraca
  `IReadOnlyList<ProjectListItemResponse>`; backend opisuje filtrowanie po
  członkostwie, Shared/Private i preferencjach ukrycia.
- `ProjectEndpoints.cs:117-120` — `workspaceId` i `includeHidden` są parametrami,
  a lokalny `user.UserId` pochodzi z `GetCurrentUserHandler`.
- `Backend/Contracts/Projects/ProjectListItemResponse.cs:5-6` — pola to:
  `id`, `workspaceId`, `name`, `description`, `icon`, `primaryColor`,
  `visibility`, `status`, `myRole`, `isPinned`, `sortPosition`.
- `Backend/Application/Projects/ProjectHandlers.cs:59-76` — backend wymaga
  roli Observer, odrzuca zarchiwizowane projekty, filtruje ACL, respektuje
  `includeHidden` i sortuje przypięcie → sort position → nazwę → ID.
- `ProjectEndpoints.cs:32-35` — brak dostępu do pojedynczego projektu zwraca
  404, aby nie ujawniać jego istnienia. Klient zachowuje ten sam `notFound`.

## Zaimplementowane pliki

### Domain

- `lib/workspaces/domain/ports/projects_gateway.dart`
  - `ProjectsGateway.listProjects(workspaceId, includeHidden)`;
  - `ProjectsFailureReason` z rozróżnieniem transport, 401, 403, 404,
    request i invalid response;
  - `ProjectsGatewayException` zachowujący status, backend code, message i
    trace ID bez zamiany błędu w pustą listę.
- `lib/workspaces/domain/models/project_list_item.dart`
  - importy enumów zmienione na lokalne `package:devplanner`;
  - model nadal nie zna DTO ani transportu.

### Data

- `lib/workspaces/data/projects/api/projects_list_api.dart`
  - wąski port API i implementacja endpointu;
  - `workspaceId` jest częścią ścieżki, `includeHidden` query.
- `lib/workspaces/data/projects/responses/devplanner_project_list_item_response.dart`
  - ręcznie walidowany DTO zgodny z C#;
  - odrzuca brak/nieprawidłowy ID, nazwę, workspace, enum lub `isPinned`.
- `lib/workspaces/data/projects/mappers/project_list_item_mapper.dart`
  - jedyne mapowanie DTO → domain.
- `lib/workspaces/data/projects/repositories/projects_gateway_impl.dart`
  - mapuje HTTP 401/403/404 na typed reason;
  - odrzuca niepoprawne odpowiedzi;
  - dodatkowo odrzuca element, którego `workspaceId` różni się od żądanego,
    aby nie mieszać gałęzi drzewa nawet przy błędnym payloadzie.
- `lib/workspaces/data/projects/projects_list.dart`
  - clean barrel wyłącznie dla tego pionu; nie eksportuje legacy aggregate.

### Presentation

- `workspace_projects_cubit.dart/.state.dart` — leniwe ładowanie jednego
  workspace’u, typed failure, brak wiadomości wymyślonych w Cubicie.
- `workspace_project_access_cubit.dart/.state.dart` — dostęp przyznawany
  wyłącznie, gdy projekt znajduje się w odpowiedzi dla wskazanego workspace;
  brak projektu jest `notFound` bez enumeracji.

## Liczniki importów `ready_next`

Policzono przed zmianą z wersji bazowej `HEAD` i po zmianie w dokładnie tych
plikach:

| Plik | Przed | Po |
| --- | ---: | ---: |
| `domain/models/project_list_item.dart` | 3 | 0 |
| `presentation/navigation/cubit/workspace_projects_cubit.dart` | 6 | 0 |
| `presentation/navigation/cubit/workspace_projects_state.dart` | 1 | 0 |
| `presentation/navigation/cubit/workspace_project_access_cubit.dart` | 3 | 0 |
| `presentation/navigation/cubit/workspace_project_access_state.dart` | 1 | 0 |
| Nowy clean pion I2b | 0 | 0 |

Stare `projects_api.dart`, `ProjectsRepository` oraz Freezed DTO agregujące
CRUD/członkostwa nie zostały podmienione, bo wciągałyby do tej migracji
Kanban, członkostwa, payloady mutacji i modele z `coreUserId`. Nie są zależnością
nowego pionu. Ich osobna migracja musi zachować równoważną funkcjonalność i
nie może być wykonana przez globalne `ready_next` → `devplanner`.

## Testy

Dodano/zmigrowano:

- `test/workspaces/data/projects/projects_gateway_test.dart`
  - workspace ID w URL i `includeHidden`;
  - mapowanie prawdziwego DTO;
  - 403 → `forbidden`;
  - 404 → `notFound` z kodem backendu;
  - invalid response i element z innego workspace.
- `test/workspaces/presentation/navigation/workspace_projects_cubit_test.dart`
  - ready state i typed forbidden.
- `test/workspaces/presentation/navigation/workspace_project_access_cubit_test.dart`
  - access tylko w obrębie workspace i not-found bez enumeracji.

## Kompatybilność i świadomy następny krok

Nowe Cubity przyjmują `ProjectsGateway`, nie legacy `ProjectsRepository`.
Stare widoki `workspaces_home` i `WorkspaceProjectsPageView` nadal mają
historyczne wstrzykiwanie `ProjectsRepository`; nie zostały podłączone w I2b,
ponieważ zadanie zabraniało ruszać shell/UI i router. To jest jawny punkt
integracji dla kolejnego zadania: composition root musi dostarczyć
`ProjectsGatewayImpl(DevPlannerProjectsListApi(transport))`, a nowy sidebar
powinien używać clean Cubitów. Nie wolno rozwiązać tego przez alias do
`ready_next` ani przez przykładowe dane.

Nie usunięto backendowych możliwości tworzenia/reorderingu projektu z repo ani
nie dotykano Kanban, plików, Chat, Notifications, root routera i shella.

## Walidacja

```text
dart format <14 plików I2b>
PASS — 14 files formatted successfully

flutter test \
  test/workspaces/data/projects/projects_gateway_test.dart \
  test/workspaces/presentation/navigation/workspace_projects_cubit_test.dart \
  test/workspaces/presentation/navigation/workspace_project_access_cubit_test.dart
PASS — 10 tests

flutter analyze <13 plików I2b i testów>
PASS — No issues found

git diff --check
PASS
```

Nie wykonywano `restore`, `clean`, `reset`, `checkout`, commit ani push.
Istniejące niezwiązane zmiany worktree zostały zachowane.
