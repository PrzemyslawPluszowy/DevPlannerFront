# T2b — test adaptera uploadu załączników Chat

Status: **gotowe do niezależnego review rootu**.

Zmieniono wyłącznie bezpośredni test adaptera uploadu: importy korzystają z
aktualnego `package:devplanner/...`, bez adaptera zgodności i bez zmian kodu
produkcyjnego. Zachowano przypadki sesji, biletu uploadu, binarnego uploadu,
zatwierdzenia pliku oraz wszystkich statusów skanowania i przetwarzania.

Walidacja:

- `flutter analyze test/workspaces/data/chat/attachments/chat_attachment_upload_port_adapter_test.dart`:
  **0 problemów**;
- `flutter test test/workspaces/data/chat/attachments/chat_attachment_upload_port_adapter_test.dart`:
  **9 testów przeszło**;
- `git diff --check`: powodzenie.
