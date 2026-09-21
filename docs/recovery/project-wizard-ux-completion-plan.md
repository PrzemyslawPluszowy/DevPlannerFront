# Plan UX kreatora projektu — źródło kanoniczne

Pełny plan wykonawczy znajduje się w sąsiednim repozytorium Backend:

`../../../Backend/docs/recovery/project-wizard-ux-completion-plan.md`

Agent pracujący nad Frontem ma przeczytać ten dokument w całości przed zmianą
widgetów kreatora. Ten plik jest wyłącznie wskaźnikiem, aby nie utrzymywać dwóch
rozbieżnych kopii checklisty i kryteriów odbioru.

## Stan wdrożenia (2026-09-20)

Pakiety UX-1…UX-7 oraz trzy domknięte punkty UX-5 (miniatury kolumn na opcjach
workflow, „Dostosuj także…” w sposobie pracy, reguły „Gdy… → wtedy…” na kartach
funkcji startowych) są zrealizowane w tym repozytorium. Dowody (komendy, wyniki,
pliki goldenów) i lista zamian tekstów są w sekcji 16 dokumentu kanonicznego;
checklista odbioru w jego sekcji 14 jest odhaczona. Uwagi przeglądu
zewnętrznego (dwa P1: podsumowanie gubiące zawartość szablonu i stan wiersza
statusu po usunięciu sąsiada; dwa P2: zgodność przełącznika podglądu z renderem
i test roli bez prawdziwego menu) są naprawione wraz z testami regresyjnymi.
Druga runda wykryła, że finalny Kanban gubił karty szablonu (plan nie niesie
własnych statusów dla projektu z szablonu) oraz że podgląd zgadywał nazwy
i liczbę statusów systemowych — oba naprawione; opis w sekcji 16. Trzecia runda
domknęła to na kontrakcie: plan serwera niesie teraz kolumny projektu z szablonu
i zadania z nazwą kolumny docelowej, więc podsumowanie pokazuje plan zamiast
dopasowywać zadania do kolumn po nazwie (szczegóły i bramki w sekcji 16
dokumentu kanonicznego, wpis `WIZ-PREVIEW-PLAN`). Niewykonane zostają bramki
Windows i Linux, bo ta maszyna jest hostem macOS.

Nowe teksty kreatora muszą przechodzić audyt z sekcji 12: żaden komunikat nie
może mówić o portach, transporcie ani katalogach kodu.
