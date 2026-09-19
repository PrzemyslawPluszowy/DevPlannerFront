# Handoff fragment — 6F/6G API adapters

- **Status:** COMPLETE dla typed REST wire contractu Chat/Notifications.
- **Porty:** bez zmian; globalne drawery korzystają z dotychczasowych
  `ChatRepository` i `NotificationsRepository`.
- **Transport:** `DevPlannerStandaloneRuntime` składa oba klienty Retrofit z
  jednego `DevPlannerHttpTransport`. Web = cookie/CSRF REST bez Bearera i bez
  realtime; Desktop = REST/realtime tylko przy PKCE/vault credential source.
- **Kontrakt:** publiczne DTO-y, domeny i cubity używają kanonicznych lokalnych
  nazw `userId`/`authorUserId`/`recipientUserId` oraz PascalCase enumów backendu;
  nie ma deprecated aliasów ani fallbacków spoza aktualnego Swagger/OpenAPI.
- **Testy:** kontrakt JSON 4/4 PASS; Chat/Notifications adapters oraz runtime
  19/19 PASS (23/23 łącznie); `git diff --check` PASS.
- **Następny krok:** po uruchomieniu backendu wykonać E2E BFF cookie/CSRF,
  desktop PKCE/vault i testy revoke/reconnect SignalR. Nie włączać Web
  realtime przez bearer ani token z launch contextu.
