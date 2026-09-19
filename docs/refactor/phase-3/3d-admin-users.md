# Faza 3D — frontend administracji użytkownikami

**Status: COMPLETE — fundament prezentacji i portów (2026-09-16).**

Ten pakiet zastępuje trasę `/admin` placeholderem opartym o nową gałąź
`lib/admin`. Nie implementuje adaptera HTTP ani nie zakłada ścieżek OpenAPI;
backend fazy 3A dostarcza implementację `AdminUserGateway` dopiero po
zatwierdzeniu kontraktu.

## Wykonane

- Utworzono drzewo `admin/domain`, `admin/data` i `admin/presentation`.
- Dodano lokalne modele `AdminUser`, `AdminUserQuery`, page/cursor oraz
  komendy create/update/roles/lifecycle. Publiczny identyfikator to `userId`.
- `AdminUserCreateCommand` nie przyjmuje ról: zgodnie z 3A utworzenie konta
  nadaje wyłącznie domyślną rolę `User`; zmiana ról jest osobną operacją.
- Dodano typowany port domenowy `AdminUserGateway`; nie importuje Dio, klienta
  OIDC, SignalR ani secure storage i nie zawiera URL-i endpointów.
- Dodano jawny `AdminUsersComposition` z gatewayem, `currentUserId` i
  permission affordances. Permission flags sterują UX, ale nie zastępują
  autoryzacji serwera.
- Dodano małe Cubity: `AdminUsersCubit`, `AdminUserFormCubit`,
  `AdminUserRolesCubit` i `AdminUserLifecycleCubit`. Żaden nie zna
  `BuildContext`, nawigacji, widgetów ani transportu.
- Dodano stronę listy z wyszukiwaniem kursorowym, tworzeniem/edycją, rolami
  oraz akcjami dezaktywacji i reaktywacji. Zakres odpowiada aktualnemu
  kontraktowi 3A; reset hasła i unieważnianie sesji pozostają poza tym
  pakietem.
- Dodano ochronę UX przed nadaniem sobie roli administratora oraz ukryto
  akcje mutujące dla konta bieżącego tam, gdzie groziłoby to samozablokowaniem.
  Ostateczne reguły privilege/IDOR/MFA pozostają obowiązkiem backendu.
- `/admin` w `DevPlannerRouter` przyjmuje opcjonalne, jawne composition.
  Bez composition ekran pokazuje fail-closed komunikat i nie udaje pustych
  danych. Bez `users.read` pokazuje access denied; nie renderuje kont ani
  kontrolek.
- Dodano lokalizacje PL/EN dla całego ekranu administracji.

## Walidacja

- `flutter gen-l10n` — PASS.
- `flutter test test/admin/admin_users_test.dart` — PASS, 5 testów.
- Testy obejmują odczyt przez typed gateway, walidację formularza, blokadę
  self-escalation oraz fail-closed/access-denied widget states.
- `flutter analyze` — PASS, zero issues.

## Następny krok

Po zatwierdzeniu OpenAPI 3A dodać wyłącznie adapter infrastruktury do
`AdminUserGateway` oraz jawne `AdminUsersComposition` w bootstrapie aplikacji.
Nie zmieniać kontraktu prezentacji na bezpośrednie wywołania HTTP i nie
przywracać starego `workspaces/data/admin` (to niezależny, legacy Ops).

## Integracja 3D po przeglądzie (2026-09-17)

Trasa `/admin` wymaga teraz uwierzytelnionej sesji standalone BFF/cookie oraz
ładuje lokalny `UserProfile` przez `/api/v1/me` przed utworzeniem
`AdminUsersComposition`. `userId` i permissions nie są brane z launch contextu,
parametru `currentUserId`, lokalnego cache ani niezweryfikowanych claims.
Nieudane lub niedostępne `/me` kończy się stanem fail-closed; jawna composition
pozostaje zachowana dla testów i kontrolowanej kompozycji.

Produkcja nadal czeka na dokładnie jeden seam: bootstrap musi dostarczyć
`AuthComposition` z działającym `WebBffAuthPort` oraz cookie/CSRF transportem.
Nie wolno udawać tego seam bearerem ani fikcyjnymi permissions.
