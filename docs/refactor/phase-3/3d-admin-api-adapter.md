# Faza 3D — adapter API administracji użytkownikami

**Status: COMPLETE w zakresie adaptera infrastrukturalnego; produkcyjna
kompozycja pozostaje fail-closed (2026-09-16).**

## Zrealizowany zakres

- Dodano `AdminUserGatewayApiAdapter` w `lib/admin/data/adapters`. Jest on
  jedyną implementacją domenowego `AdminUserGateway` dla kontraktu backendu
  3A i przekazuje transport przez jawnie wstrzyknięty `AdminUserApiTransport`.
- Adapter używa wyłącznie potwierdzonych operacji 3A:
  `GET /api/v1/admin/users`, `POST /api/v1/admin/users`,
  `PATCH /api/v1/admin/users/{userId}`, `PUT .../roles`,
  `POST .../deactivate` oraz `POST .../reactivate`. Nie dodano get-detail,
  activation email, resetu hasła, revoke sessions ani innych operacji.
- Mapowane są pełne odpowiedzi `LocalAdminUserResponse` i
  `CursorPageResponse<LocalAdminUserResponse>`. `LocalUserRolesResponse` jest
  odzwierciedlony przez `AdminUserRolesResult(userId, roleCodes)`, a
  `LocalUserLifecycleResponse` przez `AdminUserLifecycleResult(user, changed)`.
  Poprzedni port zwracający `AdminUser` dla ról/lifecycle był niedokładny i
  został odpowiednio skorygowany wraz z cubitami oraz testami.
- `AdminUserQuery` obejmuje wszystkie opublikowane filtry listy: `cursor`,
  `search`, `status`, `emailConfirmed`, `roleCode`, `limit`. Status jest
  domenowym enumem, a adapter serializuje dokładne wartości API:
  `PendingActivation`, `Active`, `Locked`, `Deactivated`.
- Błąd `ApiErrorResponse` zachowuje typ HTTP, bezpieczny `message`, tekstowy
  `code` w `ApiError.apiCode` i `traceId`. Dodanie tych dwóch pól nie zmienia
  używanego wcześniej numerycznego `backendCode` legacy endpointów.

## Granica bezpieczeństwa i kompozycja

`AdminUserApiTransport` nie przyjmuje ani nie zwraca access/refresh tokenów.
Przyszła implementacja ma należeć do istniejącej granicy BFF/cookie, wysyłać
credentials oraz realizować CSRF dla mutacji. Adapter, domena i presentation
nie importują Dio, HTTP, OIDC, secure storage ani token store.

`AdminUsersComposition` nadal wymaga jawnego `gateway`, `currentUserId` i
permissions. `bootstrap()` nie rejestruje adaptera: obecny standalone root nie
ma jeszcze zweryfikowanego źródła sesji BFF ani wywołania `/me`, a
`HostLaunchContext` i `AuthUser` nie są takim źródłem. W konsekwencji `/admin`
pozostaje fail-closed (`AdminUsersUnavailablePage`). Produkcyjny seam należy
podłączyć dopiero po tym, gdy webowa sesja BFF/cookie i `MeGateway` zwrócą
zweryfikowane `UserProfile.userId` oraz `UserProfile.permissions`, a bezpieczny
transport BFF/CSRF będzie dostępny:

```dart
AdminUsersComposition(
  gateway: AdminUserGatewayApiAdapter(transport: authenticatedBffTransport),
  currentUserId: profileFromMe.userId,
  permissions: profileFromMe.permissions,
)
```

Nie wolno zastąpić tych danych tokenem, danymi z launch context ani lokalnym
cachem bez walidacji sesji.

## Przegląd integracji 3D (2026-09-17)

Ścieżka produkcyjna `/admin` pozostaje fail-closed do czasu podania przez hosta
zweryfikowanej sesji webowego BFF. Router nie tworzy już composition z
`HostLaunchContext`, `AuthUser` ani arbitralnego `currentUserId`. Wymaga
`AuthSessionStatus.signedIn` z klientem `webBff` oraz transportu cookie/CSRF;
desktopowy transport bearer nie może być użyty jako admin transport.

Po spełnieniu tych warunków router wykonuje `GET /api/v1/me` przez `MeGateway`.
`UserProfile.userId` i `UserProfile.permissions` są jedynym produkcyjnym źródłem
`AdminUsersComposition`; błąd lub niepełna odpowiedź `/me` daje
`AdminUsersUnavailablePage`, bez danych zastępczych. Jawna kompozycja nadal jest
dopuszczona wyłącznie jako kontrolowany seam testowy/hostowy.

Dokładny brakujący seam: standalone bootstrap nie dostarcza jeszcze instancji
`AuthComposition` z działającym `WebBffAuthPort` oraz
`DevPlannerHttpTransport(isWeb: true)` podłączonym do opublikowanego BFF.
Nie należy tego zastępować tokenem, launch contextem ani lokalnym cachem.

`DevPlannerHttpTransport` normalizuje JSON/error body, zachowuje `code`,
`message` i `traceId`, serializuje query/body, wysyła credentials oraz dodaje
CSRF do mutacji BFF. Adapter admina nie przyjmuje tokenów; desktopowy bearer
transport nie wystawia `asAdminTransport`.

## Walidacja

- `flutter test test/admin` — PASS, 9 testów.
- `test/admin/admin_user_gateway_api_adapter_test.dart` obejmuje mapowanie
  odpowiedzi, serializację requestów, typowane błędy bez sieci oraz jawną
  kompozycję.
- `flutter analyze` i `git diff --check` — uruchomione po zmianie; wynik jest
  zapisany w końcowym raporcie pakietu.

## Poza zakresem

Nie zmieniano Backend, lifecycle/recovery auth, Chat ani globalnego planu i
handoffu. Nie deklarowano zakończenia całej fazy 3; nadal wymagane są bezpieczny
transport BFF/desktop oraz publikacja zweryfikowanego current-user/permissions
w composition root.
