# 6F/6G — typed REST adapters Chat i Notifications

**Status:** COMPLETE w zakresie frontendowej warstwy data i bezpiecznego
transport seam (2026-09-17).

Pakiet domyka wire-level kontrakt istniejących globalnych drawerów i runtime'u
6F/6G. Nie zmienia paneli, routingu ani portów presentation. Retrofit pozostaje
jedynym klientem REST, a `DevPlannerHttpTransport` jest jedynym transportem
sesyjnym przekazywanym do `ChatApi` i `NotificationsApi`.

## Kontrakt adapterów

- DTO-y Chat i Notifications oraz odpowiadające im domeny i cubity używają
  kanonicznych lokalnych nazw `userId`, `authorUserId`, `recipientUserId`,
  `attachedByUserId`, `createdByUserId`, `pinnedByUserId` oraz `userIds`.
  Nie ma deprecated aliasów ani publicznych właściwości `CoreUserId`; wire
  format i nazwy Dart są spójne z aktualnym kontraktem.
- Enumy transportowe mają wartości zgodne z `System.Text.Json` backendu
  (`Direct`, `Workspace`, `Chat`, `MarkRead`, `MentionsOnly` itd.), więc
  odpowiedzi REST oraz payloady mutacji są dekodowane/emitowane bez
  heurystycznego mapowania.
- Cursor pagination, attachment session/message attachments, optimistic
  version oraz idempotency `clientMessageId` pozostają typowane i są
  przekazywane przez istniejące repository ports.
- Ścieżki Retrofit odpowiadają kanonicznym endpointom `/api/v1/chat/**` oraz
  `/api/v1/notifications/**`; nie dodano aliasów Ready/Core/DataBus.

## Bezpieczeństwo i composition

- Web korzysta z cookie BFF, `withCredentials` i CSRF z `DevPlannerHttpTransport`;
  interceptor usuwa każdy ręcznie dostarczony bearer. Web nie tworzy klienta
  SignalR ani providera tokenu.
- Desktop dostaje REST oraz realtime wyłącznie z sesyjnego providera
  PKCE/vault. Brak źródła poświadczenia zwraca `null` composition i utrzymuje
  jawny ekran unavailable; nie ma anonimowych żądań udających sukces.
- Widgety i Cubity nie znają Dio, tokenów, secure storage ani Hive. Żaden
  token nie trafia do widgetów, Hive, localStorage ani launch contextu.
- Realtime pozostaje domenowym serwisem właścicielowanym przez runtime/shell:
  Web jest REST-only, desktop używa istniejącego SignalR z replay/dedupe.
  Nie dodano pollingu ani fallbacku cache.

## Zmienione artefakty

- `lib/workspaces/data/shared/enums/chat_enums.dart`
- `lib/workspaces/data/shared/enums/notification_enums.dart`
- `lib/workspaces/data/chat/models/chat_models.dart` i pliki wygenerowane
- `lib/workspaces/data/notifications/models/notification_models.dart` i pliki wygenerowane
- `test/workspaces/data/standalone/chat_notifications_api_contract_test.dart`

Runtime composition i transport były już właścicielem składania API przed tym
pakietem; nie zmieniano globalnego drawera/shellu ani backendu.

## Walidacja

- `dart run build_runner build --delete-conflicting-outputs` — PASS (generator
  ukończył pracę; toolchain zgłosił tylko istniejące ostrzeżenie o constraint
  `json_annotation`).
- `dart format` dla zmienionych źródeł i testu — PASS.
- `flutter test test/workspaces/data/standalone/chat_notifications_api_contract_test.dart` — 4/4 PASS.
- `flutter test test/workspaces/data/chat/chat_repository_impl_test.dart test/workspaces/data/notifications/notification_settings_repositories_test.dart test/workspaces/data/standalone/devplanner_standalone_runtime_test.dart` — 19/19 PASS.
- `git diff --check` — PASS.

## Otwarte braki

- Brak E2E z uruchomionym backendem, Web BFF cookie/CSRF i realnym lokalnym
  Identity; nie deklarujemy tego jako zweryfikowane.
- Brak platformowych E2E Windows/macOS/Linux dla system-browser PKCE,
  secure vault i SignalR reconnect/revoke.
- Webowy SignalR/BFF adapter nadal nie jest bezpiecznie zatwierdzony, więc
  realtime Notifications/Chat na Web pozostaje wyłączony zgodnie z fail-closed
  kontraktem.
