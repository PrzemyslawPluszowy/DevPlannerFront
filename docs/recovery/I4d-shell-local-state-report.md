# I4d — lokalny stan zwijanego menu shellu

## Zakres

Aktywny standalone `DevPlannerShellRoute` nie używa już `setState` do obsługi
zwinięcia bocznego menu.

## Zmiana

- Stan ograniczono do prywatnego `ValueNotifier<bool>` należącego do state
  shellu.
- `ValueListenableBuilder` przebudowuje tylko layout zależny od szerokości
  menu; dane drzewka workspace, trasa i stan dziecka nie są własnością tej
  kontrolki.
- `ValueNotifier` jest jawnie zwalniany w `dispose`.

## Następny krok

Ten pakiet nie zmienia zapisu preferencji menu ani nie dodaje globalnego stanu.
Trwałe zapamiętanie ustawienia należy później zrealizować przez osobny Cubit i
adapter ustawień, zgodnie z planem motywu/shellu.
