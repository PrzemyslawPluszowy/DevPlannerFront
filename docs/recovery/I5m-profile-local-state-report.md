# I5m — profil użytkownika: lokalny stan i komponenty

## Zakres wykonany

Zmiana obejmuje wyłącznie `lib/me/presentation/**` oraz istniejące testy
`test/me`.

- Usunięto wszystkie `setState` z edycji danych osobowych i zmiany hasła.
- Edycja nazwy wyświetlanej korzysta z prywatnego `ValueNotifier<bool>`;
  kontroler jest zwalniany w `dispose` i nie nadpisuje danych z Cubita podczas
  aktywnej edycji.
- Formularz hasła korzysta z prywatnego, niemutowalnego
  `_PasswordFormUiState` w `ValueNotifier`: widoczność trzech haseł oraz
  odświeżanie wskaźników reguł hasła nie powodują przebudowy przez `setState`.
- Zachowano walidację i operację Cubita: aktualne hasło, minimum 15 znaków,
  maksimum 128 znaków, różnica od poprzedniego i zgodność potwierdzenia.
- Usunięto `part` z profilu. Strona składa teraz niezależne komponenty:
  karta danych osobowych, hasła, sesji oraz role/uprawnienia. Nie ma ukrytego
  współdzielenia biblioteki ani plików przekraczających 400 linii.
- Profil, awatar, zmiana hasła i unieważnianie sesji nadal delegują operacje
  wyłącznie do istniejących Cubitów oraz `MeGateway`; UI nie wykonuje HTTP.

## Bramy jakości

```text
flutter analyze lib/me/presentation
No issues found!

flutter test test/me --reporter compact
34/34 PASS

rg setState|StatefulBuilder|setDialogState|part: brak wyników
najdłuższy plik produktowy Dart: 397 linii
git diff --check (scoped): PASS
```

Nie dodano zależności `ready_next`, `DataBus`, `http` ani `dio`. Istniejące
importy `devplanner/core` pozostają wyłącznie warstwą motywu, lokalizacji i
błędów domenowych — bez operacji sieciowych w UI.

## Status

Gotowe do review rootu. Nie wykonano commita, push, resetu ani czyszczenia
worktree.
