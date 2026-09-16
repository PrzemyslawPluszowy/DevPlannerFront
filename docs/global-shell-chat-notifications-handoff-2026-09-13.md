# Global shell — handoff implementacyjny, 2026-09-13

## Zrealizowany pakiet

Wdrożono wyłącznie fundament globalnego shellu z etapu 0–1 planu. Nie
zmieniano kontraktu ani funkcji Chat i Notifications.

- `AppRouter` ma prywatny `ShellRoute`; `/`, `/login` oraz
  `/storage/public/:shareToken` pozostają poza nim.
- `AppGlobalShell` w `lib/app/shell/` jest właścicielem globalnego chrome'u.
  `MaterialApp.router.builder` udostępnia już wyłącznie `AppRouter` przez
  provider, więc nie opakowuje rootowego Navigatora.
- Zarezerwowany slot topbara i zwiniętego raila opisuje `AppShellMetrics`.
  Rozwinięty rail nadal jest overlayem, ale obszar trasowany zawsze zaczyna się
  pod topbarem i na prawo od zwiniętego raila.
- Shell centralnie dodaje `MediaQuery.viewPadding.top` wyłącznie do topbara i
  usuwa go z obszaru roboczego. Dzięki temu `SafeArea` raila/contentu nie
  dubluje insetu po jego rozpoczęciu pod topbarem.
- Usunięto lokalne kompensacje wysokości globalnej belki z
  `AppModuleLayout`, `AppCompactModuleLayout` i dashboardu.
- `AppGlobalModuleWrapper` pozostał cienkim aliasem kompatybilnym wstecz;
  nowy kod importuje `AppGlobalShell`.
- Test widgetowy tworzy realny `ShellRoute` i potwierdza, że rootowy dialog
  oraz `AppModalSheet.showSideSheet` mają barrier przykrywający topbar, rail i
  obszar trasowany. Test sprawdza też geometrię zarezerwowanego chrome'u.
- Test realnego `AppRouter` sprawdza `/orders?filter=due`, `/login`, `/` oraz
  `/storage/public/share-token`; shell występuje dokładnie raz wyłącznie dla
  trasy prywatnej, także gdy publiczny share ma aktywną sesję.
- Teksty changeloga są w `app_pl.arb` i `app_en.arb`; po zmianie uruchomiono
  `flutter gen-l10n`.

## Zmienione pliki

- `lib/app/shell/app_global_shell.dart`
- `lib/app/shell/app_shell_export.dart`
- `lib/app/shell/app_shell_metrics.dart`
- `lib/app/shell/changelog/app_shell_changelog_body.dart`
- `lib/app/router/app_router.dart`
- `lib/app/ready_next_app.dart`
- `lib/shared/presentation/widgets/app_global_module_wrapper.dart`
- `lib/shared/presentation/widgets/app_global_module_rail.dart`
- `lib/shared/presentation/widgets/app_module_lauout/app_module_layout.dart`
- `lib/shared/presentation/widgets/app_module_lauout/app_compact_module_layout.dart`
- `lib/features/dashboard/presentation/app_dashboard_page.dart`
- `test/shared/presentation/widgets/app_global_module_wrapper_test.dart`
- `test/shared/presentation/widgets/app_module_layout_test.dart`

## Jakość i granice

- Zachowana jest hierarchia `app/shell`; nie dodano globalnego BLoC/Cubita,
  globalnego stanu biznesowego ani wywołań API z widgetów.
- Nowe klasy mają dokumentację po polsku; niezmienna geometria jest zamknięta
  w jednej klasie zamiast w magicznych offsetach ekranów.
- Nie zmieniono istniejących tras prywatnych ani publicznych ścieżek i nie
  zmieniono publicznego API starego wrappera.
- Nie wykonano funkcji Chat, Notifications ani migracji wszystkich lokalnych
  wywołań modalnych — to są kolejne etapy planu.

## Walidacja

- `dart format` dla wszystkich zmienionych plików — sukces.
- `flutter analyze` dla zmienionego zakresu — brak problemów.
- `flutter test test/shared/presentation/widgets/app_global_module_wrapper_test.dart test/shared/presentation/widgets/app_module_layout_test.dart test/app/router/app_deep_link_test.dart test/app/router/app_route_paths_test.dart test/app/router/auth_redirect_policy_test.dart` — 28 testów, sukces.
- `flutter test test/widget_test.dart test/app/router/app_deep_link_test.dart test/app/router/app_route_paths_test.dart test/app/router/auth_redirect_policy_test.dart` — 25 testów, sukces. Testy integracji widgetowej logują istniejące odpowiedzi HTTP 400 z lokalnych atrap backendu, ale kończą się powodzeniem.
- `graphify update .` nie został uruchomiony: polecenie `graphify` nie jest dostępne w środowisku (`command not found`).

## Otwarte ryzyka i następny krok

- Nie ma jeszcze goldenów dla wariantów 1920×1080, 1440×900, 1280×720,
  compact oraz light/dark/text scaling. Następny wykonawca powinien dodać je
  przed redesignem topbara.
- Nie wykonano jeszcze testów Tab/Shift+Tab, Escape i restore focus dla
  rootowych modali. Wspólny kontrakt modalny z etapu 3 musi je zapewnić i
  objąć testami.
- Obecne `AppModalSheet` ma już domyślne `useRootNavigator: true`; należy
  dalej zinwentaryzować wszystkie bezpośrednie `showDialog`,
  `showGeneralDialog` i `showModalBottomSheet`, a następnie migrować je przez
  jedno API z jawną polityką root/nested.
- Kolejnym krokiem jest etap 2: wydzielenie małych sekcji topbara,
  `AppShellMetrics` jako pełnego tokenu motywu oraz testy responsive/golden;
  nie rozpoczynać jeszcze implementacji funkcji Chat.

## Pakiet 2 — redesign belki i responsive chrome

Zrealizowano wyłącznie redesign globalnego chrome'u. Nie dodawano funkcji
Chat, jego unread badge ani nowego transportu/API.

- `AppShellMetrics` jest teraz `ThemeExtension`: token obejmuje wysokość i
  insets topbara, szerokości raila, breakpointy compact/medium/wide oraz
  minimalny touch target. Każdy produkcyjny motyw (także paleta dynamiczna)
  dostaje ten extension; bezpośredni test widgetu ma bezpieczny fallback.
- Topbar został rozłożony drzewiasto w `app/shell/top_bar/`: powierzchnia i
  lifecycle licznika, layout, breadcrumb i akcje są osobnymi widgetami.
  Krótko żyjący `UnreadNotificationsCubit` pozostaje lokalny dla belki; nie ma
  globalnego Cubita, `BuildContext` w Cubicie ani wywołań API z widgetu.
- Belka nie renderuje już pozorowanej command palette. Zachowany publiczny
  `AppGlobalSearchCapsule` jest nieaktywny i komunikuje stan „wkrótce” przez
  ARB, gdyby został użyty przez starszy kod.
- Zachowano breadcrumb oraz wejścia Notifications i Chat. Akcje mają tokenowy
  minimalny obszar interakcji 44×44. Compact pokazuje tylko semantyczny brand
  z tooltipem, więc nie dopuszcza do horyzontalnego overflow; medium/wide
  zachowują pełny breadcrumb.
- Wizualna powierzchnia belki ma jeden separator i cień wewnątrz route shellu;
  nie tworzy własnego `Overlay`, więc nie wpływa na potwierdzony w pakiecie 1
  z-order rootowych dialogów i side sheetów.
- Dodano ARB PL/EN: `appShellBrandName` i
  `appShellCommandPaletteUnavailable`; uruchomiono `flutter gen-l10n`.

### Pliki pakietu 2

- `lib/app/shell/app_shell_metrics.dart`
- `lib/app/shell/top_bar/app_shell_top_bar.dart`
- `lib/app/shell/top_bar/app_shell_top_bar_breadcrumb.dart`
- `lib/app/shell/top_bar/app_shell_top_bar_actions.dart`
- `lib/app/shell/top_bar/top_bar_export.dart`
- `lib/app/shell/app_global_shell.dart`
- `lib/core/theme/theme.dart`
- `lib/app/ready_next_app.dart`
- `lib/shared/presentation/widgets/app_global_utility_bar.dart`
- `lib/shared/presentation/widgets/app_global_utility_bar_parts.dart`
- `lib/shared/presentation/widgets/app_global_module_rail.dart`
- `lib/l10n/app_pl.arb`, `lib/l10n/app_en.arb` oraz wygenerowane lokalizacje
- `test/app/shell/top_bar/app_shell_top_bar_test.dart`
- `test/shared/presentation/widgets/app_global_module_wrapper_test.dart`

### Walidacja pakietu 2

- `flutter gen-l10n` — sukces.
- `dart format` dla shellu, topbara, motywu, współdzielonych widgetów i testów
  — sukces.
- `flutter analyze` (pełny projekt) — brak problemów.
- `flutter test test/app/shell/top_bar/app_shell_top_bar_test.dart
  test/shared/presentation/widgets/app_global_utility_bar_test.dart
  test/shared/presentation/widgets/app_global_module_wrapper_test.dart
  test/shared/presentation/widgets/app_module_layout_test.dart
  test/app/router/app_deep_link_test.dart test/app/router/app_route_paths_test.dart
  test/app/router/auth_redirect_policy_test.dart` — 65 testów, sukces.
- Snapshoty geometrii obejmują desktop/compact w jasnym i ciemnym motywie oraz
  rail zwinięty/rozwinięty. Rzeczywiście renderowany `AppShellTopBar` obejmuje
  compact, medium i wide w jasnym/ciemnym motywie oraz skalę tekstu 1.0, 1.3 i
  1.5; asercje sprawdzają rect i aktywność obu akcji oraz brak overflow.
- Breakpointy są semantyką szerokości całego logicznego viewportu, a nie
  pomniejszonego panelu belki: prawdziwe renderowanie `AppShellTopBar` i
  `AppGlobalShell` testuje `599/600/601` oraz `1023/1024/1025` px.
- Test insets sprawdza `viewPadding(top: 24, left: 10, right: 12)`: rect
  panelu belki, obu akcji, raila i contentu. Snapshot raila potwierdza też, że
  rozwinięcie nie zmienia geometrii topbara ani obszaru trasowanej treści.
- `AppGlobalSearchCapsule` nie zawiera już `InkWell`; test potwierdza disabled
  semantics i brak elementu klikalnego.
- `git diff --check` — sukces.

## Pakiet 7C — typed contract sesji tymczasowych załączników

- Odświeżono Retrofit/Freezed/JSON przez `dart run build_runner build` dla
  zaakceptowanego kontraktu 7B. `ChatApi` wystawia create i cancel sesji pod
  `attachment-sessions`; odpowiedź przenosi tylko `id`, `conversationId` i
  `expiresAtUtc`.
- `SendChatMessagePayload` oraz domenowy `ChatSendMessageCommand` przenoszą
  uporządkowane `attachmentFileIds`. `ChatMessageResponse.attachments` jest
  mapowane do niemutowalnego `ChatMessageAttachment`, także dla historii i
  potwierdzenia wysyłki.
- Dodano mały port `ChatAttachmentSessionRepository` z domenowym snapshotem
  sesji. `ChatRepositoryImpl` jest jedynym adapterem typed API; nie dodano
  kolejki uploadu, ticketów Storage, Cubita ani integracji UI.

### Walidacja 7C

- `flutter test test/workspaces/data/chat/chat_repository_impl_test.dart test/workspaces/data/chat/chat_attachment_transport_contract_test.dart` — 8 sukcesów: JSON session/payload/attachments, dokładne create/cancel oraz zachowanie kolejności IDs podczas send.
- `flutter analyze` — brak problemów.
- `git diff --check` — sukces.

### Następny krok

Zbudować lokalnego ownera kolejki w `domain/chat/attachments` i Cubicie
composera: jedna sesja na composer, ticket/complete Storage z `resourceId`
sesji, polling `Clean+Ready`, retry zachowujący UUID i DELETE przy cancel/revoke.
Nie podłączać tego bez odrębnych testów kolejki oraz bez aktualizacji realtime
dla `message.attachments`.

## Pakiet 7E-B — kolejka wielu załączników bez integracji composera

- `ChatAttachmentUploadQueueCubit` jest ownerem jednej kolejki composera i
  przyjmuje wyłącznie `ChatAttachmentSelectionReady` z 7A, więc limity wyboru
  nie są ponownie implementowane ani omijane przez widget.
- Kolejka tworzy niezależnego ownera 7D dla każdego zaakceptowanego pliku.
  Uploady i polling biegną równolegle, natomiast `ChatAttachmentPreparedFile`
  jest emitowany wyłącznie po pełnym powodzeniu i w kolejności pierwotnego
  wyboru. Stan ready nie przenosi ticketów, presigned URL-i ani danych pliku.
- Błąd dowolnego ownera fail-closed unieważnia wszystkie sesje. `revoke` i
  `close` robią to samo; generation guard tłumi spóźnione wyniki pollingu.
- `markConsumedAfterConfirmedSend` wymaga dokładnej, uporządkowanej listy UUID
  z potwierdzonego send. Dopiero wtedy oznacza każdą sesję jako consumed i
  zamyka ownerów; callback częściowy lub powtórzony nie wykonuje mutacji.
- Nie podłączono composera ani widgetów. Przyszły composer ma wywołać tę metodę
  wyłącznie po zaakceptowanej odpowiedzi create-message i przesłać `files` w
  niezmienionej kolejności.

### Walidacja 7E-B

- Deterministyczne fake ownerów testują: ukończenie poza kolejnością,
  fail-closed cancel po błędzie jednego pliku, revoke w czasie pollingu oraz
  dokładnie jednokrotne oznaczenie sesji po potwierdzonym send.
- `flutter test test/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit_test.dart test/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_queue_cubit_test.dart` — sukces.

## Pakiet 7E-C — owner załączników composera bez widgetów

- `ChatAttachmentComposerCoordinatorCubit` posiada selection 7A i kolejkę
  7E-B. Przyszły picker przekazuje do niego neutralne `StorageUploadInput`; UI
  nie zarządza sesjami, pollingiem ani UUID.
- Przed nową generacją coordinator czyści identyfikatory draftu. Wpisuje je
  z powrotem wyłącznie po pełnym `ChatAttachmentUploadQueueReady`, w kolejności
  pierwotnego wyboru. Wynik starej generacji nie może wskrzesić UUID po revoke.
- `markConsumedAfterConfirmedSend` wymaga identycznej, uporządkowanej listy z
  zaakceptowanej odpowiedzi backendu i deleguje consumption tylko raz. Błąd
  wysyłki oraz retry nie zmieniają snapshotu ani sesji.
- 401/403, realtime revoke, ręczne revoke i close anulują kolejkę, utylizują
  lokalny selection oraz czyszczą identyfikatory przez mały callback
  `ChatAttachmentDraftUpdater`. `ChatComposerCubit.updateAttachmentIds` może
  zostać przekazany do niego przez przyszły owner composera, ale nie podłączono jeszcze picker UI
  ani logiki transportowej do widgetów.

### Walidacja 7E-C

- Test fake ownerów pokrywa kolejność ready w drafcie, jednokrotne consumption
  po sukcesie, zachowanie UUID przy failure/retry, cleanup revoke i tłumienie
  spóźnionego wyniku kolejki.

## Pakiet 7E-D — podpięcie composera do potwierdzenia dostawy

- `ChatMessageDeliveryQueue.confirmations` emituje mały,
  `ChatMessageDeliveryConfirmation` tylko po zweryfikowanym potwierdzeniu
  create-message. Przenosi stabilny `clientMessageId` i ten sam uporządkowany
  snapshot `attachmentFileIds`, który został zawarty w hash oraz request.
  Retry używa bez zmian UUID, hash i listy; błąd ani optimistic enqueue nie
  emitują confirmation i nie konsumują sesji.
- `ChatConversationCubit` wystawia ten stream bez znajomości widgetów.
  `ChatMessageComposer` subskrybuje go i tworzy własny coordinator tylko z
  wstrzykniętym `ChatAttachmentUploadPort`; future picker otrzymuje ownera
  przez celowany callback, bez platformowego kodu pickera, HTTP ani singletona.
- `WorkspacesModuleBindings` tworzy adapter sesji Chat/Storage/presigned PUT,
  a `ReadyNextApp` przekazuje abstrakcyjny port przez provider. Widoki pełnego
  czatu i panelu przekazują tylko port oraz stream aktualnej rozmowy.
- Detach 401/403, explicit revoke i dispose composera anulują sesje i czyszczą
  UUID draftu zanim zamkną lokalny Cubit composera.

### Walidacja 7E-D

- Test dostawy sprawdza, że failure/retry nie emituje confirmation przed
  sukcesem oraz że obie próby zachowują ordered attachment IDs.
- Test widgetowy pokrywa jednokrotne consumption po confirmation i cancel
  gotowej sesji przy `ChatConversationDetached`.

### Korekta P0 7E-D — korelacja confirmation z UUID klienta

- Coordinator przechodzi po submit do jawnego stanu
  `AwaitingConfirmation(clientMessageId, attachmentIds)`. Consumption wymaga
  obu dokładnie zgodnych wartości; sam ordered snapshot plików nie jest już
  wystarczający.
- `ChatMessageDeliveryQueue.enqueue` zwraca UUID przez `ChatConversationCubit`
  do callbacku submit composera, który rejestruje go z bieżącym snapshotem.
  Dopóki confirmation nie nadejdzie, nowy selection/prepare jest blokowany,
  więc A nie może anulować sesji ani zostać zastąpione przez B. Retry zachowuje
  ten sam UUID i listę, failure nie zmienia `AwaitingConfirmation`.
- Deterministyczny test obejmuje A → próba B → błędny client UUID → retry →
  poprawne confirmation A; tylko ostatni krok konsumuje sesję.

## Korekta 3J — modal scan

- Bieżący skan ma 0 surowych `showDialog`/`showModalBottomSheet`/
  `showGeneralDialog` poza centralnym hostem. Storage Office został przeniesiony
  do `AppModalHost` z root policy.
- Pozostało 14 systemowych pickerów daty/czasu oraz 2 overlaye: anchored
  popover `app_search_dropdown` i root toast `app_bubble_toast`.

## Pakiet 7E-E — minimalny UX załączników composera

- Composer otrzymuje `FilePickerPort` z composition root i przekazuje neutralne
  `StorageUploadInput` wyłącznie do coordinatora. `DropTarget` obsługuje
  desktop/web bez transportu HTTP w widoku.
- Widok pokazuje chipy wybranych plików i status kolejki, umożliwia usunięcie
  pliku z fail-closed cleanupem oraz blokuje picker, drop i send podczas
  `AwaitingConfirmation`, przygotowania lub błędu.

## Pakiet 4C — session-owned Notifications (część 1)

- `AppGlobalShell` tworzy jeden `NotificationsCubit` na lifecycle prywatnej
  sesji i udostępnia go topbarowi, trasie oraz globalnemu panelowi.
- Topbar nie tworzy już `UnreadNotificationsCubit` per build; badge wybiera
  licznik z tego samego stanu, który renderuje inbox.
- Panel i strona wykorzystują ownera shellu, gdy są jego potomkami; fallback
  lokalny pozostaje wyłącznie dla samodzielnego renderowania poza shellem.
- Cubit uruchamia/zatrzymuje przekazany serwis realtime bez jego dispose.

### Walidacja

- `flutter analyze lib/app/shell lib/workspaces/presentation/notifications` — sukces.
- `flutter test test/workspaces/presentation/notifications test/app/shell/panels` — 13 sukcesów.

### Otwarte ograniczenia

- API faktycznie wspiera cursor dla grup i elementów, ale obecny kontrakt
  `NotificationsRepository` ukrywa cursor oraz nie wystawia itemów. Nie
  rozszerzano go bez osobnego, kompatybilnego kontraktu domenowego i testów.
- Pozostają osobne prace: cursor itemów/grup, typowany optimistic rollback,
  dedupe `eventId` w ownerze oraz pełna macierz session/badge/panel/reconnect.

### Ryzyka i dokładny następny krok

- Snapshoty są deterministycznymi asercjami geometrii; nie zastępują jeszcze
  plikowych raster goldenów 100%/125%/150%, dlatego ten checkbox planu pozostał
  otwarty. Należy dodać je tylko po uzgodnieniu stabilnego renderera fontów CI.
- Chat i Notifications zachowują bieżące wejścia; następny etap to wspólny host
  modalny (etap 3), a dopiero później persistent pane/globalny Chat. Nie należy
  przed tym podłączać nowych drawerów ani globalnego stanu rozmów.

## Pakiet 9A — cursorowy inbox Notifications

- `NotificationsRepository` wystawia typowane strony `CursorPageResponse` dla
  `/notifications` oraz `/notifications/groups`, z dokładnymi parametrami
  backendu: `cursor`, `limit`, `category`, `isUnreadOnly`.
- Jeden Cubit należący do `AppGlobalShell` utrzymuje niezależne kursory dla
  widoku grup i pojedynczych wpisów. Scala następne strony z deduplikacją po
  `groupKey` lub `id`; topbar, drawer i pełna trasa otrzymują ten sam snapshot.
- Inbox udostępnia filtr kategorii, przełącznik tylko nieprzeczytanych,
  przełączanie grup/wpisów oraz jawne „wczytaj więcej”. Przypięcie pojedynczego
  wpisu korzysta z istniejącej typed quick action; widok wpisów pokazuje pin.
- Mutacje read/archive/pin są optymistyczne i przy błędzie przywracają dokładny
  snapshot. `401`/`403` odrzucają snapshot prywatny i zatrzymują widoczność
  danych; nie ma fallbacku do cache. Deep link pozostaje jedynie nawigacją do
  docelowej trasy, która ponownie pobiera zasób przez jego własny autoryzowany
  endpoint — backend nie wystawia osobnego endpointu autoryzacji deep linku.
- Reconnect zachowuje kontrakt REST cursor i realtime replay; adapter realtime
  czyta teraz elementy strony grup zamiast traktować odpowiedź cursorową jak
  listę.

Walidacja 9A: `flutter analyze` dla zakresu Notifications oraz testy Cubita i
widgetu inboxa zakończone powodzeniem. Dodano dowód deduplikacji cursorowej.

### Korekta 9A — tożsamość zapytania przy zmianie filtrów i widoku

- `NotificationsCubit` ma monotoniczną generację query. Każda zmiana filtra
  albo widoku unieważnia trwające żądania; późne strony, odpowiedzi licznika i
  błędy poprzedniej generacji są odrzucane przed emisją stanu.
- Zmiana filtrów natychmiast czyści oba cache listy i ich kursory, więc UI nie
  opisuje poprzedniej kategorii jako nowej. Kolejne odświeżenie uruchamia się
  po zwolnieniu pojedynczego slotu żądania.
- Optimistic mutation także zachowuje generację: stary ACK/rollback nie może
  nadpisać później wybranego query. `401`/`403` dla aktualnego query nadal
  pozostają fail-closed.
- Test Cubita opóźnia stronę `loadMore`, zmienia kategorię i widok na wpisy,
  a następnie potwierdza brak chwilowej emisji starej strony grup.

## Pakiet 3A — wspólny host modalny

Zrealizowano pierwszą, małą porcję etapu 3. Nie zmieniano zachowania domenowego
Chat ani Notifications: ich dotychczasowe drawery otrzymały wyłącznie wspólną
warstwę prezentacji.

- Dodano `AppModalHost` w `app/shell/overlay/`. Jego jawna polityka
  `AppModalNavigatorScope.root|nested` domyślnie otwiera route w root
  navigatorze; zachowany parametr `useRootNavigator` współdzielonych API jest
  mapowany na tę politykę w jednym miejscu.
- Host centralizuje root/nested navigator, barrier z lokalizowanym label,
  scrim, wspólną animację side sheeta, `requestFocus`, Escape oraz odtworzenie
  focusu aktywatora po zamknięciu. Brak `AppLocalizations` w izolowanym teście
  ma bezpieczny fallback Material dla labelu bariery.
- Zmigrowano `AppModalSheet.show`, `AppModalSheet.showSideSheet`,
  `AppExpandableSideSheet.show` i `AppConfirmDialog.show`. Publiczne parametry
  tych widgetów zachowano.
- Dotychczasowe globalne funkcje otwierania drawerów zastąpiono nazwanymi
  klasami `AppGlobalChatDrawer` i `AppGlobalNotificationsDrawer`; topbar
  korzysta z ich metod statycznych. To usuwa niejawne `showGeneralDialog` z
  obu globalnych wejść bez implementowania nowych funkcji Chat/Notifications.
- `AppModalAccessibilityBoundary` pozostaje wyłącznie granicą focus/keyboard;
  host jest jedynym właścicielem route, bariery i animacji side sheeta.

### Inwentaryzacja i wyjątki

Wstępne `rg` wykrywa nadal szeroką historyczną powierzchnię bezpośrednich
`showDialog`, `showGeneralDialog` i `showModalBottomSheet` w modułach. Nie
przenoszono jej masowo: każda migracja musi mieć test regresji modułu.

- zmigrowane w tej porcji: wspólne modal sheet/expandable/confirm oraz globalne
  wejścia Chat i Notifications;
- pozostawione jawnie: `AppDraggableSheet` (`showModalBottomSheet`) i menu
  kontekstowe — wymagają osobnych kontraktów bottom-sheet/anchored-popover;
- pozostałe dialogi Workspaces, Inventory, BHP i Dashboard są ledgerem do
  migracji partiami; nie wolno oznaczać audytu wszystkich miejsc jako
  ukończonego przed ich testami.

### Pliki pakietu 3A

## Pakiet 7C — kolejka tymczasowych załączników Chat (handoff)

Backend 7B jest zaakceptowany. Flutter nie może już rezerwować `Storage Comment`
z UUID wiadomości przed wysłaniem. Najpierw należy odświeżyć wygenerowany klient
OpenAPI z backendowego Swaggera i zweryfikować dokładne typy dla:

- `POST /api/v1/chat/conversations/{conversationId}/attachment-sessions`,
  `DELETE .../{sessionId}` oraz odpowiedź z UUID sesji i expiry;
- `SendChatMessageRequest.attachmentFileIds` (uporządkowane UUID) i
  `ChatMessageResponse.attachments`;
- istniejącego ticketu/complete Storage, gdzie `resourceId` pliku Comment jest
  UUID sesji.

Implementować w `lib/workspaces/domain/chat/attachments` jako port kolejki i
model niemutowalnego elementu (local ID, server session ID, storage file UUID,
stan ticket/upload/scan/ready/failed/cancelled). Data repository ma wyłącznie
wywoływać typed OpenAPI. Cubit ma być ownerem całej orkiestracji: tworzy jedną
sesję per composer, zachowuje kolejność stabilnych Storage UUID, nie wysyła aż
wszystkie wybrane elementy nie mają `Clean+Ready`, odtwarza retry bez zmiany
UUID, a cancel/revoke wywołuje DELETE sesji i usuwa lokalne dane. Widgety tylko
renderują stan i delegują intencje.

`ChatAttachmentSelectionCubit` pozostaje lokalnym walidatorem 7A; kolejka 7C
subskrybuje jego zaakceptowane `StorageUploadInput`, nie umieszcza API ani
business flow w `ChatAttachmentSelectionList` lub composer widget. Draft może
przechowywać jedynie lokalne metadane/ID kolejki, nigdy presigned URL, tokenu ani
treści pliku. Przed submit composer przekazuje `attachmentFileIds` w tej samej
kolejności, a po odpowiedzi aktualizuje UI z `message.attachments`.

Dla Web/Desktop dodać neutralne `ChatAttachmentSelectionSource` implementacje
picker/drag-drop/paste tylko tam, gdzie obecne zależności je wspierają; nie
importować `dart:html`, interop trzymać poza widgetami i domeną. Należy testować
źródło oraz kolejkę: cross-session/revoke, cancel, retry, zachowanie kolejności,
Pending/Scanning/Failed, sukces Clean+Ready i brak API w widgetach.

- `lib/app/shell/overlay/app_modal_host.dart`
- `lib/shared/presentation/widgets/app_modal_accessibility_boundary.dart`
- `lib/shared/presentation/widgets/app_modal_sheet.dart`
- `lib/shared/presentation/widgets/app_expandable_side_sheet.dart`
- `lib/shared/presentation/widgets/app_confirm_dialog.dart`
- `lib/workspaces/presentation/chat/chat_drawer.dart`
- `lib/workspaces/presentation/notifications/global_notifications_page.dart`
- `lib/shared/presentation/widgets/app_global_utility_bar_parts.dart`
- `test/app/shell/overlay/app_modal_host_test.dart`

### Walidacja pakietu 3A

- `flutter gen-l10n`, `dart format` — sukces.
- `flutter analyze` (pełny projekt) — brak problemów.
- `flutter test test/app/shell/overlay/app_modal_host_test.dart
  test/shared/presentation/widgets/app_expandable_side_sheet_test.dart
  test/shared/presentation/widgets/app_modal_accessibility_boundary_test.dart
  test/shared/presentation/widgets/app_global_module_wrapper_test.dart
  test/shared/presentation/widgets/app_global_utility_bar_test.dart` —
  20 testów, sukces.

### Następny krok

Następna mała porcja ma rozszerzyć test realnego `MaterialApp.router` o trzy
API modalne, nested private child, hit-test bariery nad topbarem/railem/content,
Tab/Shift+Tab, Escape, restore focus, `popRoute` bez zmiany location i politykę
konkurencji dwóch paneli. Dopiero potem migrować bottom sheet i context menu
przez osobne kontrakty; nie wdrażać jeszcze Chat.

## Pakiet 3B — koordynacja sesji i bottom sheet

- `AppGlobalShell` jest właścicielem `AppModalCoordinator`, przekazywanego
  potomkom przez `AppModalCoordinatorScope`. To lokalny stan prezentacji, nie
  singleton ani stan biznesowy: drugi równoległy request modalny jest jawnie
  odrzucany, a slot wraca po zakończeniu route'u.
- `AppModalHost` obsługuje teraz dialog, side sheet i bottom sheet. Wspólny
  focus restore sprawdza, czy origin focus node nadal jest zamontowany, i
  przywraca go dopiero po następnej klatce po zdjęciu route'u.
- `AppDraggableSheet` korzysta z hosta, z root navigator jako domyślną
  polityką i jawnym parametrem kompatybilności `useRootNavigator`.
- `AppModalSheet.showSideSheet` klamruje szerokość do ograniczeń po `SafeArea`,
  więc compact viewport nie może dostać szerokości większej od obszaru route'u.

### Walidacja 3B

- `flutter analyze` dla hosta, shellu, draggable/modal sheetów i testów — brak
  problemów.
- `flutter test test/app/shell/overlay/app_modal_host_test.dart
  test/shared/presentation/widgets/app_expandable_side_sheet_test.dart` —
  sukces. Test hosta potwierdza Escape, Tab/Shift+Tab poza aktywatorem,
  restore focus i odrzucenie drugiego równoległego modalu.

### Nadal otwarte przed akceptacją etapu 3

Brakuje jeszcze wymaganej macierzy realnego `MaterialApp.router` z nested
private child i trasami publicznymi, hit-testu bariery dla dialog/side/bottom
sheet nad topbarem/railem/content oraz `popRoute` bez zmiany location. Te
testy trzeba dodać przed uznaniem etapu 3 za ukończony.

## Pakiet 3C — propagacja koordynatora do root overlay

`AppModalHost` opakowuje teraz każdy własny dialog, side sheet i bottom sheet
tym samym `AppModalCoordinatorScope`, który odczytał z prywatnego shella.
Dzięki temu wywołanie hosta z buildera route'u umieszczonego w root overlay nie
traci sesyjnej polityki jednego panelu. Lock jest zwalniany natychmiast po
zakończeniu future route'u, przed odroczonym restore focus; callback focusu
sprawdza unmount origin node. Test hosta otwiera drugi modal z rzeczywistego
root-overlay contextu, potwierdza odrzucenie, następnie zamyka pierwszy i
otwiera kolejny. `flutter analyze` i test hosta: sukces.

## Pakiet 3D — macierz trzech API nad prywatnym shellem

Rozszerzono istniejący test prawdziwego `GoRouter` z `ShellRoute` i
`AppGlobalShell`. Sekwencyjnie otwiera on `AppModalHost.showDialog`,
`AppModalSheet.showSideSheet` oraz `AppDraggableSheet.show` z private routed
content. Dla każdego sprawdzona jest rootowa `ModalBarrier` nad topbarem,
railem i contentem; dla niedismissible side/bottom sheeta kliknięcia topbara i
raila nie uruchamiają akcji pod spodem. Bottom sheet ma `barrierDismissible:
false`, aby testował hit-test zamiast jego prawidłowego dismiss.

`flutter test test/shared/presentation/widgets/app_global_module_wrapper_test.dart`
— 14 testów, sukces; `git diff --check` — sukces. Nadal brakuje oddzielnej
macierzy nested/private/public i `popRoute`, więc etap 3 pozostaje niegotowy.

## Pakiet 3E — routing, focus i konkurencja globalnych paneli

Wydzielono testy root overlay do
`test/app/shell/overlay/app_modal_router_test.dart`. Mały harness `GoRouter`
zawiera publiczne `/login` oraz `/storage/public/:shareToken`, a prywatna
`ShellRoute` ma osobny navigator i sesyjny `AppModalCoordinator`.

Macierz obejmuje `AppModalHost.showDialog`, `AppModalSheet.showSideSheet` i
`AppDraggableSheet.show`, wywołane z private child route. Dla każdego wariantu
potwierdza rootową `ModalBarrier` nad topbarem, railem i contentem, blokadę
hit-testu tła, zamknięty cykl Tab/Shift+Tab, Escape, odtworzenie focusu
aktywatora oraz zachowanie URI z query i fragmentem. Osobny przypadek
potwierdza `popRoute` na nested private route bez zmiany location, a publiczne
login/share nie montują prywatnego shellu. Test konkurencji otwiera kolejno
wejścia oznaczone jako Czat/Powiadomienia i potwierdza, że koordynator odrzuca
drugi root overlay aż do zamknięcia pierwszego.

Testy 3E ujawniły i doprowadziły do poprawienia dwóch P0 w `AppModalHost`:

- dialog i bottom sheet nie miały `AppModalAccessibilityBoundary`, przez co
  Escape nie działał jednolicie;
- focus originu był odczytywany po wywołaniu materialowego `show*`, czyli już
  po przejściu focusu do modalu. Host przechwytuje go teraz przed otwarciem
  route'u i przywraca po jego zamknięciu.

### Walidacja 3E

- `dart format test/app/shell/overlay/app_modal_router_test.dart` — sukces.
- `flutter test test/app/shell/overlay/app_modal_router_test.dart` — 9 testów,
  sukces.
- `flutter analyze` — brak błędów dla pakietu; pozostało 11 równoległych
  informacji lint w plikach Chat thread, poza zakresem 3H.
- `flutter test test/app/shell/overlay/app_modal_host_test.dart
  test/app/shell/overlay/app_modal_router_test.dart` — 11 testów, sukces.
- `git diff --check` — sukces.
- `graphify update .` — pominięte: binarium `graphify` nie jest dostępne w
  środowisku wykonawczym.

## Pakiet 3F — domknięcie tras publicznych, scope nested i realnego shellu

Uzupełniono dowody 3E, aby test imitującego chrome'u nie był jedynym źródłem
pewności dla polityki globalnych paneli.

- `app_modal_router_test.dart` otwiera i zamyka dialog, side sheet i bottom
  sheet na obu trasach publicznych: `/login` oraz
  `/storage/public/:shareToken`. Każdy przypadek potwierdza brak prywatnego
  shellu, obecność modalu i powrót do tej samej publicznej strony.
- Świadomy wariant `navigatorScope: AppModalNavigatorScope.nested` z private
  child route potwierdza lokalny z-order: bariera pokrywa content child route,
  ale nie topbar ani rail. To jest kontrakt wyjątku; domyślny root scope nadal
  ma osobne testy nad całym chrome'em.
- `app_global_shell_modal_integration_test.dart` montuje prawdziwy
  `AppGlobalShell` w `GoRouter` wraz z realnymi publicznymi API
  `AppGlobalChatDrawer` i `AppGlobalNotificationsDrawer`. Test sprawdza, że
  Chat blokuje równoległe Notifications, Escape zwalnia slot, a Notifications
  mogą zostać otwarte później bez zmiany URI.
- Rozdzielono `app_global_module_wrapper_test.dart`: testy rzeczywistego
  `AppRouter` są w `test/app/shell/app_router_shell_test.dart`, a wspólne fake
  zależności są klasami w `test/app/shell/support/shell_test_dependencies.dart`.
  Historyczny plik widgetu ma teraz tylko testy geometrii i raila.

### Walidacja 3F

- `flutter analyze` dla plików testowych shellu — brak problemów.
- `flutter test test/app/shell/overlay/app_modal_router_test.dart` — 12
  testów, sukces.
- `flutter test test/app/shell/overlay/app_global_shell_modal_integration_test.dart
  test/app/shell/app_router_shell_test.dart
  test/shared/presentation/widgets/app_global_module_wrapper_test.dart` — 13
  testów, sukces.
- `flutter analyze` — brak problemów.
- Pełny scoped zestaw shellu (host, router, integracja prawdziwego shellu i
  geometria) — 28 testów, sukces.
- `git diff --check` — sukces.
- `graphify update .` — pominięte: binarium `graphify` nie jest dostępne w
  środowisku wykonawczym.

## Pakiet 4A — sesyjny host paneli i przypięty Chat

Zrealizowano produkcyjny fundament etapu 4, bez rozszerzania domenowego
kontraktu Chat ani Notifications.

- `AppGlobalShell` jest właścicielem małego
  `AppGlobalPanelsController`; kontroler jest tworzony i niszczony wraz z
  prywatną sesją shell route, nie jest singletonem i nie zna repository,
  transportu ani danych biznesowych.
- Akcje Chat i Notifications z `AppShellTopBar` przekazują sterowanie do
  shella. Przy dostępnym repozytorium nie zmieniają `AppRouter` ani URI; przy
  niedostępnym zachowują istniejący fallback do pełnych tras `/chat` i
  `/notifications`.
- Na wide viewport Chat jest przypiętym pane'em: `Stack` rezerwuje jego
  szerokość przez `Positioned.fill.right`, więc trasowana treść nie pozostaje
  pod pane'em. Uchwyt przy lewej krawędzi zmienia szerokość tylko w zakresie
  320–560 px i zapisuje ją po zakończeniu przeciągania. Compact i medium
  używają istniejącego modalnego root side sheeta.
- Przełączenie Chat → Notifications lub zamknięcie ukrywa przypięty pane, ale
  nie niszczy preferencji przypięcia. Dzięki temu stan widoczności jest
  sesyjny, a preferencja osobista pozostaje lokalna.
- `LocalSettingsModel`, adapter Hive i `LocalSettingsCubit` przechowują
  `globalChatPinned`, `globalChatWidth` i identyfikator ostatniej rozmowy.
  Repozytorium normalizuje szerokość i pusty identyfikator; adapter pozostaje
  kompatybilny z istniejącymi zapisami bez pól 6–8.
- `AppGlobalChatPanel` jest wspólną treścią dla root side sheeta i persistent
  pane. W persistent pane kliknięcie rozmowy nie popuje root navigatora,
  zapisuje ostatnią rozmowę i przechodzi przez zachowany deep link
  `/chat/conversations/:conversationId`. W overlay zachowane jest poprzednie
  zamknięcie sheeta przed nawigacją.
- Widoczne teksty przeniesione w panelach Chat/Notifications otrzymały wpisy
  PL/EN w ARB; uruchomiono generator lokalizacji.

### Pliki pakietu 4A

- `lib/app/shell/app_global_shell.dart`
- `lib/app/shell/panels/app_global_panels_controller.dart`
- `lib/app/shell/panels/app_global_panels_scope.dart`
- `lib/workspaces/presentation/chat/chat_drawer.dart`
- `lib/workspaces/presentation/notifications/global_notifications_page.dart`
- `lib/features/settings/domain/local_settings_model.dart`
- `lib/features/settings/application/local_settings_cubit.dart`
- `lib/features/settings/data/repositories/local_settings_repository.dart`
- `lib/core/storage/hive_helper.g.dart`
- `lib/l10n/app_pl.arb`, `lib/l10n/app_en.arb` oraz wygenerowane lokalizacje
- `test/app/shell/panels/app_global_panels_controller_test.dart`

### Walidacja 4A

- `flutter gen-l10n` — sukces.
- `dart format` dla zmienionych źródeł i testu kontrolera — sukces.
- `flutter analyze` (pełny projekt) — brak problemów.
- `flutter test test/app/shell/panels/app_global_panels_controller_test.dart
  test/app/shell/overlay/app_global_shell_modal_integration_test.dart
  test/app/shell/overlay/app_modal_router_test.dart
  test/app/shell/top_bar/app_shell_top_bar_test.dart
  test/app/router/app_deep_link_test.dart test/app/router/app_route_paths_test.dart
  test/app/router/auth_redirect_policy_test.dart
  test/shared/presentation/widgets/app_global_utility_bar_test.dart` —
  64 testy, sukces.
- `git diff --check` — sukces.

### Otwarte ryzyka i dokładny następny krok

- Etap 4 nie jest jeszcze ukończony i jego checkboxy w planie pozostają
  niezmienione: Chat nie ma jeszcze własnego źródła unread badge, statusu
  offline/reconnect ani współdzielonego stanu domenowego z pełną trasą.
  Notifications nadal mają dotychczasowy licznik oraz loading/error, ale nie
  są jeszcze jednym sesyjnym Cubitem z pane'em.
- Należy dodać widgetową macierz prawdziwego `AppGlobalShell`, która klika
  akcję topbara na wide/compact, mierzy zarezerwowaną szerokość i potwierdza
  Chat ↔ Notifications bez zmiany URI. Test powinien użyć istniejących
  atrap repository i pozostać poza plikami testów modali etapu 3.
- Następnie można wydzielić w `workspaces/presentation/chat/shell/` lokalny
  owner listy/wyboru rozmowy oraz oddzielny owner unread/reconnect, zamiast
  rozbudowywać `ChatDrawerCubit` lub `AppGlobalPanelsController`.

## Pakiet 3G — ledger i Storage Sharing

Ten pakiet nie zmienia `lib/app/shell`, Chat, Notifications ani testów agenta
etapu 4. Pełny, odtwarzalny ledger 104 punktów modalnych/pickerów/overlayów,
klasyfikację i P0 zapisano w
`docs/global-shell-modal-ledger-2026-09-13.md`.

- `StorageSharingDialog.show` korzysta teraz z `AppModalHost.showDialog` z
  domyślnym root navigator. Nie zmienia API dialogu ani jego Cubitów/repository;
  host jest wyłącznie właścicielem route'u, bariery, Escape i focusu.
- Nowy test uruchamia dialog z nested Navigatora oraz potwierdza rootowy route,
  barierę blokującą tło i zamknięcie Escape. Test izoluje tylko presentation
  poprzez atrapę repository; UI nie wykonuje żadnego API bezpośrednio.
- W Storage pozostaje 14 surowych route'ów i jeden date picker. Najwyższy P0 w
  tym module to bottom sheet menu kontekstowego w
  `storage/browser/grid/storage_file_grid.dart`, bo domyślnie wybiera nearest
  navigator i może znaleźć się pod topbarem/railem.

### Walidacja 3G

- `dart format lib/workspaces/presentation/storage/sharing/widgets/storage_sharing_dialog.dart
  test/workspaces/presentation/storage/sharing/storage_sharing_dialog_modal_host_test.dart`
  — sukces.
- `flutter test test/workspaces/presentation/storage/sharing/storage_sharing_dialog_modal_host_test.dart`
  — sukces.

### Dokładny następny krok

Zmigrować **wyłącznie** `storage_file_grid.dart` context action sheet przez
`AppModalHost.showBottomSheet` (root scope), zachowując jego API, oraz dodać
test realnego private shellu z hit-testem bariery nad topbarem i railem. Dopiero
potem kontynuować pozostałe 13 route'ów Storage; nie przenosić pickerów ani
anchored popovera w tym samym pakiecie.

## Pakiet 3H — dialogi galerii frameworkowej

- `FrameworkComponentsGalleryPage` nie wywołuje już bezpośrednio
  `showDialog`: preview pełnoekranowej tabeli oraz modal ze stanami lokalnego
  Cubita korzystają z `AppModalHost.showDialog` z domyślną polityką root.
- Publiczne, nazwane akcje prezentacyjne strony są jedynym wejściem obu
  preview; UI deleguje do nich bez własnego route/focus lifecycle, dzięki czemu
  test wykonuje dokładnie te same wywołania co galeria.
- Zachowano modalny lifecycle Cubita, brak API/biznesu w UI i dotychczasową
  semantykę `barrierDismissible: false` dla flow BLoC.
- Zaktualizowano ledger: dwa surowe dialogi galerii są zamknięte; nie oznacza
  to migracji innych dialogów frameworku ani globalnego audytu.

### Walidacja 3H

- `dart format` dla galerii i testu — sukces.
- `flutter test test/features/framework/presentation/framework_components_gallery_modal_host_test.dart` — 2 sukcesy. Prawdziwy `MaterialApp.router` z rootowym i nested private navigatorem otwiera oba dokładne entry pointy galerii; test sprawdza rootową barierę nad topbarem/railem, dismissible fullscreen preview, non-dismissible modal BLoC, Escape, restore focus i niezmieniony URI.
- `flutter test test/workspaces/presentation/storage/browser/grid/storage_file_grid_modal_host_test.dart` — sukces. Korekta 3H usuwała równoległą regresję kompilacji P0 Storage: `AppModalHost.showBottomSheet` otrzymał wymagany pozycyjny context, a test nie używa nieprawidłowego `const`.
- `flutter analyze` — brak problemów.

## Pakiet 3I — Storage grid preview

- `_FileGridCard._openPreview` używa `AppModalHost.showDialog` z domyślną
  polityką root zamiast bezpośredniego `showDialog`. Istniejący
  `StoragePreviewCubit` jest nadal przekazywany przez `BlocProvider.value`;
  modal nie przejmuje jego lifecycle ani nie wywołuje API z UI.
- Bezpośredni test Storage grid uruchamia preview z nested navigatora i
  potwierdza rootowy route, barierę blokującą tło, Escape oraz brak popu
  nested route. Ten sam test zachowuje regresję P0 context bottom sheeta.
- Ledger zmniejsza pozostałą powierzchnię Storage o dialog preview oraz
  przeniesiony wcześniej sheet menu; nie obejmuje pozostałych dialogów,
  pickerów ani context menu innych widoków Storage.

### Walidacja 3I

- `dart format` dla gridu i testu — sukces.
- `flutter analyze lib/workspaces/presentation/storage/browser/grid/storage_file_grid.dart test/workspaces/presentation/storage/browser/grid/storage_file_grid_modal_host_test.dart` — brak problemów.
- `flutter test test/workspaces/presentation/storage/browser/grid/storage_file_grid_modal_host_test.dart` — 2 sukcesy.

## Pakiet 4B — rozmowa Chat wewnątrz panelu

Poprawiono krytyczną semantykę globalnego Chat: wybór rozmowy w persistent
pane ani modalnym side sheecie nie przechodzi już do `/chat/conversations/:id`
i nie opuszcza widoku pliku, taska ani innej bieżącej trasy.

- Dodano `ChatPanelSelectionCubit` w
  `workspaces/presentation/chat/shell/cubit/`. Jest lokalny dla jednego
  egzemplarza `AppGlobalChatPanel`, zawiera wyłącznie wybraną rozmowę i nie
  zna API, routera ani globalnego lifecycle.
- Dodano `ChatPanelConversation`: mały widok treści jednej rozmowy z własnym
  `ChatConversationCubit` o lifecycle ograniczonym do wybranej rozmowy.
  Pobieranie i wysłanie są nadal zamknięte w istniejącym Cubicie; widget tylko
  uruchamia jego lifecycle, bez bezpośredniego wywołania repository/API.
- `AppGlobalChatPanel` łączy niezależne Cubity listy i selekcji. Klik rozmowy
  zapisuje preferencję ostatniej rozmowy i wybiera ją in-place; przycisk
  powrotu wraca do listy bez zmiany URI.
- Dodano jawną akcję „Otwórz pełny widok”. Tylko ona przechodzi do
  `/chat/conversations/:conversationId`; w modalnym overlay najpierw zamyka
  sheet, a w persistent pane zamyka pane. Zachowano pełne trasy dla deep
  linków i pracy w osobnym widoku.
- Dodano ARB PL/EN dla nagłówka rozmowy, powrotu, pełnego widoku, composera,
  wysłania oraz usuniętej wiadomości; uruchomiono `flutter gen-l10n`.

### Pliki pakietu 4B

- `lib/workspaces/presentation/chat/chat_drawer.dart`
- `lib/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart`
- `lib/workspaces/presentation/chat/shell/chat_panel_conversation.dart`
- `lib/app/shell/app_global_shell.dart`
- `lib/l10n/app_pl.arb`, `lib/l10n/app_en.arb` oraz wygenerowane lokalizacje

### Walidacja 4B

- `flutter gen-l10n` i `dart format` — sukces.
- `flutter analyze lib/app/shell lib/workspaces/presentation/chat
  lib/features/settings lib/l10n` — brak problemów.
- `flutter test test/app/shell/panels/app_global_panels_controller_test.dart
  test/app/shell/overlay/app_global_shell_modal_integration_test.dart
  test/workspaces/presentation/chat
  test/app/shell/overlay/app_modal_router_test.dart` — 20 testów, sukces.
- `git diff --check` — sukces.
- Pełne `flutter analyze` jest chwilowo czerwone przez niezależny plik testowy
  `test/workspaces/presentation/storage/sharing/storage_sharing_dialog_modal_host_test.dart`
  (brak importu/definicji `StorageFileResponse`, linia 111); nie zmieniano go,
  ponieważ nie należy do pakietu ani do testów kontrolowanych przez tego
  wykonawcę.

### Następny krok

Należy odebrać osobną macierz widgetową wide/compact: wybór rozmowy w panelu
ma zachować URI, persistent pane ma rezerwować content, a viewport 320 px nie
może overflowować. Potem należy zdecydować o współdzielonym ownerze unread i
reconnect bez przenoszenia ich do `ChatPanelSelectionCubit`.

## Pakiet 4D — odporna skrzynka Notifications

Domknięto małą porcję niezawodności istniejącego inboxa bez tworzenia nowego
globalnego stanu biznesowego i bez wywołań API z UI.

- `NotificationsCubit` zachowuje ostatni autoryzowany snapshot przy przejściowym
  błędzie odświeżenia, wraz z badge, i przekazuje `refreshError` do UI. Błędy
  `401/403` pozostają fail-closed: snapshot nie jest przywracany.
- `markAllRead`, `markGroupRead` oraz `archiveGroup` emitują stan optymistyczny
  przed ACK. Przy błędzie połączenia przywracają dokładny snapshot z
  nieblokującym `refreshError`; przy odebraniu dostępu usuwają snapshot przez
  typowany stan forbidden/unauthorized.
- Burst odświeżeń jest scalany: podczas jednego requestu rejestrowany jest
  tylko jeden follow-up po jego zakończeniu. `close()` zatrzymuje realtime przez
  `stop()`, lecz nie wywołuje `dispose()` na współdzielonym serwisie sesji.
- Dodano mały `NotificationsRealtimeStatusCubit`, który wyłącznie obserwuje
  istniejący `connectionStates`. Nie inicjuje huba ani nie jest właścicielem
  API. UI pokazuje lokalizowany, nieblokujący banner connecting/reconnecting/
  offline, a `refreshError` jest widoczny nad zachowaną listą lub stanem empty.
- Rozszerzono programowalną atrapę repository o `Completer` dla mutacji i
  requestu listy. Testy potwierdzają optymizm przed ACK i rollback dla grupy,
  fail-closed archive forbidden, zachowanie snapshotu po quick action oraz
  dokładnie jeden follow-up dla burstu.

### Pliki pakietu 4D

- `lib/workspaces/presentation/notifications/cubit/notifications_cubit.dart`
- `lib/workspaces/presentation/notifications/cubit/notifications_state.dart`
- `lib/workspaces/presentation/notifications/cubit/notifications_realtime_status_cubit.dart`
- `lib/workspaces/presentation/notifications/global_notifications_page.dart`
- `lib/l10n/app_pl.arb`, `lib/l10n/app_en.arb` oraz wygenerowane lokalizacje
- `test/workspaces/presentation/notifications/notifications_cubit_test.dart`

### Walidacja 4D

- `flutter gen-l10n` i `dart format` — sukces.
- `flutter test test/workspaces/presentation/notifications/notifications_cubit_test.dart`
  — 11 testów, sukces.
- `flutter analyze lib/workspaces/presentation/notifications
  test/workspaces/presentation/notifications/notifications_cubit_test.dart` —
  brak problemów.
- `flutter analyze` (pełny projekt) — brak problemów.
- `git diff --check` — sukces.

### Otwarte granice

Ten pakiet nie realizuje etapu 9: nie dodaje cursor pagination, pełnych quick
actions, preferencji ani globalnego domain Cubita. Chat nadal wymaga etapu 5
dla stabilnego UUID `clientMessageId`, kolejki offline, retry i replay bez
pełnego odświeżania; nie wolno deklarować pełnego klienta Chat na podstawie
panelu z etapu 4.

### Errata 4D — zwarty banner w panelu

Pierwsza wersja bannera używała `MaterialBanner` z pustą listą akcji. Flutter
wymaga co najmniej jednej akcji, co powodowało assert i następnie overflow w
medium root side sheecie. Zastąpiono go ograniczonym `DecoratedBox` z ikoną,
dwuliniowym tekstem i semantics `liveRegion`; nie ma pozorowanej akcji ani
nie blokuje zawartości inboxa. Przy okazji licznik nieprzeczytanych otrzymał
ARB PL/EN i `Expanded` z ellipsis, więc 320 px nie overflowuje.

- `flutter test test/app/shell/panels/app_global_shell_panels_test.dart
  --plain-name 'medium Chat i powiadomienia są root overlayami i blokują content'`
  — sukces.
- `flutter test test/workspaces/presentation/notifications
  test/app/shell/panels test/app/shell/overlay` — 36 testów, sukces.
- Dodano `global_notifications_page_test.dart`: compact 320 px zachowuje
  snapshot inboxa, pokazuje lokalizowany banner offline i nie zgłasza wyjątku
  renderera.
- `flutter analyze` i `git diff --check` — sukces.

## Incydent 4B — przerwana edycja `chat_drawer.dart`

Przerwany proces pozostawił niedomknięte `BlocBuilder`/`BlocListener`/
`Expanded` w `_ChatDrawerContent` (pierwotnie linie 180–184), przez co plik nie
przechodził parsera Darta. Naprawa ograniczyła się do przywrócenia brakujących
nawiasów i wcięć wokół istniejącego `switch` stanu listy rozmów. Nie zmieniono
logiki wyboru in-place, responsywnego persistent pane, API, repository ani
Cubitów.

### Walidacja incydentu

- `dart format lib/workspaces/presentation/chat/chat_drawer.dart` — sukces.
- pełne `flutter analyze` — brak problemów.
- `flutter test test/app/shell/panels test/app/shell/overlay
  test/workspaces/presentation/chat` — **25 sukcesów, 1 błąd**.

Pozostały błąd jest niezależną regresją responsywnej geometrii 4B:
`test/app/shell/panels/app_global_shell_panels_test.dart:354`, przypadek
`resize wide do compact nie pozostawia ujemnej geometrii contentu`. Po resize
1280→320 `AppShellMetrics.routedContentKey` ma `width == 0.0` (oczekiwano `> 0`).
To blokuje odbiór 4B i wymaga osobnej poprawki layoutu persistent pane/compact,
nie dalszej edycji `chat_drawer.dart`.

## Poprawka P0 4B — resize persistent pane do compact

Przy resize wide→compact `AppGlobalShell` rezerwował szerokość persistent pane
niezależnie od breakpointu. Przy 320 px sumował szerokość raila i 384 px Chatu,
co dawało trasowanemu contentowi szerokość `0`.

- Rezerwacja `right` i sam `_PinnedChatPane` są teraz renderowane wyłącznie na
  `AppShellViewport.wide`. Pierwsza klatka po resize natychmiast odzyskuje
  dodatnią szerokość contentu.
- Jeśli aktywny był persistent Chat, shell planuje jego zamknięcie po klatce
  przez lokalny owner `_AppGlobalShellState`; nie otwiera modalu ani nie zmienia
  stanu synchronicznie w `build`. Preferencja `globalChatPinned`, szerokość i
  URI pozostają zachowane. Stan po przejściu jest jednoznacznie `closed`.
- Domknięto przekazanie `globalChatLastConversationId` do persistent pane'u i
  modalnego drawera. Istniejący `ChatPanelSelectionCubit` odtwarza rozmowę po
  załadowaniu listy, nadal bez zmiany trasy.
- Dodano regresję: ostatnia rozmowa otwiera się w przypiętym panelu przy
  zachowaniu URI. Nie zmieniono testu, który wykrył P0.

### Walidacja poprawki P0

- `flutter analyze` — brak problemów.
- `flutter test test/app/shell/panels test/app/shell/overlay
  test/workspaces/presentation/chat` — 28 testów, sukces.
- `git diff --check` — sukces.

## Pakiet 5A — domenowy pion historii i idempotentnej dostawy Chat

Wdrożono celowo mały pion klienta rozmowy; lista globalnego drawera zachowuje
dotychczasowy kontrakt, więc nie rozszerzono scope'u o migrację całego Chat.

- Dodano niezależny od Retrofit kontrakt
  `ChatConversationRepository`: snapshot rozmowy, cursorową stronę historii i
  idempotentną wysyłkę. Modele domenowe znajdują się w drzewie
  `workspaces/domain/chat/conversation/`; prezentacja nie czyta DTO transportu
  wiadomości.
- `ChatRepositoryImpl` implementuje nowy kontrakt i mapuje `ChatApi` poza UI.
  Cursor i `nextCursor` są zachowane; wywołanie wysyłki przekazuje stabilny
  `clientMessageId`, tekst, delta i reply.
- `ChatMessageDeliveryQueue` jest małym, lokalnym ownerem dostawy, a nie
  częścią `ChatConversationCubit`. Tworzy UUID v4 bez DateTime ID, oblicza
  SHA-256 zgodny z backendem (`text\\ndeltaJson\\nreplyToMessageId`), zachowuje
  UUID/hash przy retry i wykrywa sprzeczne potwierdzenie backendu.
- `ChatConversationCubit` utrzymuje snapshot, cursorową paginację i scalanie
  bez duplikatów po `id` albo `clientMessageId`. Wiadomość pozostaje w historii
  jako `sending` albo `failed`, a retry kończy ją jako `sent`; błąd wysłania nie
  zastępuje całej historii stanem failure.
- 401/403 emitują typowy `ChatConversationDetached`, czyszczą lokalną kolejkę i
  odsubskrybowują realtime. Cubit wywołuje `stop()`, nigdy `dispose()` na
  otrzymanym serwisie realtime, więc nie zamyka współdzielonego właściciela.
- Aplikacja rejestruje nowy kontrakt w providerach. Panel legacy, który otrzyma
  wyłącznie atrapy listy drawera, renderuje bezpieczny nagłówek bez próby API;
  produkcyjna implementacja zawsze otrzymuje pion 5A.

### Pliki pakietu 5A

- `lib/workspaces/domain/chat/conversation/`
- `lib/workspaces/data/chat/repositories/chat_repository_impl.dart`
- `lib/workspaces/presentation/chat/conversation_delivery/`
- `lib/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart`
- `lib/workspaces/presentation/chat/cubit/chat_conversation_state.dart`
- `lib/workspaces/presentation/chat/chat_conversation_page.dart`
- `lib/workspaces/presentation/chat/shell/chat_panel_conversation.dart`
- `lib/workspaces/presentation/chat/chat_drawer.dart`
- `lib/app/ready_next_app.dart`
- `test/workspaces/data/chat/chat_repository_impl_test.dart`
- `test/workspaces/presentation/chat/chat_conversation_cubit_test.dart`
- `pubspec.yaml`, `pubspec.lock` (bezpośrednia zależność `crypto`, wcześniej
  przechodnia).

### Walidacja 5A

- `dart format` dla zmienionych źródeł i testów — sukces.
- `flutter analyze` — brak problemów.
- `flutter test test/app/shell/panels test/workspaces/presentation/chat
  test/workspaces/data/chat/chat_repository_impl_test.dart` — 16 testów,
  sukces.
- `git diff --check` — sukces.
- `graphify update .` — pominięte: binarium `graphify` nie jest dostępne w
  środowisku (`command not found`).

### Ryzyka i dokładny następny krok

- Kolejka 5A jest celowo pamięcią lifecycle rozmowy. Trwała kolejka offline
  wymaga osobnego ownera magazynu, polityki szyfrowania danych prywatnych oraz
  czyszczenia na logout/revocation; nie wolno dopisać jej do Cubita.
- Realtime nadal wykonuje bezpieczny reload wiadomości. Etap 5B powinien dodać
  typowany reducer `eventId`/`sequence`/replay, bez dublowania lokalnych prób,
  oraz testy reconcile po reconnect.
- Następnie można przenieść kontrakt listy drawera z DTO do modeli domenowych,
  ale jako osobny pion kompatybilności — bez modyfikowania testów geometrii
  shellu.

## Pakiet 5B — typed realtime, replay i reconcile historii Chat

Wdrożono lokalny reducer zdarzeń zamiast pełnego odczytu historii przy każdym
`chat.message.*`. Kontrakt zweryfikowano względem backendowego
`ChatRealtimeEventResponse` (`eventId`, globalnie monotoniczny `sequence`,
`conversationId`, `eventType`, `payloadJson`) oraz strony replayu
`ChatRealtimeEventPageResponse` (`items`, `nextCursor`, `resyncRequired`).

- `domain/chat/realtime/` zawiera mały `ChatConversationRealtimeEvent`, reducer
  i interfejs lifecycle. Reducer deduplikuje eventy live/replay po `eventId`,
  odrzuca wyłącznie stare sekwencje (bez fałszywego założenia ciągłości per
  rozmowa) i scala ACK z wpisem optymistycznym po `clientMessageId`.
- Adapter SignalR dekoduje `payloadJson` do modeli domenowych poza UI, zachowuje
  URL-safe cursor zgodny z backendem oraz czyta kolejne strony replayu. Jeżeli
  backend zwróci `resyncRequired`, emituje jeden typowany event zamiast
  częściowej, potencjalnie niebezpiecznej aktualizacji.
- `ChatConversationCubit` aplikuje create/update/delete bez REST reloadu.
  Tylko `resyncRequired`, zmiana członkostwa albo nieznany envelope uruchamiają
  kontrolowany snapshot REST; scalanie zachowuje lokalne `sending/failed`.
- Cubit zależy od domenowego `ChatConversationRealtimeClient`, nie od klasy
  SignalR. Na `accessRevoked` oraz HTTP 401/403 czyści kolejkę, zatrzymuje
  wyłącznie lokalną subskrypcję i emituje `ChatConversationDetached`; nie
  wywołuje `dispose()` na otrzymanym serwisie.

### Pliki pakietu 5B

- `lib/workspaces/domain/chat/realtime/`
- `lib/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart`
- `lib/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart`
- `lib/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart`
- `lib/workspaces/domain/chat/conversation/models/chat_message.dart`
- `test/workspaces/domain/chat/realtime/chat_conversation_realtime_reducer_test.dart`
- `test/workspaces/data/realtime/workspace_chat_realtime_typed_events_test.dart`
- `test/workspaces/presentation/chat/chat_conversation_realtime_test.dart`
- `test/workspaces/data/realtime/workspace_chat_realtime_service_test.dart`
- `test/workspaces/support/chat_realtime_test_support.dart`

### Walidacja 5B

- `dart format` zmienionych źródeł i testów — sukces.
- `flutter analyze` — brak problemów.
- `flutter test test/workspaces/data/realtime test/workspaces/domain/chat/realtime
  test/workspaces/presentation/chat` — 29 testów, sukces.
- `git diff --check` — sukces.

### Ryzyka i dokładny następny krok

- Dla serwerowego revoke Resource Scope backend odłącza klienta od grupy;
  klient ponownie weryfikuje dostęp przy `resyncRequired`/membership event i
  fail-closed na 401/403. Dedykowany, gwarantowany event revoke dla konkretnego
  użytkownika nadal wymaga jawnego backendowego kontraktu, więc nie należy
  zgadywać payloadu po stronie Fluttera.
- Etap 5C powinien wydzielić rich composer (reply/thread/delta), obsługę
  attachmentów i trwałą, szyfrowaną kolejkę offline jako osobne owner'y. Nie
  rozszerzać `ChatConversationCubit` o te niezależne lifecycle.

## Pakiet 5B — typowany replay i redukcja historii Chat

Dodano testową macierz dla typowanego realtime Chat; testy używają prawdziwego
`WorkspaceChatRealtimeService` z kontrolowanym transportem SignalR, a nie
imitacji eventów spoza kontraktu backendu.

- Czysty `ChatConversationRealtimeReducer` jest objęty przypadkami
  `messageCreated` → `messageUpdated` → `messageDeleted`, powtórzonego
  `eventId` z live i replayu, starszej sekwencji, pojedynczego sygnału
  `resyncRequired` oraz ACK scalającego wpis optymistyczny po
  `clientMessageId`.
- Test transportu sprawdza mapowanie trzech eventów wiadomości z pełnego
  payloadu API, globalną monotoniczność `sequence`, deduplikację live/replay i
  pojedynczy typowany event `resyncRequired` z `GetConversationEvents`.
- Test Cubita potwierdza, że live message aktualizuje historię bez drugiego
  odczytu REST, a wyścig ACK wysyłki i realtime nie usuwa istniejących
  wiadomości. Dwa przypadki revoke przez snapshot po `resyncRequired`
  potwierdzają `ChatConversationDetached`, `UnsubscribeConversation` oraz
  zatrzymanie scope'u zarówno dla 401, jak i 403.
- Zamknięcie Cubita odsubskrybowuje rozmowę, ale nie wywołuje `dispose()` na
  otrzymanym/shared transporcie.
- Wspólny harness SignalR i kompletne payloady API są w
  `test/workspaces/support/chat_realtime_test_support.dart`; nie powielają
  atrap w testach transportu i Cubita.
- Poprawiono wcześniejszy harness replayu: gdy pierwsza strona zwraca
  `nextCursor: cursor-4`, atrapa zwraca drugą pustą stronę. Asercja wymaga
  kolejności `''` → `cursor-4`, więc chroni przed zarówno pominięciem strony,
  jak i pętlą cursorową.

### Pliki testów 5B

- `test/workspaces/domain/chat/realtime/chat_conversation_realtime_reducer_test.dart`
- `test/workspaces/data/realtime/workspace_chat_realtime_typed_events_test.dart`
- `test/workspaces/presentation/chat/chat_conversation_realtime_test.dart`
- `test/workspaces/support/chat_realtime_test_support.dart`
- `test/workspaces/data/realtime/workspace_chat_realtime_service_test.dart`

### Walidacja 5B

- `dart format` dla testów i wspólnego harnessu — sukces.
- `flutter analyze` dla zakresu realtime, domenowego reduktora, repozytorium,
  istniejącego Cubita, nowych testów i harnessu — brak problemów.
- `flutter test test/workspaces/data/realtime test/workspaces/domain/chat/realtime
  test/workspaces/data/chat/chat_repository_impl_test.dart
  test/workspaces/presentation/chat/chat_conversation_cubit_test.dart
  test/workspaces/presentation/chat/chat_conversation_realtime_test.dart`
  — 34 sukcesy po erracie P0 i fail-closed malformed payload.
- `git diff --check` — sukces.
- `graphify update .` — pominięte: binarium `graphify` nie jest dostępne w
  środowisku (`command not found`).

### Ryzyka i dokładny następny krok

- Testy 5B dowodzą kontraktu in-memory/replay oraz fail-closed po odświeżeniu
  REST. Nie istnieje jeszcze trwały, szyfrowany owner offline outboxu; nie
  należy zapisywać prywatnych payloadów w Cubicie ani w globalnym serwisie.
- Pozostają integracyjne testy backendu OpenAPI/SignalR dla realnego revoke,
  cursorów wielostronicowych i restartu procesu. Należy je dodać po udostępnieniu
  kontraktu backendowego w tym repozytorium.

## Errata P0 5B — PascalCase w `PayloadJson` backendu C#

Zweryfikowano rzeczywisty kontrakt backendu: `ChatRealtimeEventFactory`
serializuje `PayloadJson` w PascalCase, a test backendu odczytuje
`MessageId`. Wygenerowany klient Flutter oczekuje camelCase, więc poprzednie
mapowanie mogło po cichu pominąć wiadomość albo usunięcie.

- `ChatRealtimeEventMapper` normalizuje na granicy transportu zarówno envelope
  (`EventId`, `Sequence`, `ConversationId`, `EventType`, `PayloadJson`,
  `Items`, `NextCursor`, `ResyncRequired`), jak i zagnieżdżony JSON DTO;
  camelCase pozostaje kompatybilny.
- `WorkspaceChatRealtimeService` normalizuje payload przed deduplikacją
  `eventId` i `sequence`, a nie tylko przed mapowaniem typowanym. Dzięki temu
  live PascalCase zachowuje cursor i nie omija deduplikacji.
- Reducer sprawdza starszą sekwencję przed zapisaniem `eventId`. Reordered,
  odrzucony event nie może zatruć deduplikacji i zablokować późniejszego,
  prawidłowego eventu o tym samym id.
- Dodano dokładny test pełnego PascalCase `ChatMessageResponse` dla create i
  update oraz replay delete z `{"MessageId":"message-1","Version":7}`.
  Test reduktora potwierdza również kolejność stale → później poprawny event.
- Niepełny albo błędnie typowany PascalCase `PayloadJson` (brak `Id`, tekstowy
  `Version`) jest łapany wyłącznie przy `ChatMessageResponse.fromJson` i
  mapowany na event z `message == null`; reducer wymusza wtedy fail-closed
  `resyncRequired`. Wadliwe mapy/listy replayu są pomijane bez wyjątku.

### Walidacja erraty P0

- `flutter analyze` dla mappera, serwisu, reduktora i testów — brak problemów.
- Testy mappera, reduktora i pełny scoped zestaw 5B — sukces.

## Pakiet 8A — Resource Chat pliku

- `ResourceChatRepository` jest małym kontraktem domenowym do idempotentnego
  resolve rozmowy pliku. Nie wystawia DTO Retrofit do Cubita ani widgetu.
- `ChatRepositoryImpl` mapuje wynik `POST /api/v1/chat/conversations/resolve`
  do domenowego `ChatConversation` i wysyła `Channel` Resource zgodny z
  `StorageChatScopeProvider`: `resource:files:<UUID-N>`, provider `files`,
  resource type `file`, resource id oraz dokładne `workspaceId/projectId`.
- Akcja „Czat pliku” jest dostępna wyłącznie na prywatnym szczególe Storage,
  gdy świeże `StorageFileDetailsResponse.permissions` potwierdza `canRead` i
  dostęp różny od `none`, a plik ma placement `workspaceId` albo `projectId`;
  nie występuje na trasie publicznego share ani dla osobistego pliku ownera
  bez placementu.
- `ResourceChatCubit` deleguje ostateczną autoryzację do resolve backendu;
  401/403 emitują stan denied bez identyfikatora rozmowy. Shell odbiera tylko
  autoryzowany conversation id przez scope UI, zapamiętuje go i otwiera globalny
  Chat in-place — bez nawigacji URI.

### Walidacja 8A

- Test repozytorium sprawdza dokładny payload resolve pliku.
- Test Cubita sprawdza sukces oraz fail-closed 401/403.
- Test widgetu potwierdza widoczność wyłącznie z aktualnych `permissions`,
  brak akcji w publicznym share, delegację do session-scoped Chat na wide i
  compact bez push URI oraz ponowną autoryzację Storage po 403, która usuwa
  poprzedni snapshot szczegółów.
- Test rzeczywistego `AppGlobalShell` potwierdza, że jego scoped bridge otwiera
  wybraną rozmowę jako pinned Chat na wide albo root overlay na compact i w obu
  przypadkach nie zmienia URI.
- Przy tym teście usunięto zagnieżdżony scroll: `StorageFilePage` przekazuje
  własny `ListView` do `WorkspaceFeatureWrapper(scrollable: false)`; wcześniej
  dawało to viewportowi nieograniczoną wysokość.
- Scoped testy 8A/panele oraz pełne `flutter analyze` — sukces.

### Ryzyka i następny krok

- Header rozmowy Resource (nazwa pliku, owner i access level) nie został
  dodany, ponieważ `ChatConversation` nie zawiera tych danych. Gdy zostanie
  wprowadzony, jego jedynym źródłem ma być świeże, nadal autoryzowane
  `StorageFileDetailsResponse`; przy 401/403/revoke należy go wyczyścić.
- Gwarantowany, per-user event revoke Resource Scope nie jest jeszcze częścią
  kontraktu Flutter. Obecny Chat fail-closed reaguje na 401/403 oraz resync;
  nie wolno zgadywać dodatkowego eventu.
- `git diff --check` — sukces.

### Errata P0 — kontrakt `StorageChatScopeProvider`

- Pierwsza wersja wysyłała `Discussion` bez `discussionRootMessageId` oraz
  pomijała `workspaceId/projectId`. `ChatService.ResolveAsync` odrzuca taki
  request, a `StorageChatScopeProvider.ValidateShape` wymaga dokładnego
  kontekstu pliku.
- `ResourceChatFileRequest` przenosi tylko świeże `fileId`, `workspaceId` i
  `projectId` z `StorageFileDetailsResponse` do domenowego repozytorium; Cubit
  ani widget nie znają DTO Retrofit.
- Testy Retrofit pokrywają plik workspace/project i kontrakt prywatny z null
  kontekstem. Widget celowo nie oferuje osobistego pliku bez workspace,
  ponieważ szczegóły Flutter nie niosą wiarygodnego sygnału user-share; nie
  wolno na jego podstawie zgadywać udostępnienia.
- Dodano celowany test C# `FilesResourceResolveCreatesCanonicalChannelWithExactStorageContext`, który wykonuje realne `ChatService.ResolveAsync`, potwierdza
  `Channel`, kanoniczny key i oba identyfikatory oraz sprawdza odmowę dla
  obcego workspace.

### Walidacja erraty P0

- Scoped Flutter testy Resource Chat i paneli, pełne `flutter analyze` oraz
  `git diff --check` — sukces.
- `dotnet test ... --filter
  FullyQualifiedName~FilesResourceResolveCreatesCanonicalChannelWithExactStorageContext`
  — sukces.

## Pakiet 8B — autoryzowana capability Resource Chat dla udostępnionych plików

- Backend `GET /api/v1/storage/files/{fileId}` po swoim istniejącym
  `RequireReadAsync` zwraca `canOpenResourceChat`. To jedyny sygnał widoczności
  akcji Fluttera; UI nie wnioskuje już udostępnienia z `canRead`, `canShare`,
  ownera ani obecności `workspaceId`.
- `StorageAccessService.HasActiveInternalShareOrPlacementAsync` zwraca tę
  capability dla pliku workspace/project, aktywnego wewnętrznego `User`,
  `Workspace` albo `Project` share, lub aktywnego placementu w folderze
  systemowym. Zawsze wyklucza `PublicLink`, wygasłe share i usunięte foldery.
  Ponieważ endpoint najpierw wymusza odczyt, sama capability nie rozszerza ACL.
- `StorageFileDetailsResponse` ma udokumentowane pole OpenAPI, a ręczny model
  Freezed Fluttera ma bezpieczny default `false`; brak pola ze starszego
  backendu ukrywa akcję fail-closed, nie odsłania danych osobistego pliku.
- Resource Chat tworzy `ResourceChatFileContext` wyłącznie ze świeżych details
  Storage (nazwa pliku, owner, efektywny access). Jest on efemeryczny w
  `AppGlobalShell`, nigdy w `AppGlobalPanelsController` ani preferencjach.
  Pinned i compact Chat pokazują lokalizowany nagłówek; powrót do listy i
  `ChatConversationDetached` po 401/403 czyszczą kontekst oraz zostawiają URI
  bez zmian.

### Testy 8B

- Backend `StorageResourceChatCapabilityTests` pokrywa osobisty plik bez share
  (false), aktywny user-share (true), public link (false), placement workspace
  (true), plik workspace oraz plik project (true). `StorageOpenApiContractTests`
  sprawdza `canOpenResourceChat` w wygenerowanym schemacie.
- Flutter widget testuje osobisty plik bez capability (akcja ukryta), osobisty
  plik z capability aktywnego share (otwarcie), public share (brak akcji),
  403 po resolve (ponowna autoryzacja i usunięcie snapshotu) oraz brak zmiany
  URI na wide/compact. Test repozytorium pozostaje dowodem dokładnych
  workspace/project payloadów resolvera.
- Integracja prawdziwego `AppGlobalShell` dowodzi lokalizowanego, świeżego
  nagłówka pliku, bezpiecznego back do listy, niezmienionego URI oraz usunięcia
  nagłówka i powrotu do listy po 403 rozmowy.

### Walidacja 8B

- `flutter analyze` — sukces, bez problemów.
- `flutter test test/workspaces/presentation/chat/resource
  test/workspaces/data/chat/chat_repository_impl_test.dart
  test/app/shell/panels/app_global_shell_panels_test.dart` — 21 sukcesów.
- `dotnet test ... --filter FullyQualifiedName~StorageResourceChatCapabilityTests
  --no-build` — 4 sukcesy.
- `dotnet test ... --filter
  FullyQualifiedName~StorageSchemasExposeFolderPlacementShareVersionAndPermissionContracts
  --no-build` — sukces.
- `dotnet test ... --filter
  FullyQualifiedName~FilesResourceResolveCreatesCanonicalChannelWithExactStorageContext
  --no-build` — sukces.
- `dotnet format whitespace veloryn-workspaces.csproj --verify-no-changes
  --no-restore --include ...` — sukces dla zmienionych plików backendu.

### Ryzyka i następny krok

- Capability dotyczy stanu details w chwili odczytu; POST resolve i późniejsze
  odczyty rozmowy nadal są bramą reautoryzacji. Nie ma gwarantowanego Flutter
  eventu per-user dla revoke — obecny fail-closed reaguje na 401/403/resync;
  nowy event można dodać wyłącznie po ustaleniu backendowego kontraktu.
- Należy regenerować klienta OpenAPI, jeśli projekt przejdzie z ręcznego modelu
  `StorageFileDetailsResponse` na generator oparty o opublikowany dokument.
  Obecny model Freezed i test OpenAPI są zgodne z nowym polem.

### Errata P0 8B — capability musi być egzekwowana przez provider Chat

- `canOpenResourceChat` nie jest granicą bezpieczeństwa Fluttera. Ten sam
  predykat jest egzekwowany w `StorageChatScopeProvider` w resolve, odczycie
  istniejącej rozmowy, synchronizacji roli i batchach używanych przez listy,
  search, bookmarki oraz realtime. Po revoke owner pliku nie może zachować
  starego Resource Chat tylko dlatego, że nadal ma zwykłe `RequireReadAsync`.
- `StorageAccessService.FindResourceChatEligibleFileIdsAsync` wykonuje batch
  dopiero po `FindReadableFilesAsync`; nie rozszerza ACL. Zwraca wyłącznie
  pliki workspace/project, pliki z poprawnie ukształtowanym aktywnym internal
  share lub z nieusuniętym nie-personal placementem. `PublicLink`, wygasły
  share i rekord share bez wymaganego targetu są fail-closed.
- Kontrakt backendowy jest sprawdzony scenariuszem: owner personalnego pliku
  z aktywnym user-share może resolve i czytać rozmowę; po usunięciu share
  `GetConversation` i bezpośredni resolve zwracają odmowę, a list i provider
  batch nie zwracają rozmowy. Osobny test odrzuca sam `PublicLink` i dopuszcza
  placement workspace oraz project.

### Walidacja erraty P0 8B

- `dotnet test ... --filter
  FullyQualifiedName~FilesScopeProviderRequiresStorageAccessAndExactBinding|
  FullyQualifiedName~GetConversationSynchronizesMembershipThroughFilesScopeProvider|
  FullyQualifiedName~PersonalSharedFileResourceChatIsRevokedForResolveReadListAndBatch|
  FullyQualifiedName~FilesScopeProviderRejectsPublicLinkAndAllowsWorkspaceAndProjectPlacements|
  FullyQualifiedName~FilesResourceResolveCreatesCanonicalChannelWithExactStorageContext`
  — 5 sukcesów.
- `dotnet test ... --filter
  FullyQualifiedName~StorageResourceChatCapabilityTests|
  FullyQualifiedName~StorageSchemasExposeFolderPlacementShareVersionAndPermissionContracts
  --no-build` — 7 sukcesów.
- Targeted `dotnet format whitespace ... --verify-no-changes` i `git diff
  --check` — sukces.

### Uzupełnienie walidacji 8B — pełny backend

- `dotnet test` dla pełnego backendu — **1006 sukcesów, 3 pominięte,
  0 błędów; 1009 testów łącznie, 2 min 58 s**. Wynik przekazany przez
  właściciela backendu po pakiecie 8B; nie uruchamiano go ponownie z Flutter
  worktree.

## Pakiet 6A — Composer wiadomości

- Dodano drzewiasty subfeature `presentation/chat/composer/`: lokalny
  `ChatComposerCubit` przechowuje wyłącznie UI draftu, tryb plain/rich i reply
  target. Nie ma `BuildContext`, repozytorium ani API.
- `ChatMessageComposer` obsługuje plain text i kontrolowany `flutter_quill`
  Delta. Pełny ekran rozmowy oraz globalny panel używają tej samej powierzchni;
  wybór odpowiedzi i anulowanie odpowiedzi nie dotykają routingu.
- Enter przekazuje gotowy plain-text draft, Shift+Enter pozostawia obsługę
  edytorowi, a aktywna kompozycja IME nie wywołuje wysyłki. Rich editor nie
  przechwytuje Entera — zachowuje natywne zachowanie Quill/IME.
- `ChatComposerDraft` przechowuje tekstowy fallback, Delta i `replyToMessageId`.
  `ChatConversationCubit.sendDraft` przekazuje ten snapshot do istniejącej
  kolejki. Kolejka hashuje komplet payloadu i zachowuje UUID, Delta oraz reply
  przez retry.
- Dodano teksty ARB PL/EN i wygenerowano lokalizacje.

### Walidacja 6A

- `flutter analyze` — sukces, bez problemów.
- `flutter test test/workspaces/presentation/chat/composer
  test/workspaces/presentation/chat/conversation_delivery
  test/workspaces/presentation/chat/chat_conversation_cubit_test.dart` —
  8 sukcesów. Pokrywa snapshot Delta/reply, reset draftu, Enter, ochronę IME
  oraz retry z tym samym UUID/payloadem.
- `git diff --check` — sukces.

### Otwarte ryzyka i następny krok

- Draft jest jeszcze session-local; trwałe przechowywanie offline, debounce i
  flush przy zamknięciu wymagają osobnego właściciela szyfrowanego magazynu.
- 6A nie obejmuje threadów, edycji/usunięcia, reakcji, mentionów ani uploadów;
  pozostają otwarte checkboxy Etapu 6 i cały Etap 7.
- Następny krok: wprowadzić mały owner trwałej kolejki/draftu offline, następnie
  dodać prawy subpanel threadów bez rozszerzania `ChatConversationCubit`.

## Pakiet 6B — bezpieczny, trwały draft i klawiatura

- Dodano `ChatDraftRepository` oraz `SecureChatDraftRepository`. Adapter używa
  wyłącznie `flutter_secure_storage` (Keychain/Keystore na desktop/mobile,
  WebCrypto na Web/Wasm), a klucz zawiera zarówno `userId`, jak i
  `conversationId`. Nie ma fallbacku Hive, SharedPreferences ani plaintext.
- W niebezpiecznym kontekście Web/Wasm lub przy niedostępnym secure storage
  odczyt zwraca pusty draft, a zapis/usunięcie kończy się fail-closed. Pakiet
  wymaga HTTPS lub localhost dla WebCrypto; jest to ograniczenie platformy,
  nie obejście przez lokalny cache.
- `ChatComposerCubit` ma mały lifecycle per composer: debounce 350 ms,
  `flush()` w `close()`, restore przy ponownym otwarciu, usuwanie po wysłaniu
  i publiczną operację usunięcia przy revoke. Snapshot zachowuje tekst, Quill
  Delta, reply target oraz kolejność identyfikatorów załączników. Każdy zapis
  i delete przechodzą przez jedną, wersjonowaną kolejkę Future; rozpoczęty
  wcześniej zapis ani opóźniony odczyt restore nie mogą wskrzesić draftu po
  revoke albo submit.
- Provider secure repository jest centralnie instalowany w `ReadyNextApp`;
  pełny widok i globalny panel przekazują do composera aktualnego usera oraz
  conversation id. Brak uwierzytelnionego usera oznacza brak trwałości, nie
  wspólny klucz `anonymous`.
- `ChatMessageComposer` subskrybuje stan aktywnego `ChatConversationCubit` w
  swoim lifecycle. `ChatConversationDetached` — zarówno HTTP 401/403, jak i
  typowany realtime access revoke — automatycznie uruchamia clear bez logiki
  biznesowej w widoku. Panel wysyła synchroniczny signal revoke przed `onBack`,
  więc dispose nie anuluje już rozpoczętego clear.
- Realne widget testy potwierdzają: plain Enter wysyła raz, Shift+Enter dodaje
  linię bez wysyłki, aktywne IME nie wysyła oraz Quill przekazuje Delta i
  tekstowy fallback. Test Cubita z memory fake sprawdza close/reopen, debounce,
  flush, reply, order attachments, automatyczny clear po detach 401/403 oraz
  race rozpoczętego save lub restore i późniejszego revoke, także przed
  unmountem panelu.

### Walidacja 6B

- `flutter analyze` — sukces, bez problemów.
- `flutter test test/workspaces/presentation/chat/composer
  test/workspaces/presentation/chat/conversation_delivery
  test/workspaces/presentation/chat/chat_conversation_cubit_test.dart` —
  19 sukcesów.
- `flutter build web --wasm --debug` — sukces; potwierdza kompilację adaptera
  secure storage także dla Web/Wasm.
- `git diff --check` — sukces.

### Otwarte ryzyka i następny krok

- Retry wysyłki nadal jest retry lokalnej optymistycznej wiadomości z UUID;
  trwały replay transportu i upload załączników pozostają poza 6B.

## Pakiet 6C — reply, wątek i nazwana dyskusja w prawym panelu

### Korekty po review

- Klucz trwałego draftu composera wątku jest teraz złożony z aktualnego
  użytkownika i `thread:<rootMessageId>`; nie zawiera identyfikatora rozmowy
  nadrzędnej. Wysyłka nadal przekazuje identyfikator rozmowy nadrzędnej oraz
  wymusza `replyToMessageId` wiadomości root.
- `ChatConversationPage` nie rzuca już wyjątku, jeśli rozmowa nadrzędna
  przejdzie do `loading` albo `detached` podczas wybranej dyskusji. Listener
  zamyka subpanel dyskusji i wątku; composer wątku otrzymuje ten sam stream
  rodzica, więc przy `detached` usuwa zabezpieczony draft przed odmontowaniem.
  Strażnik renderuje bieżący stan rodzica bez ujawniania starego panelu.
- Lokalna kolejka wątku przyjmuje wyłącznie wiadomości rozmowy nadrzędnej z
  `replyToMessageId` równym `threadRootMessageId`; potwierdzenie wiadomości
  rodzica nie może zastąpić ani pojawić się w historii wątku.
- `chatThreadLoadOlder` jest w ARB PL/EN i po zmianie uruchomiono
  `flutter gen-l10n`.

- `ChatMessageComposer` nie przejmuje już lifetime `QuillController`
  przekazanego przez wywołującego. Przy restore, zmianie trybu, submit oraz
  revoke zmienia jego dokument in-place; zwalnia tylko kontroler utworzony
  lokalnie. Test widgetowy potwierdza, że host nadal może użyć kontrolera po
  revoke i unmount composera.
- Pełny widok rozmowy otrzymał osobne, lokalne akcje reply, thread i named
  discussion. Wątek jest ładowany przez mały `ChatThreadCubit` i pozostaje
  prawym subpanelem bez zmiany URI; na compact zajmuje obszar rozmowy zamiast
  powodować overflow.
- Named discussion ma własny `ChatDiscussionCubit` i kontrakt domenowy.
  Implementacja repozytorium mapuje istniejący `POST
  /api/v1/chat/conversations/resolve` na typowany payload `Discussion`, z
  zachowaniem scope, workspace/project i `discussionRootMessageId`; UI nie
  zna URI ani DTO Retrofit. 401/403 prowadzi do stanu detached, bez dalszych
  prób dostępu.
- Dodano polskie i angielskie teksty ARB dla panelu. Nie zmieniono tras ani
  kontraktów URI.

### Walidacja 6C

- `flutter analyze lib/workspaces/presentation/chat lib/workspaces/domain/chat
  lib/workspaces/data/chat/repositories/chat_repository_impl.dart
  lib/app/ready_next_app.dart` — brak problemów.
- `flutter test test/workspaces/presentation/chat/composer
  test/workspaces/presentation/chat/chat_conversation_cubit_test.dart
  test/workspaces/data/chat/chat_repository_impl_test.dart` — 23 sukcesy.
- `git diff --check` — sukces.
- `flutter test test/workspaces/presentation/chat/chat_thread_and_discussion_ui_test.dart`
  — 4 sukcesy: cursor, reply/root i izolacja draftu, revoke 403, niezmienny
  URI dyskusji, compact bez overflow oraz detach rodzica zamykający wątek i
  usuwający jego draft bez wyjątku.

### Kolejny krok

- Thread ma własną cursor pagination i lokalną kolejkę dostawy; każda odpowiedź
  wymusza `replyToMessageId` root message, dzięki czemu zachowuje UUID/payload
  przez retry. Revoke czyści kolejkę i przez composer usuwa zabezpieczony draft.
- Po resolve named discussion panel renderuje niezależny
  `ChatConversationPageView` wraz z jego historią, realtime i composerem w tym
  samym prawym subpanelu, bez zmiany URI.

## Pakiet 7A — ograniczony fundament załączników Chat

- Dodano drzewiasty, lokalny subfeature `domain/chat/attachments/` i
  `presentation/chat/attachments/selection/`. `ChatAttachmentSelectionCubit`
  nie zna `BuildContext`, pickera, drag-and-drop, schowka ani HTTP; przyjmuje
  wyłącznie `StorageUploadInput` albo neutralny strumień
  `ChatAttachmentSelectionSource`, który może później dostać adaptery Web i
  desktop dla pickera, drag-and-drop oraz paste.
- Walidacja przed uploadem trzyma maksymalnie 20 aktywnych plików, 50 MiB na
  plik oraz 100 MiB na wiadomość. Odrzucony input nie trafia do kolejki ani do
  limitu i ma typowaną przyczynę (`tooManyFiles`, `fileTooLarge` albo
  `messageTooLarge`).
- Model lifecycle jest jawny: `processing`, `scanning`, `clean`, `infected`,
  `failed`; maszyna stanów dopuszcza tylko monotoniczny przebieg
  processing → scanning → clean/infected/failed. Brak skanu oznacza brak
  kwalifikacji pliku do przyszłej publikacji.
- `remove`, `revokeAndDispose` oraz `close` najpierw odłączają lokalne dane, a
  dopiero potem przekazują ich snapshot do opcjonalnego
  `ChatAttachmentDisposalPort`. `remove` uruchamia utylizację asynchronicznie;
  `close` na nią czeka. Błąd utylizacji zachowuje odłączony selection i stan
  diagnostyczny `disposalFailed`; pliki nie mogą wrócić do draftu.
- Dołączono mały, prezentacyjny `ChatAttachmentSelectionList` i teksty PL/EN.
  Nie jest on podpięty do composera: `ChatComposerDraft` ma wprawdzie lokalne
  `attachmentIds`, lecz `ChatSendMessageCommand`, `ChatMessage` i aktualny
  kontrakt transportowy nie przenoszą identyfikatorów załączników.

### Braki kontraktu backendu blokujące upload i integrację composera

- `StorageResourceType` nie ma `ChatMessage`/tymczasowego zasobu Chat;
  istniejące bilety uploadu nie mówią, jak bezpiecznie przypisać plik do
  niewysłanej wiadomości.
- Nie ma kontraktu Chat dla `attachmentIds` w send, odpowiedzi wiadomości ani
  realtime, więc klient nie może zachować idempotentnego payloadu i odtworzyć
  stanu po retry.
- Storage udostępnia ogólne `processingStatus`/`scanStatus` przy obiekcie
  pliku, lecz Chat nie ma do nich związanego odczytu, zdarzenia ani kontraktu
  pollingowego. Nie wolno traktować zakończenia uploadu jako `clean`.
- `deleteFile` jest soft-delete Storage i nie jest zweryfikowanym kontraktem
  porzucenia tymczasowego uploadu Chat; dlatego etap 7A wystawia wyłącznie port
  utylizacji i nie wywołuje go przez API.

### Kontrakt backendu 7B — projekt przed implementacją

Backend wprowadzi serwerowo wydaną, wygasającą sesję tymczasowych załączników
powiązaną z użytkownikiem i rozmową. Ticket Storage będzie wskazywał sesję,
a wysłanie poda uporządkowane IDs; transakcja backendu rewaliduje ownership,
Scope, `Clean`/`Ready` oraz limity i atomowo tworzy wiadomość z relacjami.
Idempotency hash, odpowiedź wiadomości i `chat.message.created` obejmą te IDs.
Anulowanie, expiry lub revoke fail-closed usuną wyłącznie niepowiązane pliki.

### Walidacja 7A

- `flutter test test/workspaces/presentation/chat/attachments/selection` —
  6 sukcesów: limity, adapter-neutralne źródło, monotoniczny lifecycle,
  fail-closed revoke/remove, cleanup przy close oraz widget listy.
- W chwili pakietu 7A `flutter analyze` nie miał diagnostyk w plikach 7A, ale
  pełny wynik blokował równoległy błąd Notifications w
  `test/workspaces/data/realtime/workspace_signalr_client_test.dart:137`
  (przekazanie `List<NotificationGroupResponse>` zamiast
  `CursorPageResponse<NotificationGroupResponse>`). To ograniczenie zostało
  później usunięte w korekcie 9A; jej pełny `flutter analyze` zakończył się
  bez problemów. Walidacja 7A pozostaje historycznie scoped.
- `git diff --check` — sukces.

## Pakiet 3K-A — rootowy picker daty

- Cztery niezależne call-site'y daty (`my_tasks_filters_dialog`,
  `storage_public_link_form`, `project_milestone_editor_dialog` i
  `tasks_board_header`) używają `AppModalPickerHost.showDate`; adapter
  zachowuje wartości `firstDate`, `lastDate`, `initialDate`, locale i builder,
  a route zawsze trafia do rootowego navigatora.
- Aktualny Flutter SDK nie przyjmuje `locale` bezpośrednio w
  `showTimePicker`; publiczne API `AppModalPickerHost.showTime` pozostaje
  niezmienione, a locale jest przekazywane przez `Localizations.override`.
- Test hosta z prawdziwym zagnieżdżonym navigatoriem potwierdza, że picker
  daty ani czasu nie jest dokładany do navigatora shella; czas sprawdza też
  `Locale('pl')` oraz custom builder.
- Pozostało dokładnie **10 surowych pickerów**: dwa w
  `task_saved_view_date_range_filter.dart`, po jednym w
  `task_details_shared.dart` i `task_details_custom_fields_editor.dart`, dwa
  w `task_recurrence_context_editor.dart`, dwa w `inventory_detail_modal.dart`
  oraz dwa w `arkusz_detail_modal_management.part.dart`. `AppModalPickerHost`
  jest wyłączony z tej liczby, ponieważ zawiera centralne wywołania systemowe.

## Pakiet 3K-D — pełne zamknięcie systemowych pickerów

- Globalny skan `lib/**/*.dart` zwraca **0 surowych** `showDatePicker` /
  `showTimePicker`; jedyne dwa wywołania pozostają w
  `app/shell/overlay/app_modal_picker_host.dart` jako centralna, jawna polityka
  rootowego navigatora.
- Test adaptera pokrywa date picker i time picker otwierane z zagnieżdżonego
  navigatora. Dla czasu potwierdza również `Locale('pl')` i custom builder;
  `Localizations.override` zachowuje publiczne API, mimo że SDK nie ma
  bezpośredniego argumentu locale dla systemowego time pickera.
- Otwarte poza tym slice'em pozostają dwa `OverlayEntry`: anchored popover
  `app_search_dropdown.dart` (owner kotwicy; zamknięcie na route/resize) oraz
  root transient toast `app_bubble_toast.dart` (musi renderować się pod aktywną
  barierą modalną, bez globalnego lifecycle'u).

## Pakiet 9D — bezpieczne usunięcie grupy powiadomień

Backend może wysłać `notification.group.removed { groupKey, realtimeSequence }`.
Klient traktuje je jako minimalny, typowany sygnał revoke: nie mapuje żadnego
payloadu grupy, odrzuca starsze sequence i usuwa tylko wskazany lokalny snapshot.
Po reconnect odtwarza wszystkie strony cursor grup, z limitem ochronnym 100 stron.

## Pakiet 9E-A — preferencje dostarczania, Storage i digest

- Runtime DI tworzy i publikuje `NotificationPreferencesRepository` oraz
  `NotificationDigestRepository` na tym samym prywatnym `NotificationsApi` co
  inbox. Presentation widzi wyłącznie porty domenowe; UI nie zna Retrofit ani
  HTTP.
- `NotificationDeliveryPreferencesCubit`, `StorageNotificationPreferenceCubit`
  oraz `NotificationDigestCubit` są lokalnymi ownerami swoich trzech,
  niezależnych lifecycle'ów. Zapis delivery/Storage jest optymistyczny i cofa
  dokładny snapshot po błędzie. Generacja żądań odrzuca spóźnione wyniki loadu
  albo zapisu po nowszej intencji. Digest jest tylko do odczytu i rozróżnia
  sukces pusty od błędu.
- `AppNotificationPreferencesModal` jest rootowym dialogiem `AppModalHost`,
  dostępnym zarówno z `GlobalNotificationsPage`, jak i
  `AppGlobalNotificationsPanel`, bez zmiany bieżącego URI. Nie dodano ustawień
  Chat, odpowiedzi z powiadomienia ani zmian `NotificationsCubit`.
- Dodano pełne PL/EN ARB i uruchomiono `flutter gen-l10n`.

### Walidacja 9E-A

- `flutter test test/workspaces/presentation/notifications` — 21 sukcesów;
  nowe testy obejmują rollback delivery/Storage, pusty i błędny digest oraz
  dostępność modala z pełnego ekranu i panelu.
- Scoped `flutter analyze` dla runtime bindings, `ReadyNextApp`, Notifications
  i nowych testów — brak problemów.
- `git diff --check` — sukces.
- Pełne `flutter analyze` po pakiecie zwracało wyłącznie cztery istniejące
  informacje `unnecessary_lambdas` w
  `test/workspaces/data/realtime/workspace_signalr_client_test.dart:248-253`;
  nie należą do 9E-A i wymagają osobnego uprzątnięcia przed końcową bramką.

## Pakiet 3L — domknięte overlaye i trwały kontrakt jakościowy

- `AppGlobalShell` posiada dwa małe, sesyjne ownery prezentacyjne:
  `AppOverlayRouteLifecycle` (sygnał routera dla anchored overlayów) oraz
  `AppBubbleToastController` (jeden transient toast powiązany z tym samym
  `AppModalCoordinator`). Nie są singletonami i nie przechowują stanu
  biznesowego.
- `AppSearchDropdown` zamyka się na zmianę trasy, resize i utratę kotwicy;
  pozostaje w najbliższym overlayu kotwicy, dlatego nie przekracza granic
  private shella.
- Toast jest rootowym transientem, lecz podczas aktywnej bariery modala nie
  istnieje w overlayu. Bieżący toast znika przy `tryAcquire`, a nowe żądania
  tworzą kolejkę FIFO emitowaną po `release` i po zamknięciu poprzedniego
  toastu. `AppModalHost` tworzy builder pod scope toastu; callback changeloga
  i most paneli shella korzystają z kontekstu potomnego scope'ów, nie z
  kontekstu root navigatora pobranego przed buildem.
- Zakaz jakościowy dla dalszych zmian: nie dodawać `OverlayEntry` ani
  statycznego lifecycle'u; nowy overlay musi mieć lokalnego/sesyjnego ownera,
  politykę route/resize/revoke oraz test z-orderu względem modala.

Walidacja pakietu: 5 testów dropdown/toast, 15 testów hosta/routera/shella,
scoped `flutter analyze` bez diagnostyk i `git diff --check` bez błędów.
Pełne `flutter analyze` kończy się czterema istniejącymi informacjami poza 3L:
`notification_reply_modal.dart` i trzy testy reply (ordering dyrektyw,
redundant argument, braces, `const`); nie ma błędów ani ostrzeżeń 3L.

## Pakiet 9E-B — ustawienia powiadomień Chat

- `ChatNotificationSettingsRepository` jest tworzony na prywatnym `ChatApi`
  przez `ChatNotificationSettingsRepositoryImpl`, przechowywany w
  `WorkspacesModuleBindings` i publikowany wyłącznie jako port domenowy.
  Widgety nie znają Retrofit ani HTTP.
- `ChatGlobalNotificationSettingsCubit` oraz
  `ChatConversationNotificationSettingsCubit` są odrębnymi, lokalnymi
  ownerami. Oba stosują generation guard dla spóźnionych wyników. Globalny
  zapis aktualizuje tylko wskazany kanał i cofa snapshot dla zwykłego błędu;
  401/403 przechodzą do stanu `Revoked`, bez przywrócenia potencjalnie
  nieuprawnionych danych.
- `ChatGlobalNotificationSettingsSection` stanowi oddzieloną sekcję
  globalnego modala `AppNotificationPreferencesModal`. Politykę konkretnej
  rozmowy udostępnia `ChatConversationNotificationSettingsModal` przez
  `AppModalHost`; ikona istnieje w globalnym panelu oraz pełnym widoku Chat,
  nie dotyka routera ani URI. Dostępne tryby: `all`, `mentionsOnly`, `muted`,
  `highOnly`.
- DND i mute wątków świadomie pozostają poza pakietem: brak zatwierdzonego
  portu i endpointu oznacza brak spekulacyjnej logiki UI.

### Walidacja 9E-B

- `flutter test test/workspaces/presentation/chat/settings/chat_notification_settings_test.dart test/workspaces/presentation/notifications/preferences/notification_preferences_cubits_test.dart` — 11 sukcesów.
- Scoped `flutter analyze` dla runtime DI, nowych cubitów/modalów,
  powierzchni Chat i testów — brak problemów.
- `git diff --check` — sukces.
- Pełne `flutter analyze` jest chwilowo blokowane przez równoległy, nieobjęty
  pakiet 9E-B `presentation/notifications/reply/notification_reply_modal.dart`
  (brakujące klucze l10n i niezgodne parametry API); nie dotyczy kodu Chat
  settings i wymaga osobnego domknięcia przed końcową bramką.

## Pakiet 9F — odpowiedź Chat z powiadomienia

- `NotificationReplyRepository` jest osobnym portem domenowym, a
  `NotificationReplyRepositoryImpl` mapuje odpowiedź `POST
  /api/v1/notifications/{id}/reply` na `ChatMessage`. Jest utworzony z
  prywatnego `NotificationsApi` w `WorkspacesModuleBindings` i publikowany w
  `ReadyNextApp` wyłącznie jako port; prezentacja nie buduje URI, DTO ani
  żądań HTTP.
- `NotificationReplyCubit` żyje tylko w otwartym dialogu. Wysyłka tworzy UUID
  v4 `clientMessageId` raz; po zwykłym błędzie zostawia tekst, Delta i UUID do
  ponowienia tej samej idempotentnej intencji. 401/403 przechodzą do stanu
  `NotificationReplyAccessRevoked`, usuwają draft/Delta/UUID z modelu cubita i
  blokują dalszą edycję; modal czyści także własne kontrolery tekstu.
- `NotificationReplyTarget` jest domenową polityką affordance, nie logiką
  widgetu: akcja jest dostępna wyłącznie dla `ChatMessage` albo niepustego
  `chatMessageId` / `messageId` w metadanych. Klient nie waliduje formatu
  referencji ani nie przyznaje dostępu — backend ponownie autoryzuje wskazane
  powiadomienie i członkostwo w rozmowie.
- `NotificationReplyAction` znajduje się we wspólnej liście Notifications,
  więc działa zarówno w `GlobalNotificationsPage`, jak i w
  `AppGlobalNotificationsPanel`. Otwiera dialog przez rootowy
  `AppModalHost.showDialog`; nie wywołuje routera i nie zmienia URI.
- Modal ma lokalizowane PL/EN stany zwykłego błędu i revoke, edytor plain/rich
  oraz odświeża inbox wyłącznie po sukcesie. Nie dodano globalnego Cubita,
  singletonu ani free-function API.

### Walidacja 9F

- `dart format` dla plików domeny reply, modala i testów — sukces.
- `flutter test test/workspaces/domain/notifications/notification_reply_target_test.dart test/workspaces/presentation/notifications/reply/notification_reply_cubit_test.dart test/workspaces/presentation/notifications/reply/notification_reply_modal_test.dart` — 10 sukcesów. Pokrywa `ChatMessage`, oba pola metadata, sukces odpowiedzi przez metadata, 401 i 403 z wyczyszczeniem stanu, retry z tym samym UUID oraz akcję z pełnej strony i panelu.
- `flutter test test/workspaces/domain/notifications test/workspaces/presentation/notifications` — 31 sukcesów; `flutter test test/workspaces/data/notifications` — 7 sukcesów.
- Pełne `flutter analyze` — brak problemów. `git diff --check` — sukces.

### Ograniczenia 9F

- Po sukcesie modal zamyka się i odświeża inbox. Przejście do konkretnej
  wiadomości Chat nie należy do 9F, aby nie wprowadzać ukrytej zmiany URI;
  wymaga osobnego, autoryzowanego deep-linku.
- Kwalifikacja klienta jest wyłącznie wskazówką UX. Nie zastępuje kontroli
  access revoke, którą backend wykonuje przy każdym `reply`.

## Pakiet 4E — status realtime panelu Chat i odbiór Etapu 4

- `ChatRealtimeStatusCubit` jest małym, lokalnym obserwatorem
  `WorkspaceChatRealtimeService` dla jednej otwartej rozmowy panelu. Nie
  uruchamia, nie zatrzymuje ani nie zna API: lifecycle połączenia pozostaje w
  `ChatConversationCubit`. Panel renderuje lokalizowany, nieblokujący banner
  connecting/reconnecting/offline.
- `AppGlobalChatPanel` przekazuje factory realtime tylko do wybranej rozmowy.
  `ChatConversationCubit` przyjmuje opcjonalny callback zwalniający wyłącznie
  transport utworzony przez tę factory; istniejący shared transport bez callbacku
  nadal jest wyłącznie odsubskrybowywany, nie niszczony.
- Widgetowy harness prawdziwego `AppGlobalShell` otrzymał neutralne porty
  composera (draft, picker, upload), aby testować panel jako realną kompozycję,
  bez systemu plików i transportu HTTP. Test potwierdza offline Chat po wyborze
  rozmowy, oprócz wcześniejszej macierzy wide/compact/URI/rezerwacji szerokości.

### Walidacja 4E

- `flutter analyze lib/workspaces/presentation/chat/chat_drawer.dart
  lib/workspaces/presentation/chat/shell/chat_panel_conversation.dart
  lib/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart
  lib/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart
  test/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit_test.dart`
  — bez diagnostyk.
- `flutter test test/app/shell/panels/app_global_shell_panels_test.dart
  test/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit_test.dart`
  — 10 sukcesów.
- `flutter test test/app/router/app_deep_link_test.dart
  test/app/router/app_route_paths_test.dart test/app/router/auth_redirect_policy_test.dart
  test/app/shell/panels test/app/shell/overlay` — 50 sukcesów.
- `flutter analyze` — brak diagnostyk.
- `git diff --check` — sukces.

### Otwarte ograniczenie kontraktu

Etap 4 nadal nie ma osobnego unread badge Chat. Zweryfikowany kontrakt
`ChatConversationResponse` zwracany przez `GET /api/v1/chat/conversations`
nie ma pola unread, a `ChatApi` nie udostępnia agregatu unread dla bieżącego
użytkownika. Do domknięcia ostatniego checkboxa backend musi dodać albo
autoryzowany `GET /api/v1/chat/unread-count`, albo stabilne `unreadCount` na
każdej rozmowie wraz z regułami realtime/reconnect i testami OpenAPI. Klient
nie może zastępować tego licznikiem Notifications ani lokalnym stubem.

## Pakiet 6D — edycja, soft delete i rewizje wiadomości

- Zweryfikowano backend Workspaces, nie tylko wygenerowany klient Fluttera:
  `PATCH /api/v1/chat/messages/{messageId}` przyjmuje `text`, opcjonalny
  `deltaJson` i wymagany `version`; `DELETE` wymaga query `version`; `GET
  /messages/{messageId}/revisions` zwraca uporządkowaną historię snapshotów.
  Backend mapuje nieaktualną wersję na `409 chat.version_conflict`.
- `ChatMessageActionsRepository` jest osobnym portem domenowym, a
  `ChatRepositoryImpl` jest jedynym adapterem Retrofit/DTO. Domenowy model
  rewizji nie wystawia modeli transportowych prezentacji.
- Lokalny `ChatMessageActionsCubit` wykonuje edycję i soft delete dopiero po
  ACK, przekazuje dokładne `Version`, rozróżnia konflikt oraz po `401/403`
  emituje fail-closed revoke. Tylko potwierdzony snapshot edycji scala się z
  historią rozmowy; delete oznacza lokalnie wiadomość jako usuniętą po `204`.
- Pełny widok rozmowy ma lokalne menu i rootowe dialogi edycji/historii przez
  `AppModalHost`; widget nie zna API ani kontraktów HTTP. Historia jest
  read-only i nie mutuje aktualnej wiadomości.

### Walidacja 6D

- Scoped `flutter analyze` nowych portów, adaptera, Cubita, UI i DI — sukces,
  bez diagnostyk.
- Targeted testy adaptera i Cubita pokrywają payload `Version`, `409`, ACK
  soft delete, fail-closed `403` historii oraz mapowanie rewizji. Pełny
  istniejący test widoku rozmowy wymaga osobnego domknięcia 4 px overflowu
  composera załączników na compact (`700×900`); nie jest maskowany zmianą
  asercji tego pakietu.

### Kolejne, nieodhaczone elementy Etapu 6

- Reakcje/piny/bookmarki/forward, wzmianki, link preview/snippety, search,
  presence/typing/receipts/status, tworzenie rozmów/członkowie i mute/archive
  mają endpointy w `ChatApi`, ale nie mają jeszcze pełnego portu domenowego,
  lokalnego ownera stanu, UI i testów; nie są implementowane spekulacyjnie.
- UI udostępnia edycję tylko plain-text. Wiadomość z `deltaJson` ma nadal
  historię i delete, ale nie jest edytowana przez tekstowy dialog, aby nie
  wysłać treści niezgodnej ze starym Delta. Bez renderera i edytora
  rich-message nie należy oznaczać safe rich content jako ukończonego.

## Audyt Etapu 8 — Resource Chat plików (2026-09-15)

Kod 8A/8B nadal spełnia kontrakt: akcja zależy od świeżego
`canOpenResourceChat` i efektywnego read, resolver wysyła idempotentny Scope
`Resource/files`, a odpowiedź trafia do globalnego panelu bez zmiany URI.
`ResourceChatFileContext` jest efemeryczny w shellu i przekazuje wyłącznie
świeżą nazwę, ownera, access level oraz bezpieczny powrót; 401/403 od resolve
odświeża Storage details, usuwa snapshot i odłącza kontekst rozmowy.

Po domknięciu równoległego pakietu akcji wiadomości pełny scoped zestaw:
`flutter test test/workspaces/presentation/chat/resource
test/workspaces/data/chat/chat_repository_impl_test.dart
test/app/shell/panels/app_global_shell_panels_test.dart` — **24 sukcesy**.
Pokrywa dokładny payload resolve dla scope workspace/project i prywatnego,
widoczność capability, brak akcji public share, panel wide/compact bez zmiany
URI, świeży nagłówek/bezpieczny powrót oraz wyczyszczenie kontekstu po 403.
`flutter analyze` kończy się bez błędów i ostrzeżeń (pozostało 6 informacji o
porządku/zbędności importów w testach panelu oraz wątku/dyskusji).
