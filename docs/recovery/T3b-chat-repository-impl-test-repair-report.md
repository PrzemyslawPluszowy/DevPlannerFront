# T3b — naprawa testu `ChatRepositoryImpl`

**Status:** gotowe do review rootu.

## Zakres

Naprawiono wyłącznie `test/workspaces/data/chat/chat_repository_impl_test.dart`.
Kod produkcyjny, routing, backend i warstwy zgodności nie były zmieniane.

## Zmiana

Test został przeniesiony z usuniętego kontraktu `ready_next` na aktualny adapter
`ChatRepositoryImpl` oraz jego API `devplanner`. Obejmuje rzeczywiste publiczne
operacje adaptera:

- pobranie rozmów;
- pobranie wiadomości z limitem strony `100`;
- wysyłkę tekstu i klucza idempotencji;
- mapowanie błędu HTTP listy rozmów na stabilny kod Chat;
- mapowanie nieoczekiwanego wyjątku wysyłki na błąd parsowania.

Dane testowe korzystają z kanonicznego `authorUserId`; nie dodano żadnej
kompatybilności dla `authorCoreUserId` ani `ready_next`.

## Walidacja

- `dart format test/workspaces/data/chat/chat_repository_impl_test.dart` — poprawne formatowanie;
- `flutter analyze test/workspaces/data/chat/chat_repository_impl_test.dart` — bez problemów;
- `flutter test --reporter compact test/workspaces/data/chat/chat_repository_impl_test.dart` — 5/5 testów przeszło.

Przed przekazaniem do review wykonano także skan starych importów i kontraktów
oraz `git diff --check` dla zakresu T3b.
