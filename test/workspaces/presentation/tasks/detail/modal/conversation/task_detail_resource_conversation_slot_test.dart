import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_page.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_chat_dependency_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/conversation/task_detail_resource_conversation_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  testWidgets('resolves task resource and mounts the shared conversation UI', (
    tester,
  ) async {
    final repository = _ChatRepositoryMock();
    final conversation = _conversation();
    when(
      () => repository.resolveTaskConversation(
        taskId: 'task-id',
        workspaceId: 'workspace-id',
        projectId: 'project-id',
      ),
    ).thenAnswer((_) async => Right(conversation));
    when(() => repository.getConversation(conversation.id)).thenAnswer(
      (_) async => Right(conversation),
    );
    when(
      () => repository.listConversationMessages(
        conversationId: conversation.id,
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => const Right(ChatMessagePage(items: [])));
    when(repository.listConversations).thenAnswer(
      (_) async => const Right(<ChatConversationResponse>[]),
    );
    when(
      () => repository.listMessages(conversation.id),
    ).thenAnswer((_) async => const Right(<ChatMessageResponse>[]));
    final composition = DevPlannerGlobalChatComposition(
      repository: repository,
      userId: 'user-id',
      draftRepository: _DraftRepositoryMock(),
    );
    ChatPanelConversation? previousPanel;

    for (final brightness in [Brightness.light, Brightness.dark]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskDetailChatDependencyScope(
              composition: composition,
              authSession: null,
              storageRepository: null,
              emojiRecentCubit: null,
              child: TaskDetailResourceConversationSlot(
                taskId: 'task-id',
                workspaceId: 'workspace-id',
                projectId: 'project-id',
                composition: composition,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Zadanie resource'), findsOneWidget);
      final outerContext = tester.element(
        find.byType(TaskDetailResourceConversationSlot),
      );
      final chatContext = tester.element(find.byType(ChatPanelConversation));
      previousPanel = tester.widget(find.byType(ChatPanelConversation));
      final outerTheme = Theme.of(outerContext);
      final tasksTheme =
          outerTheme.extension<DevPlannerTasksTheme>() ??
          DevPlannerTasksTheme.of(
            outerTheme.textTheme,
            outerTheme.colorScheme,
          );
      final taskChatTheme = Theme.of(chatContext)
          .extension<DevPlannerChatTheme>()!;
      final taskMenuTheme = Theme.of(chatContext)
          .extension<DevPlannerMenuTheme>()!;
      final foreground = outerTheme.colorScheme.onSurface;
      final metadata = outerTheme.colorScheme.onSurfaceVariant;
      expect(taskChatTheme.panelSurface, tasksTheme.canvas);
      expect(taskChatTheme.incomingBubble, tasksTheme.cardSurface);
      expect(taskChatTheme.outgoingBubble, tasksTheme.rowSelected);
      expect(taskChatTheme.incomingText, foreground);
      expect(taskChatTheme.outgoingText, foreground);
      expect(taskChatTheme.metadataText, metadata);
      expect(taskChatTheme.contentStyle.color, foreground);
      expect(taskChatTheme.authorStyle.color, foreground);
      expect(taskChatTheme.metadataStyle.color, metadata);
      expect(taskChatTheme.sendButtonSurface, tasksTheme.selectionAccent);
      expect(taskMenuTheme.surface, tasksTheme.canvas);
      expect(
        find.byTooltip(
          AppLocalizations.of(tester.element(find.byType(Scaffold)))!
              .globalChatBackToConversations,
        ),
        findsNothing,
      );
    }
    final replacementRepository = _ChatRepositoryMock();
    when(
      () => replacementRepository.resolveTaskConversation(
        taskId: 'task-id',
        workspaceId: 'workspace-id',
        projectId: 'project-id',
      ),
    ).thenAnswer((_) async => Right(conversation));
    when(() => replacementRepository.getConversation(conversation.id))
        .thenAnswer((_) async => Right(conversation));
    when(
      () => replacementRepository.listConversationMessages(
        conversationId: conversation.id,
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => const Right(ChatMessagePage(items: [])));
    when(replacementRepository.listConversations).thenAnswer(
      (_) async => const Right(<ChatConversationResponse>[]),
    );
    when(
      () => replacementRepository.listMessages(conversation.id),
    ).thenAnswer((_) async => const Right(<ChatMessageResponse>[]));
    final replacementComposition = DevPlannerGlobalChatComposition(
      repository: replacementRepository,
      userId: 'user-id',
      draftRepository: _DraftRepositoryMock(),
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TaskDetailChatDependencyScope(
            composition: replacementComposition,
            authSession: null,
            storageRepository: null,
            emojiRecentCubit: null,
            child: TaskDetailResourceConversationSlot(
              taskId: 'task-id',
              workspaceId: 'workspace-id',
              projectId: 'project-id',
              composition: replacementComposition,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Zadanie resource'), findsOneWidget);
    previousPanel!.onResourceAccessRevoked!.call();
    await tester.pump();
    expect(find.byType(ChatPanelConversation), findsOneWidget);
    verify(
      () => replacementRepository.resolveTaskConversation(
        taskId: 'task-id',
        workspaceId: 'workspace-id',
        projectId: 'project-id',
      ),
    ).called(1);
    verify(
      () => repository.resolveTaskConversation(
        taskId: 'task-id',
        workspaceId: 'workspace-id',
        projectId: 'project-id',
      ),
    ).called(1);
  });
}

ChatConversation _conversation() => ChatConversation(
  id: 'conversation-id',
  type: 'resource',
  scopeKind: 'Resource',
  scopeKey: 'task-id',
  workspaceId: 'workspace-id',
  projectId: 'project-id',
  name: 'Zadanie resource',
  version: 1,
  createdAtUtc: DateTime.utc(2026, 9, 30),
  postingPermission: 'Member',
  isArchived: false,
);

final class _ChatRepositoryMock extends Mock
    implements
        ChatRepository,
        ChatConversationRepository,
        ResourceChatRepository {}

final class _DraftRepositoryMock extends Mock implements ChatDraftRepository {}
