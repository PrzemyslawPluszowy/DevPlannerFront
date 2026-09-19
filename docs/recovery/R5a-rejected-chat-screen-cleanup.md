# R5a — odrzucony ekran Chat: cleanup

Data: 2026-09-17  
Repozytorium: `Front`

## Decyzja

Zgodnie z nadrzędną decyzją Chat nie jest osobnym ekranem aplikacji. Globalny
Chat ma docelowo działać jako panel/overlay otwierany z powłoki, bez zmiany
bieżącej trasy. Eksperymentalny pion ekranu został odrzucony przed akceptacją.

## Usunięte artefakty

Usunięto wyłącznie niezaakceptowane pliki z eksperymentalnego pionu:

- `lib/workspaces/presentation/chat/standalone/chat_standalone_page.dart`
- `lib/workspaces/presentation/chat/standalone/cubit/chat_standalone_cubit.dart`
- `lib/workspaces/presentation/chat/standalone/cubit/chat_standalone_state.dart`
- `test/workspaces/presentation/chat/standalone/chat_standalone_test.dart`

Nie usuwano ani nie modyfikowano w ramach tego cleanupu starego Chat,
routera, backendu, kontraktów danych, Notifications ani Storage. Nie wykonano
commit/push i nie zmieniano historii Git.

## Konsekwencja dla następnego pakietu

Następny Chat/Notifications powinien powstać dopiero po stabilizacji shellu
jako feature panelu/overlay hostowanego przez shell. Musi używać istniejącego
portu repozytorium i sesyjnego transportu, ale nie może tworzyć osobnej trasy
Chat ani przywracać importów `ready_next`.
