# I0 — orphaned imports, batch A

## Zakres

Batch obejmował wyłącznie trzy małe rodziny błędów kompilacji wskazane w
zleceniu:

- `lib/features/settings/application/current_user_avatar_cubit.dart`,
- `lib/workspaces/data/access_control/**`,
- `lib/workspaces/data/admin/**`.

Do zakresu dołączono jedynie bezpośredni kontrakt wymagany przez Cubit avatara:
`lib/workspaces/domain/services/task_attachment_upload_transport.dart`. Nie
zmieniano routera, shella, listy zadań, plików, czatu, powiadomień ani backendu.

W review wykryto, że wcześniejszy stan dwóch wygenerowanych klientów Retrofit
zawierał `InvalidType`. Zostały one odtworzone kontrolowanym generatorem:

```text
dart run build_runner build \
  --build-filter='lib/workspaces/data/access_control/api/access_control_api.g.dart'
dart run build_runner build \
  --build-filter='lib/workspaces/data/admin/api/admin_api.g.dart'
```

Po regeneracji oba pliki zawierają konkretne typy kontraktów i zero
`InvalidType`; generator nie pozostawił zmian w tych plikach względem
kanonicznego stanu repozytorium.

## Zmiany

| Folder / plik | Przed | Po |
| --- | --- | --- |
| `features/settings/application/current_user_avatar_cubit.dart` | import `ready_next/core/error/api_error.dart` | canonical `devplanner/foundation/error/api_error.dart` |
| `workspaces/domain/services/task_attachment_upload_transport.dart` | importy `ready_next` powodowały niezgodność typu błędu z Cubitem | canonical `devplanner` dla `ApiError` i `StorageUploadTicketResponse` |
| `workspaces/data/access_control/api` | import modelu z `ready_next` | import `devplanner` |
| `workspaces/data/access_control/models` | import enumów z `ready_next` | import `devplanner` |
| `workspaces/data/admin/api` | import modeli z `ready_next` | import `devplanner` |

Nie zmieniano modeli ani nie tworzono zastępczych typów. Kanoniczne modele już
istniały w tym repozytorium.

## Walidacja

Zakresowy `flutter analyze` przed domknięciem batcha raportował 4 diagnostyki
(1 błąd typów `ApiError` i 3 informacje o kolejności dyrektyw). Po zmianach:

```text
flutter analyze lib/features/settings/application/current_user_avatar_cubit.dart \
  lib/workspaces/domain/services/task_attachment_upload_transport.dart \
  lib/workspaces/data/access_control lib/workspaces/data/admin \
  test/admin test/shared/presentation/widgets/app_user_avatar_test.dart
No issues found!
```

Testy:

```text
flutter test test/admin test/shared/presentation/widgets/app_user_avatar_test.dart --reporter compact
All tests passed! (15 tests in the final run)
```

Maszynowa analiza:

```text
dart analyze --format machine <zakres batcha>
0 linii diagnostycznych
```

Zakres analizy obejmował również oba wygenerowane klienty Retrofit. Przed
regeneracją oba pliki zawierały wystąpienia `InvalidType`; po regeneracji: 0.

Kontrole dodatkowe:

- brak `package:ready_next` w zmienionym zakresie,
- skan `package:ready_next` i `InvalidType` w zakresie przechodzi,
- `git diff --check` dla zmian tego batcha przechodzi (globalny diff nadal ma
  niezależne, wcześniejsze trailing whitespace w `packages/material_table_view`),
- brak pozostałych błędów w zakresie batcha.

## Poza zakresem

Globalny analyzer projektu nadal może raportować problemy w innych, jeszcze
niemigrowanych rodzinach. Ten raport nie potwierdza zielonego stanu całego
projektu.
