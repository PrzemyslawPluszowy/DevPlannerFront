import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation_parts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regresje dla tożsamości rozmowy w panelu.
///
/// Bez klucza zależnego od `conversation.id` Flutter zachowuje providery i
/// `ChatConversationCubit` poprzedniej rozmowy, a nagłówek pokazuje już inną —
/// wtedy wysłanie wiadomości mogło trafić do rozmowy, której użytkownik nie widzi.
void main() {
  ChatConversation conversation(String id) => ChatConversation(
    id: id,
    type: 'direct',
    scopeKind: 'global',
    scopeKey: 'direct:global:$id',
    version: 1,
    createdAtUtc: DateTime.utc(2026, 9, 22),
    postingPermission: 'Everyone',
    isArchived: false,
    name: 'Rozmowa $id',
  );

  /// Panel w minimalnej kompozycji: draft jest portem wymaganym przez composer.
  Widget harness(
    String id, {
    WorkspaceChatRealtimeLease Function(String)? lease,
  }) => MaterialApp(
    // Nagłówek i composer czytają teksty z ARB, więc harness dostaje te same
    // delegaty co aplikacja.
    supportedLocales: const <Locale>[Locale('pl')],
    localizationsDelegates: const <LocalizationsDelegate<Object>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    // `Scaffold` daje Material i metryki pól, których panel używa w aplikacji:
    // bez niego pole tekstowe composera raportuje w testach wysokość sentinelową.
    home: Scaffold(
      body: RepositoryProvider<ChatDraftRepository>.value(
        value: _DraftRepositoryFake(),
        child: ChatPanelConversation(
          key: ChatPanelConversation.keyFor(id),
          conversationRepository: _ConversationRepositoryFake(),
          conversation: conversation(id),
          onBack: () {},
          createRealtime: lease,
        ),
      ),
    ),
  );

  Future<void> pumpConversation(WidgetTester tester, String id) async {
    // Panel jest kolumną na całą wysokość, więc dostaje realne ograniczenia
    // zamiast domyślnego ekranu testowego z nieograniczoną wysokością treści.
    tester.view.physicalSize = const Size(1000, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(harness(id));
    await tester.pump();
  }

  /// Cubit czytamy z nagłówka, bo provider wydaje go niżej niż sam panel.
  ChatConversationCubit cubitOf(WidgetTester tester) => tester
      .element(find.byType(ChatPanelConversationHeader))
      .read<ChatConversationCubit>();

  testWidgets('zmiana rozmowy wymienia Cubit razem z identyfikatorem', (
    tester,
  ) async {
    await pumpConversation(tester, 'a');
    final first = cubitOf(tester);
    expect(first.conversationId, 'a');

    await pumpConversation(tester, 'b');
    final second = cubitOf(tester);

    expect(
      second.conversationId,
      'b',
      reason: 'nagłówek i wysyłka nie mogą pochodzić z dwóch różnych rozmów',
    );
    expect(
      second,
      isNot(same(first)),
      reason: 'Cubit poprzedniej rozmowy musi zostać zamknięty',
    );
  });

  testWidgets('dzierżawa realtime powstaje raz na rozmowę i nie wycieka', (
    tester,
  ) async {
    // Prawdziwa fabryka dzierżaw: pula liczy otwarte rozmowy, więc test widzi
    // zarówno otwarcie w `initState`, jak i zwolnienie przy zamknięciu panelu.
    final factory = WorkspaceChatRealtimeFactory(
      baseUrl: 'http://127.0.0.1:9',
      credentials: WorkspaceRealtimeCredentials.bearer(() async => null),
    );
    addTearDown(factory.closeAll);

    tester.view.physicalSize = const Size(1000, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(harness('a', lease: factory.open));
    await tester.pump();
    expect(factory.openConversationCount, 1);

    // Przebudowa bez zmiany rozmowy nie może otwierać kolejnej dzierżawy:
    // dzierżawa utworzona w `build` zostawiłaby po sobie licznik referencji,
    // przez co połączenie nie zamknęłoby się po wyjściu z rozmowy.
    await tester.pumpWidget(harness('a', lease: factory.open));
    await tester.pump();
    expect(factory.openConversationCount, 1);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(
      factory.openConversationCount,
      0,
      reason: 'zamknięcie panelu zwalnia dzierżawę rozmowy',
    );
  });
}

final class _DraftRepositoryFake implements ChatDraftRepository {
  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) async => null;

  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async {}

  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async {}

  @override
  Future<void> deleteAllForUser({required String userId}) async {}
}

final class _ConversationRepositoryFake implements ChatConversationRepository {
  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) async => const Left(_failure);

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) async => const Right(ChatMessagePage(items: <ChatMessage>[]));

  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) async => const Left(_failure);

  @override
  Future<Either<ApiError, void>> markMessageDelivered({
    required String messageId,
  }) async => const Right(null);

  @override
  Future<Either<ApiError, void>> markConversationRead({
    required String conversationId,
    required String messageId,
  }) async => const Right(null);

  static const ApiError _failure = ApiError(
    type: ApiErrorType.server,
    message: 'chat.conversation.load_failed',
    apiCode: 'chat.conversation.load_failed',
  );
}
