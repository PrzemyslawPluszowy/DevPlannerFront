# R2a — naprawa importów realtime Chat

**Status:** gotowe do review rootu.

## Cel i granice

Pakiet obejmuje wyłącznie warstwę `lib/workspaces/data/realtime/chat/**`,
konieczne bezpośrednie kontrakty Chat oraz ich testy realtime. Nie zmieniono
panelu globalnego Chat, routingu, backendu ani UI.

## Zrealizowane zmiany

- Wszystkie importy `package:ready_next/...` w produkcyjnej warstwie realtime
  Chat i jej testach zostały zastąpione bezpośrednimi importami
  `package:devplanner/...`; nie zastosowano aliasu ani warstwy zgodności.
- `WorkspaceChatRealtimeService` nadal używa właściwego
  `WorkspaceSignalRTransport`, z pełnym kontraktem subskrypcji, reconnectu,
  replayu kursora, deduplikacji oraz błędów typowanych.
- Mapper jest zgodny z aktualnym DTO i modelem domenowym: pole autora to
  `authorUserId`. Testowe PascalCase/camelCase payloady odzwierciedlają ten
  sam kontrakt. Nie wprowadzono placeholderów.
- Pomocniczy transport wykorzystywany bezpośrednio przez testy również
  importuje kontrakt SignalR z `devplanner`, dzięki czemu test i produkcja
  sprawdzają ten sam typ.

## Bramy jakości

- `dart format` dla 6 zmienionych plików: bez dalszych zmian.
- `flutter analyze` dla realtime Chat i jego bezpośrednich testów: **brak
  problemów**.
- `flutter test --reporter compact` dla mappera, serwisu i typowanych eventów:
  **11 testów zakończonych sukcesem**.
- Skan `package:ready_next` w zakresie: **0 wyników**.
- Skan `setState`, `StatefulBuilder`, `setDialogState` w produkcyjnym zakresie:
  **0 wyników**.
- Skan bezpośrednich importów `http`/`dio`: **0 wyników**.
- Najdłuższy plik produkcyjny realtime Chat ma 353 linie; żaden nie przekracza
  limitu 400 linii.
- Pozostały import `package:devplanner/core/error/api_error.dart` jest
  wewnętrznym, typowanym błędem aplikacji używanym do mapowania utraty dostępu;
  nie jest zależnością od usuniętego Ready/Core/DataBus.

## Zakres review

Do review rootu: importy i kontrakt w
`chat_realtime_event_mapper.dart`, `workspace_chat_realtime_service.dart`
oraz trzy bezpośrednie testy realtime i ich testowy transport.
