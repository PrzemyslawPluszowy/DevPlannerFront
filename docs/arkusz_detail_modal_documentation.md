# Arkusz Detail Modal - dokumentacja techniczna

## Cel
Ten dokument opisuje podzial i zasady rozwoju ekranu szczegolow arkusza:
`lib/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_detail_modal.dart`.

## Aktualny podzial
- `arkusz_detail_modal.dart`
  - orchestrator ekranu (entrypoint + skladanie `part`),
  - bez logiki szczegolowej UI.
- `arkusz_detail_modal_content.part.dart`
  - strona i body szczegolow arkusza,
  - ladowanie i przejscia stanow,
  - sekcja loaded + akcje komisji.
- `arkusz_detail_modal_elements.part.dart`
  - sekcja filtrow i ich stan lokalny,
  - opcje filtrow i matchery.
- `arkusz_detail_modal_table.part.dart`
  - tabela elementow arkusza,
  - row tap -> modal edycji elementu,
  - helpery formatowania i badge tabeli.
- `arkusz_detail_modal_header.part.dart`
  - karta naglowka arkusza,
  - chipy komisji i metadanych.
- `arkusz_detail_modal_statuses.part.dart`
  - mapowanie enumow statusow do UI (`label`, `tone`, `icon`),
  - legenda statusow (ST / stan inwent. / skan),
  - helper etykiety kolumny statusu bez dopisku `ST`.

## Dlaczego `part`
Ten kod jest lokalny dla jednego ekranu i nie jest komponentem wspoldzielonym globalnie.
Zgodnie z zasadami projektu trzymamy go jako lokalny modul, ale rozbity na mniejsze pliki, zeby ograniczyc rozmiar pliku glownego.

## Statusy - single source of truth
Mapowanie enumow do warstwy wizualnej jest skupione w extensionach:
- `_SrodekTrwalyStatusUi`
- `_ArkuszElementInwentStatusUi`

Kazdy extension trzyma:
- `localizedLabel(BuildContext)`
- `tone`
- `icon`

Dzieki temu te same definicje sa uzywane rownoczesnie w:
- badge'ach tabeli,
- opcjach filtrow,
- legendzie.

## Jak dopisac nowy status
1. Dodaj wartosc po stronie modelu/enum.
2. Uzupelnij extension (`localizedLabel`, `tone`, `icon`).
3. Zweryfikuj:
- filtr,
- badge w tabeli,
- legende.

## Jak dopisac nowy filtr
1. Dodaj lokalny stan filtra w `_ArkuszElementsSectionState`.
2. Dodaj matcher do sekwencji filtrowania (`_matches...`).
3. Dodaj opcje przez dedykowany helper `_...FilterOptions`.
4. Uzyj tych samych opcji w obu layoutach (wide/compact), zeby uniknac duplikacji.

## Stan po refaktorze
Plik glowny zostal ograniczony do roli orchestratora i ma tylko kilkadziesiat linii.
Logika ekranu zostala podzielona na lokalne `part`, zgodnie z zasada trzymania kodu lokalnego dla feature.
