# Handoff fragment — 3D frontend admin users

- **Status:** COMPLETE dla typed frontend foundation; backend adapter i OpenAPI
  są poza zakresem tego pakietu.
- **Drzewo:** `lib/admin/domain` zawiera modele/port, `lib/admin/data`
  composition, a `lib/admin/presentation` stronę, formularze i cztery małe
  Cubity.
- **Router:** `/admin` przyjmuje `AdminUsersComposition?`; null daje
  `AdminUsersUnavailablePage`, a brak `users.read` daje access denied. Guard
  pozostaje istniejącym authenticated-app guardem; frontend nie deklaruje
  autoryzacji serwera.
- **Bezpieczeństwo UX:** komendy używają lokalnego `userId`, nie renderują
  mutacji bez `users.manage`, nie pozwalają UI nadać sobie
  `SystemAdmin`. Backend musi ponownie sprawdzić permission, MFA, IDOR i
  ochronę ostatniego administratora.
- **Transport:** brak URL-i, Dio, token storage i danych mockowanych w
  produkcji. `AdminUserGateway` jest jedynym portem dla przyszłego adaptera.
- **Operacje 3A:** list/create/update/set roles/deactivate/reactivate. Reset
  hasła i unieważnienie sesji nie są udawane na froncie, bo nie występują w
  obecnym kontrakcie 3A. Create nie przyjmuje ról i pozostawia domyślną rolę
  `User`; role zmienia wyłącznie osobny set-roles.
- **Dowody:** `flutter test test/admin/admin_users_test.dart` — 5/5 PASS;
  `flutter gen-l10n` PASS; `flutter analyze` PASS.
- **Kontynuacja:** po publikacji/udostępnieniu BFF podać do routera wyłącznie
  transport cookie/CSRF oraz `MeGateway`; composition ma powstać po
  autorytatywnym `UserProfile` z `/api/v1/me`, nie z `AuthUser` ani launch
  contextu.
- **Przegląd integracji 2026-09-17:** `/admin` składa się produkcyjnie tylko z
  authenticated web BFF/cookie transportu i profilu `GET /api/v1/me`. Router
  nie używa `currentUserId`, launch contextu ani claims `AuthUser` jako źródła
  uprawnień; desktopowy bearer nie jest admin transportem. Niepodłączony BFF
  oraz nieudane `/me` pozostają fail-closed. Jawny `AdminUsersComposition`
  zachowano dla testów.
