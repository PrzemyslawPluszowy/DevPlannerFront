# Handoff fragment — 6F globalny Chat

- **Status:** COMPLETE dla frontendowego panelu i route boundary; kompozycja
  backendowego transportu pozostaje downstream.
- **Publiczny port:** `DevPlannerGlobalChatComposition` w
  `lib/workspaces/presentation/chat/global_chat_composition.dart`.
- **Root entry:** `AppGlobalChatDrawer.show` używa rootowego
  `DevPlannerModalHost`, ma domyślny `topInset: 64`, focus traversal i
  semantyczny region Chat.
- **Routes:** `/chat` jest pełną listą, a
  `/chat/conversations/:conversationId` pełną rozmową/deep linkiem. Router
  nie odtwarza starych ścieżek.
- **Shell:** topbar wywołuje side sheet przez callback kompozycji; przy braku
  kompozycji przechodzi do `/chat` zamiast udawać gotową funkcję.
- **Reuse:** panel korzysta z `ChatDrawerCubit`, `ChatConversationCubit`,
  `ChatMessageComposer`, kolejki dostawy, upload portu i
  `WorkspaceChatRealtimeFactory`; nie zna Dio, SignalR, auth repository ani
  secure storage.
- **Test:** `test/workspaces/presentation/chat/global_chat_integration_test.dart`
  sprawdza ładowanie rozmowy przez jawny port; router/shell mają osobne testy.
- **Validation:** `flutter analyze`, scoped Chat/router/shell tests i
  `git diff --check` są zielone.
- **Known boundary:** bootstrap nie składa jeszcze realnego Chat repository,
  ponieważ backendowy OpenAPI/auth transport nie jest zakończony. Kolejny
  agent ma tylko dostarczyć adapter data/composition na rzeczywistym kontrakcie;
  nie zmieniać overlayu ani nie dodawać fallbacku do Ready/Core/DataBus.
