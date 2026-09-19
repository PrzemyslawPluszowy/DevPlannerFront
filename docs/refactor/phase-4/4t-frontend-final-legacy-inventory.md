# Faza 4T — Front standalone completion inventory (read-only)

**Audyt:** 2026-09-17, bieżący worktree Front. Dokument jest samodzielnym
inwentarzem; nie zmienia wspólnego planu ani handoffu.

## Werdykt

Aktywny kod produkcyjny Front nie zawiera już nazw `CoreUserId`, `coreUserId`,
`ReadyUserId`, `readyUserId`, `createdByCoreUserId`, `actorCoreUserId` ani
`authorCoreUserId`. Aktywne DTO i mapery używają odpowiednio `userId`,
`createdByUserId`, `actorUserId`, `authorUserId`, `grantedByUserId`,
`assigneeUserIds` i `editedByUserId`. Wygenerowane Freezed/JSON/Retrofit są
spójne z tym źródłem.

Nie ma aktywnego endpointu, originu ani klucza konfiguracji Ready/Core/DataBus.
Jedynym funkcjonalnym residualem jest testowy envelope Chat realtime z kluczem
`authorCoreUserId`; ponieważ mapper deserializuje już `authorUserId`, ten
fixture jest niespójny z obecnym kontraktem i wymaga migracji.

## Runtime: osiągalne kontra nieosiągalne

| Powierzchnia | Stan w aktualnym grafie startowym | Kontrakt/ścieżki |
|---|---|---|
| `lib/main.dart` → `lib/bootstrap/app_bootstrap.dart` → `DevPlannerApp` | aktywny punkt startu; domyślnie bez runtime/auth/transportu | brak połączenia z backendem w świeżym starcie; używana jest `AuthComposition.unavailable()` |
| Auth | aktywny seam, osiągalny po wstrzyknięciu hostowej kompozycji | BFF: `/bff/session`, `/bff/auth/start`, `/bff/auth/logout`, `/api/v1/me`; desktop PKCE jest portem hosta bez hardkodowanych endpointów |
| `/me` | aktywna trasa; realne HTTP dopiero z wstrzykniętym transportem | `/api/v1/me`, `/api/v1/auth/change-password`, `/api/v1/me/sessions[/{sessionId}]`, `/api/v1/me/avatar` |
| `/admin` | aktywna trasa, fail-closed; osiągalna wyłącznie z web BFF + zweryfikowanym `/me` | `/api/v1/admin/users[/{userId}]`, `/roles`, `/deactivate`, `/reactivate` |
| `/chat`, `/notifications` oraz przyciski globalnego shellu | aktywne po dostarczeniu `DevPlannerStandaloneRuntime` i sesji; domyślnie unavailable | Chat `/api/v1/chat/...`; Notifications `/api/v1/notifications/...`; desktop realtime `/api/v1/realtime/chat` i `/api/v1/realtime/notifications` |
| `/workspaces` | osiągalna trasa, ale obecnie tylko landing/placeholder bez wywołań API | brak runtime requestu |
| nested Workspaces/Projects/Tasks/Files/Wiki/Whiteboard oraz `/storage` | trasy technicznie osiągalne, renderują placeholdery; właściwe feature UI nie jest podłączone do routera | wszystkie repozytoria/adapters tych domen są nieosiągalne z `main.dart` |
| `lib/workspaces/data/access_control`, automatyzacje, Workspace feature API, Tasks/Chat realtime adapters | kod kompilowany/testowany jako biblioteka, lecz nieosiągalny z obecnych tras | wymaga osobnych seamów/composition root przed uznaniem za runtime active |
| `lib/features/settings/**` oraz pozostałe historyczne feature drzewa pozostające poza routerem | dormant/unreachable; nie są częścią standalone start graph | nie usuwać w tym pakiecie bez osobnego ownera i testów |

## Znaleziska i klasyfikacja

### Must migrate — jeden mały pakiet funkcjonalny

- `test/workspaces/support/chat_realtime_test_support.dart:73` — fixture
  `ChatRealtimeTestPayload.message()` wysyła `authorCoreUserId` zamiast
  `authorUserId`.
- `test/workspaces/support/chat_realtime_test_support.dart:106` — ten sam
  klucz w JSON replay `payloadJson`.

To jest residual aktywnej infrastruktury testów realtime, nie dokumentacja ani
negatywna asercja. Zmiana powinna być rename-only do `authorUserId`, bez
fallbacku i bez dual-read/write. Zakres obejmuje tylko support oraz testy, które
go używają (`workspace_chat_realtime_typed_events_test.dart`,
`chat_conversation_realtime_test.dart` i powiązane testy cubitów).

### Historical / negative contract tests — zachować

Poniższe wystąpienia są celowymi asercjami, że legacy klucze nie są emitowane;
nie są call-site'ami do migracji:

- `test/workspaces/data/standalone/identity_dto_userid_contract_test.dart:24,50-51`
  — `coreUserId`, `actorCoreUserId`, `authorCoreUserId` w `isNot(contains(...))`.
- `test/workspaces/data/standalone/chat_notifications_api_contract_test.dart:48`
  — negatywna asercja `authorCoreUserId`.
- `test/workspaces/data/standalone/projects_workspace_userid_contract_test.dart:57-61`
  — negatywne asercje `createdByCoreUserId`, `coreUserId`, `readyUserId`.
- `test/workspaces/data/workspaces/workspace_members_directory_contract_test.dart:19-20,39-40,63,65`
  — negatywne asercje `coreUserId`/`readyUserId`.

Historyczne dokumenty i plany poza aktywnym kodem (`workspace-implementation.md`,
`workspace-implementation-plan.md`, `docs/**`, `reports/**`, `.thunder-client/**`)
pozostają materiałem referencyjnym. Nie stanowią runtime kontraktu i nie powinny
być czyszczone w pakiecie 4T.

### Non-legacy technical matches — nie migrować

- `Ready` w nazwach stanów Cubitów (`*Ready`), enumie storage `@JsonValue('Ready')`,
  statusie uploadu `Clean+Ready` i callbacku OnlyOffice `ready` jest terminem
  technicznym/statusowym, nie usługą Ready.
- `core22` w `snap/snapcraft.yaml` i `lib/core/**` jako ścieżka technicznego
  modułu forwarding/error/theme nie oznacza zależności od Veloryn Core.
- Komentarze źródłowe z historycznym określeniem katalogu Core/Ready:
  `lib/workspaces/data/notifications/api/notifications_api.dart:104`,
  `lib/workspaces/data/notifications/models/notification_models.dart:40,250`,
  `lib/workspaces/data/projects/tasks/models/task_models.dart:676`,
  `lib/workspaces/data/projects/responses/project_member_response.dart:7` i
  `project_member_profile_response.dart:10`. Nie są odczytywane w runtime;
  można je poprawić przy okazji właściwego pakietu wording cleanup, ale nie
  należy traktować ich jako identity transport residuals.

### Generated / derived — zweryfikowane, bez zmian

Skan `lib/**` obejmujący źródła i `.g.dart`/`.freezed.dart` nie znalazł żadnej
z sześciu nazw legacy. Nie regenerować artefaktów w tym audycie; po ewentualnej
zmianie źródła fixture nie ma potrzeby uruchamiać generatora.

## Niepokrywające się pakiety implementacyjne

1. **4T-A — Chat realtime fixture contract (jedyny bezpośredni residual).**
   Zmienić dwa klucze w `test/workspaces/support/chat_realtime_test_support.dart`
   na `authorUserId`; sprawdzić mapper, replay, deduplikację i integrację Cubita.
   Target: `flutter test test/workspaces/data/realtime/chat_realtime_event_mapper_test.dart`,
   `workspace_chat_realtime_typed_events_test.dart`,
   `test/workspaces/presentation/chat/chat_conversation_realtime_test.dart`.

2. **4T-B — feature-actor/access DTO seam.** Przyszły pakiet dla
   niepodłączonych do routera kontraktów `workspace_feature_models.dart`,
   `access_control_models.dart` oraz consumerów ACL/dashboard/activity/search.
   Kanoniczne nazwy pozostają `actorUserId`, `authorUserId`, `userId`,
   `grantedByUserId`; nie dodawać aliasów. Target: istniejący
   `identity_dto_userid_contract_test.dart`, `projects_workspace_userid_contract_test.dart`
   oraz kontraktowe testy Access/feature po podłączeniu seamów.

3. **4T-C — automation identity seam.** Osobno objąć
   `automation_models.dart`, `automation_repository_impl.dart`, UI ustawień i
   serializację warunków/akcji; `AutomationCondition.userId` i
   `AutomationAction.userId` są już kanoniczne, więc pakiet ma dowieść kompletności
   kontraktu i brak legacy w trigger payloadach. Target:
   `test/workspaces/data/workspaces/automation_models_contract_test.dart` oraz
   `test/workspaces/presentation/tasks/settings/automation_settings_cubit_test.dart`.

4. **4T-D — Tasks/Chat/Notifications realtime runtime seam.** Osobno podłączyć
   obecne adaptery realtime do właściwych workspace routes/composition root;
   obejmuje `actorUserId`, obecność `userId`, `authorUserId`, replay i revoke.
   Nie mieszać tego z rename fixture 4T-A. Target: suite
   `test/workspaces/data/realtime/` oraz `test/workspaces/presentation/chat/*realtime*`.

5. **4T-E — standalone route activation.** Osobny pakiet runtime/UI dla
   placeholderów `/workspaces/**`, `/storage` i zasobów feature. Dopiero po
   podłączeniu tras można oznaczyć ich API/adapters jako runtime active; obecnie
   pozostają unreachable z grafu startowego. Target: router/shell tests plus
   feature composition/integration tests per activated route.

## Granice tego audytu

Nie uruchamiano generatora, pełnej suite ani platform builds; audyt był
read-only poza utworzeniem tego dokumentu. Nie modyfikowano kodu, wspólnego
planu ani handoffu, nie tworzono migracji, nie commitowano i nie pushowano.
