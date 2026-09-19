# Handoff fragment — 4F frontend auth `UserId`

- Auth core używa lokalnego UUID `userId`; `coreUserId`, `readyUserId`,
  `username` i `token` nie są już polami/aliasami modeli tego slice’a.
- `CurrentUserResponse` mapuje `/api/v1/me` i ma kanoniczne `userId`; BFF oraz
  desktop PKCE pozostają istniejącymi seamami kompozycji.
- Bezpośrednie call-site’y korzystają z `AuthUser.userId`; niezależne DTO
  Storage/AccessControl/Projects/Kanban/tasks pozostają poza zakresem.
- Review usunął ostatni bezpośredni odczyt `AuthUser.coreUserId` w pickerze
  zadań, bez migracji niezależnego DTO `ProjectMemberProfile`.
- Targeted suite: `test/core/auth` **48/48 PASS**, `test/auth` **16/16 PASS**,
  `test/app/router` **9/9 PASS** (łącznie **73/73 PASS**).
- Regresyjny test chat-thread po aktualizacji fake repozytorium: **4/4 PASS**.
- `flutter analyze`: **PASS**, `git diff --check`: **PASS**.
- Następny krok: osobne pakiety domenowe migrujące ich własne DTO do `UserId`,
  bez przywracania aliasów lub dual parsing.
