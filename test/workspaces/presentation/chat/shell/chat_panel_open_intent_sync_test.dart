import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_panel_open_intent_sync.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_section.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

ChatConversation conversation(String id) => ChatConversation(
  id: id,
  type: 'Channel',
  scopeKind: 'Resource',
  scopeKey: id,
  name: '$id.docx',
  version: 1,
  isArchived: false,
  createdAtUtc: DateTime.utc(2026, 10, 5),
  postingPermission: 'Everyone',
);

void main() {
  testWidgets('authorized resource opens without waiting for inbox', (
    tester,
  ) async {
    final selection = ChatPanelSelectionCubit();
    final section = ChatPanelSectionCubit();
    addTearDown(selection.close);
    addTearDown(section.close);
    await tester.pumpWidget(
      _Harness(
        selection: selection,
        section: section,
        initial: ChatPanelSelection(conversation: conversation('first')),
      ),
    );
    await tester.pump();
    expect(find.text('first.docx'), findsOneWidget);
    expect(section.state.showList, isFalse);
    expect(selection.state?.canModerate, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('new resource intent updates retained panel owners', (
    tester,
  ) async {
    final selection = ChatPanelSelectionCubit();
    final section = ChatPanelSectionCubit();
    addTearDown(selection.close);
    addTearDown(section.close);
    await tester.pumpWidget(
      _Harness(
        selection: selection,
        section: section,
        initial: ChatPanelSelection(conversation: conversation('first')),
      ),
    );
    await tester.pumpWidget(
      _Harness(
        selection: selection,
        section: section,
        initial: ChatPanelSelection(conversation: conversation('second')),
      ),
    );
    await tester.pump();
    expect(find.text('second.docx'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'same intent rebuild does not reopen manually closed conversation',
    (tester) async {
      final selection = ChatPanelSelectionCubit();
      final section = ChatPanelSectionCubit();
      addTearDown(selection.close);
      addTearDown(section.close);
      final initial = ChatPanelSelection(conversation: conversation('first'));
      await tester.pumpWidget(
        _Harness(selection: selection, section: section, initial: initial),
      );
      selection.clear();
      section.select(ChatPanelSection.chats);
      await tester.pump();
      await tester.pumpWidget(
        _Harness(selection: selection, section: section, initial: initial),
      );
      await tester.pump();
      expect(find.text('none'), findsOneWidget);
      expect(section.state.showList, isTrue);
    },
  );

  testWidgets(
    'repeated external action reopens same resource after manual choice',
    (tester) async {
      final selection = ChatPanelSelectionCubit();
      final section = ChatPanelSectionCubit();
      addTearDown(selection.close);
      addTearDown(section.close);
      final initial = ChatPanelSelection(conversation: conversation('first'));
      await tester.pumpWidget(
        _Harness(
          selection: selection,
          section: section,
          initial: initial,
          token: Object(),
        ),
      );
      selection.select(conversation('second'));
      await tester.pump();
      expect(find.text('second.docx'), findsOneWidget);
      await tester.pumpWidget(
        _Harness(
          selection: selection,
          section: section,
          initial: initial,
          token: Object(),
        ),
      );
      await tester.pump();
      expect(find.text('first.docx'), findsOneWidget);
    },
  );

  testWidgets(
    'ID intent shows already selected conversation from compact list',
    (tester) async {
      final selection = ChatPanelSelectionCubit();
      final section = ChatPanelSectionCubit();
      addTearDown(selection.close);
      addTearDown(section.close);
      selection.select(conversation('first'), role: 'Observer');
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: selection),
              BlocProvider.value(value: section),
            ],
            child: const ChatPanelOpenIntentSync(
              initialConversationId: 'first',
              child: Text('panel'),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(section.state.showList, isFalse);
      expect(selection.state?.role, 'Observer');
    },
  );

  test(
    'late pending restore cannot override explicit choice or clear',
    () async {
      final cubit = ChatPanelSelectionCubit(initialConversationId: 'first');
      cubit.select(conversation('second'));
      cubit.clear();
      cubit.restoreFrom([conversation('first')]);
      expect(cubit.state, isNull);
      cubit.requestConversation('first');
      cubit.restoreFrom([conversation('first')], roles: {'first': 'Observer'});
      expect(cubit.state?.role, 'Observer');
      expect(cubit.state?.canModerate, isFalse);
      await cubit.close();
    },
  );
}

class _Harness extends StatelessWidget {
  const _Harness({
    required this.selection,
    required this.section,
    required this.initial,
    this.token,
  });
  final ChatPanelSelectionCubit selection;
  final ChatPanelSectionCubit section;
  final ChatPanelSelection initial;
  final Object? token;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: selection),
        BlocProvider.value(value: section),
      ],
      child: ChatPanelOpenIntentSync(
        intentToken: token,
        initialSelection: initial,
        initialConversationId: initial.conversation.id,
        child: BlocBuilder<ChatPanelSelectionCubit, ChatPanelSelection?>(
          builder: (_, state) => Text(state?.conversation.name ?? 'none'),
        ),
      ),
    ),
  );
}
