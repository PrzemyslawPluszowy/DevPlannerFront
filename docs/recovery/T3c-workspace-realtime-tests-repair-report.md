# T3c — testy realtime workspace’ów

Status: **gotowe do niezależnego review rootu**.

Zmieniono wyłącznie dwa wskazane testy realtime: importy korzystają z
aktualnego `package:devplanner/...`, bez zmian kodu produkcyjnego ani warstwy
zgodności. Pozostawiono pokrycie scope Whiteboard, ponownej subskrypcji,
replayu i deduplikacji, a także reconnectu, cursorowego replayu i mapowania
zdarzeń powiadomień.

Walidacja:

- `flutter analyze` obu testów: **0 problemów**;
- `flutter test` obu testów: **9 testów przeszło**;
- `git diff --check`: powodzenie.
