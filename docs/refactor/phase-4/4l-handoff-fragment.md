# Handoff fragment — 4L frontendowe `UserId`

- **Status:** COMPLETE dla kontraktów Storage/Office/avatar/share/AI,
  Wiki/Whiteboard/OKR objętych zakresem.
- **ACL:** `WikiPageAccessGrantResponse` i
  `WhiteboardAccessGrantResponse` serializują `userId`; nie ma `coreUserId`.
- **OKR:** `ObjectiveResponse` serializuje `createdByUserId`.
- **Whiteboard:** payloady Sticky Note serializują `assigneeUserIds`.
- **Generated:** Freezed/JSON/Retrofit zostały przebudowane; nie dodano aliasów,
  fallbacków ani dual-read/write.
- **Dowody:** targeted suite **23/23**, `flutter analyze` PASS,
  legacy scan zakresu 4L pusty, `git diff --check` PASS.
- **Zakres wyłączony:** Tasks/Kanban, Projects/Workspace/Members, Admin, Auth,
  Chat i Notifications.
- **Następny krok:** koordynator powinien zrecenzować diff, zsynchronizować
  wspólny plan/handoff w obu repozytoriach i przejść do kolejnego otwartego
  pakietu frontendowego. Nie commitować ani nie pushować.
