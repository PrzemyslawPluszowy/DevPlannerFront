import 'dart:async';

import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_queue.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatMessageComposer keyboard', () {
    testWidgets('plain Enter wysyła dokładnie raz', (tester) async {
      final sent = <ChatComposerDraft>[];
      final richController = quill.QuillController.basic();
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(sent, richController: richController),
      );
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Jedna wiadomość');
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(sent, hasLength(1));
      expect(sent.single.text, 'Jedna wiadomość');
    });

    testWidgets('Shift+Enter nie wysyła i pozostawia nową linię', (
      tester,
    ) async {
      final sent = <ChatComposerDraft>[];
      await tester.pumpWidget(_ComposerWidgetFixture.app(sent));
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Pierwsza');
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();

      expect(sent, isEmpty);
      expect(find.text('Pierwsza\n'), findsOneWidget);
    });

    testWidgets('aktywna kompozycja IME nie wysyła draftu', (tester) async {
      final sent = <ChatComposerDraft>[];
      await tester.pumpWidget(_ComposerWidgetFixture.app(sent));
      await tester.tap(find.byType(TextField));
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'ka',
          selection: TextSelection.collapsed(offset: 2),
          composing: TextRange(start: 0, end: 2),
        ),
      );
      await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(sent, isEmpty);
    });

    testWidgets('Quill wysyła pełny Delta obok tekstowego fallbacku', (
      tester,
    ) async {
      final sent = <ChatComposerDraft>[];
      final richController = quill.QuillController.basic();
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(sent, richController: richController),
      );
      await tester.tap(find.text('Rich text'));
      await tester.pumpAndSettle();
      final editor = find.byType(quill.QuillEditor);
      expect(editor, findsOneWidget);
      richController.replaceText(
        0,
        0,
        'Bogata treść',
        const TextSelection.collapsed(offset: 13),
      );
      await tester.pump();
      await tester.tap(find.byTooltip('Send message'));
      await tester.pump();

      expect(sent, hasLength(1));
      expect(sent.single.text, 'Bogata treść');
      expect(sent.single.deltaJson, contains('Bogata treść'));
    });

    testWidgets('detach 401/403 automatycznie czyści aktywny draft', (
      tester,
    ) async {
      final repository = _MemoryDraftRepository();
      final states = StreamController<ChatConversationState>();
      await repository.save(
        userId: 'user-1',
        conversationId: 'conversation-1',
        draft: const ChatComposerDraft(text: 'Prywatny draft'),
      );
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(
          <ChatComposerDraft>[],
          repository: repository,
          conversationStates: states.stream,
        ),
      );
      await tester.pump();
      expect(find.text('Prywatny draft'), findsOneWidget);

      states.add(const ChatConversationDetached('Brak dostępu.'));
      await tester.pump();
      await tester.pump();

      expect(repository.value, isNull);
      await states.close();
    });

    testWidgets('synchroniczny revoke przed unmount nie traci clear', (
      tester,
    ) async {
      final repository = _MemoryDraftRepository();
      final revoked = ValueNotifier(false);
      await repository.save(
        userId: 'user-1',
        conversationId: 'conversation-1',
        draft: const ChatComposerDraft(text: 'Panelowy draft'),
      );
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(
          <ChatComposerDraft>[],
          repository: repository,
          accessRevocation: revoked,
        ),
      );
      await tester.pump();

      revoked.value = true;
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      expect(repository.value, isNull);
      revoked.dispose();
    });

    testWidgets('nie zwalnia QuillController należącego do hosta', (
      tester,
    ) async {
      final controller = quill.QuillController.basic();
      final revoked = ValueNotifier(false);
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(
          <ChatComposerDraft>[],
          richController: controller,
          accessRevocation: revoked,
        ),
      );

      revoked.value = true;
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      controller.replaceText(
        0,
        0,
        'Nadal należy do hosta',
        const TextSelection.collapsed(offset: 20),
      );

      expect(controller.document.toPlainText(), contains('Nadal należy'));
      controller.dispose();
      revoked.dispose();
    });

    testWidgets('potwierdzona dostawa konsumuje sesję composera tylko raz', (
      tester,
    ) async {
      final confirmations = StreamController<ChatMessageDeliveryConfirmation>();
      final uploadPort = _FakeAttachmentUploadPort();
      ChatAttachmentComposerCoordinatorCubit? coordinator;
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(
          <ChatComposerDraft>[],
          attachmentUploadPort: uploadPort,
          deliveryConfirmations: confirmations.stream,
          onSubmit: (_) => 'client-1',
          onAttachmentCoordinatorCreated: (value) => coordinator = value,
        ),
      );
      final owner = coordinator!;
      owner.selectInputs([
        StorageUploadInput(
          name: 'proof.txt',
          size: 1,
          bytes: Uint8List.fromList([1]),
        ),
      ]);
      await owner.prepare('conversation-1');
      await tester.enterText(find.byType(TextField), 'Wiadomość z plikiem');
      await tester.tap(find.byTooltip('Send message'));
      await tester.pump();

      confirmations.add(
        ChatMessageDeliveryConfirmation(
          clientMessageId: 'client-1',
          attachmentFileIds: const ['file-1'],
        ),
      );
      confirmations.add(
        ChatMessageDeliveryConfirmation(
          clientMessageId: 'client-1',
          attachmentFileIds: const ['file-1'],
        ),
      );
      await tester.pump();

      expect(owner.state, isA<ChatAttachmentComposerCoordinatorIdle>());
      expect(uploadPort.cancelledSessions, isEmpty);
      await confirmations.close();
    });

    testWidgets('detach anuluje przygotowaną sesję composera', (tester) async {
      final states = StreamController<ChatConversationState>();
      final uploadPort = _FakeAttachmentUploadPort();
      ChatAttachmentComposerCoordinatorCubit? coordinator;
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(
          <ChatComposerDraft>[],
          attachmentUploadPort: uploadPort,
          conversationStates: states.stream,
          onAttachmentCoordinatorCreated: (value) => coordinator = value,
        ),
      );
      final owner = coordinator!;
      owner.selectInputs([
        StorageUploadInput(
          name: 'proof.txt',
          size: 1,
          bytes: Uint8List.fromList([1]),
        ),
      ]);
      await owner.prepare('conversation-1');

      states.add(const ChatConversationDetached('Brak dostępu.'));
      await tester.pump();
      await tester.pump();

      expect(uploadPort.cancelledSessions, ['session-1']);
      expect(owner.state, isA<ChatAttachmentComposerCoordinatorIdle>());
      await states.close();
    });

    testWidgets('picker przekazuje neutralny input i przygotowuje ID', (
      tester,
    ) async {
      final picker = _FakeFilePicker([_input('picked.txt')]);
      final uploadPort = _FakeAttachmentUploadPort();
      ChatAttachmentComposerCoordinatorCubit? coordinator;
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(
          <ChatComposerDraft>[],
          filePickerPort: picker,
          attachmentUploadPort: uploadPort,
          onAttachmentCoordinatorCreated: (value) => coordinator = value,
        ),
      );
      await tester.tap(find.text('Add files'));
      await tester.pumpAndSettle();
      expect(picker.calls, 1);
      expect(coordinator!.state, isA<ChatAttachmentComposerCoordinatorReady>());
    });

    testWidgets('remove cancels ready session and awaiting locks next picker', (
      tester,
    ) async {
      final picker = _FakeFilePicker([_input('next.txt')]);
      final uploadPort = _FakeAttachmentUploadPort();
      ChatAttachmentComposerCoordinatorCubit? coordinator;
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(
          <ChatComposerDraft>[],
          filePickerPort: picker,
          attachmentUploadPort: uploadPort,
          onAttachmentCoordinatorCreated: (value) => coordinator = value,
        ),
      );
      final owner = coordinator!;
      owner.selectInputs([_input('first.txt')]);
      await owner.prepare('conversation-1');
      await owner.remove(
        'conversation-1',
        owner.selection.attachments.single.localId,
      );
      expect(uploadPort.cancelledSessions, contains('session-1'));
      owner.selectInputs([_input('locked.txt')]);
      await owner.prepare('conversation-1');
      owner.registerSubmittedMessage(
        clientMessageId: 'c1',
        attachmentIds: const ['file-1'],
      );
      await tester.tap(find.text('Add files'));
      await tester.pump();
      expect(picker.calls, 0);
    });

    testWidgets('failed attachment blocks send even with text', (tester) async {
      final sent = <ChatComposerDraft>[];
      final uploadPort = _FakeAttachmentUploadPort(fail: true);
      ChatAttachmentComposerCoordinatorCubit? coordinator;
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(
          sent,
          attachmentUploadPort: uploadPort,
          onAttachmentCoordinatorCreated: (value) => coordinator = value,
        ),
      );
      coordinator!.selectInputs([_input('bad.txt')]);
      await coordinator!.prepare('conversation-1');
      await tester.enterText(find.byType(TextField), 'tekst');
      await tester.tap(find.byTooltip('Send message'));
      expect(sent, isEmpty);
    });

    testWidgets('preparing attachment blocks send even with text', (
      tester,
    ) async {
      final sent = <ChatComposerDraft>[];
      final uploadPort = _FakeAttachmentUploadPort(pending: true);
      ChatAttachmentComposerCoordinatorCubit? coordinator;
      await tester.pumpWidget(
        _ComposerWidgetFixture.app(
          sent,
          attachmentUploadPort: uploadPort,
          onAttachmentCoordinatorCreated: (value) => coordinator = value,
        ),
      );
      coordinator!.selectInputs([_input('waiting.txt')]);
      unawaited(coordinator!.prepare('conversation-1'));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'tekst');
      await tester.tap(find.byTooltip('Send message'));
      expect(sent, isEmpty);
      uploadPort.release();
    });
  });
}

abstract final class _ComposerWidgetFixture {
  static Widget app(
    List<ChatComposerDraft> sent, {
    quill.QuillController? richController,
    ChatDraftRepository? repository,
    Stream<ChatConversationState>? conversationStates,
    Stream<ChatMessageDeliveryConfirmation>? deliveryConfirmations,
    ChatAttachmentUploadPort? attachmentUploadPort,
    FilePickerPort? filePickerPort,
    ValueChanged<ChatAttachmentComposerCoordinatorCubit>?
    onAttachmentCoordinatorCreated,
    String? Function(ChatComposerDraft)? onSubmit,
    ValueListenable<bool>? accessRevocation,
  }) => MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: ChatMessageComposer(
        draftRepository: repository ?? _NoopDraftRepository(),
        userId: 'user-1',
        conversationId: 'conversation-1',
        richController: richController,
        conversationStates: conversationStates,
        deliveryConfirmations: deliveryConfirmations,
        attachmentUploadPort: attachmentUploadPort,
        filePickerPort: filePickerPort,
        onAttachmentCoordinatorCreated: onAttachmentCoordinatorCreated,
        accessRevocation: accessRevocation,
        onSubmit:
            onSubmit ??
            (draft) {
              sent.add(draft);
              return null;
            },
      ),
    ),
  );
}

StorageUploadInput _input(String name) => StorageUploadInput(
  name: name,
  size: 1,
  bytes: Uint8List.fromList([1]),
);

final class _FakeFilePicker implements FilePickerPort {
  _FakeFilePicker(this.value);
  final List<StorageUploadInput> value;
  int calls = 0;
  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  }) async {
    calls++;
    return value;
  }
}

final class _FakeAttachmentUploadPort implements ChatAttachmentUploadPort {
  _FakeAttachmentUploadPort({this.fail = false, this.pending = false});
  final bool fail;
  final bool pending;
  final Completer<void> _gate = Completer<void>();
  void release() {
    if (!_gate.isCompleted) _gate.complete();
  }

  final cancelledSessions = <String>[];

  @override
  Future<void> cancelSession(String conversationId, String sessionId) async {
    cancelledSessions.add(sessionId);
  }

  @override
  Future<void> complete(String storageFileId) async {}

  @override
  Future<ChatAttachmentUploadSession> createSession(
    String conversationId,
  ) async => const ChatAttachmentUploadSession('session-1');

  @override
  Future<ChatAttachmentTicket> createTicket({
    required String sessionId,
    required StorageUploadInput input,
  }) async => const ChatAttachmentTicket('file-1');

  @override
  Future<ChatAttachmentRemoteStatus> status(String storageFileId) async {
    if (pending) await _gate.future;
    return fail
        ? ChatAttachmentRemoteStatus.failed
        : ChatAttachmentRemoteStatus.cleanReady;
  }

  @override
  Future<void> upload(
    ChatAttachmentTicket ticket,
    StorageUploadInput input,
  ) async {}
}

final class _MemoryDraftRepository implements ChatDraftRepository {
  ChatComposerDraft? value;

  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async => value = null;
  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) async => value;
  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async => value = draft;
}

final class _NoopDraftRepository implements ChatDraftRepository {
  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async {}
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
}
