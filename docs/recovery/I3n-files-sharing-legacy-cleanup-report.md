# I3n — porządkowanie legacy sharing

## Decyzja

Audyt wykazał, że katalog `presentation/storage/sharing` zawierał resztki
starej integracji Ready/Core, a nie drugą działającą implementację DevPlanner.
Nowy frontend ma jeden wspierany pion udostępniania:

- workspace/projekt jako cele grantów,
- lista aktywnych grantów,
- cofnięcie grantu,
- capability `canShare`,
- błędy z kodem backendu/statusu,
- dialog jako overlay.

Nie ma jeszcze kontraktu standalone katalogu użytkowników, dlatego funkcja
wyszukiwania użytkownika nie została odtworzona atrapą. Public-link został
przywrócony, ponieważ backend posiada dla niego kompletny, potwierdzony
kontrakt: formularz tworzy grant z opcjonalnym hasłem i datą wygaśnięcia,
pokazuje bezpieczny link oraz pozwala cofnąć grant z listy aktywnych udostępnień.

## Audyt referencji

Przed zmianą referencje do starego dialogu występowały w trzech historycznych
menu Files (`grid`, `list`, `context_menu`) oraz w starych testach. Dialog został
zachowany jako cienki adapter `StorageSharingDialog`, który deleguje do
`StorageDesktopSharingDialog` i pobiera `StorageRepository` z composition root.
Dzięki temu istniejące menu nadal mają działającą funkcję, ale nie importują
Ready/Core ani starego user search.

Usunięte martwe elementy:

- `user_search/cubit/storage_user_search_cubit.dart`,
- `user_search/cubit/storage_user_search_state.dart`,
- `widgets/storage_public_link_form.dart`,
- `widgets/storage_share_row.part.dart`.

Usunięto również odpowiadający test user-search, bo testował nieistniejący
kontrakt Ready. Istniejące testy Cubita i rootowego modalu przepisano na
`package:devplanner`.

## Zmienione elementy

- `widgets/storage_sharing_dialog.dart` — cienki adapter do standalone dialogu;
- `sharing/standalone/storage_public_share_form.dart` — formularz public-linku
  bez dostępu do HTTP/repozytorium;
- `sharing/standalone/storage_desktop_sharing_dialog.dart` — integracja formularza
  z Cubitem i listą grantów;
- `data/storage/transport/public_share_link_builder_*.dart` — platformowy,
  typowany builder bez zgadywania adresu;
- testy `storage_sharing_dialog_modal_host_test.dart` i
  `storage_sharing_cubit_test.dart` — standalone importy i brak Ready provider;
- usunięte zostały wyłącznie pliki bez wspieranego kontraktu albo bez
  referencji po migracji. Stary `widgets/storage_public_link_form.dart` został
  zastąpiony przez standalone formularz, nie przez atrapę.

## Potwierdzony kontrakt public-link

Warstwa danych używa wyłącznie endpointów z `StorageApi`:

- `POST /api/v1/storage/files/{fileId}/shares` z `shareType: PublicLink`,
  `accessLevel`, opcjonalnym `password` i `expiresAtUtc`;
- `GET /api/v1/storage/files/{fileId}/shares` do odświeżenia listy;
- `DELETE /api/v1/storage/files/{fileId}/shares/{shareId}` do revoke;
- `POST /api/v1/storage/public/shares/{shareToken}/download-ticket` pozostaje
  kontraktem odbiorcy publicznego dostępu i nie jest wywoływany przez UI
  udostępniania.

Link jest budowany przez `PublicShareLinkBuilder`, nigdy przez UI ani przez
sklejanie nieznanego URL-a. Web używa bieżącego originu i ścieżki
`/storage/public/{shareToken}`. Desktop wymaga jawnego
`PUBLIC_APP_BASE_URL` i używa tej samej ścieżki; brak konfiguracji zwraca
typowany błąd walidacji zamiast wygenerować błędny adres.

Po udanym `POST` Cubit dopisuje grant do stanu i wywołuje odświeżenie dopiero
po potwierdzonej mutacji. Błędy 400/403/404/409/422 są mapowane przez istniejącą
warstwę repozytorium i prezentowane jako komunikat, bez lokalnego fałszywego
stanu.

## Walidacja

```text
flutter analyze lib/workspaces/presentation/storage/sharing
```

Wynik: `No issues found!` (0 issues).

```text
flutter test \
  test/workspaces/presentation/storage/sharing/storage_sharing_dialog_modal_host_test.dart \
  test/workspaces/presentation/storage/sharing/storage_sharing_cubit_test.dart \
  test/workspaces/presentation/storage/browser/storage_sharing_vertical_test.dart \
  --reporter compact
```

Wynik: `9 tests passed` (w tym formularz public-linku, payload z hasłem i
expiry oraz brak kontroli sharingu w BFF).

Sprawdzono też, że w aktywnych plikach sharing nie ma importów
`package:ready_next` ani `package:devplanner/core`.
