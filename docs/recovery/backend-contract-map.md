# DevPlanner — potwierdzona mapa kontraktów Backend → Front

Status: stan odczytany z kodu 2026-09-17, **nie** deklaracja działającego
E2E. Dokument jest źródłem pracy dla R2/R3 i review; nie wolno na jego
podstawie wymyślać dodatkowych tras lub pól.

## Jak czytać mapę

* `BE` oznacza plik, w którym endpoint jest rejestrowany. Nazwy request/response
  są typami C# z katalogu `Backend/Contracts/...`; ta nazwa jest źródłem pola
  po polu, a nie opis skrócony z tego dokumentu.
* `FE` wskazuje aktualny klient Retrofit/adaptor Fluttera; `BRAK` znaczy, że
  nie znaleziono odpowiedniego aktywnego klienta źródłowego. Sam plik klienta
  nie dowodzi, że kompozycja runtime go wywołuje.
* Chronione endpointy używają domyślnego schematu `DevPlanner.Api`: gdy żądanie
  ma nagłówek `Authorization: Bearer ...`, jest ono przekazywane do lokalnej
  walidacji OpenIddict; bez tego nagłówka używana jest sesja BFF w cookie.
  Dla obu dróg bieżący użytkownik to wyłącznie `Guid` z claimu `sub`, odczytany
  przez `Backend/Application/Auth/GetCurrentUser/LocalUserIdHandler.cs` albo
  `GetCurrentUserHandler.cs`. Mutacje wykonane sesją BFF wymagają również
  cookie i nagłówka CSRF; klient desktopowy z bearerem ich nie wysyła. Nie
  istnieje dopuszczalny fallback `CoreUserId`, `ReadyUserId`, `ready_id` ani
  domyślny użytkownik.
* `ACL R/W/M/D` to potwierdzone sprawdzanie w serwisie: read / write / manage /
  delete. Jest to ważniejsze niż ukrycie przycisku po stronie Fluttera. Role są
  workspace: `Observer`, `Member`, `Admin`, `Owner`; projekt: `Observer`,
  `Member`, `Admin`, `Owner`. Nie ma osobnej nazwanej ASP.NET policy dla tych
  przypadków — endpoint wymaga `Auth`, a handler/service egzekwuje ACL.
* Jedyna potwierdzona nazwana policy HTTP to
  `DevPlanner.Admin.UsersManage`, oparta o permission `users.manage`
  (`Backend/Application/Auth/Admin/LocalUserAdminPolicies.cs`). Ops i ręczne
  admin-notifications wymagają SuperAdmina wewnątrz use-case'a. Aktualny kod
  rozpoznaje go po claime `permission=bswfms.custom_modules.RNext-admin`
  (`Backend/Application/Workspaces/Access/WorkspaceAccessService.cs`); jest to
  fakt do usunięcia/zweryfikowania przez identity repair, nie kontrakt UI.

## Tożsamość, auth, `/me`, admin

| Route i metoda | BE / request → response | UserId i policy | FE |
|---|---|---|---|
| `GET /auth/login`, `POST /auth/login` | `Endpoints/Auth/LocalLoginEndpoints.cs`; `LocalLoginRequest` → cookie/redirect | publiczny login; lokalne aktywne i potwierdzone konto | `lib/auth/data/adapters/desktop_pkce_auth_adapter.dart` korzysta z `/connect/*`, nie ma klienta formularza loginu |
| `GET /bff/auth/start`, `GET /bff/auth/callback`, `GET /bff/session`, `GET /bff/csrf`; `POST /bff/auth/logout` | `Endpoints/Auth/BffEndpoints.cs`; BFF protocol → cookie sesji i CSRF | start/callback/session są anonimizowane na poziomie routingu (`/bff/session` zwraca 401 bez sesji); csrf i logout wymagają Auth. BFF nie zwraca tokenów OIDC do Fluttera. | `lib/auth/data/adapters/web_bff_auth_adapter.dart` |
| `GET /connect/authorize`, `POST /connect/token` | `Endpoints/Auth/BffEndpoints.cs`; OpenIddict authorization-code + PKCE oraz refresh-token protocol | wyłącznie desktopowy client `devplanner-desktop`; po wymianie desktop używa bearera dla `/api/*`. To nie jest API webowego BFF. | `desktop_pkce_session_transport_io.dart` |
| `POST /api/v1/auth/forgot-password`, `/reset-password`, `/activate` | `Endpoints/Auth/AccountRecoveryEndpoints.cs`; `ForgotPasswordRequest` / `CompletePasswordResetRequest` → HTTP result | publiczne, neutralne błędy | `BRAK` potwierdzonego Retrofit klienta |
| `GET /api/v1/auth/mfa/status`; `POST /totp/setup`, `/totp/confirm`, `/totp/disable`, `/recovery-codes/regenerate` | `Endpoints/Auth/MfaEndpoints.cs`; DTO z `Contracts/Auth/Mfa/MfaContracts.cs` | Auth, własny `sub` | `BRAK` |
| `GET`, `PATCH /api/v1/me`; `POST`, `GET`, `DELETE /api/v1/me/avatar`; `GET /sessions`; `DELETE /sessions/{sessionId}`; `POST /api/v1/auth/change-password` | `Endpoints/Auth/MeEndpoints.cs`; `UpdateUserProfileRequest`, `ChangePasswordRequest`, session/avatar multipart → `UserProfileResponse`, `UserSessionResponse`, image | Auth, wyłącznie użytkownik z `sub` | `lib/me/data/me_api_adapter.dart` |
| `GET /api/v1/users/{userId}/avatar` | `MeEndpoints.cs`; brak body → image/jpeg/png/webp | Auth; `userId` jest ID celu, nie bieżącego aktora | `me_api_adapter.dart` |
| `GET`, `POST /api/v1/admin/users`; `GET`, `PATCH /{userId}`; `POST /{userId}/deactivate`, `/reactivate`; `PUT /{userId}/roles` | `Endpoints/Auth/LocalUserAdminEndpoints.cs`; `Create/Update/Assign...` z `Contracts/Admin/LocalUserAdminContracts.cs` → local-user responses | `Auth + DevPlanner.Admin.UsersManage`; aktor z `sub` | `lib/admin/data/adapters/admin_user_gateway_api_adapter.dart` |
| `POST /api/v1/admin/users/{userId}/activation-email`, `/force-password-reset` | `AccountRecoveryEndpoints.cs`; body zależny od recovery contract → `202 Accepted` albo typowany błąd | `Auth + DevPlanner.Admin.UsersManage` oraz rate limit `auth-recovery-admin` | `BRAK` |
| `GET|POST /api/v1/auth/me` | **BRAK w aktywnym backendzie** | — | `lib/workspaces/data/auth/api/auth_api.dart` jest niezgodnym, osieroconym klientem |

## Workspaces i projekty

| Route i metoda | BE / request → response | UserId i ACL | FE |
|---|---|---|---|
| `POST`, `GET /api/v1/workspaces` | `Endpoints/Workspaces/WorkspaceEndpoints.cs`; `CreateWorkspaceRequest` → `WorkspaceResponse`; list → `WorkspaceListItemResponse[]` | Auth; create dodaje `sub` jako Owner, list filtruje członkostwo | `data/workspaces/api/workspaces_api.dart` |
| `GET`, `PATCH /{workspaceId}`; `POST /{workspaceId}/archive`, `/restore` | `WorkspaceEndpoints.cs`; `UpdateWorkspaceRequest` → `WorkspaceResponse` | Auth + ACL: R / Admin / Owner / Owner(archiwum) | `workspaces_api.dart` |
| `PATCH /{workspaceId}/preferences`; `PUT /preferences/order` | `WorkspaceEndpoints.cs`; `UpdateWorkspaceUserPreferenceRequest`, `UpdateWorkspaceOrderRequest` → preference/list | Auth + własne preferencje, workspace R | `workspaces_api.dart` |
| `GET`, `PATCH /{workspaceId}/notification-preferences` | `WorkspaceEndpoints.cs`; workspace notification preference request/response | Auth + workspace Observer | `workspaces_api.dart` |
| `GET /{workspaceId}/members`, `/{workspaceId}/users/search`; invitations: `POST|GET /{workspaceId}/invitations`, `GET /invitations/me`, `POST /{workspaceId}/invitations/{invitationId}/accept|decline|cancel|resend`; `PATCH /{workspaceId}/members/{memberId}/role`; `DELETE /{workspaceId}/members/{memberId}|/{workspaceId}/members/me` | `WorkspaceEndpoints.cs`; member/invitation/directory DTO | Auth + R; create/cancel/resend/change/revoke Admin; accept/decline własne; leave własne | `workspaces_api.dart` |
| `GET /{workspaceId}/home`, `/dashboard/me`, `/search`, `/activity`; `GET /projects/{projectId}/dashboard` | `HomeDashboardEndpoints.cs`, `GlobalSearchEndpoints.cs`, `WorkspaceActivityEndpoints.cs`, `ProjectDashboardEndpoints.cs`; query → dashboard/search/activity DTO | Auth + workspace/project R | `data/workspaces/api/workspace_feature_api.dart` |
| `GET|PUT /{workspaceId}/dashboard/preferences` | `DashboardPreferenceEndpoints.cs`; `UpdateDashboardPreferenceRequest` → `DashboardPreferenceResponse` | Auth + własne prefs, workspace/project R | `workspace_feature_api.dart` |
| Automation: `GET|POST /projects/{projectId}/automations`, `PUT /{ruleId}`, `PATCH /{ruleId}/enabled`, `DELETE /{ruleId}`, `GET /catalog|recipes|{ruleId}/runs`, `POST /recipes/{key}/install|{ruleId}/dry-run` | `AutomationEndpoints.cs`; `Automation*Request` → `Automation*Response` | Auth + project R (read), M (mutacje) | `data/workspaces/api/automation_api.dart` |
| Task sync: `GET|POST /projects/{projectId}/task-sync/links`, `PATCH /links/{linkId}` | `CrossModuleSyncEndpoints.cs`; create/set-state → `CrossModuleSyncLinkResponse` | Auth + project R / W / M | `workspace_feature_api.dart` |
| `POST`, `GET /api/v1/workspaces/{workspaceId}/projects`; `PUT /preferences/order`; `GET|PATCH|DELETE /{projectId}`; `POST /{projectId}/archive|restore` | `Endpoints/Projects/ProjectEndpoints.cs`; `Create/UpdateProjectRequest` → `ProjectResponse`/list | Auth + workspace Member(create), project R/M/D; restore M | `data/projects/api/projects_api.dart` |
| Project members: `GET /{projectId}/members|members/profiles`; `POST /members`; `PATCH /members/{memberId}/role`; `DELETE /members/{memberId}|/members/me`; `PATCH /preferences` | `ProjectEndpoints.cs`; membership/preference DTO | Auth + project R/M; leave own membership | `projects_api.dart` |
| Templates: `GET /project-templates`; `POST /from-project/{projectId}`; `GET|DELETE /{templateId}`; `PUT /{templateId}/from-project/{projectId}`; `POST /{templateId}/apply` | `ProjectEndpoints.cs`; `ProjectTemplate*` DTO | Auth; permission decided by template/project service | `data/projects/templates/api/project_templates_api.dart` |
| Portfolios: `GET|POST /portfolios`; `GET|PUT|DELETE /{portfolioId}`; `POST|DELETE /{portfolioId}/projects`; `GET /dashboard` | `Endpoints/Projects/PortfolioEndpoints.cs`; `Create/UpdatePortfolioRequest` etc. → `Portfolio*Response` | Auth + workspace/project ACL in portfolio service | `data/projects/portfolios/api/portfolios_api.dart` |
| Milestones: `GET|POST /milestones`; `GET|PUT|DELETE /{milestoneId}`; `GET|PUT|DELETE /{milestoneId}/tasks` | `ProjectMilestoneEndpoints.cs`; `Create/UpdateMilestoneRequest` → `Milestone*Response` | Auth + project R/W/M | `data/projects/milestones/api/milestones_api.dart` |
| Custom workflow: `GET|POST /custom-workflow/statuses`; `PUT|DELETE /statuses/{id}`; `POST /statuses/reorder`; `GET /templates`; `POST /templates/apply` | `ProjectCustomStatusEndpoints.cs`; `ProjectCustomStatus*Request` → status/template DTO | Auth + project R / M | `data/projects/custom_workflow/api/custom_workflow_api.dart` |

## Tasks i Kanban

| Route i metoda | BE / request → response | UserId i ACL | FE |
|---|---|---|---|
| `POST /tasks`, `/quick-create`; `GET /tasks`, `/groups`, `/{taskId}`, `/{taskId}/history`; `PATCH /{taskId}`, `/{taskId}/list-item`, `/{taskId}/move`; `PUT /order`; `POST /{taskId}/archive|restore` | `Endpoints/Tasks/ProjectTaskEndpoints.cs`; create/update/move/order/history DTO → `ProjectTaskResponse`, list/group/mutation responses | Auth + project/task R; create W; mutation W (version/concurrency) | `data/projects/tasks/api/tasks_api.dart`, `task_advanced_api.dart` |
| `POST /tasks/selection-token`; `PATCH /selection-token/bulk`; dependencies `GET|POST /{taskId}/dependencies`, `PUT|DELETE /{taskId}/dependencies/{id}` | `ProjectTaskEndpoints.cs`; `TaskOperationsRequests`, dependency DTO → task mutation | Auth + task R/W | `tasks_api.dart` |
| Konfiguracja listy: `GET /task-list/configuration`, `GET|PUT /task-list/policy`, `GET|PUT /task-list/preferences`, `POST /task-list/preferences/reset` | `Endpoints/Tasks/TaskListConfigurationEndpoints.cs`; `EffectiveTaskListConfigurationResponse`, `ProjectTaskListPolicyResponse`, `TaskListUserPreferenceResponse`, `UpdateProjectTaskListPolicyRequest`, `UpdateTaskListUserPreferenceRequest` z `Contracts/Tasks/TaskListConfigurationContracts.cs` | Auth; odczyt i własne preferencje wymagają project R, zapis policy wymaga project M; update policy/preferencji używa `ExpectedVersion` | `data/projects/tasks/repositories/task_list_configuration_repository_impl.dart` istnieje, lecz nie jest Retrofitem i importuje `package:ready_next`; wymaga migracji source/import graph. |
| Assignees/checklist/watchers/criteria/labels/custom fields: `PUT /{taskId}/assignees|labels|custom-fields`; CRUD checklist, acceptance criteria, labels and field definitions; `GET|POST|DELETE /watchers/me`; `GET /attachments`; bulk ticket/complete attachment endpoints | `ProjectTaskEndpoints.cs`; types in `Task*Contracts.cs`, `StorageContracts.cs` | Auth + task/project R/W; definitions require project management where handler states it | `data/projects/tasks/api/task_operations_api.dart` (attachment list/tickets too) |
| Recurrence/templates/workflow/views: `POST|GET|PUT|DELETE /{taskId}/recurrence`, pause/resume/run-now, project recurrence/runs, `PUT /{taskId}/preference`; `GET|POST|PUT|DELETE /task-templates`, apply/default; `GET|PUT /task-workflow`; CRUD `/task-views` | `ProjectTaskEndpoints.cs`; recurrence/template/workflow/saved-view/preference DTO | Auth + project/task ACL; task preference, saved view i default template są stanem własnego użytkownika | `task_advanced_api.dart`, `task_operations_api.dart`, `task_templates_api.dart`, `task_views_api.dart` |
| `GET /api/v1/me/tasks`; `GET /api/v1/tasks/search`; `GET /task-timeline` | `ProjectTaskEndpoints.cs`; `MyTasksQuery`, `GlobalTaskSearchQuery`, timeline query → pages/timeline | Auth + `sub`; accessible projects only | `task_views_api.dart`, `task_advanced_api.dart` |
| Time, capacity, schedule, workload: CRUD `/tasks/{taskId}/time-entries` plus timer/submit/approve/reject; `GET|PUT /capacity`; CRUD `/capacity-overrides`; `GET /workload`; cascade and holidays under `/schedule` | `TaskTimeTrackingEndpoints.cs`, `TaskCapacityEndpoints.cs`, `TaskWorkloadEndpoints.cs`, `ProjectScheduleEndpoints.cs`; matching TaskTime/Capacity/Schedule DTO | Auth + task/project/workspace ACL; approval/manage as service requires | `task_time_tracking_api.dart`, `task_capacity_api.dart`, `task_schedule_api.dart` |
| `GET /kanban`, `/settings`, `/columns/{status}`, `/columns/custom/{id}`; `PATCH /settings`, `/bulk-move`, `/bulk-update`; `PATCH /tasks/{taskId}/move-kanban` | `Endpoints/Kanban/KanbanEndpoints.cs`; `Kanban*Request` → board/column/settings/move responses | Auth + project R; settings M; cards task W | `data/kanban/api/kanban_api.dart` |
| `GET|PUT /kanban/preferences` | `KanbanUserPreferenceEndpoints.cs`; `UpdateUserKanbanPreferenceRequest` → own `UserKanbanPreferenceResponse` | Auth + project R; own preference | `kanban_api.dart` |

## Storage

| Route i metoda | BE / request → response | UserId i ACL | FE |
|---|---|---|---|
| Upload: `POST /api/v1/storage/upload-ticket`, `/bulk-upload-tickets`, `/files/create`, `/complete-upload/{fileId}`, `/bulk-complete-upload`; `POST /quill/clean-unused-images` | `Endpoints/Storage/StorageEndpoints.cs`; `StorageUploadTicket*`, `CreateStorageDocumentRequest`, `Complete*`, Quill DTO | Auth + storage scope/ACL | `data/storage/api/storage_api.dart` |
| Files: `GET /files`, `/files/search/semantic`, `/{fileId}`, `/{fileId}/deep-link`, `/{fileId}/download-ticket`, `/stream`, version stream/ticket/list/restore; `PUT /favorite|description`; `POST /analysis/retry`, `/restore`, `/bulk-download-zip`, `/convert-to-pdf`; `DELETE /{fileId}` | `StorageEndpoints.cs`; `StorageListQuery`, file/version/download/analysis/zip DTO | Auth + file read/write/delete ACL; version/concurrency where request has version | `storage_api.dart` |
| Shares/folders/placements: file share CRUD; folder CRUD, children, placements, bulk placements, folder shares; file placement create/delete; attach existing file to project | `StorageEndpoints.cs`; `StorageFileShareResponse`, `StorageFolder*`, placement DTO | Auth + file/folder/project ACL | `storage_api.dart` |
| Office/avatar/public: `GET /files/{id}/office-session`, `POST /avatar/upload-ticket`; public share ticket/file routes; `POST /office-callback` | `StorageEndpoints.cs`; OnlyOffice/upload/public-share DTO | office callback is integration route; public share uses token; others Auth + ACL | `storage_api.dart` (callback client should not be used by Flutter) |
| AI reports/audit: workspace audit/usage and project report types/audit/create/retry/schedules/runs/deliveries | `StorageEndpoints.cs`; `Contracts/AI/*.cs` | Auth + workspace/project ACL; provider availability is server state | `storage_api.dart` |
| Storage orphan/scan admin routes both under `/api/v1/storage/admin/...` and `/api/v1/admin/ops/storage/...` | `StorageEndpoints.cs`, `AdminOpsEndpoints.cs`; storage admin DTO | Auth + SuperAdmin in service | `storage_api.dart`, `data/admin/api/admin_api.dart` |

## Chat, Notifications, Wiki, Whiteboard, Corkboard, OKR

| Obszar i route families | BE / request → response | UserId i ACL | FE |
|---|---|---|---|
| Chat conversations: `GET /api/v1/chat/conversations|archived|{id}`, resolve, update/archive/restore/leave, placements, members, status/preferences, search/facets, mention/context/link preview/snippet | `Endpoints/Chat/ChatEndpoints.cs`; `Contracts/Chat/ChatContracts.cs`, search and preference DTO | Auth + conversation/resource scope ACL; actor = `sub` | `data/chat/api/chat_api.dart` |
| Chat messages: list/thread/revisions; attachment sessions/snippet attachment; send/edit/delete/forward; mute/thread mute; pins/bookmarks; attachment CRUD; delivery/reactions/read; draft CRUD | `ChatEndpoints.cs`; Chat message/draft/reaction/attachment DTO | Auth + conversation ACL; own-message/member constraints in service | `chat_api.dart` |
| Notifications: list/unread/groups/digest/preferences; group read/archive; item quick-action/read/read-all/pin/archive/reply; `POST /api/v1/admin/notifications` | `Endpoints/Notifications/NotificationEndpoints.cs`; notification/group/preference/action DTO | Auth + own inbox; reply rechecks chat ACL; admin creation SuperAdmin | `data/notifications/api/notifications_api.dart` |
| Wiki: workspace/project tree and page create; page read/update/move/archive, revisions/diff/restore, verify, selection→task, task links, AI summarize/action-items; page ACL grants | `Endpoints/Wiki/WikiEndpoints.cs`, `Endpoints/AccessControl/WikiPageAccessEndpoints.cs`; Wiki/request/grant DTO | Auth + workspace/project R/W; verify requires project M or workspace Admin; page grant service ACL | `data/wiki/api/wiki_api.dart`, `data/access_control/api/access_control_api.dart` |
| Whiteboard: project board CRUD/templates/duplicate; board snapshot/events/pages/objects/operations/export; sticky→task; AI cluster/flow; board ACL grants | `Endpoints/Whiteboard/WhiteboardEndpoints.cs`, `WhiteboardAiEndpoints.cs`, `AccessControl/WhiteboardAccessEndpoints.cs`; Whiteboard/AI/export/grant DTO | Auth + project R/W and resource ACL R/W; idempotency required for documented creates | `data/whiteboard/api/whiteboard_api.dart`, `access_control_api.dart` |
| Corkboard: `GET|POST sections`, `GET|POST cards`, attach file; AI cluster/summarize-to-wiki/card→task/card chat | `Endpoints/Corkboard/CorkboardEndpoints.cs`, `CorkboardAiEndpoints.cs`; Corkboard DTO | Auth + project R/W | `data/corkboard/api/corkboard_api.dart` |
| OKR: list/create/get/update/delete objectives and create/update/delete key results | `Endpoints/Okr/OkrEndpoints.cs`; `Contracts/Okr/OkrContracts.cs` | Auth + workspace ACL enforced by Okr service | `data/okr/api/okr_api.dart` |
| Ops: dashboard/realtime/workers/integrations/errors/dead-letter/storage maintenance | `Endpoints/Admin/AdminOpsEndpoints.cs`; `Contracts/Admin/AdminOpsContracts.cs` | Auth + SuperAdmin in `Application/Ops/AdminOpsService.cs` | `data/admin/api/admin_api.dart` |

## Realtime — potwierdzony kontrakt hubów

| Hub | Metody serwera i kontrola dostępu | Aktualny klient Flutter | Stan |
|---|---|---|---|
| `/api/v1/realtime/tasks` | `Infrastructure/Tasks/TaskEventsHub.cs`: `SubscribeProject(workspaceId, projectId)`, `UnsubscribeProject(projectId)`, `GetProjectEvents(workspaceId, projectId, cursor?, limit<=100)`; `sub` → Guid, project read ACL | `data/realtime/scoped/workspace_scoped_realtime_service.dart`, `task_project_realtime_adapter.dart` | **NIEZGODNY**: adapter oczekuje `actorCoreUserId`, `coreUserId`, importuje `package:ready_next`; backend emituje `ActorUserId`, `UserId` (`Contracts/Tasks/TaskRealtimeEventResponse.cs`). |
| `/api/v1/realtime/chat` | `Infrastructure/Chat/ChatEventsHub.cs`: subscribe/unsubscribe conversation, typing, presence heartbeat, replay | `data/realtime/chat/workspace_chat_realtime_service.dart` | klient istnieje, lecz importuje `ready_next`; wymaga testu BFF/desktop transportu |
| `/api/v1/realtime/notifications` | `Infrastructure/Notifications/NotificationsHub.cs`: automatyczny user group w `OnConnectedAsync`, `sub` jako Guid; REST wykonuje resync | `data/realtime/notifications/workspace_notifications_realtime_service.dart` | klient istnieje, lecz importuje `ready_next` i source models nadal mają `coreUserId` |
| `/api/v1/realtime/whiteboard` | `Infrastructure/Whiteboard/WhiteboardEventsHub.cs`: join/subscribe/leave, cursor, append/apply one/batch operation, replay; board/project/resource ACL | ogólny `workspace_scoped_realtime_service.dart` | klient transportowy istnieje; brak osobnego typed ownera whiteboard w znalezionych plikach |
| `/api/v1/realtime/wiki` | `Infrastructure/Wiki/WikiEventsHub.cs`: join/leave page, selection, replay; page ACL | ogólny `workspace_scoped_realtime_service.dart` | klient transportowy istnieje; brak osobnego typed ownera Wiki w znalezionych plikach |

## Potwierdzone rozbieżności Front ↔ Backend

1. `Front/pubspec.yaml` deklaruje pakiet `devplanner`, lecz bieżące źródła
   Workspaces importują `package:ready_next/...`. Przykłady krytyczne:
   `lib/workspaces/data/realtime/{scoped,chat,tasks}/...` oraz widoki. To są
   błędy kompilacji/importu, nie błąd backendowych tras.
2. `Front/lib/workspaces/data/auth/api/auth_api.dart` wywołuje usunięte
   `GET /api/v1/auth/me`. Kanoniczne API jest `GET /api/v1/me`; aktualny,
   właściwy adapter to `lib/me/data/me_api_adapter.dart`.
3. Przywrócone źródła Fluttera nadal mają `coreUserId`/`actorCoreUserId` i
   `Core` w całym pionie Workspaces (m.in. modele Tasks, member pickery,
   Storage sharing, Notifications, Chat i realtime). Backend publikuje
   `UserId`/`ActorUserId` jako `Guid`. Nie wolno rozwiązać tego aliasem JSON
   ani fallbackiem — należy zmigrować source DTO, domain model i call-site, a
   następnie ponownie wygenerować `*.g.dart`/`*.freezed.dart`.
4. `WorkspaceSignalRClient` przyjmuje `accessTokenFactory`. To pasuje do
   desktopowego access tokenu w pamięci. Backend obsługuje jednak BFF cookie na
   chronionych hubach, a dla browserowego handshake Chat/Notifications egzekwuje
   dozwolony `Origin`; nie jest to kontrakt bearer-only. Aktualny
   `DevPlannerStandaloneRuntime` celowo nie tworzy klienta SignalR dla BFF,
   ponieważ nie ma cookie/CSRF transportu huba. Brak dotyczy więc adaptera FE,
   nie trasy backendu; nie rozszerzać go w UI.
5. Backendowy SuperAdmin jest obecnie sprawdzany przez legacy-looking kod
   permission `bswfms.custom_modules.RNext-admin`, mimo lokalnego `UserId`.
   Front nie może sam interpretować tego stringa ani nim sterować; owner
   backend identity musi podjąć osobną, testowaną decyzję przed UI Ops.
6. Front posiada REST klientów dla praktycznie wszystkich zmapowanych domen,
   ale ich istnienie nie jest równoznaczne z działającą kompozycją. Dla MFA,
   recovery i admin recovery-email nie znaleziono klienta; dla realtime
   Whiteboard/Wiki znaleziono jedynie wspólny transport, nie typed composition.
7. `lib/workspaces/data/storage/api/storage_api.dart` nadal publikuje metodę
   `officeCallback()` dla `POST /api/v1/storage/office-callback`. To endpoint
   integracyjny OnlyOffice, nie kontrakt Fluttera (nie jest zwykłym żądaniem
   Auth/BFF ani bearer). Nie znaleziono call-site'u, ale klient trzeba usunąć
   lub wydzielić przed podłączeniem Storage do runtime.

## Kolejność repair: generator i adaptery

1. **Zamrozić kontrakt:** nie zmieniać tras C# ani DTO dla ratowania analyzera.
   Na początku agent porównuje route z tą mapą i aktualnym endpointem C#.
2. **Identity + import graph:** usunąć w source `package:ready_next` i nazwy
   `*CoreUserId`/`*ReadyUserId`, wprowadzić wyłącznie `userId` zgodny z C#.
   Własność: jeden agent dla wspólnych modelów/auth/realtime; nie równoleglić
   generatora z przenoszeniem tych plików.
3. **Źródłowe DTO/payloady/adapters:** najpierw edytować niegenerowane
   `*.dart` dla jednej gałęzi (tasks+kanban, potem storage, chat/notifications,
   wiki/whiteboard/corkboard/okr), następnie mappery repository i call-site.
   Każdy endpoint mutujący zachowuje `ExpectedVersion`/Idempotency-Key tam,
   gdzie wymaga tego C#.
4. **Generator tylko po naprawie źródeł:** `dart run build_runner build
   --delete-conflicting-outputs`, potem review diffu artefaktów. Nie edytować
   ręcznie `*.g.dart` ani `*.freezed.dart`.
5. **Realtime adaptery po REST:** mapować dokładne eventy C# (`ActorUserId`,
   `UserId`, cursor base64 dla tasks) i uruchamiać reconnect/replay/dedupe
   tests. Nie tworzyć połączeń SignalR w widgetach.
6. **Composition/router:** dopiero gdy adapter dla pionu przejdzie testy,
   podłączyć go do aktualnej trasy i Gmailowego shellu. UI ma renderować
   permission/capabilities zwrócone przez domenę; 403 pozostaje porażką.
7. **Dowód:** targeted contract/mapping tests → `build_runner` → `flutter
   analyze` → smoke z lokalnym backendem dla create/read/update i 403/409.
   Wynik bez realnego backendu oznaczać `NOT RUN`, nie `PASS`.

## Minimalne dowody dla review agentów

* C#: `Backend/Endpoints/...` oraz `Backend/Contracts/...` przy każdej
  zmienianej trasie; dla dostępu także odpowiedni `Application/*Access*.cs`.
* Front: niegenerowany Retrofit client/adaptor, domain port/repository,
  mapper DTO, Cubit i widget używający wyniku. Nie akceptować samego ekranu
  z mockiem lub pustą listą.
* Realtime: nazwa huba, invoke, payload eventu i strategia reconnect/replay
  muszą mieć test mapowania do aktualnego kontraktu C#.
* W raporcie R2/R3 wpisać dokładne aktualizowane ścieżki, komendy i faktyczny
  wynik. Niniejszy dokument nie zastępuje `feature-parity.md` ani raportu
  pakietu.
