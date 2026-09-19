# Handoff fragment — 3D Admin API adapter

- **Adapter:** `AdminUserGatewayApiAdapter` mapuje kontrakt backendu 3A dla
  list/create/update/set roles/deactivate/reactivate. Nie implementuje resetu,
  revoke, activation e-mail ani nieudostępnionej w tym pakiecie operacji detail.
- **Kontrakty:** `LocalAdminUserResponse` → `AdminUser`; cursor →
  `AdminUserPage`; `LocalUserRolesResponse` → `AdminUserRolesResult`; lifecycle
  → `AdminUserLifecycleResult`, łącznie z `changed`.
- **Bezpieczeństwo:** transport jest portem BFF/cookie bez tokenów w Flutterze.
  Nie ma Dio/HTTP w `admin/domain` ani `admin/presentation`.
- **Composition seam:** nie podłączono `bootstrap()`, bo nie istnieje bezpieczne,
  zweryfikowane źródło sesji BFF oraz `/me`. `/admin` jest nadal fail-closed.
  Następny pakiet może złożyć adapter dopiero z autorytatywnym
  `UserProfile` z `/api/v1/me` oraz transportem realizującym cookies i CSRF.
- **Testy:** `flutter test test/admin` obejmuje mapping, request serialization,
  errors i kompozycję bez sieci. Uruchomić też `flutter analyze` oraz
  `git diff --check` po scaleniu z równoległymi zmianami.
- **Przegląd integracji 2026-09-17:** `/admin` składa się produkcyjnie tylko z
  authenticated web BFF/cookie transportu i profilu `GET /api/v1/me`. Router
  nie używa `currentUserId`, launch contextu ani claims `AuthUser` jako źródła
  uprawnień; desktopowy bearer nie jest admin transportem. Niepodłączony BFF
  oraz nieudane `/me` pozostają fail-closed. Jawny `AdminUsersComposition`
  zachowano dla testów.
