# Handoff fragment — 4J workspace members/directory

- Zakres 4J jest zaimplementowany w `lib/workspaces/data/workspaces`,
  workspace settings members/invitations oraz ich bezpośrednich testach.
- Kanoniczny transport to `userId`; lokalny katalog to
  `LocalDirectoryUserResponse` z backendowym `avatarFileId`.
- Retrofit używa `searchLocalUsers`; nie ma aliasów, fallbacków ani pól Ready/Core.
- Kontrakty i generated outputs zostały wygenerowane, a testy members,
  workspace home i kontraktów JSON przeszły.
- Bez rozszerzania migracji niezależnych DTO zaktualizowano bezpośrednie
  konsumenty kontraktu w Project members i Storage sharing.
- Walidacja końcowa: selektywne testy 11/11, `flutter analyze` bez uwag oraz
  `git diff --check` PASS.
- Następny agent może migrować niezależne DTO Projects/Storage w osobnych
  pakietach; nie przywracać aliasów Ready/Core w kontraktach workspace.
