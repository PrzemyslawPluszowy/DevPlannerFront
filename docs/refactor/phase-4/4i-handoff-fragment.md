# Handoff fragment — 4I frontend Tasks/Kanban `UserId`

- Pion Tasks/Kanban używa wyłącznie lokalnego `userId`; dotyczy to modeli,
  generated Freezed/JSON, Retrofit, repozytoriów, realtime oraz presentation.
- Query wykonawcy to `assigneeUserId`; listy wykonawców to `userIds` lub
  `assigneeUserIds`; pola odpowiedzi mają suffix `UserId`.
- Profile członków projektu, presence, capacity/workload, templates, saved
  views, history, watchers, board i list nie wykonują dual-read/write ani
  fallbacku Core/Ready.
- Walidacja: targeted suite **116/116 PASS**, targeted `flutter analyze` PASS,
  `git diff --check` PASS; build_runner zakończony poprawnie z istniejącym
  ostrzeżeniem wersji `json_annotation`.
- Zakres nie obejmuje workspace directory/invitations/members, Storage, Wiki,
  Whiteboard, OKR, Chat/Notifications, Auth ani common docs.
- Następny agent powinien sprawdzić pozostałe domeny frontendu i zachować brak
  aliasów, fallbacków oraz runtime połączeń Ready/Core/DataBus.
