# I5f — ustawienia projektu: lokalny stan i wydzielone widoki

## Zakres wykonany

Pakiet objął wyłącznie `lib/workspaces/presentation/projects/settings/**` oraz
bezpośredni test modali ustawień projektu.

- usunięto wszystkie wystąpienia `setState`, `StatefulBuilder` i
  `setDialogState` z pionu ustawień projektu;
- lokalne wybory w dialogach członków, etykiet, statusów, kamieni milowych,
  danych ogólnych projektu, centrum użytkownika, modalu ustawień, szczegółów
  szablonu i formularza pól własnych korzystają z prywatnych
  `ValueNotifier`ów oraz `ValueListenableBuilder`, z jawnym `dispose`;
- dialog usuwania statusu workflow otrzymał własny widget z lokalnym
  `ValueNotifier`, zamiast `StatefulBuilder`;
- wydzielono drobne komponenty oraz akcje dialogowe dla pól własnych,
  kamieni milowych, workflow, wyboru ikony/koloru oraz nawigacji centrum
  użytkownika;
- podzielono widok szablonów na listę, kartę i dialog szczegółów oraz dialog
  pola własnego na właściciela stanu, niemutowalny szkic, edytor opcji i
  pickery koloru/ikony; zachowane zostały opcje wielokrotne, kolejność,
  ikony i kolory;
- pomocniki wizualne pól własnych są metodami statycznymi
  `CustomFieldOptionVisuals`, a nie globalnymi funkcjami;
- rozbito `project_settings_modal.dart` na: katalog zakładek, ramę
  responsywną z nawigacją, host aktywnej zakładki oraz
  `ProjectSettingsCubitRegistry`, który zachowuje lazy loading, obserwację
  zapisów i jawne zamykanie Cubitów;
- entrypoint modala ustawień projektu jest statyczną metodą fasady
  `ProjectSettingsDialogs.show`, a trzy bezpośrednie użycia (Board, List,
  test) korzystają z tej fasady zamiast funkcji top-level;
- entrypoint Panelu Użytkownika Projektu jest analogiczną fasadą
  `ProjectUserHubDialogs.show`; zmieniono jego dwa bezpośrednie użycia
  (Board i test) oraz wyłącznie komentarz referencyjny facepile;
- bez zmiany kontraktów API, repozytoriów, routingu ani logiki zapisu Cubitów;
- zaktualizowano bezpośredni test modali z nieistniejącego pakietu
  `ready_next` na `devplanner`.

## Weryfikacja

```text
flutter analyze lib/workspaces/presentation/projects/settings
No issues found!

flutter test test/workspaces/presentation/projects/settings/project_settings_and_user_hub_modals_test.dart --reporter compact
4/4 PASS

rg -n "\\bsetState\\b|StatefulBuilder|setDialogState" lib/workspaces/presentation/projects/settings
brak wyników
```

## Końcowe bramki jakości

```text
find ... -exec wc -l: największy plik ma 388 linii (limit 400 zachowany)
rg setState|StatefulBuilder|setDialogState: brak wyników
git diff --check (scoped): PASS
```

Pakiet nie dodaje `part`, mixinów ani globalnych pomocników dla lokalnego
stanu. Cubity nadal wykonują całą logikę asynchroniczną i zapisową; widoki
obsługują jedynie kompozycję oraz krótkotrwały stan interakcji.

Kontrola deklaracji top-level po tej zmianie nie wykazała entrypointów UI
w pionie ustawień projektu; oba są metodami klasowych fasad.
