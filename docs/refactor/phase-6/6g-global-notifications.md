# Faza 6G — globalne Notifications DevPlanner

**Status: COMPLETE dla panelu, routingu i bezpiecznego standalone runtime wiring (2026-09-17).**

Pakiet podłącza istniejącą skrzynkę powiadomień do standalone shellu przez
jawną kompozycję. Topbar otwiera rootowy side sheet bez zmiany bieżącej trasy,
a `/notifications` pozostaje kanonicznym ekranem pełnoekranowym i deep linkiem.

## Wykonane

- Dodano `DevPlannerGlobalNotificationsComposition` w
  `lib/workspaces/presentation/notifications/global_notifications_composition.dart`.
  Przekazuje wyłącznie `NotificationsRepository` oraz opcjonalny,
  sesyjny `WorkspaceNotificationsRealtimeService`.
- `DevPlannerRouter` przyjmuje opcjonalną kompozycję Notifications, przekazuje
  akcję do rootowego shella i renderuje rzeczywisty `GlobalNotificationsPage`.
  Bez kompozycji route pokazuje jawny ekran fail-closed, a nie pustą listę lub
  cache udający sukces.
- `AppGlobalNotificationsDrawer` używa root navigatora, zachowuje `topInset`
  64 px, ma barrier i zamknięcie route. Panel ma `FocusTraversalGroup`,
  semantyczny region trasy, Escape oraz jawny close button.
- Panel i pełna trasa korzystają z istniejącego `NotificationsCubit`,
  repository, filtrów, mutacji, reply/deep-linków i realtime. Nie dodano Dio,
  SignalR, auth ani secure storage do widgetów.
- Nie przywrócono żadnych tras Ready/Core/DataBus.
- `DevPlannerStandaloneRuntime` składa `NotificationsApi` oraz
  `NotificationsRepositoryImpl` z jednego `DevPlannerHttpTransport` i zwraca
  kompozycję tylko przy aktywnej sesji lokalnego `UserId`. Web korzysta z
  cookie BFF/CSRF przez transport, bez bearerów; desktop może dostać
  Notifications realtime tylko przez istniejący PKCE/vault token provider.
- `bootstrap()`/router przyjmują ten runtime opcjonalnie. Brak runtime,
  niesygnowana sesja albo brak bezpiecznych zależności pozostawia jawny ekran
  `DevPlannerNotificationsUnavailablePage`, a topbar nie udaje pustego inboxa.

## Granice wdrożeniowe

Domyślne wywołanie `bootstrap()` nadal nie składa tej kompozycji, dopóki
adapter sesji standalone nie ustawi autorytatywnego `AuthSessionController`.
Nie ma jeszcze bezpiecznego, zweryfikowanego webowego SignalR/BFF cookie
adaptera; dlatego Web ma REST Notifications, ale realtime pozostaje wyłączony.
Nie wolno zastępować tego bearerem w kodzie Web ani tokenem z launch contextu.
Hosty testowe mogą dostarczać lokalne repozytorium lub gotowy Cubit, lecz ten
tryb nie jest ścieżką produkcyjnego bootstrapu.

## Walidacja

- `flutter analyze` — PASS.
- Ukierunkowane testy Notifications, routera i shella — PASS.
- `git diff --check` — PASS.

## Następny krok

Po opublikowaniu backendowego kontraktu złożyć repository i realtime adapter w
bootstrapie aplikacji. Nie zmieniać composition portu ani rootowego overlayu;
zweryfikować dodatkowo Escape/focus na Web i desktop.
