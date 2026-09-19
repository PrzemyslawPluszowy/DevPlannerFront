# T3a — naprawa testu kontraktu transportu załączników Chat

Data: 2026-09-18  
Status: **gotowe do niezależnego review rootu**.

## Zakres

Zmieniono wyłącznie
`test/workspaces/data/chat/chat_attachment_transport_contract_test.dart`.
Kod produkcyjny, routing, backend i modele nie zostały zmodyfikowane.

## Zrealizowane zmiany

- Import `package:ready_next` zastąpiono istniejącym modelem transportowym
  `package:devplanner/workspaces/data/chat/models/chat_models.dart`.
- Fixture odpowiedzi wiadomości używa aktualnych kluczy kontraktu lokalnego:
  `authorUserId` i `attachedByUserId`.
- Zachowano weryfikację serializacji sesji tymczasowych załączników,
  uporządkowanego `attachmentFileIds` payloadu oraz odczytu załączników z
  odpowiedzi wiadomości.
- Nie utworzono legacy modelu, aliasu ani fallbacku Ready/Core.

## Dowody

```text
dart format test/workspaces/data/chat/chat_attachment_transport_contract_test.dart
# PASS

flutter analyze test/workspaces/data/chat/chat_attachment_transport_contract_test.dart
# PASS: No issues found!

flutter test test/workspaces/data/chat/chat_attachment_transport_contract_test.dart --reporter compact
# PASS: 2/2

rg -n 'package:ready_next|\\bReady\\b|CoreUserId|coreUserId|authorCoreUserId|attachedByCoreUserId' \
  test/workspaces/data/chat/chat_attachment_transport_contract_test.dart
# PASS: brak wyników

git diff --check
# PASS
```

## Następny krok

Root powinien niezależnie powtórzyć analyzer, exact test i `git diff --check`.
Po akceptacji tylko root aktualizuje wspólny plan i handoff.
