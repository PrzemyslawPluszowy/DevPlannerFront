# Sekcje Workspaces

Każda sekcja menu otrzymuje własny katalog dopiero razem z pierwszym ekranem,
Cubit-em/use-case’em i testem. Nie umieszczamy logiki sekcji w
`WorkspacesHomePage`; shell odpowiada wyłącznie za wybór i układ nawigacji.

Docelowy układ katalogu sekcji:

```text
sections/<section>/
├── cubit/
├── widgets/
└── <section>_page.dart
```

Warstwa domenowa i repozytoria pozostają współdzielone z `lib/workspaces/data`
i `lib/workspaces/domain`; widgety nie wykonują bezpośrednich wywołań API.
